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

-- // Initialize the PlayersModel variable
local PlayersModel = nil

-- // Function to find the correct Model containing player characters
local function InitializePlayersModel()
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("Model") and child.Name == "Model" then
            -- Check if this model contains any player characters
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and child:FindFirstChild(player.Name) then
                    PlayersModel = child
                    print("Found PlayersModel: " .. child.Name)
                    return
                end
            end
        end
    end
    print("No valid PlayersModel found.")
end

-- // Call the initialization function
InitializePlayersModel()

-- // Get the character of a player
function AimingUtilities.Character(Player)
    if Player == LocalPlayer then
        return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() -- Return local player's character
    end

    if PlayersModel then
        local character = PlayersModel:FindFirstChild(Player.Name) -- Find the character under PlayersModel
        if character then
            print("Character found for player: " .. Player.Name)
        else
            print("Character not found for player: " .. Player.Name)
        end
        return character
    end
    print("PlayersModel is nil, cannot find characters.")
    return nil -- Return nil if the model doesn't exist
end

-- // Custom Team Check
function AimingUtilities.TeamMatch(PlayerA, PlayerB)
    local Camera = Workspace:FindFirstChild("Camera")
    if Camera then
        for _, dot in pairs(Camera:GetChildren()) do
            if dot:IsA("Part") and dot.Name == "Dot" then
                local motor = dot:FindFirstChild("Motor")
                if motor and motor.Part0 then
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

-- // Debugging: Print all children in PlayersModel
if PlayersModel then
    for _, child in pairs(PlayersModel:GetChildren()) do
        print("Found character in PlayersModel: " .. child.Name)
    end
else
    print("PlayersModel is nil, cannot find characters.")
end

-- // Health Check
function AimingChecks.Health(Character, Player)
    Character = Character or AimingUtilities.Character(Player)
    if Character then
        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        local Health = (Humanoid and Humanoid.Health or 0)
        return Health > 0
    end
    return false
end

-- // Forcefield Check
function AimingChecks.Forcefield(Character, Player)
    Character = Character or AimingUtilities.Character(Player)
    if Character then
        local Forcefield = Character:FindFirstChildWhichIsA("ForceField")
        return Forcefield == nil
    end
    return false
end

-- // Visibility Check
function AimingChecks.Invisible(Part)
    return Part.Transparency == 1
end

-- // Custom Check
function AimingChecks.Custom(Character, Player)
    return true
end

-- // Bezier Curve Function
function Aiming.BeizerCurve.ManagerB.Function(Pitch, Yaw)
    local RotationMatrix = CFrame.fromEulerAnglesYXZ(Pitch, Yaw, 0)
    local CurrentCamera = Workspace.CurrentCamera
    CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position) * RotationMatrix
end

-- // Return Aiming Module
return Aiming
