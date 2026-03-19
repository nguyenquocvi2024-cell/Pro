--[[
    SCRIPT: VĨ LỎ MENU (Fix Ẩn/Hiện + Fly + ESP + Aim)
    Update: 19/03/2026
]]

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Sửa tên thành VĨ LỎ nè má
local Window = Kavo.CreateLib("VĨ LỎ - PRO VIP", "DarkTheme")

-- --- TẠO NÚT ẨN/HIỆN MENU (Dành riêng cho điện thoại) ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Position = UDim2.new(0, 10, 0, 150) -- Vị trí nút bên trái màn hình
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Text = "VĨ LỎ"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.TextSize = 12

-- Bo tròn cái nút cho đẹp
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 25)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
end)

-- --- CẤU HÌNH ---
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50
local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- --- TABS ---
local Tab1 = Window:NewTab("🎮 Main")
local SecPOV = Tab1:NewSection("POV & Aimbot")

local Tab2 = Window:NewTab("🦅 Fly & ESP")
local SecFly = Tab2:NewSection("Bay & Định Vị")

-- --- LOGIC POV ---
SecPOV:NewSlider("Chỉnh POV (FOV)", "Tầm nhìn rộng", 120, 20, function(s)
    Camera.FieldOfView = s
end)

-- --- LOGIC AIMBOT ---
SecPOV:NewToggle("Bật/Tắt Aimbot", "Tự khóa mục tiêu", function(state)
    _G.Aimbot_Enabled = state
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Aimbot_Enabled then
        local target = nil
        local dist = 500 -- Khoảng cách quét
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                local screenPos, onScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local d = (Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if d < dist then target = v; dist = d end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)

-- --- LOGIC FLY ---
SecFly:NewToggle("Bật Fly", "Bay vèo vèo", function(state)
    _G.Fly_Enabled = state
    if state then
        local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            while _G.Fly_Enabled do
                wait()
                LP.Character.Humanoid.PlatformStand = true
                bv.velocity = Camera.CFrame.LookVector * _G.FlySpeed
                bg.cframe = Camera.CFrame
            end
            bv:Destroy(); bg:Destroy()
            LP.Character.Humanoid.PlatformStand = false
        end)
    end
end)

SecFly:NewSlider("Tốc Độ Bay", "Bay nhanh chậm", 300, 10, function(s) _G.FlySpeed = s end)

-- --- LOGIC ESP ---
SecFly:NewToggle("Bật ESP", "Nhìn xuyên tường", function(state)
    _G.ESP_Enabled = state
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character then
                local esp = v.Character:FindFirstChild("ViloESP")
                if _G.ESP_Enabled then
                    if not esp then
                        local h = Instance.new("Highlight", v.Character)
                        h.Name = "ViloESP"
                        h.FillColor = Color3.fromRGB(255, 0, 0) -- Màu đỏ cho nó gắt
                    end
                else
                    if esp then esp:Destroy() end
                end
            end
        end
    end)
end)
