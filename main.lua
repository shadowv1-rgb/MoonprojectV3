-- Moon Project 🌑 V6 (Ultra HD & Advanced Visuals)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("MoonV6") then PlayerGui.MoonV6:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV6"
MoonGui.ResetOnSpawn = false

-- Настройки функций
local SpeedValue = 16
local FlySpeed = 50
local Flying = false
local ESP = {Box = false, Tracers = false, Names = false}

-- 1. ИКОНКА (4K Стиль с переливом)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 70, 0, 70)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
OpenBtn.Image = "rbxassetid://605124567" -- Красивая луна
OpenBtn.Active = true; OpenBtn.Draggable = true

local BtnCorner = Instance.new("UICorner", OpenBtn); BtnCorner.CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Thickness = 2; BtnStroke.Color = Color3.new(1, 1, 1)

local BtnGradient = Instance.new("UIGradient", BtnStroke)
BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 200))
})

-- 2. ГЛАВНОЕ МЕНЮ (Ultra UI)
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 420, 0, 320)
Main.Position = UDim2.new(0.5, -210, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
Main.Visible = false; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

-- Неоновая обводка меню
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainGradient = Instance.new("UIGradient", MainStroke)
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
})

-- Анимация перелива обводки
spawn(function()
    while task.wait() do
        MainGradient.Rotation = MainGradient.Rotation + 1
    end
end)

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60); Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "MOON PROJECT 🌙"; Title.Font = Enum.Font.GothamBold; Title.TextSize = 24
Title.TextColor3 = Color3.new(1, 1, 1); Title.BackgroundTransparency = 1

-- КНОПКИ ВКЛАДОК
local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(1, 0, 0, 40); TabContainer.Position = UDim2.new(0, 0, 0, 65); TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 15)

local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -30, 1, -120); PageContainer.Position = UDim2.new(0, 15, 0, 110); PageContainer.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0, 90, 0, 30); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(30, 35, 60); Instance.new("UICorner", btn)
    
    local p = Instance.new("ScrollingFrame", PageContainer); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        p.Visible = true
    end)
    Pages[name] = p
    return p
end

local MainP = CreatePage("MAIN"); MainP.Visible = true
local VisualP = CreatePage("VISUALS")
local SettingP = CreatePage("SETTINGS")

-- КОНСТРУКТОР ТОГГЛА (4K Стиль)
local function AddToggle(parent, text, callback)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, 0, 0, 45); t.BackgroundColor3 = Color3.fromRGB(20, 22, 40); t.Text = "  " .. text; t.Font = Enum.Font.Gotham; t.TextSize = 16
    t.TextColor3 = Color3.new(0.8, 0.8, 0.8); t.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", t)
    
    local box = Instance.new("Frame", t); box.Size = UDim2.new(0, 40, 0, 20); box.Position = UDim2.new(1, -50, 0.5, -10); box.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Instance.new("UICorner", box).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", box); dot.Size = UDim2.new(0, 16, 0, 16); dot.Position = UDim2.new(0, 2, 0.5, -8); dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = false
    t.MouseButton1Click:Connect(function()
        state = not state
        dot:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2)
        box.BackgroundColor3 = state and Color3.fromRGB(0, 200, 150) or Color3.fromRGB(40, 40, 60)
        callback(state)
    end)
end

-- ФУНКЦИИ
AddToggle(MainP, "Fly Mode (Camera)", function(s)
    Flying = s
    if s then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        spawn(function() while Flying do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed; task.wait() end bv:Destroy() end)
    end
end)

AddToggle(VisualP, "ESP Boxes", function(s) ESP.Box = s end)
AddToggle(VisualP, "ESP Names", function(s) ESP.Names = s end)
AddToggle(VisualP, "ESP Tracers", function(s) ESP.Tracers = s end)

AddToggle(SettingP, "Anti-AFK", function(s)
    print("Anti-AFK: " .. tostring(s))
end)

-- ЗАКРЫТИЕ
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 80, 0, 30); Close.Position = UDim2.new(1, -95, 0, 15); Close.Text = "✕ Close"; Close.BackgroundColor3 = Color3.fromRGB(180, 50, 60); Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close)

Close.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- ESP ЦИКЛ
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character then
            -- Box & Names logic
            if ESP.Box then
                if not p.Character:FindFirstChild("MoonHighlight") then
                    local h = Instance.new("Highlight", p.Character); h.Name = "MoonHighlight"; h.FillTransparency = 0.6; h.OutlineColor = Color3.new(1,1,1)
                end
            else
                if p.Character:FindFirstChild("MoonHighlight") then p.Character.MoonHighlight:Destroy() end
            end
        end
    end
end)

print("Moon Project V6 Ultra Loaded! 🌌")
