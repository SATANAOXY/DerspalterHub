-- DerSpalter Hub v4 (Silence UI)
-- eleriumv2 kütüphanesiyle yazıldı

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ============================
-- KÜTÜPHANEYİ YÜKLE (Silence'ın kütüphanesi)
-- ============================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/silencedevs/SilenceScripts/refs/heads/main/libraries/eleriumv2.luau?cache=" .. tostring(os.time()), true))()

-- ============================
-- PENCERE
-- ============================
local window = library:AddWindow("DerSpalter Hub", {
	main_color = Color3.fromRGB(120, 80, 220),
	min_size = Vector2.new(560, 700),
	can_resize = true,
})

-- ============================
-- SEKMELER
-- ============================
local farmTab = window:AddTab("Farm")
local tpTab = window:AddTab("TP")
local infoTab = window:AddTab("Info")

-- ============================
-- STATE
-- ============================
getgenv().AutoRep = false
getgenv().AutoRebirth = false
getgenv().LockPoint = false

-- ============================
-- ANTI-AFK
-- ============================
LocalPlayer.Idled:Connect(function()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
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

-- ============================
-- AUTO REP (orijinal hız)
-- ============================
task.spawn(function()
	while true do
		if getgenv().AutoRep then
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

-- ============================
-- AUTO REBIRTH
-- ============================
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

-- ============================
-- FARM SEKMESİ
-- ============================
farmTab:AddLabel("Strength Farming:")

farmTab:AddSwitch("Auto Rep", function(state)
	getgenv().AutoRep = state
end)

farmTab:AddSwitch("Auto Rebirth", function(state)
	getgenv().AutoRebirth = state
end)

farmTab:AddSwitch("Lock Point", function(state)
	getgenv().LockPoint = state
end)

farmTab:AddLabel("Not: Lock Point açıkken karakter olduğu yerde kalır.")

-- ============================
-- TP NOKTALARI
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
			if getgenv().LockPoint then
				getgenv().LockPoint = false
			end
			char.HumanoidRootPart.CFrame = CFrame.new(loc.pos + Vector3.new(0, 3, 0))
		end
	end)
end

-- ============================
-- INFO SEKMESİ (temiz)
-- ============================
infoTab:AddLabel("DerSpalter Hub v4")
infoTab:AddLabel("Anti-AFK otomatik çalışır.")
infoTab:AddLabel("Lock Point açıkken karakter olduğu yerde kalır.")
infoTab:AddLabel("TP atınca Lock Point otomatik kapanır.")
infoTab:AddLabel("")
infoTab:AddLabel("Farm sekmesinden özellikleri açıp kapatabilirsin.")
infoTab:AddLabel("TP sekmesinden istediğin yere ışınlanabilirsin.")

print("DerSpalter Hub v4 yüklendi")
