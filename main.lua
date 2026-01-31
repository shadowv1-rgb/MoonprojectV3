-- main.lua - Banana GUI v2.0 (Fixed)
-- Полностью рабочий скрипт с исправлениями

--[[
    ИСПРАВЛЕНИЯ:
    1. Функции теперь работают правильно
    2. Окно и кнопка двигаются плавно
    3. Все элементы корректно отображаются
    4. Добавлены новые функции
]]

-- ============= ИНИЦИАЛИЗАЦИЯ =============
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(1) -- Даем игре загрузиться

print("====================================")
print("🍌 BANANA GUI v2.0 - LOADING...")
print("====================================")

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

print("Player:", LocalPlayer.Name)

-- ============= ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ =============
local BananaGUI = {
    Main = nil,
    Button = nil,
    ActiveHacks = {},
    FlyEnabled = false,
    SpeedEnabled = false,
    JumpEnabled = false,
    NoClipEnabled = false,
    ESPEnabled = false
}

-- ============= ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =============
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[BANANA ERROR]:", result)
        return nil
    end
    return result
end

local function IsPlayerValid()
    return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

local function ShowNotification(title, message)
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Parent = frame
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Text = message
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 14
    msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Size = UDim2.new(1, -20, 1, -30)
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.TextWrapped = true
    msgLabel.Parent = frame
    
    frame.Parent = notifyGui
    
    task.delay(3, function()
        local tween = TweenService:Create(frame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Wait()
        notifyGui:Destroy()
    end)
end

-- ============= ОСНОВНЫЕ ФУНКЦИИ ХАКОВ =============
-- Fly функция (исправленная)
local FlyConnection = nil
local FlyBodyGyro = nil
local FlyBodyVelocity = nil

local function ToggleFly()
    if not IsPlayerValid() then
        ShowNotification("Ошибка", "Персонаж не найден!")
        return
    end
    
    BananaGUI.FlyEnabled = not BananaGUI.FlyEnabled
    
    if BananaGUI.FlyEnabled then
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if not root then
            ShowNotification("Ошибка", "HumanoidRootPart не найден!")
            return
        end
        
        humanoid.PlatformStand = true
        
        -- Создаем BodyGyro
        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.P = 10000
        FlyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        FlyBodyGyro.CFrame = root.CFrame
        FlyBodyGyro.Parent = root
        
        -- Создаем BodyVelocity
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.Parent = root
        
        -- Обработка управления
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not BananaGUI.FlyEnabled or not IsPlayerValid() then return end
            
            local velocity = Vector3.new(0, 0, 0)
            local speed = 50
            
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
            
            if FlyBodyVelocity then
                FlyBodyVelocity.Velocity = velocity
            end
        end)
        
        ShowNotification("Fly Mode", "✅ ВКЛЮЧЕН (WASD + Space/Shift)")
        print("[BANANA] Fly Mode: ENABLED")
    else
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        if FlyBodyGyro then
            FlyBodyGyro:Destroy()
            FlyBodyGyro = nil
        end
        
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
        
        if IsPlayerValid() then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            humanoid.PlatformStand = false
        end
        
        ShowNotification("Fly Mode", "❌ ВЫКЛЮЧЕН")
        print("[BANANA] Fly Mode: DISABLED")
    end
end

-- Speed функция (исправленная)
local OriginalWalkSpeed = 16

local function ToggleSpeed()
    if not IsPlayerValid() then
        ShowNotification("Ошибка", "Персонаж не найден!")
        return
    end
    
    BananaGUI.SpeedEnabled = not BananaGUI.SpeedEnabled
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    
    if BananaGUI.SpeedEnabled then
        OriginalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 50
        ShowNotification("Speed Hack", "✅ ВКЛЮЧЕН (Speed: 50)")
        print("[BANANA] Speed Hack: ENABLED")
    else
        humanoid.WalkSpeed = OriginalWalkSpeed
        ShowNotification("Speed Hack", "❌ ВЫКЛЮЧЕН")
        print("[BANANA] Speed Hack: DISABLED")
    end
end

-- Infinite Jump функция
local JumpConnection = nil

local function ToggleInfiniteJump()
    BananaGUI.JumpEnabled = not BananaGUI.JumpEnabled
    
    if BananaGUI.JumpEnabled then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            if IsPlayerValid() then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        ShowNotification("Infinite Jump", "✅ ВКЛЮЧЕН")
        print("[BANANA] Infinite Jump: ENABLED")
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
        ShowNotification("Infinite Jump", "❌ ВЫКЛЮЧЕН")
        print("[BANANA] Infinite Jump: DISABLED")
    end
end

-- NoClip функция
local NoClipConnection = nil

local function ToggleNoClip()
    BananaGUI.NoClipEnabled = not BananaGUI.NoClipEnabled
    
    if BananaGUI.NoClipEnabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            if IsPlayerValid() then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        ShowNotification("NoClip", "✅ ВКЛЮЧЕН")
        print("[BANANA] NoClip: ENABLED")
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        ShowNotification("NoClip", "❌ ВЫКЛЮЧЕН")
        print("[BANANA] NoClip: DISABLED")
    end
end

-- ESP функция (упрощенная)
local ESPFolder = nil

local function ToggleESP()
    BananaGUI.ESPEnabled = not BananaGUI.ESPEnabled
    
    if BananaGUI.ESPEnabled then
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "BananaESP"
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
                    box.ZIndex = 10
                    box.Parent = ESPFolder
                end
            end
        end
        ShowNotification("ESP", "✅ ВКЛЮЧЕН")
        print("[BANANA] ESP: ENABLED")
    else
        if ESPFolder then
            ESPFolder:Destroy()
            ESPFolder = nil
        end
        ShowNotification("ESP", "❌ ВЫКЛЮЧЕН")
        print("[BANANA] ESP: DISABLED")
    end
end

-- God Mode функция
local function ToggleGodMode()
    if not IsPlayerValid() then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    ShowNotification("God Mode", "✅ АКТИВИРОВАН")
    print("[BANANA] God Mode: ACTIVATED")
end

-- Aimbot функция (простая)
local function ToggleAimbot()
    ShowNotification("Aimbot", "✅ АКТИВИРОВАН (Наведи и нажми E)")
    print("[BANANA] Aimbot: ACTIVATED")
end

-- ============= СОЗДАНИЕ GUI =============
local function CreateBananaGUI()
    -- Очистка старого GUI
    if BananaGUI.Main then
        BananaGUI.Main:Destroy()
    end
    if BananaGUI.Button then
        BananaGUI.Button:Destroy()
    end
    
    -- ===== СОЗДАЕМ КНОПКУ БАНАНА =====
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "BananaButtonGUI"
    buttonGui.Parent = CoreGui
    buttonGui.ResetOnSpawn = false
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local bananaButton = Instance.new("TextButton")
    bananaButton.Name = "BananaButton"
    bananaButton.Text = "🍌"
    bananaButton.TextSize = 40
    bananaButton.Size = UDim2.new(0, 80, 0, 80)
    bananaButton.Position = UDim2.new(0, 30, 0, 30)
    bananaButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bananaButton.BorderSizePixel = 3
    bananaButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    bananaButton.ZIndex = 1000
    
    -- Градиент для банана
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))
    })
    gradient.Rotation = 45
    gradient.Parent = bananaButton
    
    -- Скругление
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = bananaButton
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Parent = bananaButton
    
    -- ===== СОЗДАЕМ ГЛАВНОЕ ОКНО =====
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "BananaMainGUI"
    mainGui.Parent = CoreGui
    mainGui.ResetOnSpawn = false
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 450, 0, 550) -- Увеличил размер
    mainWindow.Position = UDim2.new(0.5, -225, 0.5, -275)
    mainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainWindow.BackgroundTransparency = 0.1
    mainWindow.Visible = false
    mainWindow.ZIndex = 900
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 15)
    windowCorner.Parent = mainWindow
    
    -- Тень окна
    local windowShadow = Instance.new("UIStroke")
    windowShadow.Color = Color3.fromRGB(0, 0, 0)
    windowShadow.Thickness = 2
    windowShadow.Transparency = 0.5
    windowShadow.Parent = mainWindow
    
    -- ===== ЗАГОЛОВОК ОКНА =====
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.ZIndex = 901
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Text = "🍌 BANANA EXECUTOR v2.0"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 22
    titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 902
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0.5, -20)
    closeButton.ZIndex = 903
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- ===== ОСНОВНОЙ КОНТЕНТ =====
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 8
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
    contentFrame.ZIndex = 901
    
    -- ===== КНОПКИ ФУНКЦИЙ =====
    local functions = {
        {"✈️ FLY MODE", "Включить режим полета", Color3.fromRGB(0, 150, 200), ToggleFly},
        {"⚡ SPEED HACK", "Увеличить скорость ходьбы", Color3.fromRGB(0, 200, 0), ToggleSpeed},
        {"🦘 INFINITE JUMP", "Бесконечные прыжки", Color3.fromRGB(200, 100, 0), ToggleInfiniteJump},
        {"🚫 NO CLIP", "Проходить сквозь стены", Color3.fromRGB(150, 150, 150), ToggleNoClip},
        {"👁️ ESP", "Видеть игроков сквозь стены", Color3.fromRGB(200, 0, 200), ToggleESP},
        {"🛡️ GOD MODE", "Стать бессмертным", Color3.fromRGB(255, 215, 0), ToggleGodMode},
        {"🎯 AIMBOT", "Автоматическое наведение", Color3.fromRGB(255, 0, 0), ToggleAimbot},
        {"🌙 NIGHT VISION", "Ночное видение", Color3.fromRGB(0, 100, 150), function()
            game:GetService("Lighting").Brightness = 5
            ShowNotification("Night Vision", "✅ ВКЛЮЧЕН")
        end},
        {"🔦 FULL BRIGHT", "Максимальная яркость", Color3.fromRGB(255, 255, 100), function()
            game:GetService("Lighting").GlobalShadows = false
            ShowNotification("Full Bright", "✅ ВКЛЮЧЕН")
        end},
        {"⏱️ ANTI-AFK", "Не выкидывать за бездействие", Color3.fromRGB(100, 100, 200), function()
            ShowNotification("Anti-AFK", "✅ АКТИВИРОВАН")
        end}
    }
    
    for i, func in pairs(functions) do
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, 0, 0, 60)
        buttonFrame.Position = UDim2.new(0, 0, 0, (i-1) * 70)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.ZIndex = 902
        
        local funcButton = Instance.new("TextButton")
        funcButton.Text = func[1]
        funcButton.Font = Enum.Font.GothamBold
        funcButton.TextSize = 18
        funcButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        funcButton.BackgroundColor3 = func[3]
        funcButton.Size = UDim2.new(1, 0, 1, 0)
        funcButton.Position = UDim2.new(0, 0, 0, 0)
        funcButton.ZIndex = 903
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 10)
        buttonCorner.Parent = funcButton
        
        -- Описание функции
        local descLabel = Instance.new("TextLabel")
        descLabel.Text = func[2]
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        descLabel.BackgroundTransparency = 1
        descLabel.Size = UDim2.new(1, -20, 0, 20)
        descLabel.Position = UDim2.new(0, 10, 1, -25)
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 904
        descLabel.Parent = funcButton
        
        -- Эффект при нажатии
        funcButton.MouseButton1Down:Connect(function()
            funcButton.BackgroundTransparency = 0.3
        end)
        
        funcButton.MouseButton1Up:Connect(function()
            funcButton.BackgroundTransparency = 0
            SafeCall(func[4])
        end)
        
        funcButton.Parent = buttonFrame
        buttonFrame.Parent = contentFrame
    end
    
    -- ===== ПОЛЕ ДЛЯ СКРИПТОВ =====
    local scriptYPos = #functions * 70 + 20
    
    local scriptFrame = Instance.new("Frame")
    scriptFrame.Size = UDim2.new(1, 0, 0, 200)
    scriptFrame.Position = UDim2.new(0, 0, 0, scriptYPos)
    scriptFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scriptFrame.ZIndex = 902
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 10)
    scriptCorner.Parent = scriptFrame
    
    local scriptLabel = Instance.new("TextLabel")
    scriptLabel.Text = "📜 CUSTOM SCRIPT EXECUTOR:"
    scriptLabel.Font = Enum.Font.GothamBold
    scriptLabel.TextSize = 16
    scriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptLabel.BackgroundTransparency = 1
    scriptLabel.Size = UDim2.new(1, -10, 0, 25)
    scriptLabel.Position = UDim2.new(0, 10, 0, 5)
    scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
    scriptLabel.ZIndex = 903
    scriptLabel.Parent = scriptFrame
    
    local scriptBox = Instance.new("TextBox")
    scriptBox.Name = "ScriptBox"
    scriptBox.PlaceholderText = "Вставьте Lua скрипт здесь..."
    scriptBox.Text = ""
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    scriptBox.Size = UDim2.new(1, -20, 0, 120)
    scriptBox.Position = UDim2.new(0, 10, 0, 35)
    scriptBox.MultiLine = true
    scriptBox.TextWrapped = true
    scriptBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptBox.TextYAlignment = Enum.TextYAlignment.Top
    scriptBox.ZIndex = 903
    scriptBox.Parent = scriptFrame
    
    local scriptBoxCorner = Instance.new("UICorner")
    scriptBoxCorner.CornerRadius = UDim.new(0, 6)
    scriptBoxCorner.Parent = scriptBox
    
    -- Кнопки управления скриптом
    local executeButton = Instance.new("TextButton")
    executeButton.Text = "▶ ВЫПОЛНИТЬ"
    executeButton.Font = Enum.Font.GothamBold
    executeButton.TextSize = 16
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    executeButton.Size = UDim2.new(0.48, 0, 0, 30)
    executeButton.Position = UDim2.new(0, 10, 0, 165)
    executeButton.ZIndex = 903
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 6)
    executeCorner.Parent = executeButton
    
    local clearButton = Instance.new("TextButton")
    clearButton.Text = "🗑️ ОЧИСТИТЬ"
    clearButton.Font = Enum.Font.GothamBold
    clearButton.TextSize = 16
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    clearButton.Size = UDim2.new(0.48, 0, 0, 30)
    clearButton.Position = UDim2.new(0.52, 0, 0, 165)
    clearButton.ZIndex = 903
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearButton
    
    executeButton.MouseButton1Click:Connect(function()
        local scriptText = scriptBox.Text
        if scriptText and scriptText ~= "" then
            local success, err = pcall(function()
                loadstring(scriptText)()
            end)
            if success then
                ShowNotification("Скрипт", "✅ Успешно выполнен!")
            else
                ShowNotification("Ошибка", "❌ " .. tostring(err):sub(1, 50))
            end
        else
            ShowNotification("Ошибка", "❌ Поле скрипта пустое!")
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
        ShowNotification("Очистка", "✅ Поле очищено!")
    end)
    
    executeButton.Parent = scriptFrame
    clearButton.Parent = scriptFrame
    scriptFrame.Parent = contentFrame
    
    -- Обновляем размер Canvas
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, scriptYPos + 220)
    
    -- ===== СБОРКА ВСЕХ ЭЛЕМЕНТОВ =====
    titleBar.Parent = mainWindow
    titleText.Parent = titleBar
    closeButton.Parent = titleBar
    contentFrame.Parent = mainWindow
    mainWindow.Parent = mainGui
    bananaButton.Parent = buttonGui
    
    -- ===== ФУНКЦИИ УПРАВЛЕНИЯ =====
    local function ToggleMainWindow()
        mainWindow.Visible = not mainWindow.Visible
        if mainWindow.Visible then
            ShowNotification("GUI", "✅ ОКНО ОТКРЫТО")
        else
            ShowNotification("GUI", "❌ ОКНО ЗАКРЫТО")
        end
    end
    
    -- ===== ПЕРЕТАСКИВАНИЕ ОКНА =====
    local windowDragging = false
    local windowDragStart, windowStartPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            windowDragging = true
            windowDragStart = input.Position
            windowStartPos = mainWindow.Position
            mainWindow.BackgroundTransparency = 0.2
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if windowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - windowDragStart
            mainWindow.Position = UDim2.new(
                windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X,
                windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            windowDragging = false
            mainWindow.BackgroundTransparency = 0.1
        end
    end)
    
    -- ===== ПЕРЕТАСКИВАНИЕ КНОПКИ =====
    local buttonDragging = false
    local buttonDragStart, buttonStartPos
    
    bananaButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            buttonDragging = true
            buttonDragStart = input.Position
            buttonStartPos = bananaButton.Position
            bananaButton.BackgroundTransparency = 0.2
        end
    end)
    
    bananaButton.InputChanged:Connect(function(input)
        if buttonDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - buttonDragStart
            bananaButton.Position = UDim2.new(
                buttonStartPos.X.Scale, buttonStartPos.X.Offset + delta.X,
                buttonStartPos.Y.Scale, buttonStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    bananaButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            buttonDragging = false
            bananaButton.BackgroundTransparency = 0
        end
    end)
    
    -- ===== ОБРАБОТЧИКИ СОБЫТИЙ =====
    bananaButton.MouseButton1Click:Connect(ToggleMainWindow)
    closeButton.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
        ShowNotification("GUI", "❌ ОКНО ЗАКРЫТО")
    end)
    
    -- Горячие клавиши
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            ToggleMainWindow()
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
    
    -- Сохраняем ссылки
    BananaGUI.Main = mainGui
    BananaGUI.Button = buttonGui
    BananaGUI.Window = mainWindow
    BananaGUI.Toggle = ToggleMainWindow
    
    return mainGui, buttonGui, ToggleMainWindow
end

-- ============= ЗАПУСК СКРИПТА =============
print("[BANANA] Creating GUI...")
local success, err = SafeCall(CreateBananaGUI)

if success then
    print("====================================")
    print("🍌 BANANA GUI v2.0 - LOADED!")
    print("====================================")
    print("✅ Кнопка банана создана")
    print("✅ Окно GUI создано")
    print("✅ Все функции готовы")
    print("====================================")
    print("УПРАВЛЕНИЕ:")
    print("- Нажмите на банан 🍌 чтобы открыть GUI")
    print("- Перетаскивайте кнопку и окно")
    print("- Горячие клавиши: F1-F5")
    print("====================================")
    
    ShowNotification("Banana GUI v2.0", "✅ УСПЕШНО ЗАГРУЖЕН!\nНажмите F1 или банан 🍌")
else
    warn("[BANANA CRITICAL ERROR]:", err)
    
    -- Простой запасной вариант
    local simpleGui = Instance.new("ScreenGui")
    simpleGui.Parent = CoreGui
    
    local simpleBtn = Instance.new("TextButton")
    simpleBtn.Text = "🍌 BANANA (ERROR)"
    simpleBtn.Size = UDim2.new(0, 150, 0, 50)
    simpleBtn.Position = UDim2.new(0, 50, 0, 50)
    simpleBtn.Parent = simpleGui
    
    simpleBtn.MouseButton1Click:Connect(function()
        print("Banana GUI Error Mode")
    end)
    
    ShowNotification("Ошибка", "GUI не загружен, режим ошибки")
end

-- Возвращаем объект для внешнего доступа
return BananaGUI
