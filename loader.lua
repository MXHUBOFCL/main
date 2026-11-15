if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local lp  = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G

local REPO = "https://raw.githubusercontent.com/MXHUBOFCL/main/main/"

local CONFIG = {
    GUI_URL    = REPO .. "ui/keygui.lua",
    BASE       = REPO .. "games/",

    -- URL 1: dijalankan untuk kick player kalau game tidak terdaftar
    KICK_URL   = REPO .. "kick.lua",

    -- URL 2: JSON status script per game (work / down / need update)
    STATUS_URL = REPO .. "status.json",

    -- URL 3: id.lua berisi daftar key + whitelist UserId Roblox
    ID_URL     = REPO .. "id.lua",

    Blocked    = { "xeno", "solara" },
    KickDelay  = 4,
}

-- Daftar game yang terdaftar. Key bisa PlaceId, GameId, atau CreatorId.
local games = {
    [97617452700163] = "contoh1.lua",
    [0000000001]     = "contoh2.lua",
}

local function lookup(t)
    return t[game.PlaceId] or t[game.GameId] or t[game.CreatorId]
end

local function kickPlayer(reason)
    env.MXHUB_KICK_REASON = reason
    local ok = pcall(function()
        loadstring(game:HttpGet(CONFIG.KICK_URL))()
    end)
    if not ok then
        pcall(function() lp:Kick(reason) end)
    end
end

local file = lookup(games)

-- Game tidak terdaftar -> jalankan URL kick
if not file then
    kickPlayer("MX HUB: this game is not supported")
    return
end

local execName = "unknown"
pcall(function()
    if identifyexecutor then
        execName = tostring((identifyexecutor()))
    end
end)

local isBlocked = false
do
    local lower = execName:lower()
    for _, bad in ipairs(CONFIG.Blocked) do
        if lower:find(bad, 1, true) then
            isBlocked = true
        end
    end
end

-- Ambil status script dari URL status
local scriptStatus
pcall(function()
    local data = HttpService:JSONDecode(game:HttpGet(CONFIG.STATUS_URL))
    scriptStatus = data[tostring(game.PlaceId)]
        or data[tostring(game.GameId)]
        or data[tostring(game.CreatorId)]
end)

env.MXHUB_CTX = {
    ExecName     = execName,
    IsBlocked    = isBlocked,
    GameFile     = file,
    ScriptStatus = scriptStatus,
    IDUrl        = CONFIG.ID_URL,
    OnSuccess    = function(key)
        task.wait(math.random())
        pcall(function()
            loadstring(game:HttpGet(CONFIG.BASE .. file))()
        end)
    end,
}

if isBlocked then
    task.delay(CONFIG.KickDelay, function()
        lp:Kick(execName .. " not supported, get better executor")
    end)
end

pcall(function()
    loadstring(game:HttpGet(CONFIG.GUI_URL))()
end)
