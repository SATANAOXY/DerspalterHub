-- DerSpalter Hub v3 (Modern UI + Kategoriler + TP)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoRep = false
getgenv().AutoRebirth = false
getgenv().LockPoint = false
getgenv().RepSpeed = 0.08
getgenv().RepCount = 5
getgenv().RebirthDelay = 1

-- ============================
-- ANTI-AFK
-- ============================
LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================
-- LOCK POINT MANTIĞI
-- ============================
local lockCFrame = nil

task.spawn(function()
	while true do
		if getgenv().LockPoint then
			local char = LocalPlayer.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					if not lockCFrame then lockCFrame = root.CFrame end
					root.CFrame = lockCFrame
					root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end
		else
			lockCFrame = nil
		end
		task.wait()
	end
end)

-- MuscleEvent'i bul
local function findMuscleEvent()
	local paths = { LocalPlayer, LocalPlayer:FindFirstChild("Character"), ReplicatedStorage, ReplicatedStorage:FindFirstChild("Remotes"), ReplicatedStorage:FindFirstChild("Events") }
	for _, parent in pairs(paths) do
		if parent then
			local ev = parent:FindFirstChild("MuscleEvent")
			if ev and ev:IsA("RemoteEvent") then return ev end
		end
	end
	return nil
end
local muscleEvent = findMuscleEvent()

-- Auto Rep
task.spawn(function()
	while true do
		if getgenv().AutoRep and muscleEvent then
			pcall(function()
				for i = 1, getgenv().RepCount do
					muscleEvent:FireServer("punch", "leftHand")
					muscleEvent:FireServer("punch", "rightHand")
				end
			end)
		end
		task.wait(getgenv().RepSpeed)
	end
end)

-- Auto Rebirth
task.spawn(function()
	while true do
		if getgenv().AutoRebirth then
			pcall(function()
				local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
				if rEvents then
					local rebirthRemote = rEvents:FindFirstChild("rebirthRemote")
					if rebirthRemote then rebirthRemote:InvokeServer("rebirthRequest") end
				end
			end)
		end
		task.wait(getgenv().RebirthDelay)
	end
end)

-- ============================
-- TP NOKTALARI
-- ============================
local TP_LOCATIONS = {
	-- Gym'ler
	{name = "Jungle Gym",          pos = Vector3.new(-8173, 64, 1898)},
	{name = "Muscle King Gym",     pos = Vector3.new(-8646, 17, -5738)},
	{name = "Legends Gym",         pos = Vector3.new(4111, 1020, -3799)},
	{name = "Mythical Gym",        pos = Vector3.new(2371, 39, 1246)},
	{name = "Frost Gym",           pos = Vector3.new(-3013, 39, -335)},
	{name = "Eternal Gym",         pos = Vector3.new(-7176, 45, -1106)},

	-- Adalar / Bölgeler
	{name = "Spawn",               pos = Vector3.new(2, 8, 115)},
	{name = "Starter Island",      pos = Vector3.new(-17, 3, -2)},
	{name = "Tiny Island",         pos = Vector3.new(-34, 7, 1903)},
	{name = "Secret Area",         pos = Vector3.new(1947, 2, 6191)},
	{name = "Legend Beach",        pos = Vector3.new(470, 3, -321)},
	{name = "Frozen Island",       pos = Vector3.new(-2600, 4, -404)},
	{name = "Mythical Island",     pos = Vector3.new(2255, 7, 1071)},
	{name = "Hell Island",         pos = Vector3.new(-6768, 7, -1287)},
	{name = "Legend Island",       pos = Vector3.new(4604, 991, -3887)},
	{name = "Muscle King Island",  pos = Vector3.new(-8646, 17, -5738)},
	{name = "Jungle Island",       pos = Vector3.new(-8659, 6, 2384)},

	-- Brawl alanları
	{name = "Brawl Lava",          pos = Vector3.new(4471, 119, -8836)},
	{name = "Brawl Desert",        pos = Vector3.new(960, 17, -7398)},
	{name = "Brawl Regular",       pos = Vector3.new(-1849, 20, -6335)},
}

-- ============================
-- UI BAŞLANGIÇ
-- ============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DerSpalterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 380, 0, 480)
Main.Position = UDim2.new(0.5, -190, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 90)
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

local MainGradient = Instance.new("UIGradient")
MainGradient.Rotation = 90
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 32)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 20)),
})
MainGradient.Parent = Main

-- Başlık Çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 14)
TitleFix.Position = UDim2.new(0, 0, 1, -14)
TitleFix.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Rotation = 0
TitleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 80, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 130, 240)),
})
TitleGradient.Parent = TitleBar

local LogoDot = Instance.new("Frame")
LogoDot.Size = UDim2.new(0, 8, 0, 8)
LogoDot.Position = UDim2.new(0, 16, 0.5, -4)
LogoDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoDot.BorderSizePixel = 0
LogoDot.Parent = TitleBar

local LogoDotCorner = Instance.new("UICorner")
LogoDotCorner.CornerRadius = UDim.new(1, 0)
LogoDotCorner.Parent = LogoDot

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 32, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DerSpalter Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local VersionTag = Instance.new("TextLabel")
VersionTag.Size = UDim2.new(0, 60, 0, 20)
VersionTag.Position = UDim2.new(1, -130, 0.5, -10)
VersionTag.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
VersionTag.Text = "v3.0"
VersionTag.TextColor3 = Color3.fromRGB(200, 200, 220)
VersionTag.Font = Enum.Font.GothamMedium
VersionTag.TextSize = 10
VersionTag.Parent = TitleBar

local VersionCorner = Instance.new("UICorner")
VersionCorner.CornerRadius = UDim.new(0, 10)
VersionCorner.Parent = VersionTag

-- Kapat Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 60, 80)}):Play()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 30, 40)}):Play()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 120, 120)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
	getgenv().AutoRep = false
	getgenv().AutoRebirth = false
	getgenv().LockPoint = false
	ScreenGui:Destroy()
end)

-- Küçült Butonu
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -70, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MinimizeBtn.Text = "–"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

MinimizeBtn.MouseEnter:Connect(function()
	TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 70, 95)}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
	TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
end)

local minimized = false
local originalSize = Main.Size

-- ============================
-- KATEGORİ SEKMELERİ (Tab Bar)
-- ============================
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -24, 0, 34)
TabBar.Position = UDim2.new(0, 12, 0, 56)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.PaddingTop = UDim.new(0, 4)
TabPadding.PaddingBottom = UDim.new(0, 4)
TabPadding.Parent = TabBar

-- İçerik
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -24, 1, -140)
Content.Position = UDim2.new(0, 12, 0, 98)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- İki ayrı sayfa (Frame)
local FarmPage = Instance.new("ScrollingFrame")
FarmPage.Name = "FarmPage"
FarmPage.Size = UDim2.new(1, 0, 1, 0)
FarmPage.BackgroundTransparency = 1
FarmPage.BorderSizePixel = 0
FarmPage.ScrollBarThickness = 4
FarmPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
FarmPage.CanvasSize = UDim2.new(0, 0, 0, 0)
FarmPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
FarmPage.Visible = true
FarmPage.Parent = Content

local FarmLayout = Instance.new("UIListLayout")
FarmLayout.Padding = UDim.new(0, 10)
FarmLayout.SortOrder = Enum.SortOrder.LayoutOrder
FarmLayout.Parent = FarmPage

local TPPage = Instance.new("ScrollingFrame")
TPPage.Name = "TPPage"
TPPage.Size = UDim2.new(1, 0, 1, 0)
TPPage.BackgroundTransparency = 1
TPPage.BorderSizePixel = 0
TPPage.ScrollBarThickness = 4
TPPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
TPPage.CanvasSize = UDim2.new(0, 0, 0, 0)
TPPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
TPPage.Visible = false
TPPage.Parent = Content

local TPLayout = Instance.new("UIListLayout")
TPLayout.Padding = UDim.new(0, 8)
TPLayout.SortOrder = Enum.SortOrder.LayoutOrder
TPLayout.Parent = TPPage

-- Sekme butonları
local function createTabButton(name, layoutOrder, page)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.5, -3, 1, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	Btn.Text = name
	Btn.TextColor3 = Color3.fromRGB(180, 180, 200)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 12
	Btn.AutoButtonColor = false
	Btn.LayoutOrder = layoutOrder
	Btn.Parent = TabBar

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Btn

	local function setActive(active)
		if active then
			TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 140, 240), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		else
			TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 48), TextColor3 = Color3.fromRGB(180, 180, 200)}):Play()
		end
	end

	Btn.MouseButton1Click:Connect(function()
		FarmPage.Visible = (page == "farm")
		TPPage.Visible = (page == "tp")
		for _, btn in pairs(TabBar:GetChildren()) do
			if btn:IsA("TextButton") then
				if btn == Btn then setActive(true) else
					TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 48), TextColor3 = Color3.fromRGB(180, 180, 200)}):Play()
				end
			end
		end
	end)

	return Btn, setActive
end

local farmTabBtn, setFarmActive = createTabButton("FARM", 1, "farm")
local tpTabBtn, setTPActive = createTabButton("TP", 2, "tp")
setFarmActive(true)

-- ============================
-- KÜÇÜLTME
-- ============================
MinimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Content.Visible = false
		TabBar.Visible = false
		TitleFix.Visible = false
		Main:TweenSize(UDim2.new(0, 380, 0, 44), "Out", "Quad", 0.25, true)
		MinimizeBtn.Text = "+"
	else
		Main:TweenSize(originalSize, "Out", "Quad", 0.25, true)
		task.wait(0.25)
		Content.Visible = true
		TabBar.Visible = true
		TitleFix.Visible = true
		MinimizeBtn.Text = "–"
	end
end)

-- Sürükleme
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

TitleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ============================
-- TOGGLE OLUŞTURMA
-- ============================
local function createToggle(parent, name, icon, layoutOrder, callback)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 52)
	Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
	Btn.Text = ""
	Btn.AutoButtonColor = false
	Btn.LayoutOrder = layoutOrder
	Btn.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Btn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(50, 50, 70)
	Stroke.Thickness = 1
	Stroke.Transparency = 0.4
	Stroke.Parent = Btn

	local IconCircle = Instance.new("Frame")
	IconCircle.Size = UDim2.new(0, 32, 0, 32)
	IconCircle.Position = UDim2.new(0, 12, 0.5, -16)
	IconCircle.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
	IconCircle.BorderSizePixel = 0
	IconCircle.Parent = Btn

	local IconCorner = Instance.new("UICorner")
	IconCorner.CornerRadius = UDim.new(1, 0)
	IconCorner.Parent = IconCircle

	local IconLabel = Instance.new("TextLabel")
	IconLabel.Size = UDim2.new(1, 0, 1, 0)
	IconLabel.BackgroundTransparency = 1
	IconLabel.Text = icon
	IconLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
	IconLabel.Font = Enum.Font.GothamBold
	IconLabel.TextSize = 16
	IconLabel.Parent = IconCircle

	local BtnTitle = Instance.new("TextLabel")
	BtnTitle.Size = UDim2.new(1, -140, 0, 20)
	BtnTitle.Position = UDim2.new(0, 56, 0, 10)
	BtnTitle.BackgroundTransparency = 1
	BtnTitle.Text = name
	BtnTitle.TextColor3 = Color3.fromRGB(230, 230, 240)
	BtnTitle.Font = Enum.Font.GothamSemibold
	BtnTitle.TextSize = 14
	BtnTitle.TextXAlignment = Enum.TextXAlignment.Left
	BtnTitle.Parent = Btn

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Size = UDim2.new(1, -140, 0, 16)
	StatusLabel.Position = UDim2.new(0, 56, 0, 28)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Text = "Kapalı"
	StatusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
	StatusLabel.Font = Enum.Font.Gotham
	StatusLabel.TextSize = 11
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	StatusLabel.Parent = Btn

	local Switch = Instance.new("Frame")
	Switch.Size = UDim2.new(0, 42, 0, 22)
	Switch.Position = UDim2.new(1, -54, 0.5, -11)
	Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	Switch.BorderSizePixel = 0
	Switch.Parent = Btn

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = Switch

	local SwitchDot = Instance.new("Frame")
	SwitchDot.Size = UDim2.new(0, 16, 0, 16)
	SwitchDot.Position = UDim2.new(0, 3, 0.5, -8)
	SwitchDot.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
	SwitchDot.BorderSizePixel = 0
	SwitchDot.Parent = Switch

	local DotCorner = Instance.new("UICorner")
	DotCorner.CornerRadius = UDim.new(1, 0)
	DotCorner.Parent = SwitchDot

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(36, 36, 50)}):Play()
		TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(90, 90, 140)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}):Play()
		TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 50, 70)}):Play()
	end)

	local isOn = false
	Btn.MouseButton1Click:Connect(function()
		local result = callback(isOn)
		if result == false then return end

		isOn = not isOn
		if isOn then
			TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 240)}):Play()
			TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TweenService:Create(IconCircle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 240)}):Play()
			TweenService:Create(IconLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			StatusLabel.Text = "Açık"
			StatusLabel.TextColor3 = Color3.fromRGB(120, 220, 160)
		else
			TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
			TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 180, 200)}):Play()
			TweenService:Create(IconCircle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 58)}):Play()
			TweenService:Create(IconLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 220)}):Play()
			StatusLabel.Text = "Kapalı"
			StatusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
		end
	end)
end

-- ============================
-- TP BUTONU OLUŞTURMA
-- ============================
local function createTPButton(parent, name, pos, layoutOrder)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 38)
	Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
	Btn.Text = ""
	Btn.AutoButtonColor = false
	Btn.LayoutOrder = layoutOrder
	Btn.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Btn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(50, 50, 70)
	Stroke.Thickness = 1
	Stroke.Transparency = 0.4
	Stroke.Parent = Btn

	local Pin = Instance.new("TextLabel")
	Pin.Size = UDim2.new(0, 24, 1, 0)
	Pin.Position = UDim2.new(0, 12, 0, 0)
	Pin.BackgroundTransparency = 1
	Pin.Text = "📍"
	Pin.TextColor3 = Color3.fromRGB(180, 180, 220)
	Pin.Font = Enum.Font.GothamBold
	Pin.TextSize = 14
	Pin.Parent = Btn

	local Label = In
