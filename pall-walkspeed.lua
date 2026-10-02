--[[ 
  WalkSpeed Controller UI + Keybind
  - Draggable panel
  - Slider 30 to 100
  - Enforces WalkSpeed every 0.01s
  - Inf Jump toggle
  - Noclip toggle
  - Minimize to draggable shoe icon, click to restore
  - Close button
  - Keybind support
  Credit: chimera__gaming
  Keybind update: @Pall
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--========================= CONFIG KEYBIND =========================--
local KEY_INFJUMP   = Enum.KeyCode.V      -- toggle Inf Jump
local KEY_NOCLIP    = Enum.KeyCode.B      -- toggle Noclip
local KEY_WS_DOWN   = Enum.KeyCode.J      -- WalkSpeed -5
local KEY_WS_UP     = Enum.KeyCode.K      -- WalkSpeed +5
local KEY_WS_RESET  = Enum.KeyCode.L      -- reset WalkSpeed ke 30
local KEY_MINIMIZE  = Enum.KeyCode.M      -- minimize / restore
local KEY_HIDE      = Enum.KeyCode.H      -- hide total
local KEY_PANIC     = Enum.KeyCode.P      -- panic stop
--==================================================================--

-- Helpers
local function waitForHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    while not hum do
        char = player.Character or player.CharacterAdded:Wait()
        hum = char:FindFirstChildWhichIsA("Humanoid")
        task.wait(0.05)
    end
    return hum
end

local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- UI Build
local gui = Instance.new("ScreenGui")
gui.Name = "WS_Controller"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(300, 130)
panel.Position = UDim2.new(0.5, -150, 0.4, -85)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
panel.Parent = gui

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", panel)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(80, 120, 255)
stroke.Transparency = 0.25

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
titleBar.Parent = panel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 235, 255)
title.Text = "WalkSpeed Controller"
title.Parent = titleBar

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.fromOffset(36, 24)
minBtn.Position = UDim2.new(1, -84, 0.5, -12)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
minBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
minBtn.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.fromOffset(36, 24)
closeBtn.Position = UDim2.new(1, -44, 0.5, -12)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
closeBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.Parent = titleBar

-- Body container
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, -24, 1, -36)
body.Position = UDim2.new(0, 12, 0, 34)
body.BackgroundTransparency = 1
body.Parent = panel

-- Labels
local wsLabel = Instance.new("TextLabel")
wsLabel.BackgroundTransparency = 1
wsLabel.Size = UDim2.new(1, 0, 0, 24)
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextSize = 14
wsLabel.TextColor3 = Color3.fromRGB(210, 215, 230)
wsLabel.Text = "WalkSpeed  [J -] [K +] [L Reset]"
wsLabel.Parent = body

local valueLabel = Instance.new("TextLabel")
valueLabel.BackgroundTransparency = 1
valueLabel.Size = UDim2.new(0, 60, 0, 24)
valueLabel.Position = UDim2.new(1, -60, 0, 0)
valueLabel.TextXAlignment = Enum.TextXAlignment.Right
valueLabel.Font = Enum.Font.GothamMedium
valueLabel.TextSize = 14
valueLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
valueLabel.Text = "30"
valueLabel.Parent = body

-- Slider track
local track = Instance.new("Frame")
track.Name = "Track"
track.Size = UDim2.new(1, 0, 0, 8)
track.Position = UDim2.new(0, 0, 0, 42)
track.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
Instance.new("UICorner", track).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", track).Color = Color3.fromRGB(80, 120, 255)
track.Parent = body

-- Slider fill
local fill = Instance.new("Frame")
fill.Name = "Fill"
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)
fill.Parent = track

-- Slider knob
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Size = UDim2.fromOffset(16, 16)
knob.Position = UDim2.new(0, -8, 0.5, -8)
knob.BackgroundColor3 = Color3.fromRGB(220, 230, 255)
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", knob).Color = Color3.fromRGB(40, 70, 160)
knob.Parent = track

-- Toggles row (compact)
local togglesRow = Instance.new("Frame")
togglesRow.Size = UDim2.new(1, 0, 0, 22)
togglesRow.Position = UDim2.new(0, 0, 0, 68)
togglesRow.BackgroundTransparency = 1
togglesRow.Parent = body

local uiList = Instance.new("UIListLayout", togglesRow)
uiList.FillDirection = Enum.FillDirection.Horizontal
uiList.Padding = UDim.new(0, 8)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiList.VerticalAlignment = Enum.VerticalAlignment.Center

local function makeToggle(name, labelText)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.AutomaticSize = Enum.AutomaticSize.None
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.TextColor3 = Color3.fromRGB(210, 215, 230)
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.Text = labelText .. ": OFF"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(80, 120, 255)
    btn.Parent = togglesRow
    return btn
end

local infJumpBtn = makeToggle("InfJumpBtn", "Inf Jump [V]")
local noclipBtn  = makeToggle("NoclipBtn" , "Noclip [B]")

-- Credit
local credit = Instance.new("TextLabel")
credit.BackgroundTransparency = 1
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -10)
credit.TextXAlignment = Enum.TextXAlignment.Center
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(160, 170, 200)
credit.Text = "credit Chimera__Gaming  |  Keybind by @Pall"
credit.Parent = body

-- Shoe icon minimized button
local shoe = Instance.new("TextButton")
shoe.Name = "ShoeIcon"
shoe.Visible = false
shoe.Text = "👟"
shoe.Font = Enum.Font.GothamBold
shoe.TextSize = 20
shoe.Size = UDim2.fromOffset(40, 40)
shoe.Position = UDim2.new(0.5, -20, 0.45, -20)
shoe.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
shoe.TextColor3 = Color3.fromRGB(220, 230, 255)
Instance.new("UICorner", shoe).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", shoe).Color = Color3.fromRGB(80, 120, 255)
shoe.Parent = gui

-- Draggable
makeDraggable(panel, titleBar)
makeDraggable(shoe, shoe)

-- Slider logic
local MIN_WS = 30
local MAX_WS = 100
local currentWS = MIN_WS

local draggingSlider = false

local function refreshSlider()
    local alpha = (currentWS - MIN_WS) / (MAX_WS - MIN_WS)
    valueLabel.Text = tostring(currentWS)
    fill.Size = UDim2.new(alpha, 0, 1, 0)
    knob.Position = UDim2.new(alpha, -8, 0.5, -8)
end

local function setSliderFromX(x)
    local absX = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
    local alpha = absX / track.AbsoluteSize.X
    local val = math.floor(MIN_WS + alpha * (MAX_WS - MIN_WS) + 0.5)
    currentWS = math.clamp(val, MIN_WS, MAX_WS)
    refreshSlider()
end

track.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        setSliderFromX(input.Position.X)
    end
end)

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or
                           input.UserInputType == Enum.UserInputType.Touch) then
        setSliderFromX(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

task.defer(function()
    refreshSlider()
end)

-- State
local running = true
local infJumpEnabled = false
local noclipEnabled = false
local isMinimized = false
local isHidden = false

-- Minimize / Hide functions
local function minimizePanel()
    isMinimized = true
    isHidden = false
    panel.Visible = false
    shoe.Visible = true
end

local function restorePanel()
    isMinimized = false
    isHidden = false
    panel.Visible = true
    shoe.Visible = false
end

local function hidePanel()
    isHidden = true
    isMinimized = false
    panel.Visible = false
    shoe.Visible = false
end

local function toggleMinimize()
    if isHidden then return end
    if isMinimized then restorePanel() else minimizePanel() end
end

local function toggleHide()
    if isHidden then
        restorePanel()
    else
        hidePanel()
    end
end

-- Toggle helpers
local function setToggle(btn, enabled, baseText)
    btn.TextColor3 = enabled and Color3.fromRGB(180, 255, 200) or Color3.fromRGB(210, 215, 230)
    btn.BackgroundColor3 = enabled and Color3.fromRGB(35, 70, 45) or Color3.fromRGB(40, 40, 48)
    btn.Text = baseText .. (enabled and ": ON" or ": OFF")
end

local function toggleInfJump()
    infJumpEnabled = not infJumpEnabled
    setToggle(infJumpBtn, infJumpEnabled, "Inf Jump [V]")
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    setToggle(noclipBtn, noclipEnabled, "Noclip [B]")
end

infJumpBtn.MouseButton1Click:Connect(toggleInfJump)
noclipBtn.MouseButton1Click:Connect(toggleNoclip)

minBtn.MouseButton1Click:Connect(toggleMinimize)
shoe.MouseButton1Click:Connect(restorePanel)

closeBtn.MouseButton1Click:Connect(function()
    running = false
    gui:Destroy()
end)

-- WalkSpeed adjust helpers
local function changeWalkSpeed(delta)
    currentWS = math.clamp(currentWS + delta, MIN_WS, MAX_WS)
    refreshSlider()
end

local function resetWalkSpeed()
    currentWS = MIN_WS
    refreshSlider()
end

-- Panic stop
local function panicStop()
    infJumpEnabled = false
    noclipEnabled = false
    setToggle(infJumpBtn, false, "Inf Jump [V]")
    setToggle(noclipBtn, false, "Noclip [B]")
    currentWS = MIN_WS
    refreshSlider()

    -- Nyalain balik collision
    local char = player.Character
    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CanCollide = true
            end
        end
    end

    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.WalkSpeed = MIN_WS end

    print("[WalkSpeed] Panic stop — semua fitur dimatiin")
end

-- WalkSpeed enforcer loop
task.spawn(function()
    local hum = waitForHumanoid()
    player.CharacterAdded:Connect(function()
        hum = waitForHumanoid()
    end)
    while running do
        if hum and hum.Parent then
            hum.WalkSpeed = currentWS
        else
            hum = waitForHumanoid()
        end
        task.wait(0.01)
    end
end)

-- Inf Jump
task.spawn(function()
    local hum = waitForHumanoid()
    player.CharacterAdded:Connect(function()
        hum = waitForHumanoid()
    end)
    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and hum and hum.Parent then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hum.Jump = true
        end
    end)
end)

-- Noclip
task.spawn(function()
    while running do
        if noclipEnabled then
            local char = player.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CanCollide = false
                    end
                end
            end
        end
        RunService.Stepped:Wait()
    end
end)

--========================= KEYBIND LISTENER =========================--
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == KEY_INFJUMP then
        toggleInfJump()
    elseif input.KeyCode == KEY_NOCLIP then
        toggleNoclip()
    elseif input.KeyCode == KEY_WS_DOWN then
        changeWalkSpeed(-5)
    elseif input.KeyCode == KEY_WS_UP then
        changeWalkSpeed(5)
    elseif input.KeyCode == KEY_WS_RESET then
        resetWalkSpeed()
    elseif input.KeyCode == KEY_MINIMIZE then
        toggleMinimize()
    elseif input.KeyCode == KEY_HIDE then
        toggleHide()
    elseif input.KeyCode == KEY_PANIC then
        panicStop()
    end
end)
