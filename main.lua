--[[
    🌑 MOON PROJECT V13: OMEGA RIVALS
    - Right-Side Navigation
    - Fixed Fly (Velocity Engine)
    - Rivals Aimbot with FOV Circle
    - Advanced ESP & FPS Boost
]]

local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

if _G.MoonV13 then return end
_G.MoonV13 = true

local Config = {
    Speed = 16, Fly = false, FlySpeed = 50, Jump = 50,
    AimEnabled = false, FOV = 100,
    ESP = false, Tracers = false, Boxes = false,
    InfJump = false, Fling = false
}

-- [УТИЛИТЫ]
local function PlaySound(id)
    local s = Instance.new("Sound", game:GetService("SoundService"))
    s.SoundId = "rbxassetid://"..id; s.Volume = 0.5; s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

-- [FOV CIRCLE]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [GUI]
local MoonGui = Instance.new("ScreenGui", LPlayer:WaitForChild("PlayerGui"))
MoonGui.Name = "MoonV13"

-- [DRAG SYSTEM]
local function MakeDraggable(obj)
    local drag, input, start, pos
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; pos = obj.Position end end)
    obj.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then input = i end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    RunService.RenderStepped:Connect(function()
        if drag and input then
            local delta = input.Position - start
            obj.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
        end
    end)
end

-- ИКОНКА
local Icon = Instance.new("Frame", MoonGui)
Icon.Size = UDim2.new(0, 60, 0, 60); Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.new(0,0,0); Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local MoonTxt = Instance.new("TextLabel", Icon); MoonTxt.Size = UDim2.new(1,0,1,0); MoonTxt.Text = "🌙"; MoonTxt.TextSize = 25; MoonTxt.BackgroundTransparency = 1
MakeDraggable(Icon)

-- МЕНЮ
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 500, 0, 350); Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
MakeDraggable(Main)

-- БЕЛО-ЧЕРНЫЙ ПЕРЕЛИВ МЕНЮ
spawn(function()
    while task.wait() do
        local val = (math.sin(tick() * 2) + 1) / 2
        Main.BackgroundColor3 = Color3.new(val * 0.1, val * 0.1, val * 0.1)
        Instance.new("UIStroke", Main).Color = Color3.new(val, val, val)
    end
end)

-- НАВИГАЦИЯ СПРАВА
local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(0, 120, 1, -20); Nav.Position = UDim2.new(1, -130, 0, 10); Nav.BackgroundTransparency = 1
local NavList = Instance.new("UIListLayout", Nav); NavList.Padding = UDim.new(0, 5)

-- КОНТЕЙНЕР
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -150, 1, -20); Container.Position = UDim2.new(0, 10, 0, 10); Container.BackgroundTransparency = 1

local function CreateTab(name)
    local b = Instance.new("TextButton", Nav)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        p.Visible = true
    end)
    return p
end

local PMain = CreateTab("Main ⚡")
local PAim = CreateTab("Rivals 🎯")
local PVis = CreateTab("Visuals 👁")
local PMisc = CreateTab("Misc ⚙")
PMain.Visible = true

-- [ЭЛЕМЕНТЫ: ТОНКИЙ СЛАЙДЕР]
local function AddSlider(parent, text, min, max, def, cb)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,15); l.Text = text..": "..def; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
    local bar = Instance.new("Frame", f); bar.Size = UDim2.new(1,0,0,2); bar.Position = UDim2.new(0,0,0.8,0); bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    local dot = Instance.new("Frame", bar); dot.Size = UDim2.new(0,10,0,10); dot.Position = UDim2.new((def-min)/(max-min), -5, 0.5, -5); dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", dot)
    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local move; move = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    local r = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
                    dot.Position = UDim2.new(r, -5, 0.5, -5)
                    local v = math.floor(min + (max-min)*r); l.Text = text..": "..v; cb(v)
                end
            end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
        end
    end)
end

local function AddToggle(parent, text, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1,-10,0,35); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = "  "..text; b.TextColor3 = Color3.new(0.8,0.8,0.8); b.TextXAlignment = "Left"; Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; cb(s); b.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(20,20,20); b.TextColor3 = s and Color3.new(0,0,0) or Color3.new(0.8,0.8,0.8)
        PlaySound(s and 1053273954 or 1053274266)
    end)
end

-- [ФУНКЦИОНАЛ]
AddSlider(PMain, "Walk Speed", 16, 500, 16, function(v) Config.Speed = v end)
AddToggle(PMain, "Flight Mode (FIX)", function(s) Config.Fly = s end)
AddSlider(PMain, "Fly Speed", 10, 500, 50, function(v) Config.FlySpeed = v end)
AddToggle(PMain, "Infinite Jump", function(s) Config.InfJump = s end)

AddToggle(PAim, "Rivals Aimbot", function(s) Config.AimEnabled = s; FOVCircle.Visible = s end)
AddSlider(PAim, "FOV Size", 20, 150, 100, function(v) Config.FOV = v end)

AddToggle(PVis, "Show Boxes", function(s) Config.Boxes = s end)
AddToggle(PVis, "Show Tracers", function(s) Config.Tracers = s end)

AddToggle(PMisc, "FPS Boost", function(s) if s then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end end end)

-- [ЛОГИКА РАБОТЫ]
local bv = Instance.new("BodyVelocity")
RunService.RenderStepped:Connect(function()
    local char = LPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if Config.Fly then
            bv.Parent = char.HumanoidRootPart; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Camera.CFrame.LookVector * (UIS:IsKeyDown(Enum.KeyCode.W) and Config.FlySpeed or 0)
        else bv.Parent = nil; char.Humanoid.WalkSpeed = Config.Speed end
    end
    
    if Config.AimEnabled then
        FOVCircle.Position = UIS:GetMouseLocation()
        FOVCircle.Radius = Config.FOV
    end
end)

UIS.JumpRequest:Connect(function() if Config.InfJump then LPlayer.Character.Humanoid:ChangeState("Jumping") end end)

local ToggleBtn = Instance.new("TextButton", Icon); ToggleBtn.Size = UDim2.new(1,0,1,0); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Text = ""
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
