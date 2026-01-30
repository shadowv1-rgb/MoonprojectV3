-- Основные переменные
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SamuraiGUI"
screenGui.Parent = playerGui

-- Главная кнопка (белая круглая)
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 60, 0, 60)
mainButton.Position = UDim2.new(0, 100, 0, 100)
mainButton.BackgroundColor3 = Color3.new(1, 1, 1)
mainButton.BorderSizePixel = 0
mainButton.Text = "侍"
mainButton.TextColor3 = Color3.new(0, 0, 0)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.SourceSansBold
mainButton.Parent = screenGui

-- Делаем кнопку круглой
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = mainButton

-- Переменные для перетаскивания
local dragging = false
local dragStart = nil
local startPos = nil

-- Функция перетаскивания
mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainButton.Position
    end
end)

mainButton.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Меню
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menuFrame

-- Заголовок меню
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Samurai Hat"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = menuFrame

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = menuFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Переключатель шляпы самурая
local hatToggle = Instance.new("TextButton")
hatToggle.Size = UDim2.new(0.8, 0, 0, 40)
hatToggle.Position = UDim2.new(0.1, 0, 0, 80)
hatToggle.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
hatToggle.BorderSizePixel = 0
hatToggle.Text = "Samurai Hat: ON"
hatToggle.TextColor3 = Color3.new(1, 1, 1)
hatToggle.TextScaled = true
hatToggle.Font = Enum.Font.SourceSans
hatToggle.Parent = menuFrame

local hatCorner = Instance.new("UICorner")
hatCorner.CornerRadius = UDim.new(0, 5)
hatCorner.Parent = hatToggle

-- Переключатель кругов при падении
local circleToggle = Instance.new("TextButton")
circleToggle.Size = UDim2.new(0.8, 0, 0, 40)
circleToggle.Position = UDim2.new(0.1, 0, 0, 140)
circleToggle.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
circleToggle.BorderSizePixel = 0
circleToggle.Text = "Landing Circles: ON"
circleToggle.TextColor3 = Color3.new(1, 1, 1)
circleToggle.TextScaled = true
circleToggle.Font = Enum.Font.SourceSans
circleToggle.Parent = menuFrame

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(0, 5)
circleCorner.Parent = circleToggle

-- Переключатель следа
local trailToggle = Instance.new("TextButton")
trailToggle.Size = UDim2.new(0.8, 0, 0, 40)
trailToggle.Position = UDim2.new(0.1, 0, 0, 200)
trailToggle.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
trailToggle.BorderSizePixel = 0
trailToggle.Text = "Samurai Trail: ON"
trailToggle.TextColor3 = Color3.new(1, 1, 1)
trailToggle.TextScaled = true
trailToggle.Font = Enum.Font.SourceSans
trailToggle.Parent = menuFrame

local trailCorner = Instance.new("UICorner")
trailCorner.CornerRadius = UDim.new(0, 5)
trailCorner.Parent = trailToggle

-- Ползунок прозрачности
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0.8, 0, 0, 30)
sliderLabel.Position = UDim2.new(0.1, 0, 0, 260)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Hat Transparency: 50%"
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.TextScaled = true
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.Parent = menuFrame

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.8, 0, 0, 20)
sliderFrame.Position = UDim2.new(0.1, 0, 0, 300)
sliderFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = menuFrame

local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0, 10)
sliderFrameCorner.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0.5, -10, 0, 0)
sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = sliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0.5, 0)
sliderButtonCorner.Parent = sliderButton

-- Переменные состояния
local hatEnabled = true
local circleEnabled = true
local trailEnabled = true
local hatTransparency = 0.5
local samuraiHat = nil
local isJumping = false
local trail = nil

-- Создание шляпы самурая
local function createSamuraiHat()
    if samuraiHat then
        samuraiHat:Destroy()
    end
    
    samuraiHat = Instance.new("Part")
    samuraiHat.Name = "SamuraiHat"
    samuraiHat.Size = Vector3.new(4, 0.5, 4)
    samuraiHat.Material = Enum.Material.Neon
    samuraiHat.Color = Color3.new(1, 1, 1)
    samuraiHat.Transparency = hatTransparency
    samuraiHat.CanCollide = false
    samuraiHat.TopSurface = Enum.SurfaceType.Smooth
    samuraiHat.BottomSurface = Enum.SurfaceType.Smooth
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Parent = samuraiHat
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = samuraiHat
    weld.Part1 = character:FindFirstChild("Head")
    weld.Parent = samuraiHat
    
    samuraiHat.CFrame = character.Head.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, math.rad(90))
    samuraiHat.Parent = character
end

-- Создание следа
local function createTrail()
    if trail then
        trail:Destroy()
    end
    
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    
    attachment0.Position = Vector3.new(-2, 0, 0)
    attachment1.Position = Vector3.new(2, 0, 0)
    attachment0.Parent = rootPart
    attachment1.Parent = rootPart
    
    trail = Instance.new("Trail")
    trail.Color = ColorSequence.new(Color3.new(1, 1, 1))
    trail.Transparency = NumberSequence.new(0.3, 1)
    trail.Lifetime = 2
    trail.MinLength = 0
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Parent = rootPart
end

-- Создание круга при приземлении
local function createLandingCircle(position)
    local circle = Instance.new("Part")
    circle.Name = "LandingCircle"
    circle.Size = Vector3.new(8, 0.1, 8)
    circle.Material = Enum.Material.Neon
    circle.Color = Color3.new(1, 1, 1)
    circle.Transparency = 0.5
    circle.CanCollide = false
    circle.Anchored = true
    circle.CFrame = CFrame.new(position)
    circle.Parent = workspace
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Parent = circle
    
    -- Анимация исчезновения
    local tween = TweenService:Create(circle, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(12, 0.1, 12)
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        circle:Destroy()
    end)
end

-- Обработка нажатия главной кнопки
mainButton.MouseButton1Click:Connect(function()
    if not dragging then
        menuFrame.Visible = not menuFrame.Visible
    end
end)

-- Закрытие меню
closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
end)

-- Переключатель шляпы
hatToggle.MouseButton1Click:Connect(function()
    hatEnabled = not hatEnabled
    if hatEnabled then
        hatToggle.Text = "Samurai Hat: ON"
        hatToggle.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
        if character:FindFirstChild("Head") then
            createSamuraiHat()
        end
    else
        hatToggle.Text = "Samurai Hat: OFF"
        hatToggle.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
        if samuraiHat then
            samuraiHat:Destroy()
            samuraiHat = nil
        end
    end
end)

-- Переключатель кругов
circleToggle.MouseButton1Click:Connect(function()
    circleEnabled = not circleEnabled
    if circleEnabled then
        circleToggle.Text = "Landing Circles: ON"
        circleToggle.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
    else
        circleToggle.Text = "Landing Circles: OFF"
        circleToggle.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
    end
end)

-- Переключатель следа
trailToggle.MouseButton1Click:Connect(function()
    trailEnabled = not trailEnabled
    if trailEnabled then
        trailToggle.Text = "Samurai Trail: ON"
        trailToggle.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
        createTrail()
    else
        trailToggle.Text = "Samurai Trail: OFF"
        trailToggle.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
        if trail then
            trail:Destroy()
            trail = nil
        end
    end
end)

-- Ползунок прозрачности
local sliderDragging = false

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
    end
end)

sliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = sliderFrame.AbsolutePosition
        local sliderSize = sliderFrame.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        sliderButton.Position = UDim2.new(relativeX, -10, 0, 0)
        
        hatTransparency = relativeX
        sliderLabel.Text = "Hat Transparency: " .. math.floor(hatTransparency * 100) .. "%"
        
        if samuraiHat then
            samuraiHat.Transparency = hatTransparency
        end
    end
end)

-- Обнаружение прыжков и приземлений
humanoid.StateChanged:Connect(function(oldState, newState)
    if newState == Enum.HumanoidStateType.Jumping or newState == Enum.HumanoidStateType.Freefall then
        isJumping = true
    elseif newState == Enum.HumanoidStateType.Landed and isJumping and circleEnabled then
        isJumping = false
        local raycast = workspace:Raycast(rootPart.Position, Vector3.new(0, -10, 0))
        if raycast then
            createLandingCircle(raycast.Position + Vector3.new(0, 0.1, 0))
        end
    end
end)

-- Инициализация
if hatEnabled and character:FindFirstChild("Head") then
    createSamuraiHat()
end

if trailEnabled then
    createTrail()
end

-- Обработка респавна персонажа
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    wait(1) -- Ждем полной загрузки персонажа
    
    if hatEnabled and character:FindFirstChild("Head") then
        createSamuraiHat()
    end
    
    if trailEnabled then
        createTrail()
    end
    
    -- Переподключаем события
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Jumping or newState == Enum.HumanoidStateType.Freefall then
            isJumping = true
        elseif newState == Enum.HumanoidStateType.Landed and isJumping and circleEnabled then
            isJumping = false
            local raycast = workspace:Raycast(rootPart.Position, Vector3.new(0, -10, 0))
            if raycast then
                createLandingCircle(raycast.Position + Vector3.new(0, 0.1, 0))
            end
        end
    end)
end)
