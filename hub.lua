-- DerSpalter Hub + Auto Rep + Auto Rebirth
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoRep = false
getgenv().AutoRebirth = false
getgenv().RepSpeed = 0.08
getgenv().RepCount = 5
getgenv().RebirthDelay = 1

-- MuscleEvent'i bul
local function findMuscleEvent()
	local paths = {
		LocalPlayer,
		LocalPlayer:FindFirstChild("Character"),
		ReplicatedStorage,
		ReplicatedStorage:FindFirstChild("Remotes"),
		ReplicatedStorage:FindFirstChild("Events"),
	}
	for _, parent in pairs(paths) do
		if parent then
			local ev = parent:FindFirstChild("MuscleEvent")
			if ev and ev:IsA("RemoteEvent") then
				return ev
			end
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
					if rebirthRemote then
						rebirthRemote:InvokeServer("rebirthRequest")
					end
				end
			end)
		end
		task.wait(getgenv().RebirthDelay)
	end
end)

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DerSpalterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 280)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- Başlık Çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DerSpalter Hub"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Kapat Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -36, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
	getgenv().AutoRep = false
	getgenv().AutoRebirth = false
	ScreenGui:Destroy()
end)

-- Küçült / Büyült
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 36, 0, 36)
MinimizeBtn.Position = UDim2.new(1, -72, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "–"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TitleBar

local minimized = false
local originalSize = Main.Size

MinimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Main:TweenSize(UDim2.new(0, 320, 0, 36), "Out", "Quad", 0.25, true)
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
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
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

-- İçerik
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

-- Auto Rep Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleBtn.Text = "Auto Rep  |  KAPALI"
ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.TextSize = 14
ToggleBtn.LayoutOrder = 1
ToggleBtn.Parent = Content

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

local repEnabled = false
ToggleBtn.MouseButton1Click:Connect(function()
	if not muscleEvent then
		ToggleBtn.Text = "MuscleEvent bulunamadı!"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
		task.wait(1.5)
		ToggleBtn.Text = "Auto Rep  |  KAPALI"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		return
	end
	repEnabled = not repEnabled
	getgenv().AutoRep = repEnabled
	if repEnabled then
		ToggleBtn.Text = "Auto Rep  |  AÇIK"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 70)
		ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
	else
		ToggleBtn.Text = "Auto Rep  |  KAPALI"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	end
end)

-- Auto Rebirth Toggle
local RebirthBtn = Instance.new("TextButton")
RebirthBtn.Size = UDim2.new(1, 0, 0, 40)
RebirthBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
RebirthBtn.Text = "Auto Rebirth  |  KAPALI"
RebirthBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
RebirthBtn.Font = Enum.Font.Gotham
RebirthBtn.TextSize = 14
RebirthBtn.LayoutOrder = 2
RebirthBtn.Parent = Content

local RebirthCorner = Instance.new("UICorner")
RebirthCorner.CornerRadius = UDim.new(0, 6)
RebirthCorner.Parent = RebirthBtn

local rebirthEnabled = false
RebirthBtn.MouseButton1Click:Connect(function()
	rebirthEnabled = not rebirthEnabled
	getgenv().AutoRebirth = rebirthEnabled
	if rebirthEnabled then
		RebirthBtn.Text = "Auto Rebirth  |  AÇIK"
		RebirthBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 70)
		RebirthBtn.TextColor3 = Color3.new(1, 1, 1)
	else
		RebirthBtn.Text = "Auto Rebirth  |  KAPALI"
		RebirthBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		RebirthBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	end
end)

print("DerSpalter Hub yüklendi")
