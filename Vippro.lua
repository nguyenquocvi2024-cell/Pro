-- Vĩ Lỏ Hub - Blox Fruits Script
-- Fixed menu with all functions

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViLoHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Vĩ Lỏ Hub"
titleText.TextColor3 = Color3.fromRGB(255, 200, 100)
titleText.TextSize = 20
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab Buttons Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 45)
tabContainer.Position = UDim2.new(0, 0, 0, 45)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabContainer

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -110)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Tabs
local tabs = {}
local currentTab = nil

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 100, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 4
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Visible = false
    tabFrame.Parent = contentFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabFrame
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    tabs[name] = {
        button = tabBtn,
        frame = tabFrame
    }
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.frame.Visible = false
            t.button.BackgroundTransparency = 0.5
            t.button.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
        tabFrame.Visible = true
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
        currentTab = name
    end)
end

local function addButton(tabName, text, callback)
    local tab = tabs[tabName]
    if not tab then return end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = tab.frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function addToggle(tabName, text, default, callback)
    local tab = tabs[tabName]
    if not tab then return end
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = UDim2.new(0, 10, 0, 0)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.frame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -15, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -60, 0, 5)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    callback(state)
end

local function addDropdown(tabName, text, options, default, callback)
    local tab = tabs[tabName]
    if not tab then return end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -20, 0, 50)
    dropdownFrame.Position = UDim2.new(0, 10, 0, 0)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    dropdownFrame.BackgroundTransparency = 0.3
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = tab.frame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = dropdownFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = dropdownFrame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, -20, 0, 25)
    dropdownBtn.Position = UDim2.new(0, 10, 0, 25)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    dropdownBtn.Text = default or options[1]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextSize = 13
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Parent = dropdownFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = dropdownBtn
    
    local selected = default or options[1]
    callback(selected)
    
    dropdownBtn.MouseButton1Click:Connect(function()
        -- Simple dropdown selection
        local selectionFrame = Instance.new("Frame")
        selectionFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        selectionFrame.Position = UDim2.new(0, 0, 0, 30)
        selectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        selectionFrame.BackgroundTransparency = 0.1
        selectionFrame.BorderSizePixel = 0
        selectionFrame.Parent = dropdownFrame
        
        local selectionCorner = Instance.new("UICorner")
        selectionCorner.CornerRadius = UDim.new(0, 6)
        selectionCorner.Parent = selectionFrame
        
        local selectionLayout = Instance.new("UIListLayout")
        selectionLayout.Padding = UDim.new(0, 2)
        selectionLayout.Parent = selectionFrame
        
        for _, option in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 25)
            optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            optBtn.Text = option
            optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.Gotham
            optBtn.BorderSizePixel = 0
            optBtn.Parent = selectionFrame
            
            optBtn.MouseButton1Click:Connect(function()
                selected = option
                dropdownBtn.Text = option
                callback(option)
                selectionFrame:Destroy()
            end)
        end
        
        -- Click outside to close
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = UserInputService:GetMouseLocation()
                local absPos = dropdownFrame.AbsolutePosition
                local absSize = dropdownFrame.AbsoluteSize
                if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                   mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                    selectionFrame:Destroy()
                    connection:Disconnect()
                end
            end
        end)
    end)
end

local function addSlider(tabName, text, min, max, default, callback)
    local tab = tabs[tabName]
    if not tab then return end
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.Position = UDim2.new(0, 10, 0, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = tab.frame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 4)
    sliderBg.Position = UDim2.new(0, 10, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 2)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 2)
    sliderFillCorner.Parent = sliderFill
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 12, 0, 12)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -6, 0, -4)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    sliderBtn.BackgroundTransparency = 0
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg
    
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(1, 0)
    sliderBtnCorner.Parent = sliderBtn
    
    local value = default
    callback(value)
    
    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local bgPos = sliderBg.AbsolutePosition
            local bgSize = sliderBg.AbsoluteSize
            local percent = math.clamp((mousePos.X - bgPos.X) / bgSize.X, 0, 1)
            value = min + (max - min) * percent
            value = math.floor(value)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderBtn.Position = UDim2.new(percent, -6, 0, -4)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
end

-- Create Tabs
createTab("⚔️ Combat", "Combat")
createTab("🗺️ Teleport", "Teleport")
createTab("🎣 Fishing", "Fishing")
createTab("⚙️ Settings", "Settings")
createTab("📊 Stats", "Stats")

-- Combat Tab
addToggle("⚔️ Combat", "Auto Farm (Level)", false, function(state)
    -- Auto farm logic here
    print("Auto Farm:", state)
end)

addToggle("⚔️ Combat", "Auto Farm (Fruit)", false, function(state)
    print("Auto Fruit Farm:", state)
end)

addToggle("⚔️ Combat", "Auto Raid", false, function(state)
    print("Auto Raid:", state)
end)

addToggle("⚔️ Combat", "Auto Sea Beast", false, function(state)
    print("Auto Sea Beast:", state)
end)

addToggle("⚔️ Combat", "Auto Mastery", false, function(state)
    print("Auto Mastery:", state)
end)

addButton("⚔️ Combat", "Kill All NPCs", function()
    print("Killing all NPCs...")
end)

addButton("⚔️ Combat", "Reset Stats", function()
    print("Resetting stats...")
end)

-- Teleport Tab
local islands = {
    "Marine Starter", "Pirate Starter", "Jungle", "Desert", "Snow",
    "Skylands", "Magma", "Prison", "Ice Castle", "Forgotten Island",
    "Cake Island", "Sea of Treats", "Hydra Island", "Great Tree"
}

addDropdown("🗺️ Teleport", "Select Island", islands, "Marine Starter", function(selected)
    print("Selected island:", selected)
end)

addButton("🗺️ Teleport", "Teleport to Island", function()
    print("Teleporting...")
end)

addToggle("🗺️ Teleport", "Auto Teleport to NPC", false, function(state)
    print("Auto Teleport:", state)
end)

-- Fishing Tab
addToggle("🎣 Fishing", "Auto Fish", false, function(state)
    print("Auto Fish:", state)
end)

addToggle("🎣 Fishing", "Auto Sell Fish", false, function(state)
    print("Auto Sell:", state)
end)

addSlider("🎣 Fishing", "Fishing Speed", 1, 10, 5, function(value)
    print("Fishing speed:", value)
end)

-- Settings Tab
addToggle("⚙️ Settings", "ESP (Show Players)", false, function(state)
    print("ESP:", state)
end)

addToggle("⚙️ Settings", "Speed Hack", false, function(state)
    print("Speed Hack:", state)
end)

addToggle("⚙️ Settings", "Fly Mode", false, function(state)
    print("Fly Mode:", state)
end)

addSlider("⚙️ Settings", "Walk Speed", 16, 200, 16, function(value)
    if LocalPlayer and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

addSlider("⚙️ Settings", "Jump Power", 50, 300, 50, function(value)
    if LocalPlayer and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

-- Stats Tab
local statLabels = {}
local function updateStats()
    -- Update stats display
    for name, label in pairs(statLabels) do
        -- Get actual stats from game
        label.Text = name .. ": 0"
    end
end

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 1, 0)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = tabs["📊 Stats"].frame

local statsLayout = Instance.new("UIListLayout")
statsLayout.Padding = UDim.new(0, 10)
statsLayout.Parent = statsFrame

local statNames = {"💪 Melee", "🔫 Gun", "🍎 Fruit", "🏃 Defense", "💰 Money", "🏆 Level", "⭐ Mastery"}
for _, stat in ipairs(statNames) do
    local statFrame = Instance.new("Frame")
    statFrame.Size = UDim2.new(1, -20, 0, 40)
    statFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    statFrame.BackgroundTransparency = 0.3
    statFrame.BorderSizePixel = 0
    statFrame.Parent = statsFrame
    
    local statCorner = Instance.new("UICorner")
    statCorner.CornerRadius = UDim.new(0, 8)
    statCorner.Parent = statFrame
    
    local statLabel = Instance.new("TextLabel")
    statLabel.Size = UDim2.new(1, -20, 1, 0)
    statLabel.Position = UDim2.new(0, 10, 0, 0)
    statLabel.BackgroundTransparency = 1
    statLabel.Text = stat .. ": Loading..."
    statLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statLabel.TextSize = 14
    statLabel.TextXAlignment = Enum.TextXAlignment.Left
    statLabel.Font = Enum.Font.Gotham
    statLabel.Parent = statFrame
    
    statLabels[stat] = statLabel
end

addButton("📊 Stats", "Refresh Stats", function()
    updateStats()
end)

-- Make window draggable
local dragging = false
local dragInput
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Select first tab by default
for name, tab in pairs(tabs) do
    if not currentTab then
        tab.button:Fire()
    end
end

print("Vĩ Lỏ Hub loaded successfully!")
