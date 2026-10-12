-- DerSpalter Hub v4 (Silence UI + Stats Panel)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/silencedevs/SilenceScripts/refs/heads/main/libraries/eleriumv2.luau?cache=" .. tostring(os.time()), true))()

local window = library:AddWindow("DerSpalter Hub", {
	main_color = Color3.fromRGB(120, 80, 220),
	min_size = Vector2.new(560, 700),
	can_resize = true,
})

local farmTab = window:AddTab("Farm")
local statsTab = window:AddTab("Stats")
local tpTab = window:AddTab("TP")
local infoTab = window:AddTab("Info")

getgenv().AutoRep = false
getgenv().FastAutoRep = false
getgenv().AutoRebirth = false
getgenv().LockPoint = false
getgenv().AutoSpin = false

LocalPlayer.Idled:Connect(function()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)

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

-- Normal Auto Rep
task.spawn(function()
	while true do
		if getgenv().AutoRep then
			pcall(function()
				if LocalPlayer:FindFirstChild("MuscleEvent") then
					for i = 1, 4 do
						LocalPlayer.MuscleEvent:FireServer("rep")
					end
				elseif LocalPlayer:FindFirstChild("muscleEvent") then
					for i = 1, 4 do
						LocalPlayer.muscleEvent:FireServer("rep")
					end
				end
			end)
		end
		task.wait(0.1)
	end
end)

-- Hızlı Auto Rep
task.spawn(function()
	while true do
		if getgenv().FastAutoRep then
			pcall(function()
				if LocalPlayer:FindFirstChild("MuscleEvent") then
					for i = 1, 28 do
						LocalPlayer.MuscleEvent:FireServer("rep")
					end
				elseif LocalPlayer:FindFirstChild("muscleEvent") then
					for i = 1, 28 do
						LocalPlayer.muscleEvent:FireServer("rep")
					end
				end
			end)
		end
		task.wait(0.04)
	end
end)

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
		task.wait(1)
	end
end)

local wheelRemote, wheelChances
pcall(function()
	wheelRemote = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("openFortuneWheelRemote")
end)
pcall(function()
	wheelChances = ReplicatedStorage:WaitForChild("shared"):WaitForChild("catalogs"):WaitForChild("fortuneWheelChances"):WaitForChild("Fortune Wheel")
end)

task.spawn(function()
	while true do
		if getgenv().AutoSpin then
			pcall(function()
				if wheelRemote and wheelChances then
					wheelRemote:InvokeServer("openFortuneWheel", wheelChances)
				end
			end)
		end
		task.wait(1)
	end
end)

-- Sayı formatlama
local function formatNumber(n)
	if n >= 1e18 then return string.format("%.2fQi", n / 1e18)
	elseif n >= 1e15 then return string.format("%.2fQa", n / 1e15)
	elseif n >= 1e12 then return string.format("%.2fT", n / 1e12)
	elseif n >= 1e9 then return string.format("%.2fB", n / 1e9)
	elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
	elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
	else return string.format("%.0f", n) end
end

local function formatTime(seconds)
	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)
	return string.format("%dd %dh %dm %ds", days, hours, mins, secs)
end

-- Stats verileri
local StatsData = {
	Running = false,
	StartTime = 0,
	StartStrength = 0,
	CurrentStrength = 0,
	Gained = 0,
}

-- Strength değerini al
local function getStrength()
	local ok, val = pcall(function()
		return LocalPlayer.leaderstats.Strength.Value
	end)
	return ok and val or 0
end

-- ============================
-- FARM SEKMESİ
-- ============================
farmTab:AddLabel("Strength Farming:")
farmTab:AddSwitch("Auto Rep (Normal)", function(state) getgenv().AutoRep = state end)
farmTab:AddSwitch("Auto Rep (Hızlı)", function(state)
	getgenv().FastAutoRep = state
	if state then
		StatsData.Running = true
		StatsData.StartTime = tick()
		StatsData.StartStrength = getStrength()
		StatsData.Gained = 0
	else
		StatsData.Running = false
	end
end)
farmTab:AddSwitch("Auto Rebirth", function(state) getgenv().AutoRebirth = state end)
farmTab:AddSwitch("Lock Point", function(state) getgenv().LockPoint = state end)
farmTab:AddLabel("Not: Lock Point açıkken karakter olduğu yerde kalır.")

farmTab:AddLabel("")
farmTab:AddLabel("Çark Çevirme:")
farmTab:AddSwitch("Auto Spin Fortune Wheel", function(state) getgenv().AutoSpin = state end)

-- ============================
-- STATS SEKMESİ
-- ============================
statsTab:AddLabel("Hızlı Farm İstatistikleri:")
statsTab:AddLabel("Hızlı Auto Rep açıldığında otomatik başlar.")
statsTab:AddLabel("")

local timerLabel = statsTab:AddLabel("⏱️ Süre: 0d 0h 0m 0s")
local gainedLabel = statsTab:AddLabel("💪 Kazanılan Strength: 0")
local startLabel = statsTab:AddLabel("📊 Başlangıç Strength: 0")
local currentLabel = statsTab:AddLabel("📊 Şu Anki Strength: 0")
statsTab:AddLabel("")
local hourLabel = statsTab:AddLabel("📈 Saatlik: 0")
local dayLabel = statsTab:AddLabel("📈 Günlük: 0")
local weekLabel = statsTab:AddLabel("📈 Haftalık: 0")
local monthLabel = statsTab:AddLabel("📈 Aylık: 0")

statsTab:AddLabel("")
statsTab:AddButton("Sıfırla", function()
	StatsData.StartTime = tick()
	StatsData.StartStrength = getStrength()
	StatsData.Gained = 0
end)

task.spawn(function()
	while true do
		task.wait(0.5)
		if StatsData.Running then
			local elapsed = tick() - StatsData.StartTime
			local current = getStrength()
			local gained = current - StatsData.StartStrength

			StatsData.CurrentStrength = current
			StatsData.Gained = gained

			timerLabel.Text = "⏱️ Süre: " .. formatTime(elapsed)
			gainedLabel.Text = "💪 Kazanılan Strength: " .. formatNumber(gained)
			startLabel.Text = "📊 Başlangıç Strength: " .. formatNumber(StatsData.StartStrength)
			currentLabel.Text = "📊 Şu Anki Strength: " .. formatNumber(current)

			if elapsed > 1 and gained > 0 then
				local perSecond = gained / elapsed
				hourLabel.Text = "📈 Saatlik: " .. formatNumber(perSecond * 3600)
				dayLabel.Text = "📈 Günlük: " .. formatNumber(perSecond * 86400)
				weekLabel.Text = "📈 Haftalık: " .. formatNumber(perSecond * 604800)
				monthLabel.Text = "📈 Aylık: " .. formatNumber(perSecond * 2592000)
			end
		end
	end
end)

-- ============================
-- TP SEKMESİ
-- ============================
local TP_LOCATIONS = {
	{name = "Jungle Gym",          pos = Vector3.new(-8173, 64, 1898)},
	{name = "Muscle King Gym",     pos = Vector3.new(-8646, 17, -5738)},
	{name = "Legends Gym",         pos = Vector3.new(4111, 1020, -3799)},
	{name = "Mythical Gym",        pos = Vector3.new(2371, 39, 1246)},
	{name = "Frost Gym",           pos = Vector3.new(-3013, 39, -335)},
	{name = "Eternal Gym",         pos = Vector3.new(-7176, 45, -1106)},
	{name = "Industrial Gym",      pos = Vector3.new(-5254, 58, 4931)},
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
	{name = "Brawl Lava",          pos = Vector3.new(4471, 119, -8836)},
	{name = "Brawl Desert",        pos = Vector3.new(960, 17, -7398)},
	{name = "Brawl Regular",       pos = Vector3.new(-1849, 20, -6335)},
}

tpTab:AddLabel("Teleport Noktaları:")
tpTab:AddLabel("TP atınca Lock Point otomatik kapanır.")

for _, loc in ipairs(TP_LOCATIONS) do
	tpTab:AddButton(loc.name, function()
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			if getgenv().LockPoint then getgenv().LockPoint = false end
			char.HumanoidRootPart.CFrame = CFrame.new(loc.pos + Vector3.new(0, 3, 0))
		end
	end)
end

-- ============================
-- INFO SEKMESİ
-- ============================
infoTab:AddLabel("DerSpalter Hub v4")
infoTab:AddLabel("Anti-AFK otomatik çalışır.")
infoTab:AddLabel("Lock Point açıkken karakter olduğu yerde kalır.")
infoTab:AddLabel("TP atınca Lock Point otomatik kapanır.")
infoTab:AddLabel("")
infoTab:AddLabel("Farm sekmesinden özellikleri açıp kapatabilirsin.")
infoTab:AddLabel("TP sekmesinden istediğin yere ışınlanabilirsin.")
infoTab:AddLabel("Stats sekmesi Hızlı Auto Rep açıkken otomatik sayar.")

print("DerSpalter Hub v4 yüklendi (Stats Panel)")
