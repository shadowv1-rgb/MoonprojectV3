--[[
    🌑 MOON PROJECT: AESTHETIC EDITION (V9)
    ULTRA HIGH-END SCRIPT INTERFACE
    White-to-Black Monochrome Transition Logic
]]

local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Очистка старых версий
for _, v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "MoonProject_Aesthetic" then v:Destroy() end
end

local Moon = Instance.new("ScreenGui", PlayerGui)
Moon.Name = "MoonProject_Aesthetic"
Moon.ResetOnSpawn = false

-- Настройки
local Config = {
    Speed = 16, Jump = 50, FlySpeed = 50, 
    Flying = false, ESP = false, Tracers = false,
    NoClip = false, AntiAFK = false, RainbowMenu = false
}

-- === СИСТЕМА ПЕРЕМЕЩЕНИЯ (DRAG) ===
local function EnableDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- === КНОПКА ОТКРЫТИЯ (4K STAR ICON) ===
local OpenBtn = Instance.new("Frame", Moon)
OpenBtn.Size = UDim2.new(0, 70, 0, 70); OpenBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); OpenBtn.ClipsDescendants = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", OpenBtn); BtnStroke.Thickness = 2; BtnStroke.Color = Color3.new(1,1,1)
EnableDrag(OpenBtn)

local MoonImg = Instance.new("ImageLabel", OpenBtn)
MoonImg.Size = UDim2.new(0.7, 0, 0.7, 0); MoonImg.Position = UDim2.new(0.15, 0, 0.15, 0)
MoonImg.Image = "rbxassetid://605124567"; MoonImg.BackgroundTransparency = 1; MoonImg.ZIndex = 2

-- Звезды (теперь не вылазят)
for i = 1, 20 do
    local s = Instance.new("Frame", OpenBtn)
    s.Size = UDim2.new(0, 2, 0, 2); s.BackgroundColor3 = Color3.new(1,1,1)
    s.Position = UDim2.new(math.random(0.1, 0.9), 0, math.random(0.1, 0.9), 0)
    Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
    spawn(function() while task.wait(math.random(1,3)) do
        TweenService:Create(s, TweenInfo.new(1), {BackgroundTransparency = 1}):Play(); task.wait(1)
        TweenService:Create(s, TweenInfo.new(1), {BackgroundTransparency = 0.4}):Play()
    end end)
end

local ToggleBtn = Instance.new("TextButton", OpenBtn)
ToggleBtn.Size = UDim2.new(1,0,1,0); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Text = ""

-- === ГЛАВНОЕ МЕНЮ ===
local Main = Instance.new("Frame", Moon)
Main.Size = UDim2.new(0, 500, 0, 350); Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Main.ClipsDescendants = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 1.5; MainStroke.Color = Color3.fromRGB(40, 40, 40)
EnableDrag(Main)

-- СУПЕР КРАСИВЫЙ ШРИФТ (White to Black Transition)
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 80); Header.Position = UDim2.new(0, 0, 0, -50)
Header.Text = "MOON PROJECT"; Header.Font = Enum.Font.Unknown -- Использует системный жирный
Header.TextSize = 60; Header.BackgroundTransparency = 1; Header.ZIndex = 3
spawn(function()
    while task.wait() do
        local val = (math.sin(tick() * 2) + 1) / 2
        Header.TextColor3 = Color3.new(val, val, val)
    end
end)

-- Левый Сайдбар (Вкладки)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

-- Контент
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -160, 1, -20); Content.Position = UDim2.new(0, 150, 0, 10)
Content.BackgroundTransparency = 1

local Pages = {}
local function NewPage(name)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamMedium; b.TextSize = 14
    Instance.new("UICorner", b)
    
    local p = Instance.new("ScrollingFrame", Content)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        p.Visible = true
    end)
    Pages[name] = p
    return p
end

-- Вкладки
local MainP = NewPage("General ⚡"); MainP.Visible = true
local VisualP = NewPage("Visuals 👁")
local WorldP = NewPage("World 🌍")
local SettingP = NewPage("Settings ⚙")

-- === ЭЛЕМЕНТЫ (UI Toolkit) ===
local function AddToggle(parent, text, callback)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, -5, 0, 40); f.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    f.Text = "  "..text; f.TextColor3 = Color3.fromRGB(200, 200, 200); f.TextXAlignment = "Left"; f.Font = "Gotham"
    Instance.new("UICorner", f)
    local s = false
    f.MouseButton1Click:Connect(function()
        s = not s; callback(s)
        TweenService:Create(f, TweenInfo.new(0.3), {BackgroundColor3 = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(18, 18, 18)}):Play()
        f.TextColor3 = s and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)
end

local function AddSlider(parent, text, min, max, def, callback)
    local h = Instance.new("Frame", parent); h.Size = UDim2.new(1, -5, 0, 50); h.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", h); l.Size = UDim2.new(1,0,0,20); l.Text = text..": "..def; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
    local bar = Instance.new("Frame", h); bar.Size = UDim2.new(1,0,0,4); bar.Position = UDim2.new(0,0,0.7,0); bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local dot = Instance.new("Frame", bar); dot.Size = UDim2.new(0,14,0,14); dot.Position = UDim2.new((def-min)/(max-min), -7, 0.5, -7); dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", dot)
    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local r = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
                    dot.Position = UDim2.new(r, -7, 0.5, -7)
                    local v = math.floor(min + (max-min)*r); l.Text = text..": "..v; callback(v)
                end
            end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
        end
    end)
end

-- === ФУНКЦИОНАЛ ===
AddSlider(MainP, "WalkSpeed", 16, 300, 16, function(v) Config.Speed = v end)
AddSlider(MainP, "JumpPower", 50, 300, 50, function(v) Config.Jump = v end)
AddToggle(MainP, "Fly Camera Mode", function(s) 
    Config.Flying = s
    if s then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        spawn(function() while Config.Flying do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * Config.FlySpeed; task.wait() end bv:Destroy() end)
    end
end)

AddToggle(VisualP, "ESP Box", function(s) Config.ESP = s end)
AddToggle(VisualP, "ESP Tracers", function(s) Config.Tracers = s end)

AddToggle(WorldP, "NoClip (Walls)", function(s) Config.NoClip = s end)
AddToggle(SettingP, "Anti-AFK System", function(s) Config.AntiAFK = s end)

-- Логика
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

RunService.Heartbeat:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        LPlayer.Character.Humanoid.WalkSpeed = Config.Speed
        LPlayer.Character.Humanoid.JumpPower = Config.Jump
        if Config.NoClip then
            for _, v in pairs(LPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and p.Character then
                if not p.Character:FindFirstChild("MoonGlow") then
                    local h = Instance.new("Highlight", p.Character); h.Name = "MoonGlow"; h.FillTransparency = 0.5
                end
            end
        end
    end
end)

print("Moon Project Aesthetic V9 Loaded Successfully.")
