
-- DerSpalter Hub | Minimal Edition
-- UI prototipi | Mobil + PC

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önceki arayüzü temizle
local OldGui = PlayerGui:FindFirstChild("DerSpalterHub")
if OldGui then
    OldGui:Destroy()
end

-- Renkler
local Colors = {
    Background = Color3.fromRGB(24, 25, 28),
    Header = Color3.fromRGB(31, 32, 36),
    Button = Color3.fromRGB(39, 40, 45),
    Accent = Color3.fromRGB(91, 170, 125),
    Text = Color3.fromRGB(238, 238, 240),
    Muted = Color3.fromRGB(155, 158, 165),
    Border = Color3.fromRGB(55, 57, 63),
    Red = Color3.fromRGB(220, 95, 95)
}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DerSpalterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Ana pencere
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(340, 225)
Main.Position = UDim2.new(0.5, -170, 0.5, -112)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius =
    UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Colors.Border
Stroke.Thickness = 1
Stroke.Parent = Main

-- Mobil / PC ölçeklendirmesi
local UIScale = Instance.new("UIScale")
UIScale.Parent = Main

local function UpdateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize
    local scale = math.min(
        viewport.X / 370,
        viewport.Y / 270,
        1
    )

    UIScale.Scale = math.clamp(scale, 0.65, 1)
end

UpdateScale()

local function ConnectCamera(camera)
    if not camera then return end

    camera:GetPropertyChangedSignal("ViewportSize"):Connect(
        UpdateScale
    )

    UpdateScale()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(
    function()
        ConnectCamera(workspace.CurrentCamera)
    end
)

-- Başlık çubuğu
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Colors.Header
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(14, 0)
Title.BackgroundTransparency = 1
Title.Text = "DerSpalter Hub"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Düğme oluşturucu
local function CreateButton(parent, name, text, size, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Colors.Button
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Colors.Text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.AutoButtonColor = false
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 7)

    button.MouseEnter:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Colors.Border}
        ):Play()
    end)

    button.MouseLeave:Connect(function()
        if button.Parent then
            TweenService:Create(
                button,
                TweenInfo.new(0.15),
                {BackgroundColor3 = Colors.Button}
            ):Play()
        end
    end)

    return button
end

-- Küçültme düğmesi
local MinimizeBtn = CreateButton(
    Header,
    "Minimize",
    "−",
    UDim2.fromOffset(34, 30),
    UDim2.new(1, -76, 0, 6)
)
MinimizeBtn.TextSize = 19

-- Kapatma düğmesi
local CloseBtn = CreateButton(
    Header,
    "Close",
    "×",
    UDim2.fromOffset(34, 30),
    UDim2.new(1, -38, 0, 6)
)
CloseBtn.TextColor3 = Colors.Red
CloseBtn.TextSize = 19

-- İçerik alanı
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -24, 1, -56)
Content.Position = UDim2.fromOffset(12, 50)
Content.BackgroundTransparency = 1
Content.Parent = Main

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Size = UDim2.new(1, 0, 0, 24)
SectionTitle.BackgroundTransparency = 1
SectionTitle.Text = "GENEL"
SectionTitle.TextColor3 = Colors.Muted
SectionTitle.Font = Enum.Font.GothamMedium
SectionTitle.TextSize = 11
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.Parent = Content

-- Auto Rep arayüz düğmesi
-- Bu prototipte yalnızca görsel durumu değiştirir.
local ToggleBtn = CreateButton(
    Content,
    "FeatureToggle",
    "Auto Rep  •  KAPALI",
    UDim2.new(1, 0, 0, 42),
    UDim2.fromOffset(0, 32)
)

local enabled = false

ToggleBtn.Activated:Connect(function()
    enabled = not enabled

    if enabled then
        ToggleBtn.Text = "Auto Rep  •  AÇIK"
        ToggleBtn.BackgroundColor3 = Colors.Accent
        ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    else
        ToggleBtn.Text = "Auto Rep  •  KAPALI"
        ToggleBtn.BackgroundColor3 = Colors.Button
        ToggleBtn.TextColor3 = Colors.Text
    end
end)

-- Alt bilgi
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 22)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Text = "DerSpalter • Minimal Edition"
Footer.TextColor3 = Colors.Muted
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.TextXAlignment = Enum.TextXAlignment.Left
Footer.Parent = Content

-- Küçültme / geri açma
local minimized = false

MinimizeBtn.Activated:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized

    local targetSize

    if minimized then
        targetSize = UDim2.fromOffset(340, 42)
        MinimizeBtn.Text = "+"
    else
        targetSize = UDim2.fromOffset(340, 225)
        MinimizeBtn.Text = "−"
    end

    TweenService:Create(
        Main,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {Size = targetSize}
    ):Play()
end)

-- Kapatma
CloseBtn.Activated:Connect(function()
    ScreenGui:Destroy()
end)

-- Sürükleme: fare ve dokunmatik
local dragging = false
local dragStart
local startPosition
local dragInput

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

print("DerSpalter Hub Minimal Edition yüklendi")
