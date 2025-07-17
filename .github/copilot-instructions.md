<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Roblox Game Development Instructions

This is a Roblox game project. When working with this codebase:

1. Use Luau (Roblox's Lua variant) syntax for all scripts
2. Follow Roblox naming conventions (PascalCase for most identifiers)
3. Use proper Roblox services (game:GetService()) instead of direct references
4. Implement proper client-server architecture with RemoteEvents/RemoteFunctions
5. Use type annotations when possible for better code quality
6. Follow Roblox security best practices (validate inputs on server, don't trust client)
7. Use proper folder structure: ServerScriptService for server scripts, StarterPlayerScripts for client scripts
8. Remember that LocalScripts only run on the client, Scripts run on the server
9. Use ReplicatedStorage for shared resources and RemoteEvents
10. Test scripts in Roblox Studio for proper functionality
