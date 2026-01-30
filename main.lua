-- LocalScript для создания GUI в Roblox
-- Обновленный скрипт с изменениями: иконка - банан на белом кружке с черной обводкой, меню побольше, надпись в левом верхнем углу с бананом

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BananaMenuGui"
screenGui.Parent = playerGui

-- Создаем иконку (ImageButton) - банан на белом кружке с черной обводкой
local iconButton = Instance.new("ImageButton")
iconButton.Name = "BananaIcon"
iconButton.Size = UDim2.new(0, 60, 0, 60)  -- Немного увеличил размер
iconButton.Position = UDim2.new(0.9, -30, 0.1, -30)  -- Позиция в правом верхнем углу
iconButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Белый фон
iconButton.Image = "rbxassetid://123456789"  -- Замените на ID изображения банана (например, найдите в Roblox Toolbox или используйте эмодзи-стиль)
iconButton.BackgroundTransparency = 0
iconButton.BorderSizePixel = 3  -- Толще обводка
iconButton.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Черная обводка

-- Делаем иконку круглой с помощью UICorner
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0.5, 0)  -- Полностью круглая
iconCorner.Parent = iconButton

iconButton.Parent = screenGui

-- Создаем меню (Frame) - побольше
local menuFrame = Instance.new("Frame")
menuFrame.Name = "BananaMenu"
menuFrame.Size = UDim2.new(0, 400, 0, 300)  -- Увеличенный размер (было 300x200)
menuFrame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Центр экрана
menuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Начальный белый цвет
menuFrame.BackgroundTransparency = 0
menuFrame.Visible = false  -- Изначально скрыто
menuFrame.BorderSizePixel = 0

-- Делаем меню draggable
local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

menuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

menuFrame.Parent = screenGui

-- Добавляем TextLabel с "BANANA PROJECT" в левом верхнем углу
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.6, 0, 0.15, 0)  -- Размер
titleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)  -- Левый верхний угол
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BANANA PROJECT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)  -- Начальный желтый цвет
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = menuFrame

-- Добавляем изображение банана возле надписи (справа от текста)
local bananaImage = Instance.new("ImageLabel")
bananaImage.Name = "BananaImage"
bananaImage.Size = UDim2.new(0.1, 0, 0.1, 0)  -- Маленький размер
bananaImage.Position = UDim2.new(0.65, 0, 0.05, 0)  -- Рядом с надписью
bananaImage.BackgroundTransparency = 1
bananaImage.Image = "rbxassetid://123456789"  -- То же изображение банана
bananaImage.Parent = menuFrame

-- Анимация переливания для меню (от белого-серого к белому)
local tweenService = game:GetService("TweenService")
local menuTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)  -- Бесконечная анимация
local menuTween = tweenService:Create(menuFrame, menuTweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)})  -- К серому
menuTween:Play()

-- Анимация переливания для надписи (от белого к желтому)
local textTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
local textTween = tweenService:Create(titleLabel, textTweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)})  -- К белому
textTween:Play()

-- Обработчик нажатия на иконку
iconButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible  -- Переключаем видимость меню
end)

-- Делаем иконку draggable (опционально)
local iconDragging = false
local iconDragInput
local iconDragStart
local iconStartPos

local function updateIconInput(input)
    local delta = input.Position - iconDragStart
    iconButton.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
end

iconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = iconButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
            end
        end)
    end
end)

iconButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        iconDragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if iconDragging and input == iconDragInput then
        updateIconInput(input)
    end
end)
