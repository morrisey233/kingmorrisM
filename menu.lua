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


-- Title untuk Auto Walk
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


local autoWalkList = {
    {text="Mount Atin", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m1.lua"},
    {text="Mount Yahayuk", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m2.lua"},
    {text="Mount Kalista", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m12.lua"},
    {text="Mount Daun",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m3.lua"},
    {text="Mount Arunika",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m4.lua"},
    {text="Mount Lembayana",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m6.lua"},
    {text="Mount YNTKTS",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m8.lua"},
    {text="Mount Sakahayang",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m7.lua"},
    {text="Mount Hana",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m9.lua"},
    {text="Mount Stecu",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m10.lua"},
    {text="Mount Ckptw",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m11.lua"},
    {text="Mount Ravika",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m5.lua"},
    {text="Antartika Normal",  link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m14.lua"},
    {text="Mount Salvatore", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m15.lua"},
    {text="Mount Kirey", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m16.lua"},
    {text="Mount Pargoy", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m17.lua"},
    {text="Ekspedisi Kaliya", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m13.lua"},
    {text="Mount Forever", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m18.lua"},
    {text="Mount Mono", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m19.lua"},
    {text="Mount Yareuu", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m20.lua"},
    {text="Mount Serenity", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m21.lua"},
    {text="Mount Pedaunan", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m22.lua"},
    {text="Mount Pengangguran", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m23.lua"},
    {text="Mount Bingung", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m24.lua"},
    {text="Mount Kawaii", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m25.lua"},
    {text="Mount Runia", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m26.lua"},
    {text="Mount Swiss", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m27.lua"},
    {text="Mount Aneh", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m28.lua"},
    {text="Mount Lirae", link="https://raw.githubusercontent.com/WataXMenu/WataXFull/refs/heads/main/m29.lua"},
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
		local ok, err = pcall(function()
			local code = game:HttpGet(info.link)
			loadstring(code)()
		end)
		if ok then
			-- Langsung hapus semua UI setelah berhasil load
			ScreenGui:Destroy()
		else 
			b.Text = "✗ Error"
			warn("Error loading:", err)
			wait(2)
			b.Text = info.text
		end
	end)
end

-- Update canvas size setelah semua button dibuat
wait(0.1)
Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)

