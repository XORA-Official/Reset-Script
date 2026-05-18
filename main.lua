-- XORA HUB | Reset Character v3.3
-- Place inside a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════
-- CUSTOM LOGO BUILDER
-- Draws a thorny black-metal X using
-- rotated Frame instances (no asset ID needed)
-- ═══════════════════════════════════════
local function buildXLogo(parent, size)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, size, 0, size)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    container.Parent = parent

    local half = size / 2
    local thickness = size * 0.18   -- arm thickness
    local armLen   = size * 1.02    -- slightly longer than container

    -- helper: one arm of the X (a rotated rounded rect)
    local function makeArm(rot)
        local arm = Instance.new("Frame")
        arm.Size = UDim2.new(0, thickness, 0, armLen)
        arm.Position = UDim2.new(0, half - thickness / 2, 0, half - armLen / 2)
        arm.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        arm.BorderSizePixel = 0
        arm.Rotation = rot
        arm.ZIndex = 2
        arm.Parent = container

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 3)
        c.Parent = arm
        return arm
    end

    makeArm(45)
    makeArm(-45)

    -- ── thorn helper ──────────────────────────────────────────
    -- Creates a thin sharp spike (tall, narrow rounded rect)
    local function makeThorn(cx, cy, w, h, rot, alpha)
        alpha = alpha or 1
        local t = Instance.new("Frame")
        t.Size = UDim2.new(0, w, 0, h)
        t.Position = UDim2.new(0, cx - w/2, 0, cy - h/2)
        t.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        t.BackgroundTransparency = 1 - alpha
        t.BorderSizePixel = 0
        t.Rotation = rot
        t.ZIndex = 3
        t.Parent = container
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0.5, 0)
        c.Parent = t
    end

    -- outer wing spikes (4 diagonal corners)
    local sp = size * 0.32          -- spike pivot distance from center
    local sw = size * 0.055         -- spike width
    local sh = size * 0.28          -- spike height

    makeThorn(half - sp, half - sp, sw, sh,  -45, 0.92)   -- top-left
    makeThorn(half + sp, half - sp, sw, sh,   45, 0.92)   -- top-right
    makeThorn(half - sp, half + sp, sw, sh,   45, 0.92)   -- bottom-left
    makeThorn(half + sp, half + sp, sw, sh,  -45, 0.92)   -- bottom-right

    -- secondary shorter thorns along each arm
    local function sideThorn(cx, cy, rot, alpha)
        makeThorn(cx, cy, sw * 0.8, sh * 0.55, rot, alpha or 0.78)
    end

    -- top-left arm side thorns
    sideThorn(half - sp * 0.54, half - sp * 0.54,  45, 0.75)
    sideThorn(half - sp * 0.54, half - sp * 0.54, -90, 0.62)
    -- top-right arm
    sideThorn(half + sp * 0.54, half - sp * 0.54, -45, 0.75)
    sideThorn(half + sp * 0.54, half - sp * 0.54,  90, 0.62)
    -- bottom-left arm
    sideThorn(half - sp * 0.54, half + sp * 0.54, -45, 0.75)
    sideThorn(half - sp * 0.54, half + sp * 0.54,  90, 0.62)
    -- bottom-right arm
    sideThorn(half + sp * 0.54, half + sp * 0.54,  45, 0.75)
    sideThorn(half + sp * 0.54, half + sp * 0.54, -90, 0.62)

    -- wing barbs at the very tips
    local tip = size * 0.44
    local bw = sw * 0.7
    local bh = sh * 0.4
    makeThorn(half - tip, half - tip, bw, bh, -10, 0.82)
    makeThorn(half + tip, half - tip, bw, bh,  10, 0.82)
    makeThorn(half - tip, half + tip, bw, bh,  10, 0.82)
    makeThorn(half + tip, half + tip, bw, bh, -10, 0.82)

    -- center void overlay (small dark diamond to suggest skull-eye negative space)
    local voidSize = size * 0.18
    local void = Instance.new("Frame")
    void.Size = UDim2.new(0, voidSize, 0, voidSize)
    void.Position = UDim2.new(0, half - voidSize/2, 0, half - voidSize/2)
    void.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    void.BorderSizePixel = 0
    void.Rotation = 45
    void.ZIndex = 4
    void.Parent = container

    local vc = Instance.new("UICorner")
    vc.CornerRadius = UDim.new(0, 2)
    vc.Parent = void

    return container
end

-- ═══════════════════════════════════════
-- GUI SETUP
-- ═══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XORA_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════
-- TOGGLE BUTTON (custom X logo)
-- ═══════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -23)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.Text = ""
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 9)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(55, 55, 55)
ToggleStroke.Thickness = 1
ToggleStroke.Parent = ToggleBtn

-- Embed the logo inside the toggle button
local toggleLogo = buildXLogo(ToggleBtn, 34)
toggleLogo.Position = UDim2.new(0, 6, 0, 6)

-- ═══════════════════════════════════════
-- MAIN FRAME  (300 × 210)
-- ═══════════════════════════════════════
local OPEN_SIZE = UDim2.new(0, 300, 0, 210)

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = OPEN_SIZE
Frame.Position = UDim2.new(0, 64, 0.5, -105)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 13)
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(42, 42, 42)
FrameStroke.Thickness = 1
FrameStroke.Parent = Frame

-- ═══════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleBarFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBarFix.BorderSizePixel = 0
TitleBarFix.Parent = TitleBar

-- Logo in titlebar (custom X, 26×26)
local titleLogoHolder = Instance.new("Frame")
titleLogoHolder.Size = UDim2.new(0, 26, 0, 26)
titleLogoHolder.Position = UDim2.new(0, 10, 0.5, -13)
titleLogoHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLogoHolder.BorderSizePixel = 0
titleLogoHolder.ZIndex = 2
titleLogoHolder.Parent = TitleBar

local titleLogoHolderCorner = Instance.new("UICorner")
titleLogoHolderCorner.CornerRadius = UDim.new(0, 5)
titleLogoHolderCorner.Parent = titleLogoHolder

local titleLogo = buildXLogo(titleLogoHolder, 24)
titleLogo.Position = UDim2.new(0, 1, 0, 1)

-- Title text
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 90, 1, 0)
TitleLabel.Position = UDim2.new(0, 44, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "XORA HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Version badge
local VerBadge = Instance.new("Frame")
VerBadge.Size = UDim2.new(0, 38, 0, 16)
VerBadge.Position = UDim2.new(0, 136, 0.5, -8)
VerBadge.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
VerBadge.BorderSizePixel = 0
VerBadge.Parent = TitleBar

local VerBadgeCorner = Instance.new("UICorner")
VerBadgeCorner.CornerRadius = UDim.new(0, 3)
VerBadgeCorner.Parent = VerBadge

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(1, 0, 1, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v3.3"
VerLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
VerLabel.TextSize = 9
VerLabel.Font = Enum.Font.GothamBold
VerLabel.Parent = VerBadge

-- Close button (minimize)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
CloseBtn.Text = "−"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(1, 0)
CloseBtnCorner.Parent = CloseBtn

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.Position = UDim2.new(0, 10, 0, 44)
Divider.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Divider.BorderSizePixel = 0
Divider.Parent = Frame

-- ═══════════════════════════════════════
-- SECTION LABEL
-- ═══════════════════════════════════════
local SectionLabel = Instance.new("TextLabel")
SectionLabel.Size = UDim2.new(1, -20, 0, 14)
SectionLabel.Position = UDim2.new(0, 10, 0, 52)
SectionLabel.BackgroundTransparency = 1
SectionLabel.Text = "PLAYER CONTROL"
SectionLabel.TextColor3 = Color3.fromRGB(65, 65, 65)
SectionLabel.TextSize = 9
SectionLabel.Font = Enum.Font.GothamBold
SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel.Parent = Frame

-- ═══════════════════════════════════════
-- RESET CHARACTER BUTTON
-- ═══════════════════════════════════════
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1, -20, 0, 38)
ResetBtn.Position = UDim2.new(0, 10, 0, 68)
ResetBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.Text = "RESET CHARACTER"
ResetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ResetBtn.TextSize = 13
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.BorderSizePixel = 0
ResetBtn.Parent = Frame

local ResetBtnCorner = Instance.new("UICorner")
ResetBtnCorner.CornerRadius = UDim.new(0, 7)
ResetBtnCorner.Parent = ResetBtn

-- ═══════════════════════════════════════
-- TERMINATE / CLOSE SCRIPT BUTTON
-- ═══════════════════════════════════════
local TerminateBtn = Instance.new("TextButton")
TerminateBtn.Size = UDim2.new(1, -20, 0, 30)
TerminateBtn.Position = UDim2.new(0, 10, 0, 112)
TerminateBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TerminateBtn.Text = "CLOSE SCRIPT"
TerminateBtn.TextColor3 = Color3.fromRGB(180, 60, 60)
TerminateBtn.TextSize = 11
TerminateBtn.Font = Enum.Font.GothamBold
TerminateBtn.BorderSizePixel = 0
TerminateBtn.Parent = Frame

local TerminateBtnCorner = Instance.new("UICorner")
TerminateBtnCorner.CornerRadius = UDim.new(0, 7)
TerminateBtnCorner.Parent = TerminateBtn

local TerminateBtnStroke = Instance.new("UIStroke")
TerminateBtnStroke.Color = Color3.fromRGB(70, 30, 30)
TerminateBtnStroke.Thickness = 1
TerminateBtnStroke.Parent = TerminateBtn

-- Status row
local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 7, 0, 7)
StatusDot.Position = UDim2.new(0, 10, 0, 152)
StatusDot.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = Frame

local StatusDotCorner = Instance.new("UICorner")
StatusDotCorner.CornerRadius = UDim.new(1, 0)
StatusDotCorner.Parent = StatusDot

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -26, 0, 14)
StatusLabel.Position = UDim2.new(0, 24, 0, 145)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.fromRGB(75, 75, 75)
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Frame

-- Divider 2
local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(1, -20, 0, 1)
Divider2.Position = UDim2.new(0, 10, 0, 166)
Divider2.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Divider2.BorderSizePixel = 0
Divider2.Parent = Frame

-- ═══════════════════════════════════════
-- DISCORD ROW
-- ═══════════════════════════════════════
local DiscordIcon = Instance.new("TextLabel")
DiscordIcon.Size = UDim2.new(0, 16, 0, 18)
DiscordIcon.Position = UDim2.new(0, 10, 0, 174)
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Text = "🔗"
DiscordIcon.TextSize = 11
DiscordIcon.Font = Enum.Font.GothamBold
DiscordIcon.Parent = Frame

local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Size = UDim2.new(1, -80, 0, 18)
DiscordLabel.Position = UDim2.new(0, 28, 0, 174)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord.gg/f9P7aNqsby"
DiscordLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
DiscordLabel.TextSize = 10
DiscordLabel.Font = Enum.Font.Gotham
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.Parent = Frame

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 44, 0, 18)
CopyBtn.Position = UDim2.new(1, -54, 0, 174)
CopyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CopyBtn.Text = "COPY"
CopyBtn.TextColor3 = Color3.fromRGB(130, 130, 130)
CopyBtn.TextSize = 8
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.BorderSizePixel = 0
CopyBtn.Parent = Frame

local CopyBtnCorner = Instance.new("UICorner")
CopyBtnCorner.CornerRadius = UDim.new(0, 4)
CopyBtnCorner.Parent = CopyBtn

-- Footer
local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -20, 0, 13)
FooterLabel.Position = UDim2.new(0, 10, 0, 195)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text = "XORA HUB  •  educational use only"
FooterLabel.TextColor3 = Color3.fromRGB(32, 32, 32)
FooterLabel.TextSize = 8
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
FooterLabel.Parent = Frame

-- ═══════════════════════════════════════
-- DRAGGABLE
-- ═══════════════════════════════════════
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateDrag(input)
    end
end)

-- ═══════════════════════════════════════
-- OPEN / CLOSE
-- ═══════════════════════════════════════
local isOpen = true

local function setOpen(open)
    isOpen = open
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if open then
        Frame.Visible = true
        TweenService:Create(Frame, tweenInfo, { Size = OPEN_SIZE }):Play()
    else
        local t = TweenService:Create(Frame, tweenInfo, { Size = UDim2.new(0, 0, 0, 0) })
        t:Play()
        t.Completed:Connect(function()
            if not isOpen then
                Frame.Visible = false
                Frame.Size = OPEN_SIZE
            end
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function() setOpen(false) end)
ToggleBtn.MouseButton1Click:Connect(function() setOpen(not isOpen) end)

-- ═══════════════════════════════════════
-- HOVER EFFECTS
-- ═══════════════════════════════════════
ResetBtn.MouseEnter:Connect(function()
    TweenService:Create(ResetBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(210, 210, 210) }):Play()
end)
ResetBtn.MouseLeave:Connect(function()
    TweenService:Create(ResetBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
end)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(60, 60, 60) }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(32, 32, 32) }):Play()
end)
TerminateBtn.MouseEnter:Connect(function()
    TweenService:Create(TerminateBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(50, 18, 18) }):Play()
    TweenService:Create(TerminateBtn, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(220, 80, 80) }):Play()
end)
TerminateBtn.MouseLeave:Connect(function()
    TweenService:Create(TerminateBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(28, 28, 28) }):Play()
    TweenService:Create(TerminateBtn, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(180, 60, 60) }):Play()
end)

-- ═══════════════════════════════════════
-- RESET BUTTON LOGIC
-- ═══════════════════════════════════════
ResetBtn.MouseButton1Click:Connect(function()
    TweenService:Create(ResetBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(160, 160, 160) }):Play()
    StatusDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Text = "Resetting..."
    StatusLabel.TextColor3 = Color3.fromRGB(190, 190, 190)

    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character then
            v.Character:BreakJoints()
        end
    end

    task.wait(0.4)
    StatusDot.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    StatusLabel.Text = "Done"
    StatusLabel.TextColor3 = Color3.fromRGB(75, 75, 75)

    task.wait(0.3)
    TweenService:Create(ResetBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()

    task.wait(1.5)
    StatusLabel.Text = "Ready"
end)

-- ═══════════════════════════════════════
-- TERMINATE / CLOSE SCRIPT
-- ═══════════════════════════════════════
TerminateBtn.MouseButton1Click:Connect(function()
    TweenService:Create(TerminateBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(90, 20, 20)
    }):Play()
    task.wait(0.15)

    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local t = TweenService:Create(Frame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    t:Play()

    TweenService:Create(ToggleBtn, TweenInfo.new(0.25), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()

    t.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- ═══════════════════════════════════════
-- COPY DISCORD
-- ═══════════════════════════════════════
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/f9P7aNqsby")
    end
    CopyBtn.Text = "✓"
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(1.5)
    CopyBtn.Text = "COPY"
    CopyBtn.TextColor3 = Color3.fromRGB(130, 130, 130)
end)
