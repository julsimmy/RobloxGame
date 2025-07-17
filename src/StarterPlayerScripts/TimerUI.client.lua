--[[
    TimerUI.client.lua
    Handles the timer display and basic UI elements for the client
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Timer variables
local startTime = tick()
local isGameActive = false
local currentTime = 0

-- UI Elements
local timerGui = nil
local timerLabel = nil
local messageLabel = nil
local leaderboardFrame = nil

-- Create the main UI
local function createUI()
    -- Main ScreenGui
    timerGui = Instance.new("ScreenGui")
    timerGui.Name = "TimerGui"
    timerGui.Parent = playerGui
    
    -- Timer Frame
    local timerFrame = Instance.new("Frame")
    timerFrame.Name = "TimerFrame"
    timerFrame.Size = UDim2.new(0, 200, 0, 80)
    timerFrame.Position = UDim2.new(0, 10, 0, 10)
    timerFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    timerFrame.BackgroundTransparency = 0.3
    timerFrame.BorderSizePixel = 0
    timerFrame.Parent = timerGui
    
    -- Round corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = timerFrame
    
    -- Timer Label
    timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Size = UDim2.new(1, 0, 0.6, 0)
    timerLabel.Position = UDim2.new(0, 0, 0, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "00:00.00"
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.Parent = timerFrame
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0.4, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.6, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready to start!"
    statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = timerFrame
    
    -- Message Frame (for notifications)
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(0, 300, 0, 60)
    messageFrame.Position = UDim2.new(0.5, -150, 0, 100)
    messageFrame.BackgroundColor3 = Color3.new(0, 0.8, 0)
    messageFrame.BackgroundTransparency = 1
    messageFrame.BorderSizePixel = 0
    messageFrame.Parent = timerGui
    
    local messageCorner = Instance.new("UICorner")
    messageCorner.CornerRadius = UDim.new(0, 10)
    messageCorner.Parent = messageFrame
    
    messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "MessageLabel"
    messageLabel.Size = UDim2.new(1, 0, 1, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = ""
    messageLabel.TextColor3 = Color3.new(1, 1, 1)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.GothamBold
    messageLabel.Parent = messageFrame
    
    -- Reset Button
    local resetButton = Instance.new("TextButton")
    resetButton.Name = "ResetButton"
    resetButton.Size = UDim2.new(0, 100, 0, 40)
    resetButton.Position = UDim2.new(0, 10, 0, 100)
    resetButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
    resetButton.BorderSizePixel = 0
    resetButton.Text = "Reset"
    resetButton.TextColor3 = Color3.new(1, 1, 1)
    resetButton.TextScaled = true
    resetButton.Font = Enum.Font.GothamBold
    resetButton.Parent = timerGui
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 5)
    resetCorner.Parent = resetButton
    
    -- Reset button functionality
    resetButton.MouseButton1Click:Connect(function()
        local resetPlayerEvent = remoteEventsFolder:FindFirstChild("ResetPlayer")
        if resetPlayerEvent then
            resetPlayerEvent:FireServer()
        end
    end)
    
    -- Leaderboard Frame
    createLeaderboard()
    
    print("UI created successfully!")
end

-- Create leaderboard UI
local function createLeaderboard()
    leaderboardFrame = Instance.new("Frame")
    leaderboardFrame.Name = "LeaderboardFrame"
    leaderboardFrame.Size = UDim2.new(0, 250, 0, 300)
    leaderboardFrame.Position = UDim2.new(1, -260, 0, 10)
    leaderboardFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    leaderboardFrame.BackgroundTransparency = 0.3
    leaderboardFrame.BorderSizePixel = 0
    leaderboardFrame.Parent = timerGui
    
    local leaderboardCorner = Instance.new("UICorner")
    leaderboardCorner.CornerRadius = UDim.new(0, 10)
    leaderboardCorner.Parent = leaderboardFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🏆 Leaderboard"
    titleLabel.TextColor3 = Color3.new(1, 1, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = leaderboardFrame
    
    -- Scrolling frame for leaderboard entries
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.Parent = leaderboardFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = scrollingFrame
end

-- Update timer display
local function updateTimer()
    if not isGameActive then return end
    
    currentTime = tick() - startTime
    local minutes = math.floor(currentTime / 60)
    local seconds = currentTime % 60
    
    timerLabel.Text = string.format("%02d:%05.2f", minutes, seconds)
end

-- Show notification message
local function showMessage(text, color, duration)
    duration = duration or 3
    color = color or Color3.new(0, 0.8, 0)
    
    messageLabel.Text = text
    messageLabel.Parent.BackgroundColor3 = color
    
    -- Animate in
    local tweenIn = TweenService:Create(
        messageLabel.Parent,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.2}
    )
    tweenIn:Play()
    
    -- Animate out after duration
    wait(duration)
    local tweenOut = TweenService:Create(
        messageLabel.Parent,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )
    tweenOut:Play()
end

-- Update leaderboard display
local function updateLeaderboard(leaderboardData)
    local scrollingFrame = leaderboardFrame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return end
    
    -- Clear existing entries
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add new entries
    for i, entry in ipairs(leaderboardData) do
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = "Entry" .. i
        entryFrame.Size = UDim2.new(1, -10, 0, 25)
        entryFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        entryFrame.BackgroundTransparency = 0.5
        entryFrame.BorderSizePixel = 0
        entryFrame.LayoutOrder = i
        entryFrame.Parent = scrollingFrame
        
        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 3)
        entryCorner.Parent = entryFrame
        
        -- Rank
        local rankLabel = Instance.new("TextLabel")
        rankLabel.Size = UDim2.new(0, 30, 1, 0)
        rankLabel.Position = UDim2.new(0, 0, 0, 0)
        rankLabel.BackgroundTransparency = 1
        rankLabel.Text = "#" .. entry.rank
        rankLabel.TextColor3 = Color3.new(1, 1, 1)
        rankLabel.TextScaled = true
        rankLabel.Font = Enum.Font.GothamBold
        rankLabel.Parent = entryFrame
        
        -- Player name
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.6, -30, 1, 0)
        nameLabel.Position = UDim2.new(0, 30, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = entry.playerName
        nameLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entryFrame
        
        -- Time
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(0.4, 0, 1, 0)
        timeLabel.Position = UDim2.new(0.6, 0, 0, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = entry.time
        timeLabel.TextColor3 = Color3.new(1, 1, 0)
        timeLabel.TextScaled = true
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.TextXAlignment = Enum.TextXAlignment.Right
        timeLabel.Parent = entryFrame
        
        -- Highlight player's own entry
        if entry.playerName == player.Name then
            entryFrame.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
        end
    end
    
    -- Update canvas size
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #leaderboardData * 27)
end

-- Handle remote events
local function connectRemoteEvents()
    -- Player joined event
    local playerJoinedEvent = remoteEventsFolder:WaitForChild("PlayerJoined")
    playerJoinedEvent.OnClientEvent:Connect(function(data)
        startTime = data.startTime
        isGameActive = true
        spawn(function()
            showMessage(data.message, Color3.new(0, 0.8, 0), 4)
        end)
    end)
    
    -- Checkpoint reached event
    local checkpointReachedEvent = remoteEventsFolder:WaitForChild("CheckpointReached")
    checkpointReachedEvent.OnClientEvent:Connect(function(data)
        spawn(function()
            showMessage(data.message, Color3.new(0, 0.8, 0), 2)
        end)
    end)
    
    -- Finish reached event
    local finishReachedEvent = remoteEventsFolder:WaitForChild("FinishReached")
    finishReachedEvent.OnClientEvent:Connect(function(data)
        isGameActive = false
        spawn(function()
            local message = data.message .. "\nTime: " .. string.format("%.2f", data.completionTime) .. "s"
            showMessage(message, Color3.new(1, 0.8, 0), 5)
        end)
        
        -- Restart timer for next attempt
        wait(3)
        startTime = tick()
        isGameActive = true
    end)
    
    -- Leaderboard update event
    local leaderboardUpdateEvent = remoteEventsFolder:WaitForChild("LeaderboardUpdate")
    leaderboardUpdateEvent.OnClientEvent:Connect(updateLeaderboard)
end

-- Handle keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        -- Reset player
        local resetPlayerEvent = remoteEventsFolder:FindFirstChild("ResetPlayer")
        if resetPlayerEvent then
            resetPlayerEvent:FireServer()
        end
    end
end)

-- Initialize
createUI()
connectRemoteEvents()

-- Start timer update loop
RunService.Heartbeat:Connect(updateTimer)

print("TimerUI loaded successfully!")
