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
    Panel    = Color3.fromRGB(17, 17, 17),
    PanelB   = Color3.fromRGB(10, 10, 10),
    Card     = Color3.fromRGB(25, 25, 25),
    CardH    = Color3.fromRGB(35, 35, 35),
    Stroke   = Color3.fromRGB(50, 50, 50),
    Button2  = Color3.fromRGB(34, 34, 34),
    Button2H = Color3.fromRGB(52, 52, 52),
    White    = Color3.fromRGB(245, 245, 245),
    WhiteH   = Color3.fromRGB(212, 212, 212),
    Black    = Color3.fromRGB(10, 10, 10),
    Text     = Color3.fromRGB(245, 245, 245),
    Muted    = Color3.fromRGB(138, 138, 138),
    Green    = Color3.fromRGB(86, 204, 124),
    Red      = Color3.fromRGB(240, 88, 88),
    Orange   = Color3.fromRGB(240, 180, 72),
}

local W, H = 480, 236

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

local IMAGES = {
    key     = "rbxassetid://120178273227579",
    getKey  = "rbxassetid://114756714804603",
    submit  = "rbxassetid://95391166128209",
    discord = "rbxassetid://127606113874611",
    donate  = "rbxassetid://105962055212659",
}

local function imageIcon(parent, image, pos, color)
    return new("ImageLabel", {
        Position = pos,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Image = image,
        ImageColor3 = color,
        ScaleType = Enum.ScaleType.Fit,
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
    Size = UDim2.fromOffset(W, H),
    BackgroundTransparency = 1,
}, gui)

local scale = new("UIScale", {}, root)
do
    local cam = Workspace.CurrentCamera
    local function fit()
        local v = cam.ViewportSize
        scale.Scale = math.clamp(math.min((v.X - 24) / W, (v.Y - 24) / H), 0.5, 1)
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

local main = new("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
}, root)
corner(main, 12)
stroke(main, T.Stroke, 0.1)
new("UIGradient", {
    Color = ColorSequence.new(T.Panel, T.PanelB),
    Rotation = 90,
}, main)

local left = new("Frame", {
    Size = UDim2.fromOffset(264, H),
    BackgroundTransparency = 1,
}, main)

new("ImageLabel", {
    Position = UDim2.fromOffset(20, 14),
    Size = UDim2.fromOffset(36, 32),
    BackgroundTransparency = 1,
    Image = CONFIG.Logo,
    ScaleType = Enum.ScaleType.Fit,
}, left)

local titleRow = new("Frame", {
    Position = UDim2.fromOffset(64, 14),
    Size = UDim2.fromOffset(196, 32),
    BackgroundTransparency = 1,
}, left)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 9),
}, titleRow)

local function titleText(text, order)
    return new("TextLabel", {
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        TextColor3 = T.Text,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
    }, titleRow)
end
titleText(CONFIG.Name, 1)
new("Frame", {
    LayoutOrder = 2,
    Size = UDim2.fromOffset(2, 18),
    BackgroundColor3 = T.Text,
    BorderSizePixel = 0,
}, titleRow)
titleText(CONFIG.Subtitle, 3)

label(left, "License key", UDim2.fromOffset(20, 60), UDim2.fromOffset(224, 14), T.Muted, 11)

local boxFrame = new("Frame", {
    Position = UDim2.fromOffset(20, 76),
    Size = UDim2.fromOffset(224, 36),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
}, left)
corner(boxFrame, 8)
local boxStroke = stroke(boxFrame)
imageIcon(boxFrame, IMAGES.key, UDim2.fromOffset(12, 10), T.Muted)

local box = new("TextBox", {
    Position = UDim2.fromOffset(36, 0),
    Size = UDim2.new(1, -46, 1, 0),
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
box.Focused:Connect(function() tween(boxStroke, 0.15, { Color = T.White }) end)
box.FocusLost:Connect(function() tween(boxStroke, 0.15, { Color = T.Stroke }) end)

local submit = new("TextButton", {
    Position = UDim2.fromOffset(20, 120),
    Size = UDim2.fromOffset(108, 34),
    BackgroundColor3 = T.White,
    Text = "Submit",
    TextColor3 = T.Black,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, left)
corner(submit, 8)
new("UIPadding", { PaddingLeft = UDim.new(0, 20) }, submit)
imageIcon(submit, IMAGES.submit, UDim2.fromOffset(-6, 9), T.Black)
hover(submit, T.White, T.WhiteH)

local getKey = new("TextButton", {
    Position = UDim2.fromOffset(136, 120),
    Size = UDim2.fromOffset(108, 34),
    BackgroundColor3 = T.Button2,
    Text = "Get a key",
    TextColor3 = T.Text,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, left)
corner(getKey, 8)
stroke(getKey)
new("UIPadding", { PaddingLeft = UDim.new(0, 20) }, getKey)
imageIcon(getKey, IMAGES.getKey, UDim2.fromOffset(-6, 9), T.Text)
hover(getKey, T.Button2, T.Button2H)

local msg = label(left, "", UDim2.fromOffset(20, 166), UDim2.fromOffset(224, 14), T.Muted, 11)
local function setMsg(text, color)
    msg.Text = text
    msg.TextColor3 = color or T.Muted
end

label(left, "Your key is saved, you only enter it once",
    UDim2.fromOffset(20, 208), UDim2.fromOffset(224, 12), T.Muted, 10)

new("Frame", {
    Position = UDim2.fromOffset(264, 16),
    Size = UDim2.new(0, 1, 1, -32),
    BackgroundColor3 = T.Stroke,
    BorderSizePixel = 0,
}, main)

local right = new("Frame", {
    Position = UDim2.fromOffset(265, 0),
    Size = UDim2.fromOffset(215, H),
    BackgroundTransparency = 1,
}, main)

label(right, "Detected game", UDim2.fromOffset(16, 16), UDim2.fromOffset(183, 14), T.Muted, 11)

local gameCard = new("Frame", {
    Position = UDim2.fromOffset(16, 32),
    Size = UDim2.fromOffset(183, 50),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
}, right)
corner(gameCard, 8)
stroke(gameCard)

local thumb = new("ImageLabel", {
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = T.Panel,
    BorderSizePixel = 0,
    Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150",
}, gameCard)
corner(thumb, 6)
stroke(thumb)

local gameNameLbl = label(gameCard, "Loading...", UDim2.fromOffset(50, 10), UDim2.fromOffset(126, 14), T.Text, 12, Enum.Font.GothamBold)
label(gameCard, gameFile and "In our list" or "Not in our list",
    UDim2.fromOffset(50, 27), UDim2.fromOffset(126, 12),
    gameFile and T.Green or T.Muted, 10)

task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    gameNameLbl.Text = (ok and info and info.Name) or "Unknown game"
end)

label(right, "Executor", UDim2.fromOffset(16, 92), UDim2.fromOffset(80, 14), T.Muted, 11)
label(right, execName, UDim2.fromOffset(100, 92), UDim2.fromOffset(99, 14), T.Text, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
label(right, "Status", UDim2.fromOffset(16, 110), UDim2.fromOffset(80, 14), T.Muted, 11)
label(right, isBlocked and "Not supported" or "Supported",
    UDim2.fromOffset(100, 110), UDim2.fromOffset(99, 14),
    isBlocked and T.Red or T.Green, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Right)

new("Frame", {
    Position = UDim2.fromOffset(16, 132),
    Size = UDim2.fromOffset(183, 1),
    BackgroundColor3 = T.Stroke,
    BorderSizePixel = 0,
}, right)

local function linkCard(y, title, display, link, drawIcon)
    local btn = new("TextButton", {
        Position = UDim2.fromOffset(16, y),
        Size = UDim2.fromOffset(183, 38),
        BackgroundColor3 = T.Card,
        Text = "",
        AutoButtonColor = false,
    }, right)
    corner(btn, 8)
    stroke(btn)
    drawIcon(btn)
    label(btn, title, UDim2.fromOffset(36, 5), UDim2.fromOffset(130, 14), T.Text, 12, Enum.Font.GothamBold)
    local sub = label(btn, display, UDim2.fromOffset(36, 20), UDim2.fromOffset(140, 12), T.Muted, 10)
    hover(btn, T.Card, T.CardH)

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

linkCard(142, "Discord", "discord.gg/G7FCTC2mEk", CONFIG.Discord, function(b)
    imageIcon(b, IMAGES.discord, UDim2.fromOffset(12, 11), T.Text)
end)
linkCard(186, "Donate", "sociabuzz.com/mxhub/tribe", CONFIG.Donate, function(b)
    imageIcon(b, IMAGES.donate, UDim2.fromOffset(12, 11), T.Text)
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

tween(shadow, 0.35, { ImageTransparency = 0.6 })
