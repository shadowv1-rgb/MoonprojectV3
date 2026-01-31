-- Простой рабочий GUI скрипт для тестирования
-- Минимальный код, 100% рабочий

-- Проверяем загрузку игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("=== BANANA PROJECT STARTING ===")

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaGUI_" .. math.random(1000,9999)
ScreenGui.Parent = game:GetService("CoreGui")

-- Создаем кнопку банана
local Button = Instance.new("TextButton")
Button.Name = "BananaButton"
Button.Text = "🍌"
Button.TextSize = 40
Button.Size = UDim2.new(0, 80, 0, 80)
Button.Position = UDim2.new(0, 20, 0, 20)
Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.BorderSizePixel = 3
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Делаем кнопку круглой
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Button

-- Создаем главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "BANANA GUI 🍌"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Parent = MainFrame

-- Простые функции
local function SimpleFly()
    print("Fly activated!")
end

local function SimpleSpeed()
    print("Speed activated!")
end

-- Кнопки функций
local function CreateFunctionButton(text, yPosition, func)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, yPosition, 0)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(func)
    btn.Parent = MainFrame
    
    return btn
end

-- Создаем кнопки
CreateFunctionButton("FLY MODE", 0.2, SimpleFly)
CreateFunctionButton("SPEED HACK", 0.35, SimpleSpeed)
CreateFunctionButton("INFINITE JUMP", 0.5, function()
    print("Jump activated!")
end)

-- Кнопка Execute
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Text = "EXECUTE SCRIPT"
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 18
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ExecuteBtn.Size = UDim2.new(0.9, 0, 0, 50)
ExecuteBtn.Position = UDim2.new(0.05, 0, 0.75, 0)

local ExeCorner = Instance.new("UICorner")
ExeCorner.CornerRadius = UDim.new(0, 8)
ExeCorner.Parent = ExecuteBtn

ExecuteBtn.MouseButton1Click:Connect(function()
    print("[[ SCRIPT EXECUTED ]]")
end)

ExecuteBtn.Parent = MainFrame

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "CLOSE"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Size = UDim2.new(0.3, 0, 0, 35)
CloseBtn.Position = UDim2.new(0.35, 0, 0.9, 0)

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

CloseBtn.Parent = MainFrame

-- Перетаскивание окна
local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
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

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = Button.Position
        Button.BackgroundTransparency = 0.3
    end
end)

Button.InputChanged:Connect(function(input)
    if btnDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - btnDragStart
        Button.Position = UDim2.new(
            btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
        )
    end
end)

Button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDragging = false
        Button.BackgroundTransparency = 0
    end
end)

-- Открытие/закрытие окна
Button.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Горячие клавиши
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Добавляем элементы в GUI
Button.Parent = ScreenGui
MainFrame.Parent = ScreenGui

print("=== GUI CREATED SUCCESSFULLY ===")
print("Press F1 to open/close")
print("Drag banana button to move it")

-- Возвращаем GUI для доступа
return {
    GUI = ScreenGui,
    Button = Button,
    Window = MainFrame
}
