local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

if gui:FindFirstChild("WataXMenuUI") then gui.WataXMenuUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WataXMenuUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gui

local mainColor = Color3.fromRGB(255, 105, 180)
local hoverBright = Color3.fromRGB(255, 182, 193)
local bgTrans = 0.15

local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local Phone = Instance.new("Frame")
Phone.Name = "Phone"
Phone.Parent = ScreenGui
Phone.Size = UDim2.new(0, 200, 0, 400)
Phone.Position = UDim2.new(0.05, 0, 0.2, 0)
Phone.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
Phone.BackgroundTransparency = 0.3
Phone.Active = true
Phone.Draggable = true
Instance.new("UICorner", Phone).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", Phone)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(180, 120, 255)
stroke.Transparency = 0.4

local Title = Instance.new("TextLabel")
Title.Parent = Phone
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.Text = "💫 WATAX MENU"
Title.TextXAlignment = Enum.TextXAlignment.Center

-- URL Universal Script
local UNIVERSAL_SCRIPT = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/universal.lua"

-- Map List dengan mapKey yang sesuai
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
Scroll.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
Scroll.BackgroundTransparency = 0.5
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = mainColor
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 12)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Buat tombol untuk setiap Mount
for i, info in ipairs(mapList) do
    local b = Instance.new("TextButton")
    b.Name = "Btn" .. i
    b.Parent = Scroll
    b.Size = UDim2.new(1, -12, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(200, 200, 255)
    b.Text = info.text
    b.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 10)
    
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(150, 100, 200)
    s.Thickness = 2
    s.Transparency = 0.5

    b.MouseEnter:Connect(function() 
        tween(s, {Transparency = 0.1, Thickness = 3}, 0.15)
        tween(b, {BackgroundColor3 = Color3.fromRGB(150, 100, 200), BackgroundTransparency = 0.1}, 0.2)
    end)
    b.MouseLeave:Connect(function() 
        tween(s, {Transparency = 0.5, Thickness = 2}, 0.2)
        tween(b, {BackgroundColor3 = Color3.fromRGB(60, 40, 100), BackgroundTransparency = 0.3}, 0.25)
    end)
    
    b.MouseButton1Click:Connect(function()
        local originalText = b.Text
        b.Text = "⏳ Loading..."
        
        -- Set parameter map sebelum load universal script
        _G.WataXSelectedMap = info.mapKey
        
        local ok, err = pcall(function()
            local code = game:HttpGet(UNIVERSAL_SCRIPT)
            loadstring(code)()
        end)
        
        if ok then
            print("[WataX Menu] Successfully loaded: " .. info.text)
            -- Hapus menu setelah berhasil load
            task.wait(0.5)
            ScreenGui:Destroy()
        else 
            b.Text = "❌ Error"
            warn("[WataX Menu] Error loading:", err)
            _G.WataXSelectedMap = nil
            task.wait(2)
            b.Text = originalText
        end
    end)
end

-- Update canvas size
task.wait(0.1)
Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
