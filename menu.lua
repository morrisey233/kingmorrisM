local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

if gui:FindFirstChild("iPhoneUI") then gui.iPhoneUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iPhoneUI"
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
Phone.Size = UDim2.new(0, 180, 0, 360)
Phone.Position = UDim2.new(0, 10, 1, -370)
Phone.AnchorPoint = Vector2.new(0, 0)
Phone.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
Phone.BackgroundTransparency = bgTrans
Phone.Active = true
Phone.Draggable = true
Instance.new("UICorner", Phone).CornerRadius = UDim.new(0, 30)
local stroke = Instance.new("UIStroke", Phone)
stroke.Thickness = 3
stroke.Color = mainColor
stroke.Transparency = 0.3

local Title = Instance.new("TextLabel")
Title.Parent = Phone
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(219, 39, 119)
Title.Text = "💖 MORRIS SCRIPT"
Title.TextXAlignment = Enum.TextXAlignment.Center

-- 🗺️ UNIVERSAL SCRIPT URL
local UNIVERSAL_SCRIPT = "https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/universal.lua"

-- ✅ Mapping mapKey dengan text yang lebih rapi
local autoWalkList = {
    {text="Mount Atin", mapKey="m1"},
    {text="Mount Yahayuk", mapKey="m2"},
    {text="Mount Daun", mapKey="m3"},
    {text="Mount Arunika", mapKey="m4"},
    {text="Mount Ravika", mapKey="m5"},
    {text="Mount Lembayana", mapKey="m6"},
    {text="Mount Sakahayang", mapKey="m7"},
    {text="Mount YNTKTS", mapKey="m8"},
    {text="Mount Hana", mapKey="m9"},
    {text="Mount Stecu", mapKey="m10"},
    {text="Mount Ckptw", mapKey="m11"},
    {text="Mount Kalista", mapKey="m12"},
    {text="Ekspedisi Kaliya", mapKey="m13"},
    {text="Antartika Normal", mapKey="m14"},
    {text="Mount Salvatore", mapKey="m15"},
    {text="Mount Kirey", mapKey="m16"},
    {text="Mount Pargoy", mapKey="m17"},
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
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = mainColor
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Buat tombol untuk setiap Mount
for i, info in ipairs(autoWalkList) do
	local b = Instance.new("TextButton")
	b.Name = "Btn" .. i
	b.Parent = Scroll
	b.Size = UDim2.new(1, -12, 0, 38)
	b.BackgroundColor3 = Color3.fromRGB(255, 228, 240)
	b.BackgroundTransparency = 0.2
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.fromRGB(219, 39, 119)
	b.Text = info.text
	b.AutoButtonColor = false
	
	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0, 15)
	
	local s = Instance.new("UIStroke", b)
	s.Color = mainColor
	s.Thickness = 2
	s.Transparency = 0.4
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

	b.MouseEnter:Connect(function() 
		tween(s, {Transparency = 0}, 0.15)
		tween(b, {BackgroundColor3 = hoverBright, BackgroundTransparency = 0}, 0.2)
	end)
	b.MouseLeave:Connect(function() 
		tween(s, {Transparency = 0.4}, 0.2)
		tween(b, {BackgroundColor3 = Color3.fromRGB(255, 228, 240), BackgroundTransparency = 0.2}, 0.25)
	end)
	b.MouseButton1Click:Connect(function()
		b.Text = "Loading..."
		
		-- ✅ Set parameter map sebelum load universal script
		_G.WataXSelectedMap = info.mapKey
		
		local ok, err = pcall(function()
			local code = game:HttpGet(UNIVERSAL_SCRIPT)
			loadstring(code)()
		end)
		if ok then
			-- Langsung hapus menu setelah berhasil load
			ScreenGui:Destroy()
		else 
			b.Text = "✗ Error"
			warn("[Menu] Error loading:", err)
			_G.WataXSelectedMap = nil -- Reset jika error
			wait(2)
			b.Text = info.text
		end
	end)
end

-- Update canvas size setelah semua button dibuat
wait(0.1)
Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
