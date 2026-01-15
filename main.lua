--[[ 
🧬 Sasha SCP Hub
👑 Author: Sasha Panov
⚙ Executor: Delta
🎮 Game: MM2 / Universal
]]

-- UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "🧬 Sasha SCP Hub",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "SashaSCP"
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--------------------------------------------------
-- 🧠 SMART AUTOFARM
--------------------------------------------------
local AutoFarm = false

local FarmTab = Window:MakeTab({
	Name = "🧠 AutoFarm",
	Icon = "rbxassetid://4483345998"
})

local function GetNearestCoin()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	local dist, coin = math.huge, nil
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name:lower():find("coin") then
			local d = (v.Position - hrp.Position).Magnitude
			if d < dist then
				dist = d
				coin = v
			end
		end
	end
	return coin
end

FarmTab:AddToggle({
	Name = "Smart AutoFarm",
	Default = false,
	Callback = function(v)
		AutoFarm = v
		task.spawn(function()
			while AutoFarm do
				task.wait(0.25)
				pcall(function()
					local coin = GetNearestCoin()
					if coin and LocalPlayer.Character then
						LocalPlayer.Character.HumanoidRootPart.CFrame =
							CFrame.new(coin.Position + Vector3.new(0,2,0))
					end
				end)
			end
		end)
	end
})

--------------------------------------------------
-- 👁 SCP ESP (MM2)
--------------------------------------------------
local ESPTab = Window:MakeTab({
	Name = "👁 SCP ESP",
	Icon = "rbxassetid://4483345998"
})

local function ApplyESP(plr, color)
	if plr.Character and plr.Character:FindFirstChild("Head") then
		if plr.Character.Head:FindFirstChild("SCP_ESP") then
			plr.Character.Head.SCP_ESP:Destroy()
		end

		local gui = Instance.new("BillboardGui", plr.Character.Head)
		gui.Name = "SCP_ESP"
		gui.Size = UDim2.new(0,120,0,40)
		gui.AlwaysOnTop = true

		local txt = Instance.new("TextLabel", gui)
		txt.Size = UDim2.new(1,0,1,0)
		txt.BackgroundTransparency = 1
		txt.Text = plr.Name
		txt.TextColor3 = color
		txt.TextScaled = true
	end
end

ESPTab:AddButton({
	Name = "Enable SCP ESP",
	Callback = function()
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				if plr.Backpack:FindFirstChild("Knife") then
					ApplyESP(plr, Color3.fromRGB(255,0,0)) -- Murder
				elseif plr.Backpack:FindFirstChild("Gun") then
					ApplyESP(plr, Color3.fromRGB(0,0,255)) -- Sheriff
				else
					ApplyESP(plr, Color3.fromRGB(0,255,0)) -- Innocent
				end
			end
		end
	end
})

--------------------------------------------------
-- 🧍 PLAYER
--------------------------------------------------
local PlayerTab = Window:MakeTab({
	Name = "🧍 Player",
	Icon = "rbxassetid://4483345998"
})

PlayerTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Callback = function(v)
		if LocalPlayer.Character then
			LocalPlayer.Character.Humanoid.WalkSpeed = v
		end
	end
})

PlayerTab:AddSlider({
	Name = "JumpPower",
	Min = 50,
	Max = 300,
	Default = 50,
	Callback = function(v)
		if LocalPlayer.Character then
			LocalPlayer.Character.Humanoid.JumpPower = v
		end
	end
})

local InfJump = false
PlayerTab:AddToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(v)
		InfJump = v
	end
})

UIS.JumpRequest:Connect(function()
	if InfJump and LocalPlayer.Character then
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

--------------------------------------------------
-- 🎯 TARGET / AIMLOCK
--------------------------------------------------
local TargetTab = Window:MakeTab({
	Name = "🎯 Target",
	Icon = "rbxassetid://4483345998"
})

local TargetName = ""
local AimLock = false

TargetTab:AddTextbox({
	Name = "Target Player",
	Default = "",
	Callback = function(v)
		TargetName = v
	end
})

TargetTab:AddToggle({
	Name = "AimLock",
	Default = false,
	Callback = function(v)
		AimLock = v
	end
})

RunService.RenderStepped:Connect(function()
	if AimLock and TargetName ~= "" then
		local plr = Players:FindFirstChild(TargetName)
		if plr and plr.Character and plr.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.Head.Position)
		end
	end
end)

--------------------------------------------------
OrionLib:Init()
