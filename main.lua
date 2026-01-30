-- Moon Project V3 🌑 (Final Mobile Optimized)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Удаление старого GUI
if PlayerGui:FindFirstChild("MoonV3") then PlayerGui.MoonV3:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "MoonV3"
ScreenGui.ResetOnSpawn = false

-- 1. КНОПКА ОТКРЫТИЯ (Месяц на синем фоне)
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 60) -- Темно-синий
OpenBtn.Image = "rbxassetid://605124567" -- Твоя иконка месяца
OpenBtn.Active = true
OpenBtn.Draggable = true

local BtnCorner = Instance.new("UICorner", OpenBtn)
BtnCorner.CornerRadius = UDim.new(1, 0)

-- Добавим эффект созвездий на саму кнопку
for i = 1, 5 do
    local s = Instance.new("Frame", OpenBtn)
    s.Size = UDim2.new(0, 2, 0, 2)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = Color3.new(1, 1, 1)
    s.BackgroundTransparency = 0.3
end

-- 2. ГЛАВНОЕ МЕНЮ
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 260)
Main.Position = UDim2.new(0.5, -160, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- Звезды на фоне меню
for i = 1, 40 do
    local star = Instance.new("Frame", Main)
    star.Size = UDim2.new(0, 2, 0, 2)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.new(1, 1, 1)
    star.BackgroundTransparency = 0.5
end

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "moon project🌑"
Title.TextColor3 = Color3.fromRGB(200, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- Кнопка закрытия
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "✕"
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close)

-- Вкладки (Простая реализация)
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Функция для создания кнопок читов
local function AddCheat(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(callback)
end

-- === ФУНКЦИИ ===

AddCheat("Speed Hack (100)", function()
    LPlayer.Character.Humanoid.WalkSpeed = 100
end)

AddCheat("Infinite Jump", function()
    local InfiniteJumpEnabled = true
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            LPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end)

AddCheat("Fly (Tap to Toggle)", function()
    -- Базовый полет
    local character = LPlayer.Character
    local hrp = character.HumanoidRootPart
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 50, 0)
    task.wait(0.5)
    bv.Velocity = Vector3.new(0, 0, 0)
end)

AddCheat("ESP Players", function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LPlayer and v.Character and not v.Character:FindFirstChild("MoonESP") then
            local highlight = Instance.new("Highlight", v.Character)
            highlight.Name = "MoonESP"
            highlight.FillColor = Color3.new(0.5, 0.5, 1)
            highlight.OutlineColor = Color3.new(1, 1, 1)
        end
    end
end)

AddCheat("Reset Settings", function()
    LPlayer.Character.Humanoid.WalkSpeed = 16
    LPlayer.Character.Humanoid.JumpPower = 50
    for _, v in pairs(LPlayer.Character:GetChildren()) do
        if v:IsA("BodyVelocity") then v:Destroy() end
    end
end)

-- Логика кнопок
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

print("Moon Project V3 Loaded! 🌑🌙")
