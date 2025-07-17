--[[
    UIManager.client.lua
    Manages additional UI elements and interactions
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI state
local isMenuOpen = false
local menuGui = nil

-- Create help/instructions menu
local function createHelpMenu()
    menuGui = Instance.new("ScreenGui")
    menuGui.Name = "HelpMenuGui"
    menuGui.Parent = playerGui
    
    -- Background frame
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.5
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Visible = false
    backgroundFrame.Parent = menuGui
    
    -- Main menu frame
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "MenuFrame"
    menuFrame.Size = UDim2.new(0, 500, 0, 400)
    menuFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    menuFrame.BorderSizePixel = 0
    menuFrame.Parent = backgroundFrame
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 15)
    menuCorner.Parent = menuFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 60)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎮 Game Instructions"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = menuFrame
    
    -- Instructions text
    local instructionsText = [[
Welcome to the Simple Obby!

🎯 OBJECTIVE:
Navigate through the obstacle course and reach the finish line as fast as possible!

🎮 CONTROLS:
• WASD or Arrow Keys - Move around
• Spacebar - Jump
• R - Reset to last checkpoint
• H - Toggle this help menu
• Mouse - Look around

✅ GAMEPLAY:
• Touch green checkpoints to save your progress
• If you fall or die, you'll respawn at your last checkpoint
• Your best time is saved and displayed on the leaderboard
• Try to beat other players' times!

🏆 FEATURES:
• Real-time timer
• Checkpoint system
• Global leaderboard
• Personal statistics

Good luck and have fun!
]]
    
    local instructionsLabel = Instance.new("TextLabel")
    instructionsLabel.Name = "InstructionsLabel"
    instructionsLabel.Size = UDim2.new(1, -40, 1, -120)
    instructionsLabel.Position = UDim2.new(0, 20, 0, 70)
    instructionsLabel.BackgroundTransparency = 1
    instructionsLabel.Text = instructionsText
    instructionsLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    instructionsLabel.TextSize = 18
    instructionsLabel.Font = Enum.Font.Gotham
    instructionsLabel.TextYAlignment = Enum.TextYAlignment.Top
    instructionsLabel.TextXAlignment = Enum.TextXAlignment.Left
    instructionsLabel.TextWrapped = true
    instructionsLabel.Parent = menuFrame
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 100, 0, 40)
    closeButton.Position = UDim2.new(0.5, -50, 1, -60)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "Close"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = menuFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        toggleHelpMenu()
    end)
    
    -- Close on background click
    backgroundFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleHelpMenu()
        end
    end)
end

-- Toggle help menu
function toggleHelpMenu()
    if not menuGui then
        createHelpMenu()
    end
    
    local backgroundFrame = menuGui:FindFirstChild("BackgroundFrame")
    if not backgroundFrame then return end
    
    isMenuOpen = not isMenuOpen
    backgroundFrame.Visible = isMenuOpen
    
    if isMenuOpen then
        -- Animate in
        local menuFrame = backgroundFrame:FindFirstChild("MenuFrame")
        if menuFrame then
            menuFrame.Size = UDim2.new(0, 0, 0, 0)
            menuFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local tween = TweenService:Create(
                menuFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {
                    Size = UDim2.new(0, 500, 0, 400),
                    Position = UDim2.new(0.5, -250, 0.5, -200)
                }
            )
            tween:Play()
        end
    end
end

-- Create help button
local function createHelpButton()
    local helpButtonGui = Instance.new("ScreenGui")
    helpButtonGui.Name = "HelpButtonGui"
    helpButtonGui.Parent = playerGui
    
    local helpButton = Instance.new("TextButton")
    helpButton.Name = "HelpButton"
    helpButton.Size = UDim2.new(0, 80, 0, 40)
    helpButton.Position = UDim2.new(0, 10, 0, 150)
    helpButton.BackgroundColor3 = Color3.new(0.2, 0.4, 0.8)
    helpButton.BorderSizePixel = 0
    helpButton.Text = "Help (H)"
    helpButton.TextColor3 = Color3.new(1, 1, 1)
    helpButton.TextScaled = true
    helpButton.Font = Enum.Font.GothamBold
    helpButton.Parent = helpButtonGui
    
    local helpCorner = Instance.new("UICorner")
    helpCorner.CornerRadius = UDim.new(0, 5)
    helpCorner.Parent = helpButton
    
    helpButton.MouseButton1Click:Connect(toggleHelpMenu)
end

-- Create settings menu
local function createSettingsMenu()
    -- This could be expanded for game settings
    -- For now, just keeping it simple
end

-- Handle keyboard input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.H then
        toggleHelpMenu()
    elseif input.KeyCode == Enum.KeyCode.Escape then
        if isMenuOpen then
            toggleHelpMenu()
        end
    end
end)

-- Show welcome message on spawn
local function showWelcomeMessage()
    wait(2) -- Wait for other UI to load
    
    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Name = "WelcomeGui"
    welcomeGui.Parent = playerGui
    
    local welcomeFrame = Instance.new("Frame")
    welcomeFrame.Size = UDim2.new(0, 400, 0, 150)
    welcomeFrame.Position = UDim2.new(0.5, -200, 0.3, 0)
    welcomeFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    welcomeFrame.BackgroundTransparency = 0.3
    welcomeFrame.BorderSizePixel = 0
    welcomeFrame.Parent = welcomeGui
    
    local welcomeCorner = Instance.new("UICorner")
    welcomeCorner.CornerRadius = UDim.new(0, 10)
    welcomeCorner.Parent = welcomeFrame
    
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, -20, 1, -40)
    welcomeLabel.Position = UDim2.new(0, 10, 0, 10)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "Welcome to the Simple Obby!\n\nPress H for help and controls\nPress R to reset to checkpoint\n\nGood luck!"
    welcomeLabel.TextColor3 = Color3.new(1, 1, 1)
    welcomeLabel.TextScaled = true
    welcomeLabel.Font = Enum.Font.Gotham
    welcomeLabel.TextWrapped = true
    welcomeLabel.Parent = welcomeFrame
    
    local okButton = Instance.new("TextButton")
    okButton.Size = UDim2.new(0, 80, 0, 30)
    okButton.Position = UDim2.new(0.5, -40, 1, -40)
    okButton.BackgroundColor3 = Color3.new(0, 0.7, 0)
    okButton.BorderSizePixel = 0
    okButton.Text = "Got it!"
    okButton.TextColor3 = Color3.new(1, 1, 1)
    okButton.TextScaled = true
    okButton.Font = Enum.Font.GothamBold
    okButton.Parent = welcomeFrame
    
    local okCorner = Instance.new("UICorner")
    okCorner.CornerRadius = UDim.new(0, 5)
    okCorner.Parent = okButton
    
    okButton.MouseButton1Click:Connect(function()
        welcomeGui:Destroy()
    end)
    
    -- Auto-close after 10 seconds
    spawn(function()
        wait(10)
        if welcomeGui.Parent then
            local tween = TweenService:Create(
                welcomeFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {BackgroundTransparency = 1}
            )
            tween:Play()
            
            local labelTween = TweenService:Create(
                welcomeLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            )
            labelTween:Play()
            
            wait(0.5)
            welcomeGui:Destroy()
        end
    end)
end

-- Initialize UI Manager
local function initialize()
    createHelpButton()
    
    -- Show welcome message when character spawns
    if player.Character then
        showWelcomeMessage()
    end
    
    player.CharacterAdded:Connect(showWelcomeMessage)
end

-- Start initialization
initialize()

print("UIManager loaded successfully!")
