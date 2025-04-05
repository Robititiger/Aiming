--[[
    Information:

    - DEADZONE CLASSIC (https://www.roblox.com/games/3221241066/)
]]

-- // Dependencies
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robititiger/Aiming/main/Module.lua"))()
local AimingUtilities = Aiming.Utilities
local AimingChecks = Aiming.Checks

-- // Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // Vars
local PlayersModel = nil

-- // Find the model containing other players' characters
local function InitializePlayersModel()
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("Model") and child.Name == "Model" then
            -- Verify it contains at least one other player's character
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and child:FindFirstChild(player.Name) then
                    PlayersModel = child
                    print("Found valid PlayersModel")
                    return
                end
            end
        end
    end
    warn("PlayersModel not found!")
end

InitializePlayersModel()

-- // Get the character of a player
function AimingUtilities.Character(Player)
    if Player == LocalPlayer then
        -- Local player's character is in Workspace
        return LocalPlayer.Character
    end
    
    -- Check in PlayersModel first
    if PlayersModel then
        local character = PlayersModel:FindFirstChild(Player.Name)
        if character then
            return character
        end
    end

    -- Check directly in Workspace for player models
    local character = Workspace:FindFirstChild(Player.Name)
    return character
end

-- // Custom team check using Dot markers
function AimingUtilities.TeamMatch(PlayerA, PlayerB)
    local camera = Workspace:FindFirstChild("Camera")
    if not camera then return false end

    -- Check if PlayerB has a team marker
    for _, dot in pairs(camera:GetChildren()) do
        if dot:IsA("Part") and dot.Name == "Dot" then
            local motor = dot:FindFirstChild("Motor")
            if motor and motor.Part0 then
                local character = AimingUtilities.Character(PlayerB)
                if character and motor.Part0 == character:FindFirstChild("HumanoidRootPart") then
                    return true -- Is ally
                end
            end
        end
    end
    return false -- Is enemy
end

-- // Health check override
function AimingChecks.Health(Character, Player)
    Character = Character or AimingUtilities.Character(Player)
    if not Character then return false end
    
    local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
    return humanoid and humanoid.Health > 0
end

-- // Forcefield check override
function AimingChecks.Forcefield(Character, Player)
    Character = Character or AimingUtilities.Character(Player)
    return not Character:FindFirstChildWhichIsA("ForceField")
end

-- // Camera control for silent aim
function Aiming.BeizerCurve.ManagerB.Function(Pitch, Yaw)
    local RotationMatrix = CFrame.fromEulerAnglesYXZ(Pitch, Yaw, 0)
    Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position) * RotationMatrix
end

return Aiming
