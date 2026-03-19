local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HẮC KỶ TỬ - PRO VIP",
   LoadingTitle = "Đang Tải Hệ Thống...",
   LoadingSubtitle = "by Nguyễn Vĩ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local LP = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.FlySpeed = 50

-- Fix lỗi kéo thả: Ép khung Menu luôn có thể di chuyển
spawn(function()
    while task.wait(1) do
        local gui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
        if gui then
            for _, v in pairs(gui:GetDescendants()) do
                if v:IsA("Frame") and v.Name == "Main" then
                    v.Active = true
                    v.Draggable = true
                end
            end
            break
        end
    end
end)

local Tab1 = Window:CreateTab("🎮 Main", 4483362458)
local SecAim = Tab1:CreateSection("Tùy Chỉnh Tầm Nhìn (POV)")

Tab1:CreateInput({
   Name = "Chỉnh POV (FOV)",
   PlaceholderText = "Nhập số (VD: 100)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then Camera.FieldOfView = num end
   end,
})

Tab1:CreateToggle({
   Name = "Bật/Tắt Aimbot",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      _G.Aimbot_Enabled = Value
   end,
})

local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
local SecPro = Tab2:CreateSection("Chức Năng VIP")

Tab2:CreateToggle({
   Name = "Bật Fly",
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
   PlaceholderText = "Nhập số tốc độ...",
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

-- Hệ thống xử lý vòng lặp (RenderStepped)
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
