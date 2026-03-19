local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "VĨ LỎ - PRO VIP",
   LoadingTitle = "Đang Tải Script...",
   LoadingSubtitle = "by Vĩ Lỏ",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50
_G.FullBright_Enabled = false -- Biến cho nhìn trong tối

local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local Tab1 = Window:CreateTab("🎮 Main", 4483362458)
local SecAim = Tab1:CreateSection("Tự Ngắm & Ánh Sáng")

Tab1:CreateInput({
   Name = "Nhập POV (50-120)",
   PlaceholderText = "Mặc định: 70",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then Camera.FieldOfView = num end
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
         Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
      else
         Lighting.Brightness = 1
         Lighting.ClockTime = 12
         Lighting.FogEnd = 10000
         Lighting.GlobalShadows = true
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
         Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

Tab1:CreateToggle({
   Name = "Bật Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
      _G.Aimbot_Enabled = Value
   end,
})

local Tab2 = Window:CreateTab("🦅 Chức Năng", 4483362458)
local SecFly = Tab2:CreateSection("Bay & ESP")

Tab2:CreateToggle({
   Name = "Bật Fly",
   CurrentValue = false,
   Flag = "Fly",
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
                    bv.velocity = Camera.CFrame.LookVector * _G.FlySpeed
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
   Name = "Nhập Tốc Độ Fly (10-300)",
   PlaceholderText = "Nhập số...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.FlySpeed = num end
   end,
})

Tab2:CreateToggle({
   Name = "Bật ESP (Soi Đỏ)",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      _G.ESP_Enabled = Value
   end,
})

game:GetService("RunService").RenderStepped:Connect(function()
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
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ViloHighlight") then
                v.Character.ViloHighlight:Destroy()
            end
        end
    end
    
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
