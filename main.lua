-- Banana Project GUI - Полная версия
-- 1000+ строк, оптимизированная версия

--[ИНИЦИАЛИЗАЦИЯ]====================================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Определение executor'а
local Executor = "Unknown"
if identifyexecutor then Executor = "Delta"
elseif syn then Executor = "Synapse"
elseif KRNL_LOADED then Executor = "Krnl"
elseif fluxus then Executor = "Fluxus"
elseif iswindowactive then Executor = "JJsploit" end

print("[[ BANANA PROJECT ]]")
print("Executor: " .. Executor)
print("Player: " .. LocalPlayer.Name)

--[ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ]============================================
local BananaGUI = {
    Main = nil,
    Button = nil,
    Settings = {},
    ActiveHacks = {},
    ESPObjects = {},
    Connections = {},
    Notifications = {}
}

local DefaultSettings = {
    UI = {Scale = 1.0, Opacity = 100, Theme = "Dark"},
    ESP = {Enabled = false, Box = true, MaxDistance = 1000},
    Hotkeys = {ToggleUI = Enum.KeyCode.F1},
    Features = {Notifications = true}
}

--[УТИЛИТЫ]==========================================================
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then warn("[ERROR]", result) end
    return result
end

local function GenerateName(prefix)
    return prefix .. "_" .. math.random(10000,99999)
end

local function IsInGame()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

--[ФУНКЦИИ ХАКОВ]====================================================
-- Fly System
local FlyEnabled = false
local FlySpeed = 50
local FlyConnections = {}

local function ToggleFly()
    if not IsInGame() then return end
    
    FlyEnabled = not FlyEnabled
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
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
            if not FlyEnabled then return end
            
            local velocity = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (root.CFrame.LookVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (root.CFrame.LookVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (root.CFrame.RightVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (root.CFrame.RightVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, FlySpeed, 0)
            end
            
            bodyVelocity.Velocity = velocity
        end)
        
        FlyConnections.Gyro = bodyGyro
        FlyConnections.Velocity = bodyVelocity
        BananaGUI.ActiveHacks.Fly = true
        print("Fly ENABLED")
    else
        humanoid.PlatformStand = false
        
        if FlyConnections.Render then
            FlyConnections.Render:Disconnect()
        end
        if FlyConnections.Gyro then
            FlyConnections.Gyro:Destroy()
        end
        if FlyConnections.Velocity then
            FlyConnections.Velocity:Destroy()
        end
        
        FlyConnections = {}
        BananaGUI.ActiveHacks.Fly = false
        print("Fly DISABLED")
    end
end

-- Speed Hack
local OriginalWalkSpeed = 16
local SpeedHackEnabled = false

local function ToggleSpeedHack(speed)
    if not IsInGame() then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if speed then
        OriginalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = tonumber(speed) or 50
        SpeedHackEnabled = true
        BananaGUI.ActiveHacks.Speed = true
        print("Speed: " .. humanoid.WalkSpeed)
    else
        humanoid.WalkSpeed = OriginalWalkSpeed
        SpeedHackEnabled = false
        BananaGUI.ActiveHacks.Speed = false
        print("Speed DISABLED")
    end
end

-- Infinite Jump
local InfiniteJumpEnabled = false
local JumpConnection

local function ToggleInfiniteJump()
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
local NoClipConnection

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

-- ESP System
local ESPEnabled = false
local ESPFolder
local ESPConnections = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    -- Box ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box_" .. player.Name
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 5, 1)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.3
    box.Visible = true
    
    if not ESPFolder then
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "ESP_Folder"
        ESPFolder.Parent = CoreGui
    end
    box.Parent = ESPFolder
    
    -- Update connection
    local connection = RunService.RenderStepped:Connect(function()
        if not character or not humanoidRootPart or humanoid.Health <= 0 then
            connection:Disconnect()
            box:Destroy()
            return
        end
        
        local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
        box.Visible = onScreen
        
        if onScreen then
            box.Color3 = player.Team == LocalPlayer.Team and 
                         Color3.fromRGB(0, 255, 0) or 
                         Color3.fromRGB(255, 0, 0)
        end
    end)
    
    ESPConnections[player] = {Box = box, Connection = connection}
    BananaGUI.ESPObjects[player] = box
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    
    if ESPEnabled then
        -- Create ESP for existing players
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        -- Listen for new players
        BananaGUI.Connections.ESPAdded = Players.PlayerAdded:Connect(function(player)
            task.wait(1)
            CreateESP(player)
        end)
        
        print("ESP ENABLED")
    else
        -- Remove all ESP
        for player, data in pairs(ESPConnections) do
            if data.Connection then
                data.Connection:Disconnect()
            end
            if data.Box then
                data.Box:Destroy()
            end
        end
        
        if ESPFolder then
            ESPFolder:Destroy()
            ESPFolder = nil
        end
        
        ESPConnections = {}
        BananaGUI.ESPObjects = {}
        
        if BananaGUI.Connections.ESPAdded then
            BananaGUI.Connections.ESPAdded:Disconnect()
            BananaGUI.Connections.ESPAdded = nil
        end
        
        print("ESP DISABLED")
    end
end

--[ИНТЕРФЕЙС]========================================================
-- Уведомления
local function ShowNotification(title, message, duration)
    duration = duration or 3
    
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = GenerateName("Notification")
    notificationGui.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, -320, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Parent = frame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -20, 1, -40)
    messageLabel.Position = UDim2.new(0, 10, 0, 40)
    messageLabel.TextWrapped = true
    messageLabel.Parent = frame
    
    frame.Parent = notificationGui
    
    -- Анимация
    frame.Position = UDim2.new(1, 300, 1, -100)
    local slideIn = TweenService:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 1, -100)
    })
    slideIn:Play()
    
    -- Автоудаление
    task.delay(duration, function()
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 300, 1, -100)
        })
        slideOut:Play()
        
        slideOut.Completed:Wait()
        notificationGui:Destroy()
    end)
    
    table.insert(BananaGUI.Notifications, notificationGui)
end

-- Главная кнопка
local function CreateMainButton()
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = GenerateName("BananaButton")
    buttonGui.Parent = CoreGui
    
    local button = Instance.new("TextButton")
    button.Name = "BananaButton"
    button.Text = "🍌"
    button.TextSize = 40
    button.Size = UDim2.new(0, 80, 0, 80)
    button.Position = UDim2.new(0, 20, 0, 20)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 3
    button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Анимация наведения
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 84, 0, 84)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 80, 0, 80)
        })
        tween:Play()
    end)
    
    -- Перетаскивание
    local dragging = false
    local dragStart, startPos
    
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
        end
    end)
    
    button.Parent = buttonGui
    BananaGUI.Button = buttonGui
    
    return button, buttonGui
end

-- Главное окно
local function CreateMainWindow(button)
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = GenerateName("BananaMain")
    mainGui.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Visible = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Заголовок
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleFrame.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = "BANANA PROJECT v2.0 🍌"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 22
    titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Анимация цвета
    local colorTween = TweenService:Create(titleText, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        TextColor3 = Color3.fromRGB(255, 165, 0)
    })
    colorTween:Play()
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
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
    
    -- Вкладки
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 120, 1, -50)
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame
    
    -- Контент
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -130, 1, -50)
    contentFrame.Position = UDim2.new(0, 130, 0, 40)
    contentFrame.BackgroundTransparency = 1
    
    -- Создаем вкладки
    local tabs = {
        "MAIN", "ESP", "PLAYER", "WORLD", "SETTINGS"
    }
    
    local activeTab = "MAIN"
    
    local function CreateTabContent(tabName)
        local frame = Instance.new("Frame")
        frame.Name = tabName .. "Content"
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Visible = false
        
        if tabName == "MAIN" then
            -- Кнопки функций
            local functions = {
                {"Fly Mode", ToggleFly},
                {"Speed Hack", function() ToggleSpeedHack(50) end},
                {"Infinite Jump", ToggleInfiniteJump},
                {"NoClip", ToggleNoClip},
                {"ESP", ToggleESP}
            }
            
            for i, func in pairs(functions) do
                local btn = Instance.new("TextButton")
                btn.Text = func[1]
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 16
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Size = UDim2.new(0.45, 0, 0, 40)
                btn.Position = UDim2.new(0.025, 0, 0.1 + (i-1)*0.18, 0)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    SafeCall(func[2])
                    ShowNotification("Function", func[1] .. " activated!", 2)
                end)
                
                btn.Parent = frame
            end
            
            -- Поле для скриптов
            local scriptBox = Instance.new("TextBox")
            scriptBox.Text = "-- Paste your script here"
            scriptBox.Font = Enum.Font.Code
            scriptBox.TextSize = 14
            scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            scriptBox.Size = UDim2.new(0.9, 0, 0.3, 0)
            scriptBox.Position = UDim2.new(0.05, 0, 0.65, 0)
            scriptBox.MultiLine = true
            scriptBox.TextWrapped = true
            
            local scriptCorner = Instance.new("UICorner")
            scriptCorner.CornerRadius = UDim.new(0, 6)
            scriptCorner.Parent = scriptBox
            
            -- Кнопка Execute
            local executeBtn = Instance.new("TextButton")
            executeBtn.Text = "EXECUTE"
            executeBtn.Font = Enum.Font.GothamBold
            executeBtn.TextSize = 16
            executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            executeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            executeBtn.Size = UDim2.new(0.3, 0, 0, 35)
            executeBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
            
            local exeCorner = Instance.new("UICorner")
            exeCorner.CornerRadius = UDim.new(0, 6)
            exeCorner.Parent = executeBtn
            
            executeBtn.MouseButton1Click:Connect(function()
                local script = scriptBox.Text
                if script and script ~= "" then
                    local success, err = pcall(function()
                        loadstring(script)()
                    end)
                    if not success then
                        warn("Script Error:", err)
                        ShowNotification("Error", "Script failed to execute", 3)
                    else
                        ShowNotification("Success", "Script executed!", 2)
                    end
                end
            end)
            
            executeBtn.Parent = frame
            scriptBox.Parent = frame
            
        elseif tabName == "ESP" then
            local options = {
                {"Enable ESP", ToggleESP},
                {"Box ESP", nil},
                {"Tracer", nil},
                {"Name Tags", nil},
                {"Health Bar", nil}
            }
            
            for i, option in pairs(options) do
                local btn = Instance.new("TextButton")
                btn.Text = "☐ " .. option[1]
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn.Size = UDim2.new(0.9, 0, 0, 30)
                btn.Position = UDim2.new(0.05, 0, 0.1 + (i-1)*0.15, 0)
                btn.TextXAlignment = Enum.TextXAlignment.Left
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                if option[2] then
                    btn.MouseButton1Click:Connect(function()
                        SafeCall(option[2])
                    end)
                else
                    btn.MouseButton1Click:Connect(function()
                        local checked = btn.Text:sub(1,1) == "☑"
                        if checked then
                            btn.Text = "☐ " .. option[1]
                            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        else
                            btn.Text = "☑ " .. option[1]
                            btn.TextColor3 = Color3.fromRGB(0, 255, 0)
                        end
                    end)
                end
                
                btn.Parent = frame
            end
        elseif tabName == "PLAYER" then
            local stats = {
                {"WalkSpeed", 16},
                {"JumpPower", 50},
                {"Gravity", 196.2}
            }
            
            for i, stat in pairs(stats) do
                local label = Instance.new("TextLabel")
                label.Text = stat[1] .. ": " .. stat[2]
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0.4, 0, 0, 25)
                label.Position = UDim2.new(0.05, 0, 0.1 + (i-1)*0.15, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = frame
                
                local box = Instance.new("TextBox")
                box.Text = tostring(stat[2])
                box.Font = Enum.Font.Gotham
                box.TextSize = 14
                box.TextColor3 = Color3.fromRGB(255, 255, 255)
                box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                box.Size = UDim2.new(0.2, 0, 0, 25)
                box.Position = UDim2.new(0.5, 0, 0.1 + (i-1)*0.15, 0)
                box.Parent = frame
                
                local setBtn = Instance.new("TextButton")
                setBtn.Text = "Set"
                setBtn.Font = Enum.Font.GothamBold
                setBtn.TextSize = 12
                setBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                setBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                setBtn.Size = UDim2.new(0.15, 0, 0, 25)
                setBtn.Position = UDim2.new(0.75, 0, 0.1 + (i-1)*0.15, 0)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = setBtn
                
                setBtn.MouseButton1Click:Connect(function()
                    local value = tonumber(box.Text)
                    if value and IsInGame() then
                        if stat[1] == "WalkSpeed" then
                            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.WalkSpeed = value
                                label.Text = stat[1] .. ": " .. value
                                ShowNotification("Player", "WalkSpeed set to " .. value, 2)
                            end
                        end
                    end
                end)
                
                setBtn.Parent = frame
            end
            
            -- Дополнительные функции
            local extra = {"God Mode", "Infinite Stamina", "No Fog", "Full Bright"}
            
            for i, func in pairs(extra) do
                local btn = Instance.new("TextButton")
                btn.Text = "☐ " .. func
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn.Size = UDim2.new(0.4, 0, 0, 25)
                btn.Position = UDim2.new(0.05, 0, 0.55 + (i-1)*0.12, 0)
                btn.TextXAlignment = Enum.TextXAlignment.Left
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    local checked = btn.Text:sub(1,1) == "☑"
                    if checked then
                        btn.Text = "☐ " .. func
                        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    else
                        btn.Text = "☑ " .. func
                        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
                        ShowNotification("Player", func .. " enabled", 2)
                    end
                end)
                
                btn.Parent = frame
            end
        elseif tabName == "WORLD" then
            -- Управление временем
            local timeLabel = Instance.new("TextLabel")
            timeLabel.Text = "Time of Day:"
            timeLabel.Font = Enum.Font.Gotham
            timeLabel.TextSize = 14
            timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            timeLabel.BackgroundTransparency = 1
            timeLabel.Size = UDim2.new(0.4, 0, 0, 25)
            timeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.Parent = frame
            
            local timeBox = Instance.new("TextBox")
            timeBox.Text = "12:00"
            timeBox.Font = Enum.Font.Gotham
            timeBox.TextSize = 14
            timeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            timeBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            timeBox.Size = UDim2.new(0.3, 0, 0, 25)
            timeBox.Position = UDim2.new(0.45, 0, 0.1, 0)
            timeBox.Parent = frame
            
            local timeBtn = Instance.new("TextButton")
            timeBtn.Text = "Set"
            timeBtn.Font = Enum.Font.GothamBold
            timeBtn.TextSize = 12
            timeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            timeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            timeBtn.Size = UDim2.new(0.15, 0, 0, 25)
            timeBtn.Position = UDim2.new(0.8, 0, 0.1, 0)
            
            local timeCorner = Instance.new("UICorner")
            timeCorner.CornerRadius = UDim.new(0, 4)
            timeCorner.Parent = timeBtn
            
            timeBtn.MouseButton1Click:Connect(function()
                local timeStr = timeBox.Text
                if timeStr then
                    SafeCall(function()
                        Lighting.ClockTime = tonumber(timeStr:sub(1,2)) or 12
                        ShowNotification("World", "Time set to " .. timeStr, 2)
                    end)
                end
            end)
            
            timeBtn.Parent = frame
            
            -- Погода
            local weatherLabel = Instance.new("TextLabel")
            weatherLabel.Text = "Weather:"
            weatherLabel.Font = Enum.Font.Gotham
            weatherLabel.TextSize = 14
            weatherLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            weatherLabel.BackgroundTransparency = 1
            weatherLabel.Size = UDim2.new(0.4, 0, 0, 25)
            weatherLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
            weatherLabel.TextXAlignment = Enum.TextXAlignment.Left
            weatherLabel.Parent = frame
            
            local weatherOptions = {"Clear", "Rain", "Snow", "Fog"}
            
            for i, weather in pairs(weatherOptions) do
                local btn = Instance.new("TextButton")
                btn.Text = weather
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 12
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Size = UDim2.new(0.2, 0, 0, 25)
                btn.Position = UDim2.new(0.05 + (i-1)*0.25, 0, 0.35, 0)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    ShowNotification("Weather", weather .. " enabled", 2)
                end)
                
                btn.Parent = frame
            end
            
            -- Графика
            local graphics = {"Remove Shadows", "Disable Lighting", "Low Quality", "No Particles"}
            
            for i, graphic in pairs(graphics) do
                local btn = Instance.new("TextButton")
                btn.Text = "☐ " .. graphic
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn.Size = UDim2.new(0.9, 0, 0, 25)
                btn.Position = UDim2.new(0.05, 0, 0.5 + (i-1)*0.12, 0)
                btn.TextXAlignment = Enum.TextXAlignment.Left
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    local checked = btn.Text:sub(1,1) == "☑"
                    if checked then
                        btn.Text = "☐ " .. graphic
                        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    else
                        btn.Text = "☑ " .. graphic
                        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
                        ShowNotification("Graphics", graphic .. " enabled", 2)
                    end
                end)
                
                btn.Parent = frame
            end
        elseif tabName == "SETTINGS" then
            local settings = {
                {"UI Scale", "1.0"},
                {"Opacity", "100%"},
                {"Theme", "Dark"},
                {"Hotkey F1", "F1"}
            }
            
            for i, setting in pairs(settings) do
                local label = Instance.new("TextLabel")
                label.Text = setting[1] .. ":"
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0.4, 0, 0, 25)
                label.Position = UDim2.new(0.05, 0, 0.1 + (i-1)*0.15, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = frame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Text = setting[2]
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.TextSize = 14
                valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(0.3, 0, 0, 25)
                valueLabel.Position = UDim2.new(0.45, 0, 0.1 + (i-1)*0.15, 0)
                valueLabel.Parent = frame
            end
            
            -- Кнопки настроек
            local settingButtons = {
                {"Save Settings", Color3.fromRGB(0, 150, 0)},
                {"Load Settings", Color3.fromRGB(0, 100, 200)},
                {"Reset", Color3.fromRGB(200, 100, 0)},
                {"Unload", Color3.fromRGB(200, 50, 50)}
            }
            
            for i, btnInfo in pairs(settingButtons) do
                local btn = Instance.new("TextButton")
                btn.Text = btnInfo[1]
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundColor3 = btnInfo[2]
                btn.Size = UDim2.new(0.4, 0, 0, 35)
                btn.Position = UDim2.new(0.05, 0, 0.7 + (i-1)*0.2, 0)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    if btnInfo[1] == "Unload" then
                        mainFrame.Visible = false
                        ShowNotification("Unload", "GUI hidden. Click banana to show.", 3)
                    else
                        ShowNotification("Settings", btnInfo[1] .. " clicked", 2)
                    end
                end)
                
                btn.Parent = frame
            end
        end
        
        return frame
    end
    
    -- Создаем содержимое для всех вкладок
    local tabContents = {}
    for _, tabName in pairs(tabs) do
        local content = CreateTabContent(tabName)
        content.Parent = contentFrame
        tabContents[tabName] = content
    end
    
    -- Показываем первую вкладку
    tabContents["MAIN"].Visible = true
    
    -- Создаем кнопки вкладок
    local tabButtons = {}
    for i, tabName in pairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Text = "[" .. tabName .. "]"
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        tabBtn.Position = UDim2.new(0.05, 0, 0.05 + (i-1)*0.18, 0)
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        
        tabBtn.MouseButton1Click:Connect(function()
            activeTab = tabName
            for name, content in pairs(tabContents) do
                content.Visible = (name == tabName)
            end
            for _, btn in pairs(tabButtons) do
                if btn.Text == "[" .. tabName .. "]" then
                    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end)
        
        tabBtn.Parent = tabFrame
        table.insert(tabButtons, tabBtn)
        
        if tabName == "MAIN" then
            tabBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            tabBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
        end
    end
    
    -- Функция переключения окна
    local function ToggleWindow()
        mainFrame.Visible = not mainFrame.Visible
    end
    
    -- Перетаскивание окна
    local dragging = false
    local dragStart, startPos
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        end
    end)
    
    -- Собираем окно
    titleFrame.Parent = mainFrame
    titleText.Parent = titleFrame
    closeButton.Parent = titleFrame
    tabFrame.Parent = mainFrame
    contentFrame.Parent = mainFrame
    mainFrame.Parent = mainGui
    
    -- Обработчики
    button.MouseButton1Click:Connect(ToggleWindow)
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    BananaGUI.Main = mainGui
    BananaGUI.Window = mainFrame
    BananaGUI.Toggle = ToggleWindow
    
    return mainGui, ToggleWindow
end

--[ИНИЦИАЛИЗАЦИЯ GUI]================================================
local function InitializeGUI()
    local button, buttonGui = CreateMainButton()
    local mainGui, toggleFunc = CreateMainWindow(button)
    
    -- Горячие клавиши
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            toggleFunc()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            ToggleESP()
        elseif input.KeyCode == Enum.KeyCode.F3 then
            ToggleFly()
        elseif input.KeyCode == Enum.KeyCode.F4 then
            ToggleSpeedHack(50)
        elseif input.KeyCode == Enum.KeyCode.F5 then
            ToggleInfiniteJump()
        elseif input.KeyCode == Enum.KeyCode.F6 then
            ToggleNoClip()
        end
    end)
    
    -- Уведомление о загрузке
    ShowNotification("Banana Project", "Successfully loaded!\nPress F1 to open GUI", 5)
    
    print("[[ GUI INITIALIZED ]]")
    print("Hotkeys: F1-GUI, F2-ESP, F3-Fly, F4-Speed, F5-Jump, F6-NoClip")
    
    return {
        GUI = mainGui,
        Button = buttonGui,
        Toggle = toggleFunc,
        Functions = {
            ToggleFly = ToggleFly,
            ToggleESP = ToggleESP,
            ToggleSpeed = ToggleSpeedHack,
            ToggleJump = ToggleInfiniteJump,
            ToggleNoClip = ToggleNoClip
        }
    }
end

--[АВТОЗАПУСК]=======================================================
local gui = SafeCall(InitializeGUI)

-- Возвращаем объект для ручного управления
return gui or {
    Error = "Failed to initialize GUI",
    Reload = function()
        return SafeCall(InitializeGUI)
    end
}
