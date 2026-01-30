-- Moon Project 🌑 V3 (Premium UI Version)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("MoonV3_Final") then PlayerGui.MoonV3_Final:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV3_Final"
MoonGui.ResetOnSpawn = false

-- 1. ИКОНКА (Месяц и звезды)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
OpenBtn.Image = "rbxassetid://605124567" -- Иконка месяца
OpenBtn.Active = true
OpenBtn.Draggable = true
local BtnCorner = Instance.new("UICorner", OpenBtn)
BtnCorner.CornerRadius = UDim.new(1, 0)

-- 2. ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", MoonGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Фон со звездами (через прозрачность)
local StarsBg = Instance.new("Frame", Main)
StarsBg.Size = UDim2.new(1, 0, 1, 0)
StarsBg.BackgroundTransparency = 1
for i = 1, 40 do
    local s = Instance.new("Frame", StarsBg)
    s.Size = UDim2.new(0, 2, 0, 2)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = Color3.new(1, 1, 1)
    s.BackgroundTransparency = 0.5
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
end

-- ВЕРХНЯЯ ПАНЕЛЬ (Tabs)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "moon project 🌑"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

-- ВКЛАДКИ
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(1, -20, 0, 35)
Tabs.Position = UDim2.new(0, 10, 0, 50)
Tabs.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", Tabs)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 10)

-- КОНТЕНТ (Scrolling Frame)
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -100)
Content.Position = UDim2.new(0, 10, 0, 95)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
local ContentList = Instance.new("UIListLayout", Content)
ContentList.Padding = UDim.new(0, 8)

-- ФУНКЦИЯ СОЗДАНИЯ ТУМБЛЕРА (Toggle)
local function CreateToggle(name, callback)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    Instance.new("UICorner", Frame)

    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, -60, 1, 0)
    Text.Position = UDim2.new(0, 15, 0, 0)
    Text.Text = name
    Text.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Text.BackgroundTransparency = 1
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Font = Enum.Font.Gotham

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 45, 0, 24)
    Switch.Position = UDim2.new(1, -55, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    Switch.Text = ""
    local SwCorner = Instance.new("UICorner", Switch)
    SwCorner.CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Switch)
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = UDim2.new(0, 3, 0.5, -9)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local toggled = false
    Switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        Switch.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(40, 45, 60)
        Dot:TweenPosition(toggled and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), "Out", "Quad", 0.2)
        callback(toggled)
    end)
end

-- === САМИ ЧИТЫ ===

CreateToggle("Speed Hack (100)", function(state)
    LPlayer.Character.Humanoid.WalkSpeed = state and 100 or 16
end)

CreateToggle("Infinite Jump", function(state)
    _G.InfJump = state
    UIS.JumpRequest:Connect(function()
        if _G.InfJump then LPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
    end)
end)

CreateToggle("ESP Players", function(state)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LPlayer and v.Character then
            if state then
                local h = Instance.new("Highlight", v.Character)
                h.Name = "MoonHighlight"
                h.FillColor = Color3.fromRGB(100, 100, 255)
            else
                if v.Character:FindFirstChild("MoonHighlight") then v.Character.MoonHighlight:Destroy() end
            end
        end
    end
end)

CreateToggle("Fly (Low G)", function(state)
    local hrp = LPlayer.Character.HumanoidRootPart
    if state then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "MoonFly"
        bv.MaxForce = Vector3.new(0, 1e6, 0)
        bv.Velocity = Vector3.new(0, 0.5, 0)
    else
        if hrp:FindFirstChild("MoonFly") then hrp.MoonFly:Destroy() end
    end
end)

-- Логика кнопок
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

print("Moon Project V3: UI Loaded!")
