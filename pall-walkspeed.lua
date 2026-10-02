--========================================================--
--  Pall Sprint                                         --
--  By @Pall                                            --
--  Fitur: Sprint + Bypass + UI + Theme                 --
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================= CONFIG =========================--
local SPRINT_KEY   = Enum.KeyCode.LeftShift
local NORMAL_SPEED = 16
local SPRINT_SPEED = 50
local SPEED_MIN    = 16
local SPEED_MAX    = 200

local TOGGLE_KEY   = Enum.KeyCode.V       -- toggle sprint
local BYPASS_KEY   = Enum.KeyCode.X       -- toggle bypass
local MINIMIZE_KEY = Enum.KeyCode.M
local HIDE_KEY     = Enum.KeyCode.H
local THEME_KEY    = Enum.KeyCode.T
local PANIC_KEY    = Enum.KeyCode.P

local DEFAULT_THEME = "light"

local PANEL_MIN_W = 200
local PANEL_MIN_H = 250
local PANEL_MAX_W = 400
local PANEL_MAX_H = 500
--==========================================================--

--========================= THEME =========================--
local THEMES = {
    light = {
        panelBg     = Color3.fromRGB(255, 255, 255),
        titleBg     = Color3.fromRGB(248, 248, 252),
        titleText   = Color3.fromRGB(30, 30, 40),
        divider     = Color3.fromRGB(230, 230, 238),
        btnBg       = Color3.fromRGB(245, 245, 250),
        btnHover    = Color3.fromRGB(235, 235, 245),
        btnText     = Color3.fromRGB(60, 60, 80),
        btnActive   = Color3.fromRGB(130, 130, 255),
        btnActiveTx = Color3.fromRGB(255, 255, 255),
        accent      = Color3.fromRGB(130, 130, 255),
        label       = Color3.fromRGB(80, 80, 100),
        statusText  = Color3.fromRGB(160, 160, 180),
        idleDot     = Color3.fromRGB(200, 200, 210),
        onDot       = Color3.fromRGB(100, 220, 130),
        onText      = Color3.fromRGB(80, 180, 110),
        offDot      = Color3.fromRGB(220, 120, 120),
        offText     = Color3.fromRGB(200, 80, 80),
        minBtnBg    = Color3.fromRGB(235, 235, 245),
        minBtnHov   = Color3.fromRGB(215, 215, 235),
        hideBtnBg   = Color3.fromRGB(255, 225, 225),
        hideBtnHov  = Color3.fromRGB(255, 190, 190),
        hideBtnTx   = Color3.fromRGB(200, 70, 70),
        themeBtnBg  = Color3.fromRGB(240, 240, 250),
        themeBtnHov = Color3.fromRGB(225, 225, 245),
        themeBtnTx  = Color3.fromRGB(120, 120, 180),
        resizeBg    = Color3.fromRGB(230, 230, 240),
        resizeHov   = Color3.fromRGB(200, 200, 230),
        resizeTx    = Color3.fromRGB(130, 130, 160),
        sliderTrack = Color3.fromRGB(45, 45, 58),
        sliderFill  = Color3.fromRGB(130, 130, 255),
        sliderThumb = Color3.fromRGB(255, 255, 255),
        sliderStr   = Color3.fromRGB(180, 180, 210),
        shadow      = Color3.fromRGB(180, 180, 200),
        keybindText = Color3.fromRGB(150, 150, 170),
        logoTx      = Color3.fromRGB(130, 130, 255),
    },
    dark = {
        panelBg     = Color3.fromRGB(28, 28, 38),
        titleBg     = Color3.fromRGB(38, 38, 50),
        titleText   = Color3.fromRGB(235, 235, 245),
        divider     = Color3.fromRGB(55, 55, 70),
        btnBg       = Color3.fromRGB(45, 45, 60),
        btnHover    = Color3.fromRGB(55, 55, 75),
        btnText     = Color3.fromRGB(220, 220, 235),
        btnActive   = Color3.fromRGB(130, 130, 255),
        btnActiveTx = Color3.fromRGB(255, 255, 255),
        accent      = Color3.fromRGB(150, 150, 255),
        label       = Color3.fromRGB(200, 200, 220),
        statusText  = Color3.fromRGB(160, 160, 190),
        idleDot     = Color3.fromRGB(120, 120, 140),
        onDot       = Color3.fromRGB(100, 220, 130),
        onText      = Color3.fromRGB(140, 230, 170),
        offDot      = Color3.fromRGB(220, 100, 100),
        offText     = Color3.fromRGB(255, 150, 150),
        minBtnBg    = Color3.fromRGB(50, 50, 70),
        minBtnHov   = Color3.fromRGB(70, 70, 95),
        hideBtnBg   = Color3.fromRGB(90, 45, 45),
        hideBtnHov  = Color3.fromRGB(120, 60, 60),
        hideBtnTx   = Color3.fromRGB(255, 200, 200),
        themeBtnBg  = Color3.fromRGB(50, 50, 70),
        themeBtnHov = Color3.fromRGB(70, 70, 95),
        themeBtnTx  = Color3.fromRGB(200, 200, 240),
        resizeBg    = Color3.fromRGB(50, 50, 70),
        resizeHov   = Color3.fromRGB(70, 70, 95),
        resizeTx    = Color3.fromRGB(180, 180, 210),
        sliderTrack = Color3.fromRGB(70, 70, 90),
        sliderFill  = Color3.fromRGB(150, 150, 255),
        sliderThumb = Color3.fromRGB(235, 235, 250),
        sliderStr   = Color3.fromRGB(90, 90, 120),
        shadow      = Color3.fromRGB(0, 0, 0),
        keybindText = Color3.fromRGB(160, 160, 190),
        logoTx      = Color3.fromRGB(180, 180, 255),
    },
}

local currentTheme = DEFAULT_THEME
local T = THEMES[currentTheme]
--==========================================================--

--========================= STATE =========================--
local sprintEnabled  = false      -- toggle sprint (bukan tahan tombol)
local bypassEnabled  = true
local flying         = false      -- gak dipake, placeholder
local sliderDragging = false
local isMinimized    = false
local isHidden       = false
local isResizing     = false
local resizeStart, resizeStartSize

--========================= SCREEN GUI =========================--
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PallSprintUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

--========================= PANEL =========================--
local PANEL_W = 220
local PANEL_H = 300

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(0, 20, 0.5, -PANEL_H/2)
panel.BackgroundColor3 = T.panelBg
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = panel

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, 4)
shadow.BackgroundColor3 = T.shadow
shadow.BackgroundTransparency = 0.72
shadow.BorderSizePixel = 0
shadow.ZIndex = panel.ZIndex - 1
shadow.Parent = panel
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow

--========================= TITLE BAR =========================--
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = T.titleBg
titleBar.BorderSizePixel = 0
titleBar.Parent = panel
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar
local titleFill = Instance.new("Frame")
titleFill.Size = UDim2.new(1, 0, 0, 14)
titleFill.Position = UDim2.new(0, 0, 1, -14)
titleFill.BackgroundColor3 = T.titleBg
titleFill.BorderSizePixel = 0
titleFill.Parent = titleBar

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 14, 0.5, -4)
dot.BackgroundColor3 = T.accent
dot.BorderSizePixel = 0
dot.Parent = titleBar
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Pall Sprint  |  By @Pall"
titleLabel.Size = UDim2.new(1, -130, 1, 0)
titleLabel.Position = UDim2.new(0, 30, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextColor3 = T.titleText
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Theme button
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 26, 0, 26)
themeBtn.Position = UDim2.new(1, -90, 0.5, -13)
themeBtn.BackgroundColor3 = T.themeBtnBg
themeBtn.BorderSizePixel = 0
themeBtn.Text = "☾"
themeBtn.TextColor3 = T.themeBtnTx
themeBtn.Font = Enum.Font.SourceSansBold
themeBtn.TextSize = 16
themeBtn.AutoButtonColor = false
themeBtn.Parent = titleBar
local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 8)
themeCorner.Parent = themeBtn

-- Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -13)
minimizeBtn.BackgroundColor3 = T.minBtnBg
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = T.btnText
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = titleBar
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Hide
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 26, 0, 26)
hideBtn.Position = UDim2.new(1, -30, 0.5, -13)
hideBtn.BackgroundColor3 = T.hideBtnBg
hideBtn.BorderSizePixel = 0
hideBtn.Text = "×"
hideBtn.TextColor3 = T.hideBtnTx
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 18
hideBtn.AutoButtonColor = false
hideBtn.Parent = titleBar
local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 8)
hideCorner.Parent = hideBtn

--========================= DIVIDER =========================--
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -28, 0, 1)
divider.Position = UDim2.new(0, 14, 0, 40)
divider.BackgroundColor3 = T.divider
divider.BorderSizePixel = 0
divider.Parent = panel

--========================= TOGGLE SPRINT BTN =========================--
local sprintBtn = Instance.new("TextButton")
sprintBtn.Size = UDim2.new(1, -28, 0, 38)
sprintBtn.Position = UDim2.new(0, 14, 0, 50)
sprintBtn.BackgroundColor3 = T.btnBg
sprintBtn.BorderSizePixel = 0
sprintBtn.Font = Enum.Font.GothamSemibold
sprintBtn.TextSize = 13
sprintBtn.TextColor3 = T.btnText
sprintBtn.Text = "▶  Enable Sprint  [V]"
sprintBtn.AutoButtonColor = false
sprintBtn.Parent = panel
local sprintCorner = Instance.new("UICorner")
sprintCorner.CornerRadius = UDim.new(0, 10)
sprintCorner.Parent = sprintBtn

--========================= DIVIDER 2 =========================--
local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, -28, 0, 1)
divider2.Position = UDim2.new(0, 14, 0, 100)
divider2.BackgroundColor3 = T.divider
divider2.BorderSizePixel = 0
divider2.Parent = panel

--========================= TOGGLE BYPASS =========================--
local bypassRow = Instance.new("Frame")
bypassRow.Size = UDim2.new(1, -28, 0, 30)
bypassRow.Position = UDim2.new(0, 14, 0, 110)
bypassRow.BackgroundTransparency = 1
bypassRow.Parent = panel

local bypassBtn = Instance.new("TextButton")
bypassBtn.Size = UDim2.new(0, 60, 0, 26)
bypassBtn.Position = UDim2.new(1, -60, 0.5, -13)
bypassBtn.BackgroundColor3 = T.btnActive
bypassBtn.BorderSizePixel = 0
bypassBtn.Font = Enum.Font.GothamSemibold
bypassBtn.TextSize = 11
bypassBtn.TextColor3 = T.btnActiveTx
bypassBtn.Text = "ON"
bypassBtn.AutoButtonColor = false
bypassBtn.Parent = bypassRow
local bypassCorner = Instance.new("UICorner")
bypassCorner.CornerRadius = UDim.new(0, 8)
bypassCorner.Parent = bypassBtn

local bypassLabel = Instance.new("TextLabel")
bypassLabel.Text = "Bypass Anti-Cheat [X]"
bypassLabel.Size = UDim2.new(1, -70, 1, 0)
bypassLabel.BackgroundTransparency = 1
bypassLabel.Font = Enum.Font.GothamSemibold
bypassLabel.TextSize = 11
bypassLabel.TextColor3 = T.label
bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
bypassLabel.Parent = bypassRow

--========================= SPEED SLIDER =========================--
local speedHeaderRow = Instance.new("Frame")
speedHeaderRow.Size = UDim2.new(1, -28, 0, 24)
speedHeaderRow.Position = UDim2.new(0, 14, 0, 150)
speedHeaderRow.BackgroundTransparency = 1
speedHeaderRow.Parent = panel

local speedTitleLbl = Instance.new("TextLabel")
speedTitleLbl.Text = "Speed"
speedTitleLbl.Size = UDim2.new(0.5, 0, 1, 0)
speedTitleLbl.BackgroundTransparency = 1
speedTitleLbl.Font = Enum.Font.GothamSemibold
speedTitleLbl.TextSize = 11
speedTitleLbl.TextColor3 = T.label
speedTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
speedTitleLbl.Parent = speedHeaderRow

local speedNumLbl = Instance.new("TextLabel")
speedNumLbl.Text = tostring(SPRINT_SPEED)
speedNumLbl.Size = UDim2.new(0.5, 0, 1, 0)
speedNumLbl.Position = UDim2.new(0.5, 0, 0, 0)
speedNumLbl.BackgroundTransparency = 1
speedNumLbl.Font = Enum.Font.GothamBold
speedNumLbl.TextSize = 11
speedNumLbl.TextColor3 = T.accent
speedNumLbl.TextXAlignment = Enum.TextXAlignment.Right
speedNumLbl.Parent = speedHeaderRow

local TRACK_H    = 6
local THUMB_SIZE = 18
local SLIDER_Y   = 184

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -28, 0, TRACK_H)
sliderTrack.Position = UDim2.new(0, 14, 0, SLIDER_Y + (THUMB_SIZE - TRACK_H)/2)
sliderTrack.BackgroundColor3 = T.sliderTrack
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = panel
local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = T.sliderFill
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local sliderThumb = Instance.new("Frame")
sliderThumb.Size = UDim2.new(0, THUMB_SIZE, 0, THUMB_SIZE)
sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
sliderThumb.Position = UDim2.new(0, 0, 0.5, 0)
sliderThumb.BackgroundColor3 = T.sliderThumb
sliderThumb.BorderSizePixel = 0
sliderThumb.ZIndex = 5
sliderThumb.Parent = sliderTrack
local thumbCorner = Instance.new("UICorner")
thumbCorner.CornerRadius = UDim.new(1, 0)
thumbCorner.Parent = sliderThumb
local thumbStroke = Instance.new("UIStroke")
thumbStroke.Color = T.sliderStr
thumbStroke.Thickness = 1.5
thumbStroke.Parent = sliderThumb

--========================= STATUS =========================--
local statusRow = Instance.new("Frame")
statusRow.Size = UDim2.new(1, -28, 0, 20)
statusRow.Position = UDim2.new(0, 14, 0, 222)
statusRow.BackgroundTransparency = 1
statusRow.Parent = panel

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 7, 0, 7)
statusDot.Position = UDim2.new(0, 0, 0.5, -3)
statusDot.BackgroundColor3 = T.idleDot
statusDot.BorderSizePixel = 0
statusDot.Parent = statusRow
local sDotCorner = Instance.new("UICorner")
sDotCorner.CornerRadius = UDim.new(1, 0)
sDotCorner.Parent = statusDot

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Sprint: OFF  |  By @Pall"
statusLabel.Size = UDim2.new(1, -14, 1, 0)
statusLabel.Position = UDim2.new(0, 14, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextColor3 = T.statusText
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusRow

--========================= KEYBIND INFO =========================--
local keybindRow = Instance.new("Frame")
keybindRow.Size = UDim2.new(1, -28, 0, 20)
keybindRow.Position = UDim2.new(0, 14, 0, 248)
keybindRow.BackgroundTransparency = 1
keybindRow.Parent = panel

local keybindLbl = Instance.new("TextLabel")
keybindLbl.Text = "V Sprint | X Bypass | M Min | H Hide | T Theme | P Panic"
keybindLbl.Size = UDim2.new(1, 0, 1, 0)
keybindLbl.BackgroundTransparency = 1
keybindLbl.Font = Enum.Font.Gotham
keybindLbl.TextSize = 9
keybindLbl.TextColor3 = T.keybindText
keybindLbl.TextXAlignment = Enum.TextXAlignment.Left
keybindLbl.Parent = keybindRow

--========================= RESIZE HANDLE =========================--
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 18, 0, 18)
resizeHandle.Position = UDim2.new(1, -18, 1, -18)
resizeHandle.AnchorPoint = Vector2.new(0, 0)
resizeHandle.BackgroundColor3 = T.resizeBg
resizeHandle.BorderSizePixel = 0
resizeHandle.Text = "⤡"
resizeHandle.TextColor3 = T.resizeTx
resizeHandle.Font = Enum.Font.SourceSansBold
resizeHandle.TextSize = 14
resizeHandle.AutoButtonColor = false
resizeHandle.ZIndex = 10
resizeHandle.Parent = panel
local resizeCorner = Instance.new("UICorner")
resizeCorner.CornerRadius = UDim.new(0, 6)
resizeCorner.Parent = resizeHandle

--========================= FLOATING LOGO =========================--
local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(0, 56, 0, 56)
logoBtn.Position = UDim2.new(0.5, -28, 0.5, -28)
logoBtn.BackgroundColor3 = T.btnActive
logoBtn.BorderSizePixel = 0
logoBtn.Text = "S"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextSize = 26
logoBtn.AutoButtonColor = false
logoBtn.Visible = false
logoBtn.Parent = screenGui
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoBtn
local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logoBtn

local logoTag = Instance.new("TextLabel")
logoTag.Size = UDim2.new(0, 80, 0, 14)
logoTag.Position = UDim2.new(0.5, -40, 0.5, 32)
logoTag.BackgroundTransparency = 1
logoTag.Font = Enum.Font.GothamBold
logoTag.TextSize = 10
logoTag.TextColor3 = T.logoTx
logoTag.Text = "By @Pall"
logoTag.Visible = false
logoTag.Parent = screenGui

--========================= BYPASS SYSTEM =========================--
local hasHooks = (type(getrawmetatable) == "function" and type(newcclosure) == "function")
local oldIndex = nil
local mt = nil

if hasHooks then
    mt = getrawmetatable(game)
    oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__index = newcclosure(function(self, key)
        if bypassEnabled and key == "WalkSpeed" and typeof(self) == "Instance" and self:IsA("Humanoid") then
            local char = player.Character
            if char and self:IsDescendantOf(char) then
                return NORMAL_SPEED
            end
        end
        return oldIndex(self, key)
    end)

    setreadonly(mt, true)
end

--========================= SPRINT LOGIC =========================--
local function getHumanoid()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildWhichIsA("Humanoid")
end

RunService.Heartbeat:Connect(function()
    local hum = getHumanoid()
    if not hum then return end

    local target
    if sprintEnabled then
        target = SPRINT_SPEED
    else
        target = NORMAL_SPEED
    end

    if hum.WalkSpeed ~= target then
        hum.WalkSpeed = target
    end
end)

--========================= SLIDER =========================--
local function applySliderPercent(pct)
    pct = math.clamp(pct, 0, 1)
    SPRINT_SPEED = math.floor(SPEED_MIN + pct * (SPEED_MAX - SPEED_MIN) + 0.5)
    speedNumLbl.Text = tostring(SPRINT_SPEED)

    local trackW = sliderTrack.AbsoluteSize.X
    local thumbX = pct * trackW
    sliderThumb.Position = UDim2.new(0, thumbX, 0.5, 0)
    sliderFill.Size = UDim2.new(0, thumbX, 1, 0)
end

local function initSlider()
    local pct = (SPRINT_SPEED - SPEED_MIN) / (SPEED_MAX - SPEED_MIN)
    applySliderPercent(pct)
end

task.defer(initSlider)

sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)
sliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not sliderDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and
       input.UserInputType ~= Enum.UserInputType.Touch then return end
    local trackPos = sliderTrack.AbsolutePosition.X
    local trackW   = sliderTrack.AbsoluteSize.X
    local mouseX   = input.Position.X
    applySliderPercent((mouseX - trackPos) / trackW)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

--========================= TOGGLE FUNCTIONS =========================--
local function setSprintUI(state)
    local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
    if state then
        TweenService:Create(sprintBtn, ti, { BackgroundColor3 = T.btnActive, TextColor3 = T.btnActiveTx }):Play()
        sprintBtn.Text = "■  Disable Sprint  [V]"
        TweenService:Create(statusDot, ti, { BackgroundColor3 = T.onDot }):Play()
        statusLabel.Text = "Sprint: ON  |  By @Pall"
        statusLabel.TextColor3 = T.onText
        dot.BackgroundColor3 = T.onDot
    else
        TweenService:Create(sprintBtn, ti, { BackgroundColor3 = T.btnBg, TextColor3 = T.btnText }):Play()
        sprintBtn.Text = "▶  Enable Sprint  [V]"
        TweenService:Create(statusDot, ti, { BackgroundColor3 = T.idleDot }):Play()
        statusLabel.Text = "Sprint: OFF  |  By @Pall"
        statusLabel.TextColor3 = T.statusText
        dot.BackgroundColor3 = T.accent
    end
end

local function toggleSprint()
    sprintEnabled = not sprintEnabled
    setSprintUI(sprintEnabled)
end

local function setBypassUI(state)
    if state then
        bypassBtn.BackgroundColor3 = T.btnActive
        bypassBtn.TextColor3 = T.btnActiveTx
        bypassBtn.Text = "ON"
    else
        bypassBtn.BackgroundColor3 = T.btnBg
        bypassBtn.TextColor3 = T.btnText
        bypassBtn.Text = "OFF"
    end
end

local function toggleBypass()
    bypassEnabled = not bypassEnabled
    setBypassUI(bypassEnabled)
end

--========================= MINIMIZE / HIDE =========================--
local function minimize()
    if isHidden then return end
    isMinimized = true
    panel.Visible = false
    logoBtn.Visible = true
    logoTag.Visible = true
end

local function restoreFromMinimize()
    isMinimized = false
    panel.Visible = true
    logoBtn.Visible = false
    logoTag.Visible = false
end

local function hidePanel()
    isHidden = true
    panel.Visible = false
    logoBtn.Visible = false
    logoTag.Visible = false
end

local function unhidePanel()
    isHidden = false
    if isMinimized then
        logoBtn.Visible = true
        logoTag.Visible = true
    else
        panel.Visible = true
    end
end

local function toggleMinimize()
    if isHidden then return end
    if isMinimized then restoreFromMinimize() else minimize() end
end

local function toggleHide()
    if isHidden then unhidePanel() else hidePanel() end
end

--========================= THEME APPLY =========================--
local function applyTheme(themeName)
    currentTheme = themeName
    T = THEMES[themeName]

    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
    local function tw(obj, props) TweenService:Create(obj, ti, props):Play() end

    tw(panel, { BackgroundColor3 = T.panelBg })
    tw(titleBar, { BackgroundColor3 = T.titleBg })
    tw(titleFill, { BackgroundColor3 = T.titleBg })
    tw(titleLabel, { TextColor3 = T.titleText })
    tw(divider, { BackgroundColor3 = T.divider })
    tw(divider2, { BackgroundColor3 = T.divider })
    tw(shadow, { BackgroundColor3 = T.shadow })

    tw(sprintBtn, { BackgroundColor3 = sprintEnabled and T.btnActive or T.btnBg })
    tw(sprintBtn, { TextColor3 = sprintEnabled and T.btnActiveTx or T.btnText })

    tw(speedTitleLbl, { TextColor3 = T.label })
    tw(speedNumLbl, { TextColor3 = T.accent })

    tw(sliderTrack, { BackgroundColor3 = T.sliderTrack })
    tw(sliderFill, { BackgroundColor3 = T.sliderFill })
    tw(sliderThumb, { BackgroundColor3 = T.sliderThumb })
    thumbStroke.Color = T.sliderStr

    tw(statusDot, { BackgroundColor3 = sprintEnabled and T.onDot or T.idleDot })
    tw(statusLabel, { TextColor3 = sprintEnabled and T.onText or T.statusText })

    tw(bypassLabel, { TextColor3 = T.label })
    tw(bypassBtn, { BackgroundColor3 = bypassEnabled and T.btnActive or T.btnBg })
    tw(bypassBtn, { TextColor3 = bypassEnabled and T.btnActiveTx or T.btnText })

    tw(keybindLbl, { TextColor3 = T.keybindText })

    tw(minimizeBtn, { BackgroundColor3 = T.minBtnBg, TextColor3 = T.btnText })
    tw(hideBtn, { BackgroundColor3 = T.hideBtnBg, TextColor3 = T.hideBtnTx })
    tw(themeBtn, { BackgroundColor3 = T.themeBtnBg, TextColor3 = T.themeBtnTx })
    themeBtn.Text = (themeName == "light") and "☾" or "☀"

    tw(resizeHandle, { BackgroundColor3 = T.resizeBg, TextColor3 = T.resizeTx })

    tw(dot, { BackgroundColor3 = sprintEnabled and T.onDot or T.accent })

    tw(logoBtn, { BackgroundColor3 = T.btnActive })
    tw(logoTag, { TextColor3 = T.logoTx })
end

local function toggleTheme()
    applyTheme(currentTheme == "light" and "dark" or "light")
end

--========================= BUTTON HOOKS =========================--
sprintBtn.MouseButton1Click:Connect(toggleSprint)
bypassBtn.MouseButton1Click:Connect(toggleBypass)
minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
hideBtn.MouseButton1Click:Connect(toggleHide)
themeBtn.MouseButton1Click:Connect(toggleTheme)

logoBtn.MouseButton1Click:Connect(function()
    if isMinimized then restoreFromMinimize() end
end)

-- Hover effect
local function addHover(btn, getNormal, getHover)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = getHover() }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = getNormal() }):Play()
    end)
end

addHover(minimizeBtn, function() return T.minBtnBg end, function() return T.minBtnHov end)
addHover(hideBtn, function() return T.hideBtnBg end, function() return T.hideBtnHov end)
addHover(themeBtn, function() return T.themeBtnBg end, function() return T.themeBtnHov end)
addHover(resizeHandle, function() return T.resizeBg end, function() return T.resizeHov end)

--========================= DRAG PANEL =========================--
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                     input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--========================= RESIZE PANEL =========================--
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        resizeStart = input.Position
        resizeStartSize = panel.AbsoluteSize
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not isResizing then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and
       input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - resizeStart
    local w = math.clamp(resizeStartSize.X + delta.X, PANEL_MIN_W, PANEL_MAX_W)
    local h = math.clamp(resizeStartSize.Y + delta.Y, PANEL_MIN_H, PANEL_MAX_H)
    panel.Size = UDim2.new(0, w, 0, h)
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

--========================= LOGO DRAG =========================--
local logoDragging, logoDragStart, logoStartPos
logoBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        logoDragging = true
        logoDragStart = input.Position
        logoStartPos = logoBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if logoDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - logoDragStart
        logoBtn.Position = UDim2.new(
            logoStartPos.X.Scale, logoStartPos.X.Offset + delta.X,
            logoStartPos.Y.Scale, logoStartPos.Y.Offset + delta.Y
        )
        logoTag.Position = UDim2.new(
            0, logoBtn.AbsolutePosition.X + logoBtn.AbsoluteSize.X/2 - 40,
            0, logoBtn.AbsolutePosition.Y + logoBtn.AbsoluteSize.Y + 4
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        logoDragging = false
    end
end)

--========================= PANIC =========================--
local function panicStop()
    sprintEnabled = false
    setSprintUI(false)

    local hum = getHumanoid()
    if hum then hum.WalkSpeed = NORMAL_SPEED end

    print("[Pall Sprint] Panic stop — speed reset ke normal")
end

--========================= KEYBINDS =========================--
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == TOGGLE_KEY then
        toggleSprint()
    elseif input.KeyCode == BYPASS_KEY then
        toggleBypass()
    elseif input.KeyCode == MINIMIZE_KEY then
        toggleMinimize()
    elseif input.KeyCode == HIDE_KEY then
        toggleHide()
    elseif input.KeyCode == THEME_KEY then
        toggleTheme()
    elseif input.KeyCode == PANIC_KEY then
        panicStop()
    end
end)

--========================= RESPAWN =========================--
player.CharacterAdded:Connect(function()
    sprintEnabled = false
    setSprintUI(false)
    task.defer(initSlider)
end)

--========================= INIT =========================--
setSprintUI(false)
setBypassUI(true)
applyTheme(DEFAULT_THEME)

if not hasHooks then
    warn("[Pall Sprint] Executor gak support hook — bypass gak aktif")
end
