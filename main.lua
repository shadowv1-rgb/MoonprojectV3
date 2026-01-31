-- [[ BANANA PROJECT - GUI EXECUTOR ]] --
-- Совместимость: Synapse Z, Wave, Delta, Hydrogen, Arceus X

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Генерация случайного имени для защиты от детекта
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Http" .. math.random(1000, 9999)
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

--- ### 1. СОЗДАНИЕ ПЛАВАЮЩЕЙ КНОПКИ (BANANA) ###
local bananaBtn = Instance.new("ImageButton")
bananaBtn.Name = "BananaToggle"
bananaBtn.Size = UDim2.new(0, 60, 0, 60)
bananaBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
bananaBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bananaBtn.Image = "rbxassetid://10837330310" -- ID банана
bananaBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = bananaBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 2
btnStroke.Color = Color3.fromRGB(0, 0, 0)
btnStroke.Parent = bananaBtn

-- Скрипт перемещения кнопки (Draggable)
local dragging, dragInput, dragStart, startPos
bananaBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = bananaBtn.Position
    end
end)

bananaBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        bananaBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--- ### 2. ОСНОВНОЕ МЕНЮ ###
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame

-- Анимация перелива фона (Белый -> Серый -> Белый)
task.spawn(function()
    while true do
        local tween = TweenService:Create(mainFrame, TweenInfo.new(3, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)})
        tween:Play()
        tween.Completed:Wait()
        local tween2 = TweenService:Create(mainFrame, TweenInfo.new(3, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

--- ### 3. ЗАГОЛОВОК "BANANA PROJECT 🍌" ###
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(1, -210, 0, 10)
title.Text = "BANANA PROJECT 🍌"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Анимация текста (Белый -> Желтый)
task.spawn(function()
    while true do
        TweenService:Create(title, TweenInfo.new(1.5), {TextColor3 = Color3.fromRGB(255, 255, 0)}):Play()
        task.wait(1.5)
        TweenService:Create(title, TweenInfo.new(1.5), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        task.wait(1.5)
    end
end)

--- ### 4. ВКЛАДКИ (TABS) ###
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 100, 1, -60)
tabContainer.Position = UDim2.new(1, -110, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.Parent = tabContainer
    Instance.new("UICorner", btn)
    return btn
end

local mainTabBtn = createTab("Main", 0)
local espTabBtn = createTab("ESP", 40)
local setTabBtn = createTab("Setting", 80)

--- ### 5. КОНТЕНТ (MAIN PAGE - EXECUTOR) ###
local mainPage = Instance.new("ScrollingFrame")
mainPage.Size = UDim2.new(0, 370, 0, 280)
mainPage.Position = UDim2.new(0, 10, 0, 50)
mainPage.BackgroundTransparency = 1
mainPage.CanvasSize = UDim2.new(0, 0, 2, 0)
mainPage.Parent = mainFrame

local editor = Instance.new("TextBox")
editor.Size = UDim2.new(1, -10, 0, 150)
editor.MultiLine = true
editor.PlaceholderText = "-- Paste your Lua script here..."
editor.Text = ""
editor.ClearTextOnFocus = false
editor.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
editor.TextColor3 = Color3.fromRGB(255, 255, 255)
editor.TextXAlignment = Enum.TextXAlignment.Left
editor.TextYAlignment = Enum.TextYAlignment.Top
editor.Parent = mainPage

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0, 100, 0, 30)
execBtn.Position = UDim2.new(0, 0, 0, 160)
execBtn.Text = "Execute"
execBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
execBtn.Parent = mainPage

execBtn.MouseButton1Click:Connect(function()
    local code = editor.Text
    local success, err = pcall(function()
        loadstring(code)()
    end)
    if not success then warn("Execution Error: " .. err) end
end)

--- ### 6. ФУНКЦИИ (FLY & JUMP) ###
local flyEnabled = false
local speedValue = 16

-- Infinite Jump Logic
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Fly Logic (Simplified)
local function toggleFly()
    flyEnabled = not flyEnabled
    local char = player.Character
    if flyEnabled then
        local bv = Instance.new("BodyVelocity", char.PrimaryPart)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = Vector3.zero
        bv.Name = "BananaFly"
        
        task.spawn(function()
            while flyEnabled do
                local dir = workspace.CurrentCamera.CFrame.LookVector
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    bv.Velocity = Vector3.new(0, 50, 0)
                elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    bv.Velocity = Vector3.new(0, -50, 0)
                else
                    bv.Velocity = Vector3.zero
                end
                task.wait()
            end
            bv:Destroy()
        end)
    end
end

-- Переключатель для Fly (Пример чекбокса)
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 100, 0, 30)
flyToggle.Position = UDim2.new(0, 110, 0, 160)
flyToggle.Text = "Fly: OFF"
flyToggle.Parent = mainPage
flyToggle.MouseButton1Click:Connect(function()
    toggleFly()
    flyToggle.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
end)

--- ### 7. ОТКРЫТИЕ / ЗАКРЫТИЕ ###
local menuOpen = false
local function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        mainFrame.Visible = true
        mainFrame.GroupTransparency = 1
        TweenService:Create(mainFrame, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
        task.wait(0.5)
        mainFrame.Visible = false
    end
end

bananaBtn.MouseButton1Click:Connect(toggleMenu)

-- Закрытие на ESC (по желанию можно убрать, так как ESC открывает меню Roblox)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then -- Лучше использовать RControl
        toggleMenu()
    end
end)

print("Banana Project Loaded!")
