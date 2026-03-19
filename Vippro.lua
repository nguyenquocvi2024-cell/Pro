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
local UserInputService = game:GetService("UserInputService")

_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.Noclip_Enabled = false
_G.FullBright_Enabled = false
_G.InfJump_Enabled = false
_G.InfAmmo_Enabled = false
_G.FlySpeed = 50
_G.HitboxSize = 2

-- TAB MAIN
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)
local SecMain = Tab1:CreateSection("Tính Năng Bổ Trợ & Chiến Đấu")

Tab1:CreateToggle({
   Name = "Bật Aimbot (Khóa Mục Tiêu)",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      _G.Aimbot_Enabled = Value
   end,
})

Tab1:CreateToggle({
   Name = "Bật Vô Hạn Đạn (Tất Cả Map)",
   CurrentValue = false,
   Flag = "InfAmmo",
   Callback = function(Value)
      _G.InfAmmo_Enabled = Value
   end,
})

Tab1:CreateInput({
   Name = "Mở Rộng Hitbox (0-300)",
   PlaceholderText = "Nhập kích thước...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.HitboxSize = num end
   end,
})

Tab1:CreateToggle({
   Name = "Bật Infinity Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      _G.InfJump_Enabled = Value
   end,
})

Tab1:CreateToggle({
   Name = "Bật Noclip (Xuyên Tường)",
   CurrentValue = false,
   Flag = "Noclip",
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

-- TAB SPEED & JUMP
local TabSpeed = Window:CreateTab("⚡ Speed & Jump", 4483362458)
TabSpeed:CreateInput({
   Name = "Chỉnh Tốc Độ Chạy",
   PlaceholderText = "16",
   Callback = function(Text)
      local num = tonumber(Text)
      if num and LP.Character then LP.Character.Humanoid.WalkSpeed = num end
   end,
})

TabSpeed:CreateInput({
   Name = "Chỉnh Độ Cao Nhảy",
   PlaceholderText = "50",
   Callback = function(Text)
      local num = tonumber(Text)
      if num and LP.Character then LP.Character.Humanoid.JumpPower = num end
   end,
})

-- TAB FLY & ESP
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
Tab2:CreateToggle({
   Name = "Bật ESP (Đã Fix Lỗi)",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      _G.ESP_Enabled = Value
   end,
})

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
   Name = "Nhập Tốc Độ Fly",
   PlaceholderText = "50",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.FlySpeed = num end
   end,
})

-- HỆ THỐNG XỬ LÝ (KHÔNG ĐƯỢC XÓA)
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and LP.Character then
        LP.Character.Humanoid:ChangeState("Jumping")
    end
end)

RunService.Stepped:Connect(function()
    if _G.Noclip_Enabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    -- Fix ESP: Quét liên tục để hiện highlight
    if _G.ESP_Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character then
                if not v.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", v.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Highlight") then
                v.Character.Highlight:Destroy()
            end
        end
    end
    -- Vô hạn đạn (Cơ chế quét Tool)
    if _G.InfAmmo_Enabled then
        for _, v in pairs(LP.Character:GetChildren()) do
            if v:IsA("Tool") and (v:FindFirstChild("Ammo") or v:FindFirstChild("Clip")) then
                local ammo = v:FindFirstChild("Ammo") or v:FindFirstChild("Clip")
                if ammo:IsA("IntValue") or ammo:IsA("NumberValue") then ammo.Value = 999 end
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
    -- Aimbot
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
