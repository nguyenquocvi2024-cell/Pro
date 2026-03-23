-- [[ HỆ THỐNG VĨ LỎ - PHIÊN BẢN CÔNG KHAI SIÊU CẤP ]]
-- [[ FULL: POV, SPEED, JUMP, FLY, ESP, TP, FLING, FAKE CHAT ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Hệ thống Vĩ lỏ - PRO VIP",
   LoadingTitle = "Đang Khởi Chạy Hệ Thống...",
   LoadingSubtitle = "by Nguyễn Vĩ DZ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Biến hệ thống
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.InfJump = false
_G.Noclip = false
_G.ESP = false
_G.Fly = false
_G.FlySpeed = 50
local SelectedPlayer = nil
local FakeChatMessage = "Tui là fan Vĩ lỏ nè!"
local FlyBV = nil
local FlyBG = nil

-- [[ TAB 1: NHÂN VẬT ]] -- Dùng icon mặc định
local Tab1 = Window:CreateTab("🎮 Nhân Vật", nil)

Tab1:CreateSection("⚙️ Cấu Hình Chỉ Số")

-- FIX: Chỉnh POV Camera
Tab1:CreateSlider({
   Name = "👁️ Tầm Nhìn (POV Camera)",
   Min = 30,
   Max = 120,
   Default = 70,
   Color = Color3.fromRGB(44, 120, 224),
   Increment = 1,
   ValueName = "độ",
   Callback = function(Value)
      if Camera then
         Camera.FieldOfView = Value
      end
   end,
})

Tab1:CreateSlider({
   Name = "🏃 Tốc Độ Chạy (Speed)",
   Min = 16,
   Max = 1000,
   Default = 16,
   Color = Color3.fromRGB(44, 120, 224),
   Increment = 1,
   ValueName = "studs/s",
   Callback = function(Value)
      _G.WalkSpeed = Value
   end,
})

Tab1:CreateSlider({
   Name = "🦘 Sức Mạnh Nhảy (Jump)",
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

Tab1:CreateToggle({
   Name = "♾️ Nhảy Vô Hạn (Inf Jump)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

Tab1:CreateToggle({
   Name = "🧱 Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip = Value
   end,
})

-- [[ TAB 2: CHẾ MODE ]]
local TabChe = Window:CreateTab("🌀 Chế Mode", nil)

TabChe:CreateSection("💬 Fake Chat & ⚔️ Tấn Công")

local function GetPlayers()
    local p = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP then
            table.insert(p, v.Name)
        end
    end
    return p
end

local PlayerDrop = TabChe:CreateDropdown({
   Name = "🎯 Chọn Nạn Nhân",
   Options = GetPlayers(),
   CurrentOption = "",
   Callback = function(Option)
      SelectedPlayer = Option
      if Option and Option ~= "" then
         Rayfield:Notify({
            Title = "Đã chọn",
            Content = "Nạn nhân: " .. Option,
            Duration = 2
         })
      end
   end,
})

TabChe:CreateButton({
   Name = "🔄 Làm Mới Danh Sách",
   Callback = function()
      PlayerDrop:Refresh(GetPlayers())
      Rayfield:Notify({
         Title = "✅ Đã làm mới",
         Content = "Danh sách người chơi đã được cập nhật!",
         Duration = 2
      })
   end,
})

TabChe:CreateInput({
   Name = "💬 Nội Dung Fake Chat",
   PlaceholderText = "Nhập câu muốn nó nói...",
   Callback = function(Text)
      if Text and Text ~= "" then
         FakeChatMessage = Text
      end
   end,
})

TabChe:CreateButton({
   Name = "📢 Fake Chat (Bóc Phốt)",
   Callback = function()
      if SelectedPlayer and SelectedPlayer ~= "" then
         StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[" .. SelectedPlayer .. "]: " .. FakeChatMessage,
            Color = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size18
         })
         Rayfield:Notify({
            Title = "✅ Đã gửi",
            Content = "Đã fake tin nhắn từ " .. SelectedPlayer,
            Duration = 2
         })
      else
         Rayfield:Notify({
            Title = "⚠️ Lỗi",
            Content = "Hãy chọn nạn nhân trước!",
            Duration = 3
         })
      end
   end,
})

TabChe:CreateButton({
   Name = "🌀 Fling (Hất Văng Nó)",
   Callback = function()
      if not SelectedPlayer then
         Rayfield:Notify({
            Title = "⚠️ Lỗi",
            Content = "Hãy chọn nạn nhân trước!",
            Duration = 3
         })
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
         local oldNoclip = _G.Noclip
         _G.Noclip = true
         
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
         _G.Noclip = oldNoclip
         
         Rayfield:Notify({
            Title = "✅ Đã fling",
            Content = "Đã hất văng " .. SelectedPlayer,
            Duration = 2
         })
      else
         Rayfield:Notify({
            Title = "⚠️ Lỗi",
            Content = "Không tìm thấy nhân vật của " .. SelectedPlayer,
            Duration = 3
         })
      end
   end,
})

TabChe:CreateButton({
   Name = "✨ Bay Đến Nó (TP)",
   Callback = function()
      if not SelectedPlayer then
         Rayfield:Notify({
            Title = "⚠️ Lỗi",
            Content = "Hãy chọn nạn nhân trước!",
            Duration = 3
         })
         return
      end
      
      local target = game.Players:FindFirstChild(SelectedPlayer)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and 
         LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
         LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
         Rayfield:Notify({
            Title = "✅ Đã TP",
            Content = "Đã bay đến " .. SelectedPlayer,
            Duration = 2
         })
      else
         Rayfield:Notify({
            Title = "⚠️ Lỗi",
            Content = "Không tìm thấy nhân vật của " .. SelectedPlayer,
            Duration = 3
         })
      end
   end,
})

-- [[ TAB 3: FLY & ESP ]]
local Tab3 = Window:CreateTab("🦅 Fly & ESP", nil)

Tab3:CreateSection("✈️ Chế Độ Bay & 👁️ ESP")

Tab3:CreateToggle({
   Name = "✈️ Bật Chế Độ Bay",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly = Value
      
      if Value then
         if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
               Title = "⚠️ Lỗi",
               Content = "Không tìm thấy nhân vật!",
               Duration = 3
            })
            _G.Fly = false
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
            while _G.Fly and LP.Character and LP.Character:FindFirstChild("Humanoid") do
               task.wait()
               LP.Character.Humanoid.PlatformStand = true
               if FlyBV then
                  FlyBV.velocity = LP.Character.Humanoid.MoveDirection * _G.FlySpeed
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

Tab3:CreateInput({
   Name = "⚡ Tốc Độ Bay",
   PlaceholderText = "Nhập tốc độ (mặc định: 50)",
   Callback = function(t)
      local speed = tonumber(t)
      if speed then
         _G.FlySpeed = speed
      end
   end,
})

Tab3:CreateToggle({
   Name = "👁️ Bật ESP Player",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESP = Value
      if not Value then
         for _, pl in pairs(game.Players:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("ViloHighlight") then
               pl.Character.ViloHighlight:Destroy()
            end
         end
      else
         Rayfield:Notify({
            Title = "👁️ ESP đã bật",
            Content = "Đang hiển thị tất cả người chơi",
            Duration = 2
         })
      end
   end,
})

-- [[ CORE LOGIC ]]
-- Xử lý nhảy vô hạn
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Cập nhật speed và jump mỗi frame
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        LP.Character.Humanoid.JumpPower = _G.JumpPower
    end
    
    if _G.Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ESP Render
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, pl in pairs(game.Players:GetPlayers()) do
            if pl ~= LP and pl.Character and not pl.Character:FindFirstChild("ViloHighlight") then
                local h = Instance.new("Highlight")
                h.Name = "ViloHighlight"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.5
                h.Parent = pl.Character
            end
        end
    end
end)

-- Xử lý khi có player mới vào game
game.Players.PlayerAdded:Connect(function(player)
    if _G.ESP then
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            if _G.ESP and not character:FindFirstChild("ViloHighlight") then
                local h = Instance.new("Highlight")
                h.Name = "ViloHighlight"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.5
                h.Parent = character
            end
        end)
    end
end)

-- Xử lý khi character được load
LP.CharacterAdded:Connect(function(character)
    task.wait(1)
    if _G.Fly then
        _G.Fly = false
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
        FlyBV = nil
        FlyBG = nil
    end
end)

-- Thông báo khởi động
Rayfield:Notify({
   Title = "✅ Hệ thống Vĩ lỏ!",
   Content = "Đã tải xong full chức năng cho ní!",
   Duration = 5
})

-- In ra console để kiểm tra
print("=== HỆ THỐNG VĨ LỎ ĐÃ KHỞI ĐỘNG ===")
print("Các tab: Nhân Vật, Chế Mode, Fly & ESP")
print("=====================================")
