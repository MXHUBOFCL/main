if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui            = game:GetService("CoreGui")
local Workspace          = game:GetService("Workspace")
local HttpService        = game:GetService("HttpService")
local LP                 = Players.LocalPlayer

local env = (getgenv and getgenv()) or _G

local MXHUB = {
    Appearance = {
        Title    = "MX HUB",
        Subtitle = "KEY SYSTEM",
        Icon     = "rbxassetid://105865788976884",
    },
    Links   = { Discord = "", Status = "" },
    Storage = { FileName = "MXHUB_Key" },
    Shop    = { Enabled = false, Title = "Donate", Link = "" },
}

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

local IMAGES = {
    key     = "rbxassetid://120178273227579",
    getKey  = "rbxassetid://114756714804603",
    submit  = "rbxassetid://95391166128209",
    discord = "rbxassetid://127606113874611",
    donate  = "rbxassetid://105962055212659",
    copy    = "rbxassetid://93903059671561",
}

local ERRORS = {
    KEY_INVALID      = "Key not found",
    KEY_EXPIRED      = "Key has expired",
    KEY_INVALIDATED  = "Key was revoked",
    REVOKED          = "Key was revoked",
    HWID_BANNED      = "Hardware banned",
    HWID_MISMATCH    = "HWID limit reached",
    ALREADY_USED     = "Key already redeemed",
    SERVICE_NOT_FOUND = "Service not found",
    SERVICE_MISMATCH = "Wrong service",
    PREMIUM_REQUIRED = "Premium required",
    NETWORK          = "Network error",
    ERROR            = "Network error",
}

local STATUS_MAP = {
    ["work"]        = { "Work",        T.Green  },
    ["down"]        = { "Down",        T.Red    },
    ["need update"] = { "Need Update", T.Yellow },
}

local function fetch(url)
    local fn, err = loadstring(game:HttpGet(url))
    if not fn then
        error(err, 0)
    end
    return fn
end

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

local function stroke(p, c)
    return new("UIStroke", {
        Color = c or T.Stroke,
        Thickness = 1,
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

local function label(parent, text, pos, size, color, ts, font)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Position = pos,
        Size = size,
        Text = text,
        TextColor3 = color,
        TextSize = ts,
        Font = font or Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

local function icon(parent, image, pos, color)
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

local function rgb(c)
    return string.format("rgb(%d,%d,%d)",
        math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function esc(x)
    return (tostring(x):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function hold()
    while true do
        task.wait(0.1)
    end
end

local function showUI(self, state)
    local ap = self.Appearance
    local W, H = 480, 252
    local done = false

    local gui = new("ScreenGui", {
        Name = "MXHubKey",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local ok = pcall(function() gui.Parent = gethui() end)
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

    local root = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H),
        BackgroundTransparency = 1,
    }, gui)

    local scale = new("UIScale", {}, root)
    local cam = Workspace.CurrentCamera
    if cam then
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
    stroke(main)
    new("UIGradient", { Color = ColorSequence.new(T.Panel, T.PanelB), Rotation = 90 }, main)
    local mainScale = new("UIScale", { Scale = 0.95 }, main)

    local left = new("Frame", { Size = UDim2.fromOffset(264, H), BackgroundTransparency = 1 }, main)

    new("ImageLabel", {
        Position = UDim2.fromOffset(20, 14),
        Size = UDim2.fromOffset(36, 32),
        BackgroundTransparency = 1,
        Image = ap.Icon or "",
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
    titleText(ap.Title or "MX HUB", 1)
    new("Frame", {
        LayoutOrder = 2,
        Size = UDim2.fromOffset(1, 16),
        BackgroundColor3 = T.StrokeH,
        BorderSizePixel = 0,
    }, titleRow)
    titleText(ap.Subtitle or "KEY SYSTEM", 3, T.Muted)

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
    local keyIcon = icon(boxFrame, IMAGES.key, UDim2.fromOffset(12, 13), T.Muted)

    local box = new("TextBox", {
        Position = UDim2.fromOffset(36, 0),
        Size = UDim2.new(1, -46, 1, 0),
        BackgroundTransparency = 1,
        Text = state.saved or "",
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
        boxToken = boxToken + 1
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

    box.Focused:Connect(function()
        boxToken = boxToken + 1
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
        icon(b, image, UDim2.fromOffset(-6, 12), T.Text)
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
    label(gameCard, tostring(game.PlaceId), UDim2.fromOffset(50, 27), UDim2.fromOffset(126, 12), T.Muted, 10)

    task.spawn(function()
        local okInfo, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        gameNameLbl.Text = (okInfo and info and info.Name) or "Unknown game"
    end)

    local function infoRow(y, key, value, color)
        local l = label(right, "", UDim2.fromOffset(16, y), UDim2.fromOffset(183, 14), T.Muted, 11)
        l.RichText = true
        l.Text = string.format('%s <font color="%s"><b>%s</b></font>', key, rgb(color), esc(value))
    end

    infoRow(94, "EXECUTOR :", state.execName, T.Text)
    if state.status ~= nil then
        local st = { "Unknown", T.Muted }
        if type(state.status) == "string" then
            local k = state.status:lower():gsub("[_%-]", " "):gsub("%s+", " ")
            st = STATUS_MAP[k] or st
        end
        infoRow(112, "SCRIPT STATUS :", st[1], st[2])
    end

    new("Frame", {
        Position = UDim2.fromOffset(16, 140),
        Size = UDim2.fromOffset(183, 1),
        BackgroundColor3 = T.Stroke,
        BorderSizePixel = 0,
    }, right)

    local function linkCard(y, title, link, image)
        local card = new("Frame", {
            Position = UDim2.fromOffset(16, y),
            Size = UDim2.fromOffset(183, 38),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
        }, right)
        corner(card, 8)
        stroke(card)
        icon(card, image, UDim2.fromOffset(12, 11), T.Text)
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
        icon(btn, IMAGES.copy, UDim2.fromOffset(5, 5), T.Text)
        hover(btn, T.Button2, T.Button2H, bs)

        local token = 0
        btn.Activated:Connect(function()
            token = token + 1
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

    local y = 152
    local discord = self.Links.Discord
    if type(discord) == "string" and discord ~= "" then
        linkCard(y, "Discord", discord, IMAGES.discord)
        y = y + 42
    end
    local shop = self.Shop
    if type(shop) == "table" and shop.Enabled and type(shop.Link) == "string" and shop.Link ~= "" then
        linkCard(y, shop.Title or "Donate", shop.Link, IMAGES.donate)
    end

    local fetching = false
    getKey.Activated:Connect(function()
        if fetching then return end
        fetching = true
        boxMessage("Getting key link...", T.Muted, false, false)
        task.spawn(function()
            task.wait(0.35)
            local called, link = pcall(state.junkie.get_key_link)
            if not called or type(link) ~= "string" or link == "" then
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
        local key = box.Text:gsub("%s+", "")
        if key == "" then
            boxMessage("Key required", T.Orange, true, true)
            return
        end

        busy = true
        boxMessage("Checking key...", T.Muted, false, false)

        local valid, text = state.check(key)
        if not valid then
            boxMessage(text, T.Red, true, true)
            busy = false
            return
        end

        state.accept(key)
        boxMessage(text, T.Green, false, false)
        task.wait(0.7)
        tween(shadow, 0.3, { ImageTransparency = 1 })
        tween(mainScale, 0.3, { Scale = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.wait(0.32)
        done = true
        gui:Destroy()
    end

    submit.Activated:Connect(trySubmit)
    box.FocusLost:Connect(function(enter)
        if enter then trySubmit() end
    end)

    tween(shadow, 0.5, { ImageTransparency = 0.6 })
    tween(mainScale, 0.45, { Scale = 1 })

    while not done and gui.Parent do
        task.wait(0.1)
    end
    return done
end

function MXHUB:LaunchJunkie(cfg)
    assert(type(cfg) == "table" and cfg.Service and cfg.Identifier and cfg.Provider,
        "LaunchJunkie needs Service, Identifier, Provider")

    local execName = "unknown"
    pcall(function()
        if identifyexecutor then
            execName = tostring((identifyexecutor()))
        end
    end)

    local status
    local statusUrl = self.Links and self.Links.Status
    if type(statusUrl) == "string" and statusUrl ~= "" then
        status = false
        pcall(function()
            local data = HttpService:JSONDecode(game:HttpGet(statusUrl))
            status = data[tostring(game.PlaceId)] or data[tostring(game.CreatorId)] or false
        end)
        if status == false then
            status = "unknown"
        end
    end

    env.SakuraUILoaded = true
    env.SakuraClosed   = false

    local okSdk, junkie = pcall(function()
        return fetch("https://jnkie.com/sdk/library.lua")()
    end)
    if not okSdk or type(junkie) ~= "table" then
        warn("[MXHUB] Failed to load Junkie SDK")
        return hold()
    end
    junkie.service    = cfg.Service
    junkie.identifier = cfg.Identifier
    junkie.provider   = cfg.Provider

    local fileName = tostring((self.Storage and self.Storage.FileName) or "MXHUB_Key") .. ".txt"

    local function check(key)
        local called, r = pcall(junkie.check_key, key)
        if not called then
            return false, "Network error"
        end
        if type(r) == "boolean" then
            return r, r and "Key valid" or "Invalid key"
        end
        if type(r) ~= "table" then
            return false, "Invalid verification response"
        end
        if r.valid == true then
            return true, "Key valid"
        end
        local code = tostring(r.error or "")
        if code == "HWID_BANNED" then
            task.delay(2, function()
                pcall(function() LP:Kick("Hardware banned") end)
            end)
        end
        return false, ERRORS[code] or r.message or (code ~= "" and code) or "Invalid key"
    end

    local function accept(key)
        env.SCRIPT_KEY = key
        env.SakuraUILoaded = false
        if key ~= "KEYLESS" then
            pcall(function()
                if writefile then writefile(fileName, key) end
            end)
        end
    end

    local preset = env.SCRIPT_KEY
    if type(preset) == "string" and preset ~= "" and preset ~= "KEYLESS" and check(preset) then
        accept(preset)
        return true
    end

    local calledK, rk = pcall(junkie.check_key, "KEYLESS")
    if calledK and type(rk) == "table" and rk.valid == true then
        env.SCRIPT_KEY = "KEYLESS"
        env.SakuraUILoaded = false
        return true
    end

    local saved
    pcall(function()
        if isfile and readfile and isfile(fileName) then
            saved = readfile(fileName):gsub("%s+", "")
        end
    end)
    if type(saved) == "string" and saved ~= "" and check(saved) then
        accept(saved)
        return true
    end

    local shown = showUI(self, {
        saved    = saved,
        execName = execName,
        status   = status,
        junkie   = junkie,
        check    = check,
        accept   = accept,
    })
    if not shown then
        env.SakuraClosed = true
        return hold()
    end
    return true
end

return MXHUB
