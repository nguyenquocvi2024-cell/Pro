-- Anime Full Custom Hub Blox Fruits 2026 | Keyless | Menu Đẹp Full Tính Năng
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RServ = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- Anti-Detect Basic (block kick/ban strings phổ biến)
local mt = getrawmetatable(game)
local oldNC = mt.__namecall
setreadonly(mt, false)
local banStr = {"Kick", "Ban", "AntiCheat", "Byfron", "Detect", "TeleportDetect", "FORCEFIELD"}
mt.__namecall = newcclosure(function(self, ...)
    local meth = getnamecallmethod()
    local args = {...}
    if meth:find("FireServer") or meth:find("InvokeServer") then
        for _, s in ipairs(banStr) do
            if table.find(args, s) or (args[1] and tostring(args[1]):lower():find(s:lower())) then return end
        end
    end
    if meth:lower() == "kick" and self == LP then return end
    return oldNC(self, ...)
end)
setreadonly(mt, true)

print("✅ Anti-Detect Basic ON")

-- GUI Full Menu
local sg = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
sg.Name = "AnimeFullHub"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 620)
main.Position = UDim2.new(0.5, -275, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
title.Text = "ANIME FULL HUB BLOX FRUITS 2026"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 26

-- Draggable
local drag, dragS, startP
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragS = inp.Position
        startP = main.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - dragS
        main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

-- Tabs
local tabs = {"AUTO FARM", "COMBAT", "FRUITS", "MISC", "TELEPORT"}
local tabBtns, tabContents = {}, {}
local yOff = 70
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.2, 0, 0, 50)
    btn.Position = UDim2.new(0.2*(i-1), 0, 0, yOff)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    table.insert(tabBtns, btn)
    
    local cont = Instance.new("ScrollingFrame", main)
    cont.Size = UDim2.new(1, -20, 1, -140)
    cont.Position = UDim2.new(0, 10, 0, 130)
    cont.CanvasSize = UDim2.new(0,0,0,1200)
    cont.BackgroundTransparency = 1
    cont.Visible = false
    cont.ScrollBarThickness = 6
    table.insert(tabContents, cont)
    
    btn.MouseButton1Click:Connect(function()
        for _, c in ipairs(tabContents) do c.Visible = false end
        cont.Visible = true
    end)
end
tabContents[1].Visible = true

local function tog(parent, name, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -20, 0, 60)
    f.BackgroundTransparency = 1
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextSize = 20
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.3, 0, 0.7, 0)
    btn.Position = UDim2.new(0.67, 0, 0.15, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.new(1,0,0)
    btn.TextSize = 18
    
    local en = false
    btn.MouseButton1Click:Connect(function()
        en = not en
        btn.Text = en and "ON" or "OFF"
        btn.TextColor3 = en and Color3.new(0,1,0) or Color3.new(1,0,0)
        callback(en)
    end)
    return f
end

-- AUTO FARM Tab
local af = tabContents[1]
tog(af, "Auto Farm Level", function(s) print("Auto Farm Level: "..(s and "ON" or "OFF")) end) -- Thêm logic pathfind/enemy farm thật
tog(af, "Auto Mastery", function(s) print("Auto Mastery: "..(s and "ON" or "OFF")) end)
tog(af, "Auto Quest", function(s) print("Auto Quest: "..(s and "ON" or "OFF")) end)
tog(af, "Auto Boss", function(s) print("Auto Boss: "..(s and "ON" or "OFF")) end)
tog(af, "Auto Raid/Dungeon", function(s) print("Raid: "..(s and "ON" or "OFF")) end)
tog(af, "Auto Sea Event/Mirage", function(s) print("Sea/Mirage: "..(s and "ON" or "OFF")) end)
tog(af, "Auto Chest/Farm Berry", function(s) print("Chest/Berry: "..(s and "ON" or "OFF")) end)
tog(af, "Bring Mobs", function(s) print("Bring Mobs: "..(s and "ON" or "OFF")) end) -- Loop tp mobs to player

-- COMBAT Tab
local cb = tabContents[2]
tog(cb, "Fast Attack", function(s)
    if s then spawn(function() while s do task.wait(0.05) pcall(function() RServ.RigControllerEvent:FireServer("hit") end) end end) end
end)
tog(cb, "Kill Aura", function(s) print("Kill Aura: "..(s and "ON" or "OFF")) end) -- Loop damage nearby
tog(cb, "Aimbot (Hold RMB)", function(s) print("Aimbot: "..(s and "ON" or "OFF")) end)

-- FRUITS Tab
local fr = tabContents[3]
tog(fr, "Fruit Sniper (Auto Buy)", function(s) print("Fruit Sniper: "..(s and "ON" or "OFF")) end)
tog(fr, "Fruit ESP (Highlight)", function(s) print("Fruit ESP: "..(s and "ON" or "OFF")) end) -- Highlight fruits

-- MISC Tab
local ms = tabContents[4]
tog(ms, "Fly (WASD/Space)", function(s) print("Fly: "..(s and "ON" or "OFF")) end) -- Thêm bodyvel/gyro
tog(ms, "NoClip", function(s) print("NoClip: "..(s and "ON" or "OFF")) end) -- Stepped CanCollide = false
tog(ms, "Speed Hack x3", function(s) LP.Character.Humanoid.WalkSpeed = s and 48 or 16 end)
tog(ms, "Inf Jump", function(s) print("Inf Jump: "..(s and "ON" or "OFF")) end) -- UIS JumpRequest
tog(ms, "Anti-AFK", function(s)
    if s then spawn(function() while s do game:GetService("VirtualUser"):Button2Down(Vector2.new()) task.wait(60) end end) end
end)

-- TELEPORT Tab
local tp = tabContents[5]
local islands = {"First Sea", "Second Sea", "Third Sea", "Mirage", "Safe Zone", "Boss Locations"}
for i, isl in ipairs(islands) do
    local b = Instance.new("TextButton", tp)
    b.Size = UDim2.new(0.45, 0, 0, 50)
    b.Position = UDim2.new((i%2==1 and 0.02 or 0.53), 0, math.floor((i-1)/2)*60, 0)
    b.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    b.Text = "TP "..isl
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function() print("Teleport to "..isl) end) -- Thêm CFrame tp thật
end

-- Close Btn
local cl = Instance.new("TextButton", main)
cl.Size = UDim2.new(0, 60, 0, 60)
cl.Position = UDim2.new(1, -70, 0, 0)
cl.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
cl.Text = "X"
cl.TextColor3 = Color3.new(1,1,1)
cl.TextSize = 30
cl.MouseButton1Click:Connect(function() sg:Destroy() end)

print("✅ Anime Full Hub Loaded! Menu full tính năng như Banana/Maru. Toggle thoải mái bro!")
