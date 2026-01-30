--[[
    🌑 MOON PROJECT: ELITE (V12)
    - Manual Flight Control
    - Compact UI with Margins
    - Audio Notifications (Top-Right)
    - Fixed Drag System
]]

local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

if _G.MoonElite then return end
_G.MoonElite = true

local Config = {
    Speed = 16, Jump = 50, Fly = false, FlySpeed = 50,
    ESP = false, NoClip = false
}

-- [СИСТЕМА ЗВУКОВ]
local function PlaySound(id)
    local s = Instance.new("Sound", game:GetService("SoundService"))
    s.SoundId = "rbxassetid://"..id; s.Volume = 0.5; s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

-- [УВЕДОМЛЕНИЯ СО ЗВУКОМ]
local function Notify(txt, state)
    local n = Instance.new("Frame", PlayerGui:FindFirstChild("MoonEliteGui"))
    n.Size = UDim2.new(0, 180, 0, 35); n.Position = UDim2.new(1, 10, 0.05, 0)
    n.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", n)
    local t = Instance.new("TextLabel", n); t.Size = UDim2.new(1,0,1,0); t.Text = txt.." "..(state and "ON" or "OFF")
    t.TextColor3 = state and Color3.new(0,1,0) or Color3.new(1,0,0); t.Font = "GothamBold"; t.TextSize = 12; t.BackgroundTransparency = 1
    
    n:TweenPosition(UDim2.new(1, -200, 0.05, 0), "Out", "Quart", 0.3)
    PlaySound(state and 1053273954 or 1053274266) -- Звуки вкл/выкл
    task.delay(2, function() n:TweenPosition(UDim2.new(1, 10, 0.05, 0), "In", "Quart", 0.3); task.wait(0.3); n:Destroy() end)
end

-- [GUI SETUP]
local MoonGui = Instance.new("ScreenGui", PlayerGui); MoonGui.Name = "MoonEliteGui"

-- [ПЛАВНЫЙ DRAG ДЛЯ ВСЕГО]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

-- ИКОНКА
local Icon = Instance.new("Frame", MoonGui)
Icon.Size = UDim2.new(0, 65, 0, 65); Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.new(0,0,0); Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.new(1,1,1)
local MoonIco = Instance.new("TextLabel", Icon); MoonIco.Size = UDim2.new(1,0,1,0); MoonIco.Text = "🌙"; MoonIco.TextSize = 30; MoonIco.BackgroundTransparency = 1
MakeDraggable(Icon)

-- МЕНЮ (МЕНЬШЕ И АККУРАТНЕЕ)
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 450, 0, 320); Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
MakeDraggable(Main)

-- ШРИФТ ЗАГОЛОВКА (ЧУТЬ МЕНЬШЕ)
local Logo = Instance.new("TextLabel", Main)
Logo.Size = UDim2.new(1, 0, 0, 70); Logo.Position = UDim2.new(0, 0, 0, -45)
Logo.Text = "MOON PROJECT"; Logo.Font = "GothamBlack"; Logo.TextSize = 45; Logo.BackgroundTransparency = 1
spawn(function() while task.wait() do local v = (math.sin(tick()*2)+1)/2 Logo.TextColor3 = Color3.new(v,v,v) end end)

-- КОНТЕЙНЕР ДЛЯ ФУНКЦИЙ (С ОТСТУПАМИ)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -40, 1, -40); Scroll.Position = UDim2.new(0, 20, 0, 20)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 10)

-- [UI TOOLKIT]
local function AddToggle(txt, cb)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = "  "..txt
    b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "Gotham"; b.TextSize = 14; b.TextXAlignment = "Left"; Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; cb(s); b.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(20,20,20)
        b.TextColor3 = s and Color3.new(0,0,0) or Color3.new(0.8,0.8,0.8)
        Notify(txt, s)
    end)
end

local function AddSlider(txt, min, max, def, cb)
    local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, 0, 0, 50); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,20); l.Text = txt..": "..def; l.TextColor3 = Color3.new(1,1,1); l.TextXAlignment = "Left"; l.BackgroundTransparency = 1
    local bar = Instance.new("Frame", f); bar.Size = UDim2.new(1,0,0,4); bar.Position = UDim2.new(0,0,0.7,0); bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local dot = Instance.new("Frame", bar); dot.Size = UDim2.new(0,14,0,14); dot.Position = UDim2.new((def-min)/(max-min),-7,0.5,-10); dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", dot)
    -- Логика слайдера (упрощенная для стабильности)
    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local m; m = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local r = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
                    dot.Position = UDim2.new(r, -7, 0.5, -10)
                    local v = math.floor(min + (max-min)*r); l.Text = txt..": "..v; cb(v)
                end
            end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then m:Disconnect() end end)
        end
    end)
end

-- ФУНКЦИИ
AddSlider("Speed", 16, 500, 16, function(v) Config.Speed = v end)
AddToggle("Fly Mode", function(s) Config.Fly = s end)
AddSlider("Fly Speed", 10, 500, 50, function(v) Config.FlySpeed = v end)
AddToggle("ESP Players", function(s) Config.ESP = s end)
AddToggle("NoClip", function(s) Config.NoClip = s end)

-- [ЦИКЛ РАБОТЫ]
RunService.Stepped:Connect(function()
    local char = LPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if not Config.Fly then
            char.Humanoid.WalkSpeed = Config.Speed
        else
            -- Ручной полет через Velocity
            char.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * (Config.FlySpeed * (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0))
        end
        if Config.NoClip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- Управление кнопкой
local Toggle = Instance.new("TextButton", Icon); Toggle.Size = UDim2.new(1,0,1,0); Toggle.BackgroundTransparency = 1; Toggle.Text = ""
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("Moon Elite V12 Loaded")
