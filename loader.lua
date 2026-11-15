if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local lp  = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G

local REPO = "https://raw.githubusercontent.com/MXHUBOFCL/main/main/"

local CONFIG = {
    GUI_URL    = REPO .. "key.lua",
    BASE       = REPO .. "games/",
    KICK_URL   = REPO .. "kick.lua",
    STATUS_URL = REPO .. "status.json",
    ID_URL     = REPO .. "id.lua",
    SC_URL     = REPO .. "sc.lua",
    Blocked    = { "xeno", "solara" },
    KickDelay  = 0,
}

local games
pcall(function()
    local data = loadstring(game:HttpGet(CONFIG.SC_URL))()
    if type(data) == "table" then
        games = data
    end
end)

if not games then
    return
end

local function lookup(t)
    return t[game.PlaceId] or t[game.CreatorId]
end

local function kickPlayer()
    pcall(function()
        loadstring(game:HttpGet(CONFIG.KICK_URL))()
    end)
end

local file = lookup(games)

if not file then
    kickPlayer()
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

local scriptStatus
pcall(function()
    local data = HttpService:JSONDecode(game:HttpGet(CONFIG.STATUS_URL))
    scriptStatus = data[tostring(game.PlaceId)]
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
