--[[
    LeaderboardManager.server.lua
    Manages player statistics and leaderboard
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- Wait for RemoteEvents folder
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Create RemoteEvents for leaderboard
local leaderboardUpdateEvent = Instance.new("RemoteEvent")
leaderboardUpdateEvent.Name = "LeaderboardUpdate"
leaderboardUpdateEvent.Parent = remoteEventsFolder

-- Note: DataStores don't work in Studio by default, so we'll use a local storage system
local playerStats = {}
local globalLeaderboard = {}

-- Initialize player stats
local function initializePlayerStats(player)
    playerStats[player.UserId] = {
        bestTime = nil,
        attempts = 0,
        checkpointsReached = 0,
        joinTime = tick()
    }
    
    -- Create leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local bestTime = Instance.new("StringValue")
    bestTime.Name = "Best Time"
    bestTime.Value = "N/A"
    bestTime.Parent = leaderstats
    
    local attempts = Instance.new("IntValue")
    attempts.Name = "Attempts"
    attempts.Value = 0
    attempts.Parent = leaderstats
    
    local checkpoints = Instance.new("IntValue")
    checkpoints.Name = "Checkpoints"
    checkpoints.Value = 0
    checkpoints.Parent = leaderstats
    
    print("Initialized stats for " .. player.Name)
end

-- Update player's best time
local function updateBestTime(player, newTime)
    local stats = playerStats[player.UserId]
    if not stats then return end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local bestTimeValue = leaderstats:FindFirstChild("Best Time")
    local attemptsValue = leaderstats:FindFirstChild("Attempts")
    
    -- Update attempts
    stats.attempts = stats.attempts + 1
    if attemptsValue then
        attemptsValue.Value = stats.attempts
    end
    
    -- Check if this is a new best time
    if not stats.bestTime or newTime < stats.bestTime then
        stats.bestTime = newTime
        if bestTimeValue then
            bestTimeValue.Value = string.format("%.2f", newTime) .. "s"
        end
        
        -- Update global leaderboard
        updateGlobalLeaderboard(player, newTime)
        
        print(player.Name .. " set a new best time: " .. string.format("%.2f", newTime) .. " seconds!")
        return true
    end
    
    return false
end

-- Update checkpoint progress
local function updateCheckpointProgress(player, checkpointNumber)
    local stats = playerStats[player.UserId]
    if not stats then return end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local checkpointsValue = leaderstats:FindFirstChild("Checkpoints")
    
    if checkpointNumber > stats.checkpointsReached then
        stats.checkpointsReached = checkpointNumber
        if checkpointsValue then
            checkpointsValue.Value = stats.checkpointsReached
        end
    end
end

-- Update global leaderboard
local function updateGlobalLeaderboard(player, time)
    -- Remove old entry if exists
    for i, entry in ipairs(globalLeaderboard) do
        if entry.userId == player.UserId then
            table.remove(globalLeaderboard, i)
            break
        end
    end
    
    -- Add new entry
    table.insert(globalLeaderboard, {
        userId = player.UserId,
        playerName = player.Name,
        time = time
    })
    
    -- Sort by time (ascending)
    table.sort(globalLeaderboard, function(a, b)
        return a.time < b.time
    end)
    
    -- Keep only top 10
    if #globalLeaderboard > 10 then
        for i = 11, #globalLeaderboard do
            table.remove(globalLeaderboard, i)
        end
    end
    
    -- Broadcast updated leaderboard to all players
    broadcastLeaderboard()
end

-- Broadcast leaderboard to all players
local function broadcastLeaderboard()
    local leaderboardData = {}
    for i, entry in ipairs(globalLeaderboard) do
        table.insert(leaderboardData, {
            rank = i,
            playerName = entry.playerName,
            time = string.format("%.2f", entry.time) .. "s"
        })
    end
    
    leaderboardUpdateEvent:FireAllClients(leaderboardData)
end

-- Handle player completing the obby
local function onFinishReached(player, data)
    local completionTime = data.completionTime
    local isNewBest = updateBestTime(player, completionTime)
    
    -- Send completion data back to client
    local responseData = {
        completionTime = completionTime,
        isNewBest = isNewBest,
        bestTime = playerStats[player.UserId].bestTime,
        rank = getRank(player.UserId)
    }
    
    -- You can add more completion logic here
end

-- Get player's rank on global leaderboard
local function getRank(userId)
    for i, entry in ipairs(globalLeaderboard) do
        if entry.userId == userId then
            return i
        end
    end
    return nil
end

-- Handle checkpoint reached
local function onCheckpointReached(player, data)
    updateCheckpointProgress(player, data.checkpointNumber)
end

-- Clean up when player leaves
local function onPlayerRemoving(player)
    if playerStats[player.UserId] then
        -- In a real game, you'd save to DataStore here
        playerStats[player.UserId] = nil
    end
end

-- Connect to RemoteEvents when they're available
local function connectRemoteEvents()
    local finishReached = remoteEventsFolder:WaitForChild("FinishReached")
    local checkpointReached = remoteEventsFolder:WaitForChild("CheckpointReached")
    
    finishReached.OnServerEvent:Connect(onFinishReached)
    checkpointReached.OnServerEvent:Connect(onCheckpointReached)
end

-- Connect events
Players.PlayerAdded:Connect(initializePlayerStats)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    initializePlayerStats(player)
end

-- Connect remote events (wait for them to be created)
spawn(connectRemoteEvents)

-- Broadcast leaderboard every 30 seconds
spawn(function()
    while true do
        wait(30)
        broadcastLeaderboard()
    end
end)

print("LeaderboardManager loaded successfully!")
