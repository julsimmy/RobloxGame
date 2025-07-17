--[[
    PlayerDataModule.lua
    Shared module for handling player data structure
--]]

local PlayerDataModule = {}

-- Create new player data structure
function PlayerDataModule.CreatePlayerData(player)
    return {
        userId = player.UserId,
        displayName = player.DisplayName or player.Name,
        currentCheckpoint = 0,
        startTime = tick(),
        bestTime = nil,
        attempts = 0,
        checkpointTimes = {},
        isPlaying = true,
        lastReset = 0,
        joinTime = tick()
    }
end

-- Validate player data structure
function PlayerDataModule.ValidatePlayerData(data)
    if type(data) ~= "table" then return false end
    
    local requiredFields = {
        "userId", "displayName", "currentCheckpoint", 
        "startTime", "attempts", "checkpointTimes", "isPlaying"
    }
    
    for _, field in ipairs(requiredFields) do
        if data[field] == nil then
            warn("Missing required field: " .. field)
            return false
        end
    end
    
    return true
end

-- Reset player progress
function PlayerDataModule.ResetProgress(data)
    if not PlayerDataModule.ValidatePlayerData(data) then
        return false
    end
    
    data.currentCheckpoint = 0
    data.startTime = tick()
    data.checkpointTimes = {}
    data.isPlaying = true
    data.attempts = data.attempts + 1
    
    return true
end

-- Update checkpoint progress
function PlayerDataModule.UpdateCheckpoint(data, checkpointNumber)
    if not PlayerDataModule.ValidatePlayerData(data) then
        return false
    end
    
    if checkpointNumber <= data.currentCheckpoint then
        return false -- Already reached this checkpoint
    end
    
    data.currentCheckpoint = checkpointNumber
    data.checkpointTimes[checkpointNumber] = tick() - data.startTime
    
    return true
end

-- Complete the game
function PlayerDataModule.CompleteGame(data)
    if not PlayerDataModule.ValidatePlayerData(data) then
        return false, 0
    end
    
    local completionTime = tick() - data.startTime
    local isNewBest = false
    
    if not data.bestTime or completionTime < data.bestTime then
        data.bestTime = completionTime
        isNewBest = true
    end
    
    data.attempts = data.attempts + 1
    
    return true, completionTime, isNewBest
end

-- Get formatted statistics
function PlayerDataModule.GetFormattedStats(data)
    if not PlayerDataModule.ValidatePlayerData(data) then
        return {}
    end
    
    return {
        bestTime = data.bestTime and string.format("%.2f", data.bestTime) .. "s" or "N/A",
        attempts = tostring(data.attempts),
        checkpoints = tostring(data.currentCheckpoint),
        currentTime = string.format("%.2f", tick() - data.startTime) .. "s"
    }
end

-- Check if player can reset (cooldown)
function PlayerDataModule.CanReset(data, cooldownTime)
    if not PlayerDataModule.ValidatePlayerData(data) then
        return false
    end
    
    cooldownTime = cooldownTime or 2
    return (tick() - data.lastReset) >= cooldownTime
end

-- Mark reset time
function PlayerDataModule.MarkReset(data)
    if not PlayerDataModule.ValidatePlayerData(data) then
        return false
    end
    
    data.lastReset = tick()
    return true
end

return PlayerDataModule
