-- ============================================
-- KING MORRIS MENU UI - COMPLETE VERSION
-- Auto AFK & Map Selector for Roblox
-- Version: 5.0 Ultimate
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

pcall(function() if gui:FindFirstChild("KingMorrisMenuUI") then gui.KingMorrisMenuUI:Destroy() end end)
pcall(function() if CoreGui:FindFirstChild("KingMorrisAutoUI") then CoreGui.KingMorrisAutoUI:Destroy() end end)

local CONFIG = {
    UNIVERSAL_SCRIPT = "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua",
    PRIVATE_SERVER_SCRIPT = "https://pastefy.app/Si31pCY9/raw",
    MAIN_COLOR = Color3.fromRGB(200, 50, 100),
    DARK_PINK = Color3.fromRGB(150, 30, 80),
    LIGHT_PINK = Color3.fromRGB(255, 120, 170),
    BG_COLOR = Color3.fromRGB(40, 15, 30),
    AUTO_START = true,
    AUTO_RESPAWN = true,
    STOP_DELAY = 30,
    RESPAWN_DELAY = 20,
    POST_RESPAWN_DELAY = 10,
    MOVE_THRESHOLD = 0.1,
    RETRY_INTERVAL = 15,
    COOLDOWN_AFTER_RESPAWN = 50,
    MAX_BUTTON_WAIT = 60,
}

local MAP_LIST = {
    {text = "Mount Atin", mapKey = "m1"}, {text = "Mount Yahayuk", mapKey = "m2"}, {text = "Mount Kalista", mapKey = "m12"},
    {text = "Mount Daun", mapKey = "m3"}, {text = "Mount Arunika", mapKey = "m4"}, {text = "Mount Lembayana", mapKey = "m6"},
    {text = "Mount YNTKTS", mapKey = "m8"}, {text = "Mount Sakahayang", mapKey = "m7"}, {text = "Mount Hana", mapKey = "m9"},
    {text = "Mount Stecu", mapKey = "m10"}, {text = "Mount Ckptw", mapKey = "m11"}, {text = "Mount Ravika", mapKey = "m5"},
    {text = "Antartika Normal", mapKey = "m14"}, {text = "Mount Salvatore", mapKey = "m15"}, {text = "Mount Kirey", mapKey = "m16"},
    {text = "Mount Pargoy", mapKey = "m17"}, {text = "Ekspedisi Kaliya", mapKey = "m13"}, {text = "Mount Forever", mapKey = "m18"},
    {text = "Mount Mono", mapKey = "m19"}, {text = "Mount Yareuu", mapKey = "m20"}, {text = "Mount Serenity", mapKey = "m21"},
    {text = "Mount Pedaunan", mapKey = "m22"}, {text = "Mount Pengangguran", mapKey = "m23"}, {text = "Mount Bingung", mapKey = "m24"},
    {text = "Mount Kawaii", mapKey = "m25"}, {text = "Mount Runia", mapKey = "m26"}, {text = "Mount Swiss", mapKey = "m27"},
    {text = "Mount Aneh", mapKey = "m28"}, {text = "Mount Lirae", mapKey = "m29"},
}

_G.KingMorrisAutoAFKEnabled = false
_G.KingMorrisPrivateServerEnabled = false
_G.KingMorrisAutoAFKRunning = false
_G.KingMorrisToggleButton = nil

local function tween(obj, props, dur)
    if not obj or not obj.Parent then return end
    pcall(function() TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end)
end

local AutoAFKSystem = {
    running = false, hrp = nil, toggleBtn = nil, lastPos = nil, stillTime = 0, totalDist = 0,
    lastAutoStart = 0, justRestarted = false, afterRespawn = false,
}

function AutoAFKSystem:clickButton(button)
    if not button or not button.Parent then warn("[King Morris Auto AFK] ✗ Button tidak valid") return false end
    print("[King Morris Auto AFK] 🔄 Mencoba klik button...")
    local success, method = false, "none"
    
    pcall(function()
        for _, c in pairs(getconnections(button.MouseButton1Click)) do
            if c.Function then
                c.Function()
                success, method = true, "getconnections"
                break
            end
        end
    end)
    
    if not success then
        pcall(function()
            firesignal(button.MouseButton1Click)
            success, method = true, "firesignal"
        end)
    end
    
    if not success then
        pcall(function()
            for _, c in pairs(getconnections(button.MouseButton1Click)) do
                c:Fire()
                success, method = true, "Fire"
                break
            end
        end)
    end
    
    if not success then
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            local pos, size = button.AbsolutePosition, button.AbsoluteSize
            local x, y = pos.X + size.X/2, pos.Y + size.Y/2
            vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.05)
            vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
            success, method = true, "VirtualInput"
        end)
    end
    
    if not success then
        pcall(function()
            for _, c in pairs(getconnections(button.Activated)) do
                if c.Function then
                    c.Function()
                    success, method = true, "Activated"
                    break
                end
            end
        end)
    end
    
    if success then
        print("[King Morris Auto AFK] ✓ Button clicked! Method: " .. method)
    else
        warn("[King Morris Auto AFK] ✗ All click methods failed!")
    end
    
    return success
end

function AutoAFKSystem:forceToggleRoute(shouldStart)
    print("[King Morris Auto AFK] 🔧 Force toggle:", shouldStart and "START" or "STOP")
    
    local success = pcall(function()
        if _G.KingMorrisToggleFunction then
            local currentlyRunning = false
            if _G.KingMorrisIsRunning then
                currentlyRunning = _G.KingMorrisIsRunning()
            end
            
            if shouldStart and not currentlyRunning then
                _G.KingMorrisToggleFunction()
                print("[King Morris Auto AFK] ✓ Started via global function")
                return true
            elseif not shouldStart and currentlyRunning then
                _G.KingMorrisToggleFunction()
                print("[King Morris Auto AFK] ✓ Stopped via global function")
                return true
            else
                print("[King Morris Auto AFK] ⚠️ Already in desired state")
                return true
            end
        end
    end)
    
    if success then return true end
    
    if self.toggleBtn and self.toggleBtn.Parent then
        return self:clickButton(self.toggleBtn)
    end
    
    return false
end

function AutoAFKSystem:getButtonText()
    if not self.toggleBtn or not self.toggleBtn.Parent then return "" end
    local ok, text = pcall(function() return self.toggleBtn.Text:lower() end)
    return ok and text or ""
end

function AutoAFKSystem:getHRP()
    local ok, result = pcall(function()
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart", 10)
    end)
    return ok and result or nil
end

function AutoAFKSystem:setStatus(text, color)
    pcall(function()
        if _G.KingMorrisStatus then
            _G.KingMorrisStatus(text, color)
        end
    end)
end

function AutoAFKSystem:waitForButton()
    print("[King Morris Auto AFK] 🔍 Waiting for button from universal.lua...")
    local startTime = tick()
    
    while not _G.KingMorrisToggleButton and (tick() - startTime) < CONFIG.MAX_BUTTON_WAIT and self.running do
        task.wait(0.5)
        local elapsed = math.floor(tick() - startTime)
        if elapsed % 10 == 0 and elapsed > 0 then
            print("[King Morris Auto AFK] Still waiting... (" .. elapsed .. "s)")
            self:setStatus("🟡 Waiting Button " .. elapsed .. "s", Color3.fromRGB(255,255,100))
        end
    end
    
    if _G.KingMorrisToggleButton and _G.KingMorrisToggleButton.Parent then
        self.toggleBtn = _G.KingMorrisToggleButton
        print("[King Morris Auto AFK] ✓ Button found!")
        return true
    else
        warn("[King Morris Auto AFK] ✗ Button timeout after " .. CONFIG.MAX_BUTTON_WAIT .. "s")
        return false
    end
end

function AutoAFKSystem:respawnCharacter()
    print("[King Morris Auto AFK] 🔄 Initiating respawn...")
    self:setStatus("🔴 Respawning...", Color3.fromRGB(255,100,100))
    
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)
    
    local newChar, timeout, elapsed = nil, 30, 0
    local conn = player.CharacterAdded:Connect(function(c) newChar = c end)
    
    while not newChar and elapsed < timeout do
        task.wait(0.5)
        elapsed = elapsed + 0.5
    end
    
    pcall(function() conn:Disconnect() end)
    
    if not newChar then
        warn("[King Morris Auto AFK] ✗ Respawn timeout")
        self.afterRespawn = false
        return
    end
    
    local newHRP, attempts = nil, 0
    while attempts < 10 and not newHRP do
        task.wait(0.5)
        attempts = attempts + 1
        pcall(function() newHRP = newChar:FindFirstChild("HumanoidRootPart") end)
    end
    
    if not newHRP then
        warn("[King Morris Auto AFK] ✗ Failed to get HRP")
        self.afterRespawn = false
        return
    end
    
    task.wait(CONFIG.POST_RESPAWN_DELAY)
    self.hrp = newHRP
    self.lastPos = self.hrp.Position
    self.stillTime, self.totalDist = 0, 0
    
    print("[King Morris Auto AFK] 🔍 Waiting for button...")
    self:setStatus("🟡 Waiting Button...", Color3.fromRGB(255,255,100))
    
    if not self:waitForButton() then
        warn("[King Morris Auto AFK] ✗ Button lost after respawn!")
        self:setStatus("❌ Button Lost", Color3.fromRGB(255,100,100))
        self.afterRespawn = false
        return
    end
    
    task.wait(2)
    self.afterRespawn = true
    
    local text = self:getButtonText()
    print("[King Morris Auto AFK] Button state:", text or "empty")
    
    if text and text:find("stop") then
        print("[King Morris Auto AFK] ⏸ Stopping before restart...")
        self:forceToggleRoute(false)
        task.wait(2)
    end
    
    if not self.toggleBtn or not self.toggleBtn.Parent then
        warn("[King Morris Auto AFK] ✗ Button lost")
        if not self:waitForButton() then
            self.afterRespawn = false
            return
        end
    end
    
    task.wait(1)
    text = self:getButtonText()
    
    if text and text:find("start") then
        print("[King Morris Auto AFK] ▶ Starting route...")
        if self:forceToggleRoute(true) then
            task.wait(2)
            self:setStatus("🟢 Auto Start Success", Color3.fromRGB(100,255,100))
            print("[King Morris Auto AFK] ✓ Route started!")
        else
            warn("[King Morris Auto AFK] ✗ Failed to start")
            self:setStatus("⚠️ Start Failed", Color3.fromRGB(255,150,100))
        end
    else
        warn("[King Morris Auto AFK] ✗ Wrong state:", text or "nil")
        self:setStatus("⚠️ Wrong State", Color3.fromRGB(255,200,100))
    end
    
    task.spawn(function()
        task.wait(CONFIG.COOLDOWN_AFTER_RESPAWN)
        self.afterRespawn = false
        print("[King Morris Auto AFK] ✓ Cooldown finished")
    end)
end

function AutoAFKSystem:createStatusUI()
    pcall(function()
        if CoreGui:FindFirstChild("KingMorrisAutoUI") then
            CoreGui.KingMorrisAutoUI:Destroy()
        end
    end)
    
    local statusGui = Instance.new("ScreenGui")
    statusGui.Name = "KingMorrisAutoUI"
    statusGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 65)
    frame.Position = UDim2.new(1, -260, 1, -110)
    frame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    frame.Parent = statusGui

    local glow = Instance.new("UIStroke", frame)
    glow.Color = Color3.fromRGB(200, 50, 100)
    glow.Thickness = 2
    glow.Transparency = 0.4

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0.45, 0)
    title.BackgroundTransparency = 1
    title.Text = "👑 King Morris Auto AFK"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 120, 170)
    title.TextScaled = true

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size = UDim2.new(1, 0, 0.55, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.45, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextScaled = true
    statusLabel.Text = "🟡 Initializing..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

    local hue = 0
    local conn = RunService.RenderStepped:Connect(function()
        if not self.running or not statusGui.Parent then
            pcall(function() conn:Disconnect() end)
            return
        end
        hue = (hue + 0.4) % 360
        pcall(function() glow.Color = Color3.fromHSV(hue / 360, 0.8, 1) end)
    end)

    _G.KingMorrisStatus = function(text, color)
        pcall(function()
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = text
                statusLabel.TextColor3 = color
            end
        end)
    end
    
    return statusGui
end

function AutoAFKSystem:start()
    if _G.KingMorrisAutoAFKRunning then
        print("[King Morris Auto AFK] ⚠️ Already running!")
        return
    end
    
    _G.KingMorrisAutoAFKRunning = true
    self.running = true
    
    print("[King Morris Auto AFK] ▶ Starting system...")
    
    self:createStatusUI()
    self:setStatus("🟡 Searching...", Color3.fromRGB(255,255,100))
    
    self.hrp = self:getHRP()
    if not self.hrp then
        warn("[King Morris Auto AFK] ✗ Failed to get HRP")
        self:setStatus("❌ HRP Not Found", Color3.fromRGB(255,100,100))
        self.running = false
        _G.KingMorrisAutoAFKRunning = false
        return
    end
    
    if not self:waitForButton() then
        warn("[King Morris Auto AFK] ✗ Button not found")
        self:setStatus("❌ Button Not Found", Color3.fromRGB(255,100,100))
        self.running = false
        _G.KingMorrisAutoAFKRunning = false
        return
    end
    
    self.lastPos = self.hrp.Position
    self:setStatus("🟢 Ready to Monitor", Color3.fromRGB(100,255,100))
    print("[King Morris Auto AFK] ✓ System ready!")
    
    task.spawn(function()
        while self.running and _G.KingMorrisAutoAFKRunning do
            pcall(function()
                if not self.hrp or not self.hrp.Parent then
                    self.hrp = self:getHRP()
                    if self.hrp then
                        self.lastPos = self.hrp.Position
                        self.stillTime, self.totalDist = 0, 0
                    end
                    return
                end
                
                if not self.toggleBtn or not self.toggleBtn.Parent then
                    if _G.KingMorrisToggleButton and _G.KingMorrisToggleButton.Parent then
                        self.toggleBtn = _G.KingMorrisToggleButton
                        print("[King Morris Auto AFK] ✓ Button restored from global")
                    else
                        warn("[King Morris Auto AFK] Button lost, searching...")
                        self:waitForButton()
                        if not self.toggleBtn then
                            self:setStatus("❌ Button Lost", Color3.fromRGB(255,100,100))
                            self.stillTime, self.totalDist = 0, 0
                            return
                        end
                    end
                end

                local currentPos = self.hrp.Position
                local dist = (currentPos - self.lastPos).Magnitude
                self.totalDist = self.totalDist + dist
                self.lastPos = currentPos

                if dist < CONFIG.MOVE_THRESHOLD then
                    self.stillTime = self.stillTime + 1
                else
                    self.stillTime, self.totalDist = 0, 0
                    self.justRestarted = false
                end

                if self.afterRespawn then
                    self.stillTime, self.totalDist = 0, 0
                    return
                end

                if self.stillTime == 0 then
                    self:setStatus("🟢 Running", Color3.fromRGB(100,255,100))
                elseif self.stillTime < CONFIG.RESPAWN_DELAY then
                    self:setStatus("🟡 Idle " .. self.stillTime .. "s", Color3.fromRGB(255,255,150))
                end

                if CONFIG.AUTO_RESPAWN and self.stillTime >= CONFIG.RESPAWN_DELAY then
                    print("[King Morris Auto AFK] ⚠️ Triggering respawn")
                    self:respawnCharacter()
                    self.stillTime, self.totalDist = 0, 0
                    self.justRestarted = false
                    return
                end

                local now = tick()
                if CONFIG.AUTO_START and self.stillTime >= CONFIG.STOP_DELAY and 
                   self.totalDist < 0.5 and (now - self.lastAutoStart > CONFIG.RETRY_INTERVAL) and 
                   not self.justRestarted then
                    
                    print("[King Morris Auto AFK] 🔄 Attempting restart...")
                    self:setStatus("🔵 Restarting...", Color3.fromRGB(100,150,255))

                    local text = self:getButtonText()
                    if text and text:find("stop") then
                        self:forceToggleRoute(false)
                        task.wait(1)
                    end
                    
                    text = self:getButtonText()
                    if text and text:find("start") then
                        if self:forceToggleRoute(true) then
                            self.lastAutoStart = now
                            self.justRestarted = true
                            self:setStatus("🟢 Running", Color3.fromRGB(100,255,100))
                        end
                    end
                    
                    self.stillTime, self.totalDist = 0, 0
                end
            end)
            
            task.wait(1)
        end
        
        print("[King Morris Auto AFK] ⏹ Loop ended")
    end)
end

function AutoAFKSystem:stop()
    self.running = false
    _G.KingMorrisAutoAFKRunning = false
    
    pcall(function()
        if CoreGui:FindFirstChild("KingMorrisAutoUI") then
            CoreGui.KingMorrisAutoUI:Destroy()
        end
    end)
    
    print("[King Morris Auto AFK] ⏹ System stopped")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KingMorrisMenuUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gui

local Phone = Instance.new("Frame")
Phone.Name = "Phone"
Phone.Parent = ScreenGui
Phone.Size = UDim2.new(0, 200, 0, 400)
Phone.Position = UDim2.new(0.05, 0, 0.2, 0)
Phone.BackgroundColor3 = CONFIG.BG_COLOR
Phone.BackgroundTransparency = 0.2
Phone.Active = true
Phone.Draggable = true
Instance.new("UICorner", Phone).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", Phone)
stroke.Thickness = 3
stroke.Color = CONFIG.MAIN_COLOR
stroke.Transparency = 0.3

local Title = Instance.new("TextLabel")
Title.Parent = Phone
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = CONFIG.LIGHT_PINK
Title.Text = "👑 KING MORRIS"
Title.TextXAlignment = Enum.TextXAlignment.Center

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Phone
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundColor3 = Color3.fromRGB(30, 10, 25)
Scroll.BackgroundTransparency = 0.4
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = CONFIG.MAIN_COLOR
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 12)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local autoAfkBtn = Instance.new("TextButton")
autoAfkBtn.Name = "AutoAFKBtn"
autoAfkBtn.Parent = Scroll
autoAfkBtn.Size = UDim2.new(1, -12, 0, 40)
autoAfkBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
autoAfkBtn.BackgroundTransparency = 0.3
autoAfkBtn.BorderSizePixel = 0
autoAfkBtn.Font = Enum.Font.GothamBold
autoAfkBtn.TextSize = 14
autoAfkBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
autoAfkBtn.Text = "⚙️ AUTO AFK"
autoAfkBtn.AutoButtonColor = false
autoAfkBtn.LayoutOrder = 0

local afkCorner = Instance.new("UICorner", autoAfkBtn)
afkCorner.CornerRadius = UDim.new(0, 10)

local afkStroke = Instance.new("UIStroke", autoAfkBtn)
afkStroke.Color = Color3.fromRGB(150, 100, 255)
afkStroke.Thickness = 2
afkStroke.Transparency = 0.5

autoAfkBtn.MouseEnter:Connect(function() 
    tween(afkStroke, {Transparency = 0.1, Thickness = 3}, 0.15)
    tween(autoAfkBtn, {BackgroundTransparency = 0.1}, 0.2)
end)

autoAfkBtn.MouseLeave:Connect(function() 
    if not _G.KingMorrisAutoAFKEnabled then
        tween(afkStroke, {Transparency = 0.5, Thickness = 2}, 0.2)
        tween(autoAfkBtn, {BackgroundTransparency = 0.3}, 0.25)
    end
end)

autoAfkBtn.MouseButton1Click:Connect(function()
    if _G.KingMorrisAutoAFKEnabled then
        _G.KingMorrisAutoAFKEnabled = false
        AutoAFKSystem:stop()
        autoAfkBtn.Text = "⚙️ AUTO AFK"
        autoAfkBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        autoAfkBtn.BackgroundTransparency = 0.3
        afkStroke.Color = Color3.fromRGB(150, 100, 255)
        afkStroke.Transparency = 0.5
        print("[King Morris] ⏹ Auto AFK DISABLED")
    else
        _G.KingMorrisAutoAFKEnabled = true
        autoAfkBtn.Text = "✅ AUTO AFK ENABLED"
        autoAfkBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        autoAfkBtn.BackgroundTransparency = 0
        afkStroke.Color = Color3.fromRGB(100, 255, 150)
        afkStroke.Transparency = 0
        print("[King Morris] ✓ Auto AFK ENABLED")
    end
end)

local privateServerBtn = Instance.new("TextButton")
privateServerBtn.Name = "PrivateServerBtn"
privateServerBtn.Parent = Scroll
privateServerBtn.Size = UDim2.new(1, -12, 0, 40)
privateServerBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
privateServerBtn.BackgroundTransparency = 0.3
privateServerBtn.BorderSizePixel = 0
privateServerBtn.Font = Enum.Font.GothamBold
privateServerBtn.TextSize = 14
privateServerBtn.TextColor3 = Color3.fromRGB(255, 255, 200)
privateServerBtn.Text = "🔐 PRIVATE SERVER"
privateServerBtn.AutoButtonColor = false
privateServerBtn.LayoutOrder = 1

local psCorner = Instance.new("UICorner", privateServerBtn)
psCorner.CornerRadius = UDim.new(0, 10)

local psStroke = Instance.new("UIStroke", privateServerBtn)
psStroke.Color = Color3.fromRGB(255, 180, 50)
psStroke.Thickness = 2
psStroke.Transparency = 0.5

privateServerBtn.MouseEnter:Connect(function() 
    tween(psStroke, {Transparency = 0.1, Thickness = 3}, 0.15)
    tween(privateServerBtn, {BackgroundTransparency = 0.1}, 0.2)
end)

privateServerBtn.MouseLeave:Connect(function() 
    if not _G.KingMorrisPrivateServerEnabled then
        tween(psStroke, {Transparency = 0.5, Thickness = 2}, 0.2)
        tween(privateServerBtn, {BackgroundTransparency = 0.3}, 0.25)
    end
end)

privateServerBtn.MouseButton1Click:Connect(function()
    if _G.KingMorrisPrivateServerEnabled then
        privateServerBtn.Text = "⚠️ ALREADY RUNNING"
        task.wait(1)
        privateServerBtn.Text = "✅ PRIVATE SERVER ON"
    else
        privateServerBtn.Text = "⏳ Loading..."
        task.spawn(function()
            local ok = pcall(function()
                loadstring(game:HttpGet(CONFIG.PRIVATE_SERVER_SCRIPT))()
            end)
            if ok then
                _G.KingMorrisPrivateServerEnabled = true
                privateServerBtn.Text = "✅ PRIVATE SERVER ON"
                privateServerBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                privateServerBtn.BackgroundTransparency = 0
                psStroke.Color = Color3.fromRGB(100, 255, 150)
                psStroke.Transparency = 0
                print("[King Morris] ✓ Private Server loaded!")
            else
                privateServerBtn.Text = "❌ ERROR"
                task.wait(2)
                privateServerBtn.Text = "🔐 PRIVATE SERVER"
            end
        end)
    end
end)

for i, info in ipairs(MAP_LIST) do
    local b = Instance.new("TextButton")
    b.Name = "Btn" .. i
    b.Parent = Scroll
    b.Size = UDim2.new(1, -12, 0, 35)
    b.BackgroundColor3 = CONFIG.DARK_PINK
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(255, 200, 220)
    b.Text = info.text
    b.AutoButtonColor = false
    b.LayoutOrder = i + 2
    
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 10)
    
    local s = Instance.new("UIStroke", b)
    s.Color = CONFIG.MAIN_COLOR
    s.Thickness = 2
    s.Transparency = 0.5

    b.MouseEnter:Connect(function() 
        tween(s, {Transparency = 0.1, Thickness = 3}, 0.15)
        tween(b, {BackgroundColor3 = CONFIG.MAIN_COLOR, BackgroundTransparency = 0.1}, 0.2)
    end)
    
    b.MouseLeave:Connect(function() 
        tween(s, {Transparency = 0.5, Thickness = 2}, 0.2)
        tween(b, {BackgroundColor3 = CONFIG.DARK_PINK, BackgroundTransparency = 0.3}, 0.25)
    end)
    
    b.MouseButton1Click:Connect(function()
        local originalText = b.Text
        b.Text = "⏳ Loading..."
        
        _G.KingMorrisSelectedMap = info.mapKey
        
        task.spawn(function()
            local ok, err = pcall(function()
                local code = game:HttpGet(CONFIG.UNIVERSAL_SCRIPT)
                loadstring(code)()
            end)
            
            if ok then
                print("[King Morris] ✓ Successfully loaded: " .. info.text)
                
                if _G.KingMorrisAutoAFKEnabled then
                    print("[King Morris] Auto AFK enabled, waiting for route UI...")
                    task.wait(10)
                    print("[King Morris] Starting Auto AFK monitoring...")
                    AutoAFKSystem:start()
                end
                
                task.wait(0.5)
                if ScreenGui and ScreenGui.Parent then
                    ScreenGui:Destroy()
                end
            else 
                b.Text = "❌ Error"
                warn("[King Morris] Error loading:", err)
                _G.KingMorrisSelectedMap = nil
                task.wait(2)
                b.Text = originalText
            end
        end)
    end)
end

task.wait(0.1)
Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)

print("===========================================")
print("[King Morris] Menu loaded successfully!")
print("[King Morris] Version: 5.0 Ultimate")
print("[King Morris] Features:")
print("  ✓ Auto AFK System with Smart Respawn")
print("  ✓ Private Server Support")
print("  ✓ " .. #MAP_LIST .. " Maps Available")
print("===========================================")

player.AncestryChanged:Connect(function()
    if AutoAFKSystem.running then
        AutoAFKSystem:stop()
    end
    if ScreenGui and ScreenGui.Parent then
        pcall(function() ScreenGui:Destroy() end)
    end
end)
