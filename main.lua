--[[ 
🔥 Sasha SCP Hub v2
👑 Author: Sasha Panov
⚙ Executor: Delta
🧠 MM2 / Universal
]]

---------------- KEY SYSTEM ----------------
local VALID_KEY = "SASHA-2026"

local function RequestKey()
    return game:GetService("Players").LocalPlayer:Kick("❌ Invalid Key\nBuy key from Sasha")
end

if getgenv().KEY == nil or getgenv().KEY ~= VALID_KEY then
    RequestKey()
    return
end

---------------- UI LOAD ----------------
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "🧬 Sasha SCP Hub",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "SashaSCP"
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------
-- AUTO FARM SMART
------------------------------------------------
local AutoFarm = false

local FarmTab = Window:MakeTab({
	Name = "🧠 Smart Farm",
	Icon = "rbxassetid://4483345998"
})

local function GetNearestCoin()
	local hrp = LocalPlayer.Character.HumanoidRootPart
	local dist, target = math.huge, nil
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name:lower():find("coin") then
			local d = (v.Position - hrp.Position).Magnitude
			if d < dist then
				dist = d
				target = v
			end
		end
	end
	return target
end

FarmTab:AddToggle({
	Name = "Smart Auto Farm",
	Default = false,
	Callback = function(v)
		AutoFarm = v
		while AutoFarm do
			task.wait(0.2)
			pcall(function()
				local coin = GetNearestCoin()
				if coin then
					LocalPlayer.Character.HumanoidRootPart.CFrame =
						CFrame.new(coin.Position + Vector3.new(0,2,0))
				end
			end)
		end
	end
})

------------------------------------------------
-- SCP ESP
------------------------------------------------
local ESPTab = Window:MakeTab({
	Name = "👁 SCP ESP",
	Icon = "rbxassetid://4483345998"
})

local function ApplyESP(plr,color)
	if plr.Character and plr.Character:FindFirstChild("Head") then
		local b = Instance.new("BillboardGui",plr.Character.Head)
		b.Size = UDim2.new(0,120,0,40)
		b.AlwaysOnTop = true
		local t = Instance.new("TextLabel",b)
		t.Size = UDim2.new(1,0,1,0)
		t.BackgroundTransparency = 1
		t.Text = plr.Name
		t.TextColor3 = color
		t.TextScaled = true
	end
end

ESPTab:AddButton({
	Name = "Enable SCP ESP",
	Callback = function()
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				if plr.Backpack:FindFirstChild("Knife") then
					ApplyESP(plr,Color3.fromRGB(255,0,0))
				elseif plr.Backpack:FindFirstChild("Gun") then
					ApplyESP(plr,Color3.fromRGB(0,0,255))
				else
					ApplyESP(plr,Color3.fromRGB(0,255,0))
				end
			end
		end
	end
})

------------------------------------------------
-- PLAYER (50+)
------------------------------------------------
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
		LocalPlayer.Character.Humanoid.WalkSpeed = v
	end
})

PlayerTab:AddSlider({
	Name = "JumpPower",
	Min = 50,
	Max = 300,
	Default = 50,
	Callback = function(v)
		LocalPlayer.Character.Humanoid.JumpPower = v
	end
})

PlayerTab:AddToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(v)
		getgenv().InfJump = v
	end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
	if getgenv().InfJump then
		LocalPlayer.Character.Humanoid:ChangeState("Jumping")
	end
end)

------------------------------------------------
-- TARGET
------------------------------------------------
local TargetTab = Window:MakeTab({
	Name = "🎯 Target",
	Icon = "rbxassetid://4483345998"
})

local TargetName
local AimLock = false

TargetTab:AddTextbox({
	Name = "Target Name",
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
	if AimLock and TargetName then
		local plr = Players:FindFirstChild(TargetName)
		if plr and plr.Character and plr.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.Head.Position)
		end
	end
end)

------------------------------------------------
OrionLib:Init()
