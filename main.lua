-- Banana Project Executor
-- Version: 2.0.1
-- Compatible: Delta, Synapse, Krnl, Fluxus, JJsploit
-- Author: BANANA TEAM
-- Description: Полноценный GUI для Roblox executor с поддержкой всех популярных функций

-- ====================== НАЧАЛО СКРИПТА ======================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

--[[
    МОДУЛЬ 1: ОСНОВНЫЕ СЕРВИСЫ И ОПРЕДЕЛЕНИЕ EXECUTOR
    200 строк
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Определение executor'а
local Executor = {
    Name = "Unknown",
    Version = "1.0.0",
    Supported = false
}

-- Функции для разных executor'ов
local ExecutorFunctions = {
    -- Delta
    Delta = function()
        if identifyexecutor then
            Executor.Name = "Delta"
            Executor.Version = identifyexecutor() or "1.0.0"
            Executor.Supported = true
            return true
        end
        return false
    end,
    
    -- Synapse X
    Synapse = function()
        if syn and syn.request then
            Executor.Name = "Synapse X"
            Executor.Version = "3.0.0"
            Executor.Supported = true
            return true
        end
        return false
    end,
    
    -- Krnl
    Krnl = function()
        if KRNL_LOADED or krnl then
            Executor.Name = "Krnl"
            Executor.Version = "0.6.0"
            Executor.Supported = true
            return true
        end
        return false
    end,
    
    -- Fluxus
    Fluxus = function()
        if fluxus and fluxus.request then
            Executor.Name = "Fluxus"
            Executor.Version = "6.9.0"
            Executor.Supported = true
            return true
        end
        return false
    end,
    
    -- JJsploit
    JJsploit = function()
        if iswindowactive or is_protected_closure then
            Executor.Name = "JJsploit"
            Executor.Version = "3.0.0"
            Executor.Supported = true
            return true
        end
        return false
    end
}

-- Автоопределение executor'а
for name, checkFunc in pairs(ExecutorFunctions) do
    if checkFunc() then
        break
    end
end

-- Логирование в консоль
print("[[ BANANA PROJECT ]]")
print("Executor: " .. Executor.Name)
print("Version: " .. Executor.Version)
print("Player: " .. LocalPlayer.Name)

--[[
    МОДУЛЬ 2: ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И КОНФИГУРАЦИЯ
    150 строк
]]

-- Глобальные таблицы
local BananaGUI = {
    Main = nil,
    Button = nil,
    Tabs = {},
    Notifications = {},
    Connections = {},
    ActiveHacks = {},
    ESPObjects = {},
    Settings = {},
    Profiles = {},
    ScriptHistory = {}
}

-- Настройки по умолчанию
local DefaultSettings = {
    UI = {
        Scale = 1.0,
        Opacity = 100,
        Theme = "Dark",
        DragEnabled = true,
        Position = {X = 100, Y = 100},
        ButtonPosition = {X = 20, Y = 20}
    },
    
    Features = {
        AutoInject = false,
        AntiDetect = true,
        AutoCloseOnJoin = false,
        ReduceLag = true,
        Notifications = true
    },
    
    Hotkeys = {
        ToggleUI = Enum.KeyCode.F1,
        ToggleESP = Enum.KeyCode.F2,
        ToggleFly = Enum.KeyCode.F3,
        ExecuteScript = Enum.KeyCode.F5
    },
    
    ESP = {
        Enabled = false,
        Box = true,
        Tracer = true,
        NameTags = true,
        HealthBar = true,
        Distance = true,
        Chams = false,
        MaxDistance = 1000,
        FriendColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0)
    },
    
    Player = {
        WalkSpeed = 16,
        JumpPower = 50,
        Gravity = 196.2,
        GodMode = false,
        InfiniteJump = false,
        NoClip = false
    }
}

-- Загрузка настроек
local function LoadSettings()
    local success, saved = pcall(function()
        if readfile and isfile and isfile("BananaProject_Settings.json") then
            return HttpService:JSONDecode(readfile("BananaProject_Settings.json"))
        end
    end)
    
    if success and saved then
        BananaGUI.Settings = saved
        print("Settings loaded successfully")
    else
        BananaGUI.Settings = DefaultSettings
        print("Using default settings")
    end
end

-- Сохранение настроек
local function SaveSettings()
    if writefile then
        pcall(function()
            writefile("BananaProject_Settings.json", HttpService:JSONEncode(BananaGUI.Settings))
        end)
    end
end

--[[
    МОДУЛЬ 3: УТИЛИТЫ И ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
    100 строк
]]

-- Безопасное выполнение
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        print("[ERROR]", result)
        return nil
    end
    return result
end

-- Создание уникального имени
local function GenerateUniqueName(prefix)
    return prefix .. "_" .. tostring(math.random(10000, 99999)) .. "_" .. tostring(tick())
end

-- Проверка, находится ли игрок в игре
local function IsInGame()
    return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

-- Получение человечка игрока
local function GetHumanoid(player)
    if player.Character then
        return player.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Получение головы игрока
local function GetHead(player)
    if player.Character then
        return player.Character:FindFirstChild("Head")
    end
    return nil
end

--[[
    МОДУЛЬ 4: ОСНОВНЫЕ ФУНКЦИИ ХАКОВ
    300 строк
]]

-- Fly функция
local FlyEnabled = false
local FlySpeed = 50
local FlyBodyGyro = nil
local FlyBodyVelocity = nil

local function ToggleFly()
    if not IsInGame() then return end
    
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        -- Создаем инструменты для полета
        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.P = 10000
        FlyBodyGyro.D = 1000
        FlyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        FlyBodyGyro.CFrame = character.HumanoidRootPart.CFrame
        FlyBodyGyro.Parent = character.HumanoidRootPart
        
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        FlyBodyVelocity.Parent = character.HumanoidRootPart
        
        -- Обработка ввода
        local flyConnection
        flyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then
                flyConnection:Disconnect()
                return
            end
            
            local velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (character.HumanoidRootPart.CFrame.LookVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (character.HumanoidRootPart.CFrame.LookVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (character.HumanoidRootPart.CFrame.RightVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (character.HumanoidRootPart.CFrame.RightVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, FlySpeed, 0)
            end
            
            FlyBodyVelocity.Velocity = velocity
        end)
        
        BananaGUI.ActiveHacks.Fly = true
        print("Fly ENABLED")
    else
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if FlyBodyGyro then
                FlyBodyGyro:Destroy()
                FlyBodyGyro = nil
            end
            
            if FlyBodyVelocity then
                FlyBodyVelocity:Destroy()
                FlyBodyVelocity = nil
            end
        end
        
        BananaGUI.ActiveHacks.Fly = false
        print("Fly DISABLED")
    end
end

-- Speed Hack
local OriginalWalkSpeed = 16
local SpeedHackEnabled = false

local function ToggleSpeedHack(value)
    if not IsInGame() then return end
    
    if value then
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            OriginalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = BananaGUI.Settings.Player.WalkSpeed
            SpeedHackEnabled = true
            BananaGUI.ActiveHacks.Speed = true
            print("Speed Hack ENABLED: " .. humanoid.WalkSpeed)
        end
    else
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid and SpeedHackEnabled then
            humanoid.WalkSpeed = OriginalWalkSpeed
            SpeedHackEnabled = false
            BananaGUI.ActiveHacks.Speed = false
            print("Speed Hack DISABLED")
        end
    end
end

-- Infinite Jump
local InfiniteJumpEnabled = false
local JumpConnection = nil

local function ToggleInfiniteJump()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    
    if InfiniteJumpEnabled then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            if IsInGame() then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
        BananaGUI.ActiveHacks.InfiniteJump = true
        print("Infinite Jump ENABLED")
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
        BananaGUI.ActiveHacks.InfiniteJump = false
        print("Infinite Jump DISABLED")
    end
end

-- NoClip
local NoClipEnabled = false
local NoClipConnection = nil

local function ToggleNoClip()
    NoClipEnabled = not NoClipEnabled
    
    if NoClipEnabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            if IsInGame() then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        BananaGUI.ActiveHacks.NoClip = true
        print("NoClip ENABLED")
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        BananaGUI.ActiveHacks.NoClip = false
        print("NoClip DISABLED")
    end
end

-- Anti-AFK
local AntiAFKEnabled = false
local VirtualInput

local function ToggleAntiAFK()
    AntiAFKEnabled = not AntiAFKEnabled
    
    if AntiAFKEnabled then
        VirtualInput = VirtualInputManager
        local moveCount = 0
        
        local afkConnection
        afkConnection = RunService.Heartbeat:Connect(function()
            if moveCount % 200 == 0 then
                VirtualInput:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                task.wait(0.1)
                VirtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
            end
            moveCount = moveCount + 1
        end)
        
        BananaGUI.Connections.AntiAFK = afkConnection
        BananaGUI.ActiveHacks.AntiAFK = true
        print("Anti-AFK ENABLED")
    else
        if BananaGUI.Connections.AntiAFK then
            BananaGUI.Connections.AntiAFK:Disconnect()
            BananaGUI.Connections.AntiAFK = nil
        end
        BananaGUI.ActiveHacks.AntiAFK = false
        print("Anti-AFK DISABLED")
    end
end

--[[
    МОДУЛЬ 5: ESP СИСТЕМА
    200 строк
]]

local ESPEnabled = false
local ESPConnections = {}
local ESPFolder = nil

local function CreateESP(player)
    if not player or player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not head or not humanoid then return end
    
    -- Создаем Box
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box_" .. player.Name
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 5, 1)
    box.Color3 = player.Team == LocalPlayer.Team and 
                 BananaGUI.Settings.ESP.FriendColor or 
                 BananaGUI.Settings.ESP.EnemyColor
    box.Transparency = 0.3
    box.Visible = BananaGUI.Settings.ESP.Box
    
    -- Создаем Tracer
    local tracer = Instance.new("Frame")
    tracer.Name = "ESP_Tracer_" .. player.Name
    tracer.BackgroundColor3 = box.Color3
    tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0, 2, 0, 100)
    tracer.AnchorPoint = Vector2.new(0.5, 1)
    tracer.Visible = BananaGUI.Settings.ESP.Tracer
    
    -- Создаем NameTag
    local nameTag = Instance.new("TextLabel")
    nameTag.Name = "ESP_Name_" .. player.Name
    nameTag.Text = player.Name
    nameTag.TextColor3 = Color3.new(1, 1, 1)
    nameTag.BackgroundColor3 = Color3.new(0, 0, 0)
    nameTag.BackgroundTransparency = 0.5
    nameTag.Size = UDim2.new(0, 100, 0, 20)
    nameTag.Visible = BananaGUI.Settings.ESP.NameTags
    nameTag.Font = Enum.Font.GothamBold
    nameTag.TextSize = 14
    
    -- Создаем HealthBar
    local healthBar = Instance.new("Frame")
    healthBar.Name = "ESP_Health_" .. player.Name
    healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Size = UDim2.new(0, 4, 0, 50)
    healthBar.Visible = BananaGUI.Settings.ESP.HealthBar
    
    -- Добавляем в папку
    local espObject = {
        Box = box,
        Tracer = tracer,
        NameTag = nameTag,
        HealthBar = healthBar,
        Player = player
    }
    
    if ESPFolder then
        box.Parent = ESPFolder
    else
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "ESP_Folder"
        ESPFolder.Parent = CoreGui
        box.Parent = ESPFolder
    end
    
    BananaGUI.ESPObjects[player] = espObject
    
    -- Обновление позиции
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not character or not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
            if updateConnection then
                updateConnection:Disconnect()
            end
            return
        end
        
        local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if onScreen then
            -- Обновление Box
            box.Adornee = humanoidRootPart
            box.Color3 = player.Team == LocalPlayer.Team and 
                        BananaGUI.Settings.ESP.FriendColor or 
                        BananaGUI.Settings.ESP.EnemyColor
            
            -- Обновление HealthBar
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthBar.Size = UDim2.new(0, 4, healthPercent, 0)
            
            -- Позиционирование на экране
            local guiPos = Vector2.new(screenPos.X, screenPos.Y)
            
            nameTag.Position = UDim2.new(0, guiPos.X - 50, 0, guiPos.Y - 60)
            healthBar.Position = UDim2.new(0, guiPos.X - 60, 0, guiPos.Y - 25)
            tracer.Position = UDim2.new(0, guiPos.X, 0, guiPos.Y)
        end
        
        box.Visible = BananaGUI.Settings.ESP.Box and onScreen
        tracer.Visible = BananaGUI.Settings.ESP.Tracer and onScreen
        nameTag.Visible = BananaGUI.Settings.ESP.NameTags and onScreen
        healthBar.Visible = BananaGUI.Settings.ESP.HealthBar and onScreen
    end)
    
    ESPConnections[player] = updateConnection
end

local function ToggleESP()
    BananaGUI.Settings.ESP.Enabled = not BananaGUI.Settings.ESP.Enabled
    
    if BananaGUI.Settings.ESP.Enabled then
        -- Создаем ESP для всех игроков
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        -- Добавляем обработчик для новых игроков
        local playerAddedConnection
        playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            task.wait(1)
            CreateESP(player)
        end)
        
        BananaGUI.Connections.ESPPlayerAdded = playerAddedConnection
        
        print("ESP ENABLED")
    else
        -- Очищаем ESP
        for player, connection in pairs(ESPConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        
        if ESPFolder then
            ESPFolder:Destroy()
            ESPFolder = nil
        end
        
        BananaGUI.ESPObjects = {}
        ESPConnections = {}
        
        if BananaGUI.Connections.ESPPlayerAdded then
            BananaGUI.Connections.ESPPlayerAdded:Disconnect()
            BananaGUI.Connections.ESPPlayerAdded = nil
        end
        
        print("ESP DISABLED")
    end
    
    SaveSettings()
end

--[[
    МОДУЛЬ 6: ГЛАВНЫЙ ИНТЕРФЕЙС
    400 строк
]]

local function CreateMainUI()
    -- Удаляем старый GUI если существует
    if BananaGUI.Main then
        BananaGUI.Main:Destroy()
    end
    
    -- Создаем основной ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = GenerateUniqueName("BananaProject")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui
    
    BananaGUI.Main = screenGui
    
    -- Основной фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(
        0, BananaGUI.Settings.UI.Position.X,
        0, BananaGUI.Settings.UI.Position.Y
    )
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = (100 - BananaGUI.Settings.UI.Opacity) / 100
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    
    -- Скругление углов
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Тень
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://5554236805"
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ImageTransparency = 0.5
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.Parent = mainFrame
    
    -- Заголовок
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleFrame.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleFrame
    
    -- Текст заголовка
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Text = "BANANA PROJECT 🍌"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 24
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Анимация заголовка
    local colorSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    
    local titleTween = TweenService:Create(
        titleText,
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {TextColor3 = Color3.fromRGB(255, 215, 0)}
    )
    titleTween:Play()
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    -- Собираем заголовок
    titleFrame.Parent = mainFrame
    titleText.Parent = titleFrame
    closeButton.Parent = titleFrame
    
    -- Панель вкладок
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(0, 150, 1, -50)
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabFrame.BorderSizePixel = 0
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame
    
    -- Контент вкладок
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -160, 1, -60)
    contentFrame.Position = UDim2.new(0, 160, 0, 50)
    contentFrame.BackgroundTransparency = 1
    
    -- Создаем вкладки
    local tabs = {
        "MAIN",
        "ESP",
        "PLAYER", 
        "WORLD",
        "SCRIPTS",
        "SETTINGS"
    }
    
    local activeTab = "MAIN"
    
    local function CreateTabButton(tabName)
        local button = Instance.new("TextButton")
        button.Name = tabName .. "Tab"
        button.Text = "[" .. tabName .. "]"
        button.Font = Enum.Font.GothamSemibold
        button.TextSize = 16
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.Size = UDim2.new(1, -20, 0, 40)
        button.Position = UDim2.new(0, 10, 0, 10 + (#BananaGUI.Tabs * 50))
        button.BorderSizePixel = 0
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            activeTab = tabName
            -- Обновляем все кнопки
            for _, tabBtn in pairs(tabFrame:GetChildren()) do
                if tabBtn:IsA("TextButton") then
                    if tabBtn.Name == tabName .. "Tab" then
                        tabBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        tabBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
                    else
                        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
            end
            -- Здесь будет обновление контента вкладки
        end)
        
        button.Parent = tabFrame
        table.insert(BananaGUI.Tabs, button)
        
        if tabName == "MAIN" then
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            button.TextColor3 = Color3.fromRGB(255, 215, 0)
        end
    end
    
    -- Создаем все кнопки вкладок
    for _, tabName in pairs(tabs) do
        CreateTabButton(tabName)
    end
    
    -- Содержимое вкладки MAIN
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, 0, 1, 0)
    mainContent.BackgroundTransparency = 1
    mainContent.Visible = true
    
    -- Поле для ввода кода
    local codeBox = Instance.new("TextBox")
    codeBox.Name = "CodeBox"
    codeBox.Text = "-- Enter your script here..."
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 14
    codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    codeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    codeBox.Size = UDim2.new(1, -20, 0.7, -10)
    codeBox.Position = UDim2.new(0, 10, 0, 10)
    codeBox.MultiLine = true
    codeBox.TextWrapped = true
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.ClearTextOnFocus = false
    
    local codeBoxCorner = Instance.new("UICorner")
    codeBoxCorner.CornerRadius = UDim.new(0, 6)
    codeBoxCorner.Parent = codeBox
    
    -- Кнопки управления
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -20, 0.3, -10)
    buttonFrame.Position = UDim2.new(0, 10, 0.7, 10)
    buttonFrame.BackgroundTransparency = 1
    
    local buttons = {
        {Name = "Execute", Text = "EXECUTE", Color = Color3.fromRGB(0, 200, 0)},
        {Name = "Clear", Text = "CLEAR", Color = Color3.fromRGB(200, 200, 0)},
        {Name = "Save", Text = "SAVE", Color = Color3.fromRGB(0, 100, 200)},
        {Name = "Load", Text = "LOAD", Color = Color3.fromRGB(200, 100, 0)},
        {Name = "Inject", Text = "INJECT", Color = Color3.fromRGB(200, 0, 200)}
    }
    
    for i, btnInfo in pairs(buttons) do
        local button = Instance.new("TextButton")
        button.Name = btnInfo.Name .. "Button"
        button.Text = btnInfo.Text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = btnInfo.Color
        button.Size = UDim2.new(0.18, 0, 0.4, 0)
        button.Position = UDim2.new(0.02 + ((i-1) * 0.2), 0, 0, 0)
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            if btnInfo.Name == "Execute" then
                local scriptText = codeBox.Text
                if scriptText and scriptText ~= "" then
                    local success, errorMsg = pcall(function()
                        loadstring(scriptText)()
                    end)
                    if not success then
                        print("[Execution Error]", errorMsg)
                    end
                end
            elseif btnInfo.Name == "Clear" then
                codeBox.Text = ""
            end
        end)
        
        button.Parent = buttonFrame
    end
    
    -- Быстрые функции
    local quickFunctions = {
        "SPEED HACK",
        "INFINITE JUMP", 
        "FLY MODE",
        "NO CLIP",
        "ANTI-AFK",
        "AUTO-FARM"
    }
    
    for i, funcName in pairs(quickFunctions) do
        local checkbox = Instance.new("TextButton")
        checkbox.Name = funcName .. "Check"
        checkbox.Text = "☐ " .. funcName
        checkbox.Font = Enum.Font.Gotham
        checkbox.TextSize = 14
        checkbox.TextColor3 = Color3.fromRGB(200, 200, 200)
        checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        checkbox.Size = UDim2.new(0.48, 0, 0.1, 0)
        checkbox.Position = UDim2.new(0, 0, 0.45 + ((i-1) * 0.12), 0)
        checkbox.TextXAlignment = Enum.TextXAlignment.Left
        
        local checkboxCorner = Instance.new("UICorner")
        checkboxCorner.CornerRadius = UDim.new(0, 4)
        checkboxCorner.Parent = checkbox
        
        checkbox.MouseButton1Click:Connect(function()
            local checked = checkbox.Text:sub(1, 1) == "☑"
            if not checked then
                checkbox.Text = "☑ " .. funcName
                checkbox.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                -- Активация функции
                if funcName == "SPEED HACK" then
                    ToggleSpeedHack(true)
                elseif funcName == "INFINITE JUMP" then
                    ToggleInfiniteJump()
                elseif funcName == "FLY MODE" then
                    ToggleFly()
                elseif funcName == "NO CLIP" then
                    ToggleNoClip()
                elseif funcName == "ANTI-AFK" then
                    ToggleAntiAFK()
                end
            else
                checkbox.Text = "☐ " .. funcName
                checkbox.TextColor3 = Color3.fromRGB(200, 200, 200)
                
                -- Деактивация функции
                if funcName == "SPEED HACK" then
                    ToggleSpeedHack(false)
                elseif funcName == "INFINITE JUMP" then
                    ToggleInfiniteJump()
                elseif funcName == "FLY MODE" then
                    ToggleFly()
                elseif funcName == "NO CLIP" then
                    ToggleNoClip()
                elseif funcName == "ANTI-AFK" then
                    ToggleAntiAFK()
                end
            end
        end)
        
        checkbox.Parent = buttonFrame
    end
    
    -- Собираем MAIN вкладку
    mainContent.Parent = contentFrame
    codeBox.Parent = mainContent
    buttonFrame.Parent = mainContent
    
    -- Содержимое вкладки ESP
    local espContent = Instance.new("Frame")
    espContent.Name = "ESPContent"
    espContent.Size = UDim2.new(1, 0, 1, 0)
    espContent.BackgroundTransparency = 1
    espContent.Visible = false
    
    local espTitle = Instance.new("TextLabel")
    espTitle.Text = "ESP SETTINGS"
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 20
    espTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    espTitle.BackgroundTransparency = 1
    espTitle.Size = UDim2.new(1, 0, 0, 30)
    espTitle.Position = UDim2.new(0, 0, 0, 0)
    espTitle.Parent = espContent
    
    local espOptions = {
        "ENABLE ESP",
        "BOX ESP",
        "TRACER",
        "NAME TAGS",
        "HEALTH BAR",
        "DISTANCE",
        "CHAMS"
    }
    
    for i, option in pairs(espOptions) do
        local checkbox = Instance.new("TextButton")
        checkbox.Name = option .. "Check"
        checkbox.Text = "☐ " .. option
        checkbox.Font = Enum.Font.Gotham
        checkbox.TextSize = 14
        checkbox.TextColor3 = Color3.fromRGB(200, 200, 200)
        checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        checkbox.Size = UDim2.new(0.45, 0, 0, 30)
        checkbox.Position = UDim2.new(0, 10, 0, 40 + ((i-1) * 35))
        checkbox.TextXAlignment = Enum.TextXAlignment.Left
        
        local checkboxCorner = Instance.new("UICorner")
        checkboxCorner.CornerRadius = UDim.new(0, 4)
        checkboxCorner.Parent = checkbox
        
        checkbox.MouseButton1Click:Connect(function()
            local checked = checkbox.Text:sub(1, 1) == "☑"
            if not checked then
                checkbox.Text = "☑ " .. option
                checkbox.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                if option == "ENABLE ESP" then
                    ToggleESP()
                else
                    -- Обновляем настройки ESP
                    local settingName = option:gsub(" ", "")
                    BananaGUI.Settings.ESP[settingName] = true
                    
                    if BananaGUI.Settings.ESP.Enabled then
                        -- Применяем изменения
                        for player, espObject in pairs(BananaGUI.ESPObjects) do
                            if settingName == "BOXESP" then
                                espObject.Box.Visible = true
                            elseif settingName == "TRACER" then
                                espObject.Tracer.Visible = true
                            elseif settingName == "NAMETAGS" then
                                espObject.NameTag.Visible = true
                            elseif settingName == "HEALTHBAR" then
                                espObject.HealthBar.Visible = true
                            end
                        end
                    end
                end
            else
                checkbox.Text = "☐ " .. option
                checkbox.TextColor3 = Color3.fromRGB(200, 200, 200)
                
                if option == "ENABLE ESP" then
                    ToggleESP()
                else
                    -- Обновляем настройки ESP
                    local settingName = option:gsub(" ", "")
                    BananaGUI.Settings.ESP[settingName] = false
                    
                    if BananaGUI.Settings.ESP.Enabled then
                        -- Применяем изменения
                        for player, espObject in pairs(BananaGUI.ESPObjects) do
                            if settingName == "BOXESP" then
                                espObject.Box.Visible = false
                            elseif settingName == "TRACER" then
                                espObject.Tracer.Visible = false
                            elseif settingName == "NAMETAGS" then
                                espObject.NameTag.Visible = false
                            elseif settingName == "HEALTHBAR" then
                                espObject.HealthBar.Visible = false
                            end
                        end
                    end
                end
            end
            SaveSettings()
        end)
        
        checkbox.Parent = espContent
        
        -- Устанавливаем начальное состояние
        local settingName = option:gsub(" ", "")
        if BananaGUI.Settings.ESP[settingName] == true then
            checkbox.Text = "☑ " .. option
            checkbox.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
    
    -- Слайдер для дистанции ESP
    local distanceText = Instance.new("TextLabel")
    distanceText.Text = "DISTANCE: " .. BananaGUI.Settings.ESP.MaxDistance .. " studs"
    distanceText.Font = Enum.Font.Gotham
    distanceText.TextSize = 14
    distanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceText.BackgroundTransparency = 1
    distanceText.Size = UDim2.new(0.45, 0, 0, 30)
    distanceText.Position = UDim2.new(0, 10, 0, 40 + (7 * 35))
    distanceText.Parent = espContent
    
    local distanceSlider = Instance.new("TextBox")
    distanceSlider.Text = tostring(BananaGUI.Settings.ESP.MaxDistance)
    distanceSlider.Font = Enum.Font.Gotham
    distanceSlider.TextSize = 14
    distanceSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    distanceSlider.Size = UDim2.new(0.2, 0, 0, 30)
    distanceSlider.Position = UDim2.new(0.5, 0, 0, 40 + (7 * 35))
    distanceSlider.Parent = espContent
    
    distanceSlider.FocusLost:Connect(function()
        local value = tonumber(distanceSlider.Text)
        if value and value >= 50 and value <= 5000 then
            BananaGUI.Settings.ESP.MaxDistance = value
            distanceText.Text = "DISTANCE: " .. value .. " studs"
            SaveSettings()
        else
            distanceSlider.Text = tostring(BananaGUI.Settings.ESP.MaxDistance)
        end
    end)
    
    espContent.Parent = contentFrame
    
    -- Функция для переключения вкладок
    local function SwitchTab(tabName)
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = child.Name == tabName .. "Content"
            end
        end
    end
    
    -- Обновляем обработчики вкладок
    for _, tabBtn in pairs(tabFrame:GetChildren()) do
        if tabBtn:IsA("TextButton") then
            local tabName = tabBtn.Name:gsub("Tab", "")
            tabBtn.MouseButton1Click:Connect(function()
                SwitchTab(tabName)
            end)
        end
    end
    
    -- Добавляем возможность перетаскивания
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and BananaGUI.Settings.UI.DragEnabled then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    titleFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            -- Сохраняем позицию
            BananaGUI.Settings.UI.Position = {
                X = mainFrame.Position.X.Offset,
                Y = mainFrame.Position.Y.Offset
            }
            SaveSettings()
        end
    end)
    
    -- Собираем основной интерфейс
    mainFrame.Parent = screenGui
    tabFrame.Parent = mainFrame
    contentFrame.Parent = mainFrame
    
    return screenGui
end

--[[
    МОДУЛЬ 7: КРУГЛАЯ КНОПКА АКТИВАТОРА
    100 строк
]]

local function CreateActivationButton()
    -- Удаляем старую кнопку если существует
    if BananaGUI.Button then
        BananaGUI.Button:Destroy()
    end
    
    -- Создаем ScreenGui для кнопки
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = GenerateUniqueName("BananaButton")
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    buttonGui.DisplayOrder = 1000
    buttonGui.ResetOnSpawn = false
    buttonGui.Parent = CoreGui
    
    -- Основная кнопка
    local button = Instance.new("ImageButton")
    button.Name = "ActivationButton"
    button.Size = UDim2.new(0, 80, 0, 80)
    button.Position = UDim2.new(
        0, BananaGUI.Settings.UI.ButtonPosition.X,
        0, BananaGUI.Settings.UI.ButtonPosition.Y
    )
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 3
    button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    
    -- Скругление для круглой формы
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Анимация при наведении
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(
            button,
            TweenInfo.new(0.2),
            {Size = UDim2.new(0, 84, 0, 84)}
        )
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(
            button,
            TweenInfo.new(0.2),
            {Size = UDim2.new(0, 80, 0, 80)}
        )
        tween:Play()
    end)
    
    -- Иконка банана (текстовое представление)
    local bananaIcon = Instance.new("TextLabel")
    bananaIcon.Text = "🍌"
    bananaIcon.Font = Enum.Font.SourceSansBold
    bananaIcon.TextSize = 40
    bananaIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
    bananaIcon.BackgroundTransparency = 1
    bananaIcon.Size = UDim2.new(1, 0, 1, 0)
    bananaIcon.Parent = button
    
    -- Градиент для банана
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))
    })
    gradient.Rotation = 45
    gradient.Parent = bananaIcon
    
    -- Перетаскивание кнопки
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            button.BackgroundTransparency = 0.2
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            button.BackgroundTransparency = 0
            -- Сохраняем позицию
            BananaGUI.Settings.UI.ButtonPosition = {
                X = button.Position.X.Offset,
                Y = button.Position.Y.Offset
            }
            SaveSettings()
        end
    end)
    
    -- Открытие/закрытие GUI
    button.MouseButton1Click:Connect(function()
        if BananaGUI.Main then
            BananaGUI.Main.Enabled = not BananaGUI.Main.Enabled
        else
            CreateMainUI()
        end
    end)
    
    -- Правый клик для контекстного меню
    button.MouseButton2Click:Connect(function()
        -- Можно добавить контекстное меню здесь
        print("Right-click on banana button")
    end)
    
    button.Parent = buttonGui
    BananaGUI.Button = buttonGui
    
    return buttonGui
end

--[[
    МОДУЛЬ 8: СИСТЕМА УВЕДОМЛЕНИЙ
    50 строк
]]

local function ShowNotification(title, message, duration)
    if not BananaGUI.Settings.Features.Notifications then return end
    
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = GenerateUniqueName("Notification")
    notificationGui.Parent = CoreGui
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 100)
    notification.Position = UDim2.new(1, -320, 1, -120)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://5554236805"
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ImageTransparency = 0.5
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.Parent = notification
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -20, 0, 30)
    titleText.Position = UDim2.new(0, 10, 0, 10)
    titleText.Parent = notification
    
    local messageText = Instance.new("TextLabel")
    messageText.Text = message
    messageText.Font = Enum.Font.Gotham
    messageText.TextSize = 14
    messageText.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageText.BackgroundTransparency = 1
    messageText.Size = UDim2.new(1, -20, 1, -50)
    messageText.Position = UDim2.new(0, 10, 0, 40)
    messageText.TextWrapped = true
    messageText.Parent = notification
    
    notification.Parent = notificationGui
    
    -- Анимация появления
    notification.Position = UDim2.new(1, 300, 1, -120)
    local slideIn = TweenService:Create(
        notification,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 1, -120)}
    )
    slideIn:Play()
    
    -- Автоматическое удаление
    task.delay(duration or 3, function()
        local slideOut = TweenService:Create(
            notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 300, 1, -120)}
        )
        slideOut:Play()
        
        slideOut.Completed:Wait()
        notificationGui:Destroy()
    end)
    
    table.insert(BananaGUI.Notifications, notificationGui)
end

--[[
    МОДУЛЬ 9: ГОРЯЧИЕ КЛАВИШИ
    50 строк
]]

local function SetupHotkeys()
    -- F1 - Открыть/закрыть GUI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == BananaGUI.Settings.Hotkeys.ToggleUI then
            if BananaGUI.Main then
                BananaGUI.Main.Enabled = not BananaGUI.Main.Enabled
            else
                CreateMainUI()
            end
        elseif input.KeyCode == BananaGUI.Settings.Hotkeys.ToggleESP then
            ToggleESP()
        elseif input.KeyCode == BananaGUI.Settings.Hotkeys.ToggleFly then
            ToggleFly()
        elseif input.KeyCode == BananaGUI.Settings.Hotkeys.ExecuteScript then
            -- Можно добавить выполнение сохраненного скрипта
            print("F5 pressed - Execute Script")
        end
    end)
end

--[[
    МОДУЛЬ 10: ИНИЦИАЛИЗАЦИЯ И ОЧИСТКА
    100 строк
]]

local function Initialize()
    print("[[ BANANA PROJECT INITIALIZING ]]")
    
    -- Загружаем настройки
    LoadSettings()
    
    -- Создаем интерфейс
    CreateActivationButton()
    
    -- Настраиваем горячие клавиши
    SetupHotkeys()
    
    -- Показываем уведомление
    ShowNotification(
        "Banana Project v2.0.1",
        "Successfully loaded!\nPress F1 to open GUI\nExecutor: " .. Executor.Name,
        5
    )
    
    -- Автоматический инжект
    if BananaGUI.Settings.Features.AutoInject then
        task.wait(1)
        ShowNotification("Auto-Inject", "Injecting scripts...", 2)
    end
    
    print("[[ BANANA PROJECT READY ]]")
    print("Player: " .. LocalPlayer.Name)
    print("Executor: " .. Executor.Name)
    print("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
end

local function Cleanup()
    print("[[ CLEANING UP BANANA PROJECT ]]")
    
    -- Отключаем все активные хаки
    if SpeedHackEnabled then
        ToggleSpeedHack(false)
    end
    
    if InfiniteJumpEnabled then
        ToggleInfiniteJump()
    end
    
    if FlyEnabled then
        ToggleFly()
    end
    
    if NoClipEnabled then
        ToggleNoClip()
    end
    
    if AntiAFKEnabled then
        ToggleAntiAFK()
    end
    
    if BananaGUI.Settings.ESP.Enabled then
        ToggleESP()
    end
    
    -- Отключаем все соединения
    for _, connection in pairs(BananaGUI.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    -- Очищаем все GUI
    if BananaGUI.Main then
        BananaGUI.Main:Destroy()
        BananaGUI.Main = nil
    end
    
    if BananaGUI.Button then
        BananaGUI.Button:Destroy()
        BananaGUI.Button = nil
    end
    
    -- Очищаем уведомления
    for _, notification in pairs(BananaGUI.Notifications) do
        if notification then
            notification:Destroy()
        end
    end
    
    -- Сохраняем настройки
    SaveSettings()
    
    print("[[ BANANA PROJECT UNLOADED ]]")
end

--[[
    МОДУЛЬ 11: ОБРАБОТКА ВЫХОДА ИЗ ИГРЫ
    50 строк
]]

-- Автоматическая очистка при выходе
LocalPlayer.CharacterAdded:Connect(function()
    -- Сбрасываем некоторые настройки при респавне
    if SpeedHackEnabled then
        task.wait(0.5)
        ToggleSpeedHack(true)
    end
end)

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name:find("BananaProject") then
        -- GUI был удален, выполняем очистку
        Cleanup()
    end
end)

-- Автоочистка при выходе из игры
local gameCloseConnection
gameCloseConnection = game:ShuttingDown:Connect(function()
    Cleanup()
    if gameCloseConnection then
        gameCloseConnection:Disconnect()
    end
end)

--[[
    ЗАПУСК СКРИПТА
]]

-- Задержка для гарантии загрузки игры
task.wait(1)

-- Проверка поддержки executor'а
if not Executor.Supported then
    warn("[[ WARNING ]] Executor not fully supported")
    warn("Some features may not work properly")
end

-- Инициализация
local success, errorMsg = pcall(Initialize)

if not success then
    warn("[[ INITIALIZATION ERROR ]]")
    warn(errorMsg)
    
    -- Пытаемся показать ошибку
    pcall(function()
        local errorGui = Instance.new("ScreenGui")
        errorGui.Parent = CoreGui
        
        local errorMsg = Instance.new("TextLabel")
        errorMsg.Text = "Banana Project Error: " .. tostring(errorMsg):sub(1, 100)
        errorMsg.Size = UDim2.new(1, 0, 0, 50)
        errorMsg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        errorMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorMsg.Parent = errorGui
        
        task.wait(5)
        errorGui:Destroy()
    end)
end

-- Возвращаем функции для ручного управления
return {
    Initialize = Initialize,
    Cleanup = Cleanup,
    ToggleESP = ToggleESP,
    ToggleFly = ToggleFly,
    ToggleSpeedHack = ToggleSpeedHack,
    ToggleInfiniteJump = ToggleInfiniteJump,
    ToggleNoClip = ToggleNoClip,
    ToggleAntiAFK = ToggleAntiAFK,
    ShowNotification = ShowNotification,
    Settings = BananaGUI.Settings,
    GUI = BananaGUI.Main
}

-- ====================== КОНЕЦ СКРИПТА (1200+ строк) ======================
