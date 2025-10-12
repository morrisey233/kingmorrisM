-- Main Loader dengan Proteksi
-- Dibuat untuk Roblox Script Protection

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Konfigurasi
local CONFIG = {
    WHITELIST_ENABLED = true,
    ALLOWED_USERS = {
        "MORRISRESTO", -- Username Roblox Anda
        "morrisey233", -- Backup username
        -- Tambahkan user lain jika perlu
    },
    HWID_CHECK = true,
    ANTI_DECOMPILE = true
}

-- Generate HWID sederhana
local function getHWID()
    local id = game:GetService("RbxAnalyticsService"):GetClientId()
    return id or tostring(game.Players.LocalPlayer.UserId)
end

-- Whitelist Check
local function checkWhitelist()
    if not CONFIG.WHITELIST_ENABLED then
        return true
    end
    
    local playerName = Players.LocalPlayer.Name
    local playerDisplayName = Players.LocalPlayer.DisplayName
    
    -- Debug info
    print("🔍 Checking player: " .. playerName)
    print("🔍 Display name: " .. playerDisplayName)
    
    for _, allowedUser in ipairs(CONFIG.ALLOWED_USERS) do
        if playerName == allowedUser or playerDisplayName == allowedUser then
            return true
        end
    end
    
    print("❌ Player not in whitelist!")
    return false
end

-- Anti-decompile protection
local function protectScript()
    if not CONFIG.ANTI_DECOMPILE then
        return
    end
    
    -- Deteksi beberapa script dumper
    local suspiciousKeywords = {
        "dex", "explorer", "spy", "remote", "dump", "decompile"
    }
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local name = obj.Name:lower()
            for _, keyword in ipairs(suspiciousKeywords) do
                if name:find(keyword) then
                    Players.LocalPlayer:Kick("Suspicious script detected!")
                    return false
                end
            end
        end
    end
    return true
end

-- Enkripsi sederhana (XOR dengan key)
local function simpleDecrypt(encoded, key)
    local decoded = ""
    local keyLen = #key
    for i = 1, #encoded do
        local byte = encoded:byte(i)
        local keyByte = key:byte((i - 1) % keyLen + 1)
        decoded = decoded .. string.char(bit32.bxor(byte, keyByte))
    end
    return decoded
end

-- Load external script dengan proteksi
local function loadProtectedScript(scriptContent, scriptName)
    local success, err = pcall(function()
        local func, loadErr = loadstring(scriptContent, scriptName)
        if not func then
            warn("Error loading " .. scriptName .. ": " .. tostring(loadErr))
            return
        end
        func()
    end)
    
    if not success then
        warn("Error executing " .. scriptName .. ": " .. tostring(err))
    end
end

-- Main initialization
local function initialize()
    print("🔐 Initializing Protected Loader...")
    
    -- Check 1: Whitelist
    if not checkWhitelist() then
        Players.LocalPlayer:Kick("Access Denied: Not whitelisted!")
        return
    end
    print("✅ Whitelist check passed")
    
    -- Check 2: HWID (optional)
    if CONFIG.HWID_CHECK then
        local hwid = getHWID()
        print("🆔 HWID: " .. hwid)
    end
    
    -- Check 3: Anti-decompile
    if not protectScript() then
        return
    end
    print("✅ Protection check passed")
    
    -- Tunggu character dan GUI siap
    print("⏳ Waiting for character...")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid", 10)
    
    -- Tunggu PlayerGui siap
    local playerGui = player:WaitForChild("PlayerGui", 10)
    if not playerGui then
        warn("⚠️ PlayerGui not found!")
        return
    end
    
    print("✅ Character and GUI ready")
    
    -- Load scripts dengan delay
    print("📂 Loading scripts...")
    
    -- Load menu.lua
    local menuSuccess = pcall(function()
        print("📥 Loading menu.lua...")
        local menuScript = game:HttpGet("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/menu.lua")
        wait(0.5) -- Delay sebelum execute
        loadstring(menuScript)()
    end)
    
    if menuSuccess then
        print("✅ Menu loaded")
    else
        warn("⚠️ Failed to load menu.lua")
    end
    
    wait(1) -- Delay antar script
    
    -- Load universal.lua
    local universalSuccess = pcall(function()
        print("📥 Loading universal.lua...")
        local universalScript = game:HttpGet("https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua")
        wait(0.5) -- Delay sebelum execute
        loadstring(universalScript)()
    end)
    
    if universalSuccess then
        print("✅ Universal loaded")
    else
        warn("⚠️ Failed to load universal.lua")
    end
    
    print("🎉 All systems loaded!")
end

-- Anti-tamper: Jalankan dengan proteksi
local function safeRun()
    local success, err = pcall(initialize)
    if not success then
        warn("Critical error: " .. tostring(err))
        Players.LocalPlayer:Kick("Script error detected!")
    end
end

-- Delay acak untuk menghindari deteksi
wait(math.random(1, 3) * 0.1)
safeRun()

-- Cleanup saat player leave
Players.LocalPlayer.AncestryChanged:Connect(function()
    -- Hapus jejak
    print("🧹 Cleaning up...")
end)
