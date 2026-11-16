if type(getgenv) ~= "function" then
    getgenv = function()
        return _G
    end
end
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local CONFIG = {
    Folder = "MeowX_Dump",
    MaxPerRemote = 5,
    DumpOnRun = true,
    SpyOnRun = true,
    SpyOwnCalls = false,
    DecompileScripts = true,
    DecompileTimeout = 8,
    RequireModules = true,
    RequireTimeout = 5,
    ScanGC = true,
    ScanGCRemotes = true,
    SkipServices = { CoreGui = true, CorePackages = true, RobloxPluginGuiService = true, NetworkClient = true },
    MaxDepthPretty = 9,
    MaxEntries = 600,
    YieldEvery = 250,
}

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local env = getgenv()

if type(env.MeowDump) == "table" and type(env.MeowDump.Cleanup) == "function" then
    pcall(env.MeowDump.Cleanup)
end

local HAS_WRITE = type(writefile) == "function"
local HAS_APPEND = type(appendfile) == "function"
local PLACE = tostring(game.PlaceId)
local OUT = CONFIG.Folder .. "/" .. PLACE
local nc = type(newcclosure) == "function" and newcclosure or function(f)
    return f
end

local connections = {}
local gui
local setStatus = function(text)
    print("[MeowDump] " .. tostring(text))
end

local function ensureFolder(path)
    if type(makefolder) == "function" then
        local exists = type(isfolder) == "function" and isfolder(path)
        if not exists then
            pcall(makefolder, path)
        end
    end
end
ensureFolder(CONFIG.Folder)
ensureFolder(OUT)
ensureFolder(OUT .. "/scripts")
ensureFolder(OUT .. "/remotes")

local function writeFresh(path, text)
    if HAS_WRITE then
        pcall(writefile, path, text)
    end
end

local function appendText(path, text)
    if not HAS_WRITE then
        return
    end
    if HAS_APPEND then
        pcall(appendfile, path, text)
    else
        local ok, old = pcall(readfile, path)
        pcall(writefile, path, (ok and old or "") .. text)
    end
end

local startedFiles = {}
local function put(path, text)
    if not startedFiles[path] then
        startedFiles[path] = true
        writeFresh(path, text)
    else
        appendText(path, text)
    end
end

local function newWriter(name)
    local path = OUT .. "/" .. name
    local buf, started = {}, false
    local w = { path = path, lines = 0 }
    function w:flush()
        if #buf == 0 then
            return
        end
        local chunk = table.concat(buf, "\n") .. "\n"
        buf = {}
        if not started then
            started = true
            writeFresh(path, chunk)
        else
            appendText(path, chunk)
        end
    end
    function w:line(s)
        buf[#buf + 1] = s
        self.lines = self.lines + 1
        if #buf >= 1500 then
            self:flush()
        end
    end
    function w:close()
        self:flush()
        return path
    end
    return w
end

local function sanitize(s)
    return (tostring(s):gsub("[^%w_%.%-]", "_")):sub(1, 90)
end

local function q(s)
    s = tostring(s)
    local extra = ""
    if #s > 400 then
        extra = "...(+" .. (#s - 400) .. ")"
        s = s:sub(1, 400)
    end
    local out = string.format("%q", s)
    out = out:gsub("\\\n", "\\n")
    out = out:gsub("\r", "\\r")
    return out .. extra
end

local function num(n)
    if n ~= n then
        return "0/0"
    elseif n == math.huge then
        return "math.huge"
    elseif n == -math.huge then
        return "-math.huge"
    elseif n == math.floor(n) and math.abs(n) < 1e15 then
        return string.format("%d", n)
    end
    return string.format("%.14g", n)
end

local function fullName(inst)
    local ok, n = pcall(function()
        return inst:GetFullName()
    end)
    return ok and n or tostring(inst)
end

local function luaPath(inst)
    local chain, cur = {}, inst
    while cur and cur ~= game do
        table.insert(chain, 1, cur)
        local ok, parent = pcall(function()
            return cur.Parent
        end)
        cur = ok and parent or nil
    end
    if not cur or #chain == 0 then
        local okn, name = pcall(function()
            return inst.Name .. ", " .. inst.ClassName
        end)
        return "nilinstance(" .. q(okn and name or "?") .. ")"
    end
    local first = chain[1]
    local s = first == workspace and "workspace" or ('game:GetService("' .. first.ClassName .. '")')
    local start = 2
    if first.ClassName == "Players" and chain[2] == LocalPlayer then
        s = s .. ".LocalPlayer"
        start = 3
    end
    for i = start, #chain do
        local n = chain[i].Name
        if n:match("^[%a_][%w_]*$") then
            s = s .. "." .. n
        else
            s = s .. "[" .. string.format("%q", n) .. "]"
        end
    end
    return s
end

local function funcName(f)
    local ok, n = pcall(function()
        return debug.info(f, "n")
    end)
    if ok and type(n) == "string" and n ~= "" then
        return n
    end
    return "?"
end

local function isArray(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n == #t, n
end

local function ser(v, depth, seen, lua)
    depth = depth or 0
    local t = typeof(v)
    if t == "string" then
        return q(v)
    elseif t == "number" then
        return num(v)
    elseif t == "boolean" or t == "nil" then
        return tostring(v)
    elseif t == "Instance" then
        if lua then
            return luaPath(v)
        end
        local ok, cls = pcall(function()
            return v.ClassName
        end)
        return "<" .. (ok and cls or "Instance") .. ":" .. fullName(v) .. ">"
    elseif t == "Vector3" then
        return string.format("Vector3.new(%s, %s, %s)", num(v.X), num(v.Y), num(v.Z))
    elseif t == "Vector2" then
        return string.format("Vector2.new(%s, %s)", num(v.X), num(v.Y))
    elseif t == "CFrame" then
        local c = { v:GetComponents() }
        for i = 1, #c do
            c[i] = num(c[i])
        end
        return "CFrame.new(" .. table.concat(c, ", ") .. ")"
    elseif t == "Color3" then
        return string.format("Color3.new(%s, %s, %s)", num(v.R), num(v.G), num(v.B))
    elseif t == "UDim2" then
        return string.format("UDim2.new(%s, %s, %s, %s)", num(v.X.Scale), num(v.X.Offset), num(v.Y.Scale), num(v.Y.Offset))
    elseif t == "UDim" then
        return string.format("UDim.new(%s, %s)", num(v.Scale), num(v.Offset))
    elseif t == "BrickColor" then
        return "BrickColor.new(" .. q(v.Name) .. ")"
    elseif t == "EnumItem" or t == "Enum" then
        return tostring(v)
    elseif t == "function" then
        return "function:" .. funcName(v)
    elseif t == "buffer" then
        local ok, len = pcall(buffer.len, v)
        return "buffer(" .. (ok and len or "?") .. ")"
    elseif t == "table" then
        seen = seen or {}
        if seen[v] then
            return "<cycle>"
        end
        if depth >= 6 then
            return "{...}"
        end
        seen[v] = true
        local arr = isArray(v)
        local parts, n = {}, 0
        if arr then
            for i = 1, #v do
                n = n + 1
                if n > 80 then
                    parts[#parts + 1] = "..."
                    break
                end
                parts[#parts + 1] = ser(v[i], depth + 1, seen, lua)
            end
        else
            for k, val in pairs(v) do
                n = n + 1
                if n > 80 then
                    parts[#parts + 1] = "..."
                    break
                end
                parts[#parts + 1] = "[" .. ser(k, depth + 1, seen, lua) .. "] = " .. ser(val, depth + 1, seen, lua)
            end
        end
        seen[v] = nil
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    return t .. ":" .. tostring(v)
end

local function dumpValue(w, label, v, depth, seen, indent)
    indent = indent or ""
    if typeof(v) ~= "table" then
        w:line(indent .. label .. " = " .. ser(v, 0))
        return
    end
    if seen[v] then
        w:line(indent .. label .. " = <cycle>")
        return
    end
    if depth >= CONFIG.MaxDepthPretty then
        w:line(indent .. label .. " = {... batas kedalaman}")
        return
    end
    seen[v] = true
    local keys = {}
    for k in pairs(v) do
        keys[#keys + 1] = k
    end
    table.sort(keys, function(a, b)
        local ta, tb = type(a), type(b)
        if ta ~= tb then
            return ta < tb
        end
        if ta == "number" or ta == "string" then
            return a < b
        end
        return tostring(a) < tostring(b)
    end)
    w:line(indent .. label .. " = { " .. #keys .. " entri")
    for i, k in ipairs(keys) do
        if i > CONFIG.MaxEntries then
            w:line(indent .. "  ... (" .. (#keys - CONFIG.MaxEntries) .. " entri lagi)")
            break
        end
        local kl = type(k) == "string" and ("[" .. q(k) .. "]") or ("[" .. ser(k, 0) .. "]")
        dumpValue(w, kl, v[k], depth + 1, seen, indent .. "  ")
    end
    w:line(indent .. "}")
    seen[v] = nil
end

local function callTimeout(timeout, fn, ...)
    local args = table.pack(...)
    local done, ok, res = false, false, nil
    task.spawn(function()
        ok, res = pcall(fn, table.unpack(args, 1, args.n))
        done = true
    end)
    local t0 = os.clock()
    while not done and os.clock() - t0 < timeout do
        task.wait(0.05)
    end
    return done, ok, res
end

local PROPS = {
    { "ValueBase", { "Value" } },
    { "TextLabel", { "Text" } },
    { "TextButton", { "Text" } },
    { "TextBox", { "Text" } },
    { "ImageLabel", { "Image" } },
    { "ImageButton", { "Image" } },
    { "GuiObject", { "Visible" } },
    { "LayerCollector", { "Enabled" } },
    { "BillboardGui", { "Enabled" } },
    { "BasePart", { "Position", "Size", "Anchored", "CanCollide", "CanTouch", "Transparency" } },
    { "ProximityPrompt", { "ActionText", "ObjectText", "HoldDuration", "MaxActivationDistance", "Enabled", "RequiresLineOfSight" } },
    { "ClickDetector", { "MaxActivationDistance" } },
    { "Humanoid", { "Health", "MaxHealth", "WalkSpeed", "JumpPower", "JumpHeight" } },
    { "Model", { "PrimaryPart" } },
    { "Sound", { "SoundId" } },
    { "BaseScript", { "Enabled" } },
    { "Tool", { "Enabled" } },
    { "Animation", { "AnimationId" } },
    { "Decal", { "Texture" } },
    { "Texture", { "Texture" } },
    { "SpecialMesh", { "MeshId" } },
    { "MeshPart", { "MeshId" } },
}

local function describe(inst)
    local parts = { inst.ClassName .. " " .. q(inst.Name) }
    for _, entry in ipairs(PROPS) do
        if inst:IsA(entry[1]) then
            for _, name in ipairs(entry[2]) do
                local ok, v = pcall(function()
                    return inst[name]
                end)
                if ok then
                    parts[#parts + 1] = name .. "=" .. ser(v, 0)
                end
            end
        end
    end
    local ok, attrs = pcall(function()
        return inst:GetAttributes()
    end)
    if ok and next(attrs) then
        parts[#parts + 1] = "attrs=" .. ser(attrs, 0)
    end
    local ok2, tags = pcall(function()
        return CollectionService:GetTags(inst)
    end)
    if ok2 and #tags > 0 then
        parts[#parts + 1] = "tags=" .. ser(tags, 0)
    end
    return table.concat(parts, "  ")
end

local function dumpTree(root, w)
    local count = 0
    local stack = { { root, 0 } }
    while #stack > 0 do
        local item = table.remove(stack)
        local inst, depth = item[1], item[2]
        local okd, line = pcall(describe, inst)
        w:line(string.rep("  ", depth) .. (okd and line or ("? " .. tostring(inst))))
        local ok, children = pcall(function()
            return inst:GetChildren()
        end)
        if ok then
            for i = #children, 1, -1 do
                stack[#stack + 1] = { children[i], depth + 1 }
            end
        end
        count = count + 1
        if count % CONFIG.YieldEvery == 0 then
            task.wait()
        end
    end
    return count
end

local report = {}
local errors = {}
local function addReport(name, w, extra)
    report[#report + 1] = string.format("%-34s %7d baris %s", name, w and w.lines or 0, extra or "")
end
local function try(name, fn, ...)
    setStatus("mulai: " .. name)
    local ok, err = pcall(fn, ...)
    if not ok then
        errors[#errors + 1] = name .. ": " .. tostring(err)
        warn("[MeowDump] gagal " .. name .. ": " .. tostring(err))
    end
    return ok
end

local REMOTE_CLASS = {
    RemoteEvent = true,
    RemoteFunction = true,
    UnreliableRemoteEvent = true,
    BindableEvent = true,
    BindableFunction = true,
}
local USE = {
    RemoteEvent = "FireServer",
    UnreliableRemoteEvent = "FireServer",
    RemoteFunction = "InvokeServer",
    BindableEvent = "Fire",
    BindableFunction = "Invoke",
}
local METHODS = {
    FireServer = false,
    fireServer = false,
    InvokeServer = true,
    invokeServer = true,
    Fire = false,
    fire = false,
    Invoke = true,
    invoke = true,
}

local function classOf(inst)
    local ok, cls = pcall(function()
        return inst.ClassName
    end)
    return ok and cls or nil
end

local function isRemote(inst)
    if typeof(inst) ~= "Instance" then
        return false
    end
    local cls = classOf(inst)
    return cls ~= nil and REMOTE_CLASS[cls] == true
end

local entries = {}
local entryList = {}
local usedNames = {}

local function uniqueName(remote)
    local base = sanitize(remote.Name)
    if base == "" then
        base = remote.ClassName
    end
    local name, i = base, 1
    while usedNames[name] do
        i = i + 1
        name = base .. "_" .. i
    end
    usedNames[name] = true
    return name
end

local function entryFor(remote)
    local e = entries[remote]
    if not e then
        local name = uniqueName(remote)
        e = {
            name = name,
            remote = remote,
            class = remote.ClassName,
            path = luaPath(remote),
            file = OUT .. "/remotes/" .. name .. ".txt",
            dirs = {},
        }
        entries[remote] = e
        entryList[#entryList + 1] = e
    end
    return e
end

local function collectRemotes()
    local list, seen = {}, {}
    local function add(i)
        if not seen[i] and isRemote(i) then
            seen[i] = true
            list[#list + 1] = i
            entryFor(i)
        end
    end
    for _, service in ipairs(game:GetChildren()) do
        if not CONFIG.SkipServices[service.ClassName] then
            local ok, desc = pcall(function()
                return service:GetDescendants()
            end)
            if ok then
                for i, d in ipairs(desc) do
                    add(d)
                    if i % 2000 == 0 then
                        task.wait()
                    end
                end
            end
        end
    end
    if type(getnilinstances) == "function" then
        local ok, nils = pcall(getnilinstances)
        if ok and type(nils) == "table" then
            for _, inst in ipairs(nils) do
                add(inst)
            end
        end
    end
    if type(getinstances) == "function" then
        local ok, all = pcall(getinstances)
        if ok and type(all) == "table" then
            for i, inst in ipairs(all) do
                add(inst)
                if i % 3000 == 0 then
                    task.wait()
                end
            end
        end
    end
    if CONFIG.ScanGCRemotes and type(getgc) == "function" then
        local ok, all = pcall(getgc, true)
        if ok and type(all) == "table" then
            for i, obj in ipairs(all) do
                if type(obj) == "userdata" then
                    add(obj)
                end
                if i % 5000 == 0 then
                    task.wait()
                end
            end
        end
    end
    return list
end

local function dumpEnv()
    local w = newWriter("01_game_info.txt")
    w:line("PlaceId=" .. game.PlaceId .. "  GameId=" .. game.GameId .. "  PlaceVersion=" .. tostring(game.PlaceVersion))
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info then
        w:line("Nama game: " .. tostring(info.Name))
    end
    local okx, exec = pcall(function()
        return identifyexecutor()
    end)
    w:line("Executor: " .. (okx and tostring(exec) or "tidak diketahui"))
    w:line("Workspace.Gravity=" .. tostring(workspace.Gravity) .. "  StreamingEnabled=" .. tostring(workspace.StreamingEnabled))
    w:line("Jumlah pemain=" .. #Players:GetPlayers())
    w:line("")
    w:line("== Atribut LocalPlayer ==")
    local okA, attrs = pcall(function()
        return LocalPlayer:GetAttributes()
    end)
    if okA then
        dumpValue(w, "attrs", attrs, 0, {})
    end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        w:line("== leaderstats ==")
        for _, c in ipairs(ls:GetChildren()) do
            local okv, v = pcall(function()
                return c.Value
            end)
            w:line("  " .. c.Name .. " (" .. c.ClassName .. ") = " .. (okv and ser(v) or "?"))
        end
    end
    w:line("")
    w:line("== Service di game ==")
    for _, s in ipairs(game:GetChildren()) do
        local okc, n = pcall(function()
            return #s:GetDescendants()
        end)
        w:line("  " .. s.ClassName .. "  (" .. (okc and n or "?") .. " descendant)")
    end
    w:line("")
    w:line("== CollectionService tags ==")
    for _, tag in ipairs(CollectionService:GetAllTags()) do
        w:line("  " .. tag .. " = " .. #CollectionService:GetTagged(tag))
    end
    w:line("")
    w:line("== Fungsi executor ==")
    local fns = {
        "writefile", "appendfile", "readfile", "makefolder", "isfolder", "listfiles", "setclipboard", "hookfunction",
        "hookmetamethod", "newcclosure", "checkcaller", "getnamecallmethod", "setnamecallmethod", "getcallingscript",
        "getgc", "getconnections", "firesignal", "fireclickdetector", "fireproximityprompt", "firetouchinterest",
        "decompile", "getscripts", "getloadedmodules", "getnilinstances", "getinstances", "getsenv", "getrenv",
        "getgenv", "getrawmetatable", "setreadonly", "request", "http_request", "queue_on_teleport", "getupvalues",
        "getconstants", "gethui", "saveinstance", "Drawing", "isexecutorclosure", "cloneref", "getfflag",
    }
    for _, n in ipairs(fns) do
        local v = getfenv()[n]
        if v == nil then
            v = env[n]
        end
        w:line(string.format("  %-22s %s", n, tostring(v ~= nil)))
    end
    addReport("01_game_info.txt", w)
    w:close()
end

local function dumpRemotes()
    local w = newWriter("02_remotes.txt")
    local list = collectRemotes()
    table.sort(list, function(a, b)
        return luaPath(a) < luaPath(b)
    end)
    for _, r in ipairs(list) do
        local e = entryFor(r)
        w:line(string.format("[%s] %-22s %s:%s()", e.name, e.class, e.path, USE[e.class] or "FireServer"))
    end
    w:line("")
    w:line("total: " .. #list)
    addReport("02_remotes.txt", w, "(" .. #list .. " remote)")
    w:close()
end

local function dumpState()
    local w = newWriter("03_state.txt")
    local char = LocalPlayer.Character
    if char then
        w:line("== Character ==")
        dumpTree(char, w)
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        w:line("== Backpack ==")
        dumpTree(bp, w)
    end
    local sg = LocalPlayer:FindFirstChild("StarterGear")
    if sg then
        w:line("== StarterGear ==")
        dumpTree(sg, w)
    end
    addReport("03_state.txt", w)
    w:close()
end

local function dumpGui()
    local w = newWriter("04_gui_texts.txt")
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local n = 0
    if pg then
        local desc = pg:GetDescendants()
        for i, d in ipairs(desc) do
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                local okT, text = pcall(function()
                    return d.Text
                end)
                local okV, vis = pcall(function()
                    return d.Visible
                end)
                n = n + 1
                w:line(string.format("[%s] %s  Text=%s", (okV and vis) and "tampil" or "sembunyi", fullName(d), okT and q(text) or "?"))
            end
            if i % 1500 == 0 then
                task.wait()
            end
        end
    end
    addReport("04_gui_texts.txt", w, "(" .. n .. " teks)")
    w:close()
end

local function dumpTrees()
    for _, service in ipairs(game:GetChildren()) do
        if not CONFIG.SkipServices[service.ClassName] then
            local fname = "05_tree_" .. service.ClassName:gsub("[^%w_]", "_") .. ".txt"
            local w = newWriter(fname)
            setStatus("tree " .. service.ClassName)
            local ok, err = pcall(dumpTree, service, w)
            if not ok then
                w:line("ERROR: " .. tostring(err))
            end
            addReport(fname, w)
            w:close()
            task.wait()
        end
    end
end

local function dumpModules()
    local w = newWriter("06_modules.txt")
    local n = 0
    local roots = { game:GetService("ReplicatedStorage"), game:GetService("ReplicatedFirst") }
    local okSp, sp = pcall(function()
        return game:GetService("StarterPlayer")
    end)
    if okSp then
        roots[#roots + 1] = sp
    end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        roots[#roots + 1] = pg
    end
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then
        roots[#roots + 1] = ps
    end
    for _, root in ipairs(roots) do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("ModuleScript") then
                n = n + 1
                w:line("")
                w:line("---- " .. luaPath(d))
                local done, okr, res = callTimeout(CONFIG.RequireTimeout, require, d)
                if done and okr then
                    dumpValue(w, "return", res, 0, {})
                else
                    w:line("gagal require: " .. (done and tostring(res) or "timeout"))
                end
                if n % 5 == 0 then
                    task.wait()
                end
            end
        end
    end
    addReport("06_modules.txt", w, "(" .. n .. " modul)")
    w:close()
end

local GC_KEYS = {
    wins = true, rebirths = true, level = true, xp = true, exp = true, money = true, cash = true, coins = true,
    gems = true, inventory = true, stats = true, data = true, trophies = true, ownedpasses = true, points = true,
}
local function scanGC()
    local w = newWriter("07_gc_state.txt")
    if type(getgc) ~= "function" then
        w:line("getgc tidak tersedia di executor ini")
        w:close()
        return
    end
    local ok, all = pcall(getgc, true)
    if not ok then
        w:line("getgc gagal: " .. tostring(all))
        w:close()
        return
    end
    local found = 0
    for i, obj in ipairs(all) do
        if type(obj) == "table" then
            local score = 0
            local okp = pcall(function()
                for k in pairs(obj) do
                    if type(k) == "string" and GC_KEYS[k:lower()] then
                        score = score + 1
                    end
                    if score >= 3 then
                        break
                    end
                end
            end)
            if okp and score >= 3 then
                found = found + 1
                w:line("")
                w:line("---- tabel #" .. found .. " (cocok " .. score .. " key)")
                dumpValue(w, "table", obj, 0, {})
                if found >= 25 then
                    break
                end
            end
        end
        if i % 5000 == 0 then
            task.wait()
        end
    end
    w:line("")
    w:line("total objek GC dipindai: " .. #all .. ", tabel cocok: " .. found)
    addReport("07_gc_state.txt", w, "(" .. found .. " tabel)")
    w:close()
end

local function dumpScripts()
    if type(decompile) ~= "function" then
        local w = newWriter("08_scripts_index.txt")
        w:line("decompile tidak tersedia di executor ini")
        w:close()
        return
    end
    local list, seen = {}, {}
    local function add(s)
        if typeof(s) == "Instance" and not seen[s] and s:IsA("LuaSourceContainer") then
            local okc, inCore = pcall(function()
                return s:IsDescendantOf(game:GetService("CoreGui")) or s:IsDescendantOf(game:GetService("CorePackages"))
            end)
            if not (okc and inCore) then
                seen[s] = true
                list[#list + 1] = s
            end
        end
    end
    if type(getscripts) == "function" then
        pcall(function()
            for _, s in ipairs(getscripts()) do
                add(s)
            end
        end)
    end
    if type(getloadedmodules) == "function" then
        pcall(function()
            for _, s in ipairs(getloadedmodules()) do
                add(s)
            end
        end)
    end
    for _, service in ipairs(game:GetChildren()) do
        if not CONFIG.SkipServices[service.ClassName] then
            local ok, desc = pcall(function()
                return service:GetDescendants()
            end)
            if ok then
                for _, d in ipairs(desc) do
                    add(d)
                end
            end
        end
    end
    local index = newWriter("08_scripts_index.txt")
    local refs = newWriter("08_remote_refs.txt")
    local okCount, failCount = 0, 0
    for i, s in ipairs(list) do
        setStatus(string.format("decompile %d/%d", i, #list))
        local name = fullName(s)
        local done, ok, src = callTimeout(CONFIG.DecompileTimeout, decompile, s)
        local file = string.format("scripts/%04d_%s.lua", i, sanitize(name))
        if done and ok and type(src) == "string" then
            okCount = okCount + 1
            writeFresh(OUT .. "/" .. file, src)
            index:line(string.format("%04d  %-12s %6d byte  %s", i, s.ClassName, #src, name))
            local hits = 0
            for line in src:gmatch("[^\r\n]+") do
                if line:find("FireServer", 1, true) or line:find("InvokeServer", 1, true) then
                    hits = hits + 1
                    if hits <= 60 then
                        refs:line("[" .. name .. "] " .. line:gsub("^%s+", ""))
                    end
                end
            end
        else
            failCount = failCount + 1
            index:line(string.format("%04d  %-12s GAGAL (%s)  %s", i, s.ClassName, done and tostring(src) or "timeout", name))
        end
        if i % 5 == 0 then
            task.wait()
        end
    end
    addReport("08_scripts_index.txt", index, string.format("(%d ok, %d gagal) + folder scripts/", okCount, failCount))
    addReport("08_remote_refs.txt", refs)
    index:close()
    refs:close()
end

local spyOn = false
local spyCounts = 0
local hooked = {}
local oldNamecall
local namecallHooked = false
local guard = setmetatable({}, { __mode = "k" })
local t0 = os.clock()
local SPY_LOG = OUT .. "/09_spy_log.txt"

local function isOwn()
    return type(checkcaller) == "function" and checkcaller()
end

local function callerName()
    if type(getcallingscript) ~= "function" then
        return nil
    end
    local ok, s = pcall(getcallingscript)
    if ok and typeof(s) == "Instance" then
        return luaPath(s)
    end
    return nil
end

local function record(dir, remote, method, args, rets, caller)
    local ok, err = pcall(function()
        local e = entryFor(remote)
        local d = e.dirs[dir]
        if not d then
            d = { n = 0, logged = 0, dup = 0, sigs = {} }
            e.dirs[dir] = d
        end
        d.n = d.n + 1
        if d.logged >= CONFIG.MaxPerRemote then
            return
        end
        local parts = {}
        for i = 1, args.n do
            parts[i] = ser(args[i], 0, nil, true)
        end
        local joined = table.concat(parts, ", ")
        local sig = method .. "|" .. joined
        if d.sigs[sig] then
            d.dup = d.dup + 1
            return
        end
        d.sigs[sig] = true
        d.logged = d.logged + 1
        spyCounts = spyCounts + 1
        local lines = { string.format("[%s] %s #%d t=%.2f class=%s", e.name, dir, d.logged, os.clock() - t0, e.class) }
        if dir == "C>S" then
            lines[#lines + 1] = "    " .. e.path .. ":" .. method .. "(" .. joined .. ")"
            if rets then
                local rp = {}
                for i = 1, rets.n do
                    rp[i] = ser(rets[i], 0, nil, true)
                end
                lines[#lines + 1] = "    return: " .. table.concat(rp, ", ")
            end
            if caller then
                lines[#lines + 1] = "    caller: " .. caller
            end
        else
            lines[#lines + 1] = "    OnClientEvent(" .. joined .. ")"
        end
        local text = table.concat(lines, "\n") .. "\n"
        put(e.file, text)
        put(SPY_LOG, text)
    end)
    if not ok then
        warn("[MeowDump] spy error: " .. tostring(err))
    end
end

local function hookEvent(r)
    if hooked[r] then
        return
    end
    local cls = classOf(r)
    if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" then
        hooked[r] = true
        entryFor(r)
        local ok, conn = pcall(function()
            return r.OnClientEvent:Connect(function(...)
                if spyOn then
                    record("S>C", r, "OnClientEvent", table.pack(...))
                end
            end)
        end)
        if ok and conn then
            connections[#connections + 1] = conn
        end
    end
end

local function installNamecall()
    if namecallHooked then
        return true
    end
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
        return false
    end
    local ok = pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", nc(function(self, ...)
            local method = getnamecallmethod()
            if spyOn and METHODS[method] ~= nil and isRemote(self) and (CONFIG.SpyOwnCalls or not isOwn()) then
                local caller = callerName()
                local args = table.pack(...)
                local thread = coroutine.running()
                guard[thread] = true
                if type(setnamecallmethod) == "function" then
                    setnamecallmethod(method)
                end
                local rets = table.pack(oldNamecall(self, ...))
                guard[thread] = nil
                task.spawn(record, "C>S", self, method, args, METHODS[method] and rets or nil, caller)
                return table.unpack(rets, 1, rets.n)
            end
            return oldNamecall(self, ...)
        end))
    end)
    namecallHooked = ok
    return ok
end

local function hookDirect(className, method)
    if type(hookfunction) ~= "function" then
        return false
    end
    local ok, inst = pcall(Instance.new, className)
    if not ok or not inst then
        return false
    end
    local okf, fn = pcall(function()
        return inst[method]
    end)
    pcall(function()
        inst:Destroy()
    end)
    if not okf or type(fn) ~= "function" then
        return false
    end
    local invoke = METHODS[method]
    local old
    local okh = pcall(function()
        old = hookfunction(fn, nc(function(self, ...)
            if spyOn and not guard[coroutine.running()] and isRemote(self) and (CONFIG.SpyOwnCalls or not isOwn()) then
                local caller = callerName()
                local args = table.pack(...)
                local rets = table.pack(old(self, ...))
                task.spawn(record, "C>S", self, method, args, invoke and rets or nil, caller)
                return table.unpack(rets, 1, rets.n)
            end
            return old(self, ...)
        end))
    end)
    return okh
end

local directInstalled = false
local function installDirect()
    if directInstalled then
        return
    end
    directInstalled = true
    hookDirect("RemoteEvent", "FireServer")
    hookDirect("UnreliableRemoteEvent", "FireServer")
    hookDirect("RemoteFunction", "InvokeServer")
end

local function spyStart()
    if spyOn then
        return
    end
    local okN = installNamecall()
    installDirect()
    spyOn = true
    setStatus(okN and "Spy ON (C>S + S>C)" or "Spy ON (hookmetamethod tidak ada)")
    task.spawn(function()
        local list = collectRemotes()
        for _, r in ipairs(list) do
            hookEvent(r)
        end
        connections[#connections + 1] = game.DescendantAdded:Connect(function(d)
            if REMOTE_CLASS[d.ClassName] then
                entryFor(d)
                hookEvent(d)
            end
        end)
        setStatus("Spy siap, " .. #list .. " remote terpantau")
    end)
end

local function spySave()
    local w = newWriter("09_spy_summary.txt")
    local rows = {}
    for _, e in ipairs(entryList) do
        rows[#rows + 1] = e
    end
    table.sort(rows, function(a, b)
        return a.name < b.name
    end)
    local unseen = 0
    for _, e in ipairs(rows) do
        if not next(e.dirs) then
            unseen = unseen + 1
        end
    end
    w:line("remote terdaftar=" .. #rows .. "  belum ada panggilan=" .. unseen .. "  entri tercatat=" .. spyCounts)
    w:line("")
    for _, e in ipairs(rows) do
        w:line(string.format("[%s] %s %s", e.name, e.class, e.path))
        if not next(e.dirs) then
            w:line("    belum ada panggilan")
        end
        for dir, d in pairs(e.dirs) do
            w:line(string.format("    %s total=%d tercatat=%d duplikat=%d", dir, d.n, d.logged, d.dup))
        end
    end
    w:close()
    setStatus("ringkasan spy disimpan: " .. OUT .. "/09_spy_summary.txt")
end

local function spyStop()
    spyOn = false
    spySave()
    setStatus("Spy OFF")
end

local busy = false
local function dumpAll()
    if busy then
        setStatus("masih berjalan...")
        return
    end
    busy = true
    report, errors = {}, {}
    local started = os.clock()
    try("info game", dumpEnv)
    try("remotes", dumpRemotes)
    try("state", dumpState)
    try("gui", dumpGui)
    try("tree service", dumpTrees)
    if CONFIG.RequireModules then
        try("modul", dumpModules)
    end
    if CONFIG.ScanGC then
        try("scan gc", scanGC)
    end
    if CONFIG.DecompileScripts then
        try("decompile", dumpScripts)
    end
    spySave()
    local w = newWriter("00_INDEX.txt")
    w:line("MeowX Dump - PlaceId " .. PLACE .. " - selesai dalam " .. string.format("%.1f", os.clock() - started) .. " detik")
    w:line("Folder: " .. OUT)
    w:line("")
    for _, line in ipairs(report) do
        w:line(line)
    end
    if #errors > 0 then
        w:line("")
        w:line("== ERROR ==")
        for _, e in ipairs(errors) do
            w:line(e)
        end
    end
    w:close()
    if type(setclipboard) == "function" then
        pcall(setclipboard, OUT)
    end
    busy = false
    setStatus("SELESAI. File di folder executor: " .. OUT .. (HAS_WRITE and "" or "  (writefile tidak ada)"))
end

local function buildGui()
    local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
    gui = Instance.new("ScreenGui")
    gui.Name = "MeowDumpUI"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(290, 380)
    frame.Position = UDim2.fromOffset(16, 70)
    frame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.fromOffset(10, 4)
    title.BackgroundTransparency = 1
    title.Text = "MeowX Dump & Debug v2"
    title.TextColor3 = Color3.fromRGB(235, 235, 240)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 48)
    status.Position = UDim2.fromOffset(10, 32)
    status.BackgroundTransparency = 1
    status.Text = "siap"
    status.TextColor3 = Color3.fromRGB(190, 140, 255)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextWrapped = true
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextYAlignment = Enum.TextYAlignment.Top
    status.Parent = frame

    setStatus = function(text)
        print("[MeowDump] " .. tostring(text))
        if status and status.Parent then
            status.Text = tostring(text)
        end
    end

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -20, 1, -92)
    list.Position = UDim2.fromOffset(10, 84)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.new()
    list.Parent = frame
    Instance.new("UIListLayout", list).Padding = UDim.new(0, 6)

    local function button(text, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -6, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = Color3.fromRGB(235, 235, 240)
        b.Font = Enum.Font.Gotham
        b.TextSize = 13
        b.Parent = list
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function()
            task.spawn(fn, b)
        end)
        return b
    end

    local function once(name, fn)
        return function()
            if busy then
                setStatus("tunggu proses sebelumnya selesai")
                return
            end
            busy = true
            report, errors = {}, {}
            try(name, fn)
            busy = false
            setStatus("selesai: " .. name .. " -> " .. OUT)
        end
    end

    button("DUMP SEMUA", dumpAll)
    button("Info game + fungsi executor", once("info game", dumpEnv))
    button("Daftar Remote", once("remotes", dumpRemotes))
    button("State pemain", once("state", dumpState))
    button("Teks HUD / GUI", once("gui", dumpGui))
    button("Tree semua service", once("tree", dumpTrees))
    button("Isi semua ModuleScript", once("modul", dumpModules))
    button("Scan GC (data pemain)", once("gc", scanGC))
    button("Decompile semua script", once("decompile", dumpScripts))
    local spyBtn
    spyBtn = button(CONFIG.SpyOnRun and "Spy: ON" or "Spy: OFF", function()
        if spyOn then
            spyStop()
            spyBtn.Text = "Spy: OFF"
        else
            spyStart()
            spyBtn.Text = "Spy: ON"
        end
    end)
    button("Simpan ringkasan spy", spySave)
    button("Tutup", function()
        if env.MeowDump then
            env.MeowDump.Cleanup()
        end
    end)

    local min = Instance.new("TextButton")
    min.Size = UDim2.fromOffset(26, 26)
    min.Position = UDim2.new(1, -32, 0, 5)
    min.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
    min.BorderSizePixel = 0
    min.Text = "-"
    min.TextColor3 = Color3.fromRGB(235, 235, 240)
    min.Font = Enum.Font.GothamBold
    min.TextSize = 16
    min.Parent = frame
    Instance.new("UICorner", min).CornerRadius = UDim.new(0, 6)
    local small = false
    min.MouseButton1Click:Connect(function()
        small = not small
        list.Visible = not small
        status.Visible = not small
        frame.Size = small and UDim2.fromOffset(290, 36) or UDim2.fromOffset(290, 380)
        min.Text = small and "+" or "-"
    end)
end

env.MeowDump = { Alive = true }
env.MeowDump.Cleanup = function()
    env.MeowDump.Alive = false
    spyOn = false
    for _, c in ipairs(connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    if gui then
        pcall(function()
            gui:Destroy()
        end)
    end
    env.MeowDump = nil
end
env.MeowDump.DumpAll = dumpAll
env.MeowDump.SpyStart = spyStart
env.MeowDump.SpyStop = spyStop
env.MeowDump.SpySave = spySave

pcall(buildGui)
if not HAS_WRITE then
    warn("[MeowDump] writefile tidak tersedia: hasil tidak bisa disimpan ke file.")
end
if CONFIG.SpyOnRun then
    task.spawn(spyStart)
end
if CONFIG.DumpOnRun then
    task.spawn(dumpAll)
end
