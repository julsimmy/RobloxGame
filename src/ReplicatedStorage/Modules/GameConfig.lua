--[[
    GameConfig.lua
    Shared configuration module for the game
--]]

local GameConfig = {}

-- Game settings
GameConfig.Settings = {
    -- Timer settings
    TimerUpdateRate = 0.1, -- How often to update timer (seconds)
    
    -- Checkpoint settings
    CheckpointCooldown = 1, -- Seconds between checkpoint activations
    CheckpointHeight = 5, -- Height above checkpoint to spawn
    
    -- Leaderboard settings
    MaxLeaderboardEntries = 10,
    LeaderboardUpdateInterval = 30, -- Seconds
    
    -- UI settings
    NotificationDuration = 3, -- Seconds
    WelcomeMessageDuration = 10, -- Seconds
    
    -- Game mechanics
    RespawnDelay = 3, -- Seconds after death before respawn
    ResetCooldown = 2, -- Seconds between resets
}

-- Colors
GameConfig.Colors = {
    Checkpoint = Color3.new(0, 1, 0), -- Green
    CheckpointActive = Color3.new(1, 0, 0), -- Red (when touched)
    Finish = Color3.new(1, 1, 0), -- Yellow
    MovingPlatform = Color3.new(0, 0.5, 1), -- Blue
    
    -- UI Colors
    Success = Color3.new(0, 0.8, 0),
    Warning = Color3.new(1, 0.8, 0),
    Error = Color3.new(0.8, 0.3, 0.3),
    Info = Color3.new(0.2, 0.4, 0.8),
}

-- Messages
GameConfig.Messages = {
    Welcome = "Welcome to the Simple Obby! Touch checkpoints to save your progress.",
    CheckpointReached = "Checkpoint {number} reached!",
    GameComplete = "Congratulations! You completed the obby!",
    NewRecord = "🎉 New personal best!",
    Reset = "Returning to checkpoint...",
    
    -- Help text
    HelpTitle = "🎮 Game Instructions",
    HelpControls = [[
🎮 CONTROLS:
• WASD or Arrow Keys - Move around
• Spacebar - Jump
• R - Reset to last checkpoint
• H - Toggle this help menu
• Mouse - Look around
]],
    HelpObjective = [[
🎯 OBJECTIVE:
Navigate through the obstacle course and reach the finish line as fast as possible!
]],
}

-- Utility functions
function GameConfig.FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%05.2f", minutes, remainingSeconds)
end

function GameConfig.GetCheckpointMessage(checkpointNumber)
    return GameConfig.Messages.CheckpointReached:gsub("{number}", tostring(checkpointNumber))
end

return GameConfig
