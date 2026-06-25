--====================================
-- MOBILE FLY + NOCLIP (FULL FIX)
-- SPEED 180
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- CONFIG
local FLY_SPEED = 200
local flying = false

-- BODY
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.P = 9e4

-- NOCLIP
local function setNoclip(state)
	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = not state
		end
	end
end

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromScale(0.28, 0.08)
btn.Position = UDim2.fromScale(0.62, 0.85)
btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
btn.TextColor3 = Color3.fromRGB(0,255,255)
btn.TextScaled = true
btn.Text = "FLY : OFF"
btn.Draggable = true

-- TOGGLE
btn.MouseButton1Click:Connect(function()
	flying = not flying
	btn.Text = flying and "FLY : ON" or "FLY : OFF"

	if flying then
		bv.Parent = hrp
		bg.Parent = hrp
		humanoid.PlatformStand = true
		setNoclip(true)
	else
		bv.Parent = nil
		bg.Parent = nil
		humanoid.PlatformStand = false
		setNoclip(false)
	end
end)

-- FLY LOGIC (mượt + đỡ lỗi)
RunService.RenderStepped:Connect(function()
	if flying and hrp then
		bg.CFrame = camera.CFrame
		bv.Velocity = (camera.CFrame.LookVector * FLY_SPEED) + Vector3.new(0,2,0)
	end
end)

-- RESET
humanoid.Died:Connect(function()
	flying = false
	bv.Parent = nil
	bg.Parent = nil
	setNoclip(false)
end)

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end)
