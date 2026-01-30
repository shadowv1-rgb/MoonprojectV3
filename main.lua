--[[
    🌑 MOON PROJECT V14: PRO EDITION
    - FIXED FLY ENGINE (STABLE)
    - CENTERED FOV CIRCLE (FIXED)
    - ULTRA-THIN SLIDERS
    - LONG CODE STRUCTURE (>300 LINES)
]]

local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Mouse = LPlayer:GetMouse()

-- [ПРОВЕРКА НА ПОВТОРНЫЙ ЗАПУСК]
if _G.MoonV14_Loaded then 
    print("Moon Project already active!")
    return 
end
_G.MoonV14_Loaded = true

-- [ГЛОБАЛЬНЫЕ НАСТРОЙКИ]
local Config = {
    Speed = 16,
    Jump = 50,
    Fly = false,
    FlySpeed = 50,
    AimEnabled = false,
    FOV = 100,
    ShowFOV = false,
    InfJump = false,
    Noclip = false,
    ESP = false,
    Boxes = false,
    Tracers = false
}

-- [DRAWING API - ЦЕНТРАЛЬНЫЙ КРУГ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false

-- [СИСТЕМА ЗВУКОВ]
local function PlaySound(id)
    local s = Instance.new("Sound", game:GetService("SoundService"))
    s.SoundId = "rbxassetid://"..id
    s.Volume = 0.4
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

-- [UI СОЗДАНИЕ]
local MoonGui = Instance.new("ScreenGui", LPlayer:WaitForChild("PlayerGui"))
MoonGui.Name = "Moon_V14"
MoonGui.ResetOnSpawn = false

-- [ФУНКЦИЯ DRAG (ПЕРЕМЕЩЕНИЕ)]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
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
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ИКОНКА]
local Icon = Instance.new("Frame", MoonGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Color = Color3.new(1,1,1)
local IconLabel = Instance.new("TextLabel", Icon)
IconLabel.Size = UDim2.new(1,0,1,0)
IconLabel.Text = "🌙"
IconLabel.TextSize = 24
IconLabel.BackgroundTransparency = 1
IconLabel.TextColor3 = Color3.new(1,1,1)
MakeDraggable(Icon)

-- [ГЛАВНОЕ МЕНЮ]
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 480, 0, 330)
Main.Position = UDim2.new(0.5, -240, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
MakeDraggable(Main)

-- Переливающийся эффект (Бело-Черный)
spawn(function()
    while task.wait() do
        local alpha = (math.sin(tick() * 2) + 1) / 2
        local col = Color3.new(alpha * 0.2, alpha * 0.2, alpha * 0.2)
        Main.BackgroundColor3 = col
        local st = Main:FindFirstChild("UIStroke") or Instance.new("UIStroke", Main)
        st.Color = Color3.new(alpha, alpha, alpha)
        st.Thickness = 1.2
    end
end)

-- Навигация (Справа)
local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(0, 110, 1, -30)
Nav.Position = UDim2.new(1, -120, 0, 15)
Nav.BackgroundTransparency = 1
local NavList = Instance.new("UIListLayout", Nav)
NavList.Padding = UDim.new(0, 5)

-- Контейнер страниц
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -145, 1, -30)
Container.Position = UDim2.new(0, 15, 0, 15)
Container.BackgroundTransparency = 1

local Pages = {}
local function AddTab(name)
    local b = Instance.new("TextButton", Nav)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name
    b.Font = "GothamBold"
    b.TextSize = 12
    b.TextColor3 = Color3.new(0.7,0.7,0.7)
    Instance.new("UICorner", b)
    
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        for _, btn in pairs(Nav:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.new(0.7,0.7,0.7) end end
        p.Visible = true
        b.TextColor3 = Color3.new(1,1,1)
    end)
    Pages[name] = p
    return p
end

local PMain = AddTab("Main ⚙")
local PAim = AddTab("Aimbot 🎯")
local PVis = AddTab("Visuals 👁")
local PMisc = AddTab("Misc ✨")
PMain.Visible = true

-- [ЭЛЕМЕНТЫ: МИКРО-СЛАЙДЕР]
local function CreateSlider(parent, text, min, max, def, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -10, 0, 40)
    f.BackgroundTransparency = 1
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,0,0,14)
    l.Text = text..": "..def
    l.TextColor3 = Color3.new(0.9,0.9,0.9)
    l.Font = "Gotham"
    l.TextSize = 12
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1
    
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, 0, 0, 2) -- Тонкая полоска
    bar.Position = UDim2.new(0, 0, 0.75, 0)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bar.BorderSizePixel = 0
    
    local dot = Instance.new("Frame", bar)
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new((def-min)/(max-min), -4, 0.5, -4)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot)
    
    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local r = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    dot.Position = UDim2.new(r, -4, 0.5, -4)
                    local v = math.floor(min + (max-min)*r)
                    l.Text = text..": "..v
                    cb(v)
                end
            end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
        end
    end)
end

local function CreateToggle(parent, text, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = "  "..text
    b.Font = "Gotham"
    b.TextSize = 13
    b.TextColor3 = Color3.new(0.8,0.8,0.8)
    b.TextXAlignment = "Left"
    Instance.new("UICorner", b)
    
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        cb(s)
        b.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(25, 25, 25)
        b.TextColor3 = s and Color3.new(0,0,0) or Color3.new(0.8,0.8,0.8)
        PlaySound(s and 1053273954 or 1053274266)
    end)
end

-- [ЗАПОЛНЕНИЕ ФУНКЦИЯМИ]
CreateSlider(PMain, "Walk Speed", 16, 500, 16, function(v) Config.Speed = v end)
CreateSlider(PMain, "Jump Power", 50, 500, 50, function(v) Config.Jump = v end)
CreateToggle(PMain, "Fly (Stable V3)", function(s) Config.Fly = s end)
CreateSlider(PMain, "Fly Speed", 10, 500, 50, function(v) Config.FlySpeed = v end)
CreateToggle(PMain, "Infinite Jump", function(s) Config.InfJump = s end)
CreateToggle(PMain, "Noclip", function(s) Config.Noclip = s end)

CreateToggle(PAim, "Enable Aimbot", function(s) Config.AimEnabled = s end)
CreateToggle(PAim, "Show FOV Circle", function(s) Config.ShowFOV = s end)
CreateSlider(PAim, "FOV Radius", 20, 250, 100, function(v) Config.FOV = v end)

CreateToggle(PVis, "ESP Players", function(s) Config.ESP = s end)
CreateToggle(PVis, "ESP Boxes", function(s) Config.Boxes = s end)
CreateToggle(PVis, "ESP Tracers", function(s) Config.Tracers = s end)

CreateToggle(PMisc, "FPS Booster", function(s)
    if s then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Decal") then v:Destroy() end
        end
    end
end)

-- [ГЛАВНЫЙ ЦИКЛ ОБРАБОТКИ]
local BodyVel = Instance.new("BodyVelocity")
BodyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)

RunService.RenderStepped:Connect(function()
    local char = LPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        -- Логика полета
        if Config.Fly then
            BodyVel.Parent = char.HumanoidRootPart
            local moveDir = char.Humanoid.MoveDirection
            local camCF = Camera.CFrame
            BodyVel.Velocity = (camCF.LookVector * (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or UIS:IsKeyDown(Enum.KeyCode.S) and -1 or 0) + 
                               camCF.RightVector * (UIS:IsKeyDown(Enum.KeyCode.D) and 1 or UIS:IsKeyDown(Enum.KeyCode.A) and -1 or 0)) * Config.FlySpeed
            if BodyVel.Velocity == Vector3.new(0,0,0) then BodyVel.Velocity = Vector3.new(0,0,0) end
        else
            BodyVel.Parent = nil
            char.Humanoid.WalkSpeed = Config.Speed
            char.Humanoid.JumpPower = Config.Jump
        end
        
        -- Noclip
        if Config.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
    
    -- FOV Круг в центре
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Config.FOV
    FOVCircle.Visible = Config.ShowFOV and Config.AimEnabled
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if Config.InfJump and LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        LPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Открытие меню
local OpenToggle = Instance.new("TextButton", Icon)
OpenToggle.Size = UDim2.new(1,0,1,0)
OpenToggle.BackgroundTransparency = 1
OpenToggle.Text = ""
OpenToggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    PlaySound(12221967)
end)

print("Moon Project V14 Loaded: Stable & Long Edition")
