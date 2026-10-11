-- DerSpalter Hub v2 (Modern UI)
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
-- UI BAŞLANGIÇ
-- ============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DerSpalterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Ana Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 360, 0, 400)
Main.Position = UDim2.new(0.5, -180, 0.5, -200)
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

-- Gradient Arka Plan
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

-- Başlık çubuğunun alt köşelerini düzleştirmek için ekstra frame
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

-- Logo Noktası
local LogoDot = Instance.new("Frame")
LogoDot.Size = UDim2.new(0, 8, 0, 8)
LogoDot.Position = UDim2.new(0, 16, 0.5, -4)
LogoDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoDot.BorderSizePixel = 0
LogoDot.Parent = TitleBar

local LogoDotCorner = Instance.new("UICorner")
LogoDotCorner.CornerRadius = UDim.new(1, 0)
LogoDotCorner.Parent = LogoDot

-- Başlık Yazısı
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

-- Sürüm etiketi
local VersionTag = Instance.new("TextLabel")
VersionTag.Size = UDim2.new(0, 60, 0, 20)
VersionTag.Position = UDim2.new(1, -130, 0.5, -10)
VersionTag.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
VersionTag.Text = "v2.0"
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

MinimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Main:TweenSize(UDim2.new(0, 360, 0, 44), "Out", "Quad", 0.25, true)
		MinimizeBtn.Text = "+"
	else
		Main:TweenSize(originalSize, "Out", "Quad", 0.25, true)
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
-- İÇERİK
-- ============================
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -24, 1, -80)
Content.Position = UDim2.new(0, 12, 0, 58)
Content.BackgroundTransparency = 1
Content.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

-- ============================
-- TOGGLE OLUŞTURMA FONKSİYONU
-- ============================
local function createToggle(name, icon, layoutOrder, callback)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 52)
	Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
	Btn.Text = ""
	Btn.AutoButtonColor = false
	Btn.LayoutOrder = layoutOrder
	Btn.Parent = Content

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Btn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(50, 50, 70)
	Stroke.Thickness = 1
	Stroke.Transparency = 0.4
	Stroke.Parent = Btn

	-- İkon dairesi
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

	-- Başlık
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

	-- Durum yazısı
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

	-- Toggle anahtarı
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

	-- Hover efekti
	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(36, 36, 50)}):Play()
		TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(90, 90, 140)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}):Play()
		TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 50, 70)}):Play()
	end)

	-- Tıklama
	local isOn = false
	Btn.MouseButton1Click:Connect(function()
		local result = callback(isOn)
		if result == false then return end -- callback reddettiyse değiştirme

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
-- TOGGLE'LARI OLUŞTUR
-- ============================

-- Auto Rep
createToggle("Auto Rep", "⚡", 1, function(currentState)
	if not muscleEvent then
		return false
	end
	local newState = not currentState
	getgenv().AutoRep = newState
	return true
end)

-- Auto Rebirth
createToggle("Auto Rebirth", "🔄", 2, function(currentState)
	local newState = not currentState
	getgenv().AutoRebirth = newState
	return true
end)

-- Lock Point
createToggle("Lock Point", "🔒", 3, function(currentState)
	local newState = not currentState
	getgenv().LockPoint = newState
	return true
end)

-- Alt bilgi
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "DerSpalter Hub  •  made with ❤"
Footer.TextColor3 = Color3.fromRGB(90, 90, 110)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.LayoutOrder = 10
Footer.Parent = Content

print("DerSpalter Hub v2 yüklendi")
