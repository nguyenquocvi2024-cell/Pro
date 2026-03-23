-- [[ HỆ THỐNG VĨ LỎ - PRO VIP EDITION ]]
-- [[ FULL UPGRADE: SPEED, JUMP, FLY, ESP, TP, FLING ]]
-- [[ BY NGUYỄN VĨ DZ ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Hệ thống Vĩ lỏ - PRO VIP",
   LoadingTitle = "Đang Tải Hệ Thống Vĩ Lỏ...",
   LoadingSubtitle = "by Nguyễn Vĩ DZ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- [[ BIẾN HỆ THỐNG ]]
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.Noclip_Enabled = false
_G.FullBright_Enabled = false
_G.InfJump_Enabled = false
_G.FlySpeed = 50
_G.WalkSpeed = 16
_G.JumpPower = 50
local SelectedPlayer = nil

-- [[ TAB 1: MAIN ]]
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)
local SecMain = Tab1:CreateSection("Điều Khiển Nhân Vật")

Tab1:CreateSlider({
   Name = "Tốc Độ Chạy (Speed)",
   Min = 16, Max = 500, Default = 16, Color = Color3.fromRGB(0, 255, 127), Increment = 1, ValueName = "Speed",
   Callback = function(Value) _G.WalkSpeed = Value end,
})

Tab1:CreateSlider({
   Name = "Độ Cao Nhảy (Jump)",
   Min = 50, Max = 500, Default = 50, Color = Color3.fromRGB(0, 255, 127), Increment = 1, ValueName = "Power",
   Callback = function(Value) _G.JumpPower = Value end,
})

Tab1:CreateToggle({
   Name = "Nhảy Vô Hạn (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value) _G.InfJump_Enabled = Value end,
})

Tab1:CreateToggle({
   Name = "Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value) _G.Noclip_Enabled = Value end,
})

Tab1:CreateToggle({
   Name = "Nhìn Trong Bóng Tối (FullBright)",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      _G.FullBright_Enabled = Value
      if Value then
         Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
         Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      else
         Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.GlobalShadows = true
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

Tab1:CreateInput({
   Name = "Chỉnh POV (FOV)",
   PlaceholderText = "Nhập số (50-120)...",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then Camera.FieldOfView = num end
   end,
})

Tab1:CreateToggle({
   Name = "Bật Aimbot",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value) _G.Aimbot_Enabled = Value end,
})

-- [[ TAB 2: CHẾ (TELEPORT & FLING) ]]
local TabChe = Window:CreateTab("🌀 Chế", 4483362458)
local SecChe = TabChe:CreateSection("Phá Đứa Khác")

local function GetPlayerList()
    local p = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP then table.insert(p, v.Name) end
    end
    return p
end

local PlayerDropdown = TabChe:CreateDropdown({
   Name = "Chọn Mục Tiêu",
   Options = GetPlayerList(),
   CurrentOption = "",
   Flag = "PlayerTarget",
   Callback = function(Option) SelectedPlayer = Option end,
})

TabChe:CreateButton({
   Name = "Làm Mới Danh Sách",
   Callback = function() PlayerDropdown:Refresh(GetPlayerList()) end,
})

TabChe:CreateButton({
   Name = "Bay Đến Nó (TP)",
   Callback = function()
      if SelectedPlayer then
         local t = game.Players:FindFirstChild(SelectedPlayer)
         if t and t.Character then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
      end
   end,
})

TabChe:CreateButton({
   Name = "Fling (Làm Văng Nó)",
   Callback = function()
      if SelectedPlayer then
         local target = game.Players:FindFirstChild(SelectedPlayer)
         if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local thrust = Instance.new("BodyAngularVelocity", LP.Character.HumanoidRootPart)
            thrust.MaxTorque = Vector3.new(0, math.huge, 0)
            thrust.P = math.huge
            thrust.AngularVelocity = Vector3.new(0, 99999, 0)
            
            local oldPos = LP.Character.HumanoidRootPart.CFrame
            _G.Noclip_Enabled = true
            for i = 1, 60 do
                task.wait(0.01)
                LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
            thrust:Destroy()
            LP.Character.HumanoidRootPart.CFrame = oldPos
            _G.Noclip_Enabled = false
         end
      end
   end,
})

-- [[ TAB 3: FLY & ESP ]]
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
local SecPro = Tab2:CreateSection("Bay Lượn & Nhìn Xuyên")

Tab2:CreateToggle({
   Name = "Bật Fly (Joystick)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      _G.Fly_Enabled = Value
      if Value then
         local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
         local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
         bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         spawn(function()
            while _G.Fly_Enabled do
               task.wait()
               if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                  LP.Character.Humanoid.PlatformStand = true
                  bv.velocity = LP.Character.Humanoid.MoveDirection * _G.FlySpeed
                  bg.cframe = Camera.CFrame
               end
            end
            bv:Destroy(); bg:Destroy()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = false end
         end)
      end
   end,
})

Tab2:CreateInput({
   Name = "Tốc Độ Fly",
   PlaceholderText = "50",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.FlySpeed = num end
   end,
})

Tab2:CreateToggle({
   Name = "Bật ESP (Highlight Red)",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      _G.ESP_Enabled = Value
      if not Value then
         for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ViloHighlight") then v.Character.ViloHighlight:Destroy() end
         end
      end
   end,
})

-- [[ LOGIC XỬ LÝ CHẠY NGẦM ]]
UIS.JumpRequest:Connect(function()
    if _G.InfJump_Enabled then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        LP.Character.Humanoid.JumpPower = _G.JumpPower
    end
    if _G.Noclip_Enabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.ESP_Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character then
                if not v.Character:FindFirstChild("ViloHighlight") then
                    local h = Instance.new("Highlight", v.Character)
                    h.Name = "ViloHighlight"; h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
    if _G.Aimbot_Enabled then
        local target = nil; local dist = 400
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
