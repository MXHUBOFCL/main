local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService        = game:GetService("HttpService")
local CoreGui            = game:GetService("CoreGui")
local Workspace          = game:GetService("Workspace")
local LP                 = Players.LocalPlayer

local env = (getgenv and getgenv()) or _G
local ctx = env.MXHUB_CTX or {}

local execName  = ctx.ExecName or "Unknown"
local isBlocked = ctx.IsBlocked == true
local gameFile  = ctx.GameFile
local onSuccess = ctx.OnSuccess or function() end

local CONFIG = {
    Name     = "MX HUB",
    Subtitle = "Key system",
    Logo     = "rbxassetid://105865788976884",

    Discord  = "https://discord.gg/G7FCTC2mEk",
    Donate   = "https://sociabuzz.com/mxhub/tribe",

    GetKeyLink = "https://discord.gg/G7FCTC2mEk",
    Keys = { "MXHUB-KEY-1", "MXHUB-KEY-2" },
    SaveFile  = "MXHUB_Key.txt",
}

local function validateKey(key)
    for _, k in ipairs(CONFIG.Keys) do
        if key == k then
            return true, "Key valid"
        end
    end
    return false, "Invalid key"
end

local function fetchKeyLink()
    return CONFIG.GetKeyLink
end

local savedKey
pcall(function()
    if isfile and readfile and isfile(CONFIG.SaveFile) then
        savedKey = readfile(CONFIG.SaveFile):gsub("%s+", "")
    end
end)

if savedKey and savedKey ~= "" and not isBlocked and gameFile then
    local called, valid = pcall(validateKey, savedKey)
    if called and valid then
        env.MXHUB_KEY = savedKey
        onSuccess(savedKey)
        return
    end
end

local T = {
    Panel   = Color3.fromRGB(43, 45, 49),
    Card    = Color3.fromRGB(30, 31, 34),
    Stroke  = Color3.fromRGB(63, 65, 71),
    Button2 = Color3.fromRGB(78, 80, 88),
    Button2H= Color3.fromRGB(104, 107, 115),
    Accent  = Color3.fromRGB(88, 101, 242),
    AccentH = Color3.fromRGB(71, 82, 196),
    Text    = Color3.fromRGB(242, 243, 245),
    Muted   = Color3.fromRGB(148, 155, 164),
    Green   = Color3.fromRGB(35, 165, 90),
    Red     = Color3.fromRGB(242, 63, 66),
    Orange  = Color3.fromRGB(240, 177, 50),
}

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        o[k] = v
    end
    o.Parent = parent
    return o
end

local function corner(p, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

local function stroke(p, c, t)
    return new("UIStroke", {
        Color = c or T.Stroke,
        Thickness = 1,
        Transparency = t or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

local function tween(o, t, props)
    TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function label(parent, text, pos, size, color, ts, font, align)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Position = pos,
        Size = size,
        Text = text,
        TextColor3 = color,
        TextSize = ts,
        Font = font or Enum.Font.GothamMedium,
        TextXAlignment = align or Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

local SHEET = "rbxassetid://122605056588923"
local ICONS = {
    key   = Vector2.new(975, 50),
    arrow = Vector2.new(200, 100),
    globe = Vector2.new(450, 500),
    chat  = Vector2.new(325, 775),
}

local function icon(parent, name, pos, color)
    local holder = new("Frame", {
        Position = pos,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
    }, parent)
    new("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = SHEET,
        ImageColor3 = color,
        ImageRectOffset = ICONS[name],
        ImageRectSize = Vector2.new(24, 24),
    }, holder)
    return holder
end

local function heart(parent, pos, color)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Position = pos,
        Size = UDim2.fromOffset(16, 16),
        Text = "♥",
        TextColor3 = color,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
    }, parent)
end

local function copy(text)
    local fn = setclipboard or toclipboard
    if fn then
        return pcall(fn, text)
    end
    return false
end

local function hover(btn, normal, over)
    btn.MouseEnter:Connect(function() tween(btn, 0.15, { BackgroundColor3 = over }) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, { BackgroundColor3 = normal }) end)
end

local gui = new("ScreenGui", {
    Name = "MXHubKey",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

do
    local ok = pcall(function()
        gui.Parent = gethui()
    end)
    if not ok or not gui.Parent then
        ok = pcall(function() gui.Parent = CoreGui end)
    end
    if not ok or not gui.Parent then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end
    for _, c in ipairs(gui.Parent:GetChildren()) do
        if c ~= gui and c.Name == "MXHubKey" then
            c:Destroy()
        end
    end
end

local root = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(600, 340),
    BackgroundTransparency = 1,
}, gui)

local scale = new("UIScale", {}, root)
do
    local cam = Workspace.CurrentCamera
    local function fit()
        local v = cam.ViewportSize
        scale.Scale = math.clamp(math.min((v.X - 32) / 600, (v.Y - 32) / 340), 0.4, 1)
    end
    fit()
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

local shadow = new("ImageLabel", {
    Position = UDim2.new(0, -25, 0, -25),
    Size = UDim2.new(1, 50, 1, 50),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.new(0, 0, 0),
    ImageTransparency = 1,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
}, root)

local main = new("CanvasGroup", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = T.Panel,
    BorderSizePixel = 0,
    GroupTransparency = 1,
}, root)
corner(main, 10)
stroke(main, T.Stroke, 0.3)

new("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(300, 350),
    Size = UDim2.fromOffset(500, 180),
    BackgroundTransparency = 1,
    Image = "rbxassetid://8992230677",
    ImageColor3 = T.Accent,
    ImageTransparency = 0.88,
}, main)
new("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(586, 10),
    Size = UDim2.fromOffset(520, 240),
    BackgroundTransparency = 1,
    Image = "rbxassetid://8992230677",
    ImageColor3 = T.Accent,
    ImageTransparency = 0.93,
}, main)

local left = new("Frame", {
    Size = UDim2.fromOffset(356, 340),
    BackgroundTransparency = 1,
}, main)

new("ImageLabel", {
    Position = UDim2.fromOffset(28, 26),
    Size = UDim2.fromOffset(44, 40),
    BackgroundTransparency = 1,
    Image = CONFIG.Logo,
    ScaleType = Enum.ScaleType.Fit,
}, left)

local titleRow = new("Frame", {
    Position = UDim2.fromOffset(82, 26),
    Size = UDim2.fromOffset(250, 40),
    BackgroundTransparency = 1,
}, left)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
}, titleRow)

local function titlePart(text, size, color, font, order)
    return new("TextLabel", {
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        TextColor3 = color,
        TextSize = size,
        Font = font,
    }, titleRow)
end
titlePart(CONFIG.Name, 22, T.Text, Enum.Font.GothamBold, 1)
titlePart("|", 18, T.Stroke, Enum.Font.GothamMedium, 2)
titlePart(CONFIG.Subtitle, 13, T.Muted, Enum.Font.GothamMedium, 3)

label(left, "License key", UDim2.fromOffset(28, 100), UDim2.fromOffset(200, 14), T.Muted, 11)

local boxFrame = new("Frame", {
    Position = UDim2.fromOffset(28, 120),
    Size = UDim2.fromOffset(300, 40),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
}, left)
corner(boxFrame, 8)
local boxStroke = stroke(boxFrame)
icon(boxFrame, "key", UDim2.fromOffset(13, 12), T.Muted)

local box = new("TextBox", {
    Position = UDim2.fromOffset(40, 0),
    Size = UDim2.new(1, -52, 1, 0),
    BackgroundTransparency = 1,
    Text = savedKey or "",
    TextColor3 = T.Text,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    PlaceholderText = "Paste your key here",
    PlaceholderColor3 = T.Muted,
    ClearTextOnFocus = false,
    ClipsDescendants = true,
}, boxFrame)
box.Focused:Connect(function() tween(boxStroke, 0.15, { Color = T.Accent }) end)
box.FocusLost:Connect(function() tween(boxStroke, 0.15, { Color = T.Stroke }) end)

local submit = new("TextButton", {
    Position = UDim2.fromOffset(28, 176),
    Size = UDim2.fromOffset(144, 38),
    BackgroundColor3 = T.Accent,
    Text = "Submit",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, left)
corner(submit, 8)
new("UIPadding", { PaddingLeft = UDim.new(0, 22) }, submit)
icon(submit, "arrow", UDim2.fromOffset(-8, 11), Color3.new(1, 1, 1))
hover(submit, T.Accent, T.AccentH)

local getKey = new("TextButton", {
    Position = UDim2.fromOffset(184, 176),
    Size = UDim2.fromOffset(144, 38),
    BackgroundColor3 = T.Button2,
    Text = "Get a key",
    TextColor3 = T.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, left)
corner(getKey, 8)
new("UIPadding", { PaddingLeft = UDim.new(0, 22) }, getKey)
icon(getKey, "globe", UDim2.fromOffset(-8, 11), T.Text)
hover(getKey, T.Button2, T.Button2H)

local msg = label(left, "", UDim2.fromOffset(28, 232), UDim2.fromOffset(300, 16), T.Muted, 12)
local function setMsg(text, color)
    msg.Text = text
    msg.TextColor3 = color or T.Muted
end

label(left, "Your key is saved, you only enter it once",
    UDim2.fromOffset(28, 296), UDim2.fromOffset(300, 14), T.Muted, 11)

new("Frame", {
    Position = UDim2.fromOffset(356, 28),
    Size = UDim2.new(0, 1, 1, -56),
    BackgroundColor3 = T.Stroke,
    BorderSizePixel = 0,
}, main)

local right = new("Frame", {
    Position = UDim2.fromOffset(357, 0),
    Size = UDim2.fromOffset(244, 340),
    BackgroundTransparency = 1,
}, main)

label(right, "Detected game", UDim2.fromOffset(28, 30), UDim2.fromOffset(184, 14), T.Muted, 11)

local gameCard = new("Frame", {
    Position = UDim2.fromOffset(28, 50),
    Size = UDim2.fromOffset(188, 60),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
}, right)
corner(gameCard, 8)
stroke(gameCard)

local thumb = new("ImageLabel", {
    Position = UDim2.fromOffset(11, 11),
    Size = UDim2.fromOffset(38, 38),
    BackgroundColor3 = T.Panel,
    BorderSizePixel = 0,
    Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150",
}, gameCard)
corner(thumb, 7)
stroke(thumb)

local gameNameLbl = label(gameCard, "Loading...", UDim2.fromOffset(58, 15), UDim2.fromOffset(122, 14), T.Text, 12)
label(gameCard, gameFile and "In our list" or "Not in our list",
    UDim2.fromOffset(58, 32), UDim2.fromOffset(122, 13),
    gameFile and T.Green or T.Muted, 11)

task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    gameNameLbl.Text = (ok and info and info.Name) or "Unknown game"
end)

label(right, "Executor", UDim2.fromOffset(28, 126), UDim2.fromOffset(90, 14), T.Muted, 11)
label(right, execName, UDim2.fromOffset(120, 126), UDim2.fromOffset(96, 14), T.Text, 11, nil, Enum.TextXAlignment.Right)
label(right, "Status", UDim2.fromOffset(28, 148), UDim2.fromOffset(90, 14), T.Muted, 11)
label(right, isBlocked and "Not supported" or "Supported",
    UDim2.fromOffset(120, 148), UDim2.fromOffset(96, 14),
    isBlocked and T.Red or T.Green, 11, nil, Enum.TextXAlignment.Right)

new("Frame", {
    Position = UDim2.fromOffset(28, 176),
    Size = UDim2.fromOffset(188, 1),
    BackgroundColor3 = T.Stroke,
    BorderSizePixel = 0,
}, right)

local function linkCard(y, title, display, link, drawIcon)
    local btn = new("TextButton", {
        Position = UDim2.fromOffset(28, y),
        Size = UDim2.fromOffset(188, 48),
        BackgroundColor3 = T.Card,
        Text = "",
        AutoButtonColor = false,
    }, right)
    corner(btn, 8)
    stroke(btn)
    drawIcon(btn)
    label(btn, title, UDim2.fromOffset(40, 10), UDim2.fromOffset(120, 14), T.Text, 12)
    local sub = label(btn, display, UDim2.fromOffset(40, 25), UDim2.fromOffset(140, 13), T.Muted, 11)
    hover(btn, T.Card, Color3.fromRGB(38, 40, 44))

    local token = 0
    btn.Activated:Connect(function()
        token += 1
        local my = token
        if copy(link) then
            sub.Text = "Link copied!"
            sub.TextColor3 = T.Green
        else
            sub.Text = link
            sub.TextColor3 = T.Orange
        end
        task.delay(1.6, function()
            if token == my then
                sub.Text = display
                sub.TextColor3 = T.Muted
            end
        end)
    end)
end

linkCard(190, "Discord", "discord.gg/G7FCTC2mEk", CONFIG.Discord, function(b)
    icon(b, "chat", UDim2.fromOffset(13, 16), T.Accent)
end)
linkCard(246, "Donate", "sociabuzz.com/mxhub/tribe", CONFIG.Donate, function(b)
    heart(b, UDim2.fromOffset(13, 16), T.Accent)
end)

if isBlocked then
    setMsg(execName .. " not supported", T.Red)
else
    setMsg("Key required", T.Orange)
end

local fetching = false
getKey.Activated:Connect(function()
    if fetching then return end
    fetching = true
    setMsg("Getting key link...", T.Muted)
    task.spawn(function()
        local link = fetchKeyLink()
        if not link then
            setMsg("Failed to get key link", T.Red)
        elseif copy(link) then
            setMsg("Key link copied, open it in your browser", T.Green)
        else
            setMsg(link, T.Orange)
        end
        fetching = false
    end)
end)

local busy = false
local function trySubmit()
    if busy then return end
    if isBlocked then
        setMsg(execName .. " not supported", T.Red)
        return
    end

    local key = box.Text:gsub("%s+", "")
    if key == "" then
        setMsg("Key required", T.Orange)
        return
    end

    busy = true
    setMsg("Checking key...", T.Muted)

    local called, valid, text = pcall(validateKey, key)
    if not (called and valid) then
        setMsg(called and (text or "Invalid key") or "Validation error", T.Red)
        busy = false
        return
    end

    pcall(function()
        if writefile then writefile(CONFIG.SaveFile, key) end
    end)
    setMsg(text or "Key valid", T.Green)

    if not gameFile then
        setMsg("Key valid, but this game is not in our list", T.Orange)
        busy = false
        return
    end

    task.wait(0.6)
    tween(main, 0.25, { GroupTransparency = 1 })
    tween(shadow, 0.25, { ImageTransparency = 1 })
    task.wait(0.3)
    gui:Destroy()

    env.MXHUB_KEY = key
    onSuccess(key)
end

submit.Activated:Connect(trySubmit)
box.FocusLost:Connect(function(enter)
    if enter then trySubmit() end
end)

tween(main, 0.35, { GroupTransparency = 0 })
tween(shadow, 0.35, { ImageTransparency = 0.6 })
