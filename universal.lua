-- ============================================
-- KING MORRIS UNIVERSAL SCRIPT - FIXED
-- Route Player dengan Auto AFK Integration
-- Version: 4.1 Fixed
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local hrp

local MAP_ROUTES = {
    m1 = {
        name = "Mount Atin",
        maxSpeed = 6,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/10.lua"}
    },
    m2 = {
        name = "Mount Yahayuk",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/21.lua"}
    },
    m12 = {
        name = "Mount Kalista",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/120.lua"}
    },
    m3 = {
        name = "Mount Daun",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/30.lua"}
    },
    m4 = {
        name = "Mount Arunika",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/40.lua"}
    },
    m6 = {
        name = "Mount Lembayana",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {
            "https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/60.lua",
            "https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/61.lua"
        }
    },
    m8 = {
        name = "Mount YNTKTS",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/80.lua"}
    },
    m7 = {
        name = "Mount Sakahayang",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/70.lua"}
    },
    m9 = {
        name = "Mount Hana",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/90.lua"}
    },
    m10 = {
        name = "Mount Stecu",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/100.lua"}
    },
    m11 = {
        name = "Mount Ckptw",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/110.lua"}
    },
    m5 = {
        name = "Mount Ravika",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/50.lua"}
    },
    m14 = {
        name = "Antartika Normal",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/140.lua"}
    },
    m15 = {
        name = "Mount Salvatore",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/150.lua"}
    },
    m16 = {
        name = "Mount Kirey",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/160.lua"}
    },
    m17 = {
        name = "Mount Pargoy",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/170.lua"}
    },
    m13 = {
        name = "Ekspedisi Kaliya",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/130.lua"}
    },
    m18 = {
        name = "Mount Forever",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/180.lua"}
    },
    m19 = {
        name = "Mount Mono",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/190.lua"}
    },
    m20 = {
        name = "Mount Yareuu",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/200.lua"}
    },
    m21 = {
        name = "Mount Serenity",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/210.lua"}
    },
    m22 = {
        name = "Mount Pedaunan",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/220.lua"}
    },
    m23 = {
        name = "Mount Pengangguran",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/230.lua"}
    },
    m24 = {
        name = "Mount Bingung",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/240.lua"}
    },
    m25 = {
        name = "Mount Kawaii",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/250.lua"}
    },
    m26 = {
        name = "Mount Runia",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/260.lua"}
    },
    m27 = {
        name = "Mount Swiss",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/270.lua"}
    },
    m28 = {
        name = "Mount Aneh",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/280.lua"}
    },
    m29 = {
        name = "Mount Lirae",
        maxSpeed = 3,
        frameTime = 1/30,
        routes = {"https://raw.githubusercontent.com/WataXScAja/WataXScIni/refs/heads/main/290.lua"}
    }
}

local selectedMapKey = _G.KingMorrisSelectedMap or "m1"
local mapConfig = MAP_ROUTES[selectedMapKey]

if not mapConfig then
    warn("[King Morris] Invalid map key: " .. tostring(selectedMapKey))
    selectedMapKey = "m1"
    mapConfig = MAP_ROUTES["m1"]
end

print("[King Morris] Selected Map: " .. mapConfig.name)

local routes = {}
local animConn
local isMoving = false
local frameTime = mapConfig.frameTime
local playbackRate = 1
local isReplayRunning = false
local currentMaxSpeed = mapConfig.maxSpeed
local isRunning = false
local toggleBtn

local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function loadRoute(url)
    local success, result = pcall(function()
        local httpResult = game:HttpGet(url)
        return loadstring(httpResult)()
    end)
    
    if success and typeof(result) == "table" and #result > 0 then
        return result
    else
        warn("[King Morris] Failed to load route from: " .. url)
        return nil
    end
end

local DEFAULT_HEIGHT = 2.9

local function getCurrentHeight()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    return humanoid.HipHeight + (char:FindFirstChild("Head") and char.Head.Size.Y or 2)
end

local function adjustRoute(frames)
    local adjusted = {}
    local offsetY = getCurrentHeight() - DEFAULT_HEIGHT
    for _, cf in ipairs(frames) do
        local pos, rot = cf.Position, cf - cf.Position
        table.insert(adjusted, CFrame.new(Vector3.new(pos.X, pos.Y + offsetY, pos.Z)) * rot)
    end
    return adjusted
end

local function loadAllRoutes()
    routes = {}
    print("[King Morris] Loading routes for: " .. mapConfig.name)
    
    for i, link in ipairs(mapConfig.routes) do
        local mapData = loadRoute(link)
        
        if mapData and #mapData > 0 then
            local adjustedData = adjustRoute(mapData)
            table.insert(routes, {"Route " .. i, adjustedData})
            print("[King Morris] Route " .. i .. " loaded (" .. #mapData .. " frames)")
        end
    end
    
    return #routes > 0
end

local function refreshHRP(char)
    if not char then char = player.Character or player.CharacterAdded:Wait() end
    hrp = char:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(refreshHRP)
if player.Character then refreshHRP(player.Character) end

local function setupMovement(char)
    task.spawn(function()
        if not char then
            char = player.Character or player.CharacterAdded:Wait()
        end
        local humanoid = char:WaitForChild("Humanoid", 5)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not humanoid or not root then return end

        humanoid.Died:Connect(function()
            isReplayRunning = false
            stopMovement()
            isRunning = false
            if toggleBtn and toggleBtn.Parent then
                toggleBtn.Text = "▶ Start"
                tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 100)}, 0.2)
            end
        end)

        if animConn then animConn:Disconnect() end
        local lastPos = root.Position
        local jumpCooldown = false

        animConn = RunService.RenderStepped:Connect(function()
            if not isMoving then return end

            if not hrp or not hrp.Parent or not hrp:IsDescendantOf(workspace) then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    root = hrp
                else
                    return
                end
            end

            if not humanoid or humanoid.Health <= 0 then return end

            local direction = root.Position - lastPos
            local dist = direction.Magnitude

            if dist > 0.01 then
                humanoid:Move(direction.Unit * math.clamp(dist * 5, 0, 1), false)
            else
                humanoid:Move(Vector3.zero, false)
            end

            local deltaY = root.Position.Y - lastPos.Y
            if deltaY > 0.9 and not jumpCooldown then
                humanoid.Jump = true
                jumpCooldown = true
                task.delay(0.4, function()
                    jumpCooldown = false
                end)
            end

            lastPos = root.Position
        end)
    end)
end

player.CharacterAdded:Connect(function(char)
    refreshHRP(char)
    setupMovement(char)
end)

if player.Character then
    refreshHRP(player.Character)
    setupMovement(player.Character)
end

local function startMovement() 
    isMoving = true 
end

local function stopMovement() 
    isMoving = false 
end

local function getNearestRoute()
    local nearestIdx, dist = 1, math.huge
    if hrp then
        local pos = hrp.Position
        for i, data in ipairs(routes) do
            for _, cf in ipairs(data[2]) do
                local d = (cf.Position - pos).Magnitude
                if d < dist then
                    dist = d
                    nearestIdx = i
                end
            end
        end
    end
    return nearestIdx
end

local function getNearestFrameIndex(frames)
    local startIdx, dist = 1, math.huge
    if hrp then
        local pos = hrp.Position
        for i, cf in ipairs(frames) do
            local d = (cf.Position - pos).Magnitude
            if d < dist then
                dist = d
                startIdx = i
            end
        end
    end
    if startIdx >= #frames then startIdx = math.max(1, #frames - 1) end
    return startIdx
end

local function lerpCF(fromCF, toCF)
    local duration = frameTime / math.max(0.05, playbackRate)
    local t = 0
    while t < duration do
        if not isReplayRunning then break end
        local dt = task.wait()
        t += dt
        local alpha = math.min(t / duration, 1)
        if hrp and hrp.Parent and hrp:IsDescendantOf(workspace) then
            hrp.CFrame = fromCF:Lerp(toCF, alpha)
        end
    end
end

local function runRoute()
    if #routes == 0 then return end
    if not hrp then refreshHRP() end
    
    isReplayRunning = true
    startMovement()
    
    local idx = getNearestRoute()
    local frames = routes[idx][2]
    
    if #frames < 2 then
        isReplayRunning = false
        return
    end
    
    local startIdx = getNearestFrameIndex(frames)
    
    for i = startIdx, #frames - 1 do
        if not isReplayRunning then break end
        lerpCF(frames[i], frames[i + 1])
    end
    
    isReplayRunning = false
    stopMovement()
end

local function stopRoute()
    isReplayRunning = false
    stopMovement()
end

-- Cleanup existing UI
if game.CoreGui:FindFirstChild("KingMorrisUniversalUI") then
    game.CoreGui:FindFirstChild("KingMorrisUniversalUI"):Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KingMorrisUniversalUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainColor = Color3.fromRGB(200, 50, 100)
local darkPink = Color3.fromRGB(150, 30, 80)
local lightPink = Color3.fromRGB(255, 120, 170)
local bgColor = Color3.fromRGB(40, 15, 30)

local frame = Instance.new("Frame")
frame.Name = "ControlPanel"
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 1, -160)
frame.BackgroundColor3 = bgColor
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local glow = Instance.new("UIStroke", frame)
glow.Color = mainColor
glow.Thickness = 2
glow.Transparency = 0.3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -16, 0, 30)
title.Position = UDim2.new(0, 8, 0, 8)
title.Text = mapConfig.name
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 0.3
title.BackgroundColor3 = darkPink
title.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.5) % 360
    title.TextColor3 = Color3.fromHSV(hue / 360, 0.7, 1)
end)

toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Name = "toggleBtn"
toggleBtn.Size = UDim2.new(1, -16, 0, 40)
toggleBtn.Position = UDim2.new(0, 8, 0, 45)
toggleBtn.Text = "▶ Start"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.BackgroundColor3 = mainColor
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.AutoButtonColor = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

local toggleGlow = Instance.new("UIStroke", toggleBtn)
toggleGlow.Color = lightPink
toggleGlow.Thickness = 2
toggleGlow.Transparency = 0.4

toggleBtn.MouseEnter:Connect(function()
    tween(toggleGlow, {Transparency = 0.1, Thickness = 4}, 0.2)
end)
toggleBtn.MouseLeave:Connect(function()
    tween(toggleGlow, {Transparency = 0.4, Thickness = 2}, 0.2)
end)

toggleBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        toggleBtn.Text = "■ Stop"
        tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(180, 40, 80)}, 0.2)
        task.spawn(runRoute)
    else
        isRunning = false
        toggleBtn.Text = "▶ Start"
        tween(toggleBtn, {BackgroundColor3 = mainColor}, 0.2)
        stopRoute()
    end
end)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0.35, 0, 0, 30)
speedLabel.Position = UDim2.new(0.325, 0, 0, 95)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = lightPink
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 18
speedLabel.Text = playbackRate .. "x"

local speedDown = Instance.new("TextButton", frame)
speedDown.Size = UDim2.new(0.22, 0, 0, 30)
speedDown.Position = UDim2.new(0.04, 0, 0, 95)
speedDown.Text = "-"
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 20
speedDown.BackgroundColor3 = darkPink
speedDown.BackgroundTransparency = 0.3
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.AutoButtonColor = false
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 8)

speedDown.MouseButton1Click:Connect(function()
    playbackRate = math.max(0.25, playbackRate - 0.25)
    speedLabel.Text = playbackRate .. "x"
end)

local speedUp = Instance.new("TextButton", frame)
speedUp.Size = UDim2.new(0.22, 0, 0, 30)
speedUp.Position = UDim2.new(0.74, 0, 0, 95)
speedUp.Text = "+"
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 20
speedUp.BackgroundColor3 = mainColor
speedUp.BackgroundTransparency = 0.3
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.AutoButtonColor = false
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 8)

speedUp.MouseButton1Click:Connect(function()
    playbackRate = math.min(currentMaxSpeed, playbackRate + 0.25)
    speedLabel.Text = playbackRate .. "x"
end)

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1, -16, 0, 18)
infoLabel.Position = UDim2.new(0, 8, 0, 130)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = lightPink
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.Text = "Loading routes..."
infoLabel.TextXAlignment = Enum.TextXAlignment.Center

local loadSuccess = loadAllRoutes()

if loadSuccess then
    infoLabel.Text = "F1: Hide/Show | F2: On/Off | Max: " .. currentMaxSpeed .. "x"
else
    infoLabel.Text = "❌ Failed to load routes"
    infoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleBtn.Text = "❌ No Routes"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end

-- CRITICAL: Share button dengan Auto AFK system
_G.KingMorrisToggleButton = toggleBtn
print("[King Morris] ✓ Toggle button shared to global")

local isVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        isVisible = not isVisible
        if isVisible then
            tween(frame, {Position = UDim2.new(0, 10, 1, -160)}, 0.3)
        else
            tween(frame, {Position = UDim2.new(0, 10, 1, 10)}, 0.3)
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        if not isRunning then
            isRunning = true
            toggleBtn.Text = "■ Stop"
            tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(180, 40, 80)}, 0.2)
            task.spawn(runRoute)
        else
            isRunning = false
            toggleBtn.Text = "▶ Start"
            tween(toggleBtn, {BackgroundColor3 = mainColor}, 0.2)
            stopRoute()
        end
    end
end)

_G.KingMorrisSelectedMap = nil
print("[King Morris] Ready! Map: " .. mapConfig.name)
print("[King Morris] F1 = Hide/Show UI | F2 = Start/Stop")
print("[King Morris] Toggle button tersedia untuk Auto AFK")
