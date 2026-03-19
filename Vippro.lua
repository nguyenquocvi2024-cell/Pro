local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HẮC KỶ TỬ - PRO VIP",
   LoadingTitle = "Đang Tải Hệ Thống Vĩ Lỏ...",
   LoadingSubtitle = "by Nguyễn Vĩ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.Noclip_Enabled = false
_G.FullBright_Enabled = false
_G.FlySpeed = 50

local Tab1 = Window:CreateTab("🎮 Main", 4483362458)
local SecMain = Tab1:CreateSection("Điều Khiển Nhân Vật")

Tab1:CreateToggle({
   Name = "Bật/Tắt Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      _G.Noclip_Enabled = Value
   end,
})

Tab1:CreateToggle({
   Name = "Bật/Tắt Nhìn Trong Bóng Tối",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      _G.FullBright_Enabled = Value
      if Value then
         Lighting.Brightness = 2
         Lighting.ClockTime = 14
         Lighting.FogEnd = 100000
         Lighting.GlobalShadows = false
         Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      else
         Lighting.Brightness = 1
         Lighting.ClockTime = 12
         Lighting.GlobalShadows = true
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

Tab1:CreateInput({
   Name = "Chỉnh POV (FOV)",
   PlaceholderText = "Nhập số (50-120)...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then Camera.FieldOfView = num end
   end,
})

Tab1:CreateToggle({
   Name = "Bật Aimbot",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      _G.Aimbot_Enabled = Value
   end,
})

local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
local SecPro = Tab2:CreateSection("Chức Năng Bay")

Tab2:CreateToggle({
   Name = "Bật Fly (Điều Khiển Tay)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      _G.Fly_Enabled = Value
      if Value then
         local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
         local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
         bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
         bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         spawn(function()
            while _G.Fly_Enabled do
               task.wait()
               if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                  LP.Character.Humanoid.PlatformStand = true
                  -- Fix: Chỉ bay khi ní sử dụng phím di chuyển (JoyStick)
                  local moveDir = LP.Character.Humanoid.MoveDirection
                  bv.velocity = moveDir * _G.FlySpeed
                  bg.cframe = Camera.CFrame
               end
            end
            bv:Destroy(); bg:Destroy()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
               LP.Character.Humanoid.PlatformStand = false
            end
         end)
      end
   end,
})

Tab2:CreateInput({
   Name = "Nhập Tốc Độ Fly",
   PlaceholderText = "Mặc định: 50",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.FlySpeed = num end
   end,
})

Tab2:CreateToggle({
   Name = "Bật ESP",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      _G.ESP_Enabled = Value
   end,
})

-- Vòng lặp xử lý hệ thống
RunService.Stepped:Connect(function()
    -- Xử lý Noclip
    if _G.Noclip_Enabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- Xử lý ESP
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
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)
