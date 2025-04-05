--[[
    Information:

    - DEADZONE CLASSIC (https://www.roblox.com/games/3221241066/)
]]

-- // Dependencies
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Module.lua"))()
local AimingUtilities = Aiming.Utilities
local AimingChecks = Aiming.Checks

-- // Vars
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // Find the model that holds all other players' character models
local PlayersModel = nil
for _, child in pairs(Workspace:GetChildren()) do
    if child:IsA("Model") and child.Name == "Model" then
        PlayersModel = child
        break
    end
end

-- //
function AimingUtilities.Character(Player)
    if PlayersModel then
        return PlayersModel:FindFirstChild(Player.Name)
    end
    return nil
end

-- // Custom Team Check
function AimingUtilities.TeamMatch(PlayerA, PlayerB)
    -- Check if PlayerB has a "Dot" object under the Camera
    local Camera = Workspace:FindFirstChild("Camera")
    if Camera then
        for _, dot in pairs(Camera:GetChildren()) do
            if dot:IsA("Part") and dot.Name == "Dot" then
                local motor = dot:FindFirstChild("Motor")
                if motor and motor.Part0 then
                    -- Check if the Part0 points to PlayerB's HumanoidRootPart
                    local character = AimingUtilities.Character(PlayerB)
                    if character and motor.Part0 == character:FindFirstChild("HumanoidRootPart") then
                        return true -- PlayerB is an ally
                    end
                end
            end
        end
    end
    return false -- PlayerB is not an ally
end

-- //
function AimingChecks.Health(Character, Player)
    -- // Get Humanoid
    Character = Character or AimingUtilities.Character(Player)
    local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

    -- // Get Health
    local Health = (Humanoid and Humanoid.Health or 0)

    -- //
    return Health > 0
end

-- //
function AimingChecks.Forcefield(Character, Player)
    -- // Get character
    Character = Character or AimingUtilities.Character(Player)
    local Forcefield = Character:FindFirstChildWhichIsA("ForceField")

    -- // Return
    return Forcefield == nil
end

-- //
function AimingChecks.Invisible(Part)
    return Part.Transparency == 1
end

-- //
function AimingChecks.Custom(Character, Player)
    return true
end

-- //
function Aiming.BeizerCurve.ManagerB.Function(Pitch, Yaw)
    local RotationMatrix = CFrame.fromEulerAnglesYXZ(Pitch, Yaw, 0)
    local CurrentCamera = Workspace.CurrentCamera
    CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position) * RotationMatrix
end

-- // Return
return Aiming
