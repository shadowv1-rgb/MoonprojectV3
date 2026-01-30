-- Moon Project 🌑 V4 (Tabs & Advanced ESP)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("MoonV4") then PlayerGui.MoonV4:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV4"
MoonGui.ResetOnSpawn = false

-- ПЕРЕМЕННЫЕ
local SpeedValue = 16
local FlySpeed = 50
local Flying = false
local ESP_Enabled = {Box = false, Tracers = false, Names = false}

-- 1. ИКОНКА (Месяц)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local MoonLabel = Instance.new("TextLabel", OpenBtn)
MoonLabel.Size = UDim2.new(1,0,1,0); MoonLabel.Text = "🌙"; MoonLabel.BackgroundTransparency = 1; MoonLabel.TextSize = 30; MoonLabel.TextColor3 = Color3.new(1,1,1)

-- 2. ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 380, 0, 350)
Main.Position = UDim2.new(0.5, -190, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(12, 14, 24)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- ПЕРЕЛИВАЮЩИЙСЯ ТЕКСТ
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MOON PROJECT 🌑"
Title.Font = Enum.Font.GothamBold; Title.TextSize = 22; Title.BackgroundTransparency = 1
spawn(function() while task.wait() do local c = math.sin(tick()*2)*0.5+0.5; Title.TextColor3 = Color3.new(c,c,c) end end)

-- ВКЛАДКИ (TABS)
local TabButtons = Instance.new("Frame", Main)
TabButtons.Size = UDim2.new(1, 0, 0, 40)
TabButtons.Position = UDim2.new(0, 0, 0, 45)
TabButtons.BackgroundTransparency = 1

local function CreateTabBtn(name, pos)
    local btn = Instance.new("TextButton", TabButtons)
    btn.Size = UDim2.new(0.5, -15, 1, 0)
    btn.Position = UDim2.new(pos, (pos == 0 and 10 or 5), 0, 0)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 35, 55); btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    return btn
end

local MainBtn = CreateTabBtn("MAIN", 0)
local VisualBtn = CreateTabBtn("VISUALS", 0.5)

-- СТРАНИЦЫ
local MainPages = Instance.new("Frame", Main)
MainPages.Size = UDim2.new(1, -20, 1, -100); MainPages.Position = UDim2.new(0, 10, 0, 90); MainPages.BackgroundTransparency = 1

local PageMain = Instance.new("ScrollingFrame", MainPages); PageMain.Size = UDim2.new(1,0,1,0); PageMain.BackgroundTransparency = 1; PageMain.Visible = true; PageMain.ScrollBarThickness = 0
local PageVisuals = Instance.new("ScrollingFrame", MainPages); PageVisuals.Size = UDim2.new(1,0,1,0); PageVisuals.BackgroundTransparency = 1; PageVisuals.Visible = false; PageVisuals.ScrollBarThickness = 0
Instance.new("UIListLayout", PageMain).Padding = UDim.new(0,10)
Instance.new("UIListLayout", PageVisuals).Padding = UDim.new(0,10)

-- ЛОГИКА ВКЛАДОК
MainBtn.MouseButton1Click:Connect(function() PageMain.Visible = true; PageVisuals.Visible = false end)
VisualBtn.MouseButton1Click:Connect(function() PageMain.Visible = false; PageVisuals.Visible = true end)

-- ФУНКЦИИ КОНСТРУКТОРЫ
local function CreateToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(25, 30, 50); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
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

-- === НАПОЛНЕНИЕ MAIN ===
CreateSlider(PageMain, "WalkSpeed", 16, 300, 16, function(v) SpeedValue = v end)
CreateSlider(PageMain, "Fly Speed", 10, 500, 50, function(v) FlySpeed = v end)
CreateToggle(PageMain, "Fly Mode", function(s)
    Flying = s
    if s then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart); bv.Name = "MoonFly"; bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        spawn(function() while Flying do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed; task.wait() end bv:Destroy() end)
    end
end)

-- === НАПОЛНЕНИЕ VISUALS ===
CreateToggle(PageVisuals, "ESP Box", function(s) ESP_Enabled.Box = s end)
CreateToggle(PageVisuals, "ESP Tracers (Линии)", function(s) ESP_Enabled.Tracers = s end)
CreateToggle(PageVisuals, "ESP Names", function(s) ESP_Enabled.Names = s end)

-- ESP ЦИКЛ
RunService.RenderStepped:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then LPlayer.Character.Humanoid.WalkSpeed = SpeedValue end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            -- Box
            if ESP_Enabled.Box then
                if not char:FindFirstChild("MoonBox") then
                    local h = Instance.new("Highlight", char); h.Name = "MoonBox"; h.FillTransparency = 0.5; h.FillColor = Color3.new(0.5, 0.5, 1)
                end
            else if char:FindFirstChild("MoonBox") then char.MoonBox:Destroy() end end
            
            -- Tracers (Линии)
            if ESP_Enabled.Tracers then
                local rootP, onScreen = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    -- Тут можно добавить отрисовку линий через Drawing API, если инжектор поддерживает, 
                    -- но для стабильности на мобилках лучше использовать Highlight или
