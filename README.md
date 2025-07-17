# Simple Roblox Obby Game

A simple obstacle course (obby) game for Roblox with checkpoints, timer, and basic gameplay mechanics.

## Game Features

- **Obstacle Course**: Navigate through various obstacles to reach the end
- **Checkpoint System**: Touch checkpoints to save progress
- **Timer**: Track completion time
- **Leaderboard**: Display best times
- **Simple UI**: Clean and intuitive interface

## Project Structure

```
src/
├── ServerScriptService/          # Server-side scripts
│   ├── GameManager.server.lua    # Main game logic
│   ├── CheckpointManager.server.lua  # Checkpoint system
│   └── LeaderboardManager.server.lua # Player statistics
├── StarterPlayerScripts/         # Client-side scripts
│   ├── TimerUI.client.lua        # Timer display
│   └── UIManager.client.lua      # UI management
├── ReplicatedStorage/           # Shared resources
│   ├── RemoteEvents/            # Communication between client/server
│   └── Modules/                 # Shared modules
└── StarterGui/                  # UI elements
    └── TimerGui.lua             # Timer GUI setup
```

## How to Use

1. Open Roblox Studio
2. Create a new place
3. Copy the scripts from the `src/` folder to their respective locations in your game
4. Build your obstacle course in the workspace
5. Place checkpoints throughout the course
6. Test the game in Studio

## Building the Obby

1. Create parts for your obstacles (moving platforms, jumps, etc.)
2. Add `Checkpoint` parts and name them sequentially (Checkpoint1, Checkpoint2, etc.)
3. Add a `Finish` part at the end of the course
4. The scripts will automatically detect and manage the checkpoints

## Customization

- Modify `GameManager.server.lua` to add new game mechanics
- Update `TimerUI.client.lua` to change the UI appearance
- Add more obstacles and checkpoints as needed
- Customize the leaderboard system in `LeaderboardManager.server.lua`

## Requirements

- Roblox Studio
- Basic understanding of Lua/Luau scripting
- Knowledge of Roblox game development

## Getting Started

1. Open this project in Roblox Studio
2. Copy scripts to appropriate folders
3. Build your obstacle course
4. Test and iterate!
