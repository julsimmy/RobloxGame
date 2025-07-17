# Installation and Setup Guide

This guide will help you set up and run the Simple Roblox Obby game in Roblox Studio.

## Prerequisites

1. **Roblox Studio** - Download and install the latest version from [roblox.com/create](https://www.roblox.com/create)
2. **Roblox Account** - You'll need a Roblox account to use Studio and publish games

## Setup Instructions

### Step 1: Open Roblox Studio
1. Launch Roblox Studio
2. Click on "New" to create a new place
3. Choose "Baseplate" or any template you prefer

### Step 2: Set Up the Project Structure
1. In the Explorer window, you should see the default game structure
2. Locate the following folders (create them if they don't exist):
   - `ServerScriptService`
   - `StarterPlayer` > `StarterPlayerScripts`
   - `ReplicatedStorage`

### Step 3: Copy the Scripts

#### Server Scripts (go in ServerScriptService):
- Copy `src/ServerScriptService/GameManager.server.lua`
- Copy `src/ServerScriptService/CheckpointManager.server.lua`
- Copy `src/ServerScriptService/LeaderboardManager.server.lua`

#### Client Scripts (go in StarterPlayer > StarterPlayerScripts):
- Copy `src/StarterPlayerScripts/TimerUI.client.lua`
- Copy `src/StarterPlayerScripts/UIManager.client.lua`

#### Shared Modules (go in ReplicatedStorage):
1. Create a folder called `Modules` in ReplicatedStorage
2. Copy `src/ReplicatedStorage/Modules/GameConfig.lua`
3. Copy `src/ReplicatedStorage/Modules/PlayerDataModule.lua`

### Step 4: Build Your Obby
The scripts will automatically create some sample obstacles, but you can customize them:

1. **Create Checkpoints:**
   - Insert a Part into Workspace
   - Name it "Checkpoint1", "Checkpoint2", etc.
   - Make it green and non-collidable
   - Position them throughout your course

2. **Create a Finish Line:**
   - Insert a Part into Workspace
   - Name it "Finish"
   - Make it yellow and non-collidable
   - Place it at the end of your course

3. **Add Obstacles:**
   - Create moving platforms, jumps, mazes, etc.
   - The sample code creates some moving platforms automatically

### Step 5: Test the Game
1. Click the "Play" button in Studio to test your game
2. Try moving through the course and touching checkpoints
3. Check that the timer, UI, and leaderboard work correctly

### Step 6: Customize (Optional)
- Modify the `GameConfig.lua` to change game settings
- Edit the UI scripts to customize the appearance
- Add more complex obstacles and mechanics
- Adjust checkpoint positions and difficulty

## File Structure in Roblox Studio

```
game
├── ServerScriptService
│   ├── GameManager (Server Script)
│   ├── CheckpointManager (Server Script)
│   └── LeaderboardManager (Server Script)
├── StarterPlayer
│   └── StarterPlayerScripts
│       ├── TimerUI (Local Script)
│       └── UIManager (Local Script)
├── ReplicatedStorage
│   ├── RemoteEvents (Folder - auto-created)
│   └── Modules
│       ├── GameConfig (ModuleScript)
│       └── PlayerDataModule (ModuleScript)
└── Workspace
    ├── Baseplate
    ├── SpawnLocation
    ├── Checkpoint1, Checkpoint2, etc.
    ├── Finish
    └── Your obstacle course parts
```

## Common Issues and Solutions

### Scripts Not Working
- Make sure scripts are in the correct folders
- Check the Output window for error messages
- Verify all RemoteEvents are being created properly

### UI Not Showing
- Ensure LocalScripts are in StarterPlayerScripts
- Check that the player has properly spawned
- Look for UI-related errors in the Output

### Checkpoints Not Working
- Verify checkpoints are named correctly (Checkpoint1, Checkpoint2, etc.)
- Make sure they're Parts, not Models
- Check that CanCollide is set to false

### Performance Issues
- Reduce the number of moving parts if needed
- Optimize script update frequencies in GameConfig
- Use simpler geometry for obstacles

## Publishing Your Game

1. Click "File" > "Publish to Roblox"
2. Give your game a name and description
3. Set appropriate tags and settings
4. Click "Create" or "Update" to publish

## Next Steps

- Add more complex obstacles and mechanics
- Implement additional game modes
- Create custom GUIs and effects
- Add sound effects and music
- Implement DataStore for persistent leaderboards (requires published game)

## Support

If you encounter issues:
1. Check the Roblox Developer Hub: [developer.roblox.com](https://developer.roblox.com)
2. Review the script comments for implementation details
3. Test each component individually to isolate problems
