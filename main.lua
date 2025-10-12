-- Main Loader dengan Proteksi Simple
-- Dibuat untuk Roblox Script Protection

local Players = game:GetService("Players")

-- Konfigurasi - Cukup Edit Username Disini
local WHITELIST = {
    "MORRISRESTO",
    -- Tambahkan username lain dibawah ini
    -- "Username2",
    -- "Username3",
}

-- Fungsi cek whitelist
local function isWhitelisted(username)
    for _, allowedUser in ipairs(WHITELIST) do
        if username == allowedUser then
            return true
        end
    end
    return false
end

-- Main initialization
local function initialize()
    local player = Players.LocalPlayer
    local username = player.Name
    
    print("🔐 KingMorris Loader Starting...")
    print("👤 Player: " .. username)
    
    -- Cek whitelist
    if not isWhitelisted(username) then
        player:Kick("❌ Access Denied: Not whitelisted!")
        return
    end
    
    print("✅ Access granted!")
    
    -- Tunggu character siap
    print("⏳ Loading...")
    local character = player.Character or player.CharacterAdded:Wait()
    player:WaitForChild("PlayerGui", 10)
    
    wait(1) -- Delay untuk stabilitas
    
    -- Load menu.lua
    print("📂 Loading Menu...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/menu.lua"))()
    end)
    
    wait(0.5)
    
    -- Load universal.lua
    print("📂 Loading Universal...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua"))()
    end)
    
    print("✅ All scripts loaded successfully!")
    print("🎉 Enjoy using KingMorris Script!")
end

-- Run dengan error handling
local success, err = pcall(initialize)
if not success then
    warn("❌ Error: " .. tostring(err))
end
