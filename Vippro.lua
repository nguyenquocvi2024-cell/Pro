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

-- Biến lưu trữ (CẤM XÓA)
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.Noclip_Enabled = false
_G.InfJump_Enabled = false
_G.InfAmmo_Enabled = false
_G.FullBright_Enabled = false
_G.FlySpeed = 50
_G.HitboxSize = 2
_G.FOVSize = 150
_G.WalkSpeed = 16
_G.JumpPower = 50

-- Lưu giá trị Lighting gốc để Full Bright reset đúng
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

-- --- VẼ VÒNG POV ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- --- NÚT AIM FLOAT ---
local AimGui = Instance.new("ScreenGui")
local AimBtn = Instance.new("TextButton")
local AimCorner = Instance.new("UICorner")

AimGui.Parent = game.CoreGui
AimBtn.Parent = AimGui
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimBtn.Size = UDim2.new(0, 65, 0, 65)
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

-- === HOOK VÔ HẠN ĐẠN (CHỈ 1 LẦN) ===
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if _G.InfAmmo_Enabled and (key == "Ammo" or key == "Clip" or key == "CurrentAmmo") then
        return 999
    end
    return oldIndex(self, key)
end)

-- === TAB MAIN ===
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)

Tab1:CreateToggle({
   Name = "Bật Vòng POV (Vùng Aim)",
   CurrentValue = false,
   Callback = function(v) _G.FOVCircle_Enabled = v; FOVCircle.Visible = v end,
})

Tab1:CreateInput({
   Name = "Kích Thước Vòng Aim",
   PlaceholderText = "Mặc định 150...",
   Callback = function(t) if tonumber(t) then _G.FOVSize = tonumber(t) end end,
})

Tab1:CreateToggle({
   Name = "Bật Aimbot (Trong Vòng POV)",
   CurrentValue = false,
   Callback = function(v) 
      _G.Aimbot_Enabled = v 
      AimBtn.Text = v and "AIM: ON" or "AIM: OFF"
      AimBtn.BackgroundColor3 = v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
   end,
})

Tab1:CreateToggle({
   Name = "Vô Hạn Đạn (Arsenal Hook)",
   CurrentValue = false,
   Callback = function(v) _G.InfAmmo_Enabled = v end,
})

Tab1:CreateInput({
   Name = "Mở Rộng Hitbox (1-1000, không giới hạn)",
   PlaceholderText = "Nhập số...",
   Callback = function(t) 
      local num = tonumber(t)
      if num and num >= 1 then _G.HitboxSize = num end 
   end,
})

Tab1:CreateToggle({
   Name = "Full Bright (Ánh Sáng Vô Hạn)",
   CurrentValue = false,
   Callback = function(v) _G.FullBright_Enabled = v end,
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

-- === TAB SPEED & JUMP (giữ sau chết) ===
local TabSpeed = Window:CreateTab("⚡ Speed & Jump", 4483362458)

TabSpeed:CreateInput({
   Name = "Chạy Nhanh (WalkSpeed)",
   PlaceholderText = "16",
   Callback = function(t) 
      local num = tonumber(t)
      if num then 
         _G.WalkSpeed = num
         if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = num
         end
      end
   end,
})

TabSpeed:CreateInput({
   Name = "Nhảy Cao (JumpPower)",
   PlaceholderText = "50",
   Callback = function(t) 
      local num = tonumber(t)
      if num then 
         _G.JumpPower = num
         if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.JumpPower = num
         end
      end
   end,
})

-- === TAB FLY & ESP ===
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)

Tab2:CreateToggle({
   Name = "Bật ESP",
   CurrentValue = false,
   Callback = function(v) _G.ESP_Enabled = v end,
})

Tab2:CreateToggle({
   Name = "Bật Fly (Điều Khiển Tay)",
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
   Name = "Nhập Tốc Độ Fly",
   PlaceholderText = "50",
   Callback = function(t) if tonumber(t) then _G.FlySpeed = tonumber(t) end end,
})

-- === GIỮ WALKSPEED/JUMPPOWER SAU KHI CHẾT ===
LP.CharacterAdded:Connect(function(newChar)
   task.wait(0.5)
   local hum = newChar:FindFirstChild("Humanoid")
   if hum then
      hum.WalkSpeed = _G.WalkSpeed
      hum.JumpPower = _G.JumpPower
   end
end)

-- === HỆ THỐNG XỬ LÝ CHÍNH ===
RunService.RenderStepped:Connect(function()
    -- Vòng POV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = _G.FOVSize
    
    -- Aimbot (POV Aim)
    if _G.Aimbot_Enabled then
        local target = nil
        local dist = _G.FOVSize
        for _, v in pairs(game.Players:GetPlayers()) do
            if v \~= LP and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if d < dist then 
                        target = v
                        dist = d 
                    end
                end
            end
        end
        if target and target.Character:FindFirstChild("Head") then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) 
        end
    end

    -- Hitbox + ESP (đã fix)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v \~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            
            if _G.ESP_Enabled then
                if not v.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", v.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.5
                end
            else
                local h = v.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    end

    -- Full Bright
    if _G.FullBright_Enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    end
end)

RunService.Stepped:Connect(function()
    -- Noclip (đã fix reset)
    if LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then 
                v.CanCollide = not _G.Noclip_Enabled 
            end
        end
    end
    
    -- Vô hạn đạn manual (backup)
    if _G.InfAmmo_Enabled and LP.Character then
        for _, tool in pairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in pairs(tool:GetDescendants()) do
                    if v:IsA("IntValue") and (v.Name == "Ammo" or v.Name == "Clip") then 
                        v.Value = 999 
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and LP.Character then 
        LP.Character.Humanoid:ChangeState("Jumping") 
    end
end)
