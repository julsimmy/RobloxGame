# Development Guide

This guide explains how to develop and extend the Simple Roblox Obby game.

## Project Architecture

### Client-Server Model
The game follows Roblox's client-server architecture:
- **Server Scripts**: Handle game logic, validation, and data management
- **Local Scripts**: Manage UI, user input, and client-side effects
- **RemoteEvents**: Enable communication between client and server

### Core Components

#### 1. GameManager (Server)
- Main game initialization
- Creates sample obstacles and checkpoints
- Handles player joining/leaving
- Manages game state

#### 2. CheckpointManager (Server)
- Tracks player progress through checkpoints
- Validates checkpoint touches
- Handles finish line detection
- Manages player respawning

#### 3. LeaderboardManager (Server)
- Tracks player statistics
- Manages global leaderboard
- Updates player leaderstats
- Broadcasts leaderboard updates

#### 4. TimerUI (Client)
- Displays real-time timer
- Shows game notifications
- Handles leaderboard display
- Manages reset functionality

#### 5. UIManager (Client)
- Help menu and instructions
- Welcome messages
- Keyboard shortcuts
- Additional UI elements

### Shared Modules

#### GameConfig
Contains all game configuration including:
- Timer settings
- Colors and styling
- Message templates
- Utility functions

#### PlayerDataModule
Handles player data structure:
- Data validation
- Progress tracking
- Statistics management
- Reset functionality

## Adding New Features

### 1. Adding New Obstacles

```lua
-- In GameManager.server.lua
local function createNewObstacle(position, name)
    local obstacle = Instance.new("Part")
    obstacle.Name = name
    obstacle.Size = Vector3.new(4, 1, 4)
    obstacle.Position = position
    obstacle.Material = Enum.Material.Neon
    obstacle.BrickColor = BrickColor.new("Bright red")
    obstacle.Anchored = true
    obstacle.Parent = workspace
    
    -- Add your custom behavior here
    
    return obstacle
end
```

### 2. Adding New UI Elements

```lua
-- In UIManager.client.lua or TimerUI.client.lua
local function createNewUIElement()
    local newElement = Instance.new("Frame")
    -- Configure your UI element
    newElement.Parent = playerGui
    
    return newElement
end
```

### 3. Adding New RemoteEvents

```lua
-- Server side (in any server script)
local newEvent = Instance.new("RemoteEvent")
newEvent.Name = "NewEvent"
newEvent.Parent = remoteEventsFolder

-- Client side (in any local script)
local newEvent = remoteEventsFolder:WaitForChild("NewEvent")
newEvent.OnClientEvent:Connect(function(data)
    -- Handle the event
end)
```

## Configuration Options

### GameConfig Settings
Modify `src/ReplicatedStorage/Modules/GameConfig.lua`:

```lua
GameConfig.Settings = {
    TimerUpdateRate = 0.1,        -- Timer refresh rate
    CheckpointCooldown = 1,       -- Checkpoint activation delay
    MaxLeaderboardEntries = 10,   -- Leaderboard size
    NotificationDuration = 3,     -- Message display time
    RespawnDelay = 3,            -- Death respawn delay
}
```

### Color Customization
```lua
GameConfig.Colors = {
    Checkpoint = Color3.new(0, 1, 0),     -- Green
    Finish = Color3.new(1, 1, 0),         -- Yellow
    Success = Color3.new(0, 0.8, 0),      -- UI success color
    -- Add your custom colors
}
```

## Best Practices

### 1. Script Organization
- Keep server scripts in ServerScriptService
- Keep client scripts in StarterPlayerScripts
- Use ModuleScripts for shared code
- Group related functionality together

### 2. Error Handling
```lua
-- Always validate inputs
local function safeFunction(player, data)
    if not player or not data then
        warn("Invalid parameters")
        return false
    end
    
    -- Your code here
    return true
end
```

### 3. Performance
- Use spawn() for non-critical tasks
- Implement cooldowns for frequent events
- Optimize UI updates
- Use object pooling for repeated elements

### 4. Security
- Validate all client inputs on server
- Use RemoteEvents properly
- Never trust client data
- Implement sanity checks

## Testing Checklist

### Functionality Testing
- [ ] Timer starts and updates correctly
- [ ] Checkpoints save progress
- [ ] Finish line completes the game
- [ ] Reset functionality works
- [ ] UI displays properly
- [ ] Leaderboard updates

### Edge Case Testing
- [ ] Multiple players
- [ ] Rapid checkpoint touching
- [ ] Network lag simulation
- [ ] Mobile compatibility
- [ ] Error scenarios

### Performance Testing
- [ ] Memory usage
- [ ] Script performance
- [ ] UI responsiveness
- [ ] Large player counts

## Common Patterns

### Event Handling
```lua
-- Server side
someEvent.OnServerEvent:Connect(function(player, ...)
    -- Validate player
    if not player or not player.Character then return end
    
    -- Handle the event
end)

-- Client side
someEvent.OnClientEvent:Connect(function(...)
    -- Handle the event
end)
```

### UI Animation
```lua
local tween = TweenService:Create(
    uiElement,
    TweenInfo.new(0.3, Enum.EasingStyle.Quad),
    {BackgroundTransparency = 0}
)
tween:Play()
```

### Safe Player Access
```lua
local function getPlayerSafely(character)
    if not character then return nil end
    return Players:GetPlayerFromCharacter(character)
end
```

## Debugging Tips

1. **Use the Output Window**: Check for errors and warnings
2. **Print Statements**: Add debug prints to track execution
3. **Test in Studio First**: Always test before publishing
4. **Use Breakpoints**: Studio supports script debugging
5. **Check RemoteEvent Flow**: Ensure client-server communication works

## Extending the Game

### Ideas for Enhancement
- Power-ups and special abilities
- Multiple difficulty levels
- Team-based challenges
- Custom building tools
- Social features (friends, parties)
- Cosmetic rewards
- Daily challenges
- Seasonal events

### Advanced Features
- DataStore integration for persistence
- In-game purchases
- Anti-cheat systems
- Advanced physics obstacles
- Multiplayer races
- Custom avatar animations
