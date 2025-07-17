--[[
    GameManager.server.lua
    Main server script that handles game initialization and core mechanics
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Create RemoteEvents folder if it doesn't exist
local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEventsFolder then
    remoteEventsFolder = Instance.new("Folder")
    remoteEventsFolder.Name = "RemoteEvents"
    remoteEventsFolder.Parent = ReplicatedStorage
end

-- Create RemoteEvents
local playerJoinedEvent = Instance.new("RemoteEvent")
playerJoinedEvent.Name = "PlayerJoined"
playerJoinedEvent.Parent = remoteEventsFolder

local gameStateEvent = Instance.new("RemoteEvent")
gameStateEvent.Name = "GameState"
gameStateEvent.Parent = remoteEventsFolder

local timerUpdateEvent = Instance.new("RemoteEvent")
timerUpdateEvent.Name = "TimerUpdate"
timerUpdateEvent.Parent = remoteEventsFolder

-- Game state variables
local gameState = {
    isActive = true,
    playerData = {}
}

-- Initialize player data when they join
local function onPlayerAdded(player)
    gameState.playerData[player.UserId] = {
        startTime = tick(),
        currentCheckpoint = 0,
        isPlaying = true,
        bestTime = nil
    }
    
    print(player.Name .. " joined the game!")
    
    -- Fire event to client
    playerJoinedEvent:FireClient(player, {
        message = "Welcome to the Obby! Touch checkpoints to save your progress.",
        startTime = gameState.playerData[player.UserId].startTime
    })
end

-- Clean up player data when they leave
local function onPlayerRemoving(player)
    if gameState.playerData[player.UserId] then
        gameState.playerData[player.UserId] = nil
    end
    print(player.Name .. " left the game!")
end

-- Reset player to their current checkpoint
local function resetPlayer(player)
    local playerData = gameState.playerData[player.UserId]
    if not playerData then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Find the current checkpoint
    local checkpointName = "Checkpoint" .. playerData.currentCheckpoint
    if playerData.currentCheckpoint == 0 then
        checkpointName = "SpawnLocation" -- Default spawn
    end
    
    local checkpoint = workspace:FindFirstChild(checkpointName)
    if checkpoint then
        humanoidRootPart.CFrame = checkpoint.CFrame + Vector3.new(0, 5, 0)
    else
        -- Fallback to spawn
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            humanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- Handle player respawning
local function onCharacterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Reset player when they die
    humanoid.Died:Connect(function()
        wait(3) -- Wait for respawn
        resetPlayer(player)
    end)
end

-- Create some basic moving platforms for the obby
local function createMovingPlatform(position, name)
    local platform = Instance.new("Part")
    platform.Name = name
    platform.Size = Vector3.new(8, 1, 8)
    platform.Position = position
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.Parent = workspace
    
    -- Add movement
    local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local goal = {Position = position + Vector3.new(0, 0, 20)}
    local tween = TweenService:Create(platform, tweenInfo, goal)
    tween:Play()
    
    return platform
end

-- Create sample checkpoints
local function createCheckpoint(position, checkpointNumber)
    local checkpoint = Instance.new("Part")
    checkpoint.Name = "Checkpoint" .. checkpointNumber
    checkpoint.Size = Vector3.new(6, 1, 6)
    checkpoint.Position = position
    checkpoint.Material = Enum.Material.Neon
    checkpoint.BrickColor = BrickColor.new("Bright green")
    checkpoint.Anchored = true
    checkpoint.CanCollide = false
    checkpoint.Parent = workspace
    
    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(0, 1, 0)
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Parent = checkpoint
    
    return checkpoint
end

-- Create finish line
local function createFinishLine(position)
    local finish = Instance.new("Part")
    finish.Name = "Finish"
    finish.Size = Vector3.new(10, 8, 2)
    finish.Position = position
    finish.Material = Enum.Material.Neon
    finish.BrickColor = BrickColor.new("Bright yellow")
    finish.Anchored = true
    finish.CanCollide = false
    finish.Parent = workspace
    
    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 1, 0)
    pointLight.Brightness = 3
    pointLight.Range = 15
    pointLight.Parent = finish
    
    return finish
end

-- Initialize game elements
local function initializeGame()
    -- Create sample obby elements (you can customize these)
    createMovingPlatform(Vector3.new(0, 5, 20), "MovingPlatform1")
    createMovingPlatform(Vector3.new(0, 10, 50), "MovingPlatform2")
    
    -- Create checkpoints
    createCheckpoint(Vector3.new(0, 5, 30), 1)
    createCheckpoint(Vector3.new(0, 10, 60), 2)
    createCheckpoint(Vector3.new(0, 15, 90), 3)
    
    -- Create finish line
    createFinishLine(Vector3.new(0, 20, 120))
    
    print("Game initialized with sample obby elements!")
end

-- Connect events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Connect character spawning
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end)

-- Handle existing players (for testing in Studio)
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Initialize the game
initializeGame()

print("GameManager loaded successfully!")
