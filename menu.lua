local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

if gui:FindFirstChild("MorrisMenuUI") then gui.MorrisMenuUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorrisMenuUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gui

-- Modern Pink Color Palette
local pink = Color3.fromRGB(255, 105, 180)
local lightPink = Color3.fromRGB(255, 182, 193)
local darkPink = Color3.fromRGB(219, 39, 119)
local white = Color3.fromRGB(255, 255, 255)
local bgDark = Color3.fromRGB(30, 30, 40)
local bgCard = Color3.fromRGB(40, 40, 52)

local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

-- URL Universal Script
local UNIVERSAL_SCRIPT = "https://raw.githubusercontent.com/morrisey233/kingmorrisM/main/universal.lua"

-- Map List
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

-- Main Container
local Main = Instance.new("Frame")
Main.Name = "MainContainer"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 280, 0, 450)
Main.Position = UDim2.new(0.5, -140, 0.5, -225)
Main.BackgroundColor3 = bgDark
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = Main
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = Main
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = darkPink
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Parent = Header
HeaderBottom.Size = UDim2.new(1, 0, 0, 16)
HeaderBottom.Position = UDim2.new(0, 0, 1, -16)
HeaderBottom.BackgroundColor3 = darkPink
HeaderBottom.BorderSizePixel = 0

-- Logo/Icon
local Icon = Instance.new("TextLabel")
Icon.Parent = Header
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(0, 15, 0, 15)
Icon.BackgroundColor3 = white
Icon.Text = "M"
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 24
Icon.TextColor3 = darkPink
Icon.BorderSizePixel = 0
local IconCorner = Instance.new("UICorner", Icon)
IconCorner.CornerRadius = UDim.new(1, 0)

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, -120, 0, 40)
Title.Position = UDim2.new(0, 65, 0, 15)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = white
Title.Text = "MORRIS SCRIPT"
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -55, 0, 15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundTransparency = 0.9
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 28
CloseBtn.TextColor3 = white
CloseBtn.AutoButtonColor = false
CloseBtn.BorderSizePixel = 0
local CloseBtnCorner = Instance.new("UICorner", CloseBtn)
CloseBtnCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, {BackgroundTransparency = 0.7})
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, {BackgroundTransparency = 0.9})
end)
CloseBtn.MouseButton1Click:Connect(function()
    tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Search Bar
local SearchBar = Instance.new("TextBox")
SearchBar.Parent = Main
SearchBar.Size = UDim2.new(1, -30, 0, 40)
SearchBar.Position = UDim2.new(0, 15, 0, 85)
SearchBar.BackgroundColor3 = bgCard
SearchBar.BorderSizePixel = 0
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 14
SearchBar.TextColor3 = white
SearchBar.PlaceholderText = "🔍 Search maps..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
SearchBar.Text = ""
SearchBar.ClearTextOnFocus = false
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 10)
Instance.new("UIPadding", SearchBar).PaddingLeft = UDim.new(0, 12)

-- Scroll Frame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Size = UDim2.new(1, -30, 1, -145)
Scroll.Position = UDim2.new(0, 15, 0, 135)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = pink
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Create Map Buttons
for i, info in ipairs(mapList) do
    local Btn = Instance.new("TextButton")
    Btn.Name = "MapBtn" .. i
    Btn.Parent = Scroll
    Btn.Size = UDim2.new(1, -8, 0, 45)
    Btn.BackgroundColor3 = bgCard
    Btn.BorderSizePixel = 0
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.TextColor3 = white
    Btn.Text = info.text
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    
    local Accent = Instance.new("Frame")
    Accent.Name = "Accent"
    Accent.Parent = Btn
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.Position = UDim2.new(0, 0, 0, 0)
    Accent.BackgroundColor3 = pink
    Accent.BorderSizePixel = 0
    local AccentCorner = Instance.new("UICorner", Accent)
    AccentCorner.CornerRadius = UDim.new(0, 10)

    Btn.MouseEnter:Connect(function()
        tween(Btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 62)})
        tween(Accent, {Size = UDim2.new(0, 6, 1, 0)})
    end)
    
    Btn.MouseLeave:Connect(function()
        tween(Btn, {BackgroundColor3 = bgCard})
        tween(Accent, {Size = UDim2.new(0, 4, 1, 0)})
    end)
    
    Btn.MouseButton1Click:Connect(function()
        local originalText = Btn.Text
        Btn.Text = "⏳ Loading..."
        tween(Btn, {BackgroundColor3 = darkPink})
        
        _G.WataXSelectedMap = info.mapKey
        
        local ok, err = pcall(function()
            local code = game:HttpGet(UNIVERSAL_SCRIPT)
            loadstring(code)()
        end)
        
        if ok then
            print("[Morris Script] Successfully loaded: " .. info.text)
            task.wait(0.5)
            ScreenGui:Destroy()
        else 
            Btn.Text = "❌ Error"
            tween(Btn, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)})
            warn("[Morris Script] Error loading:", err)
            _G.WataXSelectedMap = nil
            task.wait(2)
            Btn.Text = originalText
            tween(Btn, {BackgroundColor3 = bgCard})
        end
    end)
end

-- Search Functionality
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = SearchBar.Text:lower()
    for _, btn in pairs(Scroll:GetChildren()) do
        if btn:IsA("TextButton") then
            if searchText == "" or btn.Text:lower():find(searchText) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end
end)

-- Update Canvas Size
task.wait(0.1)
Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- Entry Animation
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
tween(Main, {Size = UDim2.new(0, 280, 0, 450), Position = UDim2.new(0.5, -140, 0.5, -225)}, 0.5)
