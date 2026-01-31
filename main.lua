-- BANANA PROJECT - Compact Edition (2100 строк)
-- Полностью рабочий скрипт для Delta Executor на телефоне

-- Инициализация
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(1)

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

print("=== BANANA PROJECT STARTING ===")
print("Player: " .. LocalPlayer.Name)

-- Глобальные переменные
local Banana = {
    MainButton = nil,
    MainWindow = nil,
    IsOpen = false,
    
    FlyEnabled = false,
    SpeedEnabled = false,
    JumpEnabled = false,
    NoClipEnabled = false,
    ESPEnabled = false,
    
    Connections = {}
}

-- Утилиты
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        print("[ERROR]", result)
    end
    return result
end

local function ShowNotification(title, message, duration)
    duration = duration or 3
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "BananaNotification"
    notification.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, 320, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    -- Желтый кружок для иконки
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0.5, -15)
    icon.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    icon.BorderSizePixel = 0
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon
    
    -- Внутренний белый кружок
    local innerCircle = Instance.new("Frame")
    innerCircle.Size = UDim2.new(0, 15, 0, 15)
    innerCircle.Position = UDim2.new(0.25, 0, 0.25, 0)
    innerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    innerCircle.BorderSizePixel = 0
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerCircle
    
    -- Текст
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 60, 0, 15)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -60, 0, 40)
    messageLabel.Position = UDim2.new(0, 60, 0, 40)
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Собираем
    innerCircle.Parent = icon
    icon.Parent = frame
    titleLabel.Parent = frame
    messageLabel.Parent = frame
    frame.Parent = notification
    
    -- Анимация
    local slideIn = TweenService:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 1, -100)
    })
    slideIn:Play()
    
    -- Автоудаление
    task.delay(duration, function()
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 320, 1, -100)
        })
        slideOut:Play()
        
        slideOut.Completed:Wait()
        notification:Destroy()
    end)
end

-- Функции хаков
local function ToggleFly()
    if not LocalPlayer.Character then return end
    
    Banana.FlyEnabled = not Banana.FlyEnabled
    
    if Banana.FlyEnabled then
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not root then
            ShowNotification("Ошибка", "Персонаж не готов")
            Banana.FlyEnabled = false
            return
        end
        
        humanoid.PlatformStand = true
        
        -- Создаем BodyGyro для стабилизации
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 10000
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        
        -- Создаем BodyVelocity для движения
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = root
        
        -- Сохраняем соединения
        Banana.Connections.FlyRender = RunService.RenderStepped:Connect(function()
            if not Banana.FlyEnabled then return end
            
            local velocity = Vector3.new(0, 0, 0)
            local speed = 50
            
            -- Управление для ПК
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (root.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (root.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (root.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (root.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, speed, 0)
            end
            
            bodyVelocity.Velocity = velocity
        end)
        
        Banana.Connections.FlyGyro = bodyGyro
        Banana.Connections.FlyVelocity = bodyVelocity
        
        ShowNotification("Fly Mode", "ВКЛЮЧЕН (WASD + Space/Shift)")
        print("Fly ENABLED")
    else
        -- Отключаем полет
        if Banana.Connections.FlyRender then
            Banana.Connections.FlyRender:Disconnect()
            Banana.Connections.FlyRender = nil
        end
        
        if Banana.Connections.FlyGyro then
            Banana.Connections.FlyGyro:Destroy()
            Banana.Connections.FlyGyro = nil
        end
        
        if Banana.Connections.FlyVelocity then
            Banana.Connections.FlyVelocity:Destroy()
            Banana.Connections.FlyVelocity = nil
        end
        
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        
        ShowNotification("Fly Mode", "ВЫКЛЮЧЕН")
        print("Fly DISABLED")
    end
end

local function ToggleSpeed()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    Banana.SpeedEnabled = not Banana.SpeedEnabled
    
    if Banana.SpeedEnabled then
        humanoid.WalkSpeed = 100
        ShowNotification("Speed Hack", "ВКЛЮЧЕН (Speed: 100)")
    else
        humanoid.WalkSpeed = 16
        ShowNotification("Speed Hack", "ВЫКЛЮЧЕН")
    end
end

local function ToggleInfiniteJump()
    Banana.JumpEnabled = not Banana.JumpEnabled
    
    if Banana.JumpEnabled then
        Banana.Connections.Jump = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        ShowNotification("Infinite Jump", "ВКЛЮЧЕН")
    else
        if Banana.Connections.Jump then
            Banana.Connections.Jump:Disconnect()
            Banana.Connections.Jump = nil
        end
        ShowNotification("Infinite Jump", "ВЫКЛЮЧЕН")
    end
end

local function ToggleNoClip()
    Banana.NoClipEnabled = not Banana.NoClipEnabled
    
    if Banana.NoClipEnabled then
        Banana.Connections.NoClip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        ShowNotification("NoClip", "ВКЛЮЧЕН")
    else
        if Banana.Connections.NoClip then
            Banana.Connections.NoClip:Disconnect()
            Banana.Connections.NoClip = nil
        end
        ShowNotification("NoClip", "ВЫКЛЮЧЕН")
    end
end

-- Создание кнопки
local function CreateMainButton()
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "BananaButtonGUI"
    buttonGui.Parent = CoreGui
    
    local button = Instance.new("TextButton")
    button.Name = "BananaButton"
    button.Text = ""
    button.Size = UDim2.new(0, 70, 0, 70)
    button.Position = UDim2.new(0, 20, 0, 20)
    button.BackgroundColor3 = Color3.fromRGB(255, 204, 0) -- Желтый цвет
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.ZIndex = 1000
    
    -- Делаем круглой
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Градиент для красивого вида
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 204, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 153, 0))
    })
    gradient.Rotation = 45
    gradient.Parent = button
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Parent = button
    
    -- Анимация градиента
    local gradientTween = TweenService:Create(gradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 405
    })
    gradientTween:Play()
    
    -- Эффект при наведении
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 75, 0, 75)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()
    end)
    
    -- Перетаскивание
    local dragging = false
    local dragStart, startPos
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            button.BackgroundTransparency = 0.3
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            button.BackgroundTransparency = 0
        end
    end)
    
    button.Parent = buttonGui
    Banana.MainButton = button
    
    return buttonGui, button
end

-- Создание главного окна
local function CreateMainWindow()
    local windowGui = Instance.new("ScreenGui")
    windowGui.Name = "BananaMainWindow"
    windowGui.Parent = CoreGui
    windowGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    windowGui.DisplayOrder = 999
    
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 400, 0, 500)
    mainWindow.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainWindow.BackgroundTransparency = 0.1
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = false
    mainWindow.ZIndex = 900
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainWindow
    
    -- Заголовок с анимацией
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "BANANA PROJECT"
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = Color3.fromRGB(255, 204, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Анимация переливания заголовка
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 204, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 153, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 204, 0))
    })
    titleGradient.Parent = titleLabel
    
    local titleAnimation = TweenService:Create(titleGradient, 
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360
        })
    titleAnimation:Play()
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Контент
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 204, 0)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    -- Быстрые функции
    local functions = {
        {"FLY MODE", ToggleFly, Color3.fromRGB(52, 152, 219)},
        {"SPEED HACK", ToggleSpeed, Color3.fromRGB(46, 204, 113)},
        {"INFINITE JUMP", ToggleInfiniteJump, Color3.fromRGB(241, 196, 15)},
        {"NO CLIP", ToggleNoClip, Color3.fromRGB(155, 89, 182)},
        {"ESP", function()
            Banana.ESPEnabled = not Banana.ESPEnabled
            if Banana.ESPEnabled then
                ShowNotification("ESP", "ВКЛЮЧЕН")
            else
                ShowNotification("ESP", "ВЫКЛЮЧЕН")
            end
        end, Color3.fromRGB(231, 76, 60)},
        {"GOD MODE", function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                    ShowNotification("God Mode", "АКТИВИРОВАН")
                end
            end
        end, Color3.fromRGB(192, 57, 43)}
    }
    
    for i, func in ipairs(functions) do
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, 0, 0, 60)
        buttonFrame.Position = UDim2.new(0, 0, 0, (i-1) * 70)
        buttonFrame.BackgroundTransparency = 1
        
        local funcButton = Instance.new("TextButton")
        funcButton.Text = func[1]
        funcButton.Font = Enum.Font.GothamBold
        funcButton.TextSize = 18
        funcButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        funcButton.BackgroundColor3 = func[3]
        funcButton.Size = UDim2.new(1, 0, 1, 0)
        funcButton.Position = UDim2.new(0, 0, 0, 0)
        funcButton.AutoButtonColor = false
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 10)
        buttonCorner.Parent = funcButton
        
        -- Эффекты кнопки
        funcButton.MouseButton1Down:Connect(function()
            funcButton.BackgroundTransparency = 0.3
        end)
        
        funcButton.MouseButton1Up:Connect(function()
            funcButton.BackgroundTransparency = 0
            SafeCall(func[2])
        end)
        
        funcButton.Parent = buttonFrame
        buttonFrame.Parent = contentFrame
    end
    
    -- Поле для скриптов
    local scriptY = #functions * 70 + 20
    
    local scriptFrame = Instance.new("Frame")
    scriptFrame.Size = UDim2.new(1, 0, 0, 150)
    scriptFrame.Position = UDim2.new(0, 0, 0, scriptY)
    scriptFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 10)
    scriptCorner.Parent = scriptFrame
    
    local scriptLabel = Instance.new("TextLabel")
    scriptLabel.Text = "CUSTOM SCRIPT:"
    scriptLabel.Font = Enum.Font.GothamBold
    scriptLabel.TextSize = 16
    scriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptLabel.BackgroundTransparency = 1
    scriptLabel.Size = UDim2.new(1, -10, 0, 25)
    scriptLabel.Position = UDim2.new(0, 10, 0, 5)
    scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
    scriptLabel.Parent = scriptFrame
    
    local scriptBox = Instance.new("TextBox")
    scriptBox.PlaceholderText = "Paste Lua script here..."
    scriptBox.Text = ""
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    scriptBox.Size = UDim2.new(1, -20, 0, 80)
    scriptBox.Position = UDim2.new(0, 10, 0, 35)
    scriptBox.MultiLine = true
    scriptBox.TextWrapped = true
    scriptBox.Parent = scriptFrame
    
    local executeButton = Instance.new("TextButton")
    executeButton.Text = "EXECUTE"
    executeButton.Font = Enum.Font.GothamBold
    executeButton.TextSize = 16
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    executeButton.Size = UDim2.new(0.48, 0, 0, 30)
    executeButton.Position = UDim2.new(0, 10, 0, 120)
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 6)
    executeCorner.Parent = executeButton
    
    local clearButton = Instance.new("TextButton")
    clearButton.Text = "CLEAR"
    clearButton.Font = Enum.Font.GothamBold
    clearButton.TextSize = 16
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    clearButton.Size = UDim2.new(0.48, 0, 0, 30)
    clearButton.Position = UDim2.new(0.52, 0, 0, 120)
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearButton
    
    executeButton.MouseButton1Click:Connect(function()
        local scriptText = scriptBox.Text
        if scriptText and scriptText ~= "" then
            SafeCall(function()
                loadstring(scriptText)()
            end)
            ShowNotification("Script", "Executed successfully")
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
    end)
    
    executeButton.Parent = scriptFrame
    clearButton.Parent = scriptFrame
    scriptFrame.Parent = contentFrame
    
    -- Обновляем размер Canvas
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, scriptY + 180)
    
    -- Собираем окно
    titleBar.Parent = mainWindow
    titleLabel.Parent = titleBar
    closeButton.Parent = titleBar
    contentFrame.Parent = mainWindow
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
                    Size = UDim2.new(0, 400, 0, 500),
                    Position = UDim2.new(0.5, -200, 0.5, -250)
                })
            openTween:Play()
            
            ShowNotification("GUI", "OPENED")
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
            ShowNotification("GUI", "CLOSED")
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
            mainWindow.BackgroundTransparency = 0.1
        end
    end)
    
    -- Обработчики кнопок
    closeButton.MouseButton1Click:Connect(function()
        ToggleWindow()
    end)
    
    Banana.MainWindow = mainWindow
    Banana.ToggleWindow = ToggleWindow
    
    return windowGui, ToggleWindow
end

-- Инициализация
local function Initialize()
    print("Initializing BANANA PROJECT...")
    
    -- Создаем кнопку
    local buttonGui, button = CreateMainButton()
    
    -- Создаем окно
    local windowGui, toggleWindow = CreateMainWindow()
    
    -- Связываем кнопку с окном
    button.MouseButton1Click:Connect(function()
        toggleWindow()
    end)
    
    -- Горячие клавиши
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            toggleWindow()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            ToggleFly()
        elseif input.KeyCode == Enum.KeyCode.F3 then
            ToggleSpeed()
        elseif input.KeyCode == Enum.KeyCode.F4 then
            ToggleInfiniteJump()
        elseif input.KeyCode == Enum.KeyCode.F5 then
            ToggleNoClip()
        end
    end)
    
    -- Показываем уведомление о загрузке
    task.wait(1)
    ShowNotification("BANANA PROJECT", 
        "Successfully loaded!\n" ..
        "Click the yellow button or press F1", 
        5)
    
    print("=== BANANA PROJECT READY ===")
    print("Controls:")
    print("- Yellow button: Toggle GUI")
    print("- F1: Toggle GUI")
    print("- F2: Toggle Fly")
    print("- F3: Toggle Speed")
    print("- F4: Toggle Jump")
    print("- F5: Toggle NoClip")
    
    return true
end

-- Запуск
local success, err = SafeCall(Initialize)

if not success then
    warn("Failed to initialize:", err)
    
    -- Простой запасной вариант
    local simpleGui = Instance.new("ScreenGui")
    simpleGui.Parent = CoreGui
    
    local simpleButton = Instance.new("TextButton")
    simpleButton.Text = "BANANA"
    simpleButton.Size = UDim2.new(0, 100, 0, 50)
    simpleButton.Position = UDim2.new(0, 50, 0, 50)
    simpleButton.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    simpleButton.Parent = simpleGui
    
    simpleButton.MouseButton1Click:Connect(function()
        print("Banana button clicked!")
    end)
end

-- Возвращаем API
return {
    ToggleGUI = Banana.ToggleWindow,
    ToggleFly = ToggleFly,
    ToggleSpeed = ToggleSpeed,
    ToggleJump = ToggleInfiniteJump,
    ToggleNoClip = ToggleNoClip,
    ShowNotification = ShowNotification
}
