local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local mainColor = Color3.fromRGB(200, 50, 100)
local darkPink = Color3.fromRGB(150, 30, 80)
local lightPink = Color3.fromRGB(255, 179, 217)
local bgColor = Color3.fromRGB(40, 15, 30)

-- Whitelist Configuration
local WHITELIST_URL = "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/whitelist.txt"

-- Cache untuk menghindari request berulang
local whitelistCache = {}
local cacheExpiry = 0

-- Function untuk HTTP request yang kompatibel dengan executor
local function httpGet(url)
    print("🔧 Trying game:HttpGet first...")
    
    -- Try game:HttpGet first (most reliable)
    local success1, result1 = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success1 and result1 and #result1 > 0 then
        print("✅ game:HttpGet success!")
        return result1
    end
    
    print("⚠️ game:HttpGet failed, trying request()...")
    
    -- Try request()
    if request then
        local success2, response = pcall(function()
            return request({
                Url = url,
                Method = "GET"
            })
        end)
        
        if success2 and response and response.Body then
            print("✅ request() success!")
            return response.Body
        end
    end
    
    -- Try syn.request
    if syn and syn.request then
        local success3, response = pcall(function()
            return syn.request({
                Url = url,
                Method = "GET"
            })
        end)
        
        if success3 and response and response.Body then
            print("✅ syn.request() success!")
            return response.Body
        end
    end
    
    error("All HTTP methods failed")
end

-- Function untuk parse whitelist format sederhana
local function parseWhitelist(content)
    local users = {}
    
    print("📄 Parsing content...")
    print("📏 Content length: " .. #content)
    
    -- Format: USERNAME:TIER:EXPIRES (setiap baris)
    -- Contoh: MORRISRESTO:vip:lifetime
    for line in content:gmatch("[^\r\n]+") do
        line = line:match("^%s*(.-)%s*$") -- Trim whitespace
        
        print("📝 Processing line: [" .. line .. "]")
        
        if line ~= "" and not line:match("^#") and not line:match("^%-%-") then -- Skip empty, comment, dan HTML
            local parts = {}
            for part in line:gmatch("[^:]+") do
                table.insert(parts, part:match("^%s*(.-)%s*$")) -- Trim each part
            end
            
            print("  Parts found: " .. #parts)
            if #parts > 0 then
                for i, p in ipairs(parts) do
                    print("    [" .. i .. "] = " .. p)
                end
            end
            
            if #parts >= 3 then
                local username = parts[1]
                local tier = parts[2]
                local expires = parts[3]
                
                users[username] = {
                    tier = tier,
                    expires = expires,
                    hwid = nil
                }
                print("  ✅ Added user: " .. username)
            else
                print("  ⚠️ Invalid format (need 3 parts)")
            end
        end
    end
    
    return users
end

local function checkAccessAPI(username)
    print("🔍 Checking access for: " .. username)
    
    local currentTime = tick()
    if whitelistCache[username] and currentTime < cacheExpiry then
        print("📦 Using cached data")
        return whitelistCache[username]
    end
    
    print("🌐 Fetching whitelist...")
    
    local success, result = pcall(function()
        local response = httpGet(WHITELIST_URL)
        print("📥 Response length: " .. #response .. " chars")
        print("📝 First 100 chars: " .. string.sub(response, 1, 100))
        return parseWhitelist(response)
    end)
    
    if not success then
        warn("❌ Failed to fetch/parse whitelist: " .. tostring(result))
        whitelistCache[username] = {allowed = false}
        cacheExpiry = currentTime + 60
        return whitelistCache[username]
    end
    
    if not result then
        warn("❌ Invalid whitelist format")
        whitelistCache[username] = {allowed = false}
        cacheExpiry = currentTime + 60
        return whitelistCache[username]
    end
    
    -- Count users
    local userCount = 0
    for _ in pairs(result) do
        userCount = userCount + 1
    end
    print("📊 Total users in whitelist: " .. userCount)
    
    -- Debug: Print all usernames
    print("👥 Users in whitelist:")
    for uname, _ in pairs(result) do
        print("  - " .. uname)
    end
    
    local userData = result[username]
    
    if userData then
        print("✅ User found in whitelist!")
        print("  - Tier: " .. tostring(userData.tier))
        print("  - Expires: " .. tostring(userData.expires))
        
        local isValid = true
        if userData.expires ~= "lifetime" then
            local expireDate = userData.expires
            local today = os.date("%Y-%m-%d")
            print("  - Today: " .. today)
            print("  - Expire Date: " .. expireDate)
            isValid = expireDate >= today
            print("  - Valid: " .. tostring(isValid))
        else
            print("  - Lifetime access!")
        end
        
        if isValid then
            whitelistCache[username] = {
                allowed = true,
                tier = userData.tier,
                expires = userData.expires
            }
            cacheExpiry = currentTime + 300
            print("✅ Access GRANTED")
            return whitelistCache[username]
        else
            print("❌ Subscription expired")
            whitelistCache[username] = {allowed = false}
            cacheExpiry = currentTime + 60
            return whitelistCache[username]
        end
    else
        print("❌ User NOT found in whitelist")
        whitelistCache[username] = {allowed = false}
        cacheExpiry = currentTime + 60
        return whitelistCache[username]
    end
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
        local script = httpGet(url)
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
    
    local accessData = checkAccessAPI(player.Name)
    
    print("\n📊 Final Result:")
    print("  - Allowed: " .. tostring(accessData.allowed))
    if accessData.tier then
        print("  - Tier: " .. accessData.tier)
    end
    if accessData.expires then
        print("  - Expires: " .. accessData.expires)
    end
    
    if not accessData.allowed then
        print("\n❌ Access Denied - Showing GUI")
        createGUI()
        return
    end
    
    print("\n✅ Access Granted")
    print("🎖️ Tier: " .. (accessData.tier or "standard"):upper())
    print("⏰ Expires: " .. (accessData.expires or "unknown"))
    
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    wait(2)
    
    safeLoad("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/menu.lua", "Menu")
    
    print("🎉 All systems loaded!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end)
