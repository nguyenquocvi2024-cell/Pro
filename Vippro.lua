local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("VĨ LỎ - PRO VIP", "DarkTheme")

local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50

spawn(function()
    while true do
        local main = coreGui:FindFirstChild("VĨ LỎ - PRO VIP")
        if main and main:FindFirstChild("Main") then
            main.Main.Active = true
            main.Main.Draggable = true
            main.DisplayOrder = 100
            break
        end
        task.wait(0.5)
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "ViloControlFix"
sg.Parent = coreGui
sg.DisplayOrder = 999

local btn = Instance.new("TextButton")
btn.Parent = sg
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.BackgroundTransparency = 0.2
btn.Position = UDim2.new(0, 10, 0, 150)
btn.Size = UDim2.new(0, 90, 0, 45)
btn.Text = "ẨN/HIỆN"
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.TextSize = 15
btn.Active = true
btn.Draggable = true
local ui = Instance.new("UICorner")
ui.Parent = btn

btn.MouseButton1Click:Connect(function()
    local target = coreGui:FindFirstChild("VĨ LỎ - PRO VIP")
    if target then
        target.Enabled = not target.Enabled
    end
end)

local Tab1 = Window:NewTab("🎮 Main")
local SecPOV = Tab1:NewSection("Tầm Nhìn & Aim")

SecPOV:NewTextBox("Nhập POV (50-120)", "", function(txt)
    local num = tonumber(txt)
    if num then Camera.FieldOfView = num end
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

SecFly:NewTextBox("Nhập Tốc Độ Fly (10-300)", "", function(txt)
    local num = tonumber(txt)
    if num then _G.FlySpeed = num end
end)

SecFly:NewToggle("Bật ESP", "", function(state)
    _G.ESP_Enabled = state
end)

runService.RenderStepped:Connect(function()
    if _G.ESP_Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character then
                if not v.Character:FindFirstChild("ViloHighlight") then
                    local h = Instance.new("Highlight", v.Character)
                    h.Name = "ViloHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
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
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)
