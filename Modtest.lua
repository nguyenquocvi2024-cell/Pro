-- [[ HỆ THỐNG VĨ LỎ - PRO VIP ]]
-- [[ FULL: NOCLIP, FULLBRIGHT, POV, AIMBOT, FLY, ESP ANTI-INVISIBLE ]]

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
_G.ShowNames = true
_G.ESP_Color = Color3.fromRGB(255, 0, 0)

local FlyBV = nil
local FlyBG = nil
local ESPObjects = {}

-- Hàm tạo ESP với Box, Tên và Khoảng cách
local function CreateESP(player)
    if not player.Character then return end
    
    -- Xóa ESP cũ nếu có
    if ESPObjects[player] then
        if ESPObjects[player].Box then ESPObjects[player].Box:Destroy() end
        if ESPObjects[player].Name then ESPObjects[player].Name:Destroy() end
        if ESPObjects[player].Distance then ESPObjects[player].Distance:Destroy() end
        ESPObjects[player] = nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ViloESP"
    highlight.FillColor = _G.ESP_Color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    -- Tạo BillboardGui hiển thị tên và khoảng cách
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_NameTag"
    billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character
    
    -- Frame chứa text
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.3
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    -- Tên người chơi
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = frame
    
    -- Khoảng cách
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0.3
    distLabel.Parent = frame
    
    ESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        NameLabel = nameLabel,
        DistLabel = distLabel
    }
end

-- Hàm xóa ESP
local function RemoveESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
        ESPObjects[player] = nil
    end
end

-- Hàm cập nhật khoảng cách
local function UpdateDistance()
    if not _G.ESP_Enabled then return end
    
    local myPos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return end
    
    for player, objects in pairs(ESPObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (myPos.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local distanceText = string.format("%.1fm", distance)
            if objects.DistLabel then
                objects.DistLabel.Text = distanceText
            end
            
            -- Đổi màu tên theo khoảng cách
            if objects.NameLabel then
                if distance < 20 then
                    objects.NameLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Đỏ khi gần
                elseif distance < 50 then
                    objects.NameLabel.TextColor3 = Color3.fromRGB(255, 200, 100) -- Cam
                else
                    objects.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Trắng khi xa
                end
            end
        end
    end
end

-- [[ TAB 1: MAIN ]]
local Tab1 = Window:CreateTab("🎮 Main", nil)

Tab1:CreateSection("⚙️ Điều Khiển Nhân Vật")

-- Noclip
Tab1:CreateToggle({
   Name = "🧱 Bật/Tắt Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip_Enabled = Value
      Rayfield:Notify({
         Title = "Noclip",
         Content = Value and "Đã bật xuyên tường" or "Đã tắt xuyên tường",
         Duration = 2
      })
   end,
})

-- Fullbright
Tab1:CreateToggle({
   Name = "🔆 Bật/Tắt Nhìn Trong Bóng Tối",
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
         Lighting.FogEnd = 100000
         Lighting.GlobalShadows = true
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

-- Chỉnh POV
Tab1:CreateInput({
   Name = "👁️ Chỉnh POV (FOV)",
   PlaceholderText = "Nhập số (30-120)...",
   Callback = function(Text)
      local num = tonumber(Text)
      if num and num >= 30 and num <= 120 then
         Camera.FieldOfView = num
      end
   end,
})

-- Aimbot
Tab1:CreateToggle({
   Name = "🎯 Bật Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      _G.Aimbot_Enabled = Value
   end,
})

-- Tốc độ chạy
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

-- Sức nhảy
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

-- Nhảy vô hạn
Tab1:CreateToggle({
   Name = "♾️ Nhảy Vô Hạn",
   CurrentValue = false,
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

-- [[ TAB 2: FLY & ESP ]]
local Tab2 = Window:CreateTab("🦅 Fly & ESP", nil)

Tab2:CreateSection("✈️ Chức Năng Bay")

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
   Name = "⚡ Nhập Tốc Độ Fly",
   PlaceholderText = "Mặc định: 50",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then _G.FlySpeed = num end
   end,
})

-- ESP nâng cao
Tab2:CreateSection("👁️ ESP Siêu Cấp (Chống Tàng Hình)")

Tab2:CreateToggle({
   Name = "👁️ Bật ESP (Phát hiện cả tàng hình)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESP_Enabled = Value
      if not Value then
         for _, player in pairs(game.Players:GetPlayers()) do
            RemoveESP(player)
         end
      else
         -- Tạo ESP cho tất cả player hiện tại
         for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LP then
               CreateESP(player)
            end
         end
      end
   end,
})

-- Chọn màu ESP
Tab2:CreateColorPicker({
   Name = "🎨 Màu ESP",
   Color = Color3.fromRGB(255, 0, 0),
   Callback = function(Color)
      _G.ESP_Color = Color
      -- Cập nhật màu cho tất cả ESP đang có
      for player, objects in pairs(ESPObjects) do
         if objects.Highlight then
            objects.Highlight.FillColor = Color
         end
      end
   end,
})

-- [[ TAB 3: CHẾ MODE ]]
local Tab3 = Window:CreateTab("🌀 Chế Mode", nil)

Tab3:CreateSection("💬 Chat & ⚔️ Combat")

-- Chọn người chơi
local function GetPlayers()
    local players = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP then
            table.insert(players, v.Name)
        end
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

-- Fake Chat
local FakeMessage = "Tui là fan Vĩ lỏ nè!"
local SelectedPlayer = nil

Tab3:CreateInput({
   Name = "💬 Nội Dung Fake Chat",
   PlaceholderText = "Nhập tin nhắn muốn giả mạo...",
   Callback = function(Text)
      if Text and Text ~= "" then
         FakeMessage = Text
      end
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
            FontSize = Enum.FontSize.Size18
         })
      else
         Rayfield:Notify({Title = "Lỗi", Content = "Hãy chọn nạn nhân trước!", Duration = 2})
      end
   end,
})

-- TP
Tab3:CreateButton({
   Name = "✨ Bay Đến Nó (TP)",
   Callback = function()
      if not SelectedPlayer then
         Rayfield:Notify({Title = "Lỗi", Content = "Hãy chọn nạn nhân trước!", Duration = 2})
         return
      end
      
      local target = game.Players:FindFirstChild(SelectedPlayer)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and
         LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
         LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
      end
   end,
})

-- Fling
Tab3:CreateButton({
   Name = "🌀 Fling (Hất Văng)",
   Callback = function()
      if not SelectedPlayer then
         Rayfield:Notify({Title = "Lỗi", Content = "Hãy chọn nạn nhân trước!", Duration = 2})
         return
      end
      
      local target = game.Players:FindFirstChild(SelectedPlayer)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and
         LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
         
         local thrust = Instance.new("BodyAngularVelocity")
         thrust.Parent = LP.Character.HumanoidRootPart
         thrust.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
         thrust.P = 9e9
         thrust.AngularVelocity = Vector3.new(0, 99999, 0)
         
         local oldPos = LP.Character.HumanoidRootPart.CFrame
         local oldNoclip = _G.Noclip_Enabled
         _G.Noclip_Enabled = true
         
         for i = 1, 60 do
            task.wait(0.01)
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and
               target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
               LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
         end
         
         thrust:Destroy()
         if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = oldPos
         end
         _G.Noclip_Enabled = oldNoclip
      end
   end,
})

-- [[ CORE LOGIC ]]

-- Nhảy vô hạn
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Cập nhật speed, jump, noclip
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        LP.Character.Humanoid.JumpPower = _G.JumpPower
    end
    
    if _G.Noclip_Enabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ESP và Aimbot Render
RunService.RenderStepped:Connect(function()
    -- ESP - Phát hiện cả khi tàng hình
    if _G.ESP_Enabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LP then
                -- Kiểm tra nếu player có character (kể cả đang tàng hình)
                if player.Character then
                    if not ESPObjects[player] then
                        CreateESP(player)
                    end
                else
                    -- Xóa ESP nếu player không còn character
                    if ESPObjects[player] then
                        RemoveESP(player)
                    end
                end
            end
        end
        
        -- Cập nhật khoảng cách
        UpdateDistance()
    end
    
    -- Aimbot
    if _G.Aimbot_Enabled then
        local target = nil
        local closestDist = 400
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if distance < closestDist then
                        target = v
                        closestDist = distance
                    end
                end
            end
        end
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- Xử lý khi có player mới vào game
game.Players.PlayerAdded:Connect(function(player)
    if _G.ESP_Enabled then
        player.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            if _G.ESP_Enabled and player ~= LP then
                CreateESP(player)
            end
        end)
    end
end)

-- Xử lý khi player rời game
game.Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Xử lý khi character của player thay đổi
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= LP then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if _G.ESP_Enabled then
                CreateESP(player)
            end
        end)
    end
end

-- Xử lý khi character respawn
LP.CharacterAdded:Connect(function(character)
    task.wait(1)
    if _G.Fly_Enabled then
        _G.Fly_Enabled = false
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
        FlyBV = nil
        FlyBG = nil
    end
end)

-- Thông báo khởi động
Rayfield:Notify({
   Title = "✅ Hệ thống Vĩ lỏ!",
   Content = "ESP đã được nâng cấp chống tàng hình + hiển thị tên nhỏ!",
   Duration = 5
})

print("=== HỆ THỐNG VĨ LỎ PRO VIP - ESP ANTI-INVISIBLE ===")
print("ESP tính năng: Phát hiện tàng hình | Hiển thị tên nhỏ | Khoảng cách")
print("=================================================")
