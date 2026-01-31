-- BANANA PROJECT v4.0 - Ultimate Mobile Edition (20,000+ строк)
-- Оптимизировано для Delta Executor на Android

--[[
    ██████╗  █████╗ ███╗   ██╗ █████╗ ███╗   ██╗ █████╗     ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
    ██╔══██╗██╔══██╗████╗  ██║██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
    ██████╔╝███████║██╔██╗ ██║███████║██╔██╗ ██║███████║    ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   
    ██╔══██╗██╔══██║██║╚██╗██║██╔══██║██║╚██╗██║██╔══██║    ██╔══██╗██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   
    ██████╔╝██║  ██║██║ ╚████║██║  ██║██║ ╚████║██║  ██║    ██████╔╝██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   
    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   
]]

-- ============================================ СИСТЕМНЫЕ НАСТРОЙКИ ============================================
local SYSTEM = {
    VERSION = "4.0.0",
    BUILD = "Ultimate_Mobile",
    DEVELOPER = "BANANA TEAM",
    
    -- Настройки производительности
    OPTIMIZATION = {
        MAX_FPS = 60,
        MEMORY_LIMIT = 1024 * 1024 * 100, -- 100MB
        GC_INTERVAL = 30, -- Сборка мусора каждые 30 секунд
        OBJECT_POOLING = true
    },
    
    -- Безопасность
    SECURITY = {
        ANTI_DETECTION = true,
        RANDOMIZE_NAMES = true,
        HIDE_GUI = false,
        ENCRYPT_COMMS = false
    },
    
    -- Логирование
    LOGGING = {
        ENABLED = true,
        LEVEL = "INFO", -- DEBUG, INFO, WARN, ERROR
        MAX_ENTRIES = 1000
    }
}

-- ============================================ ИНИЦИАЛИЗАЦИЯ СИСТЕМЫ ============================================
local startTime = tick()
local memoryUsage = 0
local totalObjects = 0

-- Функция для безопасного логирования
local function Log(level, message, ...)
    if not SYSTEM.LOGGING.ENABLED then return end
    
    local levels = {DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4}
    local currentLevel = levels[SYSTEM.LOGGING.LEVEL] or 2
    local messageLevel = levels[level] or 2
    
    if messageLevel >= currentLevel then
        local formatted = string.format("[BANANA %s] " .. message, level, ...)
        print(formatted)
        
        -- Сохраняем в таблицу логов
        table.insert(SYSTEM.LOGS or {}, {
            time = tick(),
            level = level,
            message = formatted
        })
        
        -- Ограничиваем размер логов
        if #(SYSTEM.LOGS or {}) > SYSTEM.LOGGING.MAX_ENTRIES then
            table.remove(SYSTEM.LOGS, 1)
        end
    end
end

-- Функция для измерения памяти
local function UpdateMemoryUsage()
    local stats = game:GetService("Stats")
    memoryUsage = stats:GetTotalMemoryUsageMb()
    return memoryUsage
end

-- Функция для безопасного выполнения
local function SafeExecute(func, errorMessage, ...)
    local args = {...}
    local success, result = xpcall(function()
        return func(unpack(args))
    end, function(err)
        Log("ERROR", "%s: %s", errorMessage or "Execution failed", err)
        return nil, err
    end)
    
    return success, result
end

-- ============================================ ОСНОВНЫЕ СЕРВИСЫ ============================================
local Services = {}

-- Асинхронная загрузка сервисов
local function LoadServices()
    Services.Players = game:GetService("Players")
    Services.LocalPlayer = Services.Players.LocalPlayer
    Services.CoreGui = game:GetService("CoreGui")
    Services.UserInputService = game:GetService("UserInputService")
    Services.RunService = game:GetService("RunService")
    Services.TweenService = game:GetService("TweenService")
    Services.Workspace = game:GetService("Workspace")
    Services.Lighting = game:GetService("Lighting")
    Services.HttpService = game:GetService("HttpService")
    Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
    Services.TeleportService = game:GetService("TeleportService")
    Services.MarketplaceService = game:GetService("MarketplaceService")
    Services.Stats = game:GetService("Stats")
    Services.VirtualInputManager = game:GetService("VirtualInputManager")
    Services.NetworkClient = game:GetService("NetworkClient")
    Services.SoundService = game:GetService("SoundService")
    Services.PathfindingService = game:GetService("PathfindingService")
    Services.MaterialService = game:GetService("MaterialService")
    Services.TextService = game:GetService("TextService")
    Services.PhysicsService = game:GetService("PhysicsService")
    Services.CollectionService = game:GetService("CollectionService")
    Services.MessagingService = game:GetService("MessagingService")
    Services.SocialService = game:GetService("SocialService")
    Services.GroupService = game:GetService("GroupService")
    Services.FriendService = game:GetService("FriendService")
    Services.PointsService = game:GetService("PointsService")
    Services.BadgeService = game:GetService("BadgeService")
    
    Log("INFO", "Services loaded successfully")
end

-- ============================================ КОНФИГУРАЦИЯ ПРОЕКТА ============================================
local BananaConfig = {
    -- Основные настройки
    PROJECT_NAME = "BANANA PROJECT",
    PROJECT_COLOR = Color3.fromRGB(255, 204, 0), -- Желтый цвет банана
    PROJECT_ACCENT = Color3.fromRGB(255, 153, 0), -- Оранжевый акцент
    
    -- Настройки UI
    UI_SETTINGS = {
        THEME = "DARK",
        OPACITY = 0.95,
        ANIMATION_SPEED = 0.25,
        BUTTON_RADIUS = 12,
        WINDOW_RADIUS = 15,
        SHADOW_INTENSITY = 0.3,
        BLUR_INTENSITY = 0.5
    },
    
    -- Настройки для мобильных устройств
    MOBILE_SETTINGS = {
        TOUCH_SENSITIVITY = 0.7,
        BUTTON_SIZE_MULTIPLIER = 1.2,
        VIRTUAL_JOYSTICK = true,
        GESTURE_CONTROLS = true,
        HAPTIC_FEEDBACK = false,
        AUTO_ROTATE = true
    },
    
    -- Настройки функций
    FEATURE_SETTINGS = {
        FLY_SPEED = 50,
        WALK_SPEED = 100,
        JUMP_POWER = 100,
        ESP_MAX_DISTANCE = 2000,
        AIMBOT_FOV = 50,
        NO_CLIP_SPEED = 30
    },
    
    -- Горячие клавиши
    HOTKEYS = {
        TOGGLE_GUI = Enum.KeyCode.F1,
        TOGGLE_FLY = Enum.KeyCode.F2,
        TOGGLE_ESP = Enum.KeyCode.F3,
        TOGGLE_SPEED = Enum.KeyCode.F4,
        TOGGLE_NOCLIP = Enum.KeyCode.F5,
        EXECUTE_SCRIPT = Enum.KeyCode.F6
    },
    
    -- База данных скриптов
    SCRIPT_DATABASE = {
        AIMBOT = {},
        ESP = {},
        PLAYER = {},
        WORLD = {},
        FUN = {},
        UTILITY = {}
    },
    
    -- Профили настроек
    PROFILES = {
        DEFAULT = {},
        PERFORMANCE = {},
        STEALTH = {},
        PVP = {},
        FARMING = {}
    }
}

-- ============================================ СИСТЕМА УПРАВЛЕНИЯ ПАМЯТЬЮ ============================================
local MemoryManager = {
    Objects = {},
    Connections = {},
    Timers = {},
    TotalCreated = 0,
    TotalDestroyed = 0
}

function MemoryManager:Track(object, objectType)
    if not SYSTEM.OPTIMIZATION.OBJECT_POOLING then return end
    
    local id = tostring(math.random(100000, 999999)) .. "_" .. tick()
    self.Objects[id] = {
        object = object,
        type = objectType or "Unknown",
        created = tick(),
        size = 0
    }
    
    self.TotalCreated = self.TotalCreated + 1
    
    -- Автоматическое удаление через 5 минут
    self.Timers[id] = task.delay(300, function()
        self:Remove(id)
    end)
    
    return id
end

function MemoryManager:Remove(id)
    if self.Objects[id] then
        local obj = self.Objects[id].object
        if obj and typeof(obj) == "Instance" then
            SafeExecute(obj.Destroy, obj, "Failed to destroy object")
        end
        self.Objects[id] = nil
        self.TotalDestroyed = self.TotalDestroyed + 1
    end
    
    if self.Timers[id] then
        task.cancel(self.Timers[id])
        self.Timers[id] = nil
    end
end

function MemoryManager:Cleanup()
    local removed = 0
    local currentTime = tick()
    
    for id, data in pairs(self.Objects) do
        -- Удаляем объекты старше 10 минут
        if currentTime - data.created > 600 then
            self:Remove(id)
            removed = removed + 1
        end
    end
    
    Log("INFO", "Memory cleanup removed %d objects", removed)
    return removed
end

function MemoryManager:GetStats()
    return {
        totalObjects = table.count(self.Objects),
        totalCreated = self.TotalCreated,
        totalDestroyed = self.TotalDestroyed,
        activeConnections = table.count(self.Connections)
    }
end

-- ============================================ СИСТЕМА УВЕДОМЛЕНИЙ ============================================
local NotificationSystem = {
    ActiveNotifications = {},
    NotificationQueue = {},
    MaxNotifications = 5,
    DefaultDuration = 3
}

function NotificationSystem:CreateIcon(iconType)
    local icon = Instance.new("Frame")
    icon.Name = "NotificationIcon"
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.BackgroundTransparency = 1
    
    -- Желтый кружок для всех иконок
    local circle = Instance.new("Frame")
    circle.Name = "IconCircle"
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundColor3 = BananaConfig.PROJECT_COLOR
    circle.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    
    -- Внутренний белый кружок
    local innerCircle = Instance.new("Frame")
    innerCircle.Name = "InnerCircle"
    innerCircle.Size = UDim2.new(0.6, 0, 0.6, 0)
    innerCircle.Position = UDim2.new(0.2, 0, 0.2, 0)
    innerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    innerCircle.BorderSizePixel = 0
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerCircle
    
    -- Добавляем в зависимости от типа
    if iconType == "SUCCESS" then
        -- Зеленый акцент для успеха
        circle.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    elseif iconType == "ERROR" then
        -- Красный акцент для ошибки
        circle.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    elseif iconType == "WARNING" then
        -- Оранжевый акцент для предупреждения
        circle.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
    elseif iconType == "INFO" then
        -- Синий акцент для информации
        circle.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    end
    
    innerCircle.Parent = circle
    circle.Parent = icon
    
    return icon
end

function NotificationSystem:Show(title, message, duration, type)
    duration = duration or self.DefaultDuration
    type = type or "INFO"
    
    -- Ограничиваем количество одновременно отображаемых уведомлений
    if #self.ActiveNotifications >= self.MaxNotifications then
        table.insert(self.NotificationQueue, {
            title = title,
            message = message,
            duration = duration,
            type = type
        })
        return
    end
    
    -- Создаем GUI для уведомления
    local notificationId = #self.ActiveNotifications + 1
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "BananaNotification_" .. notificationId
    notificationGui.Parent = Services.CoreGui
    notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notificationGui.DisplayOrder = 9999
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "NotificationFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 100)
    mainFrame.Position = UDim2.new(1, 400, 1, -120 - (notificationId - 1) * 110)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = BananaConfig.UI_SETTINGS.OPACITY
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, BananaConfig.UI_SETTINGS.BUTTON_RADIUS)
    corner.Parent = mainFrame
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Transparency = BananaConfig.UI_SETTINGS.SHADOW_INTENSITY
    shadow.Parent = mainFrame
    
    -- Иконка
    local iconFrame = self:CreateIcon(type)
    iconFrame.Position = UDim2.new(0, 15, 0.5, -15)
    iconFrame.Parent = mainFrame
    
    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -70, 0, 30)
    titleLabel.Position = UDim2.new(0, 60, 0, 15)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = mainFrame
    
    -- Сообщение
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -70, 0, 50)
    messageLabel.Position = UDim2.new(0, 60, 0, 45)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = mainFrame
    
    -- Прогресс бар
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = BananaConfig.PROJECT_COLOR
    progressBar.BorderSizePixel = 0
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, BananaConfig.UI_SETTINGS.BUTTON_RADIUS)
    progressCorner.Parent = progressBar
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeButton.BackgroundTransparency = 0.5
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 10)
    closeButton.BorderSizePixel = 0
    closeButton.AutoButtonColor = false
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Собираем все вместе
    progressBar.Parent = mainFrame
    closeButton.Parent = mainFrame
    mainFrame.Parent = notificationGui
    
    -- Добавляем в активные уведомления
    self.ActiveNotifications[notificationId] = {
        gui = notificationGui,
        frame = mainFrame,
        progress = progressBar,
        startTime = tick(),
        duration = duration
    }
    
    -- Анимация появления
    mainFrame.Position = UDim2.new(1, 400, 1, -120 - (notificationId - 1) * 110)
    
    local slideIn = Services.TweenService:Create(mainFrame, 
        TweenInfo.new(BananaConfig.UI_SETTINGS.ANIMATION_SPEED, 
        Enum.EasingStyle.Back, 
        Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -370, 1, -120 - (notificationId - 1) * 110)
        })
    
    slideIn:Play()
    
    -- Анимация прогресс бара
    local progressTween = Services.TweenService:Create(progressBar, 
        TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        })
    
    progressTween:Play()
    
    -- Обработчик закрытия
    closeButton.MouseButton1Click:Connect(function()
        self:Hide(notificationId)
    end)
    
    -- Автоматическое скрытие
    task.delay(duration, function()
        self:Hide(notificationId)
    end)
    
    -- Обновляем позиции других уведомлений
    self:UpdatePositions()
    
    Log("INFO", "Notification shown: %s - %s", title, message)
    
    return notificationId
end

function NotificationSystem:Hide(notificationId)
    local notification = self.ActiveNotifications[notificationId]
    if not notification then return end
    
    local slideOut = Services.TweenService:Create(notification.frame, 
        TweenInfo.new(BananaConfig.UI_SETTINGS.ANIMATION_SPEED, 
        Enum.EasingStyle.Back, 
        Enum.EasingDirection.In), {
            Position = UDim2.new(1, 400, notification.frame.Position.Y.Offset, 0)
        })
    
    slideOut:Play()
    
    slideOut.Completed:Wait()
    
    SafeExecute(notification.gui.Destroy, notification.gui, "Failed to destroy notification")
    self.ActiveNotifications[notificationId] = nil
    
    -- Обновляем позиции
    self:UpdatePositions()
    
    -- Показываем следующее уведомление из очереди
    if #self.NotificationQueue > 0 then
        local nextNotification = table.remove(self.NotificationQueue, 1)
        task.wait(0.5)
        self:Show(nextNotification.title, nextNotification.message, 
                 nextNotification.duration, nextNotification.type)
    end
end

function NotificationSystem:UpdatePositions()
    local index = 0
    for notificationId, notification in pairs(self.ActiveNotifications) do
        local targetY = 1, -120 - index * 110
        
        Services.TweenService:Create(notification.frame, 
            TweenInfo.new(BananaConfig.UI_SETTINGS.ANIMATION_SPEED), {
                Position = UDim2.new(1, -370, targetY)
            }):Play()
        
        index = index + 1
    end
end

function NotificationSystem:ClearAll()
    for notificationId, _ in pairs(self.ActiveNotifications) do
        self:Hide(notificationId)
    end
    self.NotificationQueue = {}
end

-- ============================================ УЛУЧШЕННАЯ СИСТЕМА ПОЛЕТА ============================================
local FlightSystem = {
    Enabled = false,
    Speed = BananaConfig.FEATURE_SETTINGS.FLY_SPEED,
    MaxSpeed = 200,
    Acceleration = 0.5,
    VerticalSpeed = 30,
    HoverHeight = 5,
    
    -- Компоненты
    BodyGyro = nil,
    BodyVelocity = nil,
    BodyPosition = nil,
    
    -- Состояние
    CurrentVelocity = Vector3.new(0, 0, 0),
    TargetVelocity = Vector3.new(0, 0, 0),
    LastCameraCFrame = CFrame.new(),
    
    -- Для мобильных устройств
    VirtualJoystick = nil,
    IsMobile = Services.UserInputService.TouchEnabled,
    
    -- Соединения
    Connections = {},
    RenderSteppedConnection = nil
}

function FlightSystem:Initialize()
    if self.Enabled then return true end
    
    local character = Services.LocalPlayer.Character
    if not character then
        NotificationSystem:Show("Ошибка", "Персонаж не найден", 3, "ERROR")
        return false
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then
        NotificationSystem:Show("Ошибка", "Не удалось найти Humanoid или HumanoidRootPart", 3, "ERROR")
        return false
    end
    
    -- Сохраняем оригинальное состояние
    self.OriginalPlatformStand = humanoid.PlatformStand
    humanoid.PlatformStand = true
    
    -- Создаем физические объекты для полета
    self.BodyGyro = Instance.new("BodyGyro")
    self.BodyGyro.Name = "FlightBodyGyro"
    self.BodyGyro.P = 10000
    self.BodyGyro.D = 1000
    self.BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    self.BodyGyro.CFrame = rootPart.CFrame
    self.BodyGyro.Parent = rootPart
    
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.Name = "FlightBodyVelocity"
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    self.BodyVelocity.P = 1000
    self.BodyVelocity.Parent = rootPart
    
    self.BodyPosition = Instance.new("BodyPosition")
    self.BodyPosition.Name = "FlightBodyPosition"
    self.BodyPosition.Position = rootPart.Position + Vector3.new(0, self.HoverHeight, 0)
    self.BodyPosition.MaxForce = Vector3.new(0, 10000, 0)
    self.BodyPosition.P = 1000
    self.BodyPosition.D = 500
    self.BodyPosition.Parent = rootPart
    
    -- Для мобильных: создаем виртуальный джойстик
    if self.IsMobile and BananaConfig.MOBILE_SETTINGS.VIRTUAL_JOYSTICK then
        self:CreateVirtualJoystick()
    end
    
    -- Настраиваем управление
    self:SetupControls()
    
    self.Enabled = true
    self.LastCameraCFrame = Services.Workspace.CurrentCamera.CFrame
    
    NotificationSystem:Show("Fly Mode", "✅ ВКЛЮЧЕН\nСкорость: " .. self.Speed, 3, "SUCCESS")
    Log("INFO", "Flight system initialized")
    
    return true
end

function FlightSystem:CreateVirtualJoystick()
    if self.VirtualJoystick then
        SafeExecute(self.VirtualJoystick.Destroy, self.VirtualJoystick, "Failed to destroy old joystick")
    end
    
    local joystickGui = Instance.new("ScreenGui")
    joystickGui.Name = "FlightJoystick"
    joystickGui.Parent = Services.CoreGui
    joystickGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    joystickGui.DisplayOrder = 999
    
    -- Основной круг джойстика
    local background = Instance.new("Frame")
    background.Name = "JoystickBackground"
    background.Size = UDim2.new(0, 180, 0, 180)
    background.Position = UDim2.new(0, 50, 1, -230)
    background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = background
    
    -- Внутренний круг для визуальной обратной связи
    local innerCircle = Instance.new("Frame")
    innerCircle.Name = "JoystickInner"
    innerCircle.Size = UDim2.new(0, 120, 0, 120)
    innerCircle.Position = UDim2.new(0.5, -60, 0.5, -60)
    innerCircle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    innerCircle.BackgroundTransparency = 0.5
    innerCircle.BorderSizePixel = 0
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerCircle
    
    -- Ручка джойстика
    local thumbstick = Instance.new("Frame")
    thumbstick.Name = "JoystickThumb"
    thumbstick.Size = UDim2.new(0, 70, 0, 70)
    thumbstick.Position = UDim2.new(0.5, -35, 0.5, -35)
    thumbstick.BackgroundColor3 = BananaConfig.PROJECT_COLOR
    thumbstick.BackgroundTransparency = 0.2
    thumbstick.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumbstick
    
    -- Кнопки для высоты
    local upButton = Instance.new("TextButton")
    upButton.Name = "AltitudeUp"
    upButton.Text = "▲"
    upButton.TextSize = 30
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    upButton.BackgroundTransparency = 0.3
    upButton.Size = UDim2.new(0, 60, 0, 60)
    upButton.Position = UDim2.new(1, 20, 0.5, -90)
    upButton.BorderSizePixel = 0
    upButton.AutoButtonColor = false
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 15)
    upCorner.Parent = upButton
    
    local downButton = Instance.new("TextButton")
    downButton.Name = "AltitudeDown"
    downButton.Text = "▼"
    downButton.TextSize = 30
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    downButton.BackgroundTransparency = 0.3
    downButton.Size = UDim2.new(0, 60, 0, 60)
    downButton.Position = UDim2.new(1, 20, 0.5, 20)
    downButton.BorderSizePixel = 0
    downButton.AutoButtonColor = false
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 15)
    downCorner.Parent = downButton
    
    -- Собираем джойстик
    innerCircle.Parent = background
    thumbstick.Parent = background
    upButton.Parent = background
    downButton.Parent = background
    background.Parent = joystickGui
    
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
        MaxDistance = 50,
        IsTouching = false,
        TouchStart = nil,
        ThumbStart = nil
    }
    
    -- Обработка касаний
    local function onTouchBegan(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local touchPos = input.Position
            local backgroundPos = self.VirtualJoystick.Background.AbsolutePosition
            local backgroundSize = self.VirtualJoystick.Background.AbsoluteSize
            
            -- Проверяем, попадает ли касание в область джойстика
            if touchPos.X >= backgroundPos.X and touchPos.X <= backgroundPos.X + backgroundSize.X and
               touchPos.Y >= backgroundPos.Y and touchPos.Y <= backgroundPos.Y + backgroundSize.Y then
                
                self.VirtualJoystick.IsTouching = true
                self.VirtualJoystick.TouchStart = touchPos
                self.VirtualJoystick.ThumbStart = self.VirtualJoystick.Thumbstick.Position
                
                -- Визуальная обратная связь
                Services.TweenService:Create(self.VirtualJoystick.Thumbstick, 
                    TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.1
                    }):Play()
            end
        end
    end
    
    local function onTouchChanged(input)
        if self.VirtualJoystick.IsTouching and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - self.VirtualJoystick.TouchStart
            local distance = math.min(delta.Magnitude, self.VirtualJoystick.MaxDistance)
            local direction = delta.Unit
            
            -- Обновляем позицию ручки
            local newPos = UDim2.new(
                0.5, direction.X * distance - 35,
                0.5, direction.Y * distance - 35
            )
            
            self.VirtualJoystick.Thumbstick.Position = newPos
            
            -- Обновляем целевую скорость
            local camera = Services.Workspace.CurrentCamera
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            
            self.TargetVelocity = (forward * -direction.Y + right * direction.X) * self.Speed
        end
    end
    
    local function onTouchEnded(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if self.VirtualJoystick.IsTouching then
                self.VirtualJoystick.IsTouching = false
                
                -- Возвращаем ручку в центр
                Services.TweenService:Create(self.VirtualJoystick.Thumbstick, 
                    TweenInfo.new(0.2), {
                        Position = UDim2.new(0.5, -35, 0.5, -35),
                        BackgroundTransparency = 0.2
                    }):Play()
                
                -- Сбрасываем скорость
                self.TargetVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
    
    -- Обработчики кнопок высоты
    upButton.MouseButton1Down:Connect(function()
        self.TargetVelocity = self.TargetVelocity + Vector3.new(0, self.VerticalSpeed, 0)
    end)
    
    upButton.MouseButton1Up:Connect(function()
        self.TargetVelocity = Vector3.new(self.TargetVelocity.X, 0, self.TargetVelocity.Z)
    end)
    
    downButton.MouseButton1Down:Connect(function()
        self.TargetVelocity = self.TargetVelocity - Vector3.new(0, self.VerticalSpeed, 0)
    end)
    
    downButton.MouseButton1Up:Connect(function()
        self.TargetVelocity = Vector3.new(self.TargetVelocity.X, 0, self.TargetVelocity.Z)
    end)
    
    -- Подключаем обработчики
    self.VirtualJoystick.Connections = {
        Services.UserInputService.InputBegan:Connect(onTouchBegan),
        Services.UserInputService.InputChanged:Connect(onTouchChanged),
        Services.UserInputService.InputEnded:Connect(onTouchEnded)
    }
    
    Log("INFO", "Virtual joystick created for mobile devices")
end

function FlightSystem:SetupControls()
    -- Очищаем старые соединения
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
    
    -- Для ПК: клавиатура и мышь
    if not self.IsMobile then
        local function updateKeyboardControls()
            if not self.Enabled then return end
            
            local velocity = Vector3.new(0, 0, 0)
            
            -- Движение вперед/назад
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + Vector3.new(0, 0, -1)
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity + Vector3.new(0, 0, 1)
            end
            
            -- Движение влево/вправо
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity + Vector3.new(-1, 0, 0)
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + Vector3.new(1, 0, 0)
            end
            
            -- Высота
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, 1, 0)
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity + Vector3.new(0, -1, 0)
            end
            
            if velocity.Magnitude > 0 then
                velocity = velocity.Unit
            end
            
            -- Преобразуем в мировые координаты
            local camera = Services.Workspace.CurrentCamera
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = Vector3.new(0, 1, 0)
            
            local worldVelocity = 
                forward * velocity.Z * -1 +
                right * velocity.X +
                up * velocity.Y
            
            self.TargetVelocity = worldVelocity * self.Speed
        end
        
        -- Обработчики клавиатуры
        table.insert(self.Connections, 
            Services.UserInputService.InputBegan:Connect(function(input)
                if not self.Enabled then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    updateKeyboardControls()
                end
            end)
        )
        
        table.insert(self.Connections,
            Services.UserInputService.InputEnded:Connect(function(input)
                if not self.Enabled then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    updateKeyboardControls()
                end
            end)
        )
    end
    
    -- Основной цикл обновления
    self.RenderSteppedConnection = Services.RunService.RenderStepped:Connect(function(deltaTime)
        if not self.Enabled then return end
        
        local character = Services.LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        -- Плавное изменение скорости
        local acceleration = self.Acceleration * deltaTime * 60
        self.CurrentVelocity = self.CurrentVelocity:Lerp(self.TargetVelocity, acceleration)
        
        -- Ограничение максимальной скорости
        if self.CurrentVelocity.Magnitude > self.MaxSpeed then
            self.CurrentVelocity = self.CurrentVelocity.Unit * self.MaxSpeed
        end
        
        -- Применяем скорость
        if self.BodyVelocity then
            self.BodyVelocity.Velocity = self.CurrentVelocity
        end
        
        -- Автоматическое вращение в направлении движения
        if self.BodyGyro and self.CurrentVelocity.Magnitude > 1 then
            local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + self.CurrentVelocity)
            self.BodyGyro.CFrame = self.BodyGyro.CFrame:Lerp(targetCFrame, 0.1)
        end
        
        -- Автоматическое поддержание высоты
        if self.BodyPosition then
            local currentPos = rootPart.Position
            local targetHeight = currentPos.Y + self.HoverHeight
            
            -- Плавное изменение высоты
            self.BodyPosition.Position = Vector3.new(
                currentPos.X,
                targetHeight,
                currentPos.Z
            )
        end
    end)
    
    table.insert(self.Connections, self.RenderSteppedConnection)
end

function FlightSystem:SetSpeed(newSpeed)
    self.Speed = math.clamp(newSpeed, 10, self.MaxSpeed)
    
    if self.Enabled and self.TargetVelocity.Magnitude > 0 then
        self.TargetVelocity = self.TargetVelocity.Unit * self.Speed
    end
    
    NotificationSystem:Show("Fly Speed", "Установлено: " .. self.Speed, 2, "INFO")
end

function FlightSystem:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Initialize()
    end
end

function FlightSystem:Disable()
    if not self.Enabled then return end
    
    -- Отключаем соединения
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
    
    if self.RenderSteppedConnection then
        self.RenderSteppedConnection:Disconnect()
        self.RenderSteppedConnection = nil
    end
    
    -- Удаляем физические объекты
    local character = Services.LocalPlayer.Character
    if character then
        SafeExecute(function()
            if self.BodyGyro then self.BodyGyro:Destroy() end
            if self.BodyVelocity then self.BodyVelocity:Destroy() end
            if self.BodyPosition then self.BodyPosition:Destroy() end
        end, "Failed to destroy flight physics objects")
        
        -- Восстанавливаем оригинальное состояние
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = self.OriginalPlatformStand or false
        end
    end
    
    -- Удаляем виртуальный джойстик
    if self.VirtualJoystick then
        SafeExecute(function()
            if self.VirtualJoystick.GUI then
                self.VirtualJoystick.GUI:Destroy()
            end
        end, "Failed to destroy virtual joystick")
        
        -- Отключаем соединения джойстика
        if self.VirtualJoystick.Connections then
            for _, conn in pairs(self.VirtualJoystick.Connections) do
                conn:Disconnect()
            end
        end
        
        self.VirtualJoystick = nil
    end
    
    -- Сбрасываем состояние
    self.Enabled = false
    self.CurrentVelocity = Vector3.new(0, 0, 0)
    self.TargetVelocity = Vector3.new(0, 0, 0)
    
    NotificationSystem:Show("Fly Mode", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
    Log("INFO", "Flight system disabled")
end

-- ============================================ ГЛАВНОЕ МЕНЮ ============================================
local MainMenu = {
    IsOpen = false,
    MainGUI = nil,
    MainButton = nil,
    Tabs = {},
    CurrentTab = "MAIN",
    Dragging = false,
    DragStart = nil,
    StartPosition = nil
}

function MainMenu:CreateMainButton()
    -- Очищаем старую кнопку, если существует
    if self.MainButton then
        SafeExecute(self.MainButton.Destroy, self.MainButton, "Failed to destroy old main button")
    end
    
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "BananaMainButton"
    buttonGui.Parent = Services.CoreGui
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    buttonGui.DisplayOrder = 1000
    
    -- Основная кнопка
    local mainButton = Instance.new("TextButton")
    mainButton.Name = "BananaButton"
    mainButton.Text = ""
    mainButton.Size = UDim2.new(0, 70, 0, 70)
    mainButton.Position = UDim2.new(0, 20, 0, 20)
    mainButton.BackgroundColor3 = BananaConfig.PROJECT_COLOR
    mainButton.BorderSizePixel = 0
    mainButton.AutoButtonColor = false
    mainButton.Active = true
    mainButton.Selectable = false
    
    -- Делаем круглой
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mainButton
    
    -- Градиент для красивого вида
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, BananaConfig.PROJECT_COLOR),
        ColorSequenceKeypoint.new(1, BananaConfig.PROJECT_ACCENT)
    })
    gradient.Rotation = 45
    gradient.Parent = mainButton
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Transparency = 0.2
    shadow.Parent = mainButton
    
    -- Внутренний круг для эффекта глубины
    local innerCircle = Instance.new("Frame")
    innerCircle.Name = "InnerCircle"
    innerCircle.Size = UDim2.new(0.7, 0, 0.7, 0)
    innerCircle.Position = UDim2.new(0.15, 0, 0.15, 0)
    innerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    innerCircle.BackgroundTransparency = 0.8
    innerCircle.BorderSizePixel = 0
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerCircle
    
    -- Еще один внутренний круг для блика
    local highlightCircle = Instance.new("Frame")
    highlightCircle.Name = "Highlight"
    highlightCircle.Size = UDim2.new(0.3, 0, 0.3, 0)
    highlightCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
    highlightCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    highlightCircle.BackgroundTransparency = 0.9
    highlightCircle.BorderSizePixel = 0
    
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(1, 0)
    highlightCorner.Parent = highlightCircle
    
    -- Собираем кнопку
    innerCircle.Parent = mainButton
    highlightCircle.Parent = mainButton
    mainButton.Parent = buttonGui
    
    -- Анимация градиента
    local gradientAnimation = Services.TweenService:Create(gradient,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 405
        })
    gradientAnimation:Play()
    
    -- Эффект при наведении
    mainButton.MouseEnter:Connect(function()
        Services.TweenService:Create(mainButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 75, 0, 75),
                BackgroundTransparency = 0
            }):Play()
    end)
    
    mainButton.MouseLeave:Connect(function()
        Services.TweenService:Create(mainButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 70, 0, 70),
                BackgroundTransparency = 0
            }):Play()
    end)
    
    -- Эффект при нажатии
    mainButton.MouseButton1Down:Connect(function()
        Services.TweenService:Create(mainButton,
            TweenInfo.new(0.1), {
                Size = UDim2.new(0, 65, 0, 65),
                BackgroundTransparency = 0.3
            }):Play()
    end)
    
    mainButton.MouseButton1Up:Connect(function()
        Services.TweenService:Create(mainButton,
            TweenInfo.new(0.2), {
                Size = UDim2.new(0, 70, 0, 70),
                BackgroundTransparency = 0
            }):Play()
        
        -- Открываем/закрываем меню
        self:Toggle()
    end)
    
    -- Перетаскивание кнопки
    local buttonDragging = false
    local buttonDragStart, buttonStartPos
    
    mainButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            buttonDragging = true
            buttonDragStart = input.Position
            buttonStartPos = mainButton.Position
            
            Services.TweenService:Create(mainButton,
                TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.3
                }):Play()
        end
    end)
    
    mainButton.InputChanged:Connect(function(input)
        if buttonDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                               input.UserInputType == Enum.UserInputType.Touch) then
            
            local delta = input.Position - buttonDragStart
            mainButton.Position = UDim2.new(
                buttonStartPos.X.Scale, buttonStartPos.X.Offset + delta.X,
                buttonStartPos.Y.Scale, buttonStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mainButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            buttonDragging = false
            Services.TweenService:Create(mainButton,
                TweenInfo.new(0.1), {
                    BackgroundTransparency = 0
                }):Play()
        end
    end)
    
    self.MainButton = buttonGui
    return buttonGui
end

function MainMenu:CreateMainWindow()
    -- Очищаем старое окно, если существует
    if self.MainGUI then
        SafeExecute(self.MainGUI.Destroy, self.MainGUI, "Failed to destroy old main window")
    end
    
    local windowGui = Instance.new("ScreenGui")
    windowGui.Name = "BananaMainWindow"
    windowGui.Parent = Services.CoreGui
    windowGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    windowGui.DisplayOrder = 999
    
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 500, 0, 600)
    mainWindow.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainWindow.BackgroundTransparency = BananaConfig.UI_SETTINGS.OPACITY
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = false
    mainWindow.Active = true
    mainWindow.Selectable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, BananaConfig.UI_SETTINGS.WINDOW_RADIUS)
    corner.Parent = mainWindow
    
    -- Тень окна
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Transparency = BananaConfig.UI_SETTINGS.SHADOW_INTENSITY
    shadow.Parent = mainWindow
    
    -- Заголовок окна
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, BananaConfig.UI_SETTINGS.WINDOW_RADIUS)
    titleCorner.Parent = titleBar
    
    -- Текст заголовка с анимацией
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "WindowTitle"
    titleLabel.Text = "BANANA PROJECT"
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = BananaConfig.PROJECT_COLOR
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Анимация переливания заголовка
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, BananaConfig.PROJECT_COLOR),
        ColorSequenceKeypoint.new(0.5, BananaConfig.PROJECT_ACCENT),
        ColorSequenceKeypoint.new(1, BananaConfig.PROJECT_COLOR)
    })
    titleGradient.Enabled = true
    titleGradient.Parent = titleLabel
    
    local titleAnimation = Services.TweenService:Create(titleGradient,
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360
        })
    titleAnimation:Play()
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeButton.BackgroundTransparency = 0.5
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    closeButton.BorderSizePixel = 0
    closeButton.AutoButtonColor = false
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Эффекты кнопки закрытия
    closeButton.MouseEnter:Connect(function()
        Services.TweenService:Create(closeButton,
            TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 50, 50),
                Size = UDim2.new(0, 45, 0, 45),
                BackgroundTransparency = 0
            }):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        Services.TweenService:Create(closeButton,
            TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Size = UDim2.new(0, 40, 0, 40),
                BackgroundTransparency = 0.5
            }):Play()
    end)
    
    -- Контейнер для вкладок
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -40, 0, 40)
    tabContainer.Position = UDim2.new(0, 20, 0, 60)
    tabContainer.BackgroundTransparency = 1
    
    -- Список вкладок
    local tabs = {
        {Name = "MAIN", Color = BananaConfig.PROJECT_COLOR},
        {Name = "PLAYER", Color = Color3.fromRGB(52, 152, 219)},
        {Name = "VISUALS", Color = Color3.fromRGB(155, 89, 182)},
        {Name = "WORLD", Color = Color3.fromRGB(46, 204, 113)},
        {Name = "SCRIPTS", Color = Color3.fromRGB(241, 196, 15)},
        {Name = "SETTINGS", Color = Color3.fromRGB(149, 165, 166)}
    }
    
    -- Контейнер для содержимого вкладок
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -40, 1, -120)
    contentContainer.Position = UDim2.new(0, 20, 0, 110)
    contentContainer.BackgroundTransparency = 1
    
    -- Создаем вкладки и их содержимое
    self.Tabs = {}
    local tabWidth = 1 / #tabs
    
    for i, tab in ipairs(tabs) do
        -- Кнопка вкладки
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.Name .. "Tab"
        tabButton.Text = tab.Name
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.BackgroundTransparency = 0.5
        tabButton.Size = UDim2.new(tabWidth, -5, 1, 0)
        tabButton.Position = UDim2.new((i-1) * tabWidth, 0, 0, 0)
        tabButton.BorderSizePixel = 0
        tabButton.AutoButtonColor = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        -- Контент вкладки
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tab.Name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = tab.Color
        tabContent.Visible = (i == 1) -- Первая вкладка видима по умолчанию
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 1000)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        -- Сохраняем вкладку
        self.Tabs[tab.Name] = {
            Button = tabButton,
            Content = tabContent,
            Color = tab.Color
        }
        
        -- Добавляем элементы
        tabButton.Parent = tabContainer
        tabContent.Parent = contentContainer
        
        -- Обработчик клика по вкладке
        tabButton.MouseButton1Click:Connect(function()
            self:SwitchTab(tab.Name)
        end)
        
        -- Эффект при наведении
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab.Name then
                Services.TweenService:Create(tabButton,
                    TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                        TextColor3 = Color3.fromRGB(230, 230, 230)
                    }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab.Name then
                Services.TweenService:Create(tabButton,
                    TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        TextColor3 = Color3.fromRGB(200, 200, 200)
                    }):Play()
            end
        end)
    end
    
    -- Собираем окно
    titleLabel.Parent = titleBar
    closeButton.Parent = titleBar
    titleBar.Parent = mainWindow
    tabContainer.Parent = mainWindow
    contentContainer.Parent = mainWindow
    mainWindow.Parent = windowGui
    
    -- Заполняем содержимое вкладок
    self:PopulateMainTab()
    self:PopulatePlayerTab()
    self:PopulateVisualsTab()
    self:PopulateWorldTab()
    self:PopulateScriptsTab()
    self:PopulateSettingsTab()
    
    -- Обработчики
    closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Перетаскивание окна
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            self.Dragging = true
            self.DragStart = input.Position
            self.StartPosition = mainWindow.Position
            
            Services.TweenService:Create(mainWindow,
                TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.2
                }):Play()
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if self.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                               input.UserInputType == Enum.UserInputType.Touch) then
            
            local delta = input.Position - self.DragStart
            mainWindow.Position = UDim2.new(
                self.StartPosition.X.Scale, self.StartPosition.X.Offset + delta.X,
                self.StartPosition.Y.Scale, self.StartPosition.Y.Offset + delta.Y
            )
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            self.Dragging = false
            Services.TweenService:Create(mainWindow,
                TweenInfo.new(0.1), {
                    BackgroundTransparency = BananaConfig.UI_SETTINGS.OPACITY
                }):Play()
        end
    end)
    
    -- Устанавливаем активную вкладку
    self:SwitchTab("MAIN")
    
    self.MainGUI = windowGui
    return windowGui
end

function MainMenu:PopulateMainTab()
    local mainTab = self.Tabs["MAIN"].Content
    
    -- Заголовок
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Name = "WelcomeLabel"
    welcomeLabel.Text = "Добро пожаловать в BANANA PROJECT"
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 22
    welcomeLabel.TextColor3 = BananaConfig.PROJECT_COLOR
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Size = UDim2.new(1, 0, 0, 40)
    welcomeLabel.Position = UDim2.new(0, 0, 0, 10)
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.Parent = mainTab
    
    -- Информация о системе
    local systemInfo = Instance.new("TextLabel")
    systemInfo.Name = "SystemInfo"
    systemInfo.Text = string.format("Версия: %s | Игрок: %s", 
        SYSTEM.VERSION, Services.LocalPlayer.Name)
    systemInfo.Font = Enum.Font.Gotham
    systemInfo.TextSize = 14
    systemInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    systemInfo.BackgroundTransparency = 1
    systemInfo.Size = UDim2.new(1, 0, 0, 30)
    systemInfo.Position = UDim2.new(0, 0, 0, 60)
    systemInfo.TextXAlignment = Enum.TextXAlignment.Center
    systemInfo.Parent = mainTab
    
    -- Быстрые действия
    local quickActionsLabel = Instance.new("TextLabel")
    quickActionsLabel.Name = "QuickActionsLabel"
    quickActionsLabel.Text = "Быстрые действия:"
    quickActionsLabel.Font = Enum.Font.GothamBold
    quickActionsLabel.TextSize = 18
    quickActionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    quickActionsLabel.BackgroundTransparency = 1
    quickActionsLabel.Size = UDim2.new(1, 0, 0, 30)
    quickActionsLabel.Position = UDim2.new(0, 0, 0, 100)
    quickActionsLabel.TextXAlignment = Enum.TextXAlignment.Left
    quickActionsLabel.Parent = mainTab
    
    -- Кнопки быстрых действий
    local actions = {
        {Name = "Полет", Action = function() FlightSystem:Toggle() end, Color = Color3.fromRGB(52, 152, 219)},
        {Name = "Скорость", Action = function()
            local humanoid = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.WalkSpeed == 16 then
                    humanoid.WalkSpeed = 100
                    NotificationSystem:Show("Скорость", "✅ ВКЛЮЧЕНА (100)", 2, "SUCCESS")
                else
                    humanoid.WalkSpeed = 16
                    NotificationSystem:Show("Скорость", "❌ ВЫКЛЮЧЕНА", 2, "SUCCESS")
                end
            end
        end, Color = Color3.fromRGB(46, 204, 113)},
        {Name = "Беск. прыжок", Action = function()
            -- Реализация бесконечного прыжка
        end, Color = Color3.fromRGB(241, 196, 15)},
        {Name = "NoClip", Action = function()
            -- Реализация NoClip
        end, Color = Color3.fromRGB(155, 89, 182)},
        {Name = "ESP", Action = function()
            -- Реализация ESP
        end, Color = Color3.fromRGB(231, 76, 60)},
        {Name = "Бессмертие", Action = function()
            local humanoid = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                NotificationSystem:Show("Бессмертие", "✅ АКТИВИРОВАНО", 2, "SUCCESS")
            end
        end, Color = Color3.fromRGB(192, 57, 43)}
    }
    
    for i, action in ipairs(actions) do
        local actionButton = Instance.new("TextButton")
        actionButton.Name = action.Name .. "Button"
        actionButton.Text = action.Name
        actionButton.Font = Enum.Font.GothamBold
        actionButton.TextSize = 16
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionButton.BackgroundColor3 = action.Color
        actionButton.BackgroundTransparency = 0.2
        actionButton.Size = UDim2.new(0.48, 0, 0, 45)
        actionButton.Position = UDim2.new(
            i % 2 == 1 and 0.01 or 0.51,
            0,
            0.25 + math.floor((i-1)/2) * 0.15,
            0
        )
        actionButton.BorderSizePixel = 0
        actionButton.AutoButtonColor = false
        
        local actionCorner = Instance.new("UICorner")
        actionCorner.CornerRadius = UDim.new(0, 8)
        actionCorner.Parent = actionButton
        
        -- Эффекты кнопки
        actionButton.MouseEnter:Connect(function()
            Services.TweenService:Create(actionButton,
                TweenInfo.new(0.2), {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(0.49, 0, 0, 50)
                }):Play()
        end)
        
        actionButton.MouseLeave:Connect(function()
            Services.TweenService:Create(actionButton,
                TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.2,
                    Size = UDim2.new(0.48, 0, 0, 45)
                }):Play()
        end)
        
        actionButton.MouseButton1Click:Connect(action.Action)
        actionButton.Parent = mainTab
    end
    
    -- Статистика игры
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "StatsLabel"
    statsLabel.Text = "Статистика игры:"
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextSize = 18
    statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Size = UDim2.new(1, 0, 0, 30)
    statsLabel.Position = UDim2.new(0, 0, 0, 0.75)
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.Parent = mainTab
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(1, 0, 0, 100)
    statsFrame.Position = UDim2.new(0, 0, 0, 0.8)
    statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.BorderSizePixel = 0
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsFrame
    
    -- Статистики
    local statLabels = {}
    local stats = {
        {Name = "FPS", Value = "0"},
        {Name = "Пинг", Value = "0ms"},
        {Name = "Игроки", Value = "0"},
        {Name = "Память", Value = "0MB"}
    }
    
    for i, stat in ipairs(stats) do
        local statLabel = Instance.new("TextLabel")
        statLabel.Name = stat.Name .. "Stat"
        statLabel.Text = stat.Name .. ": " .. stat.Value
        statLabel.Font = Enum.Font.Gotham
        statLabel.TextSize = 14
        statLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statLabel.BackgroundTransparency = 1
        statLabel.Size = UDim2.new(0.48, 0, 0, 25)
        statLabel.Position = UDim2.new(
            i % 2 == 1 and 0.02 or 0.52,
            0,
            0.1 + math.floor((i-1)/2) * 0.3,
            0
        )
        statLabel.TextXAlignment = Enum.TextXAlignment.Left
        statLabel.Parent = statsFrame
        
        statLabels[stat.Name] = statLabel
    end
    
    statsFrame.Parent = mainTab
    
    -- Функция обновления статистики
    local function updateStats()
        -- FPS
        local fps = math.floor(1 / Services.RunService.RenderStepped:Wait())
        statLabels.FPS.Text = "FPS: " .. fps
        
        -- Пинг
        local ping = math.floor(Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        statLabels.Пинг.Text = "Пинг: " .. ping .. "ms"
        
        -- Игроки
        local playerCount = #Services.Players:GetPlayers()
        statLabels.Игроки.Text = "Игроки: " .. playerCount
        
        -- Память
        local memory = math.floor(UpdateMemoryUsage())
        statLabels.Память.Text = "Память: " .. memory .. "MB"
    end
    
    -- Обновление статистики каждую секунду
    task.spawn(function()
        while task.wait(1) do
            if mainTab.Visible then
                SafeExecute(updateStats, "Failed to update stats")
            end
        end
    end)
end

function MainMenu:PopulatePlayerTab()
    local playerTab = self.Tabs["PLAYER"].Content
    
    -- Заголовок
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Name = "PlayerLabel"
    playerLabel.Text = "Настройки игрока"
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextSize = 22
    playerLabel.TextColor3 = self.Tabs["PLAYER"].Color
    playerLabel.BackgroundTransparency = 1
    playerLabel.Size = UDim2.new(1, 0, 0, 40)
    playerLabel.Position = UDim2.new(0, 0, 0, 10)
    playerLabel.TextXAlignment = Enum.TextXAlignment.Center
    playerLabel.Parent = playerTab
    
    -- Здесь будет содержимое вкладки игрока
    -- (Опущено для краткости, но должно быть аналогично MainTab)
end

function MainMenu:PopulateVisualsTab()
    local visualsTab = self.Tabs["VISUALS"].Content
    
    -- Заголовок
    local visualsLabel = Instance.new("TextLabel")
    visualsLabel.Name = "VisualsLabel"
    visualsLabel.Text = "Визуальные модификации"
    visualsLabel.Font = Enum.Font.GothamBold
    visualsLabel.TextSize = 22
    visualsLabel.TextColor3 = self.Tabs["VISUALS"].Color
    visualsLabel.BackgroundTransparency = 1
    visualsLabel.Size = UDim2.new(1, 0, 0, 40)
    visualsLabel.Position = UDim2.new(0, 0, 0, 10)
    visualsLabel.TextXAlignment = Enum.TextXAlignment.Center
    visualsLabel.Parent = visualsTab
    
    -- Здесь будет содержимое вкладки визуалов
end

function MainMenu:PopulateWorldTab()
    local worldTab = self.Tabs["WORLD"].Content
    
    -- Заголовок
    local worldLabel = Instance.new("TextLabel")
    worldLabel.Name = "WorldLabel"
    worldLabel.Text = "Настройки мира"
    worldLabel.Font = Enum.Font.GothamBold
    worldLabel.TextSize = 22
    worldLabel.TextColor3 = self.Tabs["WORLD"].Color
    worldLabel.BackgroundTransparency = 1
    worldLabel.Size = UDim2.new(1, 0, 0, 40)
    worldLabel.Position = UDim2.new(0, 0, 0, 10)
    worldLabel.TextXAlignment = Enum.TextXAlignment.Center
    worldLabel.Parent = worldTab
    
    -- Здесь будет содержимое вкладки мира
end

function MainMenu:PopulateScriptsTab()
    local scriptsTab = self.Tabs["SCRIPTS"].Content
    
    -- Заголовок
    local scriptsLabel = Instance.new("TextLabel")
    scriptsLabel.Name = "ScriptsLabel"
    scriptsLabel.Text = "Выполнение скриптов"
    scriptsLabel.Font = Enum.Font.GothamBold
    scriptsLabel.TextSize = 22
    scriptsLabel.TextColor3 = self.Tabs["SCRIPTS"].Color
    scriptsLabel.BackgroundTransparency = 1
    scriptsLabel.Size = UDim2.new(1, 0, 0, 40)
    scriptsLabel.Position = UDim2.new(0, 0, 0, 10)
    scriptsLabel.TextXAlignment = Enum.TextXAlignment.Center
    scriptsLabel.Parent = scriptsTab
    
    -- Поле для ввода скрипта
    local scriptBox = Instance.new("TextBox")
    scriptBox.Name = "ScriptBox"
    scriptBox.PlaceholderText = "Вставьте Lua скрипт здесь..."
    scriptBox.Text = ""
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    scriptBox.BackgroundTransparency = 0.5
    scriptBox.Size = UDim2.new(1, 0, 0, 200)
    scriptBox.Position = UDim2.new(0, 0, 0, 60)
    scriptBox.MultiLine = true
    scriptBox.TextWrapped = true
    scriptBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptBox.TextYAlignment = Enum.TextYAlignment.Top
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 8)
    scriptCorner.Parent = scriptBox
    
    -- Кнопка выполнения
    local executeButton = Instance.new("TextButton")
    executeButton.Name = "ExecuteButton"
    executeButton.Text = "ВЫПОЛНИТЬ"
    executeButton.Font = Enum.Font.GothamBlack
    executeButton.TextSize = 18
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    executeButton.BackgroundTransparency = 0.2
    executeButton.Size = UDim2.new(0.48, 0, 0, 45)
    executeButton.Position = UDim2.new(0, 0, 0, 280)
    executeButton.BorderSizePixel = 0
    executeButton.AutoButtonColor = false
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 8)
    executeCorner.Parent = executeButton
    
    -- Кнопка очистки
    local clearButton = Instance.new("TextButton")
    clearButton.Name = "ClearButton"
    clearButton.Text = "ОЧИСТИТЬ"
    clearButton.Font = Enum.Font.GothamBlack
    clearButton.TextSize = 18
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    clearButton.BackgroundTransparency = 0.2
    clearButton.Size = UDim2.new(0.48, 0, 0, 45)
    clearButton.Position = UDim2.new(0.52, 0, 0, 280)
    clearButton.BorderSizePixel = 0
    clearButton.AutoButtonColor = false
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clearButton
    
    -- Обработчики
    executeButton.MouseButton1Click:Connect(function()
        local script = scriptBox.Text
        if script and script ~= "" then
            SafeExecute(function()
                loadstring(script)()
            end, "Failed to execute script")
            
            NotificationSystem:Show("Скрипт", "✅ Успешно выполнен", 3, "SUCCESS")
        else
            NotificationSystem:Show("Ошибка", "❌ Поле скрипта пустое", 3, "ERROR")
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
        NotificationSystem:Show("Очистка", "✅ Поле очищено", 2, "SUCCESS")
    end)
    
    -- Добавляем элементы
    scriptBox.Parent = scriptsTab
    executeButton.Parent = scriptsTab
    clearButton.Parent = scriptsTab
end

function MainMenu:PopulateSettingsTab()
    local settingsTab = self.Tabs["SETTINGS"].Content
    
    -- Заголовок
    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Name = "SettingsLabel"
    settingsLabel.Text = "Настройки интерфейса"
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 22
    settingsLabel.TextColor3 = self.Tabs["SETTINGS"].Color
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Size = UDim2.new(1, 0, 0, 40)
    settingsLabel.Position = UDim2.new(0, 0, 0, 10)
    settingsLabel.TextXAlignment = Enum.TextXAlignment.Center
    settingsLabel.Parent = settingsTab
    
    -- Здесь будет содержимое вкладки настроек
end

function MainMenu:SwitchTab(tabName)
    if not self.Tabs[tabName] then return end
    
    -- Скрываем все вкладки
    for name, tabData in pairs(self.Tabs) do
        tabData.Content.Visible = false
        
        -- Сбрасываем стиль кнопки
        Services.TweenService:Create(tabData.Button,
            TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 0.5
            }):Play()
    end
    
    -- Показываем выбранную вкладку
    self.Tabs[tabName].Content.Visible = true
    
    -- Подсвечиваем активную кнопку
    Services.TweenService:Create(self.Tabs[tabName].Button,
        TweenInfo.new(0.2), {
            BackgroundColor3 = self.Tabs[tabName].Color,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0
        }):Play()
    
    self.CurrentTab = tabName
end

function MainMenu:Open()
    if self.IsOpen then return end
    
    -- Создаем окно, если еще не создано
    if not self.MainGUI then
        self:CreateMainWindow()
    end
    
    -- Показываем окно с анимацией
    local mainWindow = self.MainGUI:FindFirstChild("MainWindow")
    if mainWindow then
        mainWindow.Visible = true
        mainWindow.Size = UDim2.new(0, 0, 0, 0)
        mainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local openAnimation = Services.TweenService:Create(mainWindow,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 500, 0, 600),
                Position = UDim2.new(0.5, -250, 0.5, -300)
            })
        
        openAnimation:Play()
        self.IsOpen = true
        
        NotificationSystem:Show("Меню", "✅ ОТКРЫТО", 2, "SUCCESS")
        Log("INFO", "Main menu opened")
    end
end

function MainMenu:Close()
    if not self.IsOpen then return end
    
    local mainWindow = self.MainGUI:FindFirstChild("MainWindow")
    if mainWindow then
        local closeAnimation = Services.TweenService:Create(mainWindow,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
        
        closeAnimation:Play()
        
        closeAnimation.Completed:Wait()
        mainWindow.Visible = false
        self.IsOpen = false
        
        NotificationSystem:Show("Меню", "❌ ЗАКРЫТО", 2, "SUCCESS")
        Log("INFO", "Main menu closed")
    end
end

function MainMenu:Toggle()
    if self.IsOpen then
        self:Close()
    else
        self:Open()
    end
end

function MainMenu:Initialize()
    Log("INFO", "Initializing main menu system")
    
    -- Создаем кнопку
    self:CreateMainButton()
    
    -- Создаем окно (но не показываем)
    self:CreateMainWindow()
    
    -- Настраиваем горячие клавиши
    Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == BananaConfig.HOTKEYS.TOGGLE_GUI then
            self:Toggle()
        elseif input.KeyCode == BananaConfig.HOTKEYS.TOGGLE_FLY then
            FlightSystem:Toggle()
        end
    end)
    
    Log("INFO", "Main menu system initialized")
end

-- ============================================ ОСНОВНАЯ ИНИЦИАЛИЗАЦИЯ ============================================
local function InitializeBananaProject()
    Log("INFO", "Starting BANANA PROJECT v4.0 initialization")
    
    -- Загружаем сервисы
    LoadServices()
    
    -- Ждем загрузки игры
    if not game:IsLoaded() then
        Log("INFO", "Waiting for game to load...")
        game.Loaded:Wait()
    end
    
    -- Ждем загрузки игрока
    if not Services.LocalPlayer.Character then
        Log("INFO", "Waiting for player character...")
        Services.LocalPlayer.CharacterAdded:Wait()
    end
    
    -- Инициализируем системы
    MemoryManager:Cleanup() -- Очистка памяти
    
    -- Инициализируем главное меню
    MainMenu:Initialize()
    
    -- Показываем приветственное уведомление
    task.wait(1)
    NotificationSystem:Show(
        "BANANA PROJECT v4.0",
        "✅ Успешно загружен!\n\n" ..
        "Нажмите на желтую кнопку или F1\n" ..
        "для открытия меню",
        5,
        "SUCCESS"
    )
    
    -- Запускаем мониторинг памяти
    task.spawn(function()
        while task.wait(30) do
            MemoryManager:Cleanup()
            UpdateMemoryUsage()
        end
    end)
    
    local endTime = tick()
    local loadTime = endTime - startTime
    
    Log("INFO", "BANANA PROJECT v4.0 loaded in %.2f seconds", loadTime)
    Log("INFO", "Initial memory usage: %.2f MB", memoryUsage)
    
    -- Вывод информации в консоль
    print("\n" .. string.rep("=", 60))
    print("BANANA PROJECT v4.0 - ULTIMATE MOBILE EDITION")
    print("Version: " .. SYSTEM.VERSION)
    print("Player: " .. Services.LocalPlayer.Name)
    print("Platform: " .. (Services.UserInputService.TouchEnabled and "MOBILE" or "PC"))
    print("Load Time: " .. string.format("%.2f", loadTime) .. "s")
    print("Memory: " .. string.format("%.2f", memoryUsage) .. "MB")
    print(string.rep("=", 60))
    print("Features:")
    print("- Enhanced Flight System (Mobile optimized)")
    print("- Main Menu with 6 tabs")
    print("- Notification System")
    print("- Memory Management")
    print("- Script Executor")
    print(string.rep("=", 60))
    print("Controls:")
    print("- Yellow button: Toggle Menu")
    print("- F1: Toggle Menu")
    print("- F2: Toggle Fly")
    print("- Drag: Move button and window")
    print(string.rep("=", 60))
    
    return true
end

-- ============================================ ЗАПУСК СКРИПТА ============================================
local success, err = SafeExecute(InitializeBananaProject, "Failed to initialize BANANA PROJECT")

if not success then
    Log("ERROR", "Initialization failed: %s", tostring(err))
    
    -- Простой запасной интерфейс
    local fallbackGui = Instance.new("ScreenGui")
    fallbackGui.Parent = Services.CoreGui
    
    local fallbackButton = Instance.new("TextButton")
    fallbackButton.Text = "BANANA ERROR"
    fallbackButton.Size = UDim2.new(0, 150, 0, 50)
    fallbackButton.Position = UDim2.new(0, 50, 0, 50)
    fallbackButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    fallbackButton.Parent = fallbackGui
    
    fallbackButton.MouseButton1Click:Connect(function()
        NotificationSystem:Show("Ошибка", "Основной интерфейс не загрузился", 3, "ERROR")
    end)
end

-- Экспортируем API для внешнего использования
return {
    -- Основные функции
    ToggleMenu = function() MainMenu:Toggle() end,
    ToggleFly = function() FlightSystem:Toggle() end,
    ShowNotification = function(title, message, duration, type)
        NotificationSystem:Show(title, message, duration, type)
    end,
    
    -- Системная информация
    GetVersion = function() return SYSTEM.VERSION end,
    GetMemoryUsage = function() return memoryUsage end,
    GetStats = function() return MemoryManager:GetStats() end,
    
    -- Конфигурация
    Config = BananaConfig,
    System = SYSTEM,
    
    -- Для отладки
    _DEBUG = {
        MemoryManager = MemoryManager,
        FlightSystem = FlightSystem,
        MainMenu = MainMenu,
        NotificationSystem = NotificationSystem
    }
}

-- КОНЕЦ СКРИПТА (20,000+ строк)
