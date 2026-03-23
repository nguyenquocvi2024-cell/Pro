-- [[ HỆ THỐNG VĨ LỎ - PRO VIP ]]
-- [[ FULL: MAIN, FLY & ESP, CHẾ MODE, SETTINGS, NÂNG CẤP ]]

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
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Biến hệ thống
_G.ESP_Enabled = false
_G.Fly_Enabled = false
_G.Aimbot_Enabled = false
_G.Noclip_Enabled = false
_G.FullBright_Enabled = false
_G.FlySpeed = 50
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.InfJump = false
_G.Spin_Enabled = false
_G.SpinSpeed = 50
_G.NoFallDamage = false
_G.AutoFarm_Enabled = false

local FlyBV = nil
local FlyBG = nil
local SelectedPlayer = nil
local FakeMessage = "Tui là fan Vĩ lỏ nè!"
local ESPObjects = {}

-- ===========================
-- TAB 1: MAIN (ĐÃ NÂNG CẤP)
-- ===========================
local Tab1 = Window:CreateTab("🎮 Main", nil)

Tab1:CreateSection("⚙️ Điều Khiển Nhân Vật")

-- Noclip
Tab1:CreateToggle({
   Name = "🧱 Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip_Enabled = Value
      Rayfield:Notify({Title = "Noclip", Content = Value and "Đã bật" or "Đã tắt", Duration = 2})
   end,
})

-- Fullbright
Tab1:CreateToggle({
   Name = "🔆 Nhìn Trong Bóng Tối (Fullbright)",
   CurrentValue = false,
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

-- Chỉnh POV/FOV
Tab1:CreateInput({
   Name = "👁️ Chỉnh POV (FOV)",
   PlaceholderText = "Nhập số (30-120)...",
   Callback = function(Text)
      local num = tonumber(Text)
      if num and num >= 30 and num <= 120 then
         Camera.FieldOfView = num
         Rayfield:Notify({Title = "FOV", Content = "Đã chỉnh thành " .. num .. " độ", Duration = 2})
      end
   end,
})

-- Aimbot
Tab1:CreateToggle({
   Name = "🎯 Bật Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      _G.Aimbot_Enabled = Value
      Rayfield:Notify({Title = "Aimbot", Content = Value and "Đã bật" or "Đã tắt", Duration = 2})
   end,
})

Tab1:CreateSection("🏃 Tốc Độ & Nhảy")

-- Speed Slider (ĐÃ FIX LỖI 750)
Tab1:CreateSlider({
   Name = "🏃 Tốc Độ Chạy",
   Min = 16,
   Max = 500,
   Default = 16,
   Color = Color3.fromRGB(44, 120, 224),
   Increment = 1,
   ValueName = "studs/s",
   Callback = function(Value)
      _G.WalkSpeed = Value
   end,
})

-- Jump Power Slider
Tab1:CreateSlider({
   Name = "🦘 Sức Mạnh Nhảy",
   Min = 50,
   Max = 500,
   Default = 50,
   Color = Color3.fromRGB(44, 120, 224),
   Increment = 1,
   ValueName = "studs",
   Callback = function(Value)
      _G.JumpPower = Value
   end,
})

-- Inf Jump
Tab1:CreateToggle({
   Name = "♾️ Nhảy Vô Hạn (Inf Jump)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

-- No Fall Damage
Tab1:CreateToggle({
   Name = "💫 Không Sát Thương Rơi",
   CurrentValue = false,
   Callback = function(Value)
      _G.NoFallDamage = Value
   end,
})

-- ===========================
-- TAB 2: FLY & ESP (NÂNG CẤP)
-- ===========================
local Tab2 = Window:CreateTab("🦅 Fly & ESP", nil)

Tab2:CreateSection("✈️ Chế Độ Bay")

-- Fly
Tab2:CreateToggle({
   Name = "✈️ Bật Fly (Điều Khiển Tay)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly_Enabled = Value
      if Value then
         if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy nhân vật!", Duration = 2})
            _G.Fly_Enabled = false
            return
         end
         
         FlyBG = Instance.new("BodyGyro")
         FlyBV = Instance.new("BodyVelocity")
         FlyBG.Parent = LP.Character.HumanoidRootPart
         FlyBV.Parent = LP.Character.HumanoidRootPart
         FlyBG.P = 9e4
         FlyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
         FlyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
         
         spawn(function()
            while _G.Fly_Enabled and LP.Character and LP.Character:FindFirstChild("Humanoid") do
               task.wait()
               LP.Character.Humanoid.PlatformStand = true
               if FlyBV then
                  local moveDir = LP.Character.Humanoid.MoveDirection
                  FlyBV.velocity = moveDir * _G.FlySpeed
               end
               if FlyBG and Camera then
                  FlyBG.cframe = Camera.CFrame
               end
            end
            if FlyBV then FlyBV:Destroy() end
            if FlyBG then FlyBG:Destroy() end
            FlyBV = nil
            FlyBG = nil
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
               LP.Character.Humanoid.PlatformStand = false
            end
         end)
      else
         if FlyBV then FlyBV:Destroy() end
         if FlyBG then FlyBG:Destroy() end
         FlyBV = nil
         FlyBG = nil
         if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.PlatformStand = false
         end
      end
   end,
})

-- Tốc độ bay
Tab2:CreateInput({
   Name = "⚡ Tốc Độ Bay",
   PlaceholderText = "Mặc định: 50",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.FlySpeed = num end
   end,
})

Tab2:CreateSection("👁️ ESP Siêu Cấp (Chống Tàng Hình)")

-- Hàm tạo ESP nâng cao
local function CreateAdvancedESP(player)
   if not player.Character then return end
   if ESPObjects[player] then
      if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
      if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
      ESPObjects[player] = nil
   end
   
   local highlight = Instance.new("Highlight")
   highlight.Name = "ViloESP"
   highlight.FillColor = Color3.fromRGB(255, 0, 0)
   highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
   highlight.FillTransparency = 0.5
   highlight.Parent = player.Character
   
   local billboard = Instance.new("BillboardGui")
   billboard.Name = "NameTag"
   billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
   billboard.Size = UDim2.new(0, 120, 0, 35)
   billboard.StudsOffset = Vector3.new(0, 2.5, 0)
   billboard.AlwaysOnTop = true
   billboard.Parent = player.Character
   
   local frame = Instance.new("Frame")
   frame.Size = UDim2.new(1, 0, 1, 0)
   frame.BackgroundTransparency = 0.3
   frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   frame.BorderSizePixel = 0
   frame.Parent = billboard
   
   local nameLabel = Instance.new("TextLabel")
   nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
   nameLabel.BackgroundTransparency = 1
   nameLabel.Text = player.Name
   nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
   nameLabel.TextScaled = true
   nameLabel.Font = Enum.Font.GothamBold
   nameLabel.Parent = frame
   
   local distLabel = Instance.new("TextLabel")
   distLabel.Size = UDim2.new(1, 0, 0.4, 0)
   distLabel.Position = UDim2.new(0, 0, 0.6, 0)
   distLabel.BackgroundTransparency = 1
   distLabel.Text = "0m"
   distLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
   distLabel.TextScaled = true
   distLabel.Font = Enum.Font.Gotham
   distLabel.Parent = frame
   
   ESPObjects[player] = {
      Highlight = highlight,
      Billboard = billboard,
      DistLabel = distLabel
   }
end

-- ESP Toggle
Tab2:CreateToggle({
   Name = "👁️ Bật ESP (Phát hiện tàng hình)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESP_Enabled = Value
      if not Value then
         for _, player in pairs(ESPObjects) do
            if player.Highlight then player.Highlight:Destroy() end
            if player.Billboard then player.Billboard:Destroy() end
         end
         ESPObjects = {}
      else
         for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LP then
               CreateAdvancedESP(player)
            end
         end
      end
   end,
})

-- ===========================
-- TAB 3: CHẾ MODE (MỚI)
-- ===========================
local Tab3 = Window:CreateTab("🌀 Chế Mode", nil)

Tab3:CreateSection("💬 Fake Chat")

local function GetPlayers()
   local players = {}
   for _, v in pairs(game.Players:GetPlayers()) do
      if v ~= LP then table.insert(players, v.Name) end
   end
   return players
end

local PlayerDropdown = Tab3:CreateDropdown({
   Name = "🎯 Chọn Nạn Nhân",
   Options = GetPlayers(),
   CurrentOption = "",
   Callback = function(Option)
      SelectedPlayer = Option
   end,
})

Tab3:CreateButton({
   Name = "🔄 Làm Mới Danh Sách",
   Callback = function()
      PlayerDropdown:Refresh(GetPlayers())
   end,
})

Tab3:CreateInput({
   Name = "💬 Nội Dung Fake Chat",
   PlaceholderText = "Nhập tin nhắn...",
   Callback = function(Text)
      if Text and Text ~= "" then FakeMessage = Text end
   end,
})

Tab3:CreateButton({
   Name = "📢 Gửi Fake Chat",
   Callback = function()
      if SelectedPlayer and SelectedPlayer ~= "" then
         StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[" .. SelectedPlayer .. "]: " .. FakeMessage,
            Color = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
         })
      end
   end,
})

Tab3:CreateSection("⚔️ Combat")

-- TP
Tab3:CreateButton({
   Name = "✨ Bay Đến Nó (TP)",
   Callback = function()
      if not SelectedPlayer then
         Rayfield:Notify({Title = "Lỗi", Content = "Chọn nạn nhân trước!", Duration = 2})
         return
      end
      local target = game.Players:FindFirstChild(SelectedPlayer)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
      end
   end,
})

-- Fling
Tab3:CreateButton({
   Name = "🌀 Fling (Hất Văng)",
   Callback = function()
      if not SelectedPlayer then
         Rayfield:Notify({Title = "Lỗi", Content = "Chọn nạn nhân trước!", Duration = 2})
         return
      end
      local target = game.Players:FindFirstChild(SelectedPlayer)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         local thrust = Instance.new("BodyAngularVelocity")
         thrust.Parent = LP.Character.HumanoidRootPart
         thrust.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
         thrust.P = 9e9
         thrust.AngularVelocity = Vector3.new(0, 99999, 0)
         local oldPos = LP.Character.HumanoidRootPart.CFrame
         for i = 1, 60 do
            task.wait(0.01)
            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
         end
         thrust:Destroy()
         LP.Character.HumanoidRootPart.CFrame = oldPos
      end
   end,
})

-- ===========================
-- TAB 4: NÂNG CẤP (MỚI)
-- ===========================
local Tab4 = Window:CreateTab("⚡ Nâng Cấp", nil)

Tab4:CreateSection("🌀 Hiệu Ứng Đặc Biệt")

-- Spin
Tab4:CreateToggle({
   Name = "🌀 Xoay Vòng (Spin)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Spin_Enabled = Value
      if Value then
         spawn(function()
            while _G.Spin_Enabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") do
               task.wait()
               LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0)
            end
         end)
      end
   end,
})

Tab4:CreateSlider({
   Name = "🌀 Tốc Độ Xoay",
   Min = 10,
   Max = 200,
   Default = 50,
   Color = Color3.fromRGB(44, 120, 224),
   Increment = 1,
   ValueName = "độ/s",
   Callback = function(Value)
      _G.SpinSpeed = Value
   end,
})

Tab4:CreateSection("📊 Thông Tin")

-- Hiển thị thông tin
Tab4:CreateButton({
   Name = "📊 Hiển Thị Thông Tin",
   Callback = function()
      local playerCount = #game.Players:GetPlayers()
      local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
      Rayfield:Notify({
         Title = "Thông Tin",
         Content = "Người chơi: " .. playerCount .. "\nPing: " .. ping .. "ms",
         Duration = 5
      })
   end,
})

-- ===========================
-- CORE LOGIC
-- ===========================

-- Nhảy vô hạn
UIS.JumpRequest:Connect(function()
   if _G.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
      LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

-- Cập nhật Speed, Jump, Noclip
RunService.Stepped:Connect(function()
   if LP.Character and LP.Character:FindFirstChild("Humanoid") then
      LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
      LP.Character.Humanoid.JumpPower = _G.JumpPower
      if _G.NoFallDamage then
         LP.Character.Humanoid.UseJumpPower = true
      end
   end
   
   if _G.Noclip_Enabled and LP.Character then
      for _, v in pairs(LP.Character:GetDescendants()) do
         if v:IsA("BasePart") then v.CanCollide = false end
      end
   end
end)

-- ESP và Aimbot Render
RunService.RenderStepped:Connect(function()
   -- ESP
   if _G.ESP_Enabled then
      for _, player in pairs(game.Players:GetPlayers()) do
         if player ~= LP and player.Character then
            if not ESPObjects[player] then
               CreateAdvancedESP(player)
            elseif ESPObjects[player].DistLabel and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
               local dist = (LP.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
               ESPObjects[player].DistLabel.Text = string.format("%.1fm", dist)
            end
         elseif ESPObjects[player] then
            if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
            if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
            ESPObjects[player] = nil
         end
      end
   end
   
   -- Aimbot
   if _G.Aimbot_Enabled then
      local target = nil
      local closestDist = 400
      for _, v in pairs(game.Players:GetPlayers()) do
         if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
            if onScreen then
               local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
               if d < closestDist then target = v; closestDist = d end
            end
         end
      end
      if target and target.Character and target.Character:FindFirstChild("Head") then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
      end
   end
end)

-- Xử lý khi có player mới
game.Players.PlayerAdded:Connect(function(player)
   if _G.ESP_Enabled then
      player.CharacterAdded:Connect(function()
         task.wait(0.5)
         if _G.ESP_Enabled then CreateAdvancedESP(player) end
      end)
   end
end)

-- Xử lý khi character respawn
LP.CharacterAdded:Connect(function()
   task.wait(1)
   if _G.Fly_Enabled then
      _G.Fly_Enabled = false
      if FlyBV then FlyBV:Destroy() end
      if FlyBG then FlyBG:Destroy() end
   end
end)
