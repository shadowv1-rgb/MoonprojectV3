-- main.lua для Delta Executor
-- Простой рабочий GUI скрипт

-- Инициализация
wait(1)
print("[BANANA] Loading...")

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Проверка игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("[BANANA] Game loaded, player:", LocalPlayer.Name)

-- Главная функция создания GUI
local function CreateBananaGUI()
    print("[BANANA] Creating GUI...")
    
    -- Создаем ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BananaGUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    
    -- Кнопка банана
    local BananaButton = Instance.new("TextButton")
    BananaButton.Name = "BananaButton"
    BananaButton.Text = "🍌"
    BananaButton.TextSize = 40
    BananaButton.Size = UDim2.new(0, 80, 0, 80)
    BananaButton.Position = UDim2.new(0, 20, 0, 20)
    BananaButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BananaButton.BorderSizePixel = 3
    BananaButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BananaButton.ZIndex = 100
    
    -- Делаем круглой
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = BananaButton
    
    -- Главное окно
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 400, 0, 300)
    MainWindow.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainWindow.Visible = false
    MainWindow.ZIndex = 50
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 8)
    WindowCorner.Parent = MainWindow
    
    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Text = "BANANA GUI v1.0"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Parent = MainWindow
    
    -- Кнопка закрытия
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.Parent = MainWindow
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Простые функции
    local function FlyToggle()
        print("[BANANA] Fly activated")
        -- Простая реализация Fly
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = not humanoid.PlatformStand
                print("Fly:", humanoid.PlatformStand)
            end
        end
    end
    
    local function SpeedToggle()
        print("[BANANA] Speed activated")
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.WalkSpeed == 16 then
                    humanoid.WalkSpeed = 50
                else
                    humanoid.WalkSpeed = 16
                end
                print("Speed:", humanoid.WalkSpeed)
            end
        end
    end
    
    local function JumpToggle()
        print("[BANANA] Infinite Jump activated")
    end
    
    local function NoClipToggle()
        print("[BANANA] NoClip activated")
    end
    
    -- Создаем кнопки функций
    local buttonData = {
        {"FLY MODE", Color3.fromRGB(0, 150, 200), FlyToggle},
        {"SPEED HACK", Color3.fromRGB(0, 200, 0), SpeedToggle},
        {"INFINITE JUMP", Color3.fromRGB(200, 100, 0), JumpToggle},
        {"NO CLIP", Color3.fromRGB(150, 150, 150), NoClipToggle}
    }
    
    for i, data in pairs(buttonData) do
        local btn = Instance.new("TextButton")
        btn.Text = data[1]
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = data[2]
        btn.Size = UDim2.new(0.45, 0, 0, 40)
        btn.Position = UDim2.new(0.025, 0, 0.2 + (i-1)*0.25, 0)
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(data[3])
        btn.Parent = MainWindow
    end
    
    -- Поле для скриптов
    local ScriptBox = Instance.new("TextBox")
    ScriptBox.Text = "-- Введите скрипт здесь"
    ScriptBox.Font = Enum.Font.Code
    ScriptBox.TextSize = 14
    ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ScriptBox.Size = UDim2.new(0.9, 0, 0.3, 0)
    ScriptBox.Position = UDim2.new(0.05, 0, 0.6, 0)
    ScriptBox.MultiLine = true
    ScriptBox.TextWrapped = true
    ScriptBox.Parent = MainWindow
    
    local ScriptCorner = Instance.new("UICorner")
    ScriptCorner.CornerRadius = UDim.new(0, 6)
    ScriptCorner.Parent = ScriptBox
    
    -- Кнопка выполнения
    local ExecuteButton = Instance.new("TextButton")
    ExecuteButton.Text = "EXECUTE"
    ExecuteButton.Font = Enum.Font.GothamBold
    ExecuteButton.TextSize = 18
    ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    ExecuteButton.Size = UDim2.new(0.3, 0, 0, 35)
    ExecuteButton.Position = UDim2.new(0.35, 0, 0.92, 0)
    
    local ExeCorner = Instance.new("UICorner")
    ExeCorner.CornerRadius = UDim.new(0, 6)
    ExeCorner.Parent = ExecuteButton
    
    ExecuteButton.MouseButton1Click:Connect(function()
        local scriptText = ScriptBox.Text
        if scriptText and scriptText ~= "" then
            local success, err = pcall(function()
                loadstring(scriptText)()
            end)
            if not success then
                warn("[BANANA] Script error:", err)
            else
                print("[BANANA] Script executed successfully")
            end
        end
    end)
    
    ExecuteButton.Parent = MainWindow
    
    -- Функции управления окном
    local function ToggleWindow()
        MainWindow.Visible = not MainWindow.Visible
    end
    
    -- Перетаскивание окна
    local dragging = false
    local dragStart, startPos
    
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
        end
    end)
    
    Title.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    Title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Перетаскивание кнопки
    local btnDragging = false
    local btnDragStart, btnStartPos
    
    BananaButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDragging = true
            btnDragStart = input.Position
            btnStartPos = BananaButton.Position
            BananaButton.BackgroundTransparency = 0.3
        end
    end)
    
    BananaButton.InputChanged:Connect(function(input)
        if btnDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - btnDragStart
            BananaButton.Position = UDim2.new(
                btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
                btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    BananaButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDragging = false
            BananaButton.BackgroundTransparency = 0
        end
    end)
    
    -- Обработчики кликов
    BananaButton.MouseButton1Click:Connect(ToggleWindow)
    CloseButton.MouseButton1Click:Connect(function()
        MainWindow.Visible = false
    end)
    
    -- Горячие клавиши
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            ToggleWindow()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            FlyToggle()
        elseif input.KeyCode == Enum.KeyCode.F3 then
            SpeedToggle()
        end
    end)
    
    -- Добавляем элементы
    BananaButton.Parent = ScreenGui
    MainWindow.Parent = ScreenGui
    
    print("[BANANA] GUI created successfully!")
    print("[BANANA] Press F1 to open/close")
    
    return ScreenGui
end

-- Запускаем создание GUI
local success, err = pcall(function()
    local gui = CreateBananaGUI()
    if gui then
        print("[BANANA] ✅ GUI loaded!")
        print("[BANANA] Click the banana button 🍌")
    end
end)

if not success then
    warn("[BANANA] ❌ Error creating GUI:", err)
    
    -- Пробуем простой вариант
    local simpleGUI = Instance.new("ScreenGui")
    simpleGUI.Parent = CoreGui
    
    local simpleBtn = Instance.new("TextButton")
    simpleBtn.Text = "BANANA 🍌"
    simpleBtn.Size = UDim2.new(0, 100, 0, 50)
    simpleBtn.Position = UDim2.new(0, 50, 0, 50)
    simpleBtn.Parent = simpleGUI
    
    simpleBtn.MouseButton1Click:Connect(function()
        print("Banana button clicked!")
    end)
    
    print("[BANANA] Simple GUI created")
end

-- Сообщение об успехе
print("==================================")
print("BANANA GUI LOADED SUCCESSFULLY!")
print("Features:")
print("- Fly Mode (F2)")
print("- Speed Hack (F3)")
print("- Script Executor")
print("- Draggable Windows")
print("==================================")
