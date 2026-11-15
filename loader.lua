if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G

local CONFIG = {
    GUI_URL   = "https://raw.githubusercontent.com/MXHUBOFCL/main/main/key.lua",
    BASE      = "https://raw.githubusercontent.com/MXHUBOFCL/main/main/games/",
    Blocked   = { "xeno", "solara" },
    KickDelay = 0,
}

local games = {
    [97617452700163] = "1.lua",
    [0000000001] = "contoh2.lua",
}

local file = games[game.PlaceId] or games[game.GameId]

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

env.MXHUB_CTX = {
    ExecName  = execName,
    IsBlocked = isBlocked,
    GameFile  = file,
    OnSuccess = function(key)
        if not file then return end
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
