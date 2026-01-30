--[[
    🌑 MOON PROJECT: SAMURAI EDITION 🌸
    --------------------------------------------------
    - FUNCTIONS: Samurai Hat, FOV Changer, Sakura Trail, Landing Effect
    - CONTROLS: Fly (W,A,S,D + E UP + Q DOWN), UI Dragging
    --------------------------------------------------
]]

local S = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP = S.Players.LocalPlayer
local UIS = S.UserInputService
local RS = S.RunService
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ ]
_G.Moon = {
    Fly = false, Speed = 100,
    FOV = {Enabled = false, Value = 70},
    SamuraiHat = false,
    SakuraTrail = false,
    LandingEffect = false,
    Keys = {w=false, s=false, a=false, d=false, e=false, q=false}
}

-- [ ФУНКЦИЯ DRAGGABLE (ПЕРЕТАСКИВАНИЕ) ]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [ СОЗДАНИЕ ИНТЕРФЕЙСА (СТИЛЬ МЕНЮ) ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui); Gui.Name = "MoonSamurai"; Gui.ResetOnSpawn = false

-- Иконка Луны (с сакурой)
local Icon = Instance.new("Frame", Gui)
Icon.Size = UDim2.new(0, 60, 0, 60); Icon.Position = UDim2.new(0, 20, 0.5, -30)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local IconStroke = Instance.new("UIStroke", Icon); IconStroke.Color = Color3.fromRGB(255, 192, 203) -- Розовый
local IBtn = Instance.new("TextButton", Icon)
IBtn.Size = UDim2.new(1,0,1,0); IBtn.Text = "🌸"; IBtn.TextSize = 30; IBtn.BackgroundTransparency = 1; IBtn.TextColor3 = Color3.fromRGB(255, 192, 203)

-- Главное Меню
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 450, 0, 350); Main.Position = UDim2.new(0.5, -225, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(255, 192, 203) -- Розовый
Main.Visible = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(255, 192, 203)
Title.Text = "MOON PROJECT: SAMURAI EDITION 🌸"; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18

local Nav = Instance.new("ScrollingFrame", Main)
Nav.Size = UDim2.new(1, -20, 1, -50); Nav.Position = UDim2.new(0, 10, 0, 40); Nav.BackgroundTransparency = 1; Nav.CanvasSize = UDim2.new(0,0,2,0)
Instance.new("UIListLayout", Nav).Padding = UDim.new(0, 5)

local function AddToggleBtn(text, initial_state, config_key, callback)
    local b = Instance.new("TextButton", Nav)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamBold"; Instance.new("UICorner", b)
    
    local state = initial_state
    b.Text = text .. (state and ": ON" or ": OFF")
    b.MouseButton1Click:Connect(function()
        state = not state
        _G.Moon[config_key] = state
        b.Text = text .. (state and ": ON" or ": OFF")
        if callback then callback(state) end
    end)
    return b
end

local function AddSlider(text, min_val, max_val, initial_val, config_key, callback)
    local f = Instance.new("Frame", Nav); f.Size = UDim2.new(1,0,0,35); f.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", f); label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left; label.Font = Enum.Font.GothamBold
    
    local slider = Instance.new("Frame", f); slider.Size = UDim2.new(1, -50, 0, 5); slider.Position = UDim2.new(0, 0, 1, -7); slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    local dot = Instance.new("Frame", slider); dot.Size = UDim2.new(0, 10, 0, 10); dot.BackgroundColor3 = Color3.fromRGB(255, 192, 203); Instance.new("UICorner", dot)
    
    local currentValue = initial_val
    local function UpdateSlider(pos_x)
        local percentage = pos_x / slider.AbsoluteSize.X
        currentValue = min_val + (max_val - min_val) * percentage
        dot.Position = UDim2.new(percentage, -5, 0.5, -5)
        label.Text = text .. ": " .. math.floor(currentValue)
        _G.Moon[config_key] = currentValue
        if callback then callback(currentValue) end
    end
    
    dot.Position = UDim2.new((initial_val - min_val) / (max_val - min_val), -5, 0.5, -5)
    label.Text = text .. ": " .. math.floor(current_val)

    MakeDraggable(dot)
    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    local p = math.clamp(i.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
                    UpdateSlider(p)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then connection:Disconnect() end
            end)
        end
    end)
    return f
end


-- [ ФУНКЦИИ КНОПОК ]
AddToggleBtn("SAMURAI HAT", false, "SamuraiHat", function(state)
    if state then
        local hat = Instance.new("MeshPart")
        hat.Name = "SamuraiHat"
        hat.BrickColor = BrickColor.new("Dark stone grey")
        hat.Size = Vector3.new(1, 1, 1) -- Adjust size as needed
        hat.Shape = Enum.PartType.Ball -- Or Block
        
        local mesh = Instance.new("SpecialMesh", hat)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://625866164" -- Пример MeshId самурайской шляпы. Тебе, возможно, придется найти свой Asset ID.
        mesh.TextureId = "rbxassetid://625866205" -- Пример TextureId
        mesh.Scale = Vector3.new(1.5, 1.5, 1.5)

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hat
        weld.Part1 = LP.Character:FindFirstChild("Head")
        weld.Parent = hat
        
        hat.Parent = LP.Character
        _G.Moon.HatInstance = hat
    else
        if _G.Moon.HatInstance then _G.Moon.HatInstance:Destroy(); _G.Moon.HatInstance = nil end
    end
end)

AddToggleBtn("FOV CHANGER", _G.Moon.FOV.Enabled, "FOV.Enabled", function(state)
    if not state then Camera.FieldOfView = 70 end
end)
AddSlider("FOV VALUE", 1, 120, _G.Moon.FOV.Value, "FOV.Value", function(value)
    if _G.Moon.FOV.Enabled then Camera.FieldOfView = value end
end)

AddToggleBtn("SAKURA TRAIL", false, "SakuraTrail", function(state)
    -- Логика трейла будет в RenderStepped
end)

AddToggleBtn("LANDING EFFECT", false, "LandingEffect", function(state)
    -- Логика эффекта приземления будет в Humanoid.StateChanged
end)

AddToggleBtn("FLY", false, "Fly", function(state)
    -- Логика Fly уже есть
end)

-- [ ФУНКЦИИ ИГРЫ ]

-- FLY LOGIC (из предыдущих версий)
local bv, bg
RS.RenderStepped:Connect(function()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if _G.Moon.Fly and root and hum then
        if not bv or bv.Parent ~= root then
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 15000
        end
        hum.PlatformStand = true
        bg.CFrame = Camera.CFrame
        
        local dir = Vector3.new(0,0,0)
        local camCF = Camera.CFrame
        if _G.Moon.Keys.w then dir = dir + camCF.LookVector end
        if _G.Moon.Keys.s then dir = dir + (-camCF.LookVector) end
        if _G.Moon.Keys.a then dir = dir + (-camCF.RightVector) end
        if _G.Moon.Keys.d then dir = dir + camCF.RightVector end
        if _G.Moon.Keys.e then dir = dir + Vector3.new(0, 1, 0) end
        if _G.Moon.Keys.q then dir = dir + Vector3.new(0, -1, 0) end
        
        bv.Velocity = dir.Unit * _G.Moon.Speed
    else
        if bv then bv:Destroy(); bv = nil end
        if bg then bg:Destroy(); bg = nil end
        if hum then hum.PlatformStand = false end
    end

    -- FOV Changer
    if _G.Moon.FOV.Enabled then
        Camera.FieldOfView = _G.Moon.FOV.Value
    end

    -- Sakura Trail
    if _G.Moon.SakuraTrail and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local particle = Instance.new("ParticleEmitter")
        particle.Texture = "rbxassetid://972332617" -- Пример ID текстуры сакуры (розовый лепесток). Найди свой.
        particle.Transparency = NumberSequence.new(0, 1)
        particle.Lifetime = 1
        particle.Size = NumberSequence.new(0.5, 0)
        particle.Speed = 0
        particle.SpreadAngle = Vector2.new(360, 360)
        particle.Acceleration = Vector3.new(0, -5, 0)
        particle.Rate = 50
        particle.Parent = LP.Character.HumanoidRootPart
        S.Debris:AddItem(particle, 0.1) -- Удалить эмиттер быстро, чтобы не засорять
    end
end)

-- Управление Fly
UIS.InputBegan:Connect(function(i, g)
    if not g then
        local k = i.KeyCode.Name:lower()
        if _G.Moon.Keys[k] ~= nil then _G.Moon.Keys[k] = true end
    end
end)
UIS.InputEnded:Connect(function(i)
    local k = i.KeyCode.Name:lower()
    if _G.Moon.Keys[k] ~= nil then _G.Moon.Keys[k] = false end
end)


-- LANDING EFFECT
local lastState = nil
LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed and _G.Moon.LandingEffect then
            local effect = Instance.new("Part")
            effect.Anchored = true
            effect.CanCollide = false
            effect.Transparency = 1
            effect.Size = Vector3.new(10, 0.1, 10)
            effect.CFrame = CFrame.new(char.HumanoidRootPart.Position) * CFrame.new(0, -char.HumanoidRootPart.Size.Y/2 - effect.Size.Y/2, 0)
            effect.Parent = workspace

            local mesh = Instance.new("SpecialMesh", effect)
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://203299719" -- Circle mesh
            mesh.Scale = Vector3.new(1, 0.1, 1)

            local originalScale = mesh.Scale
            for i = 1, 20 do -- 2 секунды (20 кадров по 0.1 сек)
                task.wait(0.1)
                effect.Transparency = i / 20
                mesh.Scale = originalScale + Vector3.new(i/10, 0, i/10) -- Расширение круга
            end
            effect:Destroy()
        end
    end)
end)


-- СВЯЗЬ GUI И ЛОГИКИ
IBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
MakeDraggable(Main); MakeDraggable(Icon)

print("🌑 MOON PROJECT: SAMURAI EDITION LOADED! 🌸")
