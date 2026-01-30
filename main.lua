--[[
    🌑 MOON PROJECT: PURE SAMURAI VISUALS 🌸
    --------------------------------------------------
    - Шляпа: Белая, 50% прозрачности
    - Трейл: Лепестки сакуры
    - Эффект: Белый круг при приземлении
    --------------------------------------------------
]]

local S = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LP = S.Players.LocalPlayer
local RS = S.RunService

-- [ НАСТРОЙКИ ]
local Config = {
    HatTransparency = 0.5,
    HatColor = Color3.new(1, 1, 1), -- Белый
    SakuraColor = Color3.fromRGB(255, 182, 193) -- Розовый
}

-- [ 1. ШЛЯПА САМУРАЯ ]
local function CreateHat()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    
    -- Если шляпа уже есть, удаляем
    if char:FindFirstChild("MoonSamuraiHat") then char.MoonSamuraiHat:Destroy() end

    local hat = Instance.new("Part")
    hat.Name = "MoonSamuraiHat"
    hat.Size = Vector3.new(2, 0.4, 2)
    hat.Color = Config.HatColor
    hat.Transparency = Config.HatTransparency
    hat.CanCollide = false
    hat.Massless = true
    hat.Parent = char

    local mesh = Instance.new("SpecialMesh", hat)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://625866164" -- Меш самурайской шляпы
    mesh.Scale = Vector3.new(1.2, 1.2, 1.2)

    local weld = Instance.new("Weld", hat)
    weld.Part0 = hat
    weld.Part1 = head
    weld.C0 = CFrame.new(0, -0.2, 0) -- Подгонка по высоте
end

-- [ 2. ЭФФЕКТ ПРИЗЕМЛЕНИЯ ]
local function LandingCircle(pos)
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.Transparency = 0.4
    p.Material = Enum.Material.Neon; p.Color = Color3.new(1, 1, 1)
    p.Size = Vector3.new(1, 0.1, 1); p.Position = pos - Vector3.new(0, 2.8, 0)
    p.Parent = workspace
    
    local m = Instance.new("SpecialMesh", p)
    m.MeshType = Enum.MeshType.FileMesh
    m.MeshId = "rbxassetid://203299719" -- Меш круга
    
    task.spawn(function()
        for i = 1, 15 do
            m.Scale = m.Scale + Vector3.new(1.2, 0, 1.2)
            p.Transparency = p.Transparency + 0.04
            task.wait(0.03)
        end
        p:Destroy()
    end)
end

-- [ 3. ЛИНИЯ САКУРЫ (TRAIL) ]
RS.RenderStepped:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.4, 0.4, 0.4)
        p.Color = Config.SakuraColor
        p.Transparency = 0.3
        p.Anchored = true; p.CanCollide = false
        p.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), 0)
        p.Parent = workspace
        
        task.spawn(function()
            local tween = S.TweenService:Create(p, TweenInfo.new(1), {
                Transparency = 1, 
                CFrame = p.CFrame * CFrame.new(0, -2, 0)
            })
            tween:Play()
            tween.Completed:Wait()
            p:Destroy()
        end)
    end
end)

-- [ ЗАПУСК И ОБНОВЛЕНИЕ ПРИ СМЕРТИ ]
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    CreateHat()
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then
            LandingCircle(char.HumanoidRootPart.Position)
        end
    end)
end)

-- Первый запуск
if LP.Character then
    CreateHat()
    LP.Character.Humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then
            LandingCircle(LP.Character.HumanoidRootPart.Position)
        end
    end)
end

print("🌑 Moon Samurai Visuals Loaded! White Hat + Sakura Trail.")
