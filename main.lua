-- Скрипт для Delta injector: GUI меню "BANANA PROJECT" с исправлениями - рабочий ESP, speed hack с минусом, persistent иконка, новый fly из loadstring

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Функция для создания GUI (вызывается при старте и respawn)
local function createGUI()
    -- Удаляем старую GUI, если есть
    if playerGui:FindFirstChild("BananaMenuGui") then
        playerGui.BananaMenuGui:Destroy()
    end

    -- Создаем ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BananaMenuGui"
    screenGui.Parent = playerGui

    -- Создаем иконку (ImageButton) - круглый белый кружок с черной обводкой и бананом внутри
    local iconButton = Instance.new("ImageButton")
    iconButton.Name = "BananaIcon"
    iconButton.Size = UDim2.new(0, 50, 0, 50)  -- Размер 50x50
    iconButton.Position = UDim2.new(0.9, -25, 0.1, -25)  -- Позиция в правом верхнем углу
    iconButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Белый фон
    iconButton.Image = "rbxassetid://123456789"  -- Замените на реальный ID банана
    iconButton.BackgroundTransparency = 0
    iconButton.BorderSizePixel = 4  -- Толстая черная обводка
    iconButton.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Черная обводка

    -- Делаем иконку круглой
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0.5, 0)
    iconCorner.Parent = iconButton

    iconButton.Parent = screenGui

    -- Создаем меню (Frame) - размер 500x400
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "BananaMenu"
    menuFrame.Size = UDim2.new(0, 500, 0, 400)
    menuFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    menuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    menuFrame.BackgroundTransparency = 0
    menuFrame.Visible = false
    menuFrame.BorderSizePixel = 0

    -- Draggable меню
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

    -- Надпись "BANAN PROJECT" с бананом
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "BANAN PROJECT"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = menuFrame

    local bananaImage = Instance.new("ImageLabel")
    bananaImage.Name = "BananaImage"
    bananaImage.Size = UDim2.new(0.1, 0, 0.08, 0)
    bananaImage.Position = UDim2.new(0.55, 0, 0.05, 0)
    bananaImage.BackgroundTransparency = 1
    bananaImage.Image = "rbxassetid://123456789"  -- То же ID
    bananaImage.Parent = menuFrame

    -- Анимации переливания
    local tweenService = game:GetService("TweenService")
    local menuTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local menuTween = tweenService:Create(menuFrame, menuTweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)})
    menuTween:Play()

    local textTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local textTween = tweenService:Create(titleLabel, textTweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)})
    textTween:Play()

    -- Обработчик иконки
    iconButton.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)

    -- Draggable иконка
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

    -- Раздел "main"
    local mainSection = Instance.new("TextLabel")
    mainSection.Name = "MainSection"
    mainSection.Size = UDim2.new(0.4, 0, 0.08, 0)
    mainSection.Position = UDim2.new(0.05, 0, 0.15, 0)
    mainSection.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    mainSection.BackgroundTransparency = 0
    mainSection.BorderSizePixel = 2
    mainSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainSection.Text = "main"
    mainSection.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainSection.TextScaled = true
    mainSection.Font = Enum.Font.SourceSansBold
    mainSection.Parent = menuFrame

    -- Fly (заменен на loadstring)
    local flyButton = Instance.new("TextButton")
    flyButton.Name = "FlyButton"
    flyButton.Size = UDim2.new(0, 100, 0, 30)
    flyButton.Position = UDim2.new(0.05, 0, 0.25, 0)
    flyButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    flyButton.Text = "Fly"
    flyButton.TextScaled = true
    flyButton.Parent = menuFrame

    flyButton.MouseButton1Click:Connect(function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\048\51\55\100\102\102\57\102\048\97\55\048\048\49\55\51\048\52\100\100\100\54\55\102\100\99\100\51\55\048\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\048\54\048\100\102\53\50\51\51\52\51\99\102\51\048\98\55\56\55\048\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
    end)

    -- Ползунок Fly Speed (1-10) - оставлен, но может не работать с новым fly
    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Size = UDim2.new(0, 100, 0, 20)
    flySpeedLabel.Position = UDim2.new(0.05, 0, 0.33, 0)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Fly Speed: 5"
    flySpeedLabel.TextScaled = true
    flySpeedLabel.Parent = menuFrame

    local flySpeedUp = Instance.new("TextButton")
    flySpeedUp.Size = UDim2.new(0, 25, 0, 20)
    flySpeedUp.Position = UDim2.new(0.25, 0, 0.33, 0)
    flySpeedUp.Text = "+"
    flySpeedUp.Parent = menuFrame
    flySpeedUp.MouseButton1Click:Connect(function()
        -- Не влияет на новый fly
    end)

    local flySpeedDown = Instance.new("TextButton")
    flySpeedDown.Size = UDim2.new(0, 25, 0, 20)
    flySpeedDown.Position = UDim2.new(0.3, 0, 0.33, 0)
    flySpeedDown.Text = "-"
    flySpeedDown.Parent = menuFrame
    flySpeedDown.MouseButton1Click:Connect(function()
        -- Не влияет на новый fly
    end)

    -- Infinity Jump
    local infinityJumpButton = Instance.new("TextButton")
    infinityJumpButton.Name = "InfinityJumpButton"
    infinityJumpButton.Size = UDim2.new(0, 100, 0, 30)
    infinityJumpButton.Position = UDim2.new(0.35, 0, 0.25, 0)
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

    -- ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = UDim2.new(0, 100, 0, 30)
    espButton.Position = UDim2.new(0.35, 0, 0.33, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    espButton.Text = "ESP: OFF"
    espButton.TextScaled = true
    espButton.Parent = menuFrame

    local espEnabled = false
    local espColor = Color3.fromRGB(255, 255, 255)  -- White

    local function updateESP()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then
                -- Nametag
                local nametag = p.Character:FindFirstChild("ESPNametag") or Instance.new("BillboardGui")
                nametag.Name = "ESPNametag"
                nametag.Size = UDim2.new(0, 100, 0, 50)
                nametag.StudsOffset = Vector3.new(0, 2, 0)
                nametag.Adornee = p.Character.Head
                nametag.Enabled = espEnabled and nametagEnabled
                local nameLabel = nametag:FindFirstChild("NameLabel") or Instance.new("TextLabel")
                nameLabel.Name = "NameLabel"
                nameLabel.Text = p.Name
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = espColor
                nameLabel.TextScaled = true
                nameLabel.Parent = nametag
                nametag.Parent = p.Character

                -- Boxes
                local box = p.Character:FindFirstChild("ESPBox") or Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = p.Character:GetExtentsSize()
                box.Adornee = p.Character
                box.Color3 = espColor
                box.Transparency = 0.5
                box.ZIndex = 1
                box.AlwaysOnTop = true
                box.Visible = espEnabled and boxesEnabled
                box.Parent = p.Character

                -- Tracers
                local tracer = p.Character:FindFirstChild("ESPTracer") or Instance.new("Beam")
                tracer.Name = "ESPTracer"
                tracer.Attachment0 = Instance.new("Attachment", workspace.CurrentCamera)
                tracer.Attachment1 = Instance.new("Attachment", p.Character.HumanoidRootPart)
                tracer.Color = ColorSequence.new(espColor)
                tracer.Enabled = espEnabled and tracersEnabled
                tracer.Parent = p.Character
            end
        end
    end

    espButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
        updateESP()
    end)

    -- Boxes
    local boxesButton = Instance.new("TextButton")
    boxesButton.Name = "BoxesButton"
    boxesButton.Size = UDim2.new(0, 75, 0, 20)
    boxesButton.Position = UDim2.new(0.35, 0, 0.41, 0)
    boxesButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    boxesButton.Text = "Boxes: OFF"
    boxesButton.TextScaled = true
    boxesButton.Parent = menuFrame

    local boxesEnabled = false
    boxesButton.MouseButton1Click:Connect(function()
        boxesEnabled = not boxesEnabled
        boxesButton.Text = boxesEnabled and "Boxes: ON" or "Boxes: OFF"
        updateESP()
    end)

    -- Nametag
    local nametagButton = Instance.new("TextButton")
    nametagButton.Name = "NametagButton"
    nametagButton.Size = UDim2.new(0, 75, 0, 20)
    nametagButton.Position = UDim2.new(0.35, 0, 0.47, 0)
    nametagButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    nametagButton.Text = "Nametag: OFF"
    nametagButton.TextScaled = true
    nametagButton.Parent = menuFrame

    local nametagEnabled = false
    nametagButton.MouseButton1Click:Connect(function()
        nametagEnabled = not nametagEnabled
        nametagButton.Text = nametagEnabled and "Nametag: ON" or "Nametag: OFF"
        updateESP()
    end)

    -- Tracers
    local tracersButton = Instance.new("TextButton")
    tracersButton.Name = "TracersButton"
    tracersButton.Size = UDim2.new(0, 75, 0, 20)
    tracersButton.Position = UDim2.new(0.35,
