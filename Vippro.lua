--[[
    SCRIPT: VĨ LỎ MENU FINAL FIX
    - Hỗ trợ kéo thả Menu (Draggable)
    - Fix Slider & ESP Highlight
    - Nút Ẩn/Hiện chuyên nghiệp
]]

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("VĨ LỎ - PRO VIP", "DarkTheme")

-- --- FIX KÉO THẢ MENU (Cho điện thoại đứng im) ---
-- Tính năng này giúp ní có thể chạm vào thanh tiêu đề để di chuyển Menu
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v:FindFirstChild("Main") then
        local main = v.Main
        main.Active = true
        main.Draggable = true -- Cho phép kéo thả tự do
    end
end

-- --- NÚT ẨN/HIỆN (VỊ TRÍ MỚI) ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BorderSizePixel = 2
ToggleButton.Position = UDim2.new(0, 5, 0, 200)
ToggleButton.Size = UDim2.new(0, 60, 0, 40)
ToggleButton.Text = "ẨN/HIỆN"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.TextSize = 10
local UICorner = Instance.new("UICorner")
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
end)

-- --- BIẾN HỆ THỐNG ---
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50
local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- --- TAB 1: CHỈNH NHÌN ---
local Tab1 = Window:NewTab("🎮 Main")
local SecPOV = Tab1:NewSection("POV & AIM")

SecPOV:NewSlider("Chỉnh POV", "Mở rộng tầm nhìn", 120, 50, function(s)
    Camera.FieldOfView = s
end)

SecPOV:NewToggle("Bật Aimbot", "Tự khóa mục tiêu", function(state)
    _G.Aimbot_Enabled = state
end)

-- --- TAB 2: BAY & ESP ---
local Tab2 = Window:NewTab("🦅 Fly & ESP")
local SecFly = Tab2:NewSection("Chức Năng Pro")

-- Logic Fly (Đã tối ưu cho di động)
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
                LP.Character.Humanoid.PlatformStand = true
                bv.velocity = Camera.CFrame.LookVector * _G.FlySpeed
                bg.cframe = Camera.CFrame
            end
            bv:Destroy(); bg:Destroy()
            LP.Character.Humanoid.PlatformStand = false
        end)
    end
end)

SecFly:NewSlider("Tốc Độ Bay", "Kéo chậm để tránh lỗi", 250, 10, function(s)
    _G.FlySpeed = s
end)

-- Logic ESP Highlight (Màu đỏ rực)
SecFly:NewToggle("Bật ESP", "Nhìn xuyên tường", function(state)
    _G.ESP_Enabled = state
end)

-- Vòng lặp quét liên tục (Fix lỗi ESP không hiện)
game:GetService("RunService").RenderStepped:Connect(function()
    -- Xử lý ESP
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character then
            local highlight = v.Character:FindFirstChild("ViloHighlight")
            if _G.ESP_Enabled then
                if not highlight then
                    local h = Instance.new("Highlight")
                    h.Name = "ViloHighlight"
                    h.Parent = v.Character
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
    
    -- Xử lý Aimbot
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
