--[[
    CheckpointManager.server.lua
    Handles checkpoint detection and player progress tracking
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Wait for RemoteEvents folder
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Create RemoteEvents for checkpoints
local checkpointReachedEvent = Instance.new("RemoteEvent")
checkpointReachedEvent.Name = "CheckpointReached"
checkpointReachedEvent.Parent = remoteEventsFolder

local finishReachedEvent = Instance.new("RemoteEvent")
finishReachedEvent.Name = "FinishReached"
finishReachedEvent.Parent = remoteEventsFolder

local resetPlayerEvent = Instance.new("RemoteEvent")
resetPlayerEvent.Name = "ResetPlayer"
resetPlayerEvent.Parent = remoteEventsFolder

-- Player checkpoint data
local playerCheckpoints = {}

-- Initialize player checkpoint data
local function initializePlayer(player)
    playerCheckpoints[player.UserId] = {
        currentCheckpoint = 0,
        startTime = tick(),
        checkpointTimes = {}
    }
end

-- Handle checkpoint touching
local function onCheckpointTouched(hit, checkpointNumber)
    local character = hit.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local player = Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    local playerData = playerCheckpoints[player.UserId]
    if not playerData then return end
    
    -- Only progress if this is the next checkpoint
    if checkpointNumber == playerData.currentCheckpoint + 1 then
        playerData.currentCheckpoint = checkpointNumber
        playerData.checkpointTimes[checkpointNumber] = tick() - playerData.startTime
        
        print(player.Name .. " reached checkpoint " .. checkpointNumber)
        
        -- Fire event to client
        checkpointReachedEvent:FireClient(player, {
            checkpointNumber = checkpointNumber,
            time = playerData.checkpointTimes[checkpointNumber],
            message = "Checkpoint " .. checkpointNumber .. " reached!"
        })
        
        -- Visual feedback
        local checkpoint = workspace:FindFirstChild("Checkpoint" .. checkpointNumber)
        if checkpoint then
            -- Change color temporarily
            local originalColor = checkpoint.BrickColor
            checkpoint.BrickColor = BrickColor.new("Bright red")
            wait(0.5)
            checkpoint.BrickColor = originalColor
        end
    end
end

-- Handle finish line touching
local function onFinishTouched(hit)
    local character = hit.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local player = Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    local playerData = playerCheckpoints[player.UserId]
    if not playerData then return end
    
    local completionTime = tick() - playerData.startTime
    
    print(player.Name .. " finished the obby in " .. string.format("%.2f", completionTime) .. " seconds!")
    
    -- Fire event to client
    finishReachedEvent:FireClient(player, {
        completionTime = completionTime,
        checkpointTimes = playerData.checkpointTimes,
        message = "Congratulations! You completed the obby!"
    })
    
    -- Reset for another attempt
    playerData.currentCheckpoint = 0
    playerData.startTime = tick()
    playerData.checkpointTimes = {}
end

-- Reset player to their current checkpoint
local function resetPlayerToCheckpoint(player)
    local playerData = playerCheckpoints[player.UserId]
    if not playerData then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Find the current checkpoint
    local checkpointName = "Checkpoint" .. playerData.currentCheckpoint
    if playerData.currentCheckpoint == 0 then
        -- Go to spawn
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            humanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        end
    else
        local checkpoint = workspace:FindFirstChild(checkpointName)
        if checkpoint then
            humanoidRootPart.CFrame = checkpoint.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- Connect checkpoint touch events
local function connectCheckpoints()
    -- Connect all existing checkpoints
    for i = 1, 10 do -- Check for up to 10 checkpoints
        local checkpoint = workspace:FindFirstChild("Checkpoint" .. i)
        if checkpoint then
            checkpoint.Touched:Connect(function(hit)
                onCheckpointTouched(hit, i)
            end)
            print("Connected Checkpoint" .. i)
        end
    end
    
    -- Connect finish line
    local finish = workspace:FindFirstChild("Finish")
    if finish then
        finish.Touched:Connect(onFinishTouched)
        print("Connected Finish line")
    end
end

-- Handle player joining
local function onPlayerAdded(player)
    initializePlayer(player)
    
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Reset on death
        humanoid.Died:Connect(function()
            wait(5) -- Wait for respawn
            resetPlayerToCheckpoint(player)
        end)
    end)
end

-- Handle player leaving
local function onPlayerRemoving(player)
    if playerCheckpoints[player.UserId] then
        playerCheckpoints[player.UserId] = nil
    end
end

-- Handle reset requests from client
resetPlayerEvent.OnServerEvent:Connect(function(player)
    resetPlayerToCheckpoint(player)
end)

-- Connect events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Wait a moment for game elements to load, then connect checkpoints
wait(2)
connectCheckpoints()

print("CheckpointManager loaded successfully!")
