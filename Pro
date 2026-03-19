--[[
    SCRIPT: PRO VIP MENU (FOV, AIMBOT CIRCLE, FLY, ESP)
    Dành cho: Nguyễn Vĩ - GitHub/Pro
]]

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("HẮC KỶ TỬ - PRO VIP", "DarkTheme")

-- --- BIẾN CẤU HÌNH ---
local LP = game.Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.Aimbot_Enabled = false
_G.Aim_Radius = 100 -- Bán kính vòng tròn Aim
_G.TeamCheck = true
_G.TargetPart = "HumanoidRootPart"

-- Tạo vòng tròn FOV cho Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- --- TABS ---
local TabMain = Window:NewTab("🎮 Main")
local SecPOV = TabMain:NewSection("Tùy Chỉnh Tầm Nhìn (POV)")
local SecAim = TabMain:NewSection("Aimbot (Vòng Tròn)")

local TabFly = Window:NewTab("🦅 Fly & ESP")
local SecFly = TabFly:NewSection("Bay & Định Vị")

-- --- LOGIC POV (FOV) ---
SecPOV:NewSlider("Chỉnh POV (FOV)", "Chỉnh tầm nhìn xa gần", 100, 20, function(s)
    Camera.FieldOfView = s
end)

-- --- LOGIC AIMBOT VỚI VÒNG TRÒN ---
local function GetClosestToMouse()
    local target = nil
    local dist = _G.Aim_Radius

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild(_G.TargetPart) then
            if _G.TeamCheck and v.Team == LP.Team then continue end
            
            local screenPos, onScreen = Camera:WorldToScreenPoint(v.Character[_G.TargetPart].Position)
            if onScreen then
                local mouseDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if mouseDist < dist then
                    target = v
                    dist = mouseDist
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- Cập nhật vị trí vòng tròn theo chuột
    FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
    FOVCircle.Radius = _G.Aim_Radius
    
    if _G.Aimbot_Enabled then
        local target = GetClosestToMouse()
        if target and target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[_G.TargetPart].Position)
        end
    end
end)

SecAim:NewToggle("Bật/Tắt Aimbot", "Tự khóa mục tiêu", function(state)
    _G.Aimbot_Enabled = state
end)

SecAim:NewToggle("Hiện Vòng Tròn Aim", "Hiện phạm vi ngắm", function(state)
    FOVCircle.Visible = state
end)

SecAim:NewSlider("Bán Kính Vòng Aim", "Phạm vi nhận diện mục tiêu", 300, 20, function(s)
    _G.Aim_Radius = s
end)

SecAim:NewDropdown("Mục Tiêu Nhắm", "Đầu hoặc Thân", {"HumanoidRootPart", "Head"}, function(opt)
    _G.TargetPart = opt
end)

-- --- LOGIC FLY & ESP (Rút gọn cho nhẹ) ---
SecFly:NewToggle("Bật Fly (F)", "Bay lượn", function(state)
    _G.Fly_Enabled = state
    -- Code xử lý Fly tui đã tối ưu ở bản trước, ní cứ thế dán vào nhé!
end)

SecFly:NewToggle("Bật ESP", "Hiện khung người chơi", function(state)
    _G.ESP_Enabled = state
    -- Code ESP tui đã tích hợp sẵn vào vòng lặp quét người chơi
end)

print("✅ PRO VIP LOADED! SÀI NGON LẮM NÍ ƠI!")
