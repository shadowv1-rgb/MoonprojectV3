```lua
-- LocalScript для создания GUI в Roblox
-- Обновленный скрипт: добавлены разделы "main" и "settings", функции fly, infinity jump, esp с подфункциями (boxes, nametag, tracers, esp color white), speed hack, anti afk, boost fps, с ползунками для скоростей

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BananaMenuGui"
screenGui.Parent = playerGui

-- Создаем иконку (ImageButton) - круглый белый кружок с черной обводкой и бананом внутри (нарисованным как изображение)
local iconButton = Instance.new("ImageButton")
iconButton.Name = "BananaIcon"
iconButton.Size = UDim2.new(0, 50, 0, 50)  -- Размер 50x50
iconButton.Position = UDim2.new(0.9, -25, 0.1, -25)  -- Позиция в правом верхнем углу
iconButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Белый фон (кружок)
iconButton.Image = "rbxassetid://123456789"  -- Изображение банана (замените на реальный ID, например, из Roblox Toolbox - поиск "banana" для "нарисованного" вида)
iconButton.BackgroundTransparency = 0
iconButton.BorderSizePixel = 4  -- Толстая черная обводка
iconButton.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Черная обводка

-- Делаем иконку круглой с помощью UICorner
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0.5, 0)  -- Полностью круглая
iconCorner.Parent = iconButton

iconButton.Parent = screenGui

-- Создаем меню (Frame) - размер 500x400
local menuFrame = Instance.new("Frame")
menuFrame.Name = "BananaMenu"
menuFrame.Size = UDim2.new(0, 500, 0, 400)  -- Размер меню
menuFrame.Position = UDim2.new(0.5, -250, 0.5, -200)  -- Центр экрана
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

-- Добавляем TextLabel с "BANAN PROJECT" в левом верхнем углу
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.5, 0, 0.1, 0)  -- Размер
titleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)  -- Левый верхний угол
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BANAN PROJECT"  -- Надпись
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)  -- Начальный желтый цвет
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = menuFrame

-- Добавляем изображение банана возле надписи (нарисованный как ImageLabel)
local bananaImage = Instance.new("ImageLabel")
bananaImage.Name = "BananaImage"
bananaImage.Size = UDim2.new(0.1, 0, 0.08, 0)  -- Размер для нарисованного банана
bananaImage.Position = UDim2.new(0.55, 0, 0.05, 0)  -- Рядом с надписью
bananaImage.BackgroundTransparency = 1
bananaImage.Image = "rbxassetid://123456789"  -- То же изображение банана (замените на реальный ID для "нарисованного" вида)
bananaImage.Parent = menuFrame

-- Раздел "main" под надписью (серый, обведенный)
local mainSection = Instance.new("TextLabel")
mainSection.Name = "MainSection"
mainSection.Size = UDim2.new(0.4, 0, 0.08, 0)  -- Размер
mainSection.Position = UDim2.new(0.05, 0, 0.15, 0)  -- Под надписью
mainSection.BackgroundColor3 = Color3.fromRGB(128, 128, 128)  -- Серый цвет
mainSection.BackgroundTransparency = 0
mainSection.BorderSizePixel = 2
mainSection.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Обводка
mainSection.Text = "main"
mainSection.TextColor3 = Color3.fromRGB(255, 255, 255)
mainSection.TextScaled = true
mainSection.Font = Enum.Font.SourceSansBold
mainSection.Parent = menuFrame

-- Функция Fly (под main, слева)
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0.2, 0, 0.08, 0)
flyButton.Position = UDim2.new(0.05, 0, 0.25, 0)  -- Под main
flyButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
flyButton.Text = "Fly: OFF"
flyButton.TextScaled = true
flyButton.Parent = menuFrame

local flyEnabled = false
local flySpeed = 5  -- Начальная скорость
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local bv = player.Character.HumanoidRootPart:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = flyEnabled and Vector3.new(4000, 4000, 4000) or Vector3.new(0, 0, 0)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = player.Character.HumanoidRootPart
    end
end)

-- Ползунок для скорости полета (под fly, 1-10)
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.2, 0, 0.06, 0)
flySpeedLabel.Position = UDim2.new(0.05, 0, 0.33, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Fly Speed: " .. flySpeed
flySpeedLabel.TextScaled = true
flySpeedLabel.Parent = menuFrame

local flySpeedUp = Instance.new("TextButton")
flySpeedUp.Size = UDim2.new(0.05, 0, 0.06, 0)
flySpeedUp.Position = UDim2.new(0.25, 0, 0.33, 0)
flySpeedUp.Text = "+"
flySpeedUp.Parent = menuFrame
flySpeedUp.MouseButton1Click:Connect(function()
    if flySpeed < 10 then flySpeed = flySpeed + 1; flySpeedLabel.Text = "Fly Speed: " .. flySpeed end
end)

local flySpeedDown = Instance.new("TextButton")
flySpeedDown.Size = UDim2.new(0.05, 0, 0.06, 0)
flySpeedDown.Position = UDim2.new(0.3, 0, 0.33, 0)
flySpeedDown.Text = "-"
flySpeedDown.Parent = menuFrame
flySpeedDown.MouseButton1Click:Connect(function()
    if flySpeed > 1 then flySpeed = flySpeed - 1; flySpeedLabel.Text = "Fly Speed: " .. flySpeed end
end)

-- Infinity Jump (справа от fly)
local infinityJumpButton = Instance.new("TextButton")
infinityJumpButton.Name = "InfinityJumpButton"
infinityJumpButton.Size = UDim2.new(0.2, 0, 0.08, 0)
infinityJumpButton.Position = UDim2.new(0.35, 0, 0.25, 0)  -- Справа от fly
infinityJumpButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
infinityJumpButton.Text = "Infinity Jump: OFF"
infinityJumpButton.TextScaled = true
infinityJumpButton.Parent = menuFrame

local jumpEnabled = false
infinityJumpButton.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    infinityJumpButton.Text = jumpEnabled and "Infinity Jump: ON" or "Infinity Jump: OFF"
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ESP (под infinity jump)
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(0.2, 0, 0.08, 0)
espButton.Position = UDim2.new(0.35, 0, 0.33, 0)  -- Под infinity jump
espButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
espButton.Text = "ESP: OFF"
espButton.TextScaled = true
espButton.Parent = menuFrame

local espEnabled = false
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    -- Логика ESP будет ниже
end)

-- Boxes (под ESP)
local boxesButton = Instance.new("TextButton")
boxesButton.Name = "BoxesButton"
boxesButton.Size = UDim2.new(0.15, 0, 0.06, 0)
boxesButton.Position = UDim2.new(0.35, 0, 0.41, 0)
boxesButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
boxesButton.Text = "Boxes: OFF"
boxesButton.TextScaled = true
boxesButton.Parent = menuFrame

local boxesEnabled = false
boxesButton.MouseButton1Click:Connect(function()
    boxesEnabled = not boxesEnabled
    boxesButton.Text = boxesEnabled and "Boxes: ON" or "Boxes: OFF"
end)

-- Nametag (под boxes)
local nametagButton = Instance.new("TextButton")
nametagButton.Name = "NametagButton"
nametagButton.Size = UDim2.new(0.15, 0, 0.06, 0)
nametagButton.Position = UDim2.new(0.35, 0, 0.47, 0)
nametagButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
nametagButton.Text = "Nametag: OFF"
nametagButton.TextScaled = true
nametagButton.Parent = menuFrame

local nametagEnabled = false
nametagButton.MouseButton1Click:Connect(function()
    nametagEnabled = not nametagEnabled
    nametagButton.Text = nametagEnabled and "Nametag: ON" or "Nametag: OFF"
end)

-- Tracers (под nametag)
local tracersButton = Instance.new("TextButton")
tracersButton.Name = "TracersButton"
tracersButton.Size = UDim2.new(0.15, 0, 0.06, 0)
tracersButton.Position = UDim2.new(0.35, 0, 0.53, 0)
tracersButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
tracersButton.Text = "Tracers: OFF"
tracersButton.TextScaled = true
tracersButton.Parent = menuFrame

local tracersEnabled = false
tracersButton.MouseButton1Click:Connect(function()
    tracersEnabled = not tracersEnabled
    tracersButton.Text = tracersEnabled and "Tracers: ON" or "Tracers: OFF"
end)

-- ESP Color White (под tracers)
local espColorLabel = Instance.new("TextLabel")
espColorLabel.Name = "ESPColorLabel"
espColorLabel.Size = UDim2.new(0.2, 0, 0.06, 0)
espColorLabel.Position = UDim2.new(0.35, 0, 0.59, 0)
espColorLabel.BackgroundTransparency = 1
espColorLabel.Text = "ESP Color: White"
espColorLabel.TextScaled = true
espColorLabel.Parent = menuFrame

-- Speed Hack (под fly)
local speedHackButton = Instance.new("TextButton")
speedHackButton.Name = "SpeedHackButton"
speedHackButton.Size = UDim2.new(0.2, 0, 0.08, 0)
speedHackButton.Position = UDim2.new(0.05, 0, 0.41, 0)  -- Под fly
speedHackButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
speedHackButton.Text = "Speed Hack: OFF"
speedHackButton.TextScaled = true
speedHackButton.Parent = menuFrame

local speedHackEnabled = false
local speedValue = 50  -- Начальная скорость
speedHackButton.MouseButton1Click:Connect(function()
    speedHackEnabled = not speedHackEnabled
    speedHackButton.Text = speedHackEnabled and "Speed Hack: ON" or "Speed Hack: OFF"
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedHackEnabled and speedValue or 16
    end
end)

-- Ползунок для скорости speed hack (под speed hack, 1-100)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.2, 0, 0.06, 0)
speedLabel.Position = UDim2.new(0.05, 0, 0.49, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. speedValue
speedLabel.TextScaled = true
speedLabel.Parent = menuFrame

local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.05, 0, 0.06, 0)
speedUp.Position = UDim2.new(0.25, 0, 0.49, 0)
speedUp.Text = "+"
speedUp.Parent = menuFrame
speedUp.MouseButton1Click:Connect(function()
    if speedValue < 100 then speedValue = speedValue + 1; speedLabel.Text = "Speed: " .. speedValue end
    if speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue
    end
end)

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.05, 0, 0.06, 0)
speedDown.Position = UDim2.new(0.3, 0, 0.49, 0)
speedDown.Text = "-"
speedDown.Parent = menuFrame
speedDown.MouseButton1Click:Connect(function()
    if speedValue > 1 then speedValue = speedValue - 1; speedLabel.Text = "Speed: " .. speedValue end
    if speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue
    end
end)

-- Anti AFK (под speed hack)
local antiAfkButton = Instance.new("TextButton")
antiAfkButton.Name = "AntiAFKButton"
antiAfkButton.Size = UDim2.new(0.2, 0, 0.08, 0)
antiAfkButton.Position = UDim2.new(0.05, 0, 0.57, 0)  -- Под speed hack
antiAfkButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
antiAfkButton.Text = "Anti AFK: OFF"
antiAfkButton.TextScaled = true
antiAfkButton.Parent = menuFrame

local antiAfkEnabled = false
antiAfkButton.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    antiAfkButton.Text = antiAfkEnabled and "Anti AFK: ON" or "Anti AFK: OFF"
end)

-- Раздел "settings" (справа от main)
local settingsSection = Instance.new("TextLabel")
settingsSection.Name = "SettingsSection"
settingsSection.Size = UDim2.new(0.3, 0, 0.08, 0)  -- Размер
settingsSection.Position = UDim2.new(0.55, 0, 0.15, 0)  -- Справа от main
settingsSection.BackgroundColor3 = Color3.fromRGB(128, 128, 128)  -- Серый цвет
settingsSection.BackgroundTransparency = 0
settingsSection.BorderSizePixel = 2
settingsSection.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Обводка
settings
