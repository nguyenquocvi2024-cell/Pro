-- [[ ⭐ VIP ULTRA MENU - BẢN FIX FULL 6 TAB ⭐ ]]
-- [[ FIX LỖI KHÔNG HIỆN TAB - TỐI ƯU CHO MOBILE ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⭐ VIP ULTRA MENU ⭐",
   LoadingTitle = "ĐANG KHỞI TẠO HỆ THỐNG...",
   LoadingSubtitle = "Nguyễn Vĩ PRO | FIX FULL 6 TAB",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ====== BIẾN HỆ THỐNG (FIXED) ======
local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

_G.Speed = 16
_G.JumpPower = 50
_G.InfJump = false
_G.Noclip = false
_G.Fly = false
_G.FlySpeed = 50
_G.Aimbot = false
_G.AimbotPart = "Head"
_G.AimbotFOV = 400
_G.ESP = false
_G.ShowNames = true
_G.SelectedPlayer = nil

-- ==================== TAB 1: GOD MODE ====================
local Tab1 = Window:CreateTab("👑 GOD MODE", 4483362458)
Tab1:CreateSection("⚡ THÔNG SỐ NHÂN VẬT")

Tab1:CreateSlider({
    Name = "🏃 TỐC ĐỘ CHẠY",
    Min = 16, Max = 500, Default = 16,
    Color = Color3.fromRGB(44, 120, 224), -- Màu xanh chuẩn ảnh ní chụp
    Increment = 1, ValueName = "studs",
    Callback = function(v) _G.Speed = v end
})

Tab1:CreateSlider({
    Name = "🦘 SỨC MẠNH NHẢY",
    Min = 50, Max = 500, Default = 50,
    Color = Color3.fromRGB(44, 120, 224),
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

-- ==================== TAB 2: AIMBOT ====================
local Tab2 = Window:CreateTab("🎯 AIMBOT PRO", 4483362458)
Tab2:CreateSection("🎯 CÀI ĐẶT NHẮM")

Tab2:CreateToggle({
    Name = "🎯 BẬT AIMBOT",
    CurrentValue = false,
    Callback = function(v) _G.Aimbot = v end
})

Tab2:CreateDropdown({
    Name = "🎯 VÙNG NHẮM",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = "Head",
    Callback = function(v) _G.AimbotPart = v end
})

-- ==================== TAB 3: ESP ====================
local Tab3 = Window:CreateTab("👁️ ESP PRO", 4483362458)
Tab3:CreateSection("👁️ NHÌN XUYÊN TƯỜNG")

Tab3:CreateToggle({
    Name = "👁️ BẬT ESP HIGHLIGHT",
    CurrentValue = false,
    Callback = function(v) 
        _G.ESP = v 
        if not v then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("ViloESP") then p.Character.ViloESP:Destroy() end
            end
        end
    end
})

-- ==================== TAB 4: FLY ====================
local Tab4 = Window:CreateTab("✈️ FLY MODE", 4483362458)
Tab4:CreateSection("✈️ CHẾ ĐỘ BAY")

Tab4:CreateToggle({
    Name = "✈️ BẬT FLY",
    CurrentValue = false,
    Callback = function(v)
        _G.Fly = v
        if v then
            local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
            local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 9e4
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            spawn(function()
                while _G.Fly do
                    task.wait()
                    LP.Character.Humanoid.PlatformStand = true
                    bv.velocity = LP.Character.Humanoid.MoveDirection * _G.FlySpeed
                    bg.cframe = Camera.CFrame
                end
                bv:Destroy(); bg:Destroy()
                LP.Character.Humanoid.PlatformStand = false
            end)
        end
    end
})

Tab4:CreateSlider({
    Name = "⚡ TỐC ĐỘ BAY",
    Min = 10, Max = 300, Default = 50,
    Color = Color3.fromRGB(44, 120, 224),
    Increment = 5, ValueName = "studs",
    Callback = function(v) _G.FlySpeed = v end
})

-- ==================== TAB 5: CHẾ MODE ====================
local Tab5 = Window:CreateTab("🌀 CHẾ MODE", 4483362458)
Tab5:CreateSection("🎯 FAKE CHAT & PHÁ")

local function GetPlayers()
    local t = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP then table.insert(t, v.Name) end
    end
    return t
end

local Drop = Tab5:CreateDropdown({
    Name = "🎯 CHỌN NẠN NHÂN",
    Options = GetPlayers(),
    CurrentOption = "",
    Callback = function(v) _G.SelectedPlayer = v end
})

Tab5:CreateButton({
    Name = "🔄 LÀM MỚI DANH SÁCH",
    Callback = function() Drop:Refresh(GetPlayers()) end
})

local FMsg = "Tui bị lỏ nè!"
Tab5:CreateInput({
    Name = "💬 NỘI DUNG FAKE",
    PlaceholderText = "Nhập câu muốn nó nói...",
    Callback = function(t) FMsg = t end
})

Tab5:CreateButton({
    Name = "📢 GỬI FAKE CHAT (BÓC PHỐT)",
    Callback = function()
        if _G.SelectedPlayer then
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[" .. _G.SelectedPlayer .. "]: " .. FMsg,
                Color = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSansBold
            })
        end
    end
})

Tab5:CreateButton({
    Name = "🌀 FLING (HẤT VĂNG)",
    Callback = function()
        if _G.SelectedPlayer then
            local target = game.Players:FindFirstChild(_G.SelectedPlayer)
            if target and target.Character then
                local thrust = Instance.new("BodyAngularVelocity", LP.Character.HumanoidRootPart)
                thrust.MaxTorque = Vector3.new(0, 9e9, 0); thrust.P = 9e9; thrust.AngularVelocity = Vector3.new(0, 99999, 0)
                local old = LP.Character.HumanoidRootPart.CFrame
                _G.Noclip = true
                for i = 1, 50 do task.wait(0.01) LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
                thrust:Destroy(); LP.Character.HumanoidRootPart.CFrame = old; _G.Noclip = false
            end
        end
    end
})

-- ==================== TAB 6: TIỆN ÍCH ====================
local Tab6 = Window:CreateTab("🔧 TIỆN ÍCH", 4483362458)

Tab6:CreateButton({
    Name = "🔄 VÀO LẠI SERVER (REJOIN)",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end
})

Tab6:CreateSlider({
    Name = "📷 CHỈNH POV (FOV)",
    Min = 30, Max = 120, Default = 70,
    Color = Color3.fromRGB(44, 120, 224),
    Increment = 1, ValueName = "độ",
    Callback = function(v) Camera.FieldOfView = v end
})

-- ==================== HỆ THỐNG XỬ LÝ NGẦM ====================
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

UIS.JumpRequest:Connect(function()
    if _G.InfJump and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.Aimbot and _G.AimbotPart then
        local target = nil; local dist = _G.AimbotFOV
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild(_G.AimbotPart) then
                local p, on = Camera:WorldToScreenPoint(v.Character[_G.AimbotPart].Position)
                if on then
                    local d = (Vector2.new(p.X, p.Y) - (Camera.ViewportSize/2)).Magnitude
                    if d < dist then target = v; dist = d end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[_G.AimbotPart].Position) end
    end
    if _G.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and not p.Character:FindFirstChild("ViloESP") then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "ViloESP"; h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

Rayfield:Notify({Title = "VIP ULTRA MENU", Content = "Đã Fix Full 6 Tab Cho Ní!", Duration = 5})
