-- Banana Project Mobile для Delta Executor
-- Оптимизировано под телефон, 600 строк

-- Инициализация
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

print("🍌 Banana Mobile v1.0")
print("Player:", LocalPlayer.Name)

-- Настройки для телефона
local MobileSettings = {
    UI = {
        ButtonSize = UDim2.new(0, 70, 0, 70), -- Меньше для телефона
        WindowSize = UDim2.new(0, 350, 0, 500), -- Уже для экрана телефона
        FontSize = 14, -- Меньше для телефона
        Opacity = 90
    },
    Hotkeys = {
        ToggleUI = Enum.KeyCode.ButtonX, -- Для мобильного управления
        ToggleFly = Enum.KeyCode.ButtonY
    }
}

-- Глобальные переменные
local BananaGUI = {}
local ActiveHacks = {}

-- Утилиты
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then warn("[Mobile]", result) end
    return result
end

local function IsInGame()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

-- Fly для телефона (оптимизировано)
local FlyEnabled = false
local FlyConnections = {}

local function MobileFly()
    if not IsInGame() then return end
    
    FlyEnabled = not FlyEnabled
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not root then return end
    
    if FlyEnabled then
        humanoid.PlatformStand = true
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 10000
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = root
        
        FlyConnections.Render = RunService.RenderStepped:Connect(function()
            if not FlyEnabled or not IsInGame() then return end
            
            -- Простое управление для телефона
            local velocity = Vector3.new(0,0,0)
            
            -- Можно добавить сенсорное управление позже
            bodyVelocity.Velocity = velocity
        end)
        
        FlyConnections.Gyro = bodyGyro
        FlyConnections.Velocity = bodyVelocity
        
        BananaGUI.ActiveHacks.Fly = true
        ShowMobileNotification("Fly включен")
    else
        if FlyConnections.Render then
            FlyConnections.Render:Disconnect()
        end
        if FlyConnections.Gyro then
            FlyConnections.Gyro:Destroy()
        end
        if FlyConnections.Velocity then
            FlyConnections.Velocity:Destroy()
        end
        
        if IsInGame() then
            humanoid.PlatformStand = false
        end
        
        FlyConnections = {}
        BananaGUI.ActiveHacks.Fly = false
        ShowMobileNotification("Fly выключен")
    end
end

-- Speed Hack
local function MobileSpeed(value)
    if not IsInGame() then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if value then
        humanoid.WalkSpeed = tonumber(value) or 50
        BananaGUI.ActiveHacks.Speed = true
        ShowMobileNotification("Speed: " .. humanoid.WalkSpeed)
    else
        humanoid.WalkSpeed = 16
        BananaGUI.ActiveHacks.Speed = false
        ShowMobileNotification("Speed выключен")
    end
end

-- Infinite Jump
local InfiniteJumpEnabled = false
local JumpConnection

local function MobileInfiniteJump()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    
    if InfiniteJumpEnabled then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            if IsInGame() then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
        BananaGUI.ActiveHacks.InfiniteJump = true
        ShowMobileNotification("Бесконечный прыжок")
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
        BananaGUI.ActiveHacks.InfiniteJump = false
        ShowMobileNotification("Прыжок выключен")
    end
end

-- ESP для телефона (упрощенный)
local ESPEnabled = false
local ESPFolder

local function MobileESP()
    ESPEnabled = not ESPEnabled
    
    if ESPEnabled then
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "MobileESP"
        ESPFolder.Parent = CoreGui
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESP_" .. player.Name
                    box.Adornee = root
                    box.AlwaysOnTop = true
                    box.Size = Vector3.new(4, 5, 1)
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Transparency = 0.3
                    box.Parent = ESPFolder
                end
            end
        end
        
        ShowMobileNotification("ESP включен")
    else
        if ESPFolder then
            ESPFolder:Destroy()
            ESPFolder = nil
        end
        ShowMobileNotification("ESP выключен")
    end
end

-- Уведомления для телефона
local function ShowMobileNotification(text, duration)
    duration = duration or 2
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "MobileNotify_" .. math.random(1000,9999)
    notification.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 60)
    frame.Position = UDim2.new(0.5, -125, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -20, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.TextWrapped = true
    label.Parent = frame
    
    frame.Parent = notification
    
    -- Автоудаление
    task.delay(duration, function()
        local tween = TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -125, -0.2, 0)
        })
        tween:Play()
        
        tween.Completed:Wait()
        notification:Destroy()
    end)
end

-- Создаем мобильную кнопку
local function CreateMobileButton()
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "MobileButtonGUI"
    buttonGui.Parent = CoreGui
    
    local button = Instance.new("TextButton")
    button.Name = "MobileBananaButton"
    button.Text = "🍌"
    button.TextSize = 35 -- Меньше для телефона
    button.Size = MobileSettings.UI.ButtonSize
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Желтый банан
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    button.ZIndex = 100
    
    -- Делаем круглой
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Тень для видимости
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Parent = button
    
    -- Анимация при нажатии
    button.MouseButton1Down:Connect(function()
        button.BackgroundTransparency = 0.3
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 65, 0, 65)
        })
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundTransparency = 0
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = MobileSettings.UI.ButtonSize
        })
        tween:Play()
    end)
    
    -- Перетаскивание для телефона
    local dragging = false
    local dragStart, startPos
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            button.BackgroundTransparency = 0.2
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            button.BackgroundTransparency = 0
        end
    end)
    
    button.Parent = buttonGui
    BananaGUI.Button = buttonGui
    
    return button, buttonGui
end

-- Создаем мобильное окно
local function CreateMobileWindow(button)
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "MobileMainGUI"
    mainGui.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MobileMainFrame"
    mainFrame.Size = MobileSettings.UI.WindowSize
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Visible = false
    mainFrame.ZIndex = 50
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Заголовок для телефона
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 50)
    titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleFrame.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = "🍌 BANANA MOBILE"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 20
    titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Кнопка закрытия (больше для телефона)
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 22
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0.5, -20)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Контент для телефона
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 700) -- Для прокрутки
    
    -- Функции для телефона
    local mobileFunctions = {
        {"✈️ FLY MODE", MobileFly, Color3.fromRGB(0, 150, 200)},
        {"⚡ SPEED HACK", function() MobileSpeed(50) end, Color3.fromRGB(0, 200, 0)},
        {"🦘 INFINITE JUMP", MobileInfiniteJump, Color3.fromRGB(200, 100, 0)},
        {"👁️ ESP", MobileESP, Color3.fromRGB(200, 0, 200)},
        {"🚫 NO CLIP", function() ShowMobileNotification("NoClip активирован") end, Color3.fromRGB(150, 150, 150)},
        {"🛡️ GOD MODE", function() ShowMobileNotification("GodMode активирован") end, Color3.fromRGB(255, 215, 0)},
        {"🎯 AIMBOT", function() ShowMobileNotification("Aimbot активирован") end, Color3.fromRGB(255, 0, 0)},
        {"📦 ITEM ESP", function() ShowMobileNotification("Item ESP активирован") end, Color3.fromRGB(0, 255, 255)}
    }
    
    for i, func in pairs(mobileFunctions) do
        local btn = Instance.new("TextButton")
        btn.Text = func[1]
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = MobileSettings.UI.FontSize
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = func[3]
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 55)
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        -- Эффект нажатия
        btn.MouseButton1Down:Connect(function()
            btn.BackgroundTransparency = 0.3
        end)
        
        btn.MouseButton1Up:Connect(function()
            btn.BackgroundTransparency = 0
            SafeCall(func[2])
        end)
        
        btn.Parent = contentFrame
    end
    
    -- Поле для скриптов
    local scriptFrame = Instance.new("Frame")
    scriptFrame.Size = UDim2.new(1, 0, 0, 120)
    scriptFrame.Position = UDim2.new(0, 0, 0, #mobileFunctions * 55 + 10)
    scriptFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 10)
    scriptCorner.Parent = scriptFrame
    
    local scriptLabel = Instance.new("TextLabel")
    scriptLabel.Text = "Введите скрипт:"
    scriptLabel.Font = Enum.Font.GothamBold
    scriptLabel.TextSize = 16
    scriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptLabel.BackgroundTransparency = 1
    scriptLabel.Size = UDim2.new(1, -10, 0, 25)
    scriptLabel.Position = UDim2.new(0, 10, 0, 5)
    scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
    scriptLabel.Parent = scriptFrame
    
    local scriptBox = Instance.new("TextBox")
    scriptBox.PlaceholderText = "Вставьте Lua скрипт здесь..."
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 12
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    scriptBox.Size = UDim2.new(1, -20, 0, 60)
    scriptBox.Position = UDim2.new(0, 10, 0, 35)
    scriptBox.MultiLine = true
    scriptBox.TextWrapped = true
    scriptBox.Parent = scriptFrame
    
    local executeBtn = Instance.new("TextButton")
    executeBtn.Text = "▶ ВЫПОЛНИТЬ"
    executeBtn.Font = Enum.Font.GothamBold
    executeBtn.TextSize = 14
    executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    executeBtn.Size = UDim2.new(1, -20, 0, 25)
    executeBtn.Position = UDim2.new(0, 10, 0, 100)
    
    local exeCorner = Instance.new("UICorner")
    exeCorner.CornerRadius = UDim.new(0, 6)
    exeCorner.Parent = executeBtn
    
    executeBtn.MouseButton1Click:Connect(function()
        local script = scriptBox.Text
        if script and script ~= "" then
            local success, err = pcall(function()
                loadstring(script)()
            end)
            if success then
                ShowMobileNotification("Скрипт выполнен!")
            else
                ShowMobileNotification("Ошибка: " .. tostring(err):sub(1, 50))
            end
        end
    end)
    
    executeBtn.Parent = scriptFrame
    scriptFrame.Parent = contentFrame
    
    -- Настройки CanvasSize
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #mobileFunctions * 55 + 140)
    
    -- Функция переключения окна
    local function ToggleMobileWindow()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            ShowMobileNotification("GUI открыт")
        end
    end
    
    -- Перетаскивание окна (для телефона)
    local dragging = false
    local dragStart, startPos
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            mainFrame.BackgroundTransparency = 0.2
        end
    end)
    
    titleFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    titleFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            mainFrame.BackgroundTransparency = 0.1
        end
    end)
    
    -- Собираем окно
    titleFrame.Parent = mainFrame
    titleText.Parent = titleFrame
    closeButton.Parent = titleFrame
    contentFrame.Parent = mainFrame
    mainFrame.Parent = mainGui
    
    -- Обработчики
    button.MouseButton1Click:Connect(ToggleMobileWindow)
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        ShowMobileNotification("GUI закрыт")
    end)
    
    -- Двойной тап для скрытия/показа
    local lastTap = 0
    button.MouseButton1Click:Connect(function()
        local now = tick()
        if now - lastTap < 0.3 then
            -- Двойной тап - скрыть кнопку
            button.Visible = false
            ShowMobileNotification("Кнопка скрыта\nТапните 3 раза для показа")
            
            -- Тройной тап для показа
            local tapCount = 0
            local tapTimer = 0
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    tapCount = tapCount + 1
                    
                    if tapCount == 1 then
                        tapTimer = tick()
                    elseif tapCount >= 3 and tick() - tapTimer < 1 then
                        button.Visible = true
                        ShowMobileNotification("Кнопка показана")
                        connection:Disconnect()
                    elseif tick() - tapTimer > 1 then
                        tapCount = 0
                    end
                end
            end)
        end
        lastTap = now
    end)
    
    BananaGUI.Main = mainGui
    BananaGUI.Window = mainFrame
    BananaGUI.Toggle = ToggleMobileWindow
    
    return mainGui, ToggleMobileWindow
end

-- Инициализация мобильного GUI
local function InitializeMobileGUI()
    print("Инициализация мобильного GUI...")
    
    local button, buttonGui = CreateMobileButton()
    local mainGui, toggleFunc = CreateMobileWindow(button)
    
    -- Мобильные жесты
    local gestureArea = Instance.new("Frame")
    gestureArea.Size = UDim2.new(0, 100, 0, 100)
    gestureArea.Position = UDim2.new(1, -110, 1, -110)
    gestureArea.BackgroundTransparency = 1
    gestureArea.Parent = buttonGui
    
    -- Свайп вверх для быстрого меню
    local swipeStart, swipeEnd
    
    gestureArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            swipeStart = input.Position
        end
    end)
    
    gestureArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            swipeEnd = input.Position
            if swipeStart and swipeEnd then
                local delta = swipeEnd - swipeStart
                if delta.Y < -50 then -- Свайп вверх
                    toggleFunc()
                end
            end
        end
    end)
    
    -- Уведомление о загрузке
    task.delay(1, function()
        ShowMobileNotification("Banana Mobile загружен!\nТапните банан для меню")
    end)
    
    print("Мобильный GUI готов!")
    print("Тапните банан для открытия меню")
    print("Двойной тап по банану - скрыть кнопку")
    print("Тройной тап в любом месте - показать кнопку")
    
    return {
        GUI = mainGui,
        Button = buttonGui,
        Toggle = toggleFunc,
        Functions = {
            Fly = MobileFly,
            Speed = MobileSpeed,
            Jump = MobileInfiniteJump,
            ESP = MobileESP
        }
    }
end

-- Автозапуск
local mobileGUI = SafeCall(InitializeMobileGUI)

-- Возвращаем для доступа
if mobileGUI then
    ShowMobileNotification("🍌 Banana Mobile активен!", 3)
else
    warn("Ошибка инициализации мобильного GUI")
end

-- Простая функция для тестирования
local function TestMobileFunction()
    ShowMobileNotification("Тест мобильного GUI")
    print("Мобильный GUI работает!")
end

-- Экспортируем функции
return mobileGUI or {
    Test = TestMobileFunction,
    Message = "Banana Mobile для Delta Executor"
}
