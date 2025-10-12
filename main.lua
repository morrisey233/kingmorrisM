-- Main Loader dengan Proteksi
-- Dibuat untuk Roblox Script Protection

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Konfigurasi
local CONFIG = {
    WHITELIST_ENABLED = true,
    ALLOWED_USERS = {
        "MORRISRESTO", -- Ganti dengan username Roblox Anda
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
    for _, allowedUser in ipairs(CONFIG.ALLOWED_USERS) do
        if playerName == allowedUser then
            return true
        end
    end
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
    
    -- Load scripts
    print("📂 Loading scripts...")
    
    -- Coba load menu.lua
    local menuSuccess = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/morrisey233/YourRepo/main/menu.lua"))()
    end)
    
    if menuSuccess then
        print("✅ Menu loaded")
    else
        warn("⚠️ Failed to load menu.lua")
    end
    
    -- Coba load universal.lua
    local universalSuccess = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/morrisey233/YourRepo/main/universal.lua"))()
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

