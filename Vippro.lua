local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HẮC KỶ TỬ - PRO VIP",
   LoadingTitle = "Hệ Thống Vĩ Lỏ Đang Chạy...",
   LoadingSubtitle = "by Nguyễn Vĩ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- --- BIẾN ĐIỀU KHIỂN (THEO CODE MỚI CỦA NÍ) ---
_G.Aimbot_Enabled = false
_G.FOVSize = 200          -- To như vòng trong ảnh
_G.AimPart = "Head"
_G.TeamCheck = true
_G.Prediction = 0.12      -- Prediction vừa đủ
_G.SmoothSpeed = 0.35     -- Mượt như pro
_G.InfAmmo_Enabled = false
_G.ESP_Enabled = false
_G.Noclip_Enabled = false
_G.Fly_Enabled = false
_G.FlySpeed = 50

-- --- FOV CIRCLE XANH DƯƠNG (GIỐNG HỆT ẢNH) ---
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 3
fovCircle.Color = Color3.fromRGB(0, 170, 255)  -- Xanh dương chuẩn
fovCircle.Filled = false
fovCircle.Transparency = 0.6
fovCircle.NumSides = 120
fovCircle.Radius = _G.FOVSize
fovCircle.Visible = false

-- --- HÀM TÌM TARGET (CODE MỚI) ---
local function getClosestPlayer()
    local closest, shortest = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(_G.AimPart) then
            if _G.TeamCheck and plr.Team == LocalPlayer.Team then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character[_G.AimPart].Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < shortest and dist < _G.FOVSize then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

-- --- TAB MAIN ---
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)

Tab1:CreateToggle({
   Name = "BẬT AIMBOT (GIỮ CHUỘT PHẢI)",
   CurrentValue = false,
   Callback = function(v) _G.Aimbot_Enabled = v; fovCircle.Visible = v end,
})

Tab1:CreateToggle({
   Name = "TEAM CHECK",
   CurrentValue = true,
   Callback = function(v) _G.TeamCheck = v end,
})

Tab1:CreateInput({
   Name = "CHỈNH VÒNG FOV",
   PlaceholderText = "200",
   Callback = function(t) if tonumber(t) then _G.FOVSize = tonumber(t); fovCircle.Radius = tonumber(t) end end,
})

Tab1:CreateToggle({
   Name = "VÔ HẠN ĐẠN (FIX ARSENAL)",
   CurrentValue = false,
   Callback = function(v)
      _G.InfAmmo_Enabled = v
      if v then
         local old
         old = hookmetamethod(game, "__index", function(self, key)
            if _G.InfAmmo_Enabled and (key == "Ammo" or key == "Clip" or key == "CurrentAmmo") then
               return 999
            end
            return old(self, key)
         end)
      end
   end,
})

Tab1:CreateToggle({
   Name = "NOCLIP (XUYÊN TƯỜNG)",
   CurrentValue = false,
   Callback = function(v) _G.Noclip_Enabled = v end,
})

-- --- TAB FLY & ESP ---
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
Tab2:CreateToggle({
   Name = "BẬT ESP",
   CurrentValue = false,
   Callback = function(v) _G.ESP_Enabled = v end,
})
Tab2:CreateToggle({
   Name = "BẬT FLY",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly_Enabled = Value
      if Value then
         local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
         local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
         bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         spawn(function()
            while _G.Fly_Enabled do
               task.wait()
               if LocalPlayer.Character then
                  LocalPlayer.Character.Humanoid.PlatformStand = true
                  bv.velocity = LocalPlayer.Character.Humanoid.MoveDirection * _G.FlySpeed
                  bg.cframe = Camera.CFrame
               end
            end
            bv:Destroy(); bg:Destroy()
            if LocalPlayer.Character then LocalPlayer.Character.Humanoid.PlatformStand = false end
         end)
      end
   end,
})

-- --- VÒNG LẶP XỬ LÝ (RENDER) ---
RunService.RenderStepped:Connect(function()
    fovCircle.Position = UserInputService:GetMouseLocation()
    
    -- AIMBOT SMOOTH + CHỈ KHI GIỮ CHUỘT PHẢI
    if _G.Aimbot_Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = target.Character[_G.AimPart].Position
            local vel = (target.Character:FindFirstChild("HumanoidRootPart") and target.Character.HumanoidRootPart.Velocity) or Vector3.zero
            
            local predictedPos = targetPos + vel * _G.Prediction
            local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
            
            -- SMOOTH LERP (KHÔNG GIẬT TÂM)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.SmoothSpeed)
        end
    end

    -- ESP Fix
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if _G.ESP_Enabled then
                if not v.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight", v.Character).FillColor = Color3.fromRGB(255, 0, 0)
                end
            else
                local h = v.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    end
end)

-- Noclip & Stepped
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = not _G.Noclip_Enabled end
        end
    end
end)

-- Toggle Phím Right Ctrl
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        _G.Aimbot_Enabled = not _G.Aimbot_Enabled
        fovCircle.Visible = _G.Aimbot_Enabled
    end
end)
