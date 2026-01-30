--[[
    🌸 MOON PROJECT: SAMURAI V2
    - Растяг экрана (слайдер в меню)
    - Трейл только при ходьбе
    - Прозрачная белая шляпа
]]

local S = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP = S.Players.LocalPlayer
local RS = S.RunService
local TS = S.TweenService
local Camera = workspace.CurrentCamera

local Config = {
    FOV = 70,
    SakuraColor = Color3.fromRGB(255, 182, 193),
    HatTransparency = 0.5
}

-- [ 1. СОЗДАНИЕ МЕНЮ ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 200, 0, 100)
Main.Position = UDim2.new(0, 20, 0.5, -50)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Config.SakuraColor

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "MOON SAMURAI"
Title.TextColor3 = Config.SakuraColor
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local Slider = Instance.new("TextButton", Main)
Slider.Size = UDim2.new(0.9, 0, 0, 30)
Slider.Position = UDim2.new(0.05, 0, 0.5, 0)
Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Slider.Text = "FOV: 70"
Slider.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Slider)

-- Логика слайдера FOV
local dragging = false
Slider.MouseButton1Down:Connect(function() dragging = true end)
S.UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

RS.RenderStepped:Connect(function()
    if dragging then
        local mousePos = S.UserInputService:GetMouseLocation().X
        local relativePos = math.clamp((mousePos - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
        Config.FOV = 70 + (relativePos * 50) -- От 70 до 120
        Slider.Text = "FOV: " .. math.floor(Config.FOV)
        Camera.FieldOfView = Config.FOV
    end
end)

-- [ 2. ШЛЯПА САМУРАЯ ]
local function CreateHat()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    
    local hat = Instance.new("Part")
    hat.Name = "MoonHat"
    hat.Size = Vector3.new(2, 0.5, 2)
    hat.Color = Color3.new(1, 1, 1)
    hat.Transparency = Config.HatTransparency
    hat.CanCollide = false
    hat.Massless = true
    hat.Parent = char

    local mesh = Instance.new("SpecialMesh", hat)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://625866164" 
    mesh.Scale = Vector3.new(1.2, 1.2, 1.2)

    local weld = Instance.new("Weld", hat)
    weld.Part0 = hat
    weld.Part1 = head
    weld.C0 = CFrame.new(0, -0.2, 0)
end

-- [ 3. ЭФФЕКТ ПРИЗЕМЛЕНИЯ ]
local function LandingEffect(pos)
    local p = Instance.new("Part", workspace)
    p.Anchored = true; p.CanCollide = false; p.Size = Vector3.new(1, 0.1, 1)
    p.Position = pos - Vector3.new(0, 2.5, 0); p.Material = Enum.Material.Neon
    p.Color = Color3.new(1, 1, 1); p.Transparency = 0.5
    
    local m = Instance.new("SpecialMesh", p)
    m.MeshType = Enum.MeshType.FileMesh; m.MeshId = "rbxassetid://203299719"
    
    TS:Create(m, TweenInfo.new(1), {Scale = Vector3.new(15, 0, 15)}):Play()
    TS:Create(p, TweenInfo.new(1), {Transparency = 1}):Play()
    task.delay(1, function() p:Destroy() end)
end

-- [ 4. ТРЕЙЛ (ТОЛЬКО ПРИ ХОДЬБЕ) ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        if char.Humanoid.MoveDirection.Magnitude > 0 then
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(0.3, 0.3, 0.3); p.Color = Config.SakuraColor
            p.Material = Enum.Material.Neon; p.Anchored = true; p.CanCollide = false
            p.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), 1)
            
            TS:Create(p, TweenInfo.new(1), {Transparency = 1, CFrame = p.CFrame * CFrame.new(0, -1, 0)}):Play()
            task.delay(1, function() p:Destroy() end)
        end
    end
end)

-- Инициализация
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    CreateHat()
    char.Humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then LandingEffect(char.HumanoidRootPart.Position) end
    end)
end)

if LP.Character then 
    CreateHat() 
    LP.Character.Humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then LandingEffect(LP.Character.HumanoidRootPart.Position) end
    end)
end
