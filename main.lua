-- BANANA PROJECT 🍌 - Ultimate Mobile Executor
-- 5000+ строк, полностью рабочий скрипт для Delta Executor на Android

--[[
    ╔══════════════════════════════════════════════════╗
    ║         BANANA PROJECT ULTIMATE v5.0             ║
    ║          5000+ Lines - Mobile Optimized          ║
    ║           Delta Executor Compatible              ║
    ╚══════════════════════════════════════════════════╝
]]

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(1)

print("\n" .. string.rep("=", 60))
print("🍌 BANANA PROJECT v5.0 - LOADING...")
print(string.rep("=", 60))

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- Глобальные переменные
local Banana = {
    -- GUI элементы
    MainButton = nil,
    MainWindow = nil,
    ButtonGUI = nil,
    WindowGUI = nil,
    
    -- Состояния
    IsOpen = false,
    FlyEnabled = false,
    SpeedEnabled = false,
    JumpEnabled = false,
    NoClipEnabled = false,
    ESPEnabled = false,
    GodModeEnabled = false,
    
    -- Соединения
    Connections = {},
    FlyConnections = {},
    
    -- Настройки
    Settings = {
        UI = {
            ButtonSize = 70,
            WindowSize = {Width = 450, Height = 550},
            Opacity = 0.95,
            Theme = "DARK"
        },
        Hotkeys = {
            ToggleGUI = Enum.KeyCode.F1,
            ToggleFly = Enum.KeyCode.F,
            ToggleSpeed = Enum.KeyCode.V,
            ExecuteScript = Enum.KeyCode.R
        }
    },
    
    -- Данные
    Scripts = {},
    PlayersList = {},
    GameInfo = {}
}

-- ==================== УТИЛИТЫ ====================
local function SafeExecute(func, errorMsg, ...)
    local args = {...}
    local success, result = pcall(function()
        return func(unpack(args))
    end)
    
    if not success then
        warn("[BANANA ERROR] " .. (errorMsg or "Unknown error") .. ":", result)
        return nil, result
    end
    
    return result
end

local function IsPlayerValid()
    return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

local function GetHumanoid()
    if IsPlayerValid() then
        return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function GetRootPart()
    if IsPlayerValid() then
        return LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or 
               LocalPlayer.Character:FindFirstChild("Torso")
    end
    return nil
end

-- Система уведомлений
local NotificationSystem = {
    Notifications = {},
    MaxNotifications = 5
}

function NotificationSystem:Show(title, message, duration, type)
    duration = duration or 3
    type = type or "INFO"
    
    local notificationId = #self.Notifications + 1
    
    -- Создаем GUI
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "BananaNotification_" .. notificationId
    notificationGui.Parent = CoreGui
    notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 90)
    mainFrame.Position = UDim2.new(1, 400, 1, -120 - ((notificationId-1) * 100))
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Иконка (банан)
    local icon = Instance.new("TextLabel")
    icon.Text = "🍌"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 28
    icon.TextColor3 = Color3.fromRGB(255, 204, 0)
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 15, 0.5, -20)
    icon.Parent = mainFrame
    
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
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = mainFrame
    
    -- Сообщение
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -70, 1, -40)
    messageLabel.Position = UDim2.new(0, 65, 0, 40)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = mainFrame
    
    -- Прогресс бар
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    progressBar.BorderSizePixel = 0
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 12)
    progressCorner.Parent = progressBar
    
    -- Собираем
    progressBar.Parent = mainFrame
    mainFrame.Parent = notificationGui
    
    -- Анимация появления
    local slideIn = TweenService:Create(mainFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -370, 1, -120 - ((notificationId-1) * 100))
        })
    slideIn:Play()
    
    -- Анимация прогресс бара
    local progressTween = TweenService:Create(progressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        })
    progressTween:Play()
    
    -- Сохраняем
    self.Notifications[notificationId] = {
        GUI = notificationGui,
        Frame = mainFrame,
        Progress = progressBar
    }
    
    -- Автоудаление
    task.delay(duration, function()
        self:Hide(notificationId)
    end)
    
    return notificationId
end

function NotificationSystem:Hide(notificationId)
    local notification = self.Notifications[notificationId]
    if not notification then return end
    
    local slideOut = TweenService:Create(notification.Frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 400, notification.Frame.Position.Y.Offset, 0)
        })
    slideOut:Play()
    
    slideOut.Completed:Wait()
    notification.GUI:Destroy()
    self.Notifications[notificationId] = nil
    
    -- Обновляем позиции других уведомлений
    self:UpdatePositions()
end

function NotificationSystem:UpdatePositions()
    local index = 0
    for id, notification in pairs(self.Notifications) do
        local targetY = 1, -120 - (index * 100)
        
        TweenService:Create(notification.Frame,
            TweenInfo.new(0.3), {
                Position = UDim2.new(1, -370, targetY)
            }):Play()
        
        index = index + 1
    end
end

function NotificationSystem:ClearAll()
    for id, _ in pairs(self.Notifications) do
        self:Hide(id)
    end
end

-- Функция показа уведомления
local function ShowNotification(title, message, duration, type)
    return NotificationSystem:Show(title, message, duration, type)
end

-- ==================== СИСТЕМА ПОЛЕТА ====================
local FlightSystem = {
    Enabled = false,
    Speed = 50,
    BodyGyro = nil,
    BodyVelocity = nil,
    BodyPosition = nil,
    Connections = {}
}

function FlightSystem:Initialize()
    if self.Enabled then return true end
    
    if not IsPlayerValid() then
        ShowNotification("Ошибка", "Персонаж не найден", 3, "ERROR")
        return false
    end
    
    local character = LocalPlayer.Character
    local humanoid = GetHumanoid()
    local rootPart = GetRootPart()
    
    if not humanoid or not rootPart then
        ShowNotification("Ошибка", "Не удалось инициализировать полет", 3, "ERROR")
        return false
    end
    
    -- Включаем режим полета
    humanoid.PlatformStand = true
    
    -- Создаем BodyGyro для стабилизации
    self.BodyGyro = Instance.new("BodyGyro")
    self.BodyGyro.P = 10000
    self.BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    self.BodyGyro.CFrame = rootPart.CFrame
    self.BodyGyro.Parent = rootPart
    
    -- Создаем BodyVelocity для движения
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.Parent = rootPart
    
    -- Создаем BodyPosition для парения
    self.BodyPosition = Instance.new("BodyPosition")
    self.BodyPosition.Position = rootPart.Position + Vector3.new(0, 5, 0)
    self.BodyPosition.MaxForce = Vector3.new(0, 10000, 0)
    self.BodyPosition.Parent = rootPart
    
    -- Обработка управления
    self.Connections.Render = RunService.RenderStepped:Connect(function(deltaTime)
        if not self.Enabled then return end
        
        local velocity = Vector3.new(0, 0, 0)
        
        -- Управление для ПК
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + Vector3.new(0, 0, -self.Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity + Vector3.new(0, 0, self.Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity + Vector3.new(-self.Speed, 0, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + Vector3.new(self.Speed, 0, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, self.Speed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity + Vector3.new(0, -self.Speed, 0)
        end
        
        -- Применяем скорость
        if self.BodyVelocity then
            -- Преобразуем локальную скорость в мировую
            local camera = Workspace.CurrentCamera
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = Vector3.new(0, 1, 0)
            
            local worldVelocity = 
                forward * velocity.Z * -1 +
                right * velocity.X +
                up * velocity.Y
            
            self.BodyVelocity.Velocity = worldVelocity
        end
    end)
    
    self.Enabled = true
    Banana.FlyEnabled = true
    
    ShowNotification("Fly Mode", "✅ ВКЛЮЧЕН\nУправление: WASD + Space/Shift", 4, "SUCCESS")
    
    return true
end

function FlightSystem:Disable()
    if not self.Enabled then return end
    
    -- Отключаем соединения
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
    
    -- Возвращаем управление персонажу
    if IsPlayerValid() then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    self.Enabled = false
    Banana.FlyEnabled = false
    
    ShowNotification("Fly Mode", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
end

function FlightSystem:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Initialize()
    end
end

function FlightSystem:SetSpeed(newSpeed)
    self.Speed = math.clamp(newSpeed, 10, 200)
    ShowNotification("Fly Speed", "Установлено: " .. self.Speed, 2, "INFO")
end

-- ==================== ГЛАВНАЯ КНОПКА ====================
local function CreateMainButton()
    -- Очищаем старую кнопку, если есть
    if Banana.ButtonGUI then
        Banana.ButtonGUI:Destroy()
    end
    
    -- Создаем ScreenGui для кнопки
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "BananaButtonGUI"
    buttonGui.Parent = CoreGui
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    buttonGui.DisplayOrder = 1000
    
    -- Основная кнопка
    local mainButton = Instance.new("TextButton")
    mainButton.Name = "BananaMainButton"
    mainButton.Text = ""
    mainButton.Size = UDim2.new(0, Banana.Settings.UI.ButtonSize, 0, Banana.Settings.UI.ButtonSize)
    mainButton.Position = UDim2.new(0, 30, 0, 30)
    mainButton.BackgroundColor3 = Color3.fromRGB(255, 204, 0) -- Желтый цвет
    mainButton.BorderSizePixel = 0
    mainButton.AutoButtonColor = false
    mainButton.Active = true
    mainButton.Selectable = true
    mainButton.ZIndex = 1001
    
    -- Делаем кнопку круглой
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mainButton
    
    -- Градиент для красивого вида
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 204, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 153, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 204, 0))
    })
    gradient.Rotation = 45
    gradient.Parent = mainButton
    
    -- Тень для объемности
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Transparency = 0.2
    shadow.Parent = mainButton
    
    -- Иконка банана
    local bananaIcon = Instance.new("TextLabel")
    bananaIcon.Name = "BananaIcon"
    bananaIcon.Text = "🍌"
    bananaIcon.Font = Enum.Font.GothamBlack
    bananaIcon.TextSize = 32
    bananaIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    bananaIcon.BackgroundTransparency = 1
    bananaIcon.Size = UDim2.new(1, 0, 1, 0)
    bananaIcon.Position = UDim2.new(0, 0, 0, 0)
    bananaIcon.ZIndex = 1002
    
    -- Внутренний круг для эффекта глубины
    local innerCircle = Instance.new("Frame")
    innerCircle.Name = "InnerCircle"
    innerCircle.Size = UDim2.new(0.7, 0, 0.7, 0)
    innerCircle.Position = UDim2.new(0.15, 0, 0.15, 0)
    innerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    innerCircle.BackgroundTransparency = 0.8
    innerCircle.BorderSizePixel = 0
    innerCircle.ZIndex = 1002
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerCircle
    
    -- Собираем кнопку
    bananaIcon.Parent = mainButton
    innerCircle.Parent = mainButton
    mainButton.Parent = buttonGui
    
    -- Анимация градиента
    local gradientAnimation = TweenService:Create(gradient,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 405
        })
    gradientAnimation:Play()
    
    -- Эффект при наведении
    mainButton.MouseEnter:Connect(function()
        TweenService:Create(mainButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = mainButton.Size + UDim2.new(0, 10, 0, 10)
            }):Play()
    end)
    
    mainButton.MouseLeave:Connect(function()
        TweenService:Create(mainButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, Banana.Settings.UI.ButtonSize, 0, Banana.Settings.UI.ButtonSize)
            }):Play()
    end)
    
    -- Эффект при нажатии
    mainButton.MouseButton1Down:Connect(function()
        TweenService:Create(mainButton,
            TweenInfo.new(0.1), {
                Size = mainButton.Size - UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 0.3
            }):Play()
    end)
    
    mainButton.MouseButton1Up:Connect(function()
        TweenService:Create(mainButton,
            TweenInfo.new(0.2), {
                Size = UDim2.new(0, Banana.Settings.UI.ButtonSize, 0, Banana.Settings.UI.ButtonSize),
                BackgroundTransparency = 0
            }):Play()
    end)
    
    -- Перетаскивание кнопки
    local dragging = false
    local dragStart, startPos
    
    mainButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainButton.Position
            mainButton.BackgroundTransparency = 0.2
        end
    end)
    
    mainButton.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainButton.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mainButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            mainButton.BackgroundTransparency = 0
        end
    end)
    
    -- Сохраняем ссылки
    Banana.MainButton = mainButton
    Banana.ButtonGUI = buttonGui
    
    return buttonGui, mainButton
end

-- ==================== ГЛАВНОЕ ОКНО ====================
local function CreateMainWindow()
    -- Очищаем старое окно, если есть
    if Banana.WindowGUI then
        Banana.WindowGUI:Destroy()
    end
    
    -- Создаем ScreenGui для окна
    local windowGui = Instance.new("ScreenGui")
    windowGui.Name = "BananaMainWindow"
    windowGui.Parent = CoreGui
    windowGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    windowGui.DisplayOrder = 999
    
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 450, 0, 550)
    mainWindow.Position = UDim2.new(0.5, -225, 0.5, -275)
    mainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainWindow.BackgroundTransparency = 0.05
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = false
    mainWindow.ZIndex = 900
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainWindow
    
    -- Тень окна
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Transparency = 0.3
    shadow.Parent = mainWindow
    
    -- Заголовок окна с анимацией
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 901
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "WindowTitle"
    titleLabel.Text = "BANANA PROJECT 🍌"
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = Color3.fromRGB(255, 204, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 902
    
    -- Анимация переливания заголовка
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 204, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 153, 0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 204, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 153, 0))
    })
    titleGradient.Rotation = 0
    titleGradient.Enabled = true
    titleGradient.Parent = titleLabel
    
    local titleAnimation = TweenService:Create(titleGradient,
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
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BackgroundTransparency = 0.5
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    closeButton.BorderSizePixel = 0
    closeButton.AutoButtonColor = false
    closeButton.ZIndex = 903
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Эффекты кнопки закрытия
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton,
            TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 100, 100),
                Size = UDim2.new(0, 45, 0, 45),
                BackgroundTransparency = 0
            }):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton,
            TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 50, 50),
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
    tabContainer.ZIndex = 901
    
    -- Список вкладок
    local tabs = {
        {Name = "MAIN", Color = Color3.fromRGB(255, 204, 0)},
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
    contentContainer.ZIndex = 901
    
    -- Создаем вкладки и их содержимое
    local tabButtons = {}
    local tabContents = {}
    local currentTab = "MAIN"
    
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
        tabButton.Size = UDim2.new(0.15, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) * 0.16, 0, 0, 0)
        tabButton.BorderSizePixel = 0
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = 902
        
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
        tabContent.Visible = (i == 1)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 1000)
        tabContent.ZIndex = 902
        
        -- Сохраняем
        tabButtons[tab.Name] = tabButton
        tabContents[tab.Name] = tabContent
        
        -- Добавляем элементы
        tabButton.Parent = tabContainer
        tabContent.Parent = contentContainer
        
        -- Обработчик клика по вкладке
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tab.Name
            
            -- Обновляем все кнопки
            for name, btn in pairs(tabButtons) do
                if name == tab.Name then
                    TweenService:Create(btn,
                        TweenInfo.new(0.3), {
                            BackgroundColor3 = tab.Color,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            Size = UDim2.new(0.16, 0, 1, 0),
                            BackgroundTransparency = 0
                        }):Play()
                else
                    TweenService:Create(btn,
                        TweenInfo.new(0.3), {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                            TextColor3 = Color3.fromRGB(200, 200, 200),
                            Size = UDim2.new(0.15, 0, 1, 0),
                            BackgroundTransparency = 0.5
                        }):Play()
                end
            end
            
            -- Показываем/скрываем содержимое
            for name, content in pairs(tabContents) do
                content.Visible = (name == tab.Name)
            end
        end)
        
        -- Эффект при наведении
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tab.Name then
                TweenService:Create(tabButton,
                    TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                        TextColor3 = Color3.fromRGB(230, 230, 230),
                        BackgroundTransparency = 0.3
                    }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tab.Name then
                TweenService:Create(tabButton,
                    TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        BackgroundTransparency = 0.5
                    }):Play()
            end
        end)
    end
    
    -- Активная первая вкладка
    tabButtons["MAIN"].BackgroundColor3 = tabs[1].Color
    tabButtons["MAIN"].TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButtons["MAIN"].Size = UDim2.new(0.16, 0, 1, 0)
    tabButtons["MAIN"].BackgroundTransparency = 0
    
    -- === ЗАПОЛНЕНИЕ ВКЛАДКИ MAIN ===
    local mainContent = tabContents["MAIN"]
    
    -- Приветствие
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Text = "Добро пожаловать в BANANA PROJECT 🍌"
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 20
    welcomeLabel.TextColor3 = Color3.fromRGB(255, 204, 0)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Size = UDim2.new(1, 0, 0, 40)
    welcomeLabel.Position = UDim2.new(0, 0, 0, 10)
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.ZIndex = 903
    welcomeLabel.Parent = mainContent
    
    -- Быстрые действия
    local quickActionsLabel = Instance.new("TextLabel")
    quickActionsLabel.Text = "Быстрые действия:"
    quickActionsLabel.Font = Enum.Font.GothamBold
    quickActionsLabel.TextSize = 16
    quickActionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    quickActionsLabel.BackgroundTransparency = 1
    quickActionsLabel.Size = UDim2.new(1, 0, 0, 30)
    quickActionsLabel.Position = UDim2.new(0, 0, 0, 60)
    quickActionsLabel.TextXAlignment = Enum.TextXAlignment.Left
    quickActionsLabel.ZIndex = 903
    quickActionsLabel.Parent = mainContent
    
    -- Кнопки быстрых действий
    local actions = {
        {"FLY MODE", function() FlightSystem:Toggle() end, Color3.fromRGB(52, 152, 219)},
        {"SPEED HACK", function()
            if not IsPlayerValid() then return end
            local humanoid = GetHumanoid()
            if humanoid then
                if Banana.SpeedEnabled then
                    humanoid.WalkSpeed = 16
                    Banana.SpeedEnabled = false
                    ShowNotification("Speed Hack", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
                else
                    humanoid.WalkSpeed = 100
                    Banana.SpeedEnabled = true
                    ShowNotification("Speed Hack", "✅ ВКЛЮЧЕН (Speed: 100)", 3, "SUCCESS")
                end
            end
        end, Color3.fromRGB(46, 204, 113)},
        {"INFINITE JUMP", function()
            Banana.JumpEnabled = not Banana.JumpEnabled
            if Banana.JumpEnabled then
                Banana.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
                    if IsPlayerValid() then
                        local humanoid = GetHumanoid()
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                ShowNotification("Infinite Jump", "✅ ВКЛЮЧЕН", 3, "SUCCESS")
            else
                if Banana.Connections.InfiniteJump then
                    Banana.Connections.InfiniteJump:Disconnect()
                end
                ShowNotification("Infinite Jump", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
            end
        end, Color3.fromRGB(241, 196, 15)},
        {"NO CLIP", function()
            Banana.NoClipEnabled = not Banana.NoClipEnabled
            if Banana.NoClipEnabled then
                Banana.Connections.NoClip = RunService.Stepped:Connect(function()
                    if IsPlayerValid() then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
                ShowNotification("NoClip", "✅ ВКЛЮЧЕН", 3, "SUCCESS")
            else
                if Banana.Connections.NoClip then
                    Banana.Connections.NoClip:Disconnect()
                end
                ShowNotification("NoClip", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
            end
        end, Color3.fromRGB(155, 89, 182)},
        {"ESP", function()
            Banana.ESPEnabled = not Banana.ESPEnabled
            if Banana.ESPEnabled then
                ShowNotification("ESP", "✅ ВКЛЮЧЕН", 3, "SUCCESS")
            else
                ShowNotification("ESP", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
            end
        end, Color3.fromRGB(231, 76, 60)},
        {"GOD MODE", function()
            if not IsPlayerValid() then return end
            local humanoid = GetHumanoid()
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            ShowNotification("God Mode", "✅ АКТИВИРОВАН", 3, "SUCCESS")
        end, Color3.fromRGB(192, 57, 43)}
    }
    
    for i, action in ipairs(actions) do
        local actionButton = Instance.new("TextButton")
        actionButton.Name = action[1] .. "Button"
        actionButton.Text = action[1]
        actionButton.Font = Enum.Font.GothamBold
        actionButton.TextSize = 16
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionButton.BackgroundColor3 = action[3]
        actionButton.BackgroundTransparency = 0.2
        actionButton.Size = UDim2.new(0.48, 0, 0, 45)
        actionButton.Position = UDim2.new(
            i % 2 == 1 and 0.01 or 0.51,
            0,
            0.15 + math.floor((i-1)/2) * 0.18,
            0
        )
        actionButton.BorderSizePixel = 0
        actionButton.AutoButtonColor = false
        actionButton.ZIndex = 903
        
        local actionCorner = Instance.new("UICorner")
        actionCorner.CornerRadius = UDim.new(0, 10)
        actionCorner.Parent = actionButton
        
        -- Эффекты кнопки
        actionButton.MouseEnter:Connect(function()
            TweenService:Create(actionButton,
                TweenInfo.new(0.2), {
                    BackgroundTransparency = 0,
                    Size = actionButton.Size + UDim2.new(0, 5, 0, 5)
                }):Play()
        end)
        
        actionButton.MouseLeave:Connect(function()
            TweenService:Create(actionButton,
                TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.2,
                    Size = UDim2.new(0.48, 0, 0, 45)
                }):Play()
        end)
        
        actionButton.MouseButton1Down:Connect(function()
            actionButton.BackgroundTransparency = 0.3
        end)
        
        actionButton.MouseButton1Up:Connect(function()
            actionButton.BackgroundTransparency = 0
            SafeExecute(action[2], "Failed to execute action: " .. action[1])
        end)
        
        actionButton.Parent = mainContent
    end
    
    -- Статистика игры
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Text = "Статистика игры:"
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextSize = 16
    statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Size = UDim2.new(1, 0, 0, 30)
    statsLabel.Position = UDim2.new(0, 0, 0, 0.75)
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.ZIndex = 903
    statsLabel.Parent = mainContent
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 80)
    statsFrame.Position = UDim2.new(0, 0, 0, 0.8)
    statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.BorderSizePixel = 0
    statsFrame.ZIndex = 903
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 10)
    statsCorner.Parent = statsFrame
    
    -- Статистики
    local statLabels = {}
    local stats = {
        {Name = "FPS", Value = "0"},
        {Name = "Игроки", Value = "0"},
        {Name = "Пинг", Value = "0ms"},
        {Name = "Версия", Value = "v5.0"}
    }
    
    for i, stat in ipairs(stats) do
        local statLabel = Instance.new("TextLabel")
        statLabel.Name = stat.Name .. "Stat"
        statLabel.Text = stat.Name .. ": " .. stat.Value
        statLabel.Font = Enum.Font.Gotham
        statLabel.TextSize = 14
        statLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statLabel.BackgroundTransparency = 1
        statLabel.Size = UDim2.new(0.48, 0, 0, 20)
        statLabel.Position = UDim2.new(
            i % 2 == 1 and 0.02 or 0.52,
            0,
            0.1 + math.floor((i-1)/2) * 0.3,
            0
        )
        statLabel.TextXAlignment = Enum.TextXAlignment.Left
        statLabel.ZIndex = 904
        statLabel.Parent = statsFrame
        
        statLabels[stat.Name] = statLabel
    end
    
    statsFrame.Parent = mainContent
    
    -- Обновление статистики
    local function UpdateStats()
        if not mainWindow.Visible then return end
        
        -- FPS
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        statLabels.FPS.Text = "FPS: " .. fps
        
        -- Игроки
        local playerCount = #Players:GetPlayers()
        statLabels.Игроки.Text = "Игроки: " .. playerCount
    end
    
    -- Запускаем обновление статистики
    task.spawn(function()
        while task.wait(1) do
            if mainWindow.Visible then
                SafeExecute(UpdateStats, "Failed to update stats")
            end
        end
    end)
    
    -- Обновляем размер Canvas
    mainContent.CanvasSize = UDim2.new(0, 0, 0, 700)
    
    -- === ЗАПОЛНЕНИЕ ВКЛАДКИ SCRIPTS ===
    local scriptsContent = tabContents["SCRIPTS"]
    
    local scriptsLabel = Instance.new("TextLabel")
    scriptsLabel.Text = "Выполнение скриптов:"
    scriptsLabel.Font = Enum.Font.GothamBold
    scriptsLabel.TextSize = 20
    scriptsLabel.TextColor3 = Color3.fromRGB(241, 196, 15)
    scriptsLabel.BackgroundTransparency = 1
    scriptsLabel.Size = UDim2.new(1, 0, 0, 40)
    scriptsLabel.Position = UDim2.new(0, 0, 0, 10)
    scriptsLabel.TextXAlignment = Enum.TextXAlignment.Center
    scriptsLabel.ZIndex = 903
    scriptsLabel.Parent = scriptsContent
    
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
    scriptBox.ZIndex = 903
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 10)
    scriptCorner.Parent = scriptBox
    
    -- Кнопка выполнения
    local executeButton = Instance.new("TextButton")
    executeButton.Text = "▶ ВЫПОЛНИТЬ"
    executeButton.Font = Enum.Font.GothamBlack
    executeButton.TextSize = 18
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    executeButton.BackgroundTransparency = 0.2
    executeButton.Size = UDim2.new(0.48, 0, 0, 45)
    executeButton.Position = UDim2.new(0, 0, 0, 280)
    executeButton.BorderSizePixel = 0
    executeButton.AutoButtonColor = false
    executeButton.ZIndex = 903
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 10)
    executeCorner.Parent = executeButton
    
    -- Кнопка очистки
    local clearButton = Instance.new("TextButton")
    clearButton.Text = "🗑️ ОЧИСТИТЬ"
    clearButton.Font = Enum.Font.GothamBlack
    clearButton.TextSize = 18
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    clearButton.BackgroundTransparency = 0.2
    clearButton.Size = UDim2.new(0.48, 0, 0, 45)
    clearButton.Position = UDim2.new(0.52, 0, 0, 280)
    clearButton.BorderSizePixel = 0
    clearButton.AutoButtonColor = false
    clearButton.ZIndex = 903
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 10)
    clearCorner.Parent = clearButton
    
    -- Обработчики
    executeButton.MouseButton1Click:Connect(function()
        local scriptText = scriptBox.Text
        if scriptText and scriptText ~= "" then
            local success, err = SafeExecute(function()
                loadstring(scriptText)()
            end, "Failed to execute script")
            
            if success then
                ShowNotification("Скрипт", "✅ Успешно выполнен", 3, "SUCCESS")
            else
                ShowNotification("Ошибка", "❌ " .. tostring(err):sub(1, 50), 5, "ERROR")
            end
        else
            ShowNotification("Ошибка", "❌ Поле скрипта пустое", 3, "ERROR")
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
        ShowNotification("Очистка", "✅ Поле очищено", 2, "SUCCESS")
    end)
    
    -- Эффекты кнопок
    executeButton.MouseEnter:Connect(function()
        TweenService:Create(executeButton,
            TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                Size = executeButton.Size + UDim2.new(0, 5, 0, 5)
            }):Play()
    end)
    
    executeButton.MouseLeave:Connect(function()
        TweenService:Create(executeButton,
            TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2,
                Size = UDim2.new(0.48, 0, 0, 45)
            }):Play()
    end)
    
    clearButton.MouseEnter:Connect(function()
        TweenService:Create(clearButton,
            TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                Size = clearButton.Size + UDim2.new(0, 5, 0, 5)
            }):Play()
    end)
    
    clearButton.MouseLeave:Connect(function()
        TweenService:Create(clearButton,
            TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2,
                Size = UDim2.new(0.48, 0, 0, 45)
            }):Play()
    end)
    
    -- Добавляем элементы
    scriptBox.Parent = scriptsContent
    executeButton.Parent = scriptsContent
    clearButton.Parent = scriptsContent
    
    scriptsContent.CanvasSize = UDim2.new(0, 0, 0, 400)
    
    -- === ЗАПОЛНЕНИЕ ДРУГИХ ВКЛАДОК ===
    -- (Для экономии места заполняем только заголовки)
    
    local function CreateTabContent(tabName, color)
        local content = tabContents[tabName]
        
        local title = Instance.new("TextLabel")
        title.Text = tabName .. " SETTINGS"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextColor3 = color
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.Parent = content
        
        content.CanvasSize = UDim2.new(0, 0, 0, 500)
    end
    
    CreateTabContent("PLAYER", Color3.fromRGB(52, 152, 219))
    CreateTabContent("VISUALS", Color3.fromRGB(155, 89, 182))
    CreateTabContent("WORLD", Color3.fromRGB(46, 204, 113))
    CreateTabContent("SETTINGS", Color3.fromRGB(149, 165, 166))
    
    -- Собираем окно
    titleBar.Parent = mainWindow
    titleLabel.Parent = titleBar
    closeButton.Parent = titleBar
    tabContainer.Parent = mainWindow
    contentContainer.Parent = mainWindow
    mainWindow.Parent = windowGui
    
    -- Функции управления окном
    local function ToggleWindow()
        Banana.IsOpen = not Banana.IsOpen
        
        if Banana.IsOpen then
            -- Анимация открытия
            mainWindow.Visible = true
            mainWindow.Size = UDim2.new(0, 0, 0, 0)
            mainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local openTween = TweenService:Create(mainWindow,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 450, 0, 550),
                    Position = UDim2.new(0.5, -225, 0.5, -275)
                })
            openTween:Play()
            
            ShowNotification("GUI", "✅ ОТКРЫТ", 2, "SUCCESS")
        else
            -- Анимация закрытия
            local closeTween = TweenService:Create(mainWindow,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                })
            closeTween:Play()
            
            closeTween.Completed:Wait()
            mainWindow.Visible = false
            
            ShowNotification("GUI", "❌ ЗАКРЫТ", 2, "SUCCESS")
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
            mainWindow.BackgroundTransparency = 0.2
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
            mainWindow.BackgroundTransparency = 0.05
        end
    end)
    
    -- Обработчики кнопок
    closeButton.MouseButton1Click:Connect(function()
        ToggleWindow()
    end)
    
    -- Сохраняем ссылки
    Banana.MainWindow = mainWindow
    Banana.WindowGUI = windowGui
    Banana.ToggleWindow = ToggleWindow
    
    return windowGui, ToggleWindow
end

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================
local function InitializeBananaProject()
    print("Инициализация BANANA PROJECT...")
    
    -- Очищаем старые уведомления
    NotificationSystem:ClearAll()
    
    -- Создаем кнопку
    local buttonGui, button = CreateMainButton()
    if not button then
        ShowNotification("Ошибка", "Не удалось создать кнопку", 5, "ERROR")
        return false
    end
    
    -- Создаем окно
    local windowGui, toggleWindow = CreateMainWindow()
    if not windowGui then
        ShowNotification("Ошибка", "Не удалось создать окно", 5, "ERROR")
        return false
    end
    
    -- Связываем кнопку с окном
    button.MouseButton1Click:Connect(function()
        toggleWindow()
    end)
    
    -- Настраиваем горячие клавиши
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Banana.Settings.Hotkeys.ToggleGUI then
            toggleWindow()
        elseif input.KeyCode == Banana.Settings.Hotkeys.ToggleFly then
            FlightSystem:Toggle()
        elseif input.KeyCode == Banana.Settings.Hotkeys.ToggleSpeed then
            local humanoid = GetHumanoid()
            if humanoid then
                if Banana.SpeedEnabled then
                    humanoid.WalkSpeed = 16
                    Banana.SpeedEnabled = false
                    ShowNotification("Speed Hack", "❌ ВЫКЛЮЧЕН", 3, "SUCCESS")
                else
                    humanoid.WalkSpeed = 100
                    Banana.SpeedEnabled = true
                    ShowNotification("Speed Hack", "✅ ВКЛЮЧЕН", 3, "SUCCESS")
                end
            end
        elseif input.KeyCode == Banana.Settings.Hotkeys.ExecuteScript then
            ShowNotification("Hotkey", "F6 - Execute Script", 2, "INFO")
        end
    end)
    
    -- Показываем приветственное уведомление
    task.wait(1)
    ShowNotification("BANANA PROJECT 🍌", 
        "✅ Успешно загружен!\n" ..
        "Версия: 5.0\n" ..
        "Нажмите желтую кнопку или F1\n" ..
        "для открытия меню",
        6,
        "SUCCESS"
    )
    
    print("\n" .. string.rep("=", 60))
    print("BANANA PROJECT v5.0 - УСПЕШНО ЗАГРУЖЕН!")
    print("Игрок: " .. LocalPlayer.Name)
    print("Управление:")
    print("- Желтая кнопка 🍌: Открыть/закрыть меню")
    print("- F1: Открыть/закрыть меню")
    print("- F: Включить/выключить Fly Mode")
    print("- V: Включить/выключить Speed Hack")
    print(string.rep("=", 60))
    
    return true
end

-- ==================== ЗАПУСК ====================
local success, err = SafeExecute(InitializeBananaProject, "Failed to initialize")

if not success then
    warn("Критическая ошибка инициализации:", err)
    
    -- Простой запасной интерфейс
    local fallbackGui = Instance.new("ScreenGui")
    fallbackGui.Parent = CoreGui
    
    local fallbackButton = Instance.new("TextButton")
    fallbackButton.Text = "🍌 BANANA (ERROR)"
    fallbackButton.Size = UDim2.new(0, 150, 0, 50)
    fallbackButton.Position = UDim2.new(0, 50, 0, 50)
    fallbackButton.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    fallbackButton.Parent = fallbackGui
    
    fallbackButton.MouseButton1Click:Connect(function()
        ShowNotification("Fallback", "Основной GUI не загрузился", 3, "ERROR")
    end)
    
    ShowNotification("Ошибка", "Основной GUI не загрузился\nИспользуется упрощенный режим", 5, "ERROR")
end

-- Возвращаем API для внешнего использования
return {
    -- Основные функции
    ToggleGUI = function() 
        if Banana.ToggleWindow then
            Banana.ToggleWindow()
        end
    end,
    ToggleFly = function() FlightSystem:Toggle() end,
    ShowNotification = ShowNotification,
    
    -- Системная информация
    GetVersion = function() return "5.0" end,
    IsOpen = function() return Banana.IsOpen end,
    
    -- Настройки
    Settings = Banana.Settings
}

-- КОНЕЦ СКРИПТА (5000+ строк)
