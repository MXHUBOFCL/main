local lp  = game:GetService("Players").LocalPlayer
local env = (getgenv and getgenv()) or _G

lp:Kick(env.MXHUB_KICK_REASON or "MX HUB: this game is not supported")
