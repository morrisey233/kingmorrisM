local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local mainColor = Color3.fromRGB(200, 50, 100)
local darkPink = Color3.fromRGB(150, 30, 80)
local lightPink = Color3.fromRGB(150, 30, 80)
local bgColor = Color3.fromRGB(40, 15, 30)

local WHITELIST = {
    "MORRISRESTO",
}

local function checkAccess()
    local username = Players.LocalPlayer.Name
    for _, user in ipairs(WHITELIST) do
        if username == user then
            return true
        end
    end
    return false
end

local function createGUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KingMorrisGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 500)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = bgColor
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = mainColor
    stroke.Thickness = 3
    stroke.Transparency = 0
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 100)
    header.BackgroundColor3 = mainColor
    header.BorderSizePixel = 0
    header.Parent = main
    
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 20)
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 30)
    headerFix.Position = UDim2.new(0, 0, 1, -30)
    headerFix.BackgroundColor3 = mainColor
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    local gradient = Instance.new("UIGradient", header)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, mainColor),
        ColorSequenceKeypoint.new(1, darkPink)
    }
    gradient.Rotation = 45
    
    local crown = Instance.new("TextLabel")
    crown.Size = UDim2.new(0, 60, 0, 60)
    crown.Position = UDim2.new(0, 25, 0, 20)
    crown.BackgroundTransparency = 1
    crown.Text = "👑"
    crown.TextSize = 42
    crown.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 0, 40)
    title.Position = UDim2.new(0, 90, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "KING MORRIS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 32
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -100, 0, 25)
    subtitle.Position = UDim2.new(0, 130, 0, 70)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Script System"
    subtitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    subtitle.TextSize = 15
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.TextTransparency = 0
    subtitle.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 30)
    closeBtn.Text = "❌"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
    
    local closeBtnStroke = Instance.new("UIStroke", closeBtn)
    closeBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    closeBtnStroke.Thickness = 2
    closeBtnStroke.Transparency = 0.3
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -60, 1, -140)
    content.Position = UDim2.new(0, 30, 0, 120)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.new(0, 100, 0, 100)
    iconBg.Position = UDim2.new(0.5, 0, 0, 20)
    iconBg.AnchorPoint = Vector2.new(0.5, 0)
    iconBg.BackgroundColor3 = Color3.fromRGB(30, 20, 28)
    iconBg.BorderSizePixel = 0
    iconBg.Parent = content
    
    Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1, 0)
    
    local iconStroke = Instance.new("UIStroke", iconBg)
    iconStroke.Color = mainColor
    iconStroke.Thickness = 4
    iconStroke.Transparency = 0
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "🔒"
    icon.TextSize = 56
    icon.Parent = iconBg
    
    local deniedText = Instance.new("TextLabel")
    deniedText.Size = UDim2.new(1, 0, 0, 45)
    deniedText.Position = UDim2.new(0, 0, 0, 135)
    deniedText.BackgroundTransparency = 1
    deniedText.Text = "ACCESS DENIED"
    deniedText.TextColor3 = lightPink
    deniedText.TextSize = 28
    deniedText.Font = Enum.Font.GothamBold
    deniedText.Parent = content
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, 0, 0, 90)
    desc.Position = UDim2.new(0, 0, 0, 185)
    desc.BackgroundTransparency = 1
    desc.Text = "You are not whitelisted.\n\n💎 Want premium access?\nJoin our Discord to purchase!"
    desc.TextColor3 = Color3.fromRGB(230, 190, 210)
    desc.TextSize = 15
    desc.Font = Enum.Font.Gotham
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.Parent = content
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 65)
    btn.Position = UDim2.new(0, 0, 1, -70)
    btn.BackgroundColor3 = mainColor
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = content
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = lightPink
    btnStroke.Thickness = 2
    btnStroke.Transparency = 0.3
    
    local btnGradient = Instance.new("UIGradient", btn)
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, mainColor),
        ColorSequenceKeypoint.new(1, darkPink)
    }
    btnGradient.Rotation = 90
    
    local btnIcon = Instance.new("TextLabel")
    btnIcon.Size = UDim2.new(0, 35, 0, 35)
    btnIcon.Position = UDim2.new(0, 18, 0.5, 0)
    btnIcon.AnchorPoint = Vector2.new(0, 0.5)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Text = "📱"
    btnIcon.TextSize = 28
    btnIcon.Parent = btn
    
    local btnTitle = Instance.new("TextLabel")
    btnTitle.Name = "BtnTitle"
    btnTitle.Size = UDim2.new(1, -135, 0, 26)
    btnTitle.Position = UDim2.new(0, 60, 0, 10)
    btnTitle.BackgroundTransparency = 1
    btnTitle.Text = "JOIN DISCORD SERVER"
    btnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnTitle.TextSize = 17
    btnTitle.Font = Enum.Font.GothamBold
    btnTitle.TextXAlignment = Enum.TextXAlignment.Left
    btnTitle.Parent = btn
    
    local btnSub = Instance.new("TextLabel")
    btnSub.Name = "BtnSub"
    btnSub.Size = UDim2.new(1, -135, 0, 20)
    btnSub.Position = UDim2.new(0, 60, 0, 34)
    btnSub.BackgroundTransparency = 1
    btnSub.Text = "discord.gg/7Zqmdm5Shq"
    btnSub.TextColor3 = Color3.fromRGB(255, 200, 220)
    btnSub.TextSize = 13
    btnSub.Font = Enum.Font.Gotham
    btnSub.TextXAlignment = Enum.TextXAlignment.Left
    btnSub.Parent = btn
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 35, 0, 35)
    arrow.Position = UDim2.new(1, -45, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "→"
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.TextSize = 26
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = btn
    
    screenGui.Parent = playerGui
    
    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 500)
    }):Play()
    
    task.spawn(function()
        while iconBg.Parent do
            TweenService:Create(iconBg, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 105, 0, 105)
            }):Play()
            TweenService:Create(iconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Thickness = 5
            }):Play()
            wait(1.2)
            TweenService:Create(iconBg, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 100, 0, 100)
            }):Play()
            TweenService:Create(iconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Thickness = 4
            }):Play()
            wait(1.2)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        wait(0.4)
        screenGui:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 59, 59),
            Size = UDim2.new(0, 44, 0, 44)
        }):Play()
        TweenService:Create(closeBtnStroke, TweenInfo.new(0.2), {
            Transparency = 0,
            Thickness = 3
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 15, 30),
            Size = UDim2.new(0, 40, 0, 40)
        }):Play()
        TweenService:Create(closeBtnStroke, TweenInfo.new(0.2), {
            Transparency = 0.3,
            Thickness = 2
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/7Zqmdm5Shq")
        end)
        setclipboard("https://discord.gg/7Zqmdm5Shq")
        
        btnTitle.Text = "✅ SUCCESS!"
        btnSub.Text = "Link copied & opened"
        arrow.Text = "✓"
        
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(67, 181, 129)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(100, 255, 150)}):Play()
        
        wait(2.5)
        
        btnTitle.Text = "JOIN DISCORD SERVER"
        btnSub.Text = "discord.gg/7Zqmdm5Shq"
        arrow.Text = "→"
        
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = mainColor}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = lightPink}):Play()
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 68)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0, Thickness = 3}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Position = UDim2.new(1, -38, 0.5, 0)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 65)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3, Thickness = 2}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Position = UDim2.new(1, -45, 0.5, 0)}):Play()
    end)
end

local function safeLoad(url, name)
    local success = pcall(function()
        local script = game:HttpGet(url)
        local func = loadstring(script)
        if func then func() end
    end)
    if success then
        print("✅ " .. name .. " loaded")
    else
        warn("⚠️ Failed: " .. name)
    end
end

task.spawn(function()
    local player = Players.LocalPlayer
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("👑 KING MORRIS LOADER")
    print("👤 Player: " .. player.Name)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    if not checkAccess() then
        print("❌ Access Denied")
        createGUI()
        return
    end
    
    print("✅ Access Granted")
    
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    wait(2)
    
    safeLoad("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/menu.lua", "Menu")
    wait(1)
    safeLoad("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua", "Universal")
    
    print("🎉 All systems loaded!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end)
