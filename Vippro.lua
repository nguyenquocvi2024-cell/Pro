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

_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.Noclip_Enabled = false
_G.InfJump_Enabled = false
_G.InfAmmo_Enabled = false
_G.FlySpeed = 50
_G.HitboxSize = 2

-- --- TẠO NÚT BẬT/TẮT AIM NHANH (FLOAT BUTTON) ---
local AimGui = Instance.new("ScreenGui")
local AimBtn = Instance.new("TextButton")
local AimCorner = Instance.new("UICorner")

AimGui.Parent = game.CoreGui
AimBtn.Parent = AimGui
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimBtn.Size = UDim2.new(0, 60, 0, 60)
AimBtn.Position = UDim2.new(0, 10, 0, 300)
AimBtn.Text = "AIM: OFF"
AimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBtn.Draggable = true
AimBtn.Active = true
AimCorner.Parent = AimBtn

AimBtn.MouseButton1Click:Connect(function()
    _G.Aimbot_Enabled = not _G.Aimbot_Enabled
    AimBtn.Text = _G.Aimbot_Enabled and "AIM: ON" or "AIM: OFF"
    AimBtn.BackgroundColor3 = _G.Aimbot_Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- --- TAB MAIN ---
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)

Tab1:CreateToggle({
   Name = "Bật Vô Hạn Đạn (Fix Arsenal)",
   CurrentValue = false,
   Flag = "InfAmmo",
   Callback = function(Value)
      _G.InfAmmo_Enabled = Value
      -- Hook hệ thống đạn cho Arsenal và các game chuyên nghiệp
      if Value then
          local old
          old = hookmetamethod(game, "__index", function(self, key)
              if _G.InfAmmo_Enabled and tostring(self) == "Ammo" or tostring(self) == "Clip" or key == "Ammo" then
                  return 999
              end
              return old(self, key)
          end)
      end
   end,
})

Tab1:CreateInput({
   Name = "Hitbox Expander (0-300)",
   PlaceholderText = "Nhập số...",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.HitboxSize = num end
   end,
})

Tab1:CreateToggle({
   Name = "Infinity Jump",
   CurrentValue = false,
   Callback = function(v) _G.InfJump_Enabled = v end,
})

Tab1:CreateToggle({
   Name = "Noclip (Xuyên Tường)",
   CurrentValue = false,
   Callback = function(v) _G.Noclip_Enabled = v end,
})

-- --- TAB SPEED & JUMP ---
local TabSpeed = Window:CreateTab("⚡ Speed & Jump", 4483362458)
TabSpeed:CreateInput({
   Name = "WalkSpeed",
   PlaceholderText = "16",
   Callback = function(t) if tonumber(t) then LP.Character.Humanoid.WalkSpeed = tonumber(t) end end,
})
TabSpeed:CreateInput({
   Name = "JumpPower",
   PlaceholderText = "50",
   Callback = function(t) if tonumber(t) then LP.Character.Humanoid.JumpPower = tonumber(t) end end,
})

-- --- TAB FLY & ESP ---
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
Tab2:CreateToggle({
   Name = "Bật ESP",
   CurrentValue = false,
   Callback = function(v) _G.ESP_Enabled = v end,
})
Tab2:CreateToggle({
   Name = "Fly (Điều Khiển Tay)",
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

-- --- HỆ THỐNG XỬ LÝ FIX LỖI ---
RunService.Stepped:Connect(function()
    -- Noclip
    if _G.Noclip_Enabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    -- ESP Fix
    if _G.ESP_Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and not v.Character:FindFirstChild("ViloHighlight") then
                local h = Instance.new("Highlight", v.Character)
                h.Name = "ViloHighlight"
                h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- Hitbox
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            v.Character.HumanoidRootPart.Transparency = 0.8
        end
    end
    -- Aimbot Fix: Chống kẹt tâm khi nhìn xuống đất
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
            local targetPos = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos) 
        end
    end
end)

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and LP.Character then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)
