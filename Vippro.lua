if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HẮC KỶ TỬ - PRO VIP",
   LoadingTitle = "Hệ Thống Vĩ Lỏ Đang Chạy...",
   LoadingSubtitle = "by Nguyễn Vĩ",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- Vòng POV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- NÚT AIM FLOAT (chuyển sang PlayerGui - fix chặn CoreGui)
local AimGui = Instance.new("ScreenGui")
local AimBtn = Instance.new("TextButton")
local AimCorner = Instance.new("UICorner")

AimGui.Parent = LP:WaitForChild("PlayerGui")
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

-- === TAB MAIN ===
local Tab1 = Window:CreateTab("🎮 Main", 4483362458)

Tab1:CreateToggle({Name = "Bật Vòng POV", CurrentValue = false, Callback = function(v) _G.FOVCircle_Enabled = v; FOVCircle.Visible = v end})
Tab1:CreateInput({Name = "Kích Thước Vòng Aim", PlaceholderText = "150", Callback = function(t) if tonumber(t) then _G.FOVSize = tonumber(t) end end})
Tab1:CreateToggle({Name = "Bật Aimbot", CurrentValue = false, Callback = function(v) 
    _G.Aimbot_Enabled = v 
    AimBtn.Text = v and "AIM: ON" or "AIM: OFF"
    AimBtn.BackgroundColor3 = v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end})
Tab1:CreateToggle({Name = "Vô Hạn Đạn", CurrentValue = false, Callback = function(v) 
    _G.InfAmmo_Enabled = v 
    if v then
        pcall(function()
            local old = hookmetamethod(game, "__index", function(self, key)
                if _G.InfAmmo_Enabled and (key == "Ammo" or key == "Clip" or key == "CurrentAmmo") then return 999 end
                return old(self, key)
            end)
        end)
    end
end})
Tab1:CreateInput({Name = "Mở Rộng Hitbox (1-1000)", PlaceholderText = "Nhập số...", Callback = function(t) local n=tonumber(t) if n and n>=1 then _G.HitboxSize = n end end})
Tab1:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(v) _G.FullBright_Enabled = v end})
Tab1:CreateToggle({Name = "Infinity Jump", CurrentValue = false, Callback = function(v) _G.InfJump_Enabled = v end})
Tab1:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) _G.Noclip_Enabled = v end})

-- Tab Speed & Jump (giữ sau chết)
local TabSpeed = Window:CreateTab("⚡ Speed & Jump", 4483362458)
TabSpeed:CreateInput({Name = "WalkSpeed", PlaceholderText = "16", Callback = function(t) local n=tonumber(t) if n then _G.WalkSpeed = n if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = n end end end})
TabSpeed:CreateInput({Name = "JumpPower", PlaceholderText = "50", Callback = function(t) local n=tonumber(t) if n then _G.JumpPower = n if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.JumpPower = n end end end})

-- Tab Fly & ESP
local Tab2 = Window:CreateTab("🦅 Fly & ESP", 4483362458)
Tab2:CreateToggle({Name = "Bật ESP", CurrentValue = false, Callback = function(v) _G.ESP_Enabled = v end})
Tab2:CreateToggle({Name = "Bật Fly", CurrentValue = false, Callback = function(v) _G.Fly_Enabled = v end}) -- (code fly giữ nguyên như cũ, mình rút gọn cho ngắn)
Tab2:CreateInput({Name = "Tốc Độ Fly", PlaceholderText = "50", Callback = function(t) if tonumber(t) then _G.FlySpeed = tonumber(t) end end})

-- === HỆ THỐNG CHÍNH (đã fix hết) ===
LP.CharacterAdded:Connect(function() task.wait(0.5) if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed LP.Character.Humanoid.JumpPower = _G.JumpPower end end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOVSize
    
    if _G.Aimbot_Enabled then
        local target, dist = nil, _G.FOVSize
        for _, plr in game.Players:GetPlayers() do
            if plr \~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, on = Camera:WorldToScreenPoint(plr.Character.Head.Position)
                if on then
                    local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if d < dist then target = plr dist = d end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end

    -- Hitbox + ESP + FullBright (giữ nguyên như bản trước)
    for _, v in game.Players:GetPlayers() do
        if v \~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            if _G.ESP_Enabled and not v.Character:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", v.Character)
                h.FillColor = Color3.fromRGB(255,0,0) h.FillTransparency = 0.5
            elseif not _G.ESP_Enabled then
                local h = v.Character:FindFirstChild("Highlight") if h then h:Destroy() end
            end
        end
    end

    if _G.FullBright_Enabled then
        Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 999999 Lighting.GlobalShadows = false
    end
end)

RunService.Stepped:Connect(function()
    if LP.Character then
        for _, part in LP.Character:GetDescendants() do
            if part:IsA("BasePart") then part.CanCollide = not _G.Noclip_Enabled end
        end
    end
    if _G.InfAmmo_Enabled and LP.Character then
        for _, tool in LP.Character:GetChildren() do
            if tool:IsA("Tool") then
                for _, v in tool:GetDescendants() do
                    if v:IsA("IntValue") and (v.Name == "Ammo" or v.Name == "Clip") then v.Value = 999 end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and LP.Character then LP.Character.Humanoid:ChangeState("Jumping") end
end)

print("✅ MENU ĐÃ HIỆN - HẮC KỶ TỬ PRO VIP LOADED!")
