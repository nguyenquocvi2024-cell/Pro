local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HẮC KỶ TỬ - PRO VIP",
   LoadingTitle = "Hệ Thống Vĩ Lỏ Đang Chạy...",
   LoadingSubtitle = "by Nguyễn Vĩ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- --- TẤT CẢ BIẾN CẤM XÓA ---
_G.Aimbot_Enabled = false
_G.FOVCircle_Enabled = false
_G.FOVSize = 150
_G.InfAmmo_Enabled = false
_G.ESP_Enabled = false
_G.Noclip_Enabled = false
_G.InfJump_Enabled = false
_G.FullBright_Enabled = false
_G.Fly_Enabled = false
_G.FlySpeed = 50
_G.HitboxSize = 2

-- --- KHỞI TẠO VÒNG POV XANH (GIỐNG ẢNH 100%) ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 999

-- --- NÚT AIM NỔI (FLOAT BUTTON) ---
local AimGui = Instance.new("ScreenGui", game.CoreGui)
local AimBtn = Instance.new("TextButton", AimGui)
AimBtn.Size = UDim2.new(0, 65, 0, 65)
AimBtn.Position = UDim2.new(0, 10, 0, 300)
AimBtn.Text = "AIM: OFF"
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBtn.Draggable = true
AimBtn.Active = true
Instance.new("UICorner", AimBtn)

AimBtn.MouseButton1Click:Connect(function()
    _G.Aimbot_Enabled = not _G.Aimbot_Enabled
    AimBtn.Text = _G.Aimbot_Enabled and "AIM: ON" or "AIM: OFF"
    AimBtn.BackgroundColor3 = _G.Aimbot_Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- --- MỤC CHÍNH (MAIN) ---
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)

Tab1:CreateToggle({
   Name = "HIỆN VÒNG POV (VÙNG NGẮM)",
   CurrentValue = false,
   Callback = function(v) _G.FOVCircle_Enabled = v end,
})

Tab1:CreateInput({
   Name = "CHỈNH KÍCH THƯỚC VÒNG POV",
   PlaceholderText = "150",
   Callback = function(t) if tonumber(t) then _G.FOVSize = tonumber(t) end end,
})

Tab1:CreateToggle({
   Name = "BẬT AIMBOT (KHÓA TÂM CHUẨN)",
   CurrentValue = false,
   Callback = function(v) 
      _G.Aimbot_Enabled = v 
      AimBtn.Text = v and "AIM: ON" or "AIM: OFF"
      AimBtn.BackgroundColor3 = v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
   end,
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

Tab1:CreateInput({
   Name = "HITBOX EXPANDER (0-300)",
   PlaceholderText = "Nhập số...",
   Callback = function(t) if tonumber(t) then _G.HitboxSize = tonumber(t) end end,
})

Tab1:CreateToggle({
   Name = "INFINITY JUMP (NHẢY VÔ HẠN)",
   CurrentValue = false,
   Callback = function(v) _G.InfJump_Enabled = v end,
})

Tab1:CreateToggle({
   Name = "NOCLIP (XUYÊN TƯỜNG - FIXED)",
   CurrentValue = false,
   Callback = function(v) _G.Noclip_Enabled = v end,
})

-- --- MỤC TỐC ĐỘ & NHẢY (SPEED OF JUMP) ---
local TabSpeed = Window:CreateTab("⚡ Speed & Jump", 4483362458)
TabSpeed:CreateInput({
   Name = "CHẠY NHANH (WALKSPEED)",
   PlaceholderText = "16",
   Callback = function(t) if tonumber(t) and LP.Character then LP.Character.Humanoid.WalkSpeed = tonumber(t) end end,
})
TabSpeed:CreateInput({
   Name = "NHẢY CAO (JUMPPOWER)",
   PlaceholderText = "50",
   Callback = function(t) if tonumber(t) and LP.Character then LP.Character.Humanoid.JumpPower = tonumber(t) end end,
})

-- --- MỤC BAY & ESP ---
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
Tab2:CreateToggle({
   Name = "BẬT ESP (CHỐNG RÁC)",
   CurrentValue = false,
   Callback = function(v) _G.ESP_Enabled = v end,
})

Tab2:CreateToggle({
   Name = "BẬT FLY (ĐIỀU KHIỂN TAY)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly_Enabled = Value
      if Value then
         local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
         local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
         bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
         bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         spawn(function()
            while _G.Fly_Enabled do
               task.wait()
               if LP.Character then
                  LP.Character.Humanoid.PlatformStand = true
                  bv.velocity = LP.Character.Humanoid.MoveDirection * _G.FlySpeed
                  bg.cframe = Camera.CFrame
               end
            end
            bv:Destroy(); bg:Destroy()
            if LP.Character then LP.Character.Humanoid.PlatformStand = false end
         end)
      end
   end,
})

Tab2:CreateInput({
   Name = "TỐC ĐỘ BAY (FLY SPEED)",
   PlaceholderText = "50",
   Callback = function(t) if tonumber(t) then _G.FlySpeed = tonumber(t) end end,
})

-- --- HỆ THỐNG XỬ LÝ RENDER (QUAN TRỌNG NHẤT) ---
RunService.RenderStepped:Connect(function()
    -- Vòng POV hiện xanh chuẩn 100%
    FOVCircle.Visible = _G.FOVCircle_Enabled
    FOVCircle.Radius = _G.FOVSize
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Aimbot Chống Chúi Đất & Khóa Tâm Mượt
    if _G.Aimbot_Enabled then
        local target = nil
        local dist = _G.FOVSize
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
            local lookAtPos = target.Character.Head.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, lookAtPos), 0.2)
        end
    end

    -- Hitbox & ESP Fix Rác Highlight
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            v.Character.HumanoidRootPart.Transparency = 0.8
            if _G.ESP_Enabled then
                if not v.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", v.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            else
                local h = v.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    -- Noclip Fix Tắt/Bật chuẩn
    if LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = not _G.Noclip_Enabled end
        end
    end
    -- Vô hạn đạn quét Tool
    if _G.InfAmmo_Enabled and LP.Character then
        for _, tool in pairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in pairs(tool:GetDescendants()) do
                    if v:IsA("IntValue") and (v.Name == "Ammo" or v.Name == "Clip") then v.Value = 999 end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and LP.Character then LP.Character.Humanoid:ChangeState("Jumping") end
end)
