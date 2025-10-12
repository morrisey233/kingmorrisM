-- Main Loader Simple & Safe
-- KingMorris Script Protection

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Username Whitelist
local WHITELIST = {
    "MORRISRESTO",
    -- Tambah username disini:
    -- "Username2",
}

-- Check whitelist
local function checkAccess()
    local username = Players.LocalPlayer.Name
    for _, user in ipairs(WHITELIST) do
        if username == user then
            return true
        end
    end
    return false
end

-- Show access denied prompt with clickable link
local function showAccessDenied()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AccessDeniedGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Background blur
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Main container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 400, 0, 300)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BorderSizePixel = 0
    container.Parent = frame
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🔐 ACCESS DENIED"
    title.TextColor3 = Color3.fromRGB(255, 85, 85)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Message
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -40, 0, 80)
    message.Position = UDim2.new(0, 20, 0, 80)
    message.BackgroundTransparency = 1
    message.Text = "You are not whitelisted.\n\n💎 Want premium access?\nJoin our Discord to order!"
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextSize = 16
    message.Font = Enum.Font.Gotham
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.TextWrapped = true
    message.Parent = container
    
    -- Discord Button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -40, 0, 50)
    discordBtn.Position = UDim2.new(0, 20, 0, 180)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "📱 JOIN DISCORD SERVER"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.TextSize = 16
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = discordBtn
    
    -- Copy link button
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(1, -40, 0, 40)
    copyBtn.Position = UDim2.new(0, 20, 0, 245)
    copyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    copyBtn.Text = "📋 discord.gg/7Zqmdm5Shq"
    copyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    copyBtn.TextSize = 14
    copyBtn.Font = Enum.Font.Gotham
    copyBtn.Parent = container
    
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 8)
    copyCorner.Parent = copyBtn
    
    screenGui.Parent = playerGui
    
    -- Button functions
    discordBtn.MouseButton1Click:Connect(function()
        -- Try to open Discord invite
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/7Zqmdm5Shq")
        end)
        
        -- Also copy to clipboard
        setclipboard("https://discord.gg/7Zqmdm5Shq")
        
        discordBtn.Text = "✅ LINK COPIED!"
        wait(2)
        discordBtn.Text = "📱 JOIN DISCORD SERVER"
    end)
    
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/7Zqmdm5Shq")
        copyBtn.Text = "✅ Copied to clipboard!"
        wait(2)
        copyBtn.Text = "📋 discord.gg/7Zqmdm5Shq"
    end)
    
    -- Kick after 10 seconds
    wait(10)
    player:Kick("❌ Access Denied\n\nJoin Discord: discord.gg/7Zqmdm5Shq")
end

-- Load script dengan safety
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
        print("✅ " .. name .. " loaded")
    else
        warn("⚠️ " .. name .. " failed to load")
    end
end

-- Main function
task.spawn(function()
    local player = Players.LocalPlayer
    
    print("━━━━━━━━━━━━━━━━━━━━━━")
    print("🔐 KingMorris Loader")
    print("👤 User: " .. player.Name)
    print("━━━━━━━━━━━━━━━━━━━━━━")
    
    -- Check access
    if not checkAccess() then
        print("❌ Access Denied")
        showAccessDenied()
        return
    end
    
    print("✅ Access Granted")
    
    -- Wait for character
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    wait(2) -- Safety delay
    
    -- Load scripts
    print("📥 Loading scripts...")
    
    safeLoad(
        "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/menu.lua",
        "Menu"
    )
    
    wait(1)
    
    safeLoad(
        "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua", 
        "Universal"
    )
    
    print("━━━━━━━━━━━━━━━━━━━━━━")
    print("🎉 Ready to use!")
    print("━━━━━━━━━━━━━━━━━━━━━━")
end)
