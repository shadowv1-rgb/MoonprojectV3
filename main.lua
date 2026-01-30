-- Moon Project 🌑 V5 (Settings & Anti-AFK)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")

if PlayerGui:FindFirstChild("MoonV5") then PlayerGui.MoonV5:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV5"
MoonGui.ResetOnSpawn = false

-- ПЕРЕМЕННЫЕ
local SpeedValue = 16
local FlySpeed = 50
local Flying = false
local ESP_Enabled = {Box = false, Tracers = false}
local AntiAFK_Enabled = false

-- 1. ИКОНКА (Месяц)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 60); OpenBtn.Active = true; OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local MoonLabel = Instance.new("TextLabel", OpenBtn)
MoonLabel.Size = UDim2.new(1,0,1,0); MoonLabel.Text = "🌙"; MoonLabel.BackgroundTransparency = 1; MoonLabel.TextSize = 30; MoonLabel.TextColor3 = Color3.new(1,1,1)

-- 2. ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 380, 0, 380); Main.Position = UDim2.new(0.5, -190, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(12, 14, 24); Main.Visible = false; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

-- ПЕРЕЛИВАЮЩИЙСЯ ТЕКСТ
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45); Title.Text = "MOON PROJECT 🌑"; Title.Font = Enum.Font.GothamBold; Title.TextSize = 22; Title.BackgroundTransparency = 1
spawn(function() while task.wait() do local c = math.sin(tick()*2)*0.5+0.5; Title.TextColor3 = Color3.new(c,c,c) end end)

-- ВКЛАДКИ
local TabButtons = Instance.new("Frame", Main)
TabButtons.Size = UDim2.new(1, 0, 0, 40); TabButtons.Position = UDim2.new(0, 0, 0, 50); TabButtons.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabButtons); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 5)

local function CreateTabBtn(name)
    local btn = Instance.new("TextButton", TabButtons)
    btn.Size = UDim2.new(0, 110, 1, 0); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 35, 55); btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    return btn
end

local MainBtn = CreateTabBtn("MAIN")
local VisualBtn = CreateTabBtn("VISUALS")
local SettingsBtn = CreateTabBtn("SETTINGS")

-- СТРАНИЦЫ
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -20, 1, -110); Container.Position = UDim2.new(0, 10, 0, 100); Container.BackgroundTransparency = 1

local function CreatePage()
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0,10); return p
end

local PageMain = CreatePage(); PageMain.Visible = true
local PageVisuals = CreatePage()
local PageSettings = CreatePage()

-- ЛОГИКА ВКЛАДОК
MainBtn.MouseButton1Click:Connect(function() PageMain.Visible = true; PageVisuals.Visible = false; PageSettings.Visible = false end)
VisualBtn.MouseButton1Click:Connect(function() PageMain.Visible = false; PageVisuals.Visible = true; PageSettings.Visible = false end)
SettingsBtn.MouseButton1Click:Connect(function() PageMain.Visible = false; PageVisuals.Visible = false; PageSettings.Visible = true end)

-- КОНСТРУКТОРЫ
local function CreateToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(25, 30, 50); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(25, 30, 50)
        callback(state)
    end)
end

local function CreateSlider(parent, name, min, max, def, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1,0,0,50); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,20); l.Text = name..": "..def; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0.9,0,0,5); b.Position = UDim2.new(0.05,0,0.7,0); b.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
    local d = Instance.new("TextButton", b); d.Size = UDim2.new(0,15,0,15); d.Position = UDim2.new((def-min)/(max-min),-7,0.5,-7); d.Text = ""; Instance.new("UICorner", d)
    d.MouseButton1Down:Connect(function()
        local c; c = UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local rel = math.clamp((input.Position.X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                d.Position = UDim2.new(rel, -7, 0.5, -7)
                local val = math.floor(min + (max-min)*rel); l.Text = name..": "..val; callback(val)
            end
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then c:Disconnect() end end)
    end)
end

-- === MAIN ===
CreateSlider(PageMain, "WalkSpeed", 16, 300, 16, function(v) SpeedValue = v end)
CreateSlider(PageMain, "Fly Speed", 10, 500, 50, function(v) FlySpeed = v end)
CreateToggle(PageMain, "Fly Mode", function(s)
    Flying = s
    if s then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart); bv.Name = "MoonFly"; bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        spawn(function() while Flying do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed; task.wait() end bv:Destroy() end)
    end
end)

-- === VISUALS ===
CreateToggle(PageVisuals, "ESP Box", function(s) ESP_Enabled.Box = s end)
CreateToggle(PageVisuals, "ESP Tracers", function(s) ESP_Enabled.Tracers = s end)

-- === SETTINGS ===
CreateToggle(PageSettings, "Anti-AFK", function(s)
    AntiAFK_Enabled = s
    if s then print("Moon Project: Anti-AFK Enabled") end
end)

-- ANTI-AFK LOGIC
LPlayer.Idled:Connect(function()
    if AntiAFK_Enabled then
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end
end)

-- РАБОЧИЙ ЦИКЛ
RunService.RenderStepped:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then LPlayer.Character.Humanoid.WalkSpeed = SpeedValue end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character then
            if ESP_Enabled.Box then
                if not p.Character:FindFirstChild("MoonBox") then local h = Instance.new("Highlight", p.Character); h.Name = "MoonBox"; h.FillColor = Color3.new(0.5,0.5,1) end
            else if p.Character:FindFirstChild("MoonBox") then p.Character.MoonBox:Destroy() end end
        end
    end
end)

-- КНОПКИ
local CloseBtn = Instance.new("TextButton", Main); CloseBtn.Size = UDim2.new(0,30,0,30); CloseBtn.Position = UDim2.new(1,-35,0,5); CloseBtn.Text = "✕"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)
