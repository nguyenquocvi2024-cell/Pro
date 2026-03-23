-- [[ VIP ULTRA MENU - BẢN FULL CHỨC NĂNG ]]
-- [[ MỞ MENU LÀ DÙNG NGAY - KHÔNG CẦN SETUP ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⭐ VIP ULTRA MENU ⭐",
   LoadingTitle = "ĐANG KHỞI TẠO...",
   LoadingSubtitle = "Nguyễn Vĩ PRO | 6 TAB SIÊU KHỦNG",
   ConfigurationSaving = { Enabled = true },
   KeySystem = false
})

-- ====== BIẾN TOÀN CỤC ======
local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- TẤT CẢ TÍNH NĂNG ĐỀU CÓ BẬT/TẮT
_G = {
    Speed = 16,
    JumpPower = 50,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    Aimbot = false,
    AimbotPart = "Head",
    AimbotFOV = 400,
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ShowNames = true,
    ShowDistance = true,
    FullBright = false,
    Spin = false,
    SpinSpeed = 50,
    SelectedPlayer = nil,
}

local FlyBV, FlyBG = nil, nil

-- ==================== TAB 1: GOD MODE ====================
local Tab1 = Window:CreateTab("👑 GOD MODE", nil)

Tab1:CreateSection("⚡ THÔNG SỐ NHÂN VẬT")

Tab1:CreateSlider({
    Name = "🏃 TỐC ĐỘ CHẠY",
    Min = 16, Max = 500, Default = 16,
    Color = Color3.fromRGB(255, 70, 70),
    Increment = 1, ValueName = "studs/s",
    Callback = function(v) _G.Speed = v end
})

Tab1:CreateSlider({
    Name = "🦘 SỨC MẠNH NHẢY",
    Min = 50, Max = 500, Default = 50,
    Color = Color3.fromRGB(255, 120, 70),
    Increment = 1, ValueName = "studs",
    Callback = function(v) _G.JumpPower = v end
})

Tab1:CreateToggle({
    Name = "♾️ NHẢY VÔ HẠN",
    CurrentValue = false,
    Callback = function(v) _G.InfJump = v end
})

Tab1:CreateToggle({
    Name = "🧱 XUYÊN TƯỜNG (NOCLIP)",
    CurrentValue = false,
    Callback = function(v) _G.Noclip = v end
})

Tab1:CreateToggle({
    Name = "🔆 SÁNG HOÀN HẢO (FULLBRIGHT)",
    CurrentValue = false,
    Callback = function(v)
        _G.FullBright = v
        if v then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            game.Lighting.GlobalShadows = true
        end
    end
})

-- ==================== TAB 2: AIMBOT ====================
local Tab2 = Window:CreateTab("🎯 AIMBOT PRO", nil)

Tab2:CreateSection("🎯 CÀI ĐẶT AIMBOT")

Tab2:CreateToggle({
    Name = "🎯 BẬT AIMBOT (NHẮM ĐẦU)",
    CurrentValue = false,
    Callback = function(v) _G.Aimbot = v end
})

Tab2:CreateDropdown({
    Name = "🎯 NHẮM VÀO BỘ PHẬN",
    Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso"},
    CurrentOption = "Head",
    Callback = function(v) _G.AimbotPart = v end
})

Tab2:CreateSlider({
    Name = "📏 PHẠM VI AIMBOT (FOV)",
    Min = 100, Max = 800, Default = 400,
    Color = Color3.fromRGB(255, 50, 50),
    Increment = 10, ValueName = "studs",
    Callback = function(v) _G.AimbotFOV = v end
})

local TargetLabel = Tab2:CreateLabel("🎯 TARGET: Chưa có")

-- ==================== TAB 3: ESP ====================
local Tab3 = Window:CreateTab("👁️ ESP PRO", nil)

Tab3:CreateSection("👁️ CÀI ĐẶT ESP")

Tab3:CreateToggle({
    Name = "👁️ BẬT ESP (CHỐNG TÀNG HÌNH)",
    CurrentValue = false,
    Callback = function(v) 
        _G.ESP = v
        if not v then
            for _, pl in pairs(game.Players:GetPlayers()) do
                if pl.Character then
                    if pl.Character:FindFirstChild("ESP_Box") then pl.Character.ESP_Box:Destroy() end
                    if pl.Character:FindFirstChild("ESP_Name") then pl.Character.ESP_Name:Destroy() end
                end
            end
        end
    end
})

Tab3:CreateColorPicker({
    Name = "🎨 MÀU ESP",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(c) _G.ESPColor = c end
})

Tab3:CreateToggle({
    Name = "🏷️ HIỂN THỊ TÊN",
    CurrentValue = true,
    Callback = function(v) _G.ShowNames = v end
})

Tab3:CreateToggle({
    Name = "📏 HIỂN THỊ KHOẢNG CÁCH",
    CurrentValue = true,
    Callback = function(v) _G.ShowDistance = v end
})

-- ==================== TAB 4: FLY ====================
local Tab4 = Window:CreateTab("✈️ FLY MODE", nil)

Tab4:CreateSection("✈️ CHẾ ĐỘ BAY")

Tab4:CreateToggle({
    Name = "✈️ BẬT FLY (WASD ĐIỀU KHIỂN)",
    CurrentValue = false,
    Callback = function(v)
        _G.Fly = v
        if v then
            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
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
                while _G.Fly and LP.Character do
                    task.wait()
                    if LP.Character:FindFirstChild("Humanoid") then
                        LP.Character.Humanoid.PlatformStand = true
                        if FlyBV then FlyBV.velocity = LP.Character.Humanoid.MoveDirection * _G.FlySpeed end
                        if FlyBG then FlyBG.cframe = Camera.CFrame end
                    end
                end
                if FlyBV then FlyBV:Destroy() end
                if FlyBG then FlyBG:Destroy() end
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid.PlatformStand = false
                end
            end)
        else
            if FlyBV then FlyBV:Destroy() end
            if FlyBG then FlyBG:Destroy() end
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.PlatformStand = false
            end
        end
    end
})

Tab4:CreateInput({
    Name = "⚡ TỐC ĐỘ BAY",
    PlaceholderText = "Mặc định: 50",
    Callback = function(t)
        local num = tonumber(t)
        if num then _G.FlySpeed = num end
    end
})

-- ==================== TAB 5: CHẾ MODE ====================
local Tab5 = Window:CreateTab("🌀 CHẾ MODE", nil)

Tab5:CreateSection("🎯 CHỌN NẠN NHÂN")

local function GetPlayers()
    local list = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP then table.insert(list, v.Name) end
    end
    return list
end

local PlayerDrop = Tab5:CreateDropdown({
    Name = "🎯 DANH SÁCH NGƯỜI CHƠI",
    Options = GetPlayers(),
    CurrentOption = "",
    Callback = function(v) _G.SelectedPlayer = v end
})

Tab5:CreateButton({
    Name = "🔄 LÀM MỚI DANH SÁCH",
    Callback = function() PlayerDrop:Refresh(GetPlayers()) end
})

Tab5:CreateSection("⚔️ HÀNH ĐỘNG")

Tab5:CreateButton({
    Name = "✨ BAY ĐẾN NẠN NHÂN (TP)",
    Callback = function()
        if not _G.SelectedPlayer then return end
        local target = game.Players:FindFirstChild(_G.SelectedPlayer)
        if target and target.Character then
            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
})

Tab5:CreateButton({
    Name = "🌀 FLING (HẤT VĂNG)",
    Callback = function()
        if not _G.SelectedPlayer then return end
        local target = game.Players:FindFirstChild(_G.SelectedPlayer)
        if target and target.Character then
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
    end
})

Tab5:CreateSection("💬 FAKE CHAT")

local FakeMsg = "Vĩ lỏ đẹp trai!"
Tab5:CreateInput({
    Name = "💬 NỘI DUNG FAKE",
    PlaceholderText = "Nhập tin nhắn...",
    Callback = function(t) if t ~= "" then FakeMsg = t end end
})

Tab5:CreateButton({
    Name = "📢 GỬI FAKE CHAT",
    Callback = function()
        if _G.SelectedPlayer then
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[" .. _G.SelectedPlayer .. "]: " .. FakeMsg,
                Color = Color3.fromRGB(255, 255, 255)
            })
        end
    end
})

-- ==================== TAB 6: TIỆN ÍCH ====================
local Tab6 = Window:CreateTab("🔧 TIỆN ÍCH", nil)

Tab6:CreateSection("🌀 HIỆU ỨNG")

Tab6:CreateToggle({
    Name = "🌀 XOAY VÒNG (SPIN)",
    CurrentValue = false,
    Callback = function(v)
        _G.Spin = v
        if v then
            spawn(function()
                while _G.Spin and LP.Character do
                    task.wait()
                    LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0)
                end
            end)
        end
    end
})

Tab6:CreateSlider({
    Name = "🌀 TỐC ĐỘ XOAY",
    Min = 10, Max = 200, Default = 50,
    Color = Color3.fromRGB(255, 100, 100),
    Increment = 5, ValueName = "độ/s",
    Callback = function(v) _G.SpinSpeed = v end
})

Tab6:CreateSection("📊 TIỆN ÍCH KHÁC")

Tab6:CreateButton({
    Name = "📊 XEM THÔNG TIN SERVER",
    Callback = function()
        Rayfield:Notify({
            Title = "📊 THÔNG TIN",
            Content = "👥 Người chơi: " .. #game.Players:GetPlayers() .. "\n📡 Ping: " .. game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() .. "ms",
            Duration = 5
        })
    end
})

Tab6:CreateButton({
    Name = "🔄 REJOIN (VÀO LẠI)",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

-- ==================== CORE LOGIC ====================

-- Cập nhật Speed/Jump/Noclip
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.Speed
        LP.Character.Humanoid.JumpPower = _G.JumpPower
    end
    if _G.Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Nhảy vô hạn
UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Aimbot + ESP
RunService.RenderStepped:Connect(function()
    -- AIMBOT
    if _G.Aimbot then
        local closest, closestDist = nil, _G.AimbotFOV
        local center = Camera.ViewportSize / 2
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild(_G.AimbotPart) then
                local pos, onScreen = Camera:WorldToScreenPoint(v.Character[_G.AimbotPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = v
                    end
                end
            end
        end
        if closest then
            TargetLabel:Set("🎯 TARGET: " .. closest.Name)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character[_G.AimbotPart].Position)
        else
            TargetLabel:Set("🎯 TARGET: Không có")
        end
    end
    
    -- ESP
    if _G.ESP then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character then
                if not v.Character:FindFirstChild("ESP_Box") then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP_Box"
                    h.FillColor = _G.ESPColor
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.5
                    h.Parent = v.Character
                end
                if _G.ShowNames and not v.Character:FindFirstChild("ESP_Name") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ESP_Name"
                    bill.Adornee = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
                    bill.Size = UDim2.new(0, 120, 0, 35)
                    bill.StudsOffset = Vector3.new(0, 2.5, 0)
                    bill.AlwaysOnTop = true
                    bill.Parent = v.Character
                    local frame = Instance.new("Frame", bill)
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundTransparency = 0.3
                    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    local name = Instance.new("TextLabel", frame)
                    name.Size = UDim2.new(1, 0, 0.6, 0)
                    name.BackgroundTransparency = 1
                    name.Text = v.Name
                    name.TextColor3 = Color3.fromRGB(255, 255, 255)
                    name.TextScaled = true
                    if _G.ShowDistance then
                        local dist = Instance.new("TextLabel", frame)
                        dist.Size = UDim2.new(1, 0, 0.4, 0)
                        dist.Position = UDim2.new(0, 0, 0.6, 0)
                        dist.BackgroundTransparency = 1
                        dist.TextColor3 = Color3.fromRGB(255, 200, 0)
                        dist.TextScaled = true
                        spawn(function()
                            while v.Character and LP.Character do
                                task.wait(0.1)
                                local d = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                                dist.Text = string.format("%.1fm", d)
                                if not _G.ESP then break end
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- Cập nhật dropdown khi có player mới
game.Players.PlayerAdded:Connect(function() PlayerDrop:Refresh(GetPlayers()) end)
game.Players.PlayerRemoving:Connect(function() PlayerDrop:Refresh(GetPlayers()) end)

-- Thông báo
Rayfield:Notify({
    Title = "⭐ VIP ULTRA MENU",
    Content = "6 TAB ĐẦY ĐỦ | BẬT/TẮT TỪNG TÍNH NĂNG",
    Duration = 5
})

print("========== MENU ĐÃ SẴN SÀNG ==========")
print("6 TAB: GOD MODE | AIMBOT | ESP | FLY | CHẾ MODE | TIỆN ÍCH")
print("TẤT CẢ TÍNH NĂNG ĐỀU CÓ BẬT/TẮT")
print("======================================")
