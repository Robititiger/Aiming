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
            PlayersModel = child
            print("Found PlayersModel: " .. child.Name)
            return
        end
    end
    print("No valid PlayersModel found.")
end

-- // Call the initialization function
InitializePlayersModel()

-- // Get the character of a player
function AimingUtilities.Character(Player)
    -- Only look for other players' characters in PlayersModel
    if Player ~= LocalPlayer then
        if PlayersModel then
            local character = PlayersModel:FindFirstChild(Player.Name) -- Find the character under PlayersModel
            if character then
                print("Character found for player: " .. Player.Name)
            else
                -- Only print for other players
                print("Character not found for player: " .. Player.Name)
            end
            return character
        end
        print("PlayersModel is nil, cannot find characters.")
    end
    -- Return nil for the local player since their character is not in PlayersModel
    return nil
end

-- // Custom Team Check
function AimingUtilities.TeamMatch(PlayerA, PlayerB)
    -- Implement your custom team check logic here
    -- For example, you can check if both players are in the same team
    local teamA = PlayerA.Team
    local teamB = PlayerB.Team
    return teamA == teamB
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

-- // Return Aiming Module
return Aiming
