local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

if gui:FindFirstChild("KingMorrisMenuUI") then 
    gui.KingMorrisMenuUI:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KingMorrisMenuUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gui

local mainColor = Color3.fromRGB(200, 50, 100)
local darkPink = Color3.fromRGB(150, 30, 80)
local lightPink = Color3.fromRGB(255, 120, 170)
local bgColor = Color3.fromRGB(40, 15, 30)

local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local Phone = Instance.new("Frame")
Phone.Name = "Phone"
Phone.Parent = ScreenGui
Phone.Size = UDim2.new(0, 200, 0, 400)
Phone.Position = UDim2.new(0.05, 0, 0.2, 0)
Phone.BackgroundColor3 = bgColor
Phone.BackgroundTransparency = 0.2
Phone.Active = true
Phone.Draggable = true
Instance.new("UICorner", Phone).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", Phone)
stroke.Thickness = 3
stroke.Color = mainColor
stroke.Transparency = 0.3

local Title = Instance.new("TextLabel")
Title.Parent = Phone
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = lightPink
Title.Text = "👑 KING MORRIS"
Title.TextXAlignment = Enum.TextXAlignment.Center

local UNIVERSAL_SCRIPT = "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua"

local mapList = {
    {text="Mount Atin", mapKey="m1"},
    {text="Mount Yahayuk", mapKey="m2"},
    {text="Mount Kalista", mapKey="m12"},
    {text="Mount Daun", mapKey="m3"},
    {text="Mount Arunika", mapKey="m4"},
    {text="Mount Lembayana", mapKey="m6"},
    {text="Mount YNTKTS", mapKey="m8"},
    {text="Mount Sakahayang", mapKey="m7"},
    {text="Mount Hana", mapKey="m9"},
    {text="Mount Stecu", mapKey="m10"},
    {text="Mount Ckptw", mapKey="m11"},
    {text="Mount Ravika", mapKey="m5"},
    {text="Antartika Normal", mapKey="m14"},
    {text="Mount Salvatore", mapKey="m15"},
    {text="Mount Kirey", mapKey="m16"},
    {text="Mount Pargoy", mapKey="m17"},
    {text="Ekspedisi Kaliya", mapKey="m13"},
    {text="Mount Forever", mapKey="m18"},
    {text="Mount Mono", mapKey="m19"},
    {text="Mount Yareuu", mapKey="m20"},
    {text="Mount Serenity", mapKey="m21"},
    {text="Mount Pedaunan", mapKey="m22"},
    {text="Mount Pengangguran", mapKey="m23"},
    {text="Mount Bingung", mapKey="m24"},
    {text="Mount Kawaii", mapKey="m25"},
    {text="Mount Runia", mapKey="m26"},
    {text="Mount Swiss", mapKey="m27"},
    {text="Mount Aneh", mapKey="m28"},
    {text="Mount Lirae", mapKey="m29"},
}

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Phone
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundColor3 = Color3.fromRGB(30, 10, 25)
Scroll.BackgroundTransparency = 0.4
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = mainColor
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 12)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============ GLOBAL AUTO AFK FLAG ============
_G.KingMorrisAutoAFKEnabled = false

-- ============ AUTO AFK FUNCTION ============
local function startAutoAFK()
    if _G.WataXAutoAFKRunning then
        print("[King Morris] Auto AFK sudah jalan!")
        return
    end
    
    _G.WataXAutoAFKRunning = true
    
    local AUTO_START = true
    local AUTO_RESPAWN = true
    local STOP_DELAY = 25
    local RESPAWN_DELAY = 10
    local POST_RESPAWN_DELAY = 10
    local MOVE_THRESHOLD = 0.1
    local RETRY_INTERVAL = 10
    local COOLDOWN_AFTER_RESPAWN = 30

    local hrp, toggleBtn
    local lastPos, stillTime, totalDist = nil, 0, 0
    local lastAutoStart = 0
    local justRestarted = false
    local afterRespawn = false

    local function clickButton(button)
        if not button then return end
        for _, c in ipairs(getconnections(button.MouseButton1Click)) do
            pcall(function() c.Function() end)
        end
    end

    local function getButtonText()
        if not toggleBtn then return "" end
        return toggleBtn.Text:lower()
    end

    local function getHRP()
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart", 10)
    end

    local function setStatus(text, color)
        if _G.WataXStatus then
            _G.WataXStatus(text, color)
        end
    end

    local function respawnChar()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            print("[Auto AFK] Respawning...")
            setStatus("🔴 Respawning...", Color3.fromRGB(255,100,100))
            char.Humanoid.Health = 0
        end
        player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
        task.wait(POST_RESPAWN_DELAY)
        hrp = getHRP()
        
        afterRespawn = true
        local text = getButtonText()
        if text:find("stop") then
            clickButton(toggleBtn)
            task.wait(1)
        end
        if getButtonText():find("start") then
            clickButton(toggleBtn)
            setStatus("🟢 Auto Start after Respawn", Color3.fromRGB(100,255,100))
        end

        task.spawn(function()
            task.wait(COOLDOWN_AFTER_RESPAWN)
            afterRespawn = false
        end)
    end

    local function waitForToggleButton()
        print("[Auto AFK] Mencari toggle button...")
        local ui
        local maxWait = 30
        local waited = 0
        
        repeat
            task.wait(1)
            waited += 1
            
            -- Cari di Core GUI untuk KingMorrisUniversalUI
            for _, g in pairs(game.CoreGui:GetDescendants()) do
                if g:IsA("TextButton") and g.Name == "toggleBtn" then
                    if g.Parent and g.Parent.Name == "ControlPanel" then
                        ui = g
                        break
                    end
                end
            end
            
            -- Fallback: cari button dengan text Start/Stop
            if not ui then
                for _, g in pairs(game.CoreGui:GetDescendants()) do
                    if g:IsA("TextButton") and (g.Text:find("Start") or g.Text:find("Stop")) then
                        if g.Parent and g.Parent.Name == "ControlPanel" then
                            ui = g
                            break
                        end
                    end
                end
            end
            
            if waited >= maxWait then
                warn("[Auto AFK] Timeout - Toggle button tidak ditemukan setelah 30 detik")
                setStatus("❌ Route UI Not Found", Color3.fromRGB(255,100,100))
                break
            end
        until ui or not _G.WataXAutoAFKRunning
        
        if ui then
            print("[Auto AFK] Toggle button ditemukan:", ui.Text)
        end
        return ui
    end

    -- Create Status UI
    if not game.CoreGui:FindFirstChild("WataX_AutoUI") then
        local statusGui = Instance.new("ScreenGui")
        statusGui.Name = "WataX_AutoUI"
        statusGui.Parent = game.CoreGui

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
        statusLabel.Text = "🟡 Waiting for Route..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

        local hue = 0
        RunService.RenderStepped:Connect(function()
            if not _G.WataXAutoAFKRunning then
                statusGui:Destroy()
                return
            end
            hue = (hue + 0.4) % 360
            glow.Color = Color3.fromHSV(hue / 360, 0.8, 1)
        end)

        _G.WataXStatus = function(text, color)
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = text
                statusLabel.TextColor3 = color
            end
        end
    end

    hrp = getHRP()
    toggleBtn = waitForToggleButton()
    
    if not toggleBtn then
        print("[Auto AFK] Toggle button tidak ditemukan, menghentikan...")
        _G.WataXAutoAFKRunning = false
        return
    end
    
    lastPos = hrp.Position
    setStatus("🟢 Ready to Monitor", Color3.fromRGB(100,255,100))

    task.spawn(function()
        while _G.WataXAutoAFKRunning and task.wait(1) do
            if not hrp or not hrp.Parent then
                hrp = getHRP()
                lastPos = hrp.Position
                stillTime, totalDist = 0, 0
                continue
            end

            local dist = (hrp.Position - lastPos).Magnitude
            totalDist += dist
            lastPos = hrp.Position

            if dist < MOVE_THRESHOLD then
                stillTime += 1
            else
                stillTime, totalDist = 0, 0
                justRestarted = false
            end

            if afterRespawn then
                stillTime = 0
                continue
            end

            if stillTime == 0 then
                setStatus("🟢 Running", Color3.fromRGB(100,255,100))
            elseif stillTime < RESPAWN_DELAY then
                setStatus("🟡 Idle "..stillTime.."s", Color3.fromRGB(255,255,150))
            end

            if AUTO_RESPAWN and stillTime >= RESPAWN_DELAY then
                print("[Auto AFK] Triggering respawn...")
                respawnChar()
                stillTime, totalDist = 0, 0
                justRestarted = false
                continue
            end

            local now = tick()
            if AUTO_START and stillTime >= STOP_DELAY and totalDist < 0.5 and (now - lastAutoStart > RETRY_INTERVAL) then
                if not justRestarted then
                    local text = getButtonText()
                    setStatus("🔵 Restarting Route...", Color3.fromRGB(100,150,255))

                    if text:find("stop") then
                        clickButton(toggleBtn)
                        task.wait(1)
                    end
                    if getButtonText():find("start") then
                        clickButton(toggleBtn)
                        lastAutoStart = now
                        justRestarted = true
                        setStatus("🟢 Running", Color3.fromRGB(100,255,100))
                    end
                end
                stillTime, totalDist = 0, 0
            end
        end
    end)
end

-- ============ AUTO AFK BUTTON (TOGGLE) ============
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
        -- DISABLE AUTO AFK
        _G.KingMorrisAutoAFKEnabled = false
        _G.WataXAutoAFKRunning = false
        
        autoAfkBtn.Text = "⚙️ AUTO AFK"
        autoAfkBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        autoAfkBtn.BackgroundTransparency = 0.3
        afkStroke.Color = Color3.fromRGB(150, 100, 255)
        afkStroke.Transparency = 0.5
        
        if game.CoreGui:FindFirstChild("WataX_AutoUI") then
            game.CoreGui.WataX_AutoUI:Destroy()
        end
        
        print("[King Morris] Auto AFK DISABLED")
    else
        -- ENABLE AUTO AFK
        _G.KingMorrisAutoAFKEnabled = true
        
        autoAfkBtn.Text = "✅ AUTO AFK ENABLED"
        autoAfkBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        autoAfkBtn.BackgroundTransparency = 0
        afkStroke.Color = Color3.fromRGB(100, 255, 150)
        afkStroke.Transparency = 0
        
        print("[King Morris] Auto AFK ENABLED - Pilih map dan start route!")
        
        -- Tampilkan notifikasi
        if _G.WataXStatus then
            _G.WataXStatus("✅ Auto AFK Ready!", Color3.fromRGB(100,255,100))
        end
    end
end)

-- ============ MAP BUTTONS ============
for i, info in ipairs(mapList) do
    local b = Instance.new("TextButton")
    b.Name = "Btn" .. i
    b.Parent = Scroll
    b.Size = UDim2.new(1, -12, 0, 35)
    b.BackgroundColor3 = darkPink
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(255, 200, 220)
    b.Text = info.text
    b.AutoButtonColor = false
    b.LayoutOrder = i + 1
    
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 10)
    
    local s = Instance.new("UIStroke", b)
    s.Color = mainColor
    s.Thickness = 2
    s.Transparency = 0.5

    b.MouseEnter:Connect(function() 
        tween(s, {Transparency = 0.1, Thickness = 3}, 0.15)
        tween(b, {BackgroundColor3 = mainColor, BackgroundTransparency = 0.1}, 0.2)
    end)
    
    b.MouseLeave:Connect(function() 
        tween(s, {Transparency = 0.5, Thickness = 2}, 0.2)
        tween(b, {BackgroundColor3 = darkPink, BackgroundTransparency = 0.3}, 0.25)
    end)
    
    b.MouseButton1Click:Connect(function()
        local originalText = b.Text
        b.Text = "⏳ Loading..."
        
        _G.KingMorrisSelectedMap = info.mapKey
        
        task.spawn(function()
            local ok, err = pcall(function()
                local code = game:HttpGet(UNIVERSAL_SCRIPT)
                loadstring(code)()
            end)
            
            if ok then
                print("[King Morris] Successfully loaded: " .. info.text)
                
                -- Jika Auto AFK enabled, start monitoring setelah map load
                if _G.KingMorrisAutoAFKEnabled then
                    print("[King Morris] Auto AFK enabled, waiting for route UI...")
                    task.wait(3) -- Beri waktu UI muncul
                    print("[King Morris] Starting Auto AFK monitoring...")
                    startAutoAFK()
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
