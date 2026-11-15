local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui            = game:GetService("CoreGui")
local Workspace          = game:GetService("Workspace")
local LP                 = Players.LocalPlayer

local env = (getgenv and getgenv()) or _G
local ctx = env.MXHUB_CTX or {}

local execName     = ctx.ExecName or "Unknown"
local isBlocked    = ctx.IsBlocked == true
local gameFile     = ctx.GameFile
local onSuccess    = ctx.OnSuccess or function() end
local scriptStatus = ctx.ScriptStatus
local idUrl        = ctx.IDUrl

local CONFIG = {
    Name     = "MX HUB",
    Subtitle = "KEY SYSTEM",
    Logo     = "rbxassetid://105865788976884",

    Discord  = "https://discord.gg/G7FCTC2mEk",
    Donate   = "https://sociabuzz.com/mxhub/tribe",

    GetKeyLink = "https://discord.gg/G7FCTC2mEk",
    SaveFile   = "MXHUB_Key.txt",
}

local idData = {}
pcall(function()
    local data = loadstring(game:HttpGet(idUrl))()
    if type(data) == "table" then
        idData = data
    end
end)

local function isWhitelisted()
    for _, id in ipairs(idData.Whitelist or {}) do
        if tonumber(id) == LP.UserId then
            return true
        end
    end
    return false
end

local function validateKey(key)
    local keys = idData.Keys
    if type(keys) ~= "table" or #keys == 0 then
        return false, "Failed to load keys"
    end
    for _, k in ipairs(keys) do
        if key == k then
            return true, "Key valid"
        end
    end
    return false, "Invalid key"
end

if not isBlocked and gameFile and isWhitelisted() then
    env.MXHUB_KEY = "whitelist"
    onSuccess("whitelist")
    return
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
    Panel    = Color3.fromRGB(21, 21, 23),
    PanelB   = Color3.fromRGB(12, 12, 14),
    Card     = Color3.fromRGB(28, 28, 31),
    Stroke   = Color3.fromRGB(46, 46, 52),
    StrokeH  = Color3.fromRGB(84, 84, 92),
    Button2  = Color3.fromRGB(35, 35, 39),
    Button2H = Color3.fromRGB(50, 50, 56),
    White    = Color3.fromRGB(245, 245, 245),
    Text     = Color3.fromRGB(240, 240, 242),
    Muted    = Color3.fromRGB(135, 135, 144),
    Green    = Color3.fromRGB(86, 204, 124),
    Red      = Color3.fromRGB(240, 88, 88),
    Orange   = Color3.fromRGB(240, 180, 72),
    Yellow   = Color3.fromRGB(250, 214, 70),
}

local W, H = 480, 252

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

local function tween(o, t, props, style, dir)
    local tw = TweenService:Create(
        o,
        TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
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
    copy    = "rbxassetid://93903059671561",
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

local function hover(btn, normal, over, strokeObj)
    local press = new("UIScale", { Scale = 1 }, btn)
    btn.MouseEnter:Connect(function()
        tween(btn, 0.2, { BackgroundColor3 = over })
        if strokeObj then tween(strokeObj, 0.2, { Color = T.StrokeH }) end
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.2, { BackgroundColor3 = normal })
        tween(press, 0.2, { Scale = 1 })
        if strokeObj then tween(strokeObj, 0.2, { Color = T.Stroke }) end
    end)
    btn.MouseButton1Down:Connect(function()
        tween(press, 0.08, { Scale = 0.97 })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(press, 0.16, { Scale = 1 })
    end)
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
    local conn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
    gui.Destroying:Connect(function() conn:Disconnect() end)
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
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
}, root)
corner(main, 12)
stroke(main, T.Stroke, 0)
new("UIGradient", {
    Color = ColorSequence.new(T.Panel, T.PanelB),
    Rotation = 90,
}, main)
local mainScale = new("UIScale", { Scale = 0.95 }, main)

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

local function titleText(text, order, color)
    return new("TextLabel", {
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        TextColor3 = color or T.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
    }, titleRow)
end
titleText(CONFIG.Name, 1)
new("Frame", {
    LayoutOrder = 2,
    Size = UDim2.fromOffset(1, 16),
    BackgroundColor3 = T.StrokeH,
    BorderSizePixel = 0,
}, titleRow)
titleText(CONFIG.Subtitle, 3, T.Muted)

new("Frame", {
    Position = UDim2.fromOffset(20, 58),
    Size = UDim2.fromOffset(224, 1),
    BackgroundColor3 = T.Stroke,
    BorderSizePixel = 0,
}, left)

label(left, "LICENSE KEY", UDim2.fromOffset(20, 76), UDim2.fromOffset(224, 14), T.Muted, 10, Enum.Font.GothamBold)

local boxFrame = new("Frame", {
    Position = UDim2.fromOffset(20, 96),
    Size = UDim2.fromOffset(224, 42),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
}, left)
corner(boxFrame, 8)
local boxStroke = stroke(boxFrame)
local keyIcon = imageIcon(boxFrame, IMAGES.key, UDim2.fromOffset(12, 13), T.Muted)

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

local boxToken = 0
local function setBoxColor(c)
    tween(boxStroke, 0.25, { Color = c })
    tween(keyIcon, 0.25, { ImageColor3 = c })
end

local function resetBox()
    box.PlaceholderText = "Paste your key here"
    box.PlaceholderColor3 = T.Muted
    tween(boxStroke, 0.25, { Color = T.Stroke })
    tween(keyIcon, 0.25, { ImageColor3 = T.Muted })
end

local function shake()
    task.spawn(function()
        for _, dx in ipairs({ 5, -5, 3, -3, 1, 0 }) do
            tween(boxFrame, 0.04, { Position = UDim2.fromOffset(20 + dx, 96) }, Enum.EasingStyle.Sine)
            task.wait(0.04)
        end
    end)
end

local function boxMessage(text, color, autoReset, doShake)
    boxToken += 1
    local my = boxToken
    box.Text = ""
    box.PlaceholderText = text
    box.PlaceholderColor3 = color
    setBoxColor(color)
    if doShake then shake() end
    if autoReset then
        task.delay(1.8, function()
            if boxToken == my and not box:IsFocused() then
                resetBox()
            end
        end)
    end
end

local function boxError(text)
    boxMessage(text, T.Orange, true, true)
end

box.Focused:Connect(function()
    boxToken += 1
    box.PlaceholderText = "Paste your key here"
    box.PlaceholderColor3 = T.Muted
    setBoxColor(T.White)
end)
box.FocusLost:Connect(function()
    tween(boxStroke, 0.25, { Color = T.Stroke })
    tween(keyIcon, 0.25, { ImageColor3 = T.Muted })
end)

local function makeButton(x, text, image)
    local b = new("TextButton", {
        Position = UDim2.fromOffset(x, 170),
        Size = UDim2.fromOffset(108, 40),
        BackgroundColor3 = T.Button2,
        Text = text,
        TextColor3 = T.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    }, left)
    corner(b, 8)
    local s = stroke(b)
    new("UIPadding", { PaddingLeft = UDim.new(0, 20) }, b)
    imageIcon(b, image, UDim2.fromOffset(-6, 12), T.Text)
    hover(b, T.Button2, T.Button2H, s)
    return b
end

local submit = makeButton(20, "Submit", IMAGES.submit)
local getKey = makeButton(136, "Get a key", IMAGES.getKey)

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

label(right, "DETECTED GAME", UDim2.fromOffset(16, 16), UDim2.fromOffset(150, 14), T.Muted, 10, Enum.Font.GothamBold)

local gameCard = new("Frame", {
    Position = UDim2.fromOffset(16, 34),
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

local function rgb(c)
    return string.format("rgb(%d,%d,%d)",
        math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function esc(x)
    return (tostring(x):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function infoRow(y, key, value, color)
    local l = label(right, "", UDim2.fromOffset(16, y), UDim2.fromOffset(183, 14), T.Muted, 11)
    l.RichText = true
    l.Text = string.format('%s <font color="%s"><b>%s</b></font>', key, rgb(color), esc(value))
    return l
end

local STATUS_MAP = {
    ["work"]        = { "Work",        T.Green  },
    ["down"]        = { "Down",        T.Red    },
    ["need update"] = { "Need Update", T.Yellow },
}
local function scriptStatusInfo(v)
    if type(v) == "string" then
        local k = v:lower():gsub("[_%-]", " "):gsub("%s+", " ")
        if STATUS_MAP[k] then return STATUS_MAP[k] end
    end
    return { "Unknown", T.Muted }
end
local st = scriptStatusInfo(scriptStatus)

infoRow(94,  "EXECUTOR :",      execName, T.Text)
infoRow(112, "STATUS :",        isBlocked and "Not supported" or "Supported", isBlocked and T.Red or T.Green)
infoRow(130, "SCRIPT STATUS :", st[1], st[2])

new("Frame", {
    Position = UDim2.fromOffset(16, 154),
    Size = UDim2.fromOffset(183, 1),
    BackgroundColor3 = T.Stroke,
    BorderSizePixel = 0,
}, right)

local function linkCard(y, title, link, icon)
    local card = new("Frame", {
        Position = UDim2.fromOffset(16, y),
        Size = UDim2.fromOffset(183, 38),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
    }, right)
    corner(card, 8)
    stroke(card)
    imageIcon(card, icon, UDim2.fromOffset(12, 11), T.Text)
    local name = label(card, title, UDim2.fromOffset(36, 12), UDim2.fromOffset(104, 14), T.Text, 12, Enum.Font.GothamBold)

    local btn = new("TextButton", {
        Position = UDim2.fromOffset(149, 6),
        Size = UDim2.fromOffset(26, 26),
        BackgroundColor3 = T.Button2,
        Text = "",
        AutoButtonColor = false,
    }, card)
    corner(btn, 6)
    local bs = stroke(btn)
    imageIcon(btn, IMAGES.copy, UDim2.fromOffset(5, 5), T.Text)
    hover(btn, T.Button2, T.Button2H, bs)

    local token = 0
    btn.Activated:Connect(function()
        token += 1
        local my = token
        if copy(link) then
            name.Text = "Copied!"
            tween(name, 0.2, { TextColor3 = T.Green })
        else
            name.Text = "Copy failed"
            tween(name, 0.2, { TextColor3 = T.Orange })
        end
        task.delay(1.6, function()
            if token == my then
                name.Text = title
                tween(name, 0.3, { TextColor3 = T.Text })
            end
        end)
    end)
end

linkCard(164, "Discord", CONFIG.Discord, IMAGES.discord)
linkCard(206, "Donate", CONFIG.Donate, IMAGES.donate)

if isBlocked then
    boxMessage(execName .. " not supported", T.Red, false, false)
end

local fetching = false
getKey.Activated:Connect(function()
    if fetching then return end
    fetching = true
    boxMessage("Getting key link...", T.Muted, false, false)
    task.spawn(function()
        task.wait(0.35)
        local link = fetchKeyLink()
        if not link then
            boxMessage("Failed to get key link", T.Red, true, true)
        elseif copy(link) then
            boxMessage("Key link copied", T.Green, true, false)
        else
            boxMessage(link, T.Orange, true, false)
        end
        fetching = false
    end)
end)

local busy = false
local function trySubmit()
    if busy then return end
    if isBlocked then
        boxMessage(execName .. " not supported", T.Red, true, true)
        return
    end

    local key = box.Text:gsub("%s+", "")
    if key == "" then
        boxError("Key required")
        return
    end

    busy = true
    boxMessage("Checking key...", T.Muted, false, false)
    task.wait(0.45)

    local called, valid, text = pcall(validateKey, key)
    if not (called and valid) then
        boxMessage(called and (text or "Invalid key") or "Validation error", T.Red, true, true)
        busy = false
        return
    end

    pcall(function()
        if writefile then writefile(CONFIG.SaveFile, key) end
    end)
    boxMessage(text or "Key valid", T.Green, false, false)

    if not gameFile then
        task.wait(0.6)
        boxMessage("Key valid, but game not in list", T.Orange, true, false)
        busy = false
        return
    end

    task.wait(0.7)
    tween(shadow, 0.3, { ImageTransparency = 1 })
    tween(mainScale, 0.3, { Scale = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.wait(0.32)
    gui:Destroy()

    env.MXHUB_KEY = key
    onSuccess(key)
end

submit.Activated:Connect(trySubmit)
box.FocusLost:Connect(function(enter)
    if enter then trySubmit() end
end)

tween(shadow, 0.5, { ImageTransparency = 0.6 })
tween(mainScale, 0.45, { Scale = 1 })
