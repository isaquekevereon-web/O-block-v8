-- O-BLOCK V8 COMPLETO | Aimbot + ESP + FOV + Wall Check + Minimize
-- Interface PvP com indicadores de jogadores e controle de camera
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local LP = Players.LocalPlayer
local PG = LP:WaitForChild('PlayerGui')
if _G.OBLOCK_V8_STOP then pcall(_G.OBLOCK_V8_STOP) end
local previous = PG:FindFirstChild('OBLOCK_V8')
if previous then previous:Destroy() end
local active, holding = true, false
local connections, esp = {}, {}
local state = {Aim=false, Box=false, Health=false, FOV=true, Wall=true, Dead=true, Team=false, Radius=140, Smooth=0.18}
local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end
local function corner(parent, radius)
    local obj = Instance.new('UICorner')
    obj.CornerRadius = UDim.new(0, radius)
    obj.Parent = parent
end
local gui = Instance.new('ScreenGui')
gui.Name = 'OBLOCK_V8'
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PG
local panel = Instance.new('Frame')
panel.Size = UDim2.fromOffset(310, 435)
panel.Position = UDim2.new(0.5,-155,0.5,-217)
panel.BackgroundColor3 = Color3.fromRGB(16,10,26)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui
corner(panel, 14)
local outline = Instance.new('UIStroke')
outline.Color = Color3.fromRGB(172,76,255)
outline.Thickness = 2
outline.Parent = panel
local grad = Instance.new('UIGradient')
grad.Color = ColorSequence.new(Color3.fromRGB(20,11,34),Color3.fromRGB(68,22,100))
grad.Rotation = 25
grad.Parent = panel
local tween = TweenService:Create(grad,TweenInfo.new(4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Rotation=170})
tween:Play()
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1,-100,0,44)
title.Position = UDim2.fromOffset(12,3)
title.BackgroundTransparency = 1
title.Text = 'O-BLOCK 👺 | V8'
title.TextColor3 = Color3.fromRGB(231,192,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.Active = true
title.Parent = panel
local function headerButton(text, offset)
    local b = Instance.new('TextButton')
    b.Size = UDim2.fromOffset(32,30)
    b.Position = UDim2.new(1,offset,0,10)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 20
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = Color3.fromRGB(99,38,153)
    b.Parent = panel
    corner(b,8)
    return b
end
local minimize = headerButton('-',-78)
local close = headerButton('×',-40)
local scroll = Instance.new('ScrollingFrame')
scroll.Size = UDim2.new(1,-24,1,-98)
scroll.Position = UDim2.fromOffset(12,52)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new()
scroll.Parent = panel
local list = Instance.new('UIListLayout')
list.Padding = UDim.new(0,7)
list.Parent = scroll
local function action(text, callback)
    local b = Instance.new('TextButton')
    b.Size = UDim2.new(1,-6,0,41)
    b.BackgroundColor3 = Color3.fromRGB(53,27,78)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.Parent = scroll
    corner(b,8)
    connect(b.MouseButton1Click,function() callback(b) end)
    return b
end
local aimButton
local function toggle(label, key)
    local b
    local function refresh()
        b.Text = label .. ': ' .. (state[key] and 'ON' or 'OFF')
        b.BackgroundColor3 = state[key] and Color3.fromRGB(105,39,160) or Color3.fromRGB(53,27,78)
    end
    b = action('',function()
        state[key] = not state[key]
        refresh()
        if key == 'Aim' then
            aimButton.Visible = state.Aim
            if not state.Aim then holding = false end
        end
    end)
    refresh()
end
-- Button created before toggles so visibility changes work
 aimButton = Instance.new('TextButton')
aimButton.Size = UDim2.fromOffset(82,52)
aimButton.Position = UDim2.new(1,-98,0.58,0)
aimButton.Text = '🎯 MIRAR'
aimButton.Font = Enum.Font.GothamBold
aimButton.TextSize = 13
aimButton.TextColor3 = Color3.new(1,1,1)
aimButton.BackgroundColor3 = Color3.fromRGB(101,36,159)
aimButton.Visible = false
aimButton.Parent = gui
corner(aimButton,12)
connect(aimButton.InputBegan,function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then holding = true end
end)
connect(aimButton.InputEnded,function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then holding = false end
end)
toggle('🎯 AIMBOT HEAD','Aim')
toggle('📦 ESP BOX','Box')
toggle('❤️ HEALTH BAR','Health')
toggle('⭕ FOV CIRCLE','FOV')
toggle('🧱 WALL CHECK','Wall')
toggle('💀 IGNORE DEAD','Dead')
toggle('🛡️ TEAM CHECK','Team')
action('⭕ FOV: 140',function(b)
    state.Radius = state.Radius + 25
    if state.Radius > 350 then state.Radius = 50 end
    b.Text = '⭕ FOV: '..state.Radius
end)
action('🎚️ SMOOTH: 0.18',function(b)
    state.Smooth = state.Smooth + 0.1
    if state.Smooth > 0.85 then state.Smooth = 0.08 end
    b.Text = string.format('🎚️ SMOOTH: %.2f',state.Smooth)
end)
local footer = Instance.new('TextLabel')
footer.Size = UDim2.new(1,0,0,28)
footer.Position = UDim2.new(0,0,1,-32)
footer.BackgroundTransparency = 1
footer.Text = 'OUTSIDE PVP | O-BLOCK SYSTEM'
footer.TextColor3 = Color3.fromRGB(209,157,255)
footer.TextSize = 11
footer.Font = Enum.Font.GothamBold
footer.Parent = panel
local floating = Instance.new('TextButton')
floating.Size = UDim2.fromOffset(56,56)
floating.Position = UDim2.new(0,16,0.5,-28)
floating.Text = '👺'
floating.TextSize = 28
floating.BackgroundColor3 = Color3.fromRGB(59,21,91)
floating.TextColor3 = Color3.new(1,1,1)
floating.Visible = false
floating.Active = true
floating.Parent = gui
corner(floating,28)
local floatingStroke = Instance.new('UIStroke')
floatingStroke.Color = Color3.fromRGB(177,79,255)
floatingStroke.Thickness = 2
floatingStroke.Parent = floating
connect(minimize.MouseButton1Click,function() panel.Visible = false floating.Visible = true end)
connect(floating.MouseButton1Click,function() floating.Visible = false panel.Visible = true end)
local function makeDraggable(handle, target)
    local dragging, startPos, initial, dragInput = false,nil,nil,nil
    connect(handle.InputBegan,function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            initial = target.Position
            connect(input.Changed,function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    connect(handle.InputChanged,function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    connect(UIS.InputChanged,function(input)
        if dragging and input == dragInput then
            local delta = input.Position - startPos
            target.Position = UDim2.new(initial.X.Scale,initial.X.Offset+delta.X,initial.Y.Scale,initial.Y.Offset+delta.Y)
        end
    end)
end
makeDraggable(title,panel)
makeDraggable(floating,floating)
local fov = Instance.new('Frame')
fov.AnchorPoint = Vector2.new(0.5,0.5)
fov.BackgroundTransparency = 1
fov.Parent = gui
corner(fov,1000)
local fovStroke = Instance.new('UIStroke')
fovStroke.Color = Color3.fromRGB(185,80,255)
fovStroke.Thickness = 2
fovStroke.Parent = fov
local function playerParts(p)
    if p == LP then return end
    if state.Team and LP.Team and p.Team == LP.Team then return end
    local char = p.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass('Humanoid')
    local head = char:FindFirstChild('Head')
    local root = char:FindFirstChild('HumanoidRootPart')
    if not hum or not head or not root then return end
    if state.Dead and hum.Health <= 0 then return end
    return char,hum,head,root
end
local function wallVisible(camera,char,head)
    if not state.Wall then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {camera}
    if LP.Character then table.insert(ignore,LP.Character) end
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true
    local origin = camera.CFrame.Position
    local result = workspace:Raycast(origin,head.Position-origin,params)
    return result and result.Instance:IsDescendantOf(char) or false
end
local function targetHead(camera)
    local size = camera.ViewportSize
    local center = Vector2.new(size.X/2,size.Y/2)
    local best, distance = nil,state.Radius
    for _,p in ipairs(Players:GetPlayers()) do
        local char,_,head = playerParts(p)
        if char then
            local point,shown = camera:WorldToViewportPoint(head.Position)
            if shown and point.Z > 0 then
                local d = (Vector2.new(point.X,point.Y)-center).Magnitude
                if d < distance and wallVisible(camera,char,head) then
                    distance = d
                    best = head
                end
            end
        end
    end
    return best
end
local function clearESP(p)
    if esp[p] then esp[p].box:Destroy() esp[p] = nil end
end
local function updateESP(p,camera)
    if not state.Box and not state.Health then clearESP(p) return end
    local char,hum,head,root = playerParts(p)
    if not char then clearESP(p) return end
    local top,shown = camera:WorldToViewportPoint(head.Position+Vector3.new(0,0.7,0))
    local bottom = camera:WorldToViewportPoint(root.Position-Vector3.new(0,3,0))
    if not shown or top.Z <= 0 or bottom.Z <= 0 then clearESP(p) return end
    local h = math.abs(bottom.Y-top.Y)
    if h < 3 then clearESP(p) return end
    if not esp[p] then
        local box = Instance.new('Frame')
        box.BackgroundTransparency = 1
        box.Parent = gui
        local stroke = Instance.new('UIStroke')
        stroke.Color = Color3.fromRGB(180,75,255)
        stroke.Thickness = 2
        stroke.Parent = box
        local back = Instance.new('Frame')
        back.Size = UDim2.new(0,5,1,0)
        back.Position = UDim2.fromOffset(-10,0)
        back.BackgroundColor3 = Color3.fromRGB(90,24,24)
        back.BorderSizePixel = 0
        back.Parent = box
        local fill = Instance.new('Frame')
        fill.AnchorPoint = Vector2.new(0,1)
        fill.Position = UDim2.fromScale(0,1)
        fill.BackgroundColor3 = Color3.fromRGB(0,255,40)
        fill.BorderSizePixel = 0
        fill.Parent = back
        esp[p] = {box=box,stroke=stroke,back=back,fill=fill}
    end
    local item = esp[p]
    local w = h * 0.55
    item.box.Size = UDim2.fromOffset(w,h)
    item.box.Position = UDim2.fromOffset(top.X-w/2,math.min(top.Y,bottom.Y))
    item.stroke.Enabled = state.Box
    item.back.Visible = state.Health
    local ratio = math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
    item.fill.Size = UDim2.fromScale(1,ratio)
    item.fill.BackgroundColor3 = Color3.fromRGB(math.floor(255*(1-ratio)),math.floor(255*ratio),30)
end
local elapsed = 0
connect(RunService.RenderStepped,function(dt)
    if not active then return end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local size = camera.ViewportSize
    fov.Visible = state.FOV
    fov.Size = UDim2.fromOffset(state.Radius*2,state.Radius*2)
    fov.Position = UDim2.fromOffset(size.X/2,size.Y/2)
    if state.Aim and holding then
        local head = targetHead(camera)
        if head and head.Parent then
            local desired = CFrame.lookAt(camera.CFrame.Position,head.Position)
            camera.CFrame = camera.CFrame:Lerp(desired,math.clamp(state.Smooth,0.01,1))
        end
    end
    elapsed = elapsed + dt
    if elapsed >= 0.1 then
        elapsed = 0
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LP then updateESP(p,camera) end
        end
    end
end)
connect(Players.PlayerRemoving,clearESP)
local function cleanup()
    active = false
    holding = false
    tween:Cancel()
    for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    for p in pairs(esp) do clearESP(p) end
    gui:Destroy()
end
_G.OBLOCK_V8_STOP = cleanup
connect(close.MouseButton1Click,cleanup)
print('O-BLOCK V8 loaded')
