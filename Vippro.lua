local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Hệ Thống Vĩ DZ - PRO VIP",
   LoadingTitle = "Đang Tải Hệ Thống Vĩ Lỏ...",
   LoadingSubtitle = "by Nguyễn Vĩ + TEAM",
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
_G.FullBright_Enabled = false
_G.InfJump_Enabled = false
_G.FlySpeed = 50
_G.HitboxSize = 2

local Tab1 = Window:CreateTab("🎮 Main", 4483362458)
local SecMain = Tab1:CreateSection("Tính Năng Bổ Trợ")

Tab1:CreateToggle({
   Name = "Bật Infinity Jump (Nhảy Vô Hạn)",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      _G.InfJump_Enabled = Value
   end,
})

Tab1:CreateInput({
   Name = "Mở Rộng Hitbox (0-300)",
   PlaceholderText = "Nhập kích thước (VD: 20)...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.HitboxSize = num end
   end,
})

Tab1:CreateToggle({
   Name = "Bật Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      _G.Noclip_Enabled = Value
   end,
})

Tab1:CreateToggle({
   Name = "Bật Nhìn Trong Bóng Tối",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      _G.FullBright_Enabled = Value
      if Value then
         Lighting.Brightness = 2
         Lighting.ClockTime = 14
         Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      else
         Lighting.Brightness = 1
         Lighting.ClockTime = 12
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

local TabSpeed = Window:CreateTab("⚡ Speed & Jump", 4483362458)
local SecSpeed = TabSpeed:CreateSection("Tùy Chỉnh Thân Thể")

TabSpeed:CreateInput({
   Name = "Tùy Chỉnh Chạy Nhanh",
   PlaceholderText = "Mặc định: 16",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num and LP.Character and LP.Character:FindFirstChild("Humanoid") then
         LP.Character.Humanoid.WalkSpeed = num
      end
   end,
})

TabSpeed:CreateInput({
   Name = "Tùy Chỉnh Nhảy Cao",
   PlaceholderText = "Mặc định: 50",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num and LP.Character and LP.Character:FindFirstChild("Humanoid") then
         LP.Character.Humanoid.JumpPower = num
      end
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

-- Xử lý Nhảy Vô Hạn
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Vòng lặp xử lý liên tục
RunService.Stepped:Connect(function()
    if _G.Noclip_Enabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- Xử lý Hitbox Expander
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            v.Character.HumanoidRootPart.Transparency = 0.7
            v.Character.HumanoidRootPart.CanCollide = false
        end
    end

    -- ESP & Aimbot giữ nguyên như cũ...
end)
