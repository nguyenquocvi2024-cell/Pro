local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("VĨ LỎ - PRO VIP", "DarkTheme")

spawn(function()
    while task.wait(1) do
        local MainFrame = game:GetService("CoreGui"):FindFirstChild("VĨ LỎ - PRO VIP")
        if MainFrame and MainFrame:FindFirstChild("Main") then
            MainFrame.Main.Active = true
            MainFrame.Main.Draggable = true 
            break
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BackgroundTransparency = 0.4
ToggleButton.Position = UDim2.new(0, 10, 0, 200)
ToggleButton.Size = UDim2.new(0, 70, 0, 40)
ToggleButton.Text = "VĨ LỎ"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.Active = true
ToggleButton.Draggable = true 

UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    local target = game:GetService("CoreGui"):FindFirstChild("VĨ LỎ - PRO VIP")
    if target then
        target.Enabled = not target.Enabled
    end
end)

_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50
local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

local Tab1 = Window:NewTab("🎮 Main")
local SecPOV = Tab1:NewSection("Tầm Nhìn & Aim")

SecPOV:NewSlider("Chỉnh POV", "", 120, 50, function(s)
    Camera.FieldOfView = s
end)

SecPOV:NewToggle("Bật Aimbot", "", function(state)
    _G.Aimbot_Enabled = state
end)

local Tab2 = Window:NewTab("🦅 Fly & ESP")
local SecFly = Tab2:NewSection("Chức Năng VIP")

SecFly:NewToggle("Bật Fly", "", function(state)
    _G.Fly_Enabled = state
    if state then
        local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            while _G.Fly_Enabled do
                task.wait()
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid.PlatformStand = true
                    bv.velocity = Camera.CFrame.LookVector * _G.FlySpeed
                    bg.cframe = Camera.CFrame
                end
            end
            bv:Destroy(); bg:Destroy()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.PlatformStand = false
            end
        end)
    end
end)

SecFly:NewSlider("Tốc Độ Fly", "", 300, 10, function(s)
    _G.FlySpeed = s
end)

SecFly:NewToggle("Bật ESP", "", function(state)
    _G.ESP_Enabled = state
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.ESP_Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character then
                if not v.Character:FindFirstChild("ViloHighlight") then
                    local h = Instance.new("Highlight", v.Character)
                    h.Name = "ViloHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ViloHighlight") then
                v.Character.ViloHighlight:Destroy()
            end
        end
    end
    
    if _G.Aimbot_Enabled then
        local target = nil
        local dist = 400
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if d < dist then target = v; dist = d end
                end
            end
        end
        if target then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) 
        end
    end
end)
