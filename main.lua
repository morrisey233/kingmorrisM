-- KING MORRIS SCRIPT LOADER
-- Premium Script Protection System
-- Modern & Professional Design

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ═══════════════════════════════════════
-- WHITELIST CONFIGURATION
-- ═══════════════════════════════════════
local WHITELIST = {
    "MORRISRESTO",
    -- Add more usernames here:
    -- "Username2",
    -- "Username3",
}

-- ═══════════════════════════════════════
-- FUNCTIONS
-- ═══════════════════════════════════════

local function checkAccess()
    local username = Players.LocalPlayer.Name
    for _, user in ipairs(WHITELIST) do
        if username == user then
            return true
        end
    end
    return false
end

local function createModernGUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KingMorrisGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    
    -- Background Blur Effect
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    -- Main Container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainContainer"
    mainFrame.Size = UDim2.new(0, 450, 0, 400)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = background
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    -- Gradient Border Effect
    local borderGradient = Instance.new("UIStroke")
    borderGradient.Color = Color3.fromRGB(88, 101, 242)
    borderGradient.Thickness = 2
    borderGradient.Transparency = 0
    borderGradient.Parent = mainFrame
    
    -- Header Section
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    -- Fix bottom corner
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 20)
    headerFix.Position = UDim2.new(0, 0, 1, -20)
    headerFix.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    -- Crown Icon
    local crownIcon = Instance.new("TextLabel")
    crownIcon.Name = "CrownIcon"
    crownIcon.Size = UDim2.new(0, 50, 0, 50)
    crownIcon.Position = UDim2.new(0, 20, 0, 15)
    crownIcon.BackgroundTransparency = 1
    crownIcon.Text = "👑"
    crownIcon.TextSize = 36
    crownIcon.Parent = header
    
    -- Brand Title
    local brandTitle = Instance.new("TextLabel")
    brandTitle.Name = "BrandTitle"
    brandTitle.Size = UDim2.new(1, -80, 0, 35)
    brandTitle.Position = UDim2.new(0, 75, 0, 15)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "KING MORRIS"
    brandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    brandTitle.TextSize = 28
    brandTitle.Font = Enum.Font.GothamBold
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    brandTitle.Parent = header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -80, 0, 20)
    subtitle.Position = UDim2.new(0, 75, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Script System"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 59)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(1, 0)
    closeBtnCorner.Parent = closeBtn
    
    -- Content Container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -40, 1, -120)
    content.Position = UDim2.new(0, 20, 0, 90)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    -- Status Icon
    local statusIcon = Instance.new("TextLabel")
    statusIcon.Name = "StatusIcon"
    statusIcon.Size = UDim2.new(0, 80, 0, 80)
    statusIcon.Position = UDim2.new(0.5, 0, 0, 10)
    statusIcon.AnchorPoint = Vector2.new(0.5, 0)
    statusIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    statusIcon.Text = "🔒"
    statusIcon.TextSize = 48
    statusIcon.Font = Enum.Font.GothamBold
    statusIcon.Parent = content
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = statusIcon
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = Color3.fromRGB(255, 59, 59)
    iconStroke.Thickness = 3
    iconStroke.Parent = statusIcon
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 100)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ACCESS DENIED"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 26
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = content
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, 0, 0, 60)
    description.Position = UDim2.new(0, 0, 0, 145)
    description.BackgroundTransparency = 1
    description.Text = "You are not whitelisted.\n\n💎 Want premium access?\nJoin our Discord to purchase!"
    description.TextColor3 = Color3.fromRGB(180, 180, 200)
    description.TextSize = 15
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.Parent = content
    
    -- Discord Button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Name = "DiscordButton"
    discordBtn.Size = UDim2.new(1, 0, 0, 50)
    discordBtn.Position = UDim2.new(0, 0, 1, -110)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = ""
    discordBtn.AutoButtonColor = false
    discordBtn.Parent = content
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 10)
    discordCorner.Parent = discordBtn
    
    local discordIcon = Instance.new("TextLabel")
    discordIcon.Size = UDim2.new(0, 30, 0, 30)
    discordIcon.Position = UDim2.new(0, 15, 0.5, 0)
    discordIcon.AnchorPoint = Vector2.new(0, 0.5)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Text = "📱"
    discordIcon.TextSize = 24
    discordIcon.Parent = discordBtn
    
    local discordText = Instance.new("TextLabel")
    discordText.Size = UDim2.new(1, -50, 1, 0)
    discordText.Position = UDim2.new(0, 50, 0, 0)
    discordText.BackgroundTransparency = 1
    discordText.Text = "JOIN DISCORD SERVER"
    discordText.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordText.TextSize = 16
    discordText.Font = Enum.Font.GothamBold
    discordText.TextXAlignment = Enum.TextXAlignment.Left
    discordText.Parent = discordBtn
    
    -- Copy Link Button
    local copyBtn = Instance.new("TextButton")
    copyBtn.Name = "CopyButton"
    copyBtn.Size = UDim2.new(1, 0, 0, 45)
    copyBtn.Position = UDim2.new(0, 0, 1, -55)
    copyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    copyBtn.Text = ""
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = content
    
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 10)
    copyCorner.Parent = copyBtn
    
    local copyStroke = Instance.new("UIStroke")
    copyStroke.Color = Color3.fromRGB(60, 60, 70)
    copyStroke.Thickness = 1
    copyStroke.Parent = copyBtn
    
    local copyIcon = Instance.new("TextLabel")
    copyIcon.Size = UDim2.new(0, 25, 0, 25)
    copyIcon.Position = UDim2.new(0, 15, 0.5, 0)
    copyIcon.AnchorPoint = Vector2.new(0, 0.5)
    copyIcon.BackgroundTransparency = 1
    copyIcon.Text = "📋"
    copyIcon.TextSize = 20
    copyIcon.Parent = copyBtn
    
    local copyText = Instance.new("TextLabel")
    copyText.Name = "CopyText"
    copyText.Size = UDim2.new(1, -50, 1, 0)
    copyText.Position = UDim2.new(0, 45, 0, 0)
    copyText.BackgroundTransparency = 1
    copyText.Text = "discord.gg/7Zqmdm5Shq"
    copyText.TextColor3 = Color3.fromRGB(180, 180, 200)
    copyText.TextSize = 14
    copyText.Font = Enum.Font.Gotham
    copyText.TextXAlignment = Enum.TextXAlignment.Left
    copyText.Parent = copyBtn
    
    screenGui.Parent = playerGui
    
    -- ═══════════════════════════════════════
    -- ANIMATIONS
    -- ═══════════════════════════════════════
    
    -- Entrance Animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 450, 0, 400)
    })
    openTween:Play()
    
    -- Pulse animation for icon
    task.spawn(function()
        while statusIcon.Parent do
            TweenService:Create(statusIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 85, 0, 85)
            }):Play()
            wait(1)
            TweenService:Create(statusIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 80, 0, 80)
            }):Play()
            wait(1)
        end
    end)
    
    -- ═══════════════════════════════════════
    -- BUTTON FUNCTIONS
    -- ═══════════════════════════════════════
    
    -- Close Button
    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        screenGui:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 59, 59)
        }):Play()
    end)
    
    -- Discord Button
    discordBtn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/7Zqmdm5Shq")
        end)
        
        setclipboard("https://discord.gg/7Zqmdm5Shq")
        
        discordText.Text = "✅ LINK COPIED TO CLIPBOARD!"
        TweenService:Create(discordBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(67, 181, 129)
        }):Play()
        
        wait(2)
        
        discordText.Text = "JOIN DISCORD SERVER"
        TweenService:Create(discordBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        }):Play()
    end)
    
    discordBtn.MouseEnter:Connect(function()
        TweenService:Create(discordBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(98, 111, 252)
        }):Play()
    end)
    
    discordBtn.MouseLeave:Connect(function()
        TweenService:Create(discordBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        }):Play()
    end)
    
    -- Copy Button
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/7Zqmdm5Shq")
        
        copyText.Text = "✅ Copied to clipboard!"
        copyText.TextColor3 = Color3.fromRGB(67, 181, 129)
        
        wait(2)
        
        copyText.Text = "discord.gg/7Zqmdm5Shq"
        copyText.TextColor3 = Color3.fromRGB(180, 180, 200)
    end)
    
    copyBtn.MouseEnter:Connect(function()
        TweenService:Create(copyBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        }):Play()
    end)
    
    copyBtn.MouseLeave:Connect(function()
        TweenService:Create(copyBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        }):Play()
    end)
end

local function safeLoad(url, name)
    local success, result = pcall(function()
        local script = game:HttpGet(url)
        local func = loadstring(script)
        if func then
            func()
            return true
        end
        return false
    end)
    
    if success and result then
        print("✅ " .. name .. " loaded successfully")
    else
        warn("⚠️ Failed to load " .. name)
    end
end

-- ═══════════════════════════════════════
-- MAIN EXECUTION
-- ═══════════════════════════════════════

task.spawn(function()
    local player = Players.LocalPlayer
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("👑 KING MORRIS LOADER")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("👤 Player: " .. player.Name)
    print("🔍 Checking access...")
    
    if not checkAccess() then
        print("❌ Access Denied")
        createModernGUI()
        return
    end
    
    print("✅ Access Granted!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    wait(2)
    
    print("📥 Loading scripts...")
    
    safeLoad(
        "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/menu.lua",
        "Menu System"
    )
    
    wait(1)
    
    safeLoad(
        "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua",
        "Universal System"
    )
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎉 All systems loaded!")
    print("✨ Enjoy KING MORRIS Script!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end)
