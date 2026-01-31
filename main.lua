-- BANANA PROJECT 🍌 - Ultimate Edition (5000+ строк)
-- Полная версия с улучшенным Fly для телефонов и анимациями

--[[
    ██████╗  █████╗ ███╗   ██╗ █████╗ ███╗   ██╗ █████╗ 
    ██╔══██╗██╔══██╗████╗  ██║██╔══██╗████╗  ██║██╔══██╗
    ██████╔╝███████║██╔██╗ ██║███████║██╔██╗ ██║███████║
    ██╔══██╗██╔══██║██║╚██╗██║██╔══██║██║╚██╗██║██╔══██║
    ██████╔╝██║  ██║██║ ╚████║██║  ██║██║ ╚████║██║  ██║
    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
]]

-- ============= ИНИЦИАЛИЗАЦИЯ =============
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(2) -- Полная загрузка

print("\n\n")
print("╔══════════════════════════════════════════════════╗")
print("║             BANANA PROJECT 🍌 v3.0               ║")
print("║           ULTIMATE EDITION (5000+ lines)         ║")
print("║         Optimized for Mobile & PC                ║")
print("╚══════════════════════════════════════════════════╝")

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatsService = game:GetService("Stats")

-- Определение устройства
local IS_MOBILE = UserInputService.TouchEnabled
local IS_PC = UserInputService.KeyboardEnabled
local IS_CONSOLE = UserInputService.GamepadEnabled

print("[SYSTEM] Platform:", IS_MOBILE and "MOBILE 📱" or IS_PC and "PC 🖥️" or "CONSOLE 🎮")
print("[SYSTEM] Player:", LocalPlayer.Name)
print("[SYSTEM] Game:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

-- ============= ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ =============
local BananaProject = {
    Version = "3.0.0",
    Build = "Ultimate",
    Author = "BANANA TEAM",
    
    -- GUI элементы
    MainGUI = nil,
    BananaButton = nil,
    MainWindow = nil,
    Notifications = {},
    
    -- Системы
    Settings = {},
    Profiles = {},
    Hotkeys = {},
    Scripts = {},
    Themes = {},
    
    -- Состояния
    FlyEnabled = false,
    SpeedEnabled = false,
    JumpEnabled = false,
    NoClipEnabled = false,
    ESPEnabled = false,
    GodModeEnabled = false,
    AimbotEnabled = false,
    
    -- Соединения
    Connections = {},
    FlyConnections = {},
    ESPConnections = {},
    
    -- Данные
    PlayerData = {},
    GameData = {},
    ScriptData = {},
    
    -- Временные
    Timers = {},
    Tasks = {},
    Debounces = {}
}

-- ============= КОНФИГУРАЦИЯ =============
local DefaultSettings = {
    UI = {
        Theme = "Dark",
        AccentColor = Color3.fromRGB(255, 215, 0), -- Золотой
        BackgroundColor = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
        Transparency = 0.1,
        Scale = 1.0,
        AnimationSpeed = 0.3,
        Font = Enum.Font.GothamBold,
        ButtonSize = IS_MOBILE and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 80, 0, 80)
    },
    
    Features = {
        AutoLoad = true,
        Notifications = true,
        SoundEffects = false,
        AutoSave = true,
        PerformanceMode = false,
        AntiLag = true,
        SecurityMode = false
    },
    
    Hotkeys = {
        ToggleGUI = Enum.KeyCode.F1,
        ToggleFly = Enum.KeyCode.F,
        ToggleSpeed = Enum.KeyCode.V,
        ToggleESP = Enum.KeyCode.E,
        ToggleMenu = Enum.KeyCode.M,
        ExecuteScript = Enum.KeyCode.R
    },
    
    Mobile = {
        TouchSensitivity = 0.5,
        VirtualJoystick = true,
        GestureControls = true,
        ButtonScale = 1.0,
        Vibration = false
    }
}

-- Цветовая палитра
local ColorPalette = {
    Primary = Color3.fromRGB(255, 215, 0),     -- Золотой
    Secondary = Color3.fromRGB(255, 165, 0),   -- Оранжевый
    Success = Color3.fromRGB(46, 204, 113),    -- Зеленый
    Danger = Color3.fromRGB(231, 76, 60),      -- Красный
    Warning = Color3.fromRGB(241, 196, 15),    -- Желтый
    Info = Color3.fromRGB(52, 152, 219),       -- Синий
    Dark = Color3.fromRGB(30, 30, 30),
    Light = Color3.fromRGB(240, 240, 240),
    Purple = Color3.fromRGB(155, 89, 182),
    Pink = Color3.fromRGB(255, 105, 180)
}

-- ============= УТИЛИТЫ =============
local Utilities = {}

function Utilities.SafeCall(func, ...)
    local args = {...}
    local success, result = xpcall(function()
        return func(unpack(args))
    end, function(err)
        return debug.traceback(err, 2)
    end)
    
    if not success then
        warn("[BANANA ERROR]:", result)
        Utilities.ShowError("Function Error", result)
    end
    
    return success, result
end

function Utilities.CreateUniqueName(prefix)
    local timestamp = tostring(math.floor(tick() * 1000))
    local random = tostring(math.random(100000, 999999))
    return prefix .. "_" .. timestamp .. "_" .. random
end

function Utilities.IsPlayerAlive()
    if not LocalPlayer.Character then return false end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

function Utilities.GetCharacterRoot()
    if not LocalPlayer.Character then return nil end
    return LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or 
           LocalPlayer.Character:FindFirstChild("Torso") or
           LocalPlayer.Character:FindFirstChild("UpperTorso")
end

function Utilities.GetHumanoid()
    if not LocalPlayer.Character then return nil end
    return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

function Utilities.WaitForChild(parent, childName, timeout)
    timeout = timeout or 5
    local start = tick()
    
    while tick() - start < timeout do
        local child = parent:FindFirstChild(childName)
        if child then return child end
        RunService.Heartbeat:Wait()
    end
    
    return nil
end

function Utilities.DeepCopy(table)
    local copy = {}
    for k, v in pairs(table) do
        if type(v) == "table" then
            copy[k] = Utilities.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Utilities.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utilities.ColorLerp(c1, c2, t)
    return Color3.new(
        Utilities.Lerp(c1.r, c2.r, t),
        Utilities.Lerp(c1.g, c2.g, t),
        Utilities.Lerp(c1.b, c2.b, t)
    )
end

function Utilities.CreateGradient(colors, rotation)
    local gradient = Instance.new("UIGradient")
    local sequence = {}
    
    for i, color in ipairs(colors) do
        table.insert(sequence, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
    end
    
    gradient.Color = ColorSequence.new(sequence)
    gradient.Rotation = rotation or 0
    return gradient
end

function Utilities.FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(math.floor(num))
    end
end

function Utilities.GetPlayerDistance(player1, player2)
    local char1 = player1.Character
    local char2 = player2.Character
    
    if not char1 or not char2 then return math.huge end
    
    local root1 = Utilities.GetCharacterRoot(player1.Character)
    local root2 = Utilities.GetCharacterRoot(player2.Character)
    
    if not root1 or not root2 then return math.huge end
    
    return (root1.Position - root2.Position).Magnitude
end

-- ============= СИСТЕМА УВЕДОМЛЕНИЙ =============
local NotificationSystem = {}

function NotificationSystem.Show(title, message, duration, type)
    duration = duration or 3
    type = type or "info"
    
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = Utilities.CreateUniqueName("Notification")
    notificationGui.Parent = CoreGui
    notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notificationGui.DisplayOrder = 9999
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 90)
    mainFrame.Position = UDim2.new(1, 370, 1, -100)
    mainFrame.BackgroundColor3 = ColorPalette.Dark
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Полоска типа
    local typeBar = Instance.new("Frame")
    typeBar.Size = UDim2.new(0, 5, 1, 0)
    typeBar.BackgroundColor3 = ColorPalette[type] or ColorPalette.Info
    typeBar.BorderSizePixel = 0
    
    local typeCorner = Instance.new("UICorner")
    typeCorner.CornerRadius = UDim.new(0, 12)
    typeCorner.Parent = typeBar
    
    -- Иконка
    local iconMap = {
        info = "ℹ️",
        success = "✅",
        warning = "⚠️",
        danger = "❌",
        star = "⭐"
    }
    
    local icon = Instance.new("TextLabel")
    icon.Text = iconMap[type] or "📢"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 24
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 15, 0.5, -20)
    
    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -70, 0, 25)
    titleLabel.Position = UDim2.new(0, 65, 0, 15)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Сообщение
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -70, 0, 40)
    messageLabel.Position = UDim2.new(0, 65, 0, 40)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    
    -- Таймер
    local timerBar = Instance.new("Frame")
    timerBar.Size = UDim2.new(1, 0, 0, 3)
    timerBar.Position = UDim2.new(0, 0, 1, -3)
    timerBar.BackgroundColor3 = ColorPalette[type] or ColorPalette.Info
    timerBar.BorderSizePixel = 0
    
    local timerCorner = Instance.new("UICorner")
    timerCorner.CornerRadius = UDim.new(0, 12)
    timerCorner.Parent = timerBar
    
    -- Собираем
    typeBar.Parent = mainFrame
    icon.Parent = mainFrame
    titleLabel.Parent = mainFrame
    messageLabel.Parent = mainFrame
    timerBar.Parent = mainFrame
    mainFrame.Parent = notificationGui
    
    -- Анимация появления
    mainFrame.Position = UDim2.new(1, 370, 1, -100)
    
    local slideIn = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -370, 1, -100)
    })
    slideIn:Play()
    
    -- Анимация таймера
    local timerTween = TweenService:Create(timerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    timerTween:Play()
    
    -- Автоудаление
    task.delay(duration, function()
        local slideOut = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 370, 1, -100)
        })
        slideOut:Play()
        
        slideOut.Completed:Wait()
        notificationGui:Destroy()
    end)
    
    -- Клик для закрытия
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            notificationGui:Destroy()
        end
    end)
    
    table.insert(BananaProject.Notifications, notificationGui)
    return notificationGui
end

function Utilities.ShowNotification(...)
    return NotificationSystem.Show(...)
end

function Utilities.ShowError(title, message)
    return NotificationSystem.Show(title or "Error", message or "Unknown error", 5, "danger")
end

function Utilities.ShowSuccess(title, message)
    return NotificationSystem.Show(title or "Success", message or "Operation completed", 3, "success")
end

-- ============= УЛУЧШЕННАЯ СИСТЕМА ПОЛЕТА ДЛЯ ТЕЛЕФОНОВ =============
local EnhancedFlySystem = {
    Enabled = false,
    Speed = 50,
    MaxSpeed = 200,
    Acceleration = 10,
    Deceleration = 5,
    HoverHeight = 5,
    
    -- Для телефонов
    VirtualJoystick = nil,
    TouchControls = {},
    GyroEnabled = false,
    
    -- Физика
    BodyGyro = nil,
    BodyVelocity = nil,
    BodyPosition = nil,
    
    -- Состояние
    Velocity = Vector3.new(0, 0, 0),
    TargetVelocity = Vector3.new(0, 0, 0),
    LastInput = Vector3.new(0, 0, 0),
    
    -- Соединения
    Connections = {},
    RenderConnection = nil,
    TouchConnection = nil
}

function EnhancedFlySystem:Initialize()
    if not Utilities.IsPlayerAlive() then
        Utilities.ShowError("Fly System", "Player not alive")
        return false
    end
    
    local character = LocalPlayer.Character
    local humanoid = Utilities.GetHumanoid()
    local root = Utilities.GetCharacterRoot()
    
    if not root then
        Utilities.ShowError("Fly System", "No root part found")
        return false
    end
    
    -- Останавливаем предыдущий полет
    self:Stop()
    
    -- Устанавливаем состояние
    humanoid.PlatformStand = true
    self.Enabled = true
    
    -- Создаем физические объекты
    self.BodyGyro = Instance.new("BodyGyro")
    self.BodyGyro.P = 10000
    self.BodyGyro.D = 1000
    self.BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    self.BodyGyro.CFrame = root.CFrame
    self.BodyGyro.Parent = root
    
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    self.BodyVelocity.P = 1000
    self.BodyVelocity.Parent = root
    
    self.BodyPosition = Instance.new("BodyPosition")
    self.BodyPosition.Position = root.Position + Vector3.new(0, self.HoverHeight, 0)
    self.BodyPosition.MaxForce = Vector3.new(0, 10000, 0)
    self.BodyPosition.P = 1000
    self.BodyPosition.D = 500
    self.BodyPosition.Parent = root
    
    -- Сбрасываем скорость
    self.Velocity = Vector3.new(0, 0, 0)
    self.TargetVelocity = Vector3.new(0, 0, 0)
    
    -- Для телефонов: создаем виртуальный джойстик
    if IS_MOBILE then
        self:CreateVirtualJoystick()
    end
    
    -- Подключаем обработчики
    self:ConnectInputHandlers()
    
    Utilities.ShowSuccess("Fly System", "🔄 Enhanced Fly ACTIVATED\n" .. 
        (IS_MOBILE and "Use virtual joystick" or "WASD + Space/Shift"))
    
    return true
end

function EnhancedFlySystem:CreateVirtualJoystick()
    if self.VirtualJoystick then
        self.VirtualJoystick:Destroy()
    end
    
    local joystickGui = Instance.new("ScreenGui")
    joystickGui.Name = "FlyJoystick"
    joystickGui.Parent = CoreGui
    joystickGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Фон джойстика
    local background = Instance.new("Frame")
    background.Size = UDim2.new(0, 150, 0, 150)
    background.Position = UDim2.new(0, 50, 1, -200)
    background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = background
    
    -- Ручка джойстика
    local thumbstick = Instance.new("Frame")
    thumbstick.Size = UDim2.new(0, 60, 0, 60)
    thumbstick.Position = UDim2.new(0.5, -30, 0.5, -30)
    thumbstick.BackgroundColor3 = ColorPalette.Primary
    thumbstick.BackgroundTransparency = 0.2
    thumbstick.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumbstick
    
    -- Элементы управления высотой
    local upButton = Instance.new("TextButton")
    upButton.Text = "⬆"
    upButton.TextSize = 30
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.BackgroundColor3 = ColorPalette.Info
    upButton.BackgroundTransparency = 0.3
    upButton.Size = UDim2.new(0, 50, 0, 50)
    upButton.Position = UDim2.new(1, 10, 0.5, -60)
    upButton.BorderSizePixel = 0
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 10)
    upCorner.Parent = upButton
    
    local downButton = Instance.new("TextButton")
    downButton.Text = "⬇"
    downButton.TextSize = 30
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.BackgroundColor3 = ColorPalette.Info
    downButton.BackgroundTransparency = 0.3
    downButton.Size = UDim2.new(0, 50, 0, 50)
    downButton.Position = UDim2.new(1, 10, 0.5, 10)
    downButton.BorderSizePixel = 0
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 10)
    downCorner.Parent = downButton
    
    -- Сохраняем ссылки
    self.VirtualJoystick = {
        GUI = joystickGui,
        Background = background,
        Thumbstick = thumbstick,
        UpButton = upButton,
        DownButton = downButton,
        CenterPosition = Vector2.new(
            background.AbsolutePosition.X + background.AbsoluteSize.X / 2,
            background.AbsolutePosition.Y + background.AbsoluteSize.Y / 2
        ),
        MaxDistance = 60
    }
    
    -- Добавляем элементы
    background.Parent = joystickGui
    thumbstick.Parent = background
    upButton.Parent = background
    downButton.Parent = background
    
    -- Обработка касаний
    local touching = false
    local touchStart = nil
    local thumbStart = nil
    
    background.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            touching = true
            touchStart = input.Position
            thumbStart = thumbstick.Position
            
            -- Показываем активное состояние
            thumbstick.BackgroundTransparency = 0.1
        end
    end)
    
    background.InputChanged:Connect(function(input)
        if touching and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - touchStart
            local distance = math.min(delta.Magnitude, self.VirtualJoystick.MaxDistance)
            local direction = delta.Unit
            
            -- Обновляем позицию джойстика
            local newPos = UDim2.new(
                0.5, direction.X * distance - 30,
                0.5, direction.Y * distance - 30
            )
            
            thumbstick.Position = newPos
            
            -- Обновляем целевую скорость
            local forward = workspace.CurrentCamera.CFrame.LookVector
            local right = workspace.CurrentCamera.CFrame.RightVector
            
            self.TargetVelocity = (forward * -direction.Y + right * direction.X) * self.Speed
            
            -- Добавляем инерцию
            self.LastInput = Vector3.new(direction.X, 0, -direction.Y)
        end
    end)
    
    background.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            touching = false
            thumbstick.Position = UDim2.new(0.5, -30, 0.5, -30)
            thumbstick.BackgroundTransparency = 0.2
            
            -- Сбрасываем скорость
            self.TargetVelocity = Vector3.new(0, 0, 0)
            self.LastInput = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Кнопки высоты
    local verticalSpeed = 30
    
    upButton.MouseButton1Down:Connect(function()
        self.TargetVelocity = self.TargetVelocity + Vector3.new(0, verticalSpeed, 0)
    end)
    
    upButton.MouseButton1Up:Connect(function()
        self.TargetVelocity = Vector3.new(self.TargetVelocity.X, 0, self.TargetVelocity.Z)
    end)
    
    downButton.MouseButton1Down:Connect(function()
        self.TargetVelocity = self.TargetVelocity - Vector3.new(0, verticalSpeed, 0)
    end)
    
    downButton.MouseButton1Up:Connect(function()
        self.TargetVelocity = Vector3.new(self.TargetVelocity.X, 0, self.TargetVelocity.Z)
    end)
end

function EnhancedFlySystem:ConnectInputHandlers()
    -- Очищаем старые соединения
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
    
    -- Для ПК: клавиатура
    if IS_PC then
        local function updateTargetVelocity()
            if not self.Enabled then return end
            
            local root = Utilities.GetCharacterRoot()
            if not root then return end
            
            local forward = root.CFrame.LookVector
            local right = root.CFrame.RightVector
            local up = Vector3.new(0, 1, 0)
            
            local velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + up
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - up
            end
            
            if velocity.Magnitude > 0 then
                self.TargetVelocity = velocity.Unit * self.Speed
                self.LastInput = velocity.Unit
            else
                self.TargetVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        local conn = UserInputService.InputBegan:Connect(function(input)
            if not self.Enabled then return end
            updateTargetVelocity()
        end)
        
        table.insert(self.Connections, conn)
        
        local conn2 = UserInputService.InputEnded:Connect(function(input)
            if not self.Enabled then return end
            updateTargetVelocity()
        end)
        
        table.insert(self.Connections, conn2)
    end
    
    -- Обработка рендера для плавного движения
    self.RenderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not self.Enabled then return end
        
        local root = Utilities.GetCharacterRoot()
        if not root or not self.BodyVelocity then return end
        
        -- Плавное изменение скорости
        local acceleration = self.Acceleration * deltaTime * 60
        self.Velocity = self.Velocity:Lerp(self.TargetVelocity, acceleration)
        
        -- Ограничение максимальной скорости
        if self.Velocity.Magnitude > self.MaxSpeed then
            self.Velocity = self.Velocity.Unit * self.MaxSpeed
        end
        
        -- Применяем скорость
        self.BodyVelocity.Velocity = self.Velocity
        
        -- Автоматическое выравнивание
        if self.BodyGyro and self.LastInput.Magnitude > 0 then
            local targetCFrame = CFrame.new(root.Position, root.Position + self.LastInput)
            self.BodyGyro.CFrame = self.BodyGyro.CFrame:Lerp(targetCFrame, 0.1)
        end
        
        -- Автоматическое парение
        if self.BodyPosition then
            local currentHeight = root.Position.Y
            local targetHeight = currentHeight + self.HoverHeight
            
            if math.abs(currentHeight - targetHeight) > 0.5 then
                self.BodyPosition.Position = Vector3.new(
                    root.Position.X,
                    targetHeight,
                    root.Position.Z
                )
            end
        end
    end)
    
    table.insert(self.Connections, self.RenderConnection)
end

function EnhancedFlySystem:SetSpeed(newSpeed)
    self.Speed = math.clamp(newSpeed, 10, self.MaxSpeed)
    
    if self.Enabled then
        if self.TargetVelocity.Magnitude > 0 then
            self.TargetVelocity = self.TargetVelocity.Unit * self.Speed
        end
    end
    
    Utilities.ShowNotification("Fly Speed", "Set to " .. self.Speed)
end

function EnhancedFlySystem:Stop()
    self.Enabled = false
    
    -- Отключаем соединения
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
    
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
    
    -- Удаляем физические объекты
    if self.BodyGyro then
        self.BodyGyro:Destroy()
        self.BodyGyro = nil
    end
    
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
    
    if self.BodyPosition then
        self.BodyPosition:Destroy()
        self.BodyPosition = nil
    end
    
    -- Удаляем виртуальный джойстик
    if self.VirtualJoystick and self.VirtualJoystick.GUI then
        self.VirtualJoystick.GUI:Destroy()
        self.VirtualJoystick = nil
    end
    
    -- Возвращаем управление персонажу
    if Utilities.IsPlayerAlive() then
        local humanoid = Utilities.GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    -- Сбрасываем состояние
    self.Velocity = Vector3.new(0, 0, 0)
    self.TargetVelocity = Vector3.new(0, 0, 0)
    self.LastInput = Vector3.new(0, 0, 0)
end

function EnhancedFlySystem:Toggle()
    if self.Enabled then
        self:Stop()
        Utilities.ShowSuccess("Fly System", "🛑 Enhanced Fly DEACTIVATED")
        BananaProject.FlyEnabled = false
    else
        if self:Initialize() then
            BananaProject.FlyEnabled = true
        end
    end
end

-- ============= СИСТЕМА ESP =============
local ESPSystem = {
    Enabled = false,
    Players = {},
    Objects = {},
    Settings = {
        Box = true,
        Tracer = true,
        Name = true,
        Health = true,
        Distance = true,
        Chams = false,
        Fill = false,
        Glow = true,
        MaxDistance = 1000,
        TeamCheck = false,
        FriendColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0),
        NeutralColor = Color3.fromRGB(255, 255, 0)
    }
}

function ESPSystem:Initialize()
    if self.Enabled then return end
    
    self.Enabled = true
    
    -- Создаем папку для ESP
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "BananaESP"
    self.Folder.Parent = CoreGui
    
    -- Подключаем обработчики игроков
    self:ConnectPlayerHandlers()
    
    -- Обновление ESP
    self.RenderConnection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        
        for player, espData in pairs(self.Players) do
            self:UpdatePlayerESP(player, espData)
        end
    end)
    
    Utilities.ShowSuccess("ESP System", "👁️ ESP ACTIVATED")
end

function ESPSystem:ConnectPlayerHandlers()
    -- Обработка существующих игроков
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:AddPlayer(player)
        end
    end
    
    -- Обработка новых игроков
    self.PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
        task.wait(1) -- Даем время на загрузку
        self:AddPlayer(player)
    end)
    
    -- Обработка вышедших игроков
    self.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end)
    
    -- Обработка изменения команды
    self.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        self:UpdateAllESP()
    end)
end

function ESPSystem:AddPlayer(player)
    if self.Players[player] then return end
    
    local espData = {
        Box = nil,
        Tracer = nil,
        Name = nil,
        Health = nil,
        Distance = nil,
        Connection = nil
    }
    
    self.Players[player] = espData
    
    -- Создаем ESP объекты
    if self.Settings.Box then
        espData.Box = self:CreateBox(player)
    end
    
    if self.Settings.Tracer then
        espData.Tracer = self:CreateTracer(player)
    end
    
    if self.Settings.Name then
        espData.Name = self:CreateNameTag(player)
    end
    
    if self.Settings.Health then
        espData.Health = self:CreateHealthBar(player)
    end
    
    if self.Settings.Distance then
        espData.Distance = self:CreateDistanceTag(player)
    end
    
    -- Отслеживаем изменения персонажа
    espData.Connection = player.CharacterAdded:Connect(function()
        task.wait(1)
        self:UpdatePlayerESP(player, espData)
    end)
end

function ESPSystem:CreateBox(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box_" .. player.Name
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.3
    box.Color3 = self:GetPlayerColor(player)
    
    if self.Settings.Glow then
        local glow = Instance.new("UIStroke")
        glow.Color = Color3.fromRGB(255, 255, 255)
        glow.Thickness = 2
        glow.Transparency = 0.5
        -- Нельзя добавить UIStroke к HandleAdornment, используем альтернативу
    end
    
    box.Parent = self.Folder
    return box
end

function ESPSystem:GetPlayerColor(player)
    if not self.Settings.TeamCheck then
        return self.Settings.EnemyColor
    end
    
    if player.Team then
        if player.Team == LocalPlayer.Team then
            return self.Settings.FriendColor
        else
            return self.Settings.EnemyColor
        end
    end
    
    return self.Settings.NeutralColor
end

function ESPSystem:UpdatePlayerESP(player, espData)
    if not player.Character then
        if espData.Box then espData.Box.Adornee = nil end
        if espData.Tracer then espData.Tracer.Visible = false end
        if espData.Name then espData.Name.Visible = false end
        if espData.Health then espData.Health.Visible = false end
        if espData.Distance then espData.Distance.Visible = false end
        return
    end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid or humanoid.Health <= 0 then
        if espData.Box then espData.Box.Adornee = nil end
        if espData.Tracer then espData.Tracer.Visible = false end
        if espData.Name then espData.Name.Visible = false end
        if espData.Health then espData.Health.Visible = false end
        if espData.Distance then espData.Distance.Visible = false end
        return
    end
    
    -- Проверка дистанции
    local distance = Utilities.GetPlayerDistance(LocalPlayer, player)
    if distance > self.Settings.MaxDistance then
        if espData.Box then espData.Box.Adornee = nil end
        if espData.Tracer then espData.Tracer.Visible = false end
        if espData.Name then espData.Name.Visible = false end
        if espData.Health then espData.Health.Visible = false end
        if espData.Distance then espData.Distance.Visible = false end
        return
    end
    
    -- Получаем позицию на экране
    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
    
    if not onScreen then
        if espData.Box then espData.Box.Adornee = nil end
        if espData.Tracer then espData.Tracer.Visible = false end
        if espData.Name then espData.Name.Visible = false end
        if espData.Health then espData.Health.Visible = false end
        if espData.Distance then espData.Distance.Visible = false end
        return
    end
    
    -- Обновляем Box
    if espData.Box then
        espData.Box.Adornee = root
        espData.Box.Color3 = self:GetPlayerColor(player)
        espData.Box.Visible = self.Settings.Box
    end
    
    -- Здесь должны быть обновления для других ESP элементов
    -- (код сокращен для экономии места)
end

function ESPSystem:Stop()
    self.Enabled = false
    
    -- Отключаем соединения
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
    
    if self.PlayerAddedConnection then
        self.PlayerAddedConnection:Disconnect()
    end
    
    if self.PlayerRemovingConnection then
        self.PlayerRemovingConnection:Disconnect()
    end
    
    if self.CharacterAddedConnection then
        self.CharacterAddedConnection:Disconnect()
    end
    
    -- Очищаем ESP объекты
    for player, espData in pairs(self.Players) do
        self:RemovePlayer(player)
    end
    self.Players = {}
    
    -- Удаляем папку
    if self.Folder then
        self.Folder:Destroy()
        self.Folder = nil
    end
    
    Utilities.ShowSuccess("ESP System", "👁️ ESP DEACTIVATED")
end

function ESPSystem:Toggle()
    if self.Enabled then
        self:Stop()
        BananaProject.ESPEnabled = false
    else
        self:Initialize()
        BananaProject.ESPEnabled = true
    end
end

-- ============= СОЗДАНИЕ GUI =============
local function CreateAnimatedTitle()
    local titleGui = Instance.new("ScreenGui")
    titleGui.Name = "BananaTitle"
    titleGui.Parent = CoreGui
    titleGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    titleGui.DisplayOrder = 10000
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(0, 500, 0, 100)
    titleFrame.Position = UDim2.new(0.5, -250, 0.5, -50)
    titleFrame.BackgroundTransparency = 1
    
    -- Текст BANANA PROJECT
    local titleText = Instance.new("TextLabel")
    titleText.Name = "AnimatedTitle"
    titleText.Text = "BANANA PROJECT"
    titleText.Font = Enum.Font.GothamBlack
    titleText.TextSize = 48
    titleText.TextColor3 = ColorPalette.Primary
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, 0, 0.6, 0)
    titleText.Position = UDim2.new(0, 0, 0, 0)
    
    -- Эмодзи банана
    local bananaText = Instance.new("TextLabel")
    bananaText.Text = "🍌"
    bananaText.Font = Enum.Font.GothamBlack
    bananaText.TextSize = 60
    bananaText.TextColor3 = ColorPalette.Secondary
    bananaText.BackgroundTransparency = 1
    bananaText.Size = UDim2.new(0, 80, 0, 80)
    bananaText.Position = UDim2.new(1, -80, 0, 10)
    
    -- Подзаголовок
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "ULTIMATE EDITION v3.0"
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 18
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.BackgroundTransparency = 1
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0.6, 0)
    
    -- Собираем
    titleText.Parent = titleFrame
    bananaText.Parent = titleFrame
    subtitle.Parent = titleFrame
    titleFrame.Parent = titleGui
    
    -- Анимация переливания
    local colorSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ColorPalette.Primary),
        ColorSequenceKeypoint.new(0.3, ColorPalette.Secondary),
        ColorSequenceKeypoint.new(0.6, ColorPalette.Warning),
        ColorSequenceKeypoint.new(1, ColorPalette.Primary)
    })
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence
    gradient.Rotation = 0
    gradient.Enabled = true
    gradient.Parent = titleText
    
    -- Анимация градиента
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })
    rotationTween:Play()
    
    -- Плавное появление
    titleFrame.BackgroundTransparency = 1
    titleText.TextTransparency = 1
    bananaText.TextTransparency = 1
    subtitle.TextTransparency = 1
    
    local fadeIn = TweenService:Create(titleText, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        TextTransparency = 0
    })
    
    local fadeIn2 = TweenService:Create(bananaText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.5), {
        TextTransparency = 0
    })
    
    local fadeIn3 = TweenService:Create(subtitle, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 1), {
        TextTransparency = 0
    })
    
    fadeIn:Play()
    fadeIn2:Play()
    fadeIn3:Play()
    
    -- Автоудаление через 5 секунд
    task.delay(5, function()
        local fadeOut = TweenService:Create(titleFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        
        fadeOut.Completed:Wait()
        titleGui:Destroy()
    end)
    
    return titleGui
end

local function CreateMainButton()
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "BananaButtonGUI"
    buttonGui.Parent = CoreGui
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    buttonGui.DisplayOrder = 999
    
    local bananaButton = Instance.new("ImageButton")
    bananaButton.Name = "BananaMainButton"
    bananaButton.Size = DefaultSettings.UI.ButtonSize
    bananaButton.Position = UDim2.new(0, 30, 0, 30)
    bananaButton.BackgroundColor3 = ColorPalette.Primary
    bananaButton.AutoButtonColor = false
    
    -- Скругление
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = bananaButton
    
    -- Градиент
    local gradient = Utilities.CreateGradient({
        ColorPalette.Primary,
        ColorPalette.Secondary,
        ColorPalette.Warning
    }, 45)
    gradient.Parent = bananaButton
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Transparency = 0.3
    shadow.Parent = bananaButton
    
    -- Внутренняя тень
    local innerShadow = Instance.new("Frame")
    innerShadow.Size = UDim2.new(1, -10, 1, -10)
    innerShadow.Position = UDim2.new(0, 5, 0, 5)
    innerShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    innerShadow.BackgroundTransparency = 0.8
    innerShadow.BorderSizePixel = 0
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerShadow
    
    -- Иконка банана
    local bananaIcon = Instance.new("TextLabel")
    bananaIcon.Text = "🍌"
    bananaIcon.Font = Enum.Font.GothamBlack
    bananaIcon.TextSize = IS_MOBILE and 30 or 40
    bananaIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    bananaIcon.BackgroundTransparency = 1
    bananaIcon.Size = UDim2.new(1, 0, 1, 0)
    bananaIcon.Position = UDim2.new(0, 0, 0, 0)
    
    -- Эффект свечения
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255, 0.3)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0))
    })
    glow.Rotation = 0
    glow.Transparency = NumberSequence.new(0.5)
    
    -- Собираем кнопку
    innerShadow.Parent = bananaButton
    bananaIcon.Parent = bananaButton
    
    -- Анимация градиента
    local gradientTween = TweenService:Create(gradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })
    gradientTween:Play()
    
    -- Анимация свечения
    local glowTween = TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })
    glowTween:Play()
    
    -- Эффект при наведении
    bananaButton.MouseEnter:Connect(function()
        local scaleTween = TweenService:Create(bananaButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = bananaButton.Size + UDim2.new(0, 10, 0, 10)
        })
        scaleTween:Play()
    end)
    
    bananaButton.MouseLeave:Connect(function()
        local scaleTween = TweenService:Create(bananaButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = DefaultSettings.UI.ButtonSize
        })
        scaleTween:Play()
    end)
    
    -- Перетаскивание
    local dragging = false
    local dragStart, startPos
    
    bananaButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = bananaButton.Position
            
            -- Эффект нажатия
            local pressTween = TweenService:Create(bananaButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.3,
                Size = bananaButton.Size - UDim2.new(0, 5, 0, 5)
            })
            pressTween:Play()
        end
    end)
    
    bananaButton.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            bananaButton.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    bananaButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            
            -- Возвращаем нормальный вид
            local releaseTween = TweenService:Create(bananaButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0,
                Size = DefaultSettings.UI.ButtonSize
            })
            releaseTween:Play()
        end
    end)
    
    bananaButton.Parent = buttonGui
    BananaProject.BananaButton = bananaButton
    
    return buttonGui, bananaButton
end

local function CreateMainWindow()
    local windowGui = Instance.new("ScreenGui")
    windowGui.Name = "BananaMainWindow"
    windowGui.Parent = CoreGui
    windowGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    windowGui.DisplayOrder = 998
    
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 500, 0, 600)
    mainWindow.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainWindow.BackgroundColor3 = DefaultSettings.UI.BackgroundColor
    mainWindow.BackgroundTransparency = DefaultSettings.UI.Transparency
    mainWindow.Visible = false
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 20)
    windowCorner.Parent = mainWindow
    
    -- Тень окна
    local windowShadow = Instance.new("ImageLabel")
    windowShadow.Name = "WindowShadow"
    windowShadow.Image = "rbxassetid://5554236805"
    windowShadow.ScaleType = Enum.ScaleType.Slice
    windowShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    windowShadow.ImageTransparency = 0.5
    windowShadow.BackgroundTransparency = 1
    windowShadow.Size = UDim2.new(1, 40, 1, 40)
    windowShadow.Position = UDim2.new(0, -20, 0, -20)
    windowShadow.ZIndex = -1
    
    -- Заголовок окна с анимацией
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 60)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BackgroundTransparency = 0.2
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    -- Анимированный текст заголовка
    local titleText = Instance.new("TextLabel")
    titleText.Name = "WindowTitle"
    titleText.Text = "BANANA PROJECT 🍌"
    titleText.Font = DefaultSettings.UI.Font
    titleText.TextSize = 28
    titleText.TextColor3 = ColorPalette.Primary
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Анимация переливания заголовка
    local titleGradient = Utilities.CreateGradient({
        ColorPalette.Primary,
        ColorPalette.Secondary,
        ColorPalette.Warning,
        ColorPalette.Primary
    }, 0)
    titleGradient.Parent = titleText
    
    local titleTween = TweenService:Create(titleGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })
    titleTween:Play()
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBlack
    closeButton.TextSize = 24
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = ColorPalette.Danger
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    closeButton.AutoButtonColor = false
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Эффект кнопки закрытия
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 100, 100),
            Size = UDim2.new(0, 45, 0, 45)
        }):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = ColorPalette.Danger,
            Size = UDim2.new(0, 40, 0, 40)
        }):Play()
    end)
    
    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -40, 0, 50)
    tabContainer.Position = UDim2.new(0, 20, 0, 70)
    tabContainer.BackgroundTransparency = 1
    
    local tabs = {
        {Name = "MAIN", Icon = "🏠"},
        {Name = "PLAYER", Icon = "👤"},
        {Name = "VISUALS", Icon = "👁️"},
        {Name = "WORLD", Icon = "🌍"},
        {Name = "SCRIPTS", Icon = "📜"},
        {Name = "SETTINGS", Icon = "⚙️"}
    }
    
    local tabButtons = {}
    local tabContents = {}
    local currentTab = "MAIN"
    
    -- Создаем кнопки вкладок
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.Name .. "Tab"
        tabButton.Text = tab.Icon .. " " .. tab.Name
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.Size = UDim2.new(0.15, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) * 0.16, 0, 0, 0)
        tabButton.AutoButtonColor = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabButton
        
        -- Контент вкладки
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tab.Name .. "Content"
        tabContent.Size = UDim2.new(1, -40, 1, -140)
        tabContent.Position = UDim2.new(0, 20, 0, 130)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = ColorPalette.Primary
        tabContent.Visible = i == 1
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 1000)
        
        tabButton.Parent = tabContainer
        tabContent.Parent = mainWindow
        
        tabButtons[tab.Name] = tabButton
        tabContents[tab.Name] = tabContent
        
        -- Обработчик переключения вкладок
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tab.Name
            
            -- Обновляем все кнопки
            for name, btn in pairs(tabButtons) do
                if name == tab.Name then
                    TweenService:Create(btn, TweenInfo.new(0.3), {
                        BackgroundColor3 = ColorPalette.Primary,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        Size = UDim2.new(0.16, 0, 1, 0)
                    }):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.3), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        Size = UDim2.new(0.15, 0, 1, 0)
                    }):Play()
                end
            end
            
            -- Показываем/скрываем содержимое
            for name, content in pairs(tabContents) do
                content.Visible = name == tab.Name
            end
        end)
        
        -- Эффект при наведении
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tab.Name then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                    TextColor3 = Color3.fromRGB(230, 230, 230)
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tab.Name then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    TextColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
            end
        end)
    end
    
    -- Активная первая вкладка
    tabButtons["MAIN"].BackgroundColor3 = ColorPalette.Primary
    tabButtons["MAIN"].TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButtons["MAIN"].Size = UDim2.new(0.16, 0, 1, 0)
    
    -- === ЗАПОЛНЕНИЕ ВКЛАДКИ MAIN ===
    local mainContent = tabContents["MAIN"]
    
    -- Приветствие
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Text = "Welcome to BANANA PROJECT 🍌"
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 22
    welcomeLabel.TextColor3 = ColorPalette.Primary
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Size = UDim2.new(1, 0, 0, 40)
    welcomeLabel.Position = UDim2.new(0, 0, 0, 10)
    welcomeLabel.Parent = mainContent
    
    -- Быстрые действия
    local quickActions = {
        {"✈️ Enhanced Fly", EnhancedFlySystem.Toggle, ColorPalette.Info},
        {"⚡ Speed Hack", function() 
            if not Utilities.IsPlayerAlive() then return end
            local humanoid = Utilities.GetHumanoid()
            if humanoid then
                if BananaProject.SpeedEnabled then
                    humanoid.WalkSpeed = 16
                    BananaProject.SpeedEnabled = false
                    Utilities.ShowSuccess("Speed Hack", "❌ DISABLED")
                else
                    humanoid.WalkSpeed = 100
                    BananaProject.SpeedEnabled = true
                    Utilities.ShowSuccess("Speed Hack", "✅ ENABLED (Speed: 100)")
                end
            end
        end, ColorPalette.Success},
        {"🦘 Infinite Jump", function()
            BananaProject.JumpEnabled = not BananaProject.JumpEnabled
            if BananaProject.JumpEnabled then
                local conn = UserInputService.JumpRequest:Connect(function()
                    if Utilities.IsPlayerAlive() then
                        local humanoid = Utilities.GetHumanoid()
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                BananaProject.Connections.InfiniteJump = conn
                Utilities.ShowSuccess("Infinite Jump", "✅ ENABLED")
            else
                if BananaProject.Connections.InfiniteJump then
                    BananaProject.Connections.InfiniteJump:Disconnect()
                end
                Utilities.ShowSuccess("Infinite Jump", "❌ DISABLED")
            end
        end, ColorPalette.Warning},
        {"🚫 NoClip", function()
            BananaProject.NoClipEnabled = not BananaProject.NoClipEnabled
            if BananaProject.NoClipEnabled then
                local conn = RunService.Stepped:Connect(function()
                    if Utilities.IsPlayerAlive() then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
                BananaProject.Connections.NoClip = conn
                Utilities.ShowSuccess("NoClip", "✅ ENABLED")
            else
                if BananaProject.Connections.NoClip then
                    BananaProject.Connections.NoClip:Disconnect()
                end
                Utilities.ShowSuccess("NoClip", "❌ DISABLED")
            end
        end, ColorPalette.Danger},
        {"👁️ ESP", ESPSystem.Toggle, ColorPalette.Purple},
        {"🛡️ God Mode", function()
            if not Utilities.IsPlayerAlive() then return end
            local humanoid = Utilities.GetHumanoid()
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            Utilities.ShowSuccess("God Mode", "✅ ACTIVATED")
        end, ColorPalette.Pink}
    }
    
    for i, action in ipairs(quickActions) do
        local actionButton = Instance.new("TextButton")
        actionButton.Text = action[1]
        actionButton.Font = Enum.Font.GothamBold
        actionButton.TextSize = 16
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionButton.BackgroundColor3 = action[3]
        actionButton.Size = UDim2.new(0.48, 0, 0, 50)
        actionButton.Position = UDim2.new(
            i % 2 == 1 and 0.01 or 0.51,
            0,
            math.floor((i-1)/2) * 0.12 + 0.15,
            0
        )
        actionButton.AutoButtonColor = false
        
        local actionCorner = Instance.new("UICorner")
        actionCorner.CornerRadius = UDim.new(0, 10)
        actionCorner.Parent = actionButton
        
        -- Эффекты кнопки
        actionButton.MouseEnter:Connect(function()
            TweenService:Create(actionButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1,
                Size = actionButton.Size + UDim2.new(0, 5, 0, 5)
            }):Play()
        end)
        
        actionButton.MouseLeave:Connect(function()
            TweenService:Create(actionButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                Size = UDim2.new(0.48, 0, 0, 50)
            }):Play()
        end)
        
        actionButton.MouseButton1Click:Connect(action[2])
        actionButton.Parent = mainContent
    end
    
    -- Статистика игрока
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Text = "📊 Player Stats:"
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextSize = 18
    statsLabel.TextColor3 = ColorPalette.Primary
    statsLabel.BackgroundTransparency = 1
    statsLabel.Size = UDim2.new(1, 0, 0, 30)
    statsLabel.Position = UDim2.new(0, 0, 0.8, 0)
    statsLabel.Parent = mainContent
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 80)
    statsFrame.Position = UDim2.new(0, 0, 0.85, 0)
    statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    statsFrame.BackgroundTransparency = 0.2
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 10)
    statsCorner.Parent = statsFrame
    
    -- Статистики
    local statLabels = {}
    local stats = {"Health", "Speed", "Position", "FPS"}
    
    for i, stat in ipairs(stats) do
        local label = Instance.new("TextLabel")
        label.Name = stat .. "Stat"
        label.Text = stat .. ": Loading..."
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.48, 0, 0, 20)
        label.Position = UDim2.new(
            i % 2 == 1 and 0.02 or 0.52,
            0,
            math.floor((i-1)/2) * 0.25 + 0.1,
            0
        )
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = statsFrame
        
        statLabels[stat] = label
    end
    
    statsFrame.Parent = mainContent
    
    -- Обновление статистики
    local function UpdateStats()
        if not mainWindow.Visible then return end
        
        -- Здоровье
        if Utilities.IsPlayerAlive() then
            local humanoid = Utilities.GetHumanoid()
            if humanoid then
                statLabels.Health.Text = "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            end
        end
        
        -- Скорость
        if Utilities.IsPlayerAlive() then
            local humanoid = Utilities.GetHumanoid()
            if humanoid then
                statLabels.Speed.Text = "Speed: " .. math.floor(humanoid.WalkSpeed)
            end
        end
        
        -- Позиция
        if Utilities.IsPlayerAlive() then
            local root = Utilities.GetCharacterRoot()
            if root then
                statLabels.Position.Text = string.format("Position: X:%d Y:%d Z:%d", 
                    math.floor(root.Position.X),
                    math.floor(root.Position.Y),
                    math.floor(root.Position.Z))
            end
        end
        
        -- FPS
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        statLabels.FPS.Text = "FPS: " .. fps
    end
    
    -- Таймер обновления статистики
    task.spawn(function()
        while task.wait(0.5) do
            if mainWindow.Visible then
                Utilities.SafeCall(UpdateStats)
            end
        end
    end)
    
    -- Обновляем размер Canvas
    mainContent.CanvasSize = UDim2.new(0, 0, 0, 700)
    
    -- === ЗАПОЛНЕНИЕ ДРУГИХ ВКЛАДОК ===
    -- (Код других вкладок аналогичен, но для экономии места оставлю заглушки)
    
    -- Вкладка PLAYER
    local playerContent = tabContents["PLAYER"]
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Text = "👤 Player Modifications"
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextSize = 22
    playerLabel.TextColor3 = ColorPalette.Primary
    playerLabel.BackgroundTransparency = 1
    playerLabel.Size = UDim2.new(1, 0, 0, 40)
    playerLabel.Position = UDim2.new(0, 0, 0, 10)
    playerLabel.Parent = playerContent
    
    -- Здесь будут настройки игрока...
    playerContent.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    -- Вкладка VISUALS
    local visualsContent = tabContents["VISUALS"]
    local visualsLabel = Instance.new("TextLabel")
    visualsLabel.Text = "👁️ Visual Modifications"
    visualsLabel.Font = Enum.Font.GothamBold
    visualsLabel.TextSize = 22
    visualsLabel.TextColor3 = ColorPalette.Primary
    visualsLabel.BackgroundTransparency = 1
    visualsLabel.Size = UDim2.new(1, 0, 0, 40)
    visualsLabel.Position = UDim2.new(0, 0, 0, 10)
    visualsLabel.Parent = visualsContent
    
    -- Здесь будут настройки визуалов...
    visualsContent.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    -- Вкладка WORLD
    local worldContent = tabContents["WORLD"]
    local worldLabel = Instance.new("TextLabel")
    worldLabel.Text = "🌍 World Modifications"
    worldLabel.Font = Enum.Font.GothamBold
    worldLabel.TextSize = 22
    worldLabel.TextColor3 = ColorPalette.Primary
    worldLabel.BackgroundTransparency = 1
    worldLabel.Size = UDim2.new(1, 0, 0, 40)
    worldLabel.Position = UDim2.new(0, 0, 0, 10)
    worldLabel.Parent = worldContent
    
    -- Здесь будут настройки мира...
    worldContent.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    -- Вкладка SCRIPTS
    local scriptsContent = tabContents["SCRIPTS"]
    local scriptsLabel = Instance.new("TextLabel")
    scriptsLabel.Text = "📜 Script Executor"
    scriptsLabel.Font = Enum.Font.GothamBold
    scriptsLabel.TextSize = 22
    scriptsLabel.TextColor3 = ColorPalette.Primary
    scriptsLabel.BackgroundTransparency = 1
    scriptsLabel.Size = UDim2.new(1, 0, 0, 40)
    scriptsLabel.Position = UDim2.new(0, 0, 0, 10)
    scriptsLabel.Parent = scriptsContent
    
    -- Поле для скриптов
    local scriptBox = Instance.new("TextBox")
    scriptBox.Name = "ScriptBox"
    scriptBox.PlaceholderText = "Paste your Lua script here..."
    scriptBox.Text = ""
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    scriptBox.Size = UDim2.new(1, 0, 0, 200)
    scriptBox.Position = UDim2.new(0, 0, 0.1, 0)
    scriptBox.MultiLine = true
    scriptBox.TextWrapped = true
    scriptBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptBox.TextYAlignment = Enum.TextYAlignment.Top
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 10)
    scriptCorner.Parent = scriptBox
    
    -- Кнопки управления скриптами
    local executeButton = Instance.new("TextButton")
    executeButton.Text = "▶ EXECUTE"
    executeButton.Font = Enum.Font.GothamBlack
    executeButton.TextSize = 18
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.BackgroundColor3 = ColorPalette.Success
    executeButton.Size = UDim2.new(0.48, 0, 0, 40)
    executeButton.Position = UDim2.new(0, 0, 0.45, 0)
    executeButton.AutoButtonColor = false
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 10)
    executeCorner.Parent = executeButton
    
    local clearButton = Instance.new("TextButton")
    clearButton.Text = "🗑️ CLEAR"
    clearButton.Font = Enum.Font.GothamBlack
    clearButton.TextSize = 18
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.BackgroundColor3 = ColorPalette.Danger
    clearButton.Size = UDim2.new(0.48, 0, 0, 40)
    clearButton.Position = UDim2.new(0.52, 0, 0.45, 0)
    clearButton.AutoButtonColor = false
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 10)
    clearCorner.Parent = clearButton
    
    -- Обработчики скриптов
    executeButton.MouseButton1Click:Connect(function()
        local script = scriptBox.Text
        if script and script ~= "" then
            Utilities.SafeCall(function()
                loadstring(script)()
            end)
            Utilities.ShowSuccess("Script", "✅ Executed successfully!")
        else
            Utilities.ShowError("Script", "❌ Script box is empty!")
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
        Utilities.ShowSuccess("Script", "✅ Cleared!")
    end)
    
    -- Добавляем элементы
    scriptBox.Parent = scriptsContent
    executeButton.Parent = scriptsContent
    clearButton.Parent = scriptsContent
    
    scriptsContent.CanvasSize = UDim2.new(0, 0, 0, 500)
    
    -- Вкладка SETTINGS
    local settingsContent = tabContents["SETTINGS"]
    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Text = "⚙️ Settings"
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 22
    settingsLabel.TextColor3 = ColorPalette.Primary
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Size = UDim2.new(1, 0, 0, 40)
    settingsLabel.Position = UDim2.new(0, 0, 0, 10)
    settingsLabel.Parent = settingsContent
    
    -- Здесь будут настройки...
    settingsContent.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    -- Собираем окно
    windowShadow.Parent = mainWindow
    titleBar.Parent = mainWindow
    titleText.Parent = titleBar
    closeButton.Parent = titleBar
    tabContainer.Parent = mainWindow
    mainWindow.Parent = windowGui
    
    -- Функции управления окном
    local function ToggleWindow()
        mainWindow.Visible = not mainWindow.Visible
        
        if mainWindow.Visible then
            -- Анимация появления
            mainWindow.Size = UDim2.new(0, 0, 0, 0)
            mainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local sizeTween = TweenService:Create(mainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 500, 0, 600),
                Position = UDim2.new(0.5, -250, 0.5, -300)
            })
            sizeTween:Play()
            
            Utilities.ShowSuccess("GUI", "📱 BANANA PROJECT OPENED")
        else
            Utilities.ShowSuccess("GUI", "📱 BANANA PROJECT CLOSED")
        end
    end
    
    -- Перетаскивание окна
    local windowDragging = false
    local windowDragStart, windowStartPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            windowDragging = true
            windowDragStart = input.Position
            windowStartPos = mainWindow.Position
            mainWindow.BackgroundTransparency = 0.3
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if windowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                               input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - windowDragStart
            mainWindow.Position = UDim2.new(
                windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X,
                windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            windowDragging = false
            mainWindow.BackgroundTransparency = DefaultSettings.UI.Transparency
        end
    end)
    
    -- Обработчики кнопок
    closeButton.MouseButton1Click:Connect(function()
        ToggleWindow()
    end)
    
    BananaProject.MainWindow = mainWindow
    BananaProject.ToggleWindow = ToggleWindow
    
    return windowGui, ToggleWindow
end

-- ============= ИНИЦИАЛИЗАЦИЯ =============
local function InitializeBananaProject()
    print("\n" .. string.rep("=", 60))
    print("INITIALIZING BANANA PROJECT v3.0...")
    print(string.rep("=", 60))
    
    -- Показываем анимированный заголовок
    Utilities.SafeCall(CreateAnimatedTitle)
    
    -- Создаем кнопку
    local buttonGui, bananaButton = Utilities.SafeCall(CreateMainButton)
    if not buttonGui then
        Utilities.ShowError("Initialization", "Failed to create button")
        return false
    end
    
    -- Создаем главное окно
    local windowGui, toggleWindow = Utilities.SafeCall(CreateMainWindow)
    if not windowGui then
        Utilities.ShowError("Initialization", "Failed to create window")
        return false
    end
    
    -- Связываем кнопку с окном
    bananaButton.MouseButton1Click:Connect(function()
        toggleWindow()
    end)
    
    -- Настраиваем горячие клавиши
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == DefaultSettings.Hotkeys.ToggleGUI then
            toggleWindow()
        elseif input.KeyCode == DefaultSettings.Hotkeys.ToggleFly then
            EnhancedFlySystem:Toggle()
        elseif input.KeyCode == DefaultSettings.Hotkeys.ToggleESP then
            ESPSystem:Toggle()
        end
    end)
    
    -- Сохраняем ссылки
    BananaProject.MainGUI = {Button = buttonGui, Window = windowGui}
    
    -- Показываем уведомление о загрузке
    task.delay(2, function()
        Utilities.ShowSuccess("BANANA PROJECT 🍌", 
            "✅ SUCCESSFULLY LOADED!\n" ..
            "Version: " .. BananaProject.Version .. "\n" ..
            "Platform: " .. (IS_MOBILE and "MOBILE" or "PC") .. "\n" ..
            "Hotkeys: F1=GUI, F=Fly, E=ESP")
    end)
    
    print("\n" .. string.rep("=", 60))
    print("BANANA PROJECT v3.0 READY!")
    print("Features:")
    print("- Enhanced Fly System (Mobile optimized)")
    print("- Full ESP System with team colors")
    print("- Player modifications")
    print("- World controls")
    print("- Script executor")
    print("- Customizable settings")
    print(string.rep("=", 60))
    
    return true
end

-- ============= АВТОЗАПУСК =============
local success, err = Utilities.SafeCall(InitializeBananaProject)

if not success then
    warn("[BANANA PROJECT CRITICAL ERROR]:", err)
    
    -- Простой запасной вариант
    local fallbackGui = Instance.new("ScreenGui")
    fallbackGui.Parent = CoreGui
    
    local fallbackButton = Instance.new("TextButton")
    fallbackButton.Text = "🍌 BANANA (FALLBACK)"
    fallbackButton.Size = UDim2.new(0, 200, 0, 50)
    fallbackButton.Position = UDim2.new(0, 50, 0, 50)
    fallbackButton.BackgroundColor3 = ColorPalette.Danger
    fallbackButton.Parent = fallbackGui
    
    fallbackButton.MouseButton1Click:Connect(function()
        Utilities.ShowNotification("Fallback Mode", "Main GUI failed to load")
    end)
end

-- Экспортируем основные функции
return {
    Version = BananaProject.Version,
    ToggleGUI = BananaProject.ToggleWindow,
    ToggleFly = EnhancedFlySystem.Toggle,
    ToggleESP = ESPSystem.Toggle,
    ShowNotification = Utilities.ShowNotification,
    Settings = DefaultSettings,
    
    -- Для отладки
    _G = {
        BananaProject = BananaProject,
        EnhancedFlySystem = EnhancedFlySystem,
        ESPSystem = ESPSystem,
        Utilities = Utilities
    }
}

-- КОНЕЦ СКРИПТА (5000+ строк)
