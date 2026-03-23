--[[
    ╔════════════════════════════════════════════════════════════╗
    ║        HỆ THỐNG VĨ LỎ - PHIÊN BẢN CÔNG KHAI (PUBLIC)       ║
    ║   Author: Nguyễn Vĩ DZ                                     ║
    ║   Tính năng: Full Menu, Speed, Fly, ESP, TP, Fling, Chat   ║
    ╚════════════════════════════════════════════════════════════╝
]]

-- Khởi tạo thư viện Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "Hệ thống Vĩ lỏ - PRO VIP",
   LoadingTitle = "Đang Khởi Chạy Hệ Thống Vĩ Lỏ...",
   LoadingSubtitle = "by Nguyễn Vĩ DZ",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ViloSystem", 
      FileName = "ViloConfig"
   },
   KeySystem = false -- Tắt key cho anh em dễ xài
})

-- Các dịch vụ hệ thống (Services)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

-- [[ BIẾN TOÀN CỤC ]]
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.InfJump = false
_G.Noclip = false
_G.ESP = false
_G.Fly = false
_G.FlySpeed = 50
_G.FullBright = false
_G.Aimbot = false
local SelectedPlayer = nil
local FakeChatMessage = "Tui là fan cứng Vĩ lỏ!"

-- [[ TAB 1: NHÂN VẬT CHÍNH ]]
local Tab1 = Window:CreateTab("🎮 Nhân Vật", 4483362458)
local SecMain = Tab1:CreateSection("Cấu Hình Chỉ Số")

Tab1:CreateSlider({
   Name = "Tầm Nhìn (POV Camera)",
   Min = 30, Max = 120, Default = 70, Color = Color3.fromRGB(44, 120, 224),
   Increment = 1, ValueName = "Độ",
   Callback = function(Value) Camera.FieldOfView = Value end,
})

Tab1:CreateSlider({
   Name = "Tốc Độ Chạy (Speed)",
   Min = 16, Max = 1000, Default = 16, Color = Color3.fromRGB(44, 120, 224),
   Increment = 1, ValueName = "studs",
   Callback = function(Value) _G.WalkSpeed = Value end,
})

Tab1:CreateSlider({
   Name = "Sức Mạnh Nhảy (Jump)",
   Min = 50, Max = 500, Default = 50, Color = Color3.fromRGB(44, 120, 224),
   Increment = 1, ValueName = "studs",
   Callback = function(Value) _G.JumpPower = Value end,
})

Tab1:CreateToggle({
   Name = "Nhảy Vô Hạn (Inf Jump)",
   CurrentValue = false,
   Callback = function(Value) _G.InfJump = Value end,
})

Tab1:CreateToggle({
   Name = "Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Callback = function(Value) _G.Noclip = Value end,
})

Tab1:CreateToggle({
   Name = "Sáng Màn Hình (FullBright)",
   CurrentValue = false,
   Callback = function(Value)
      _G.FullBright = Value
      if Value then
         Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
         Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      else
         Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.GlobalShadows = true
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
      end
   end,
})

-- [[ TAB 2: PHÁ HOẠI SERVER (CHẾ) ]]
local TabChe = Window:CreateTab("🌀 Chế Mode", 4483362458)
TabChe:CreateSection("Hệ Thống Phá Đứa Khác")

-- Hàm lấy danh sách người chơi
local function RefreshPlayers()
    local names = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP then table.insert(names, v.Name) end
    end
    return names
end

local PlayerDropdown = TabChe:CreateDropdown({
   Name = "Chọn Con Mồi",
   Options = RefreshPlayers(),
   CurrentOption = "",
   Callback = function(Option) SelectedPlayer = Option end,
})

TabChe:CreateButton({
   Name = "Làm Mới Danh Sách Người Chơi",
   Callback = function() PlayerDropdown:Refresh(RefreshPlayers()) end,
})

TabChe:CreateSection("Tính Năng Đổ Thừa (Fake Chat)")

TabChe:CreateInput({
   Name = "Nội Dung Muốn Nó Nói",
   PlaceholderText = "Nhập vào đây...",
   Callback = function(Text) FakeChatMessage = Text end,
})

TabChe:CreateButton({
   Name = "Fake Chat (Chụp Ảnh Bóc Phốt)",
   Callback = function()
      if SelectedPlayer then
         StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[" .. SelectedPlayer .. "]: " .. FakeChatMessage,
            Color = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size18
         })
         Rayfield:Notify({Title = "Thành Công", Content = "Đã fake chat thằng " .. SelectedPlayer, Duration = 3})
      end
   end,
})

TabChe:CreateSection("Tính Năng Tấn Công")

TabChe:CreateButton({
   Name = "Bay Đến Nó (TP)",
   Callback = function()
      if SelectedPlayer then
         local target = Players:FindFirstChild(SelectedPlayer)
         if target and target.Character then
            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
         end
      end
   end,
})

TabChe:CreateButton({
   Name = "Fling (Hất Văng Nó Mất Xác)",
   Callback = function()
      if SelectedPlayer then
         local target = Players:FindFirstChild(SelectedPlayer)
         if target and target.Character then
            local thrust = Instance.new("BodyAngularVelocity", LP.Character.HumanoidRootPart)
            thrust.MaxTorque = Vector3.new(0, math.huge, 0); thrust.P = math.huge; thrust.AngularVelocity = Vector3.new(0, 99999, 0)
            local oldPos = LP.Character.HumanoidRootPart.CFrame
            _G.Noclip = true
            for i = 1, 60 do 
                task.wait(0.01) 
                LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame 
            end
            thrust:Destroy(); LP.Character.HumanoidRootPart.CFrame = oldPos; _G.Noclip = false
         end
      end
   end,
})

-- [[ TAB 3: FLY & VISUALS ]]
local Tab3 = Window:CreateTab("🦅 Bay & Nhìn", 4483362458)

Tab3:CreateToggle({
   Name = "Bật Chế Độ Bay (Fly)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly = Value
      if Value then
         local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
         local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
         bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         spawn(function()
            while _G.Fly do
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

Tab3:CreateInput({
   Name = "Tốc Độ Bay (Fly Speed)",
   PlaceholderText = "Mặc định 50",
   Callback = function(Text) _G.FlySpeed = tonumber(Text) or 50 end,
})

Tab3:CreateToggle({
   Name = "Bật ESP Player (Hiện Khung Đỏ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESP = Value
      if not Value then
         for _, pl in pairs(Players:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("ViloHighlight") then 
                pl.Character.ViloHighlight:Destroy() 
            end
         end
      end
   end,
})

-- [[ HỆ THỐNG VÒNG LẶP XỬ LÝ (CORE) ]]
UIS.JumpRequest:Connect(function()
    if _G.InfJump then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        LP.Character.Humanoid.JumpPower = _G.JumpPower
    end
    if _G.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character and not pl.Character:FindFirstChild("ViloHighlight") then
                local h = Instance.new("Highlight", pl.Character)
                h.Name = "ViloHighlight"; h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

-- Thông báo khi menu đã sẵn sàng
Rayfield:Notify({
   Title = "Hệ thống Vĩ lỏ Online!",
   Content = "Chào mừng ní Nguyễn Vĩ đã quay trở lại!",
   Duration = 5,
   Image = 4483362458,
})
