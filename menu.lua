-- ============================================
-- KING MORRIS MENU UI - FIXED INTEGRATION
-- Auto AFK & Map Selector for Roblox
-- Version: 4.1 Fixed
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Cleanup existing UIs
if gui:FindFirstChild("KingMorrisMenuUI") then 
    gui.KingMorrisMenuUI:Destroy() 
end
if CoreGui:FindFirstChild("WataX_AutoUI") then
    CoreGui.WataX_AutoUI:Destroy()
end

-- ============================================
-- CONFIGURATION
-- ============================================

local CONFIG = {
    -- URLs
    UNIVERSAL_SCRIPT = "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua",
    PRIVATE_SERVER_SCRIPT = "https://pastefy.app/Si31pCY9/raw",
    
    -- Brand Colors
    MAIN_COLOR = Color3.fromRGB(200, 50, 100),
    DARK_PINK = Color3.fromRGB(150, 30, 80),
    LIGHT_PINK = Color3.fromRGB(255, 120, 170),
    BG_COLOR = Color3.fromRGB(40, 15, 30),
    ACCENT_PINK = Color3.fromRGB(255, 100, 150),
    
    -- Auto AFK Settings
    AUTO_START = true,
    AUTO_RESPAWN = true,
    STOP_DELAY = 30,
    RESPAWN_DELAY = 20,
    POST_RESPAWN_DELAY = 8,
    MOVE_THRESHOLD = 0.1,
    RETRY_INTERVAL = 15,
    COOLDOWN_AFTER_RESPAWN = 45,
    MAX_BUTTON_WAIT = 60,
    BUTTON_SEARCH_RETRY = 15,
}

local MAP_LIST = {
    {text = "Mount Atin", mapKey = "m1"},
    {text = "Mount Yahayuk", mapKey = "m2"},
    {text = "Mount Kalista", mapKey = "m12"},
    {text = "Mount Daun", mapKey = "m3"},
    {text = "Mount Arunika", mapKey = "m4"},
    {text = "Mount Lembayana", mapKey = "m6"},
    {text = "Mount YNTKTS", mapKey = "m8"},
    {text = "Mount Sakahayang", mapKey = "m7"},
    {text = "Mount Hana", mapKey = "m9"},
    {text = "Mount Stecu", mapKey = "m10"},
    {text = "Mount Ckptw", mapKey = "m11"},
    {text = "Mount Ravika", mapKey = "m5"},
    {text = "Antartika Normal", mapKey = "m14"},
    {text = "Mount Salvatore", mapKey = "m15"},
    {text = "Mount Kirey", mapKey = "m16"},
    {text = "Mount Pargoy", mapKey = "m17"},
    {text = "Ekspedisi Kaliya", mapKey = "m13"},
    {text = "Mount Forever", mapKey = "m18"},
    {text = "Mount Mono", mapKey = "m19"},
    {text = "Mount Yareuu", mapKey = "m20"},
    {text = "Mount Serenity", mapKey = "m21"},
    {text = "Mount Pedaunan", mapKey = "m22"},
    {text = "Mount Pengangguran", mapKey = "m23"},
    {text = "Mount Bingung", mapKey = "m24"},
    {text = "Mount Kawaii", mapKey = "m25"},
    {text = "Mount Runia", mapKey = "m26"},
    {text = "Mount Swiss", mapKey = "m27"},
    {text = "Mount Aneh", mapKey = "m28"},
    {text = "Mount Lirae", mapKey = "m29"},
}

-- Global State
_G.KingMorrisAutoAFKEnabled = false
_G.KingMorrisPrivateServerEnabled = false
_G.WataXAutoAFKRunning = false
_G.KingMorrisToggleButton = nil

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function tween(obj, props, dur)
    if not obj or not obj.Parent then return end
    TweenService:Create(
        obj, 
        TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        props
    ):Play()
end

-- ============================================
-- AUTO AFK SYSTEM (IMPROVED)
-- ============================================

local AutoAFKSystem = {
    running = false,
    hrp = nil,
    toggleBtn = nil,
    lastPos = nil,
    stillTime = 0,
    totalDist = 0,
    lastAutoStart = 0,
    justRestarted = false,
    afterRespawn = false,
    buttonConnection = nil
}

function AutoAFKSystem:clickButton(button)
    if not button or not button.Parent then 
        warn("[Auto AFK] ✗ Button tidak valid")
        return false
    end
    
    local success = false
    
    -- Method 1: firesignal
    pcall(function()
        if firesignal and button.MouseButton1Click then
            firesignal(button.MouseButton1Click)
            success = true
            print("[Auto AFK] ✓ Clicked (firesignal)")
        end
    end)
    
    -- Method 2: getconnections
    if not success then
        pcall(function()
            local connections = getconnections(button.MouseButton1Click)
            if connections then
                for _, c in ipairs(connections) do
                    if c and type(c) == "table" and c.Function then
                        pcall(function()
                            c.Function()
                            success = true
                        end)
                        if success then
                            print("[Auto AFK] ✓ Clicked (getconnections)")
                            break
                        end
                    end
                end
            end
        end)
    end
    
    -- Method 3: Virtual input
    if not success then
        pcall(function()
            local VirtualInputManager = game:GetService("VirtualInputManager")
            if VirtualInputManager then
                local pos = button.AbsolutePosition
                local size = button.AbsoluteSize
                local centerX = pos.X + (size.X / 2)
                local centerY = pos.Y + (size.Y / 2)
                
                VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
                success = true
                print("[Auto AFK] ✓ Clicked (VirtualInput)")
            end
        end)
    end
    
    return success
end

function AutoAFKSystem:getButtonText()
    if not self.toggleBtn or not self.toggleBtn.Parent then return "" end
    local success, text = pcall(function()
        return self.toggleBtn.Text:lower()
    end)
    return success and text or ""
end

function AutoAFKSystem:getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", 10)
end

function AutoAFKSystem:setStatus(text, color)
    if _G.WataXStatus then
        pcall(function()
            _G.WataXStatus(text, color)
        end)
    end
end

function AutoAFKSystem:waitForButton()
    print("[Auto AFK] 🔍 Menunggu button dari universal.lua...")
    local startTime = tick()
    
    while not _G.KingMorrisToggleButton and (tick() - startTime) < CONFIG.MAX_BUTTON_WAIT and self.running do
        task.wait(0.5)
        
        local elapsed = math.floor(tick() - startTime)
        if elapsed % 10 == 0 then
            print("[Auto AFK] Masih menunggu... (" .. elapsed .. "s)")
            self:setStatus("🟡 Waiting Button " .. elapsed .. "s", Color3.fromRGB(255,255,100))
        end
    end
    
    if _G.KingMorrisToggleButton then
        self.toggleBtn = _G.KingMorrisToggleButton
        print("[Auto AFK] ✓ Button ditemukan!")
        return true
    else
        warn("[Auto AFK] ✗ Button timeout setelah " .. CONFIG.MAX_BUTTON_WAIT .. "s")
        return false
    end
end

function AutoAFKSystem:respawnCharacter()
    print("[Auto AFK] 🔄 Memulai respawn...")
    self:setStatus("🔴 Respawning...", Color3.fromRGB(255,100,100))
    
    -- Respawn character
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)
    
    -- Tunggu karakter baru
    local newChar
    local timeout = 30
    local elapsed = 0
    
    local connection = player.CharacterAdded:Connect(function(char)
        newChar = char
    end)
    
    while not newChar and elapsed < timeout do
        task.wait(0.5)
        elapsed = elapsed + 0.5
    end
    
    connection:Disconnect()
    
    if not newChar then
        warn("[Auto AFK] ✗ Respawn timeout")
        self.afterRespawn = false
        return
    end
    
    -- Dapatkan HRP baru
    local newHRP
    local hrpAttempts = 0
    while hrpAttempts < 10 and not newHRP do
        task.wait(0.5)
        hrpAttempts = hrpAttempts + 1
        pcall(function()
            newHRP = newChar:FindFirstChild("HumanoidRootPart")
        end)
    end
    
    if not newHRP then
        warn("[Auto AFK] ✗ Gagal mendapatkan HRP baru")
        self.afterRespawn = false
        return
    end
    
    task.wait(CONFIG.POST_RESPAWN_DELAY)
    self.hrp = newHRP
    self.lastPos = self.hrp.Position
    self.stillTime = 0
    self.totalDist = 0
    
    print("[Auto AFK] 🔍 Menunggu button kembali...")
    self:setStatus("🟡 Waiting Button...", Color3.fromRGB(255,255,100))
    
    -- Tunggu button dari global
    local buttonFound = self:waitForButton()
    
    if not buttonFound then
        warn("[Auto AFK] ✗ Button hilang setelah respawn!")
        self:setStatus("❌ Button Lost", Color3.fromRGB(255,100,100))
        self.afterRespawn = false
        return
    end
    
    task.wait(2)
    self.afterRespawn = true
    
    -- Stop jika sedang running
    local text = self:getButtonText()
    print("[Auto AFK] Status button:", text or "kosong")
    
    if text and text:find("stop") then
        print("[Auto AFK] ⏸ Stopping sebelum restart...")
        self:clickButton(self.toggleBtn)
        task.wait(2)
    end
    
    -- Verifikasi button lagi
    if not self.toggleBtn or not self.toggleBtn.Parent then
        warn("[Auto AFK] ✗ Button hilang setelah stop")
        buttonFound = self:waitForButton()
        if not buttonFound then
            self.afterRespawn = false
            return
        end
    end
    
    -- Start route
    task.wait(1)
    text = self:getButtonText()
    
    if text and text:find("start") then
        print("[Auto AFK] ▶ Memulai route...")
        local started = self:clickButton(self.toggleBtn)
        if started then
            task.wait(2)
            self:setStatus("🟢 Auto Start Success", Color3.fromRGB(100,255,100))
            print("[Auto AFK] ✓ Route dimulai!")
        else
            warn("[Auto AFK] ✗ Gagal start")
            self:setStatus("⚠️ Start Failed", Color3.fromRGB(255,150,100))
        end
    else
        warn("[Auto AFK] ✗ Status salah:", text or "nil")
        self:setStatus("⚠️ Wrong State", Color3.fromRGB(255,200,100))
    end
    
    -- Cooldown
    task.spawn(function()
        task.wait(CONFIG.COOLDOWN_AFTER_RESPAWN)
        self.afterRespawn = false
        print("[Auto AFK] ✓ Cooldown selesai")
    end)
end

function AutoAFKSystem:createStatusUI()
    if CoreGui:FindFirstChild("WataX_AutoUI") then
        CoreGui.WataX_AutoUI:Destroy()
    end
    
    local statusGui = Instance.new("ScreenGui")
    statusGui.Name = "WataX_AutoUI"
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
    glow.Color = Color3.fromRGB(180, 120, 255)
    glow.Thickness = 2
    glow.Transparency = 0.4

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0.45, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ AutoAFK Status"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(180, 180, 255)
    title.TextScaled = true

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size = UDim2.new(1, 0, 0.55, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.45, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextScaled = true
    statusLabel.Text = "🟡 Initializing..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

    -- Rainbow effect
    local hue = 0
    local connection = RunService.RenderStepped:Connect(function()
        if not self.running or not statusGui.Parent then
            connection:Disconnect()
            return
        end
        hue = (hue + 0.4) % 360
        glow.Color = Color3.fromHSV(hue / 360, 0.8, 1)
    end)

    _G.WataXStatus = function(text, color)
        if statusLabel and statusLabel.Parent then
            pcall(function()
                statusLabel.Text = text
                statusLabel.TextColor3 = color
            end)
        end
    end
    
    return statusGui
end

function AutoAFKSystem:start()
    if _G.WataXAutoAFKRunning then
        print("[Auto AFK] ⚠️ Sudah berjalan!")
        return
    end
    
    _G.WataXAutoAFKRunning = true
    self.running = true
    
    print("[Auto AFK] ▶ Memulai sistem...")
    
    -- Buat UI
    self:createStatusUI()
    self:setStatus("🟡 Mencari Button...", Color3.fromRGB(255,255,100))
    
    -- Dapatkan HRP
    self.hrp = self:getHRP()
    if not self.hrp then
        warn("[Auto AFK] ✗ Gagal mendapatkan HRP")
        self:setStatus("❌ HRP Not Found", Color3.fromRGB(255,100,100))
        self.running = false
        _G.WataXAutoAFKRunning = false
        return
    end
    
    -- Tunggu button dari universal.lua
    local buttonFound = self:waitForButton()
    if not buttonFound then
        warn("[Auto AFK] ✗ Button tidak ditemukan")
        self:setStatus("❌ Button Not Found", Color3.fromRGB(255,100,100))
        self.running = false
        _G.WataXAutoAFKRunning = false
        return
    end
    
    self.lastPos = self.hrp.Position
    self:setStatus("🟢 Ready to Monitor", Color3.fromRGB(100,255,100))
    print("[Auto AFK] ✓ Sistem siap!")
    
    -- Main loop
    task.spawn(function()
        while self.running and _G.WataXAutoAFKRunning do
            pcall(function()
                -- Verifikasi HRP
                if not self.hrp or not self.hrp.Parent then
                    self.hrp = self:getHRP()
                    if self.hrp then
                        self.lastPos = self.hrp.Position
                        self.stillTime, self.totalDist = 0, 0
                    end
                    return
                end
                
                -- Verifikasi button menggunakan global
                if not self.toggleBtn or not self.toggleBtn.Parent then
                    if _G.KingMorrisToggleButton and _G.KingMorrisToggleButton.Parent then
                        self.toggleBtn = _G.KingMorrisToggleButton
                        print("[Auto AFK] ✓ Button direstore dari global")
                    else
                        warn("[Auto AFK] Button hilang, mencari...")
                        self:waitForButton()
                        if not self.toggleBtn then
                            self:setStatus("❌ Button Lost", Color3.fromRGB(255,100,100))
                            self.stillTime, self.totalDist = 0, 0
                            return
                        end
                    end
                end

                -- Hitung movement
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

                -- Skip saat cooldown
                if self.afterRespawn then
                    self.stillTime = 0
                    self.totalDist = 0
                    return
                end

                -- Update status
                if self.stillTime == 0 then
                    self:setStatus("🟢 Running", Color3.fromRGB(100,255,100))
                elseif self.stillTime < CONFIG.RESPAWN_DELAY then
                    self:setStatus("🟡 Idle " .. self.stillTime .. "s", Color3.fromRGB(255,255,150))
                end

                -- Auto respawn
                if CONFIG.AUTO_RESPAWN and self.stillTime >= CONFIG.RESPAWN_DELAY then
                    print("[Auto AFK] ⚠️ Memicu respawn")
                    self:respawnCharacter()
                    self.stillTime, self.totalDist = 0, 0
                    self.justRestarted = false
                    return
                end

                -- Auto restart
                local now = tick()
                if CONFIG.AUTO_START and self.stillTime >= CONFIG.STOP_DELAY and 
                   self.totalDist < 0.5 and (now - self.lastAutoStart > CONFIG.RETRY_INTERVAL) and 
                   not self.justRestarted then
                    
                    print("[Auto AFK] 🔄 Mencoba restart...")
                    local text = self:getButtonText()
                    self:setStatus("🔵 Restarting...", Color3.fromRGB(100,150,255))

                    if text and text:find("stop") then
                        self:clickButton(self.toggleBtn)
                        task.wait(1)
                    end
                    
                    text = self:getButtonText()
                    if text and text:find("start") then
                        if self:clickButton(self.toggleBtn) then
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
        
        print("[Auto AFK] ⏹ Loop selesai")
    end)
end

function AutoAFKSystem:stop()
    self.running = false
    _G.WataXAutoAFKRunning = false
    
    if CoreGui:FindFirstChild("WataX_AutoUI") then
        CoreGui.WataX_AutoUI:Destroy()
    end
    
    print("[Auto AFK] ⏹ Sistem dihentikan")
end

-- ============================================
-- MAIN UI CREATION
-- ============================================

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

-- ============================================
-- AUTO AFK BUTTON
-- ============================================

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
        -- DISABLE
        _G.KingMorrisAutoAFKEnabled = false
        AutoAFKSystem:stop()
        
        autoAfkBtn.Text = "⚙️ AUTO AFK"
        autoAfkBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        autoAfkBtn.BackgroundTransparency = 0.3
        afkStroke.Color = Color3.fromRGB(150, 100, 255)
        afkStroke.Transparency = 0.5
        
        print("[King Morris] ⏹ Auto AFK DISABLED")
    else
        -- ENABLE
        _G.KingMorrisAutoAFKEnabled = true
        
        autoAfkBtn.Text = "✅ AUTO AFK ENABLED"
        autoAfkBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        autoAfkBtn.BackgroundTransparency = 0
        afkStroke.Color = Color3.fromRGB(100, 255, 150)
        afkStroke.Transparency = 0
        
        print("[King Morris] ✓ Auto AFK ENABLED")
    end
end)

-- ============================================
-- PRIVATE SERVER BUTTON
-- ============================================

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

-- ============================================
-- MAP BUTTONS
-- ============================================

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
                
                -- Jika Auto AFK enabled, start monitoring setelah map load
                if _G.KingMorrisAutoAFKEnabled then
                    print("[King Morris] Auto AFK enabled, menunggu route UI...")
                    task.wait(8) -- Beri waktu UI muncul dan stabil
                    print("[King Morris] Memulai Auto AFK monitoring...")
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

-- ============================================
-- FINAL SETUP
-- ============================================

task.wait(0.1)
Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)

print("===========================================")
print("[King Morris] Menu loaded successfully!")
print("[King Morris] Version: 4.1 Fixed Integration")
print("[King Morris] Features:")
print("  ✓ Auto AFK System dengan Smart Respawn")
print("  ✓ Private Server Support")
print("  ✓ " .. #MAP_LIST .. " Maps Available")
print("===========================================")

-- Cleanup saat player leaving
player.AncestryChanged:Connect(function()
    if AutoAFKSystem.running then
        AutoAFKSystem:stop()
    end
    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end)
