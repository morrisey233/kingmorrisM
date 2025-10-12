-- WataX Universal Route Script with Menu Integration
-- UI disesuaikan dengan tema menu utama

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local hrp

-- 🗺️ MAP CONFIGURATION DATABASE
local MAP_DATABASE = {
    m1 = {name = "Mount Atin", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m1.lua", maxSpeed = 6, frameTime = 1/30},
    m2 = {name = "Mount Yahayuk", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m2.lua", maxSpeed = 3, frameTime = 1/30},
    m3 = {name = "Mount Daun", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m3.lua", maxSpeed = 3, frameTime = 1/30},
    m4 = {name = "Mount Arunika", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m4.lua", maxSpeed = 3, frameTime = 1/30},
    m5 = {name = "Mount Ravika", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m5.lua", maxSpeed = 3, frameTime = 1/30},
    m6 = {name = "Mount Lembayana", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m6.lua", maxSpeed = 3, frameTime = 1/30},
    m7 = {name = "Mount Sakahayang", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m7.lua", maxSpeed = 3, frameTime = 1/30},
    m8 = {name = "Mount YNTKTS", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m8.lua", maxSpeed = 3, frameTime = 1/33},
    m9 = {name = "Mount Hana", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m9.lua", maxSpeed = 3, frameTime = 1/30},
    m10 = {name = "Mount Stecu", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m10.lua", maxSpeed = 3, frameTime = 1/30},
    m11 = {name = "Mount Ckptw", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m11.lua", maxSpeed = 3, frameTime = 1/30},
    m12 = {name = "Mount Kalista", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m12.lua", maxSpeed = 3, frameTime = 1/30},
    m13 = {name = "Ekspedisi Kaliya", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m13.lua", maxSpeed = 3, frameTime = 1/30},
    m14 = {name = "Antartika Normal", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m14.lua", maxSpeed = 3, frameTime = 1/30},
    m15 = {name = "Mount Salvatore", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m15.lua", maxSpeed = 3, frameTime = 1/30},
    m16 = {name = "Mount Kirey", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m16.lua", maxSpeed = 3, frameTime = 1/30},
    m17 = {name = "Mount Pargoy", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m17.lua", maxSpeed = 3, frameTime = 1/30},
    m18 = {name = "Mount Forever", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m18.lua", maxSpeed = 3, frameTime = 1/45},
    m19 = {name = "Mount Mono", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m19.lua", maxSpeed = 3, frameTime = 1/45},
    m20 = {name = "Mount Yareuu", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m20.lua", maxSpeed = 3, frameTime = 1/45},
    m21 = {name = "Mount Serenity", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m21.lua", maxSpeed = 3, frameTime = 1/45},
    m22 = {name = "Mount Pedaunan", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m22.lua", maxSpeed = 3, frameTime = 1/45},
    m23 = {name = "Mount Pengangguran", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m23.lua", maxSpeed = 3, frameTime = 1/30},
    m24 = {name = "Mount Bingung", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m24.lua", maxSpeed = 3, frameTime = 1/32},
    m25 = {name = "Mount Kawaii", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m25.lua", maxSpeed = 3, frameTime = 1/32},
    m26 = {name = "Mount Runia", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m26.lua", maxSpeed = 3, frameTime = 1/32},
    m27 = {name = "Mount Swiss", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m27.lua", maxSpeed = 3, frameTime = 1/32},
    m28 = {name = "Mount Aneh", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m28.lua", maxSpeed = 3, frameTime = 1/32},
    m29 = {name = "Mount Lirae", url = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m29.lua", maxSpeed = 3, frameTime = 1/32},
}

-- PARAMETER DARI MENU
local selectedMapKey = _G.WataXSelectedMap or "m1"
local mapConfig = MAP_DATABASE[selectedMapKey]

if not mapConfig then
    warn("[WataX] Map tidak ditemukan: " .. selectedMapKey .. ". Menggunakan default.")
    selectedMapKey = "m1"
    mapConfig = MAP_DATABASE["m1"]
end

print("[WataX] Loading map: " .. mapConfig.name)

-- Variables
local routes = {}
local animConn
local isMoving = false
local frameTime = mapConfig.frameTime
local playbackRate = 1
local isReplayRunning = false
local currentMaxSpeed = mapConfig.maxSpeed

-- Color Theme (Match menu utama)
local mainColor = Color3.fromRGB(255, 105, 180)
local hoverBright = Color3.fromRGB(255, 182, 193)
local bgTrans = 0.15

-- Tween helper
local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Function untuk load route dari URL
local function loadRoute(url)
    local ok, data = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if ok and typeof(data) == "table" and #data > 0 then
        return data
    end
    return nil
end

-- Load route map yang dipilih
local function loadCurrentMap()
    routes = {}
    local mapData = loadRoute(mapConfig.url)
    if mapData then
        table.insert(routes, {"Route 1", mapData})
        print("[WataX] Successfully loaded: " .. mapConfig.name)
    else
        warn("[WataX] Failed to load map: " .. mapConfig.name)
        return false
    end
    return true
end

if not loadCurrentMap() then
    warn("[WataX] Tidak dapat memuat route. Script dihentikan.")
    return
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
            print("[WataX] Karakter mati, replay otomatis berhenti.")
            isReplayRunning = false
            stopMovement()
            isRunning = false
            if toggleBtn and toggleBtn.Parent then
                toggleBtn.Text = "▶ Start"
                tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(152, 251, 152), BackgroundTransparency = 0.2}, 0.2)
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

local function startMovement() isMoving=true end
local function stopMovement() isMoving=false end

local DEFAULT_HEIGHT = 2.9
local function getCurrentHeight()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    return humanoid.HipHeight + (char:FindFirstChild("Head") and char.Head.Size.Y or 2)
end

local function adjustRoute(frames)
    local adjusted = {}
    local offsetY = getCurrentHeight() - DEFAULT_HEIGHT
    for _,cf in ipairs(frames) do
        local pos, rot = cf.Position, cf - cf.Position
        table.insert(adjusted, CFrame.new(Vector3.new(pos.X,pos.Y+offsetY,pos.Z)) * rot)
    end
    return adjusted
end

if #routes > 0 then
    for i, data in ipairs(routes) do
        data[2] = adjustRoute(data[2])
    end
end

local function getNearestRoute()
    local nearestIdx, dist = 1, math.huge
    if hrp then
        local pos = hrp.Position
        for i,data in ipairs(routes) do
            for _,cf in ipairs(data[2]) do
                local d = (cf.Position - pos).Magnitude
                if d < dist then dist=d nearestIdx=i end
            end
        end
    end
    return nearestIdx
end

local function getNearestFrameIndex(frames)
    local startIdx, dist = 1, math.huge
    if hrp then
        local pos = hrp.Position
        for i,cf in ipairs(frames) do
            local d = (cf.Position - pos).Magnitude
            if d < dist then dist=d startIdx=i end
        end
    end
    if startIdx >= #frames then startIdx = math.max(1,#frames-1) end
    return startIdx
end

local function lerpCF(fromCF,toCF)
    local duration = frameTime/math.max(0.05,playbackRate)
    local t = 0
    while t < duration do
        if not isReplayRunning then break end
        local dt = task.wait()
        t += dt
        local alpha = math.min(t/duration,1)
        if hrp and hrp.Parent and hrp:IsDescendantOf(workspace) then
            hrp.CFrame = fromCF:Lerp(toCF,alpha)
        end
    end
end

local function runRoute()
    if #routes==0 then return end
    if not hrp then refreshHRP() end
    isReplayRunning = true
    startMovement()
    local idx = getNearestRoute()
    local frames = routes[idx][2]
    if #frames<2 then isReplayRunning=false return end
    local startIdx = getNearestFrameIndex(frames)
    for i=startIdx,#frames-1 do
        if not isReplayRunning then break end
        lerpCF(frames[i],frames[i+1])
    end
    isReplayRunning=false
    stopMovement()
end

local function stopRoute()
    isReplayRunning=false
    stopMovement()
end

-- 🎨 UI Creation (Match Menu Theme)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WataXReplayUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Name = "Phone"
frame.Size = UDim2.new(0, 180, 0, 360)
frame.Position = UDim2.new(0, 10, 1, -370)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
frame.BackgroundTransparency = bgTrans
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 30)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3
stroke.Color = mainColor
stroke.Transparency = 0.3

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(219, 39, 119)
title.Text = mapConfig.name
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextWrapped = true

-- Start/Stop Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 45)
toggleBtn.Position = UDim2.new(0, 10, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(152, 251, 152)
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.BorderSizePixel = 0
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.fromRGB(0, 128, 0)
toggleBtn.Text = "▶ Start"
toggleBtn.AutoButtonColor = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 15)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(0, 128, 0)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.4

toggleBtn.MouseEnter:Connect(function()
    tween(toggleStroke, {Transparency = 0}, 0.15)
    tween(toggleBtn, {BackgroundTransparency = 0}, 0.2)
end)
toggleBtn.MouseLeave:Connect(function()
    tween(toggleStroke, {Transparency = 0.4}, 0.2)
    tween(toggleBtn, {BackgroundTransparency = 0.2}, 0.25)
end)

isRunning = false
toggleBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        toggleBtn.Text = "■ Stop"
        tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(255, 99, 71), BackgroundTransparency = 0}, 0.2)
        tween(toggleStroke, {Color = Color3.fromRGB(255, 99, 71)}, 0.2)
        task.spawn(runRoute)
    else
        isRunning = false
        toggleBtn.Text = "▶ Start"
        tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(152, 251, 152), BackgroundTransparency = 0.2}, 0.2)
        tween(toggleStroke, {Color = Color3.fromRGB(0, 128, 0)}, 0.2)
        stopRoute()
    end
end)

-- Speed Label
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 105)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 13
speedLabel.TextColor3 = Color3.fromRGB(219, 39, 119)
speedLabel.Text = "Speed: " .. playbackRate .. "x"
speedLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Speed Controls
local speedDown = Instance.new("TextButton", frame)
speedDown.Size = UDim2.new(0.4, -8, 0, 35)
speedDown.Position = UDim2.new(0, 10, 0, 135)
speedDown.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
speedDown.BackgroundTransparency = 0.2
speedDown.BorderSizePixel = 0
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 18
speedDown.TextColor3 = Color3.fromRGB(60, 60, 60)
speedDown.Text = "−"
speedDown.AutoButtonColor = false
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 10)

speedDown.MouseEnter:Connect(function()
    tween(speedDown, {BackgroundTransparency = 0}, 0.15)
end)
speedDown.MouseLeave:Connect(function()
    tween(speedDown, {BackgroundTransparency = 0.2}, 0.15)
end)

speedDown.MouseButton1Click:Connect(function()
    playbackRate = math.max(0.25, playbackRate - 0.25)
    speedLabel.Text = "Speed: " .. playbackRate .. "x"
end)

local speedUp = Instance.new("TextButton", frame)
speedUp.Size = UDim2.new(0.4, -8, 0, 35)
speedUp.Position = UDim2.new(0.5, 8, 0, 135)
speedUp.BackgroundColor3 = mainColor
speedUp.BackgroundTransparency = 0.2
speedUp.BorderSizePixel = 0
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 18
speedUp.TextColor3 = Color3.fromRGB(219, 39, 119)
speedUp.Text = "+"
speedUp.AutoButtonColor = false
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 10)

speedUp.MouseEnter:Connect(function()
    tween(speedUp, {BackgroundTransparency = 0}, 0.15)
end)
speedUp.MouseLeave:Connect(function()
    tween(speedUp, {BackgroundTransparency = 0.2}, 0.15)
end)

speedUp.MouseButton1Click:Connect(function()
    playbackRate = math.min(currentMaxSpeed, playbackRate + 0.25)
    speedLabel.Text = "Speed: " .. playbackRate .. "x"
end)

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -20, 0, 35)
closeBtn.Position = UDim2.new(0, 10, 0, 180)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
closeBtn.Text = "✖ Close"
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 15)

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, {BackgroundTransparency = 0}, 0.15)
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, {BackgroundTransparency = 0.2}, 0.15)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Clear parameter setelah digunakan
_G.WataXSelectedMap = nil
