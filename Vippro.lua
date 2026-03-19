--[[
    SCRIPT: VĨ LỎ MENU - SIÊU FIX NÚT ẨN HIỆN
    - Nút ẨN/HIỆN có thể cầm kéo di chuyển khắp màn hình
    - Fix lỗi bấm nút không tắt được Menu
    - Giữ nguyên các tính năng Fly, ESP, Aim, POV
]]

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("VĨ LỎ - PRO VIP", "DarkTheme")

-- --- TẠO NÚT ẨN/HIỆN DI CHUYỂN ĐƯỢC ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "ViloControl"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Position = UDim2.new(0, 10, 0, 200)
ToggleButton.Size = UDim2.new(0, 65, 0, 35)
ToggleButton.Text = "ẨN/HIỆN"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true -- Cho phép ní cầm nút kéo đi chỗ khác

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Fix lỗi bấm không ăn: Gọi trực tiếp lệnh đóng/mở của Kavo
ToggleButton.MouseButton1Click:Connect(function()
    local coreGui = game:GetService("CoreGui")
    for _, v in pairs(coreGui:GetChildren()) do
        if v.Name == "VĨ LỎ - PRO VIP" or v:FindFirstChild("Main") then
            v.Enabled = not v.Enabled
        end
    end
end)

-- --- GIỮ NGUYÊN LOGIC HỆ THỐNG ---
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50
local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- --- TAB 1: MAIN ---
local Tab1 = Window:NewTab("🎮 Main")
local SecPOV = Tab1:NewSection("POV & AIM")

SecPOV:NewSlider("Chỉnh POV", "Tầm nhìn", 120, 50, function(s)
    Camera.FieldOfView = s
end)

SecPOV:NewToggle("Bật Aimbot", "Khóa mục tiêu", function(state)
    _G.Aimbot_Enabled = state
end)

-- --- TAB 2: FLY & ESP ---
local Tab2 = Window:NewTab("🦅 Fly & ESP")
local SecFly = Tab2:NewSection("Chức Năng")

SecFly:NewToggle("Bật Fly", "Bay lượn", function(state)
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
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = false end
        end)
    end
end)

SecFly:NewSlider("Tốc Độ Bay", "Speed", 250, 10, function(s) _G.FlySpeed = s end)

SecFly:NewToggle("Bật ESP", "Soi đỏ", function(state) _G.ESP_Enabled = state end)

-- VÒNG LẶP RENDER (GIỮ NGUYÊN ĐỂ KHÔNG LỖI)
game:GetService("RunService").RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character then
            local highlight = v.Character:FindFirstChild("ViloHighlight")
            if _G.ESP_Enabled then
                if not highlight then
                    local h = Instance.new("Highlight", v.Character)
                    h.Name = "ViloHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            elseif highlight then highlight:Destroy() end
        end
    end
    -- Aimbot Logic
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
