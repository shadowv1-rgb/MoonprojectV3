-- Moon Project 🌑 Full Version
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")

-- Удаление старой копии
if PlayerGui:FindFirstChild("MoonProjectV2") then
    PlayerGui.MoonProjectV2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonProjectV2"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- 1. КНОПКА-ЛУНА
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
OpenBtn.Text = "🌑"
OpenBtn.TextSize = 30
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Draggable = true -- Для теста
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 15)

-- 2. ГЛАВНОЕ МЕНЮ
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 260, 0, 200)
Main.Position = UDim2.new(0.5, -130, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Visible = false
Instance.new("UICorner", Main)

-- Звезды
for i = 1, 15 do
    local s = Instance.new("Frame", Main)
    s.Size = UDim2.new(0, 2, 0, 2)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = Color3.new(1, 1, 1)
    s.BackgroundTransparency = 0.5
end

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "moon project 🌑"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "✕"
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close)

-- Логика
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

print("Moon Project 🌑 Ready!")
