# Simple Roblox Obby Game

A complete, ready-to-play obstacle course (obby) game for Roblox featuring modern UI, real-time leaderboards, and engaging gameplay mechanics.

![Roblox Game](https://img.shields.io/badge/Platform-Roblox-00A2FF?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-Luau-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 🎮 Game Features

- **🏃 Obstacle Course**: Navigate through challenging obstacles with moving platforms
- **✅ Checkpoint System**: Touch green checkpoints to save your progress
- **⏱️ Real-time Timer**: Track your completion time with millisecond precision
- **🏆 Global Leaderboard**: Compete with other players for the best times
- **📱 Modern UI**: Clean, responsive interface with animations
- **🔄 Reset System**: Quick reset to last checkpoint with R key
- **❓ Help System**: Built-in instructions and controls guide
- **📊 Statistics**: Track attempts, best times, and progress

## 🚀 Quick Start

1. **Download Roblox Studio** from [roblox.com/create](https://www.roblox.com/create)
2. **Open a new baseplate** in Roblox Studio
3. **Copy the scripts** from the `src/` folder to their respective locations
4. **Press Play** to test the game immediately!

> 📖 **Need detailed setup instructions?** Check out [SETUP.md](SETUP.md) for a complete installation guide.

## 🎯 How to Play

| Control | Action |
|---------|--------|
| `WASD` / Arrow Keys | Move around |
| `Spacebar` | Jump |
| `R` | Reset to last checkpoint |
| `H` | Toggle help menu |
| `Mouse` | Look around |

**Objective**: Race through the obstacle course as fast as possible! Touch the green checkpoints to save your progress, and try to reach the yellow finish line with the best time.

## 📁 Project Structure

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

## 🛠️ Development

Want to customize or extend the game? Check out these resources:

- **[SETUP.md](SETUP.md)** - Complete installation and setup guide
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development guide and API reference
- **[src/ReplicatedStorage/Modules/GameConfig.lua](src/ReplicatedStorage/Modules/GameConfig.lua)** - Game configuration options

## 🎨 Customization

The game is designed to be easily customizable:

- **Colors & Styling**: Modify `GameConfig.Colors`
- **Game Settings**: Adjust timers, cooldowns, and limits in `GameConfig.Settings`
- **UI Messages**: Update text and notifications in `GameConfig.Messages`
- **New Obstacles**: Add custom obstacles in `GameManager.server.lua`
- **Additional Features**: Extend functionality using the modular architecture

## 🧪 Testing

To test your game:

1. **Studio Testing**: Use Roblox Studio's play mode
2. **Multiplayer Testing**: Test with multiple players in Studio
3. **Mobile Testing**: Preview on different screen sizes
4. **Performance Testing**: Monitor script performance and memory usage

## 🚀 Deployment

1. **Publish to Roblox**: Use File > Publish to Roblox in Studio
2. **Set Game Details**: Add description, thumbnail, and tags
3. **Configure Settings**: Set age rating, genre, and privacy settings
4. **Test Live**: Invite friends to test the published game

## 📝 Requirements

- **Roblox Studio** (Latest version recommended)
- **Basic Lua/Luau Knowledge** (for customization)
- **Roblox Account** (for publishing)

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Report bugs and issues
- Suggest new features
- Submit improvements
- Share your customizations

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Roblox Developer Hub**: [developer.roblox.com](https://developer.roblox.com)
- **Community Forum**: [devforum.roblox.com](https://devforum.roblox.com)
- **Documentation**: Check the inline code comments for implementation details

---

**Happy game development! 🎮✨**
