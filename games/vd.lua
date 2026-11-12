local function geniter(f, s, c)
	if type(f) ~= "function" then
		local mt = getmetatable(f)

		if type(mt) == "table" and mt.__iter then
			f, s, c = mt.__iter(f)
		elseif type(f) == "table" then
			f, s, c = next, f, nil
		end
	end

	return function()
		local r = table.pack(f(s, c))

		if r[1] == nil then
			return false
		end

		c = r[1]

		return true, table.unpack(r, 1, r.n)
	end
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local t1 = {
	Players = game:GetService("Players"),
	Debris = game:GetService("Debris"),
	UserInputService = game:GetService("UserInputService"),
	Lighting = game:GetService("Lighting"),
	RunService = game:GetService("RunService"),
	CoreGui = game:GetService("CoreGui"),
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	VirtualInputManager = game:GetService("VirtualInputManager"),
	VirtualUser = game:GetService("VirtualUser"),
	HttpService = game:GetService("HttpService"),
	Stats = game:GetService("Stats"),
	Workspace = game:GetService("Workspace"),
	TeleportService = game:GetService("TeleportService"),
	GuiService = game:GetService("GuiService"),
	RbxAnalytics = game:GetService("RbxAnalyticsService"),
	LocalPlayer = game:GetService("Players").LocalPlayer,
	Terrain = game:GetService("Workspace").Terrain,
	Camera = workspace.CurrentCamera
}
local Atmosphere = t1.Lighting:FindFirstChildOfClass("Atmosphere")
local Remotes = t1.ReplicatedStorage:FindFirstChild("Remotes")
local Attacks = Remotes and Remotes:FindFirstChild("Attacks")
local Remotes2 = t1.ReplicatedStorage:WaitForChild("Remotes", 10)
local Generator = Remotes2 and Remotes2:FindFirstChild("Generator")
local RepairEvent = Generator and Generator:FindFirstChild("RepairEvent")
local SkillCheckResultEvent = Generator and Generator:FindFirstChild("SkillCheckResultEvent")
local PalletDropEvent = Remotes2 and Remotes2:FindFirstChild("Pallet") and Remotes2.Pallet:FindFirstChild("PalletDropEvent")
local parry = Remotes2 and Remotes2:FindFirstChild("Items") and Remotes2.Items:FindFirstChild("Parrying Dagger") and Remotes2.Items["Parrying Dagger"]:FindFirstChild("parry")
local u14 = false
local expired = "Unknown"
local userThumbnailAsync = t1.Players:GetUserThumbnailAsync(t1.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
local t2 = {
	icon = "121088593459735",
	name = "VD_T",
	version = "Finall",
	dc = "https://discord.gg/AHEBP9gWgw",
	tt = "https://www.tiktok.com/@tiooxy?_r=1&_t=ZS-94pT94Ao2iL"
}
local t3 = {
	PistolV2_Enabled = false,
	PistolV2_ShowLaser = false,
	PistolV2_PredictStrength = 1.5,
	PistolV2_VelSmoothing = 0.35,
	TP_Offset = 5,
	Pistol_CustomSound = false,
	Pistol_SelectedSound = "Sound 1",
	ESP_Master = false,
	ESP_Player = false,
	ESP_Killer = false,
	ESP_SCP = false,
	ESP_Name = false,
	ESP_NameG = false,
	ESP_Outline = false,
	ESP_ItemIcon = false,
	ESP_MaxDistance = 200,
	ESP_Generator = false,
	ESP_Pallet = false,
	ESP_Trap = false,
	ESP_Hook = false,
	ESP_Gate = false,
	ESP_Window = false,
	ESP_KillerWarn = false,
	ESP_Hitbox = false,
	ESP_FaceLine = false,
	ESP_Pumpkin = false,
	Killer_SpamHit = false,
	Killer_SpamHitRadius = 15,
	Killer_SpamHitDelay = 100,
	Killer_HitEspCircle = true,
	Killer_BreakSpeed = 1,
	Killer_BreakS = false,
	Killer_BypassCarry = false,
	Killer_WalkSpeedToggle = false,
	Killer_WalkSpeed = 16,
	Killer_AttackMode = "BasicAttack",
	Killer_3rdPerson = false,
	Killer_CameraMode = "Classic",
	Killer_InfLunge = false,
	Anti_Blind = false,
	Show_Stun = false,
	Surv_Parry = false,
	Surv_ParryV2 = false,
	Surv_ParryCircle = true,
	Surv_ParryAggressive = false,
	Surv_ParrySafety = false,
	Surv_ParryRadius = 15,
	Surv_ParryFace = 0.7,
	Ignored_Skills_List = {},
	Surv_GodMode = false,
	Surv_SelfHeal = false,
	Surv_AutoSprint = false,
	Surv_AutoDisarmTrap = false,
	Surv_AutoSkillCheck = false,
	Surv_SkillCheckMode = "Legit",
	Surv_SkillSpeed = 1,
	Surv_PerfectSkill = true,
	Surv_NoSkill = false,
	Surv_Perks = false,
	Surv_SpeedBoost = 1.1,
	Surv_VaultSpeed = 1.3,
	Surv_SpeedAfterVault = false,
	Surv_FastVault = false,
	Surv_PerfectVault = false,
	Surv_AutoCrouch = false,
	Surv_NoFall = false,
	Surv_FleeDistance = 30,
	Surv_AutoPallet = false,
	Surv_AutoPalletRadius = 10,
	Surv_AutoPalletSM = true,
	Surv_AutoPalletSF = false,
	Surv_CrouchV = false,
	Surv_Spdb = false,
	Surv_QuickRecoveryCD = 15,
	Surv_FlowstateCD = 20,
	Surv_Fov = false,
	Surv_FOV_Value = 80,
	Surv_FastAccel = false,
	Aimbot_Enabled = false,
	Aimbot_ShowFOV = true,
	Aimbot_Radius = 150,
	Aimbot_MaxDist = 300,
	Aimbot_Smoothness = 0.5,
	Aimbot_Predict = 0.01,
	Aim_Silent = false,
	Aim_Lock = false,
	Predict = false,
	SmartPredict = false,
	AIM_TargetPart = "Torso",
	AutoCrush_Pumpkin = false,
	Butcher_Aim = false,
	leadButcher = 1.2,
	Pistol_Target = "Killer",
	Pistol_PredictLead = 0.5,
	Pistol_AimOffset = -1,
	Pistol_FOVMode = false,
	Pistol_ShowFOV = false,
	Pistol_FOV = 80,
	Pistol_ShowLaser = true,
	Flash_Silent = false,
	Flash_YOffset = 2,
	Aim_SilentVeil = false,
	Veil_ShowFOV = true,
	Veil_LeadMultiplier = 1.7,
	Veil_FOV = 80,
	Veil_ShowLaser = true,
	SPEAR_Auto = false,
	SPEAR_Speed = 165,
	SPEAR_Gravity = workspace.Gravity * 0.5,
	SPEAR_MaxDist = 200,
	Crosshair_Enabled = false,
	Crosshair_Type = "Cross",
	Crosshair_Color = Color3.new(0, 1, 0),
	Crosshair_Size = 4,
	Crosshair_OffsetX = 0,
	Crosshair_OffsetY = 0,
	Misc_Invisible = false,
	Misc_InvisOffset = -4,
	Misc_InvisibleC = false,
	Misc_FakeName = false,
	Misc_FakeAttributes = false,
	Misc_CopyAvatar = false,
	Misc_Noclip = false,
	Misc_FlyToggle = false,
	Misc_FlySpeed = 10,
	Misc_HighJump = false,
	Misc_JumpPower = 50,
	Misc_InfJump = false,
	Misc_InfiniteZoom = false,
	Misc_Fullbright = false,
	Misc_Potato = false,
	Misc_SkipCutscene = false,
	Misc_SmoothCam = false,
	Misc_CamHeight = -1,
	Misc_CamStiffness = 9.5,
	Misc_SmoothHDR = false,
	Next_Map = true
}
local t4 = {
	Level = t1.LocalPlayer:GetAttribute("Level") or 0,
	Gears = t1.LocalPlayer:GetAttribute("Gears") or 0,
	Screws = t1.LocalPlayer:GetAttribute("Screws") or 0
}
local t5 = {
	Unloaded = false,
	OriginalSpeed = 16,
	isPredicting = false,
	CutsceneConn = nil,
	CharCutscene = nil,
	FleeThread = nil,
	RandomMode_IsNormal = false,
	AutoSprintThread = nil,
	OriginalLighting = nil,
	CurrentPing = 0,
	QuickRecoveryOnCD = false,
	FlowstateOnCD = false,
	HookF = false,
	isAimLocking = false,
	currentTarget = nil,
	lockTimerThread = nil,
	lastNoclipChar = nil,
	activeMask = nil,
	Veil_CachedDir = nil,
	Veil_CachedSpeed = nil,
	Veil_CachedStartPos = nil,
	Veil_HasCache = false,
	lastUpdate = 0,
	lastSpam = 0,
	SpearModeConn = nil,
	StunConn = nil,
	SpamHit = nil,
	autoParry = nil,
	CrosshairUI = nil,
	WatermarkUI = nil,
	ItemESPs = {},
	FlyConnection = nil,
	FollowConnection = nil,
	InfiniteZoomConn = nil,
	ThirdPersonCamConn = nil,
	blockThread = nil,
	AutoPalletThread = nil,
	VaultBoostThread = nil,
	Pv2Con = nil,
	lungeV2Connection = nil,
	RepairEngineRunning = false,
	VaultBoostActive = false,
	AutoFollow = false,
	isHoldingLunge = false,
	isHolding = false,
	cachedNoclipParts = {},
	ActiveAnimations = {},
	SpooferConns = {},
	TeamConnections = {},
	DroppedPallets = {},
	TrackV2 = {},
	touchLunge = nil,
	currentTouch = nil,
	locked = nil,
	Butcher_CachedDir = nil,
	Butcher_HasCache = false,
	Butcher_TargetPart = nil,
	PistolV2_LaserBeam = nil,
	PistolV2_VelocityCache = {},
	PistolV2_CachedShouldRedirect = false,
	PistolV2_CachedRedirectDir = nil,
	PistolV2_CachedOriginPos = nil,
	PistolV2_CachedTargetPos = nil,
	PistolV2_IsAiming = false,
	PistolV2_CacheConn = nil,
	PistolV2_TouchInput = nil
}
local t6 = {
	Colors = {
		SCP = Color3.fromRGB(150, 0, 255),
		Player = Color3.fromRGB(0, 255, 255),
		Killer = Color3.fromRGB(255, 0, 0),
		Generator = Color3.fromRGB(255, 255, 0),
		Trap = Color3.fromRGB(255, 0, 100),
		GeneratorDone = Color3.fromRGB(0, 255, 0),
		Pallet = Color3.fromRGB(255, 128, 0),
		Hook = Color3.fromRGB(255, 105, 180),
		Gate = Color3.fromRGB(255, 255, 255),
		Window = Color3.fromRGB(0, 150, 255)
	}
}
local t7 = {
	isChargingSpear = false,
	isChargingPistol = false,
	isAimingFlash = false,
	currentTouchInput = nil,
	isAimbotHolding = false,
	isChargingButcher = false,
	lockedAimbotTarget = nil
}
local t8 = {
	Visibility = {},
	Generators = {},
	Pallets = {},
	Hooks = {},
	Gates = {},
	Windows = {},
	SCPs = {},
	Traps = {},
	Pumpkins = {}
}
local s1 = "Spectator"
local u25
local HumanoidRootPart
local Humanoid
local t9 = {
	WEB = "https://panel.vdtixo.store",
	SCRIPT = "https://script.vdtixo.store",
	keyFile = "VD_KeySave.txt",
	cache = "VD_T/Log/KeyCache.json"
}

t9.Url = t9.WEB .. "/api/verify"

local lib = loadstring(game:HttpGet(t9.SCRIPT .. "/lib/Library.lua"))()
local lib2 = loadstring(game:HttpGet(t9.SCRIPT .. "/lib/addons/ThemeManager.lua"))()
local lib3 = loadstring(game:HttpGet(t9.SCRIPT .. "/lib/addons/SaveManager.lua"))()
local lib4 = loadstring(game:HttpGet(t9.SCRIPT .. "/addons/esp.lua"))()
local lib5 = loadstring(game:HttpGet(t9.SCRIPT .. "/addons/key.lua"))()
local lib6, v35, v36, v37 = loadstring(game:HttpGet(t9.SCRIPT .. "/addons/module.lua"))()

if not (syn and syn.request or http and http.request or http_request or fluxus and fluxus.request) then
end

local function v38(p1, p2, p3)
	getgenv().Library:Notify({
		Title = "Tixo Hub",
		Description = p1,
		Time = p2 or 3,
		Icon = "bell",
		SoundId = p3
	})
end

local t10 = {}
local t11 = {}

local function v41()
	table.clear(t10)

	for _, player in ipairs(t1.Players:GetPlayers()) do
		if player ~= t1.LocalPlayer then
			table.insert(t10, player)
		end
	end
end

t1.Players.PlayerAdded:Connect(v41)
t1.Players.PlayerRemoving:Connect(v41)
v41()

local function v44(p4)
	u25 = p4
	HumanoidRootPart = p4:WaitForChild("HumanoidRootPart", 3)
	Humanoid = p4:WaitForChild("Humanoid", 3)

	if Humanoid then
		t5.OriginalSpeed = Humanoid.WalkSpeed
	end
end
local function v45()
	return t1.LocalPlayer:FindFirstChild("SelectedKiller") and t1.LocalPlayer.SelectedKiller.Value or t1.LocalPlayer:GetAttribute("SelectedKiller")
end
local function v46()
	return s1
end
local function v47(p5)
	local Team = p5 and p5.Team

	return Team and p5.Team.Name == "Killer"
end
local function v49(p6)
	return p6 and p6.Team and p6.Team.Name == "Survivors"
end
local function v50()
	return HumanoidRootPart
end
local function v51(p7)
	local v52 = v50()

	if v52 then
		return (p7 - v52.Position).Magnitude
	end

	return math.huge
end
local function v53(p8)
	if p8 then
		return p8:GetAttribute("Knocked") == true or p8:GetAttribute("IsHooked") == true
	end

	return false
end
local function v54(p9)
	if not p9 then
		return true
	end

	local playerFromCharacter = t1.Players:GetPlayerFromCharacter(p9)

	if playerFromCharacter and playerFromCharacter:GetAttribute("IsDead") then
		return true
	end

	if not p9:GetAttribute("IsCarried") then
		if not (p9:GetAttribute("IsHooked") or p9:GetAttribute("Knocked")) then
			local CheckInterractable = p9:FindFirstChild("CheckInterractable")

			if CheckInterractable then
				for _, v in ipairs({
					"isVaulting",
					"isSliding",
					"isDroppingPallet",
					"isRepairing",
					"isHealing",
					"isUnhooking",
					"isExiting"
				}) do
					if CheckInterractable:GetAttribute(v) == true then
						return true
					end
				end
			end

			return false
		end
	end

	return true
end
local function v59(p10)
	if not t3.Surv_ParrySafety then
		return true
	end

	if not p10 then
		return false
	end

	local CheckInterractable = p10:FindFirstChild("CheckInterractable")

	if CheckInterractable then
		if CheckInterractable:GetAttribute("isVaulting") == true then
			return false
		end

		if CheckInterractable:GetAttribute("isRepairing") == true then
			return false
		end

		if CheckInterractable:GetAttribute("isUnhooking") == true then
			return false
		end

		if CheckInterractable:GetAttribute("isHealing") == true then
			return false
		end

		if CheckInterractable:GetAttribute("isSliding") == true then
			return false
		end
	end

	return true
end

local t12 = {}
local t13 = {
	S = t1,
	Config = t3,
	State = t5,
	Cache = t8,
	Tuning = t6,
	ActivePlayers = t10,
	ActiveKillers = t11,
	VALID_PARRY_IDS = v36.VALID_PARRY_IDS,
	UIElements = t12,
	GetCharacterRoot = v50,
	GetDistance = v51,
	GetRole = v46,
	IsKiller = v47,
	ScInfo = t2,
	IsSurvivor = v49,
	IsDowned = v53,
	IsPlayerBusy = v54,
	IsSafeToParry = v59,
	Notif = v38,
	RepairEvent = RepairEvent,
	SkillRemote = SkillCheckResultEvent,
	PalletEvent = PalletDropEvent,
	ParryRemote = parry,
	GlobalRemotes = Remotes2
}

v36.Init(t13)
v35.Init(t13)
lib4.Init(t13)
lib6.Init(t13)
v37.Init(t13)

local function v63(character)
	if not character then
		return
	end

	task.spawn(function()
		local cutscene = character:WaitForChild("cutscene", 5)

		if cutscene and cutscene:IsA("LocalScript") then
			if t3.Misc_SkipCutscene then
				cutscene.Disabled = true
			end

			if t5.CutsceneConn then
				t5.CutsceneConn:Disconnect()
			end

			t5.CutsceneConn = cutscene:GetPropertyChangedSignal("Disabled"):Connect(function()
				if t3.Misc_SkipCutscene and not cutscene.Disabled then
					cutscene.Disabled = true
				end
			end)
		end
	end)
end
local function v65(p11)
	t3.Misc_SkipCutscene = p11

	local Character = t1.LocalPlayer.Character

	if p11 then
		if Character then
			v63(Character)
		end

		if t5.CharCutscene then
			t5.CharCutscene:Disconnect()
		end

		t5.CharCutscene = t1.LocalPlayer.CharacterAdded:Connect(v63)
	else
		if t5.CutsceneConn then
			t5.CutsceneConn:Disconnect()
			t5.CutsceneConn = nil
		end

		if t5.CharCutscene then
			t5.CharCutscene:Disconnect()
			t5.CharCutscene = nil
		end

		if Character then
			local cutscene = Character:FindFirstChild("cutscene")

			if cutscene and cutscene:IsA("LocalScript") then
				cutscene.Disabled = false
			end
		end
	end
end

pcall(function()
	ExtUIModule = loadstring(game:HttpGet(t9.SCRIPT .. "/addons/fps.lua"))()

	if ExtUIModule then
		t12.TargetUI = ExtUIModule.CreateTargetUI()
		t12.Watermark = ExtUIModule.CreateWatermark()
		t12.Spectator = ExtUIModule.CreateSpectator()
		t12.FOV = ExtUIModule.CreateFOV()
		getgenv().SpectUI = t12.Spectator.UI
		t5.WatermarkUI = t12.Watermark.UI
		t5.CrosshairUI = nil
	end
end)

if t12.TargetUI and t12.TargetUI.Buttons then
	for k, button in pairs(t12.TargetUI.Buttons) do
		button.MouseButton1Click:Connect(function()
			t3.Pistol_Target = k
			t12.TargetUI.UpdateVisuals(k)
			pcall(function()
				if Options and Options.Pistol_Target_Drop then
					Options.Pistol_Target_Drop:SetValue(k)
				end
			end)

			if getgenv().Library then
				v38("Pistol Target: " .. k, 0.5)
			end
		end)
	end
end

local t14 = {
	"Killer",
	"Survivor",
	"SCP"
}
local n1 = 1

local function v72()
	n1 += 1

	if n1 > #t14 then
		n1 = 1
	end

	local pistolTarget = t14[n1]

	t3.Pistol_Target = pistolTarget

	if t12.TargetUI then
		t12.TargetUI.UpdateVisuals(pistolTarget)
	end

	pcall(function()
		if Options then
			if Options.Pistol_Target_Drop then
				Options.Pistol_Target_Drop:SetValue(pistolTarget)
			end
		end
	end)

	if getgenv().Library then
		v38("Pistol Target: " .. pistolTarget, 0.5)
	end
end
local function v74()
	if not t12.Spectator then
		return
	end

	local n2 = 0

	for _, player in ipairs(t1.Players:GetPlayers()) do
		if player.Team and player.Team.Name == "Spectator" then
			n2 += 1
		end
	end

	t12.Spectator.CountText.Text = tostring(n2)
end
local function v78()
	if ExtUIModule then
		t5.CrosshairUI = ExtUIModule.DrawCrosshair({
			Enabled = t3.Crosshair_Enabled,
			Type = t3.Crosshair_Type,
			Color = t3.Crosshair_Color,
			Size = t3.Crosshair_Size,
			OffsetX = t3.Crosshair_OffsetX,
			OffsetY = t3.Crosshair_OffsetY
		})
	end
end
local function v79()
	if v46() ~= "Survivor" then
		return
	end

	local Character = t1.LocalPlayer.Character

	if not Character then
		return
	end

	local SmoothCamera = Character:WaitForChild("SmoothCamera", 3) or Character:FindFirstChild("SmoothCamera")

	if SmoothCamera and SmoothCamera:IsA("LocalScript") then
		if t3.Misc_SmoothCam then
			SmoothCamera:SetAttribute("CameraHeight", t3.Misc_CamHeight)
			SmoothCamera:SetAttribute("CameraStiffness", t3.Misc_CamStiffness)
		else
			SmoothCamera:SetAttribute("CameraHeight", -1)
			SmoothCamera:SetAttribute("CameraStiffness", 9.5)
		end
	end
end

local t15 = {
	["Sound 1"] = "rbxassetid://125027580248269",
	["Sound 2"] = "rbxassetid://79440711397443",
	["Sound 3"] = "rbxassetid://102793319115878",
	["Sound 4"] = "rbxassetid://134840941464861"
}
local t16 = {}

local function v84(p12)
	if not p12 or not p12:IsA("Sound") then
		return
	end

	if not p12:GetAttribute("OriginalSoundId") then
		p12:SetAttribute("OriginalSoundId", p12.SoundId)
	end

	local function v85()
		if t3.Pistol_CustomSound then
			local v86 = t15[t3.Pistol_SelectedSound]

			if v86 and p12.SoundId ~= v86 then
				p12.SoundId = v86
			end
		else
			local attribute = p12:GetAttribute("OriginalSoundId")

			if attribute and p12.SoundId ~= attribute then
				p12.SoundId = attribute
			end
		end
	end

	v85()

	if not t16[p12] then
		local t17 = {}

		table.insert(t17, p12:GetPropertyChangedSignal("SoundId"):Connect(v85))
		table.insert(t17, p12.Played:Connect(function()
			task.delay(1, function()
				if p12 then
					if p12.IsPlaying then
						p12:Stop()
					end
				end
			end)
		end))
		t16[p12] = t17
		p12.AncestryChanged:Connect(function(child, parent)
			if not parent and t16[p12] then
				for _, v in ipairs(t16[p12]) do
					v:Disconnect()
				end

				t16[p12] = nil
			end
		end)
	end
end
local function v91(p13)
	if not p13 then
		return
	end

	local function v92()
		local TwistOfFate = p13:FindFirstChild("Twist of Fate") or t1.Workspace:FindFirstChild("Twist of Fate", true)

		if TwistOfFate then
			for _, descendant in ipairs(TwistOfFate:GetDescendants()) do
				if descendant:IsA("Sound") then
					if descendant.Name:lower() == "shoot" then
						v84(descendant)
					end
				end
			end
		end
	end

	task.spawn(function()
		if p13:WaitForChild("Twist of Fate", 5) then
			v92()
		end
	end)
	v92()

	for _, v in ipairs({
		"Knocked",
		"IsHooked",
		"IsCarried"
	}) do
		p13:GetAttributeChangedSignal(v):Connect(v92)
	end
end
local function v98()
	if t5.HookF or not hookmetamethod then
		return
	end

	local v99

	v99 = hookmetamethod(game, "__namecall", newcclosure(function(p14, ...)
		local v100 = getnamecallmethod()
		local checkcaller_ = checkcaller and checkcaller()

		if not (checkcaller_ or typeof(p14) ~= "Instance") then
			if t3.Killer_BypassCarry and v100 == "GetAttribute" and ... == "IsCarrying" then
				return false
			end

			if v100 == "FireServer" then
				local Name = p14.Name

				if t3.Aim_SilentVeil and Name == "Spearthrow" then
					local v103 = ...

					if type(v103) == "table" and v103.Direction and t5.Veil_HasCache and t5.Veil_CachedDir then
						v103.Direction = t5.Veil_CachedDir
						v103.Origin = t5.Veil_CachedStartPos or v103.Origin
					end

					return v99(p14, v103)
				end

				if t3.Butcher_Aim and Name == "ChainThrow" then
					local Butcher_CachedDir = ...
					local value = select(2, ...)
					local value2 = select(3, ...)

					if t5.Butcher_HasCache and t5.Butcher_CachedDir and typeof(Butcher_CachedDir) == "Vector3" then
						Butcher_CachedDir = t5.Butcher_CachedDir
					end

					return v99(p14, Butcher_CachedDir, value, value2)
				end

				if Name == "Fire" and p14.Parent and p14.Parent.Name == "Twist of Fate" then
					if t3.PistolV2_Enabled and t5.PistolV2_CachedShouldRedirect and t5.PistolV2_CachedRedirectDir then
						local v107 = ...
						local PistolV2_CachedRedirectDir = t5.PistolV2_CachedRedirectDir

						if t3.PistolV2_ShowLaser and t5.PistolV2_CachedOriginPos and t5.PistolV2_CachedTargetPos then
							pcall(function()
								lib6.RenderPistolV2Laser(t5.PistolV2_CachedOriginPos, t5.PistolV2_CachedTargetPos)
							end)
						end

						return v99(p14, v107, PistolV2_CachedRedirectDir, 3)
					end

					if t3.Aim_Silent then
						return nil
					end
				end

				if t3.Surv_NoFall and Name == "Fall" then
					return nil
				end

				if Name == "VaultEvent" then
					if t3.Surv_SpeedAfterVault and not t5.QuickRecoveryOnCD then
						t5.QuickRecoveryOnCD = true
						task.defer(function()
							t5.VaultBoostActive = true

							local Character = t1.LocalPlayer.Character

							if Character then
								Character:SetAttribute("speedboost", 1.35)
							end

							if t5.VaultBoostThread then
								task.cancel(t5.VaultBoostThread)
							end

							t5.VaultBoostThread = task.delay(2.8, function()
								t5.VaultBoostActive = false

								local Character2 = t1.LocalPlayer.Character

								if Character2 then
									local Surv_Spdb = t3.Surv_Perks and t3.Surv_Spdb

									Character2:SetAttribute("speedboost", Surv_Spdb and t3.Surv_SpeedBoost or 1)
								end

								task.wait(t3.Surv_QuickRecoveryCD)
								t5.QuickRecoveryOnCD = false
							end)
						end)
					end

					if t3.Surv_FastVault and not t5.FlowstateOnCD then
						task.defer(function()
							task.wait(0.3)
							t5.FlowstateOnCD = true

							if t5.FlowstateCDThread then
								task.cancel(t5.FlowstateCDThread)
							end

							t5.FlowstateCDThread = task.spawn(function()
								task.wait(t3.Surv_FlowstateCD)
								t5.FlowstateOnCD = false
							end)
						end)
					end
				end

				if t3.Anti_Blind and v46() == "Killer" and Name == "GotBlinded" then
					return nil
				end
			end
		end

		return v99(p14, ...)
	end))
	t5.HookF = true
end

task.defer(function()
	v98()
end)

local function v112(p15)
	if not p15 then
		return
	end

	if t5.SpearModeConn then
		t5.SpearModeConn:Disconnect()
		t5.SpearModeConn = nil
	end

	if t5.StunConn then
		t5.StunConn:Disconnect()
		t5.StunConn = nil
	end

	t5.SpearModeConn = p15:GetAttributeChangedSignal("spearmode"):Connect(function()
		if v46() == "Killer" and v45() == "Veil" then
			if p15:GetAttribute("spearmode") == true then
				t7.isChargingSpear = false
				t7.currentTouchInput = nil
			end
		end
	end)
	t5.StunConn = p15:GetAttributeChangedSignal("IsStunned"):Connect(function()
		if p15:GetAttribute("IsStunned") == true then
			t7.isChargingSpear = false
			t7.currentTouchInput = nil
		end
	end)
end
local function v113()
	if not t1.LocalPlayer.Team then
		s1 = "Unknown"

		return
	end

	local Name = t1.LocalPlayer.Team.Name

	if Name == "Killer" then
		s1 = "Killer"
	elseif Name == "Survivors" then
		s1 = "Survivor"
	else
		s1 = "Spectator"
	end

	t5.VaultBoostActive = false
	t5.QuickRecoveryOnCD = false

	if t5.VaultBoostThread then
		task.cancel(t5.VaultBoostThread)
		t5.VaultBoostThread = nil
	end

	v35.KillerPredict()
	lib4.ClearAllESP()

	if Name == "Killer" or Name == "Survivors" then
		if v41 then
			v41()
		end

		task.delay(15, function()
			if t5.Unloaded then
				return
			end

			if Name == "Survivor" and t3.Surv_FastAccel then
				v36.AccelerationFast(true)
			end

			lib4.ScanMap()
			v79()
			v36.SkillS(t1.LocalPlayer.Character)
			v112(t1.LocalPlayer.Character)

			if t3.Misc_SmoothHDR then
				lib4.SmoothHdr(true)
			end
		end)
	end
end
local function v115()
	if not t3.ESP_Master then
		return
	end

	if t3.ESP_SCP then
		for _, scP in ipairs(t8.SCPs) do
			if scP and scP.Parent then
				local Humanoid2 = scP:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart2 = scP:FindFirstChild("HumanoidRootPart")

				HumanoidRootPart2 = HumanoidRootPart2 or scP:FindFirstChild("Torso") or scP:FindFirstChild("Head") or scP.PrimaryPart

				if Humanoid2 and HumanoidRootPart2 and math.floor(Humanoid2.WalkSpeed) > 0 and math.floor(Humanoid2.WalkSpeed) ~= 16 then
					local SCP = t6.Colors.SCP
					local SCPEH = scP:FindFirstChild("SCPEH")

					if not SCPEH then
						SCPEH = Instance.new("Highlight")
						SCPEH.Name = "SCPEH"
						SCPEH.Parent = scP
					end

					SCPEH.FillColor = SCP
					SCPEH.OutlineColor = SCP
					SCPEH.FillTransparency = t3.ESP_Outline and 1 or t3.Trans or 0.7
					SCPEH.Enabled = true
					SCPEH.OutlineTransparency = 0.5
				else
					local SCPEH = scP:FindFirstChild("SCPEH")

					if SCPEH then
						SCPEH.Enabled = false
					end
				end
			end
		end
	else
		lib4.ClearESP("SCP")
	end
end

local Part = Instance.new("Part")

Part.Name = "PLaser"
Part.Material = Enum.Material.Neon
Part.Color = Color3.fromRGB(57, 255, 20)
Part.CanCollide = false
Part.Anchored = true
Part.CastShadow = false
Part.Size = Vector3.new(0.05, 0.05, 1.5)
pcall(function()
	local Trajectory = t1.Workspace.Terrain:FindFirstChild("Trajectory") or t1.Workspace:FindFirstChild("Trajectory")

	if Trajectory then
		Trajectory:Destroy()
	end
end)

local Highlight = Instance.new("Highlight")

Highlight.Name = "VTarget"
Highlight.FillColor = Color3.fromRGB(255, 0, 0)
Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
Highlight.FillTransparency = 0.5
Highlight.OutlineTransparency = 0

local Circle = Drawing.new("Circle")

Circle.Filled = true
Circle.Radius = 6
Circle.Color = Color3.fromRGB(0, 220, 255)
Circle.Transparency = 0.9
Circle.Visible = false

local Folder = Instance.new("Folder")

Folder.Name = "Trajectory"
Folder.Parent = t1.Workspace.Terrain

local t18 = {}
local t19 = {}

for i = 1, 16 do
	local Attachment = Instance.new("Attachment")

	Attachment.Name = "Att_" .. i
	Attachment.Parent = Folder
	table.insert(t18, Attachment)
end

for i = 1, 15 do
	local Beam = Instance.new("Beam")

	Beam.Attachment0 = t18[i]
	Beam.Attachment1 = t18[i + 1]
	Beam.Width0 = 0.12
	Beam.Width1 = 0.12
	Beam.FaceCamera = true
	Beam.Color = ColorSequence.new(Color3.fromRGB(0, 220, 255))
	Beam.LightEmission = 1
	Beam.LightInfluence = 0
	Beam.Texture = "rbxassetid://4740112440"
	Beam.TextureSpeed = 2
	Beam.Enabled = false
	Beam.Parent = Folder
	table.insert(t19, Beam)
end

local function v134()
	for _, v in ipairs(t19) do
		v.Enabled = false
	end

	Circle.Visible = false
end
local function v137(p16, p17, p18, p19, p20, p21, p22)
	local v138 = p17 * p18
	local v139 = math.max(t3.SPEAR_MaxDist or 500, 500)
	local Position = p21 and p21.Position
	local Magnitude = Position and (Position - p16).Magnitude

	Magnitude = Magnitude or 100

	local v142 = Magnitude / p18 / 15
	local v143 = p16
	local v144 = v138
	local vector3 = Vector3.new(0, -p19, 0)
	local t20 = { p16 }
	local huge = math.huge
	local v148 = p22 or Position

	for i = 1, 15 do
		local v150 = v143 + v144 * v142 + 0.5 * vector3 * v142 ^ 2

		table.insert(t20, v150)

		if v148 then
			local Magnitude2 = (v150 - v148).Magnitude

			if Magnitude2 < huge then
				huge = Magnitude2
			end
		end

		v143 = v150
		v144 += vector3 * v142
	end

	local v152 = math.max(10, Magnitude * 0.15)
	local v153 = p21 ~= nil and Magnitude <= v139 and huge <= v152
	local colorSequence = ColorSequence.new(v153 and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60))

	for i = 1, #t20 do
		if t18[i] then
			t18[i].WorldPosition = t20[i]
		end
	end

	for i = 1, 15 do
		if i < #t20 and t3.Veil_ShowLaser then
			t19[i].Color = colorSequence
			t19[i].Enabled = true
		else
			t19[i].Enabled = false
		end
	end

	if p21 then
		local v157, v158 = t1.Camera:WorldToViewportPoint(p21.Position)

		if v158 and v157.Z > 0 then
			Circle.Position = Vector2.new(v157.X, v157.Y)
			Circle.Visible = true

			if v153 then
				Circle.Color = Color3.fromRGB(0, 255, 120)
			else
				Circle.Color = Color3.fromRGB(255, 60, 60)
			end
		else
			Circle.Visible = false
		end
	else
		Circle.Visible = false
	end
end
local function v159()
	table.clear(t11)

	for _, player in ipairs(t1.Players:GetPlayers()) do
		if player ~= t1.LocalPlayer and v47(player) and player.Character then
			table.insert(t11, player)
		end
	end
end

t1.Players.PlayerAdded:Connect(v159)
t1.Players.PlayerRemoving:Connect(v159)

for _, player in ipairs(t1.Players:GetPlayers()) do
	player:GetPropertyChangedSignal("Team"):Connect(v159)
end

local Options_ = lib.Options
local Toggles = lib.Toggles

t13.Toggles = Toggles
t13.Options = Options_
lib.ForceCheckbox = false
lib.ShowToggleFrameInKeybinds = true

local v166 = lib:CreateWindow({
	Title = "VD TIXO",
	AutoShow = true,
	MenuFadeTime = 0.2,
	Footer = "VD T " .. t2.version .. " | Checking Authentication...",
	Font = Font.fromEnum(Enum.Font.SourceSans),
	Size = UDim2.fromOffset(450, 250),
	IconSize = UDim2.fromOffset(40, 40),
	Center = true,
	CornerRadius = 10,
	Icon = t2.icon,
	ShowCustomCursor = false,
	EnableSidebarResize = false,
	EnableCompacting = false,
	SidebarCompacted = false
})
local t21 = {}

local function v168()
	local Surv_AutoSkillCheck = t3.Surv_AutoSkillCheck
	local Surv_SkillCheckMode = t3.Surv_SkillCheckMode
	local v171 = Surv_AutoSkillCheck

	if v171 then
		local v172 = Surv_SkillCheckMode == "Legit" or Surv_SkillCheckMode == "Instan"

		t3.Surv_PerfectSkill = v172 or Surv_SkillCheckMode == "Normal" or Surv_SkillCheckMode == "Random"
		t3.Surv_InstanSkill = Surv_AutoSkillCheck and Surv_SkillCheckMode == "Instan"
		t3.Surv_NoSkill = Surv_AutoSkillCheck and Surv_SkillCheckMode == "Skip"
	else
		t3.Surv_PerfectSkill = v171
		t3.Surv_InstanSkill = Surv_AutoSkillCheck and Surv_SkillCheckMode == "Instan"
		t3.Surv_NoSkill = Surv_AutoSkillCheck and Surv_SkillCheckMode == "Skip"
	end

	task.spawn(function()
		local Character = t1.LocalPlayer.Character

		if Character then
			local SkillcheckGen = Character:FindFirstChild("Skillcheck-gen")
			local SkillcheckPlayer = Character:FindFirstChild("Skillcheck-player")

			if SkillcheckGen then
				SkillcheckGen.Disabled = t3.Surv_NoSkill
			end

			if SkillcheckPlayer then
				SkillcheckPlayer.Disabled = t3.Surv_NoSkill
			end
		end
	end)
end
local function v176()
	v166:SetFooter("VD T " .. t2.version .. " | " .. (u14 and "VIP Script" or "Free Script"))
	t21.Surv = v166:AddTab("Survivor", "shield-plus", "Fitur tambahan untuk team survivor")
	t21.Killer = v166:AddTab("Killer", "skull", "Fitur tambahan untuk team killer")
	t21.Esp = v166:AddTab("ESP", "eye", "Esp semua objek dalam map")
	t21.Aim = v166:AddTab("Aim", "crosshair", "Op aim")
	t21.Misc = v166:AddTab("Misc", "sliders-horizontal")
	t21.Config = v166:AddTab("Config", "settings")
	t21.Info = v166:AddTab("Info", "badge-info")

	local Event = t21.Surv:AddLeftGroupbox("Event", "balloon")
	local v178 = t21.Surv:AddLeftGroupbox("Main & Parry", "shield")
	local v179 = t21.Surv:AddLeftGroupbox("Perks & Speed Mod", "zap")
	local v180 = t21.Surv:AddRightGroupbox("Skill Check & Repair", "wrench")
	local v181 = t21.Surv:AddRightGroupbox("Traps & Window Bypass", "shield-alert")
	local v182 = t21.Surv:AddRightGroupbox("Utility & Assist", "bot")
	local v183 = t21.Surv:AddRightGroupbox("Camera Settings", "camera")
	local v184 = t21.Killer:AddLeftGroupbox("Killer Settings", "skull")
	local v185 = t21.Killer:AddRightTabbox()
	local v186 = v185:AddTab("Skill Killer", "target")
	local v187 = v185:AddTab("Misc & Mask", "sliders-horizontal")

	Event:AddToggle("Surv_AutoCrushPumpkin", {
		Text = "Auto Crush Pumpkin",
		Default = false,
		Tooltip = "Otomatis menghancurkan labu di sekitar",
		Callback = function(p23)
			t3.AutoCrush_Pumpkin = p23
		end
	})
	v178:AddToggle("Surv_GodMode", {
		Text = "God Mode",
		Default = false,
		Callback = function(p24)
			t3.Surv_GodMode = p24
		end
	})
	v178:AddToggle("Surv_SelfHeal", {
		Text = "self progres Heal",
		Content = "Heal",
		Switch = true,
		Default = false,
		Callback = function(p25)
			t3.Surv_SelfHeal = p25
		end
	}):AddKeyPicker("Surv_KeyHeal", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Self heal",
		NoUI = false
	})
	v178:AddDivider("Auto Pallet")
	v178:AddToggle("Surv_AutoPalletToggle", {
		Text = "Auto Drop Pallet",
		Tooltip = "Otomatis menjatuhkan pallet.",
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p26)
			v36.AutoPallet(p26)
		end
	}):AddKeyPicker("Surv_AutoPalletKey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Auto Pallet",
		NoUI = false
	})
	v178:AddSlider("Surv_AutoPalletRadius", {
		Text = "Radius Pallet",
		Min = 5,
		Max = 20,
		Default = 10,
		Rounding = 0,
		Callback = function(p27)
			t3.Surv_AutoPalletRadius = p27
		end
	})
	v178:AddDivider("Auto Parry System")
	v178:AddToggle("Surv_Parry", {
		Text = "Auto Parry V1",
		Content = "Auto Parry",
		Switch = true,
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p28)
			t3.Surv_Parry = p28

			if p28 then
				Toggles.Surv_ParryV2:SetValue(false)
			end
		end
	}):AddKeyPicker("Surv_ParryKey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Auto Parry",
		NoUI = false
	})
	v178:AddToggle("Surv_ParryV2", {
		Text = "Auto Parry V2",
		Content = "Auto Parry v2",
		Switch = true,
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p29)
			t3.Surv_ParryV2 = p29
			v36.ParryV2S(p29)

			if p29 then
				Toggles.Surv_Parry:SetValue(false)
			end
		end
	}):AddKeyPicker("Surv_ParryV2Key", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Auto Parry V2",
		NoUI = false
	})
	v178:AddToggle("Fake_Parry", {
		Text = "Fake Parry (keybind R)",
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p30)
			if p30 then
				pcall(function()
					loadstring(game:HttpGet("https://pastebin.com/raw/WNJGb9ct"))()
				end)
			elseif getgenv().VD_FakeParry_Cleanup then
				pcall(getgenv().VD_FakeParry_Cleanup)
			end
		end
	})
	v178:AddCheckbox("Surv_ParrySafety", {
		Text = "Safety Parry",
		Default = false,
		Callback = function(p31)
			t3.Surv_ParrySafety = p31
		end
	})
	v178:AddCheckbox("Surv_ParryAggressive", {
		Text = "Aggressive parry V1",
		Default = false,
		Callback = function(p32)
			t3.Surv_ParryAggressive = p32
		end
	})
	v178:AddCheckbox("Surv_ParryCircle", {
		Text = "Esp Range",
		Default = true,
		Callback = function(p33)
			t3.Surv_ParryCircle = p33
		end
	})
	v178:AddSlider("Surv_ParryRadius", {
		Text = "Parry Radius",
		Min = 5,
		Max = 25,
		Default = t3.Surv_ParryRadius,
		Rounding = 0,
		Callback = function(p34)
			t3.Surv_ParryRadius = p34
		end
	})
	v178:AddSlider("Surv_ParryFace", {
		Text = "Face Sensitivity",
		Min = -10,
		Max = 10,
		Default = t3.Surv_ParryFace * 10,
		Rounding = 0,
		Callback = function(p35)
			t3.Surv_ParryFace = p35 / 10
		end
	})
	v178:AddDropdown("Surv_IgnoreSkillsList", {
		Text = "Ignore Skills",
		Values = {
			"Hidden S1",
			"Abyssal S1"
		},
		Default = {},
		Multi = true,
		Callback = function(p36)
			t3.Ignored_Skills_List = p36
		end
	})
	v179:AddToggle("Surv_Perks", {
		Text = "Perks Mod",
		Default = false,
		Callback = function(p37)
			t3.Surv_Perks = p37
		end
	}):AddKeyPicker("Surv_PerksKey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Perks Mod",
		NoUI = false
	})
	v179:AddCheckbox("Surv_Spdb", {
		Text = "speedboost",
		Default = false,
		Callback = function(p38)
			t3.Surv_Spdb = p38

			local Character = t1.LocalPlayer.Character

			if Character and v46() == "Survivor" then
				if p38 and t3.Surv_Perks then
					Character:SetAttribute("speedboost", t3.Surv_SpeedBoost)
				else
					Character:SetAttribute("speedboost", 1)
				end
			end
		end
	})
	v179:AddSlider("Surv_SpeedSlider", {
		Text = "Speed Boost Value",
		Min = 10,
		Max = 20,
		Default = 11,
		Rounding = 1,
		Callback = function(p39)
			t3.Surv_SpeedBoost = p39 / 10

			local Character = t1.LocalPlayer.Character

			if Character and t3.Surv_Spdb then
				if t3.Surv_Perks and not t5.VaultBoostActive then
					Character:SetAttribute("speedboost", t3.Surv_SpeedBoost)
				end
			end
		end
	})
	v179:AddSlider("Surv_VaultSlider", {
		Text = "Vault Speed",
		Min = 10,
		Max = 20,
		Default = 13,
		Rounding = 1,
		Callback = function(p40)
			t3.Surv_VaultSpeed = p40 / 10
		end
	})
	v179:AddCheckbox("Surv_PerfectVault", {
		Text = "Perfect vault",
		Default = false,
		Callback = function(p41)
			t3.Surv_PerfectVault = p41
		end
	})
	v179:AddCheckbox("Surv_FastVault", {
		Text = "Flowstate",
		Default = false,
		Callback = function(p42)
			t3.Surv_FastVault = p42

			if not p42 then
				if t5.FlowstateCDThread then
					task.cancel(t5.FlowstateCDThread)
					t5.FlowstateCDThread = nil
				end

				t5.FlowstateOnCD = false

				local Character = t1.LocalPlayer.Character

				if Character then
					Character:SetAttribute("Flowstate", false)
				end
			end
		end
	})
	v179:AddSlider("Surv_FlowstateCD_Slider", {
		Text = "Flowstate Cooldown",
		Min = 5,
		Max = 60,
		Default = 20,
		Rounding = 0,
		Callback = function(p43)
			t3.Surv_FlowstateCD = p43
		end
	})
	v179:AddCheckbox("Surv_SpeedAfterVault", {
		Text = "Quick Recovery",
		Default = false,
		Callback = function(p44)
			t3.Surv_SpeedAfterVault = p44
		end
	})
	v179:AddSlider("Surv_QuickRecovCD_Slider", {
		Text = "Quick Recovery Cooldown",
		Min = 5,
		Max = 60,
		Default = 15,
		Rounding = 0,
		Callback = function(p45)
			t3.Surv_QuickRecoveryCD = p45
		end
	})
	v180:AddToggle("Surv_AutoSkillCheck", {
		Text = "Auto Skill Check",
		Default = false,
		Callback = function(p46)
			t3.Surv_AutoSkillCheck = p46
			v168()
		end
	})
	v180:AddDropdown("Surv_SkillCheckMode", {
		Text = "Mode",
		Values = {
			"Legit",
			"Instan",
			"Skip",
			"Normal",
			"Random"
		},
		Default = 1,
		Multi = false,
		Tooltip = [[Instan: Auto nge-hit
Legit: Nunggu jarum pas
Normal: Safe zone lebar
Random: Perfect pertama, lalu Normal jika kena King Scourge]],
		Callback = function(p47)
			t3.Surv_SkillCheckMode = p47
			v168()
		end
	})
	v180:AddSlider("Surv_SkillSpeedSlider", {
		Text = "Skill Check Speed",
		Min = 1,
		Max = 30,
		Default = 10,
		Rounding = 1,
		Callback = function(p48)
			t3.Surv_SkillSpeed = p48 / 10
		end
	})
	v181:AddToggle("Surv_AutoDisarmTrap", {
		Text = "Auto Disarm Trap",
		Content = "auto disarm",
		Switch = true,
		Tooltip = "Otomatis mendisarm trap terdekat",
		Default = false,
		Callback = function(p49)
			t3.Surv_AutoDisarmTrap = p49

			if p49 then
				if t5.DisarmTrapThread then
					task.cancel(t5.DisarmTrapThread)
				end

				t5.DisarmTrapThread = task.spawn(function()
					local u191 = false

					while t3.Surv_AutoDisarmTrap do
						if t5.Unloaded then
							break
						end

						task.wait(0.3)

						if not (v46() ~= "Survivor" or u191) then
							pcall(function()
								local Character = t1.LocalPlayer.Character
								local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")

								if HumanoidRootPart2 and t8.Traps then
									local v194
									local n3 = 5

									for _, trap in ipairs(t8.Traps) do
										if trap and trap.Parent and trap:GetAttribute("Armed") == true then
											local Handle = trap:FindFirstChild("Handle") or trap:FindFirstChild("hitbox") or trap:IsA("Model") and trap.PrimaryPart or trap:FindFirstChildWhichIsA("BasePart")

											if Handle then
												local Magnitude = (HumanoidRootPart2.Position - Handle.Position).Magnitude

												if Magnitude < n3 then
													n3 = Magnitude
													v194 = trap
												end
											end
										end
									end

									if v194 then
										u191 = true

										local DisarmTrap = t1.ReplicatedStorage:FindFirstChild("Remotes") and t1.ReplicatedStorage.Remotes:FindFirstChild("Killers") and t1.ReplicatedStorage.Remotes.Killers:FindFirstChild("Butcher") and t1.ReplicatedStorage.Remotes.Killers.Butcher:FindFirstChild("DisarmTrap")

										if DisarmTrap then
											v38("Mendisarm Trap... (Mohon diam 5 detik)", 5)
											DisarmTrap:FireServer("begin", v194)
											task.wait(5)
											DisarmTrap:FireServer("commit")
											v38("Berhasil Mendisarm Trap!", 2)
										end

										task.wait(1.5)
										u191 = false
									end
								end
							end)
						end
					end
				end)
			elseif t5.DisarmTrapThread then
				task.cancel(t5.DisarmTrapThread)
				t5.DisarmTrapThread = nil
			end
		end
	}):AddKeyPicker("Surv_AutoDisarmKey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Auto Disarm",
		NoUI = false
	})
	v181:AddToggle("AutoFreeTrapToggle", {
		Text = "Bypass trap",
		Default = false,
		Tooltip = "Bypass trap",
		Callback = function(p50)
			v36.AutoFreeTrap(p50)
		end
	})
	v181:AddToggle("AntiBlockWindowToggle", {
		Text = "Anti Block Window",
		Content = "Infinite vault",
		Switch = true,
		Default = false,
		Risky = true,
		Tooltip = "Otomatis menghapus duri/blokir pada jendela di sekitarmu",
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p51)
			if p51 then
				t5.blockThread = task.spawn(function()
					local CollectionService = game:GetService("CollectionService")

					while task.wait(1) do
						pcall(function()
							local Character = t1.LocalPlayer.Character

							if not Character or not Character:FindFirstChild("HumanoidRootPart") then
								return
							end

							local HumanoidRootPart2 = Character.HumanoidRootPart

							for _, v in ipairs({
								"BlockedVault",
								"BlockedWindow",
								"Blocked"
							}) do
								for _, v2 in ipairs(CollectionService:GetTagged(v)) do
									CollectionService:RemoveTag(v2, v)
								end
							end

							local partBoundsInRadius = t1.Workspace:GetPartBoundsInRadius(HumanoidRootPart2.Position, 40)

							for _, partBoundsInRadiu in ipairs(partBoundsInRadius) do
								if partBoundsInRadiu:GetAttribute("Blocked") ~= nil then
									partBoundsInRadiu:SetAttribute("Blocked", false)
								end

								if partBoundsInRadiu:GetAttribute("IsBlocked") ~= nil then
									partBoundsInRadiu:SetAttribute("IsBlocked", false)
								end

								if partBoundsInRadiu:GetAttribute("Spiked") ~= nil then
									partBoundsInRadiu:SetAttribute("Spiked", false)
								end

								local v211 = partBoundsInRadiu.Name:lower()

								if v211:match("spike") or v211:match("blocker") or v211:match("entity") then
									if partBoundsInRadiu.CanCollide == true then
										partBoundsInRadiu.CanCollide = false
									end

									if partBoundsInRadiu.Transparency ~= 1 then
										partBoundsInRadiu.Transparency = 1
									end
								end
							end
						end)
					end
				end)

				return
			end

			if t5.blockThread then
				task.cancel(t5.blockThread)
				t5.blockThread = nil
			end
		end
	})
	v182:AddToggle("Surv_FastAccelToggle", {
		Text = "Fast zigzag",
		Default = false,
		Tooltip = "Anti slow zigzag",
		Callback = function(p52)
			t3.Surv_FastAccel = p52

			if v46() == "Survivor" then
				v36.AccelerationFast(p52)
			end
		end
	})
	v182:AddToggle("Surv_AutoSprintToggle", {
		Text = "Auto Sprint (Mobile)",
		Default = false,
		Tooltip = "Otomatis lari saat bergerak",
		Callback = function(p53)
			t3.Surv_AutoSprint = p53

			if p53 then
				if t5.AutoSprintThread then
					task.cancel(t5.AutoSprintThread)
				end

				t5.AutoSprintThread = task.spawn(function()
					while t3.Surv_AutoSprint and not t5.Unloaded do
						task.wait(0.1)

						local Character = t1.LocalPlayer.Character
						local Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")

						if Character and Humanoid2 and Humanoid2.Health > 0 and not v53(Character) then
							if not v54(Character) then
								if Character:GetAttribute("Crouching") ~= true and Humanoid2.MoveDirection.Magnitude > 0 then
									local v214 = false
									local attribute = Character:GetAttribute("Sprinting")

									if type(attribute) == "boolean" then
										v214 = attribute
									else
										local Sprinting = Character:FindFirstChild("Sprinting")

										if Sprinting then
											if Sprinting:IsA("BoolValue") then
												v214 = Sprinting.Value
											end
										end
									end

									if not v214 then
										local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
										local sprint = PlayerGui and PlayerGui:FindFirstChild("Survivor-mob") and PlayerGui["Survivor-mob"]:FindFirstChild("Controls") and PlayerGui["Survivor-mob"].Controls:FindFirstChild("sprint")

										if sprint and sprint.Visible then
											if type(firesignal) == "function" then
												pcall(function()
													firesignal(sprint.MouseButton1Click)
												end)
											elseif type(firesignal) == "table" then
												pcall(function()
													sprint.MouseButton1Click:Fire()
												end)
											end
										end
									end
								end
							end
						end
					end
				end)
			elseif t5.AutoSprintThread then
				task.cancel(t5.AutoSprintThread)
				t5.AutoSprintThread = nil
			end
		end
	})
	v182:AddToggle("Surv_AutoCrouch", {
		Text = "Auto Crouch dodge",
		Default = false,
		Callback = function(p54)
			t3.Surv_AutoCrouch = p54
		end
	})
	v182:AddToggle("Surv_CrouchV", {
		Text = "Auto Crouch Veil",
		Default = false,
		Callback = function(p55)
			t3.Surv_CrouchV = p55
		end
	})
	v182:AddToggle("Surv_NoFall", {
		Text = "Anti slow",
		Default = false,
		Callback = function(p56)
			t3.Surv_NoFall = p56
		end
	})
	v183:AddToggle("Surv_Fov", {
		Text = "Custom FOV",
		Default = false,
		Callback = function(p57)
			t3.Surv_Fov = p57

			if not p57 then
				t1.Camera.FieldOfView = 70
			end
		end
	})

	do
		v183:AddSlider("Surv_FOV_Value", {
			Text = "Field of View",
			Min = 70,
			Max = 120,
			Default = 70,
			Rounding = 0,
			Callback = function(p58)
				t3.Surv_FOV_Value = p58
			end
		})
	end

	v184:AddDivider("Butcher Aim")

	do
		v184:AddToggle("Killer_WalkSpeedToggle", {
			Text = "Walk Speed",
			Content = "Walkspeed",
			Switch = true,
			Default = false,
			Callback = function(p59)
				t3.Killer_WalkSpeedToggle = p59

				if not p59 and t1.LocalPlayer.Character then
					if t1.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
						t1.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = t5.OriginalSpeed or 16
					end
				end
			end
		}):AddKeyPicker("Killer_WalkSpeedKey", {
			Default = "None",
			SyncToggleState = true,
			Mode = "Toggle",
			Text = "Walk Speed",
			NoUI = false
		})
	end

	do
		v184:AddSlider("Killer_WalkSpeedSlider", {
			Text = "Walk Speed Value",
			Min = 16,
			Max = 300,
			Default = 16,
			Rounding = 0,
			Callback = function(p60)
				t3.Killer_WalkSpeed = p60
			end
		})
	end

	v184:AddDivider("attack menu")
	v184:AddDropdown("Killer_AttackModeDrop", {
		Text = "Attack Mode",
		Values = {
			"BasicAttack",
			"Lunge"
		},
		Default = 1,
		Multi = false,
		Callback = function(p61)
			t3.Killer_AttackMode = p61
		end
	})
	v184:AddToggle("Killer_SpamHit", {
		Text = "One hit",
		Default = false,
		Risky = true,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p62)
			t3.Killer_SpamHit = p62
		end
	})

	do
		v184:AddCheckbox("Killer_HitEspCircle", {
			Text = "Show Range",
			Default = true,
			Callback = function(p63)
				t3.Killer_HitEspCircle = p63
			end
		})
	end

	do
		v184:AddSlider("Killer_SpamHitRadius", {
			Text = "Hit Radius",
			Min = 5,
			Max = 15,
			Default = 8,
			Rounding = 0,
			Callback = function(p64)
				t3.Killer_SpamHitRadius = p64
			end
		})
	end

	do
		v184:AddSlider("Killer_SpamHitDelay", {
			Text = "Hit Delay",
			Min = 15,
			Max = 500,
			Default = 50,
			Rounding = 0,
			Callback = function(p65)
				t3.Killer_SpamHitDelay = p65
			end
		})
	end

	v186:AddToggle("Surv_CounterParryGUI", {
		Text = "Counter Parry",
		Content = "Counter Parry",
		Switch = true,
		Tooltip = "Keybind PC V",
		Default = false,
		Callback = function(p66)
			if p66 then
				pcall(function()
					loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/CParry"))()
				end)
			elseif getgenv().CParry then
				pcall(getgenv().CParry)
			end
		end
	})
	v186:AddToggle("Killer_InfLunge", {
		Text = "Infinite Lunge",
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p67)
			t3.Killer_InfLunge = p67

			local Character = t1.LocalPlayer.Character

			if not p67 then
				if t5.lungeV2Connection then
					t5.lungeV2Connection:Disconnect()
					t5.lungeV2Connection = nil
				end

				if Character then
					Character:SetAttribute("lungeboost", 1)
				end
			elseif Character then
				v35.InfLungeV2(Character)
			end
		end
	}):AddKeyPicker("Key_InfLunge", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Lunge",
		NoUI = false
	})

	do
		v186:AddToggle("Anti_Blind", {
			Text = "Anti blind",
			Default = false,
			Callback = function(p68)
				t3.Anti_Blind = p68
			end
		})
	end

	v186:AddToggle("Auto_BlockVault", {
		Text = "Block (windows/pallet)",
		Content = "Block windows",
		Switch = true,
		Default = false,
		Tooltip = "Block all pallet & windows",
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p69)
			v35.BlockVault(p69)
		end
	})
	v186:AddToggle("Killer_BypassCarryToggle", {
		Text = "Bypass Skill Gendong",
		Content = "Bypass Carry",
		Switch = true,
		Tooltip = "Bisa menggunakan Dash/Skill saat menggendong target",
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Default = false,
		Callback = function(p70)
			t3.Killer_BypassCarry = p70

			if p70 then
				if v46() ~= "Killer" then
					if getgenv().Library then
						v38("Fitur aktif, berlaku saat jadi Killer!", 3)
					end
				end
			end
		end
	})
	v186:AddToggle("Racing", {
		Text = "Ayam Racing",
		Content = "Ayam Racing",
		Switch = false,
		Default = false,
		Callback = function()
			game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Killers"):FindFirstChild("Masked"):FindFirstChild("alexattack"):FireServer()
		end
	})
	v186:AddToggle("Slasher_InvisibleToggle", {
		Text = "INVISIBLE SLASHER",
		Default = false,
		Tooltip = "Spam skill 1 agar invisible",
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p71)
			v35.InvisibleSlasher(p71)
		end
	}):AddKeyPicker("Key_SlasherInvis", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Invisible Slasher",
		NoUI = false
	})
	v186:AddDivider("Break Objek")

	do
		v186:AddToggle("Killer_BreakS", {
			Text = "Break objek",
			Default = false,
			Tooltip = "Kecepatan hancurkan objek",
			Callback = function(p72)
				t3.Killer_BreakS(p72)
			end
		})
	end

	v186:AddSlider("Killer_BreakSpeed", {
		Text = "Break speed",
		Min = 1,
		Max = 10,
		Default = 1,
		Rounding = 0,
		Callback = function(p73)
			t3.Killer_BreakSpeed = p73
		end
	})
	v187:AddToggle("Killer_3rdPerson", {
		Text = "3rd Person Camera",
		Default = false,
		Callback = function(p74)
			t3.Killer_3rdPerson = p74

			if t5.ThirdPersonCamConn then
				t5.ThirdPersonCamConn:Disconnect()
				t5.ThirdPersonCamConn = nil
			end

			if p74 then
				OriginalCamSettings.CameraMode = t1.LocalPlayer.CameraMode
				OriginalCamSettings.MinZoom = t1.LocalPlayer.CameraMinZoomDistance
				OriginalCamSettings.MaxZoom = t1.LocalPlayer.CameraMaxZoomDistance
				OriginalCamSettings.DevComputer = t1.LocalPlayer.DevComputerCameraMode
				OriginalCamSettings.DevTouch = t1.LocalPlayer.DevTouchCameraMode

				local function v220()
					if v46() ~= "Killer" then
						return
					end

					local Killer_CameraMode = t3.Killer_CameraMode or "Classic"

					if t1.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
						t1.LocalPlayer.CameraMode = Enum.CameraMode.Classic
					end

					local huge = t3.Misc_InfiniteZoom and math.huge

					huge = huge or 40

					if t1.LocalPlayer.CameraMaxZoomDistance ~= huge then
						t1.LocalPlayer.CameraMaxZoomDistance = huge
					end

					if t1.LocalPlayer.CameraMinZoomDistance ~= 8 then
						t1.LocalPlayer.CameraMinZoomDistance = 8
					end

					t1.LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode[Killer_CameraMode] or Enum.DevComputerCameraMovementMode.Classic
					t1.LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode[Killer_CameraMode] or Enum.DevTouchCameraMovementMode.Classic
				end

				if v46() == "Killer" then
					v220()
				elseif getgenv().Library then
					v38("3rd Person hanya berlaku saat menjadi Killer!", 3)
				end

				t5.ThirdPersonCamConn = t1.RunService.RenderStepped:Connect(function()
					if v46() == "Killer" then
						v220()
					end
				end)
			elseif OriginalCamSettings.CameraMode then
				t1.LocalPlayer.CameraMode = OriginalCamSettings.CameraMode
				t1.LocalPlayer.CameraMinZoomDistance = OriginalCamSettings.MinZoom

				local LocalPlayer = t1.LocalPlayer
				local huge = t3.Misc_InfiniteZoom and math.huge

				LocalPlayer.CameraMaxZoomDistance = huge or OriginalCamSettings.MaxZoom
				t1.LocalPlayer.DevComputerCameraMode = OriginalCamSettings.DevComputer
				t1.LocalPlayer.DevTouchCameraMode = OriginalCamSettings.DevTouch
			else
				t1.LocalPlayer.CameraMode = Enum.CameraMode.Classic
				t1.LocalPlayer.CameraMinZoomDistance = 8
				t1.LocalPlayer.CameraMaxZoomDistance = t3.Misc_InfiniteZoom and math.huge or 128
				t1.LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.UserChoice
				t1.LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.UserChoice
			end
		end
	}):AddKeyPicker("Killer_3rdPersonKey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "3rd Person",
		NoUI = false
	})
	v187:AddDropdown("Killer_CameraModeDrop", {
		Text = "3rd Person Mode",
		Values = {
			"Classic",
			"Follow"
		},
		Default = 1,
		Multi = false,
		Callback = function(p75)
			t3.Killer_CameraMode = p75

			if t3.Killer_3rdPerson then
				t1.LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode[p75] or Enum.DevComputerCameraMovementMode.Classic
				t1.LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode[p75] or Enum.DevTouchCameraMovementMode.Classic
			end
		end
	})
	v187:AddDivider("Killer Mask")

	do
		v187:AddDropdown("Killer_MaskDropdown", {
			Text = "Ganti Topeng Masked",
			Values = {
				"Tony",
				"Rabbit",
				"Alex",
				"Brandon",
				"Cobra",
				"Richard",
				"Richter"
			},
			Default = 1,
			Multi = false,
			Callback = function(p76)
				local v225 = p76

				if v46() ~= "Killer" then
					v38("Akses Ditolak: Kamu bukan Killer!", 3)

					return
				end

				if v45() ~= "Masked" then
					v38("Akses Ditolak: Killer bukan Masked!", 3)

					return
				end

				pcall(function()
					local Remotes3 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 3)

					if not Remotes3 then
						return
					end

					local Killers = Remotes3:WaitForChild("Killers", 3)

					if not Killers then
						return
					end

					local Masked = Killers:WaitForChild("Masked", 3)

					if not Masked then
						return
					end

					local Activatepower = Masked:WaitForChild("Activatepower", 3)
					local Deactivatepower = Masked:WaitForChild("Deactivatepower", 3)

					if Activatepower and Deactivatepower then
						Activatepower:FireServer(v225)
						v38("Topeng diganti ke " .. v225, 2)

						if t5.activeMask then
							task.cancel(t5.activeMask)
							t5.activeMask = nil
						end

						t5.activeMask = task.delay(60, function()
							pcall(function()
								Deactivatepower:FireServer()
							end)
						end)
					end
				end)
			end
		})
	end

	do
		local v231 = t21.Esp:AddLeftTabbox()
		local v232 = v231:AddTab("General ESP", "settings")

		v232:AddToggle("ESP_Master", {
			Text = "Aktifkan Master ESP",
			Default = false,
			Callback = function(p77)
				t3.ESP_Master = p77

				if p77 then
					lib4.ScanMap()
				else
					lib4.ClearAllESP()
				end
			end
		})
		v232:AddSlider("ESP_MaxDistSlider", {
			Text = "ESP Distance",
			Min = 50,
			Max = 500,
			Default = 200,
			Rounding = 0,
			Callback = function(p78)
				t3.ESP_MaxDistance = p78
			end
		})
		v232:AddSlider("ESP_Transr", {
			Text = "ESP Transparency",
			Min = 0,
			Max = 10,
			Default = 7,
			Rounding = 1,
			Callback = function(p79)
				t3.Trans = p79 / 10

				if t3.ESP_Master then
					lib4.ClearAllESP()
					lib4.ScanMap()
				end
			end
		})
		v232:AddCheckbox("ESP_Outline", {
			Text = "Mode Outline",
			Default = false,
			Callback = function(p80)
				t3.ESP_Outline = p80
			end
		})

		local Info = v231:AddTab("Info", "badge-info")

		Info:AddToggle("Next_Map", {
			Text = "Show Next Map",
			Default = true,
			Callback = function(p81)
				t3.Next_Map = p81
			end
		})
		Info:AddToggle("Show_Stun", {
			Text = "Indikator stun killer",
			Default = false,
			Callback = function(p82)
				t3.Show_Stun = p82
			end
		})
		Info:AddToggle("Misc_OverlayInfo", {
			Text = "Show (FPS & Spectator)",
			Default = true,
			Callback = function(p83)
				if t12.Watermark then
					t12.Watermark.UI.Enabled = p83
				end

				if t12.Spectator then
					t12.Spectator.UI.Enabled = p83
				end
			end
		})
		Info:AddToggle("Info Perk", {
			Text = "Info Perk",
			Default = false,
			Callback = function(p84)
				if not p84 then
					if getgenv().InfoPerkCleanup then
						getgenv().InfoPerkCleanup()
					end

					getgenv().InfoPerkLoaded = false
				elseif getgenv().InfoPerkLoaded then
					if getgenv().ToggleInfoPerk then
						getgenv().ToggleInfoPerk(true)
					end
				else
					pcall(function()
						loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/perk-info"))()
					end)
				end
			end
		})
	end

	do
		local v234 = t21.Esp:AddRightTabbox()
		local v235 = v234:AddTab("Group Player", "users")

		v235:AddCheckbox("ESP_Player", {
			Text = "Survivor (Player)",
			Default = false,
			Callback = function(p85)
				t3.ESP_Player = p85

				if t3.ESP_Master then
					if p85 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Player")
					end
				end
			end
		}):AddColorPicker("Color_Player", {
			Default = t6.Colors.Player,
			Title = "Player Color",
			Callback = function(p86)
				t6.Colors.Player = p86
			end
		})
		v235:AddCheckbox("ESP_Killer", {
			Text = "Killer",
			Default = false,
			Callback = function(p87)
				t3.ESP_Killer = p87

				if t3.ESP_Master then
					if p87 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Killer")
					end
				end
			end
		}):AddColorPicker("Color_Killer", {
			Default = t6.Colors.Killer,
			Title = "Killer Color",
			Callback = function(p88)
				t6.Colors.Killer = p88
			end
		})
		v235:AddCheckbox("ESP_SCP", {
			Text = "SCP / Zombie",
			Default = false,
			Callback = function(p89)
				t3.ESP_SCP = p89

				if t3.ESP_Master then
					if p89 then
						lib4.ScanMap()
					else
						lib4.ClearESP("SCP")
					end
				end
			end
		}):AddColorPicker("Color_SCP", {
			Default = t6.Colors.SCP,
			Title = "SCP Color",
			Callback = function(p90)
				t6.Colors.SCP = p90
			end
		})
		v235:AddDivider("Detail Player")
		v235:AddCheckbox("ESP_Name", {
			Text = "Nama Player",
			Default = false,
			Callback = function(p91)
				t3.ESP_Name = p91

				if p91 then
					lib4.ScanMap()
				else
					lib4.ClearAllESP()
				end
			end
		})
		v235:AddCheckbox("ESP_ItemIcon", {
			Text = "Icon Item Held",
			Default = false,
			Callback = function(p92)
				t3.ESP_ItemIcon = p92

				if not p92 then
					lib4.ClearESP("Item")
				end
			end
		})
		v235:AddCheckbox("ESP_KillerWarn", {
			Text = "Peringatan Killer (!)",
			Default = false,
			Callback = function(p93)
				t3.ESP_KillerWarn = p93
			end
		})
		v235:AddCheckbox("Hitbox", {
			Text = "Hitbox Range Killer",
			Default = false,
			Callback = function(p94)
				t3.ESP_Hitbox = p94

				if p94 then
					lib4.UpdateKillerCone()
				else
					lib4.ClearKillerCone()
				end
			end
		})
		v235:AddCheckbox("faceline", {
			Text = "Face Line Killer",
			Default = false,
			Callback = function(p95)
				t3.ESP_FaceLine = p95

				if p95 then
					lib4.UpdateKillerFaceLine()
				else
					lib4.ClearKillerFaceLine()
				end
			end
		})

		local v236 = v234:AddTab("Group Objek", "box")

		v236:AddCheckbox("ESP_Generator", {
			Text = "Generator",
			Default = false,
			Callback = function(p96)
				t3.ESP_Generator = p96

				if t3.ESP_Master then
					if p96 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Generator")
					end
				end
			end
		}):AddColorPicker("Color_Generator", {
			Default = t6.Colors.Generator,
			Title = "Generator Color",
			Callback = function(p97)
				t6.Colors.Color_Generator = p97
			end
		})
		v236:AddCheckbox("ESP_NameG", {
			Text = "Progress & Nama Generator",
			Default = false,
			Callback = function(p98)
				t3.ESP_NameG = p98

				if p98 then
					lib4.ScanMap()
				else
					lib4.ClearAllESP()
				end
			end
		})
		v236:AddCheckbox("ESP_Pallet", {
			Text = "Pallet",
			Default = false,
			Callback = function(p99)
				t3.ESP_Pallet = p99

				if t3.ESP_Master then
					if p99 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Pallet")
					end
				end
			end
		}):AddColorPicker("Color_Pallet", {
			Default = t6.Colors.Pallet,
			Title = "Pallet Color",
			Callback = function(p100)
				t6.Colors.Pallet = p100
			end
		})
		v236:AddCheckbox("ESP_Window", {
			Text = "Window / Vault",
			Default = false,
			Callback = function(p101)
				t3.ESP_Window = p101

				if t3.ESP_Master then
					if p101 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Window")
					end
				end
			end
		}):AddColorPicker("Color_Window", {
			Default = t6.Colors.Window,
			Title = "Window Color",
			Callback = function(p102)
				t6.Colors.Window = p102
			end
		})
		v236:AddCheckbox("ESP_Hook", {
			Text = "Hook",
			Default = false,
			Callback = function(p103)
				t3.ESP_Hook = p103

				if t3.ESP_Master then
					if p103 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Hook")
					end
				end
			end
		}):AddColorPicker("Color_Hook", {
			Default = t6.Colors.Hook,
			Title = "Hook Color",
			Callback = function(p104)
				t6.Colors.Hook = p104
			end
		})
		v236:AddCheckbox("ESP_Gate", {
			Text = "Exit Gate",
			Default = false,
			Callback = function(p105)
				t3.ESP_Gate = p105

				if t3.ESP_Master then
					if p105 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Gate")
					end
				end
			end
		}):AddColorPicker("Color_Gate", {
			Default = t6.Colors.Gate,
			Title = "Gate Color",
			Callback = function(p106)
				t6.Colors.Gate = p106
			end
		})
		v236:AddCheckbox("ESP_Trap", {
			Text = "Trap (BearTrap)",
			Default = false,
			Callback = function(p107)
				t3.ESP_Trap = p107

				if t3.ESP_Master then
					if p107 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Trap")
					end
				end
			end
		}):AddColorPicker("Color_Trap", {
			Default = t6.Colors.Trap,
			Title = "Trap Color",
			Callback = function(p108)
				t6.Colors.Trap = p108
			end
		})
		v236:AddCheckbox("ESP_Pumpkin", {
			Text = "Pumpkin",
			Default = false,
			Callback = function(p109)
				t3.ESP_Pumpkin = p109

				if t3.ESP_Master then
					if p109 then
						lib4.ScanMap()
					else
						lib4.ClearESP("Pumpkin")
					end
				end
			end
		}):AddColorPicker("Color_Pumpkin", {
			Default = t6.Colors.Pumpkin or Color3.fromRGB(255, 140, 0),
			Title = "Pumpkin Color",
			Callback = function(p110)
				t6.Colors.Pumpkin = p110
			end
		})
	end

	local v237 = t21.Aim:AddRightTabbox()
	local Aimbot = v237:AddTab("Aimbot")
	local v239 = v237:AddTab("Aim ToF")
	local v240 = v237:AddTab("Silent Aim")

	v239:AddDivider("Target Settings")
	v239:AddDropdown("Pistol_Target_Drop", {
		Text = "Pistol Target",
		Values = {
			"Killer",
			"Survivor",
			"SCP"
		},
		Default = 1,
		Multi = false,
		Callback = function(p111)
			t3.Pistol_Target = p111

			if t12.TargetUI and t12.TargetUI.UpdateVisuals then
				t12.TargetUI.UpdateVisuals(p111)
			end

			for i, v in ipairs(t14) do
				if v == p111 then
					n1 = i

					break
				end
			end
		end
	})
	v239:AddDropdown("AIM_TargetPart_Drop", {
		Text = "Target Part",
		Values = {
			"Head",
			"Torso",
			"Root"
		},
		Default = 2,
		Multi = false,
		Callback = function(p112)
			t3.AIM_TargetPart = p112
		end
	})
	v239:AddToggle("Pistol_TargetShortcutUI", {
		Text = "Show Mobile Target Shortcut",
		Default = false,
		Callback = function(p113)
			if t12.TargetUI then
				if t12.TargetUI.UI then
					t12.TargetUI.UI.Enabled = p113
				end
			end
		end
	}):AddKeyPicker("Pistol_CycleTargetTypeKey", {
		Default = "T",
		SyncToggleState = false,
		Mode = "Toggle",
		Text = "Cycle Target Type",
		NoUI = false,
		Callback = function()
			v72()
		end
	})
	v239:AddDivider("TOF V1")
	v239:AddToggle("Aim_Silent", {
		Text = "Pistol V1",
		Default = false,
		Callback = function(p114)
			t3.Aim_Silent = p114
		end
	}):AddColorPicker("Pistol_LaserColor", {
		Default = Color3.fromRGB(57, 255, 20),
		Title = "Pistol Laser Color",
		Callback = function(p115)
			if Part then
				Part.Color = p115
			end
		end
	}):AddKeyPicker("KeyPicker_SilentPistol", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Pistol"
	})
	v239:AddCheckbox("Pistol_ShowLaser", {
		Text = "Show Laser",
		Default = true,
		Callback = function(p116)
			t3.Pistol_ShowLaser = p116

			if not p116 then
				if Part and Part.Parent ~= nil then
					Part.Parent = nil
				end
			end
		end
	})
	v239:AddCheckbox("Aim_Lock", {
		Text = "Aim Lock",
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Default = false,
		Callback = function(p117)
			t3.Aim_Lock = p117
		end
	})
	v239:AddToggle("Aim_Pre", {
		Text = "Auto Prediksi",
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Content = "Predict",
		Switch = true,
		Callback = function(p118)
			t3.Predict = p118
		end
	}):AddKeyPicker("KeyPicker_AimPre", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Auto Prediksi"
	})
	v239:AddSlider("Pistol_PredictLead", {
		Text = "Prediction Lead",
		Tooltip = "Jarak prediksi",
		Min = 1,
		Max = 20,
		Default = 5,
		Rounding = 0,
		Callback = function(p119)
			t3.Pistol_PredictLead = p119 / 10
		end
	})
	v239:AddSlider("Pistol_AimOffsetSlider", {
		Text = "Aim Offset",
		Min = -2,
		Max = 0,
		Default = t3.Pistol_AimOffset,
		Rounding = 1,
		Callback = function(p120)
			t3.Pistol_AimOffset = p120
		end
	})
	v239:AddDivider("TOF V2")
	v239:AddToggle("Aim_PistolV2", {
		Text = "Pistol V2",
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p121)
			t3.PistolV2_Enabled = p121
			lib6.EnablePistolV2Listeners(p121)
		end
	}):AddKeyPicker("KeyPicker_PistolV2", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Pistol V2"
	})
	v239:AddCheckbox("PistolV2_ShowLaser", {
		Text = "Show Laser",
		Default = false,
		Callback = function(p122)
			t3.PistolV2_ShowLaser = p122

			if not p122 then
				lib6.ClearPistolV2Laser()
			end
		end
	})
	v239:AddSlider("PistolV2_PredictStrength", {
		Text = "Predict Strength",
		Min = 5,
		Max = 30,
		Default = 15,
		Rounding = 1,
		Callback = function(p123)
			t3.PistolV2_PredictStrength = p123 / 10
		end
	})
	v239:AddSlider("PistolV2_VelSmoothing", {
		Text = "Velocity",
		Min = 0,
		Max = 10,
		Default = 4,
		Rounding = 1,
		Callback = function(p124)
			t3.PistolV2_VelSmoothing = p124 / 10
		end
	})
	v239:AddDivider("FOV Settings")
	v239:AddCheckbox("Pistol_FOVMode", {
		Text = "FOV Mode",
		Default = false,
		Callback = function(p125)
			t3.Pistol_FOVMode = p125
		end
	})
	v239:AddCheckbox("Pistol_ShowFOV", {
		Text = "Show FOV",
		Default = false,
		Callback = function(p126)
			t3.Pistol_ShowFOV = p126
		end
	})
	v239:AddSlider("Pistol_FOVSlider", {
		Text = "FOV Radius",
		Min = 50,
		Max = 200,
		Default = 80,
		Rounding = 0,
		Callback = function(p127)
			t3.Pistol_FOV = p127
		end
	})
	v239:AddDivider("Sound Settings")
	v239:AddToggle("Pistol_CustomSoundToggle", {
		Text = "Sound TOF",
		Default = false,
		Tooltip = "Mengubah suara tembakan Pistol",
		Callback = function(p128)
			t3.Pistol_CustomSound = p128

			if t1.LocalPlayer.Character then
				v91(t1.LocalPlayer.Character)
			end
		end
	})
	v239:AddDropdown("Pistol_SoundDropdown", {
		Text = "Pilih Sound",
		Values = {
			"Sound 1",
			"Sound 2",
			"Sound 3",
			"Sound 4"
		},
		Default = 1,
		Multi = false,
		Callback = function(p129)
			t3.Pistol_SelectedSound = p129

			if t3.Pistol_CustomSound and t1.LocalPlayer.Character then
				v91(t1.LocalPlayer.Character)
			end
		end
	})

	do
		v240:AddToggle("AutoDashLockToggle", {
			Text = "Auto Aim (Hidden)",
			Content = "Auto aim",
			Switch = true,
			Default = false,
			Tooltip = "Auto lock aim hidden",
			Callback = function(p130)
				v35.AutoLock(p130)
			end
		})
	end

	v240:AddToggle("Butcher_AimToggle", {
		Text = "Butcher",
		Default = false,
		Tooltip = "Silent aim chain",
		Callback = function(p131)
			t3.Butcher_Aim = p131
		end
	}):AddKeyPicker("Butcher_AimKey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Butcher Aim",
		NoUI = false
	})
	v240:AddSlider("leadButcbher", {
		Text = "Lead predict",
		Tooltip = "Mengatur jarak ekstra prediksi",
		Min = 10,
		Max = 20,
		Default = 12,
		Rounding = 0,
		Callback = function(p132)
			t3.leadButcher = p132 / 10
		end
	})
	v240:AddDivider()
	v240:AddToggle("Aim_SilentVeil", {
		Text = "Veil",
		Default = false,
		Disabled = not u14,
		DisabledTooltip = "Fitur VIP (Locked)",
		Callback = function(p133)
			if p133 then
				if v46() ~= "Killer" then
					v38("Akses Ditolak: Kamu bukan Killer!", 3)
					task.defer(function()
						Toggles.Aim_SilentVeil:SetValue(false)
					end)

					return
				end

				if v45() ~= "Veil" then
					v38("Akses Ditolak: Killer bukan Veil!", 3)
					task.defer(function()
						Toggles.Aim_SilentVeil:SetValue(false)
					end)

					return
				end
			end

			t3.Aim_SilentVeil = p133
		end
	}):AddKeyPicker("KeyPicker_SilentVeil", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Veil"
	})
	v240:AddCheckbox("SmartPredict_Toggle", {
		Text = "Smart Predict Mode",
		Default = false,
		Callback = function(p134)
			t3.SmartPredict = p134
		end
	})

	do
		v240:AddSlider("Veil_LeadMultiplierSlider", {
			Text = "Smart Predict Lead",
			Tooltip = "Mengatur jarak ekstra prediksi",
			Min = 10,
			Max = 20,
			Default = 17,
			Rounding = 0,
			Callback = function(p135)
				t3.Veil_LeadMultiplier = p135 / 10
			end
		})
	end

	v240:AddCheckbox("Veil_ShowFOV", {
		Text = "Show FOV",
		Default = true,
		Callback = function(p136)
			t3.Veil_ShowFOV = p136
		end
	})

	do
		v240:AddCheckbox("Veil_ShowLaser", {
			Text = "Snapline",
			Default = true,
			Callback = function(p137)
				t3.Veil_ShowLaser = p137
			end
		})
	end

	do
		v240:AddSlider("Veil_FOVSlider", {
			Text = "FOV Radius",
			Min = 50,
			Max = 200,
			Default = 80,
			Rounding = 0,
			Callback = function(p138)
				t3.Veil_FOV = p138
			end
		})
	end

	do
		v240:AddSlider("Vei_Distance", {
			Text = "Distance",
			Min = 50,
			Max = 500,
			Default = 200,
			Rounding = 0,
			Callback = function(p139)
				t3.SPEAR_MaxDist = p139
			end
		})
	end

	v240:AddSlider("Veil_SpearSpeed", {
		Text = "Spear Speed",
		Min = 50,
		Max = 200,
		Default = 165,
		Rounding = 0,
		Callback = function(p140)
			t3.SPEAR_Speed = p140
		end
	})

	do
		v240:AddSlider("Veil_SpearGravity", {
			Text = "Spear Gravity",
			Min = 0,
			Max = 200,
			Default = 103,
			Rounding = 0,
			Callback = function(p141)
				t3.SPEAR_Gravity = p141
			end
		})
	end

	Aimbot:AddToggle("Aimbot_Enabled", {
		Text = "Aimbot",
		Default = false,
		Callback = function(p142)
			t3.Aimbot_Enabled = p142
		end
	})
	Aimbot:AddCheckbox("Aimbot_ShowFOV", {
		Text = "Show FOV Circle",
		Default = true,
		Callback = function(p143)
			t3.Aimbot_ShowFOV = p143
		end
	})
	Aimbot:AddSlider("Aimbot_Radius", {
		Text = "FOV Circle Radius",
		Min = 50,
		Max = 500,
		Default = 150,
		Rounding = 0,
		Callback = function(p144)
			t3.Aimbot_Radius = p144
		end
	})
	Aimbot:AddSlider("Aimbot_MaxDist", {
		Text = "Max Distance",
		Min = 50,
		Max = 1000,
		Default = 300,
		Rounding = 0,
		Callback = function(p145)
			t3.Aimbot_MaxDist = p145
		end
	})
	Aimbot:AddSlider("Aimbot_Smoothness", {
		Text = "Aimbot Smoothness",
		Min = 1,
		Max = 10,
		Default = 5,
		Rounding = 1,
		Callback = function(p146)
			t3.Aimbot_Smoothness = p146 / 10
		end
	})
	Aimbot:AddInput("Aimbot_Predict", {
		Text = "Predict Aim Offset",
		Default = "",
		Numeric = true,
		Placeholder = "misal: 0.05",
		Callback = function(p147)
			local aimbotPredict = tonumber(p147)

			if aimbotPredict then
				t3.Aimbot_Predict = aimbotPredict
			end
		end
	})
	Aimbot:AddDivider("aim flash")

	do
		Aimbot:AddToggle("FlashAim", {
			Text = "Aim (flash)",
			Default = false,
			Callback = function(p148)
				t3.Flash_Silent = p148
			end
		}):AddKeyPicker("SilentFlashKey", {
			Default = "None",
			Text = "Silent Aim Key",
			Mode = "Toggle",
			Callback = function(p149)
				t3.Flash_Silent = p149
			end
		})
	end

	Aimbot:AddSlider("FlashAimOffset", {
		Text = "Aim Offset (Y)",
		Tooltip = "Atur posisi bidikan (0 = Badan, 1.5 = Kepala, 8 = Atas Kepala)",
		Default = 2,
		Min = 1,
		Max = 10,
		Rounding = 1,
		Callback = function(p150)
			t3.Flash_YOffset = p150
		end
	})

	do
		local v244 = t21.Aim:AddLeftGroupbox("Custom Crosshair", "crosshair")

		v244:AddToggle("Crosshair_Enabled", {
			Text = "Crosshair",
			Default = false,
			Callback = function(p151)
				t3.Crosshair_Enabled = p151
				v78()
			end
		}):AddColorPicker("Crosshair_Color", {
			Default = Color3.fromRGB(57, 255, 20),
			Title = "Crosshair Color",
			Callback = function(p152)
				t3.Crosshair_Color = p152
				v78()
			end
		})
		v244:AddDropdown("Crosshair_Type", {
			Text = "Crosshair Style",
			Values = {
				"Dot",
				"Cross",
				"Circle"
			},
			Default = 2,
			Multi = false,
			Callback = function(p153)
				t3.Crosshair_Type = p153
				v78()
			end
		})
		v244:AddSlider("Crosshair_Size", {
			Text = "Crosshair Size",
			Min = 2,
			Max = 30,
			Default = 4,
			Rounding = 0,
			Callback = function(p154)
				t3.Crosshair_Size = p154
				v78()
			end
		})
	end

	do
		local v245 = t21.Aim:AddLeftGroupbox("Crosshair Position", "move")

		v245:AddInput("CrossX", {
			Text = "Posisi X",
			Default = "",
			Placeholder = "misal: 50",
			Callback = function(p155)
				local crosshairOffsetX = tonumber(p155)

				if crosshairOffsetX then
					t3.Crosshair_OffsetX = crosshairOffsetX
					v78()
				end
			end
		})
		v245:AddInput("CrossY", {
			Text = "Posisi Y",
			Default = "",
			Placeholder = "misal: 50",
			Callback = function(p156)
				local crosshairOffsetY = tonumber(p156)

				if crosshairOffsetY then
					t3.Crosshair_OffsetY = crosshairOffsetY
					v78()
				end
			end
		})
		v245:AddButton({
			Text = "Reset Posisi",
			Func = function()
				t3.Crosshair_OffsetX = 0
				t3.Crosshair_OffsetY = 0
				pcall(function()
					Options_.CrossX:SetValue("0")
				end)
				pcall(function()
					Options_.CrossY:SetValue("0")
				end)
				v78()
			end
		})
	end

	do
		local Screen = t21.Misc:AddLeftGroupbox("Screen", "camera")

		getgenv().Resolution = {
			reso = 0.65
		}
		Screen:AddDivider("Camera")
		Screen:AddToggle("Misc_SmoothCamToggle", {
			Text = "Camera DBD",
			Default = false,
			Tooltip = "Smoothies camera",
			Callback = function(p157)
				t3.Misc_SmoothCam = p157
				v79()
			end
		})
		Screen:AddSlider("Misc_CamHeightSlider", {
			Text = "Camera Height",
			Min = -10,
			Max = 10,
			Default = -1,
			Rounding = 1,
			Callback = function(p158)
				t3.Misc_CamHeight = p158

				if t3.Misc_SmoothCam then
					v79()
				end
			end
		})
		Screen:AddSlider("Misc_CamStiffnessSlider", {
			Text = "Camera Stiffness",
			Min = 1,
			Max = 30,
			Default = 1,
			Rounding = 1,
			Callback = function(p159)
				t3.Misc_CamStiffness = p159

				if t3.Misc_SmoothCam then
					v79()
				end
			end
		})
		Screen:AddDivider("Screen")
		Screen:AddToggle("Res_Toggle", {
			Text = "Custom Resolution",
			Default = false,
			Callback = function(p160)
				if not p160 then
					if getgenv().resolusi then
						getgenv().resolusi:Disconnect()
						getgenv().resolusi = nil
					end
				elseif not getgenv().resolusi then
					getgenv().resolusi = game:GetService("RunService").RenderStepped:Connect(function()
						t1.Camera.CFrame *= CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution.reso, 0, 0, 0, 1)
					end)
				end
			end
		})
		Screen:AddSlider("Res_Slider", {
			Text = "Resolution Scale",
			Default = 0.65,
			Min = 0.1,
			Max = 2,
			Rounding = 2,
			Callback = function(p161)
				getgenv().Resolution.reso = p161
			end
		})
	end

	do
		local v249 = t21.Misc:AddRightGroupbox("Spoofer Profile", "circle-user-round")

		v249:AddToggle("Misc_FakeName", {
			Text = "Fake Name",
			Default = false,
			Callback = function(p162)
				t3.Misc_FakeName = p162

				if p162 then
					v37.EnableSpoofer()
				else
					v37.DisableSpoofer()
				end
			end
		})
		v249:AddDivider("profile menu")
		v249:AddToggle("Misc_FakeAttributesToggle", {
			Text = "Fake Profile",
			Default = false,
			Callback = function(p163)
				t3.Misc_FakeAttributes = p163

				if p163 then
					if Options_.Misc_LevelInput then
						t1.LocalPlayer:SetAttribute("Level", tonumber(Options_.Misc_LevelInput.Value) or t4.Level)
					end

					if Options_.Misc_GearsInput then
						t1.LocalPlayer:SetAttribute("Gears", tonumber(Options_.Misc_GearsInput.Value) or t4.Gears)
					end

					if Options_.Misc_ScrewsInput then
						t1.LocalPlayer:SetAttribute("Screws", tonumber(Options_.Misc_ScrewsInput.Value) or t4.Screws)
					end
				else
					t1.LocalPlayer:SetAttribute("Level", t4.Level)
					t1.LocalPlayer:SetAttribute("Gears", t4.Gears)
					t1.LocalPlayer:SetAttribute("Screws", t4.Screws)
				end
			end
		})
		v249:AddInput("Misc_LevelInput", {
			Default = tostring(t4.Level),
			Numeric = true,
			Finished = true,
			Text = "Set Level",
			Tooltip = "Ubah jumlah Level",
			Placeholder = "Masukkan angka Level...",
			Callback = function(p164)
				local v250 = tonumber(p164)

				if v250 then
					if t3.Misc_FakeAttributes then
						t1.LocalPlayer:SetAttribute("Level", v250)
					end
				end
			end
		})
		v249:AddInput("Misc_GearsInput", {
			Default = tostring(t4.Gears),
			Numeric = true,
			Finished = true,
			Text = "Set Gears",
			Tooltip = "Ubah jumlah Gears",
			Placeholder = "Masukkan angka Gears...",
			Callback = function(p165)
				local v251 = tonumber(p165)

				if v251 and t3.Misc_FakeAttributes then
					t1.LocalPlayer:SetAttribute("Gears", v251)
				end
			end
		})
		v249:AddInput("Misc_ScrewsInput", {
			Default = tostring(t4.Screws),
			Numeric = true,
			Finished = true,
			Text = "Set Screws",
			Tooltip = "Ubah jumlah Screws",
			Placeholder = "Masukkan angka Screws...",
			Callback = function(p166)
				local v252 = tonumber(p166)

				if v252 and t3.Misc_FakeAttributes then
					t1.LocalPlayer:SetAttribute("Screws", v252)
				end
			end
		})
	end

	do
		local v253 = t21.Misc:AddRightGroupbox("GUI Mob", "layout-grid")

		v253:AddDivider("Invisible FE")
		v253:AddToggle("Misc_Invisible", {
			Text = "Invisible GUI",
			Default = false,
			Content = "Invisible",
			Tooltip = "Invisible FE, keybind T",
			Switch = true,
			Disabled = not u14,
			DisabledTooltip = "Fitur VIP (Locked)",
			Callback = function(p167)
				t3.Misc_Invisible = p167

				if type(getgenv().ToggleInvisible) == "function" then
					pcall(function()
						getgenv().ToggleInvisible(p167)
					end)
				elseif p167 then
					pcall(function()
						loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/invis"))()
					end)
				end
			end
		})
		v253:AddToggle("Misc_Invisible", {
			Text = "Fake clone",
			Default = false,
			Content = "Fake clone",
			Tooltip = "Fake clone",
			Switch = true,
			Callback = function(p168)
				t3.Misc_InvisibleC = p168

				if type(getgenv().TixoInvisToggle) == "function" then
					pcall(function()
						getgenv().TixoInvisToggle(p168)
					end)
				elseif p168 then
					pcall(function()
						loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/invisC"))()
						task.spawn(function()
							task.wait(0.3)

							if type(getgenv().TixoInvisToggle) == "function" then
								getgenv().TixoInvisToggle(p168)
							end
						end)
					end)
				end
			end
		}):AddKeyPicker("invisC", {
			Default = "None",
			SyncToggleState = true,
			Mode = "Toggle",
			Text = "Fake clone",
			NoUI = false
		})
		v253:AddSlider("Misc_InvisOffset", {
			Text = "Invis Offset",
			Default = -4,
			Min = -15,
			Max = 15,
			Rounding = 1,
			Callback = function(p169)
				t3.Misc_InvisOffset = p169
				getgenv().TixoInvisOffset = p169
			end
		})
		v253:AddToggle("Misc_FakeLag", {
			Text = "Fake Lag",
			Default = false,
			Content = "Fake lag",
			Tooltip = "Aktifkan Fake Lag saat berjalan",
			Switch = true,
			Callback = function(p170)
				t3.Misc_FakeLag = p170

				if type(getgenv().ToggleFakeLag) == "function" then
					pcall(function()
						getgenv().ToggleFakeLag(p170)
					end)
				elseif p170 then
					pcall(function()
						loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/fakelag"))()
						task.spawn(function()
							task.wait(0.3)

							if type(getgenv().ToggleFakeLag) == "function" then
								getgenv().ToggleFakeLag(p170)
							end
						end)
					end)
				end
			end
		}):AddKeyPicker("fakelag", {
			Default = "None",
			SyncToggleState = true,
			Mode = "Toggle",
			Text = "Fake lag",
			NoUI = false
		})
		v253:AddSlider("Misc_FakeLagMS", {
			Text = "Interval ping (MS)",
			Default = 300,
			Min = 50,
			Max = 1000,
			Rounding = 0,
			Callback = function(p171)
				getgenv().FakeLagMS = p171
			end
		})
		v253:AddDivider("Misc")
		v253:AddToggle("Misc_InfiniteZoom", {
			Text = "Infinite Zoom",
			Default = false,
			Tooltip = "Bebas zoom-out kamera sejauh mungkin",
			Callback = function(p172)
				t3.Misc_InfiniteZoom = p172

				if t5.InfiniteZoomConn then
					t5.InfiniteZoomConn:Disconnect()
					t5.InfiniteZoomConn = nil
				else
				end

				if p172 then
					t1.LocalPlayer.CameraMaxZoomDistance = math.huge
					t5.InfiniteZoomConn = t1.LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
						if t1.LocalPlayer.CameraMaxZoomDistance ~= math.huge then
							t1.LocalPlayer.CameraMaxZoomDistance = math.huge
						end
					end)
				else
					t1.LocalPlayer.CameraMaxZoomDistance = OriginalCamSettings.MaxZoom or 70
				end
			end
		})
		v253:AddToggle("Misc_CopyAvatar", {
			Text = "Copy Avatar",
			Default = false,
			Disabled = not u14,
			DisabledTooltip = "Fitur VIP (Locked)",
			Callback = function(p173)
				t3.Misc_CopyAvatar = p173

				if p173 then
					pcall(function()
						loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/copyava"))()
					end)
				elseif getgenv().RemoveCopyAvatar then
					pcall(getgenv().RemoveCopyAvatar)
				end
			end
		})
		v253:AddToggle("Misc_Moonwalk", {
			Text = "Moonwalk GUI",
			Content = "Moonwalk",
			Switch = true,
			Tooltip = "Keybind PC G",
			Default = false,
			Callback = function(p174)
				if type(getgenv().ToggleMoonwalk) == "function" then
					pcall(function()
						getgenv().ToggleMoonwalk(p174)
					end)
				elseif p174 then
					pcall(function()
						loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/MoonWalk"))()
					end)
				end
			end
		})
		v253:AddToggle("Misc_Emote", {
			Text = "Emote GUI",
			Tooltip = "Buka Emote Menu",
			Default = false,
			Callback = function(p175)
				if p175 then
					pcall(function()
						pcall(function()
							loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/emote"))()
						end)
					end)
				elseif getgenv().StopEmoteGUI then
					pcall(getgenv().StopEmoteGUI)
				end
			end
		})

		local Movement = t21.Misc:AddLeftGroupbox("Movement", "sport-shoe")

		Movement:AddToggle("Misc_Noclip", {
			Text = "Noclip",
			Default = false,
			Content = "No clip",
			Switch = true,
			Callback = function(p176)
				t3.Misc_Noclip = p176
			end
		})
		Movement:AddSlider("Misc_FlySpeed", {
			Text = "Fly Speed",
			Min = 10,
			Max = 500,
			Default = 10,
			Rounding = 0,
			Callback = function(p177)
				t3.Misc_FlySpeed = p177
			end
		})
		Movement:AddToggle("Misc_FlyToggle", {
			Text = "Fly Mode",
			Default = false,
			Callback = function(p178)
				t3.Misc_FlyToggle = p178

				local Character = t1.LocalPlayer.Character
				local Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")

				if not Character or not Humanoid2 or not HumanoidRootPart2 then
					return
				end

				if t3.Misc_FlyToggle then
					if Character:FindFirstChild("Animate") then
						Character.Animate.Disabled = true
					end

					for _, v in pairs(Humanoid2:GetPlayingAnimationTracks()) do
						v:Stop()
					end

					Humanoid2:ChangeState(Enum.HumanoidStateType.Swimming)
					Humanoid2.AutoRotate = false

					local BodyVelocity = Instance.new("BodyVelocity", HumanoidRootPart2)

					BodyVelocity.Name = "FlyStable"
					BodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
					BodyVelocity.Velocity = Vector3.new(0, 0, 0)

					local BodyGyro = Instance.new("BodyGyro", HumanoidRootPart2)

					BodyGyro.Name = "FlyGyro"
					BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
					BodyGyro.P = 90000
					BodyGyro.CFrame = t1.Camera.CFrame

					if t5.FlyConnection then
						t5.FlyConnection:Disconnect()
					end

					t5.FlyConnection = t1.RunService.Heartbeat:Connect(function()
						if Character and HumanoidRootPart2 then
							if Humanoid2 then
								t1.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
								BodyGyro.CFrame = t1.Camera.CFrame

								if Humanoid2.MoveDirection.Magnitude > 0 then
									local MoveDirection = Humanoid2.MoveDirection
									local LookVector = t1.Camera.CFrame.LookVector
									local n4 = 0

									if t1.UserInputService:IsKeyDown(Enum.KeyCode.W) or MoveDirection:Dot(t1.Camera.CFrame.LookVector) > 0.5 then
										n4 = LookVector.Y
									elseif t1.UserInputService:IsKeyDown(Enum.KeyCode.S) or MoveDirection:Dot(t1.Camera.CFrame.LookVector) < -0.5 then
										n4 = -LookVector.Y
									end

									Character:TranslateBy(Vector3.new(MoveDirection.X, n4, MoveDirection.Z) * (t3.Misc_FlySpeed / 10))
								end

								return
							end
						end
					end)
				else
					if t5.FlyConnection then
						t5.FlyConnection:Disconnect()
					end

					if HumanoidRootPart2:FindFirstChild("FlyStable") then
						HumanoidRootPart2.FlyStable:Destroy()
					end

					if HumanoidRootPart2:FindFirstChild("FlyGyro") then
						HumanoidRootPart2.FlyGyro:Destroy()
					end

					if Character:FindFirstChild("Animate") then
						Character.Animate.Disabled = false
					end

					Humanoid2.AutoRotate = true
					Humanoid2:ChangeState(Enum.HumanoidStateType.Running)
					t1.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				end
			end
		})

		local v265 = t21.Misc:AddRightGroupbox("Jump Mod", "arrow-big-up-dash")

		v265:AddToggle("Misc_HighJump", {
			Text = "High Jump",
			Default = false,
			Callback = function(p179)
				t3.Misc_HighJump = p179

				if not p179 and t1.LocalPlayer.Character then
					local Humanoid2 = t1.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

					if Humanoid2 then
						Humanoid2.UseJumpPower = false
					end
				end
			end
		})
		v265:AddSlider("Misc_JumpPower", {
			Text = "Jump Power",
			Min = 50,
			Max = 300,
			Default = 50,
			Rounding = 0,
			Callback = function(p180)
				t3.Misc_JumpPower = p180
			end
		})
		v265:AddCheckbox("Misc_InfJump", {
			Text = "Infinite Jump",
			Default = false,
			Callback = function(p181)
				t3.Misc_InfJump = p181
			end
		})

		local v267 = t21.Misc:AddLeftGroupbox("Visual Enhancements", "scan-eye")

		v267:AddToggle("Misc_SkipCutsceneToggle", {
			Text = "Skip Cutscene",
			Default = false,
			Tooltip = "Skip endscreen.",
			Callback = function(p182)
				v65(p182)
			end
		})
		v267:AddCheckbox("Misc_Fullbright", {
			Text = "Fullbright",
			Default = false,
			Callback = function(p183)
				t3.Misc_Fullbright = p183

				if p183 then
					if not t5.OriginalLighting then
						local Atmosphere2 = t1.Lighting:FindFirstChildOfClass("Atmosphere")

						t5.OriginalLighting = {
							Brightness = t1.Lighting.Brightness,
							FogEnd = t1.Lighting.FogEnd,
							GlobalShadows = t1.Lighting.GlobalShadows,
							OutdoorAmbient = t1.Lighting.OutdoorAmbient,
							Ambient = t1.Lighting.Ambient,
							AtmosphereDensity = Atmosphere2 and Atmosphere2.Density or 0.3
						}
					end

					lib4.ApplyFullbright()
					lib4.EnableFullbrightEvents()
				else
					lib4.DisableFullbrightEvents()

					if t5.OriginalLighting then
						t1.Lighting.Brightness = t5.OriginalLighting.Brightness
						t1.Lighting.FogEnd = t5.OriginalLighting.FogEnd
						t1.Lighting.GlobalShadows = t5.OriginalLighting.GlobalShadows
						t1.Lighting.OutdoorAmbient = t5.OriginalLighting.OutdoorAmbient
						t1.Lighting.Ambient = t5.OriginalLighting.Ambient

						local Atmosphere2 = t1.Lighting:FindFirstChildOfClass("Atmosphere")

						if Atmosphere2 and t5.OriginalLighting.AtmosphereDensity then
							Atmosphere2.Density = t5.OriginalLighting.AtmosphereDensity
						end
					end
				end
			end
		})
		v267:AddSlider("Fullbright_Time", {
			Text = "Fullbright Time",
			Min = 0,
			Max = 24,
			Default = 14,
			Rounding = 1,
			Callback = function(p184)
				if t3.Misc_Fullbright then
					t1.Lighting.ClockTime = p184
				end
			end
		})

		local Graphics = t21.Misc:AddRightGroupbox("Graphics", "contrast")

		Graphics:AddToggle("Misc_SmoothHDR", {
			Text = "Smooth HDR Graphics",
			Default = false,
			Callback = function(p185)
				t3.Misc_SmoothHDR = p185
				lib4.SmoothHdr(p185)
			end
		})

		local function v271()
			if not setfpscap then
				v38("Executor kamu tidak mensupport fitur setfpscap!", 3)
			elseif Toggles.Misc_FPSUnlockToggle.Value then
				local Value = Options_.Misc_FPSDropdown.Value

				if Value == "Max" then
					setfpscap(9999)
					pcall(function()
						setfflag("TaskSchedulerTargetFps", tonumber(Value))
					end)
				else
					setfpscap(tonumber(Value))
					pcall(function()
						setfflag("TaskSchedulerTargetFps", tonumber(Value))
					end)
				end
			else
				setfpscap(60)
			end
		end

		Graphics:AddToggle("Misc_FPSUnlockToggle", {
			Text = "Unlock FPS",
			Default = false,
			Callback = function()
				v271()
			end
		})
		Graphics:AddDropdown("Misc_FPSDropdown", {
			Text = "Target FPS",
			Values = {
				"60",
				"90",
				"120",
				"Max"
			},
			Default = 3,
			Multi = false,
			Callback = function()
				if Toggles.Misc_FPSUnlockToggle.Value then
					v271()
				end
			end
		})

		local Tools = t21.Misc:AddLeftGroupbox("Tools", "swords")
		local connection

		Tools:AddButton({
			Text = "Tools Jerk",
			Func = function()
				pcall(function()
					loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
					v38("Fitur Jerk berhasil dimuat!", 3)
				end)
			end
		})
		v253:AddToggle("Misc_Ring", {
			Text = "Super Fling",
			Tooltip = "Fling semua player server (1x pakai di 1 server)",
			Default = false,
			Disabled = not u14,
			DisabledTooltip = "Fitur VIP (Locked)",
			Callback = function(p186)
				if p186 then
					pcall(function()
						pcall(function()
							loadstring(game:HttpGet(t9.SCRIPT .. "/Misc/fling"))()
						end)
					end)
				elseif getgenv().StopSuperRing then
					pcall(getgenv().StopSuperRing)
				end
			end
		})
		Tools:AddToggle("Misc_AuraFling", {
			Text = "Fling",
			Default = false,
			Callback = function(p187)
				if p187 then
					if connection then
						connection:Disconnect()
					end

					connection = t1.RunService.PostSimulation:Connect(function()
						local Character = t1.LocalPlayer.Character
						local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")

						if not HumanoidRootPart2 then
							return
						end

						for _, player in ipairs(t1.Players:GetPlayers()) do
							if player ~= t1.LocalPlayer and player.Character then
								for _, child in ipairs(player.Character:GetChildren()) do
									if child:IsA("BasePart") then
										child.CanCollide = false
									end
								end
							end
						end

						local Value = Options_.Misc_FlingPower.Value
						local Velocity = HumanoidRootPart2.Velocity

						HumanoidRootPart2.Velocity = Vector3.new(Value, Value, Value)

						for _, descendant in ipairs(Character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end

						t1.RunService.RenderStepped:Wait()
						HumanoidRootPart2.Velocity = Velocity
					end)
				elseif connection then
					connection:Disconnect()
					connection = nil
				end
			end
		})
		Tools:AddSlider("Misc_FlingPower", {
			Text = "Fling Power",
			Min = 5000,
			Max = 100000,
			Default = 50000,
			Rounding = 0,
			Callback = function()
			end
		})

		local v285 = t21.Config:AddLeftGroupbox("Menu Settings", "cog")

		v285:AddSlider("UICornerSlider", {
			Text = "Corner Radius",
			Default = lib.CornerRadius,
			Min = 0,
			Max = 20,
			Rounding = 0,
			Callback = function(p188)
				v166:SetCornerRadius(p188)
			end
		})
		v285:AddToggle("KeybindMenuOpen", {
			Default = lib.KeybindFrame.Visible,
			Text = "Open Keybind",
			Callback = function(p189)
				lib.KeybindFrame.Visible = p189
			end
		})
		v285:AddToggle("ToggleCustomCursor", {
			Default = false,
			Text = "Custom Cursor",
			Callback = function(p190)
				lib.ShowCustomCursor = p190
			end
		})
		v285:AddToggle("LockMenu", {
			Default = true,
			Text = "Lock Gui",
			Callback = function(p191)
				lib.CantDragForced = p191
			end
		})
		v285:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
			Default = "RightShift",
			NoUI = true,
			Text = "Menu keybind"
		})
		lib.ToggleKeybind = Options_.MenuKeybind
		lib.ShowToggleFrameInKeybinds = true
		lib.CantDragForced = true
		lib2:SetLibrary(lib)
		lib2:SetFolder("VD_T/Theme")
		lib2:ApplyToTab(t21.Config)
		lib3:SetLibrary(lib)
		lib3:IgnoreThemeSettings()
		lib3:SetIgnoreIndexes({
			"MenuKeybind",
			"Surv_PerksKey",
			"Killer_WalkSpeedKey",
			"Surv_AutoParry"
		})
		lib3:SetFolder("VD_T/configs")
		lib3:BuildConfigSection(t21.Config)

		local v286 = t21.Info:AddLeftGroupbox("Profile User")

		v286:AddImage("UserAvatar", {
			Image = userThumbnailAsync,
			Transparency = 0,
			BackgroundTransparency = 0,
			Color = Color3.new(1, 1, 1),
			RectOffset = Vector2.zero,
			RectSize = Vector2.zero,
			ScaleType = Enum.ScaleType.Fit,
			Height = 50,
			Visible = true
		})
		v286:AddLabel("Username: " .. t1.LocalPlayer.Name)
		v286:AddLabel("Status: " .. (u14 and "VIP" or "FREE"))
		v286:AddLabel("Expired: " .. expired)
		v286:AddButton({
			Text = "Copy Key",
			Func = function()
				if not lib5.GetSavedKey() or lib5.GetSavedKey() == "" then
					v38("Tidak ada key yang tersimpan!", 3)
				elseif setclipboard then
					setclipboard(lib5.GetSavedKey())
					v38("Key berhasil disalin!", 3)
				else
					v38("Executor tidak support copy!", 3)
				end
			end
		})

		local v287 = t21.Info:AddRightGroupbox("Script Info")

		v287:AddLabel("Developer: Tio")
		v287:AddLabel("Version: " .. t2.version)
		v287:AddLabel("Status: Stable & Updated")

		local v288 = t21.Info:AddLeftGroupbox("Sosial media")
		local v289 = v288:AddLabel("Discord: Mengambil data...")

		v288:AddButton({
			Text = "Join Discord",
			Func = function()
				setclipboard(t2.dc)
				v38("Disalin!", 2)
			end
		})
		v288:AddButton({
			Text = "Tiktok",
			Func = function()
				setclipboard(t2.tt)
				v38("Disalin!", 2)
			end
		})
		t21.Info:AddRightGroupbox("GUI"):AddButton({
			Text = "Destroy UI",
			DoubleClick = true,
			Func = function()
				t5.Unloaded = true
				lib:Unload()

				if Folder then
					Folder:Destroy()
				end

				if Circle then
					Circle.Visible = false
					Circle:Remove()
				end

				if t5.CutsceneConn then
					t5.CutsceneConn:Disconnect()
				end

				if t5.CharCutscene then
					t5.CharCutscene:Disconnect()
				end

				if t5.FlyConnection then
					t5.FlyConnection:Disconnect()
				end

				if t5.FollowConnection then
					t5.FollowConnection:Disconnect()
				end

				if t5.Pv2Con then
					t5.Pv2Con:Disconnect()
				end

				if t5.FleeThread then
					task.cancel(t5.FleeThread)
				end

				if t5.DisarmTrapThread then
					task.cancel(t5.DisarmTrapThread)
				end

				if t5.VaultBoostThread then
					task.cancel(t5.VaultBoostThread)
				end

				if connection then
					connection:Disconnect()
				end

				if t5.SpearModeConn then
					t5.SpearModeConn:Disconnect()
					t5.SpearModeConn = nil
				end

				if t5.StunConn then
					t5.StunConn:Disconnect()
					t5.StunConn = nil
				end

				if t5.VaultBoostThread then
					task.cancel(t5.VaultBoostThread)
				end

				if HealAnimConnection then
					HealAnimConnection:Disconnect()
					HealAnimConnection = nil
				end

				v35.AutoLock(false)

				if getgenv().SlasherInvisLoop then
					task.cancel(getgenv().SlasherInvisLoop)
					getgenv().SlasherInvisLoop = nil
				end

				if getgenv().resolusi then
					getgenv().resolusi:Disconnect()
					getgenv().resolusi = nil
				end

				if getgenv().VD_FakeParry_Cleanup then
					pcall(getgenv().VD_FakeParry_Cleanup)
				end

				if getgenv().InfoPerkCleanup then
					pcall(getgenv().InfoPerkCleanup)
				end

				lib4.ClearAllESP()

				if Part then
					Part:Destroy()
				end

				if Highlight then
					Highlight:Destroy()
				end

				if Circle then
					Circle.Visible = false
					Circle:Remove()
				end

				for _, v in ipairs({
					"WM",
					"FovC",
					"SpcGui",
					"TargetUI",
					"Croshair"
				}) do
					local PlayerGui = t1.CoreGui:FindFirstChild(v) or t1.LocalPlayer:FindFirstChild("PlayerGui") and t1.LocalPlayer.PlayerGui:FindFirstChild(v)

					if PlayerGui then
						PlayerGui:Destroy()
					end
				end

				if getgenv().SpectUI then
					getgenv().SpectUI:Destroy()
				end

				local Character = t1.LocalPlayer.Character

				if Character then
					local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")
					local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")

					if Humanoid2 then
						Humanoid2.WalkSpeed = t5.OriginalSpeed or 16
						Humanoid2.UseJumpPower = false
						Humanoid2.JumpPower = 50

						if Character:FindFirstChild("Animate") then
							Character.Animate.Disabled = false
						end

						Humanoid2:ChangeState(Enum.HumanoidStateType.Running)
					end

					if HumanoidRootPart2 then
						if HumanoidRootPart2:FindFirstChild("FlyStable") then
							HumanoidRootPart2.FlyStable:Destroy()
						end

						if HumanoidRootPart2:FindFirstChild("FlyGyro") then
							HumanoidRootPart2.FlyGyro:Destroy()
						end

						if HumanoidRootPart2:FindFirstChild("SpamHitCircleESP") then
							HumanoidRootPart2.SpamHitCircleESP:Destroy()
						end

						if HumanoidRootPart2:FindFirstChild("AutoParryCircleESP") then
							HumanoidRootPart2.AutoParryCircleESP:Destroy()
						end

						if HumanoidRootPart2:FindFirstChild("KillerWarn") then
							HumanoidRootPart2.KillerWarn:Destroy()
						end
					end

					Character:SetAttribute("vaultspeed", 1)
					Character:SetAttribute("speedboost", 1)
				end

				t1.Camera.FieldOfView = 70
				t1.LocalPlayer.CameraMode = Enum.CameraMode.Classic
				t1.LocalPlayer.CameraMinZoomDistance = 8
				t1.LocalPlayer.CameraMaxZoomDistance = 30
				lib4.DisableFullbrightEvents()

				if t5.OriginalLighting then
					t1.Lighting.Brightness = t5.OriginalLighting.Brightness
					t1.Lighting.FogEnd = t5.OriginalLighting.FogEnd
					t1.Lighting.GlobalShadows = t5.OriginalLighting.GlobalShadows
					t1.Lighting.OutdoorAmbient = t5.OriginalLighting.OutdoorAmbient
					t1.Lighting.Ambient = t5.OriginalLighting.Ambient

					local Atmosphere2 = t1.Lighting:FindFirstChildOfClass("Atmosphere")

					if Atmosphere2 and t5.OriginalLighting.AtmosphereDensity then
						Atmosphere2.Density = t5.OriginalLighting.AtmosphereDensity
					end
				end

				v37.DisableSpoofer()

				if getgenv().RemoveCopyAvatar then
					pcall(getgenv().RemoveCopyAvatar)
				end

				if getgenv().RemoveSkyChanger then
					pcall(getgenv().RemoveSkyChanger)
				end

				if getgenv().Moonwalk then
					pcall(getgenv().Moonwalk)
				end

				if getgenv().RemoveInvisibleGui then
					pcall(getgenv().RemoveInvisibleGui)
				end

				t1.LocalPlayer:SetAttribute("Level", t4.Level)
				t1.LocalPlayer:SetAttribute("Gears", t4.Gears)
				t1.LocalPlayer:SetAttribute("Screws", t4.Screws)

				for k, v in pairs(t3) do
					if type(v) == "boolean" then
						t3[k] = false
					end
				end
			end
		})

		local v299 = t21.Info:AddLeftGroupbox("Server Info")
		local JobId = game.JobId == "" and "Singleplayer/Studio" or game.JobId

		v299:AddButton({
			Text = "Copy Server ID",
			Func = function()
				if setclipboard then
					setclipboard(JobId)
					v38("Tersalin!", 3)
				end
			end
		})
		v299:AddButton({
			Text = "Rejoin Server",
			Func = function()
				local LocalPlayer = t1.Players.LocalPlayer

				if game.JobId == "" then
					t1.TeleportService:Teleport(game.PlaceId, LocalPlayer)
				else
					t1.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
				end
			end
		})
		v299:AddButton({
			Text = "Server Hop",
			Func = function()
				v38("Mencari server baru...", 2)

				local ok, result = pcall(function()
					return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
				end)

				if ok and result then
					local data = t1.HttpService:JSONDecode(result)
					local t22 = {}

					if data and data.data then
						for _, v in ipairs(data.data) do
							if type(v) == "table" and v.id and v.id ~= game.JobId then
								table.insert(t22, v.id)
							end
						end
					end

					if #t22 > 0 then
						local v308 = t22[math.random(#t22)]

						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v308, t1.LocalPlayer)
					elseif getgenv().Library then
						v38("Gagal: Tidak ada server yang tersedia.", 3)
					end
				end
			end
		})
		task.spawn(function()
			local ok, result = pcall(function()
				return t1.HttpService:JSONDecode(game:HttpGet("https://discord.com/api/v9/invites/AHEBP9gWgw?with_counts=true"))
			end)

			if ok and result then
				v289:SetText("Discord: " .. (result.approximate_member_count or "?") .. " Members")
			else
				v289:SetText("Discord: Error")
			end
		end)
	end

	lib3:LoadAutoloadConfig()
end

local u311 = false
local n5 = 0
local u313 = lib5.GetSavedKey()

if u313 ~= "" then
	local v314, _, v316, v317 = lib5.VerifyKey(u313)

	if v314 then
		u14 = v317
		expired = v316
		u311 = true
		v176()
	end
end

t21.Key = v166:AddKeyTab("Key System")
t21.Key:SetupKeySystem({
	Title = "VD TIXO Authentication",
	Description = "Masukkan Token atau Key VIP kamu.",
	Callback = function(p192, p193)
		local now = os.clock()
		local v319 = now - n5

		if v319 < 5 then
			v38("Tunggu " .. math.ceil(5 - v319) .. " detik lagi.", 3)

			return false
		end

		n5 = now

		local v320 = lib:CreateLoading({
			Title = "Verification",
			Icon = t2.icon,
			CurrentStep = 0,
			TotalSteps = 2
		})

		pcall(function()
			v320:SetMessage("Verifikasi token...")
			v320:SetCurrentStep(1)
		end)
		task.wait(0.2)

		local v321, verifikasiGagal, v323, v324 = lib5.VerifyKey(p192)

		pcall(function()
			v320:SetMessage(v321 and "Akses Diterima!" or "Akses Ditolak!")
			v320:SetCurrentStep(2)
		end)
		task.wait(1)

		if v321 then
			u14 = v324
			expired = v323

			local v325 = u14

			p193.Text = "Status: " .. (v325 and "VIP User" or "Free User")

			if writefile then
				pcall(function()
					writefile(t9.keyFile, p192)
				end)
			end

			u313 = p192
			v38("Selamat Datang, " .. t1.LocalPlayer.Name .. "!", 3)
			pcall(function()
				v320:Destroy()
			end)

			if not u311 then
				u311 = true
				v176()
			end
		else
			p193.Text = "Gagal!\nAlasan: " .. verifikasiGagal
			v38("Verifikasi Gagal: " .. verifikasiGagal, 5)
			pcall(function()
				v320:Destroy()
			end)
		end
	end,
	GetKeyCallback = function()
		local v326, v327 = lib5.GetLink()

		if not v326 or not v327 then
			v38("Gagal mengambil link: " .. tostring(v327), 5)
		elseif setclipboard then
			setclipboard(v327)
			v38("Link berhasil disalin!", 4)
		else
			v38("Executor tidak support setclipboard. Link: " .. v327, 5)
		end
	end
})

local function v328()
	task.spawn(function()
		local Remotes3 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
		local KillerPerks = Remotes3 and Remotes3:WaitForChild("KillerPerks", 5)
		local kingscourge = KillerPerks and KillerPerks:WaitForChild("kingscourge", 5)
		local KingScourgeStart = kingscourge and kingscourge:WaitForChild("KingScourgeStart", 5)

		if KingScourgeStart then
			KingScourgeStart.OnClientEvent:Connect(function()
				if t3.Surv_SkillCheckMode == "Random" then
					t5.RandomMode_IsNormal = true
				end
			end)
		end
	end)
end

v328()

local connection

local function v334(p194)
	if not p194 then
		return
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	task.spawn(function()
		v91(p194)

		local Humanoid2 = p194:WaitForChild("Humanoid", 5)

		if not Humanoid2 then
			return
		end

		local Animator = Humanoid2:WaitForChild("Animator", 5) or Humanoid2:FindFirstChildOfClass("Animator")

		if not Animator then
			return
		end

		connection = Animator.AnimationPlayed:Connect(function(p195)
			local AnimationId = p195.Animation and p195.Animation.AnimationId

			if not AnimationId then
				return
			end

			if t3.Surv_SelfHeal and string.find(AnimationId, "95836365038528") then
				p195:Stop(0)
			end
		end)
	end)
end

t1.UserInputService.InputBegan:Connect(function(input, gameProcessed)
	local v338 = input.UserInputType == Enum.UserInputType.Touch

	if gameProcessed and not v338 then
		return
	end

	local Character = t1.LocalPlayer.Character
	local Position, AbsolutePosition, AbsoluteSize

	if Character then
		local v343 = Character:GetAttribute("spearmode") == true

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if t3.Aim_Silent then
				t7.isChargingPistol = true
				t5.locked = lib6.GetUnifiedTarget("Pistol")

				if t3.PistolV2_Enabled then
					t5.PistolV2_IsAiming = true
					Character:SetAttribute("Aiming", true)
				end

				if t3.Flash_Silent then
					t7.isAimingFlash = true
				end

				if t3.Butcher_Aim and isButcherChainMode then
					lib6.ButcherCache(t3.leadButcher)
				end
			else
				if t3.PistolV2_Enabled then
					t5.PistolV2_IsAiming = true
					Character:SetAttribute("Aiming", true)
				end

				if t3.Flash_Silent then
					t7.isAimingFlash = true
				end

				if t3.Butcher_Aim and isButcherChainMode then
					lib6.ButcherCache(t3.leadButcher)
				end
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			if t3.Aim_Silent and t7.isChargingPistol then
				lib6.AimFire()
			end

			if t3.PistolV2_Enabled and t5.PistolV2_IsAiming then
				lib6.FirePistolV2Bypass()
			end

			if t3.Aim_SilentVeil and v343 then
				t7.isChargingSpear = true
				t7.spearAimStartTime = tick()
			end

			if v46() == "Killer" and t3.Aimbot_Enabled then
				t7.lockedAimbotTarget = lib6.GetUnifiedTarget("Aimbot")

				if t7.lockedAimbotTarget then
					t7.isAimbotHolding = true
				end
			end
		elseif v338 then
			if v46() == "Killer" then
				local v344 = v35.GetKillerUI()
				local attack = v344 and v344:FindFirstChild("Controls") and v344.Controls:FindFirstChild("attack")

				if attack and attack.Visible then
					local Position2 = input.Position
					local AbsolutePosition2 = attack.AbsolutePosition
					local AbsoluteSize2 = attack.AbsoluteSize

					if AbsolutePosition2.X <= Position2.X and Position2.X <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y <= Position2.Y and Position2.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y and t3.Aimbot_Enabled then
						t7.lockedAimbotTarget = lib6.GetUnifiedTarget("Aimbot")

						if t7.lockedAimbotTarget then
							t7.isAimbotHolding = true
						end
					end
				end
			end

			if t3.Aim_Silent or t3.PistolV2_Enabled or t3.Flash_Silent then
				local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
				local GuiMob = PlayerGui and PlayerGui:FindFirstChild("Survivor-mob") and PlayerGui["Survivor-mob"]:FindFirstChild("Controls") and PlayerGui["Survivor-mob"].Controls:FindFirstChild("Gui-mob")

				if GuiMob then
					local v351 = Character and v54(Character)

					if GuiMob.Visible or v351 then
						local Position2 = input.Position
						local AbsolutePosition2 = GuiMob.AbsolutePosition
						local AbsoluteSize2 = GuiMob.AbsoluteSize

						if AbsoluteSize2.X <= 0 or AbsoluteSize2.Y <= 0 then
							local Parent = GuiMob.Parent

							if Parent then
								AbsolutePosition2 = Parent.AbsolutePosition
								AbsoluteSize2 = Parent.AbsoluteSize
							end
						end

						if AbsolutePosition2.X <= Position2.X and Position2.X <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y <= Position2.Y and Position2.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y then
							if t3.Aim_Silent then
								t7.isChargingPistol = true
								t7.currentTouchInput = input
								t5.locked = lib6.GetUnifiedTarget("Pistol")
							end

							if t3.PistolV2_Enabled then
								t5.PistolV2_IsAiming = true
								t5.PistolV2_TouchInput = input
								Character:SetAttribute("Aiming", true)
							end

							if t3.Flash_Silent then
								t7.isAimingFlash = true
								t7.currentTouchInput = input
							end
						end
					end
				end
			end

			if t3.Aim_SilentVeil and v343 then
				local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
				local attack = PlayerGui and PlayerGui:FindFirstChild("Slasher-mob") and PlayerGui["Slasher-mob"]:FindFirstChild("Controls") and PlayerGui["Slasher-mob"].Controls:FindFirstChild("attack")

				if attack and attack.Visible then
					local Position2 = input.Position
					local AbsolutePosition2 = attack.AbsolutePosition
					local AbsoluteSize2 = attack.AbsoluteSize

					if AbsolutePosition2.X <= Position2.X and Position2.X <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y <= Position2.Y and Position2.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y then
						t7.isChargingSpear = true
						t7.currentTouchInput = input
						t7.spearAimStartTime = tick()
					end
				end
			end

			if t3.Butcher_Aim then
				local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
				local move1 = PlayerGui and PlayerGui:FindFirstChild("Slasher-mob") and PlayerGui["Slasher-mob"]:FindFirstChild("Controls") and PlayerGui["Slasher-mob"].Controls:FindFirstChild("move1")

				if move1 and move1.Visible then
					Position = input.Position
					AbsolutePosition = move1.AbsolutePosition
					AbsoluteSize = move1.AbsoluteSize

					if AbsolutePosition.X <= Position.X and Position.X <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y <= Position.Y and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
						t7.isChargingButcher = true
						t7.currentTouchInput = input
					end
				end
			end
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		if t3.Aim_Silent then
			t7.isChargingPistol = true
			t5.locked = lib6.GetUnifiedTarget("Pistol")
		end

		if t3.PistolV2_Enabled then
			t5.PistolV2_IsAiming = true
		end

		if t3.Flash_Silent then
			t7.isAimingFlash = true
		end

		if t3.Butcher_Aim and isButcherChainMode then
			lib6.ButcherCache(t3.leadButcher)
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		if t3.Aim_Silent and t7.isChargingPistol then
			lib6.AimFire()
		end

		if t3.PistolV2_Enabled and t5.PistolV2_IsAiming then
			lib6.FirePistolV2Bypass()
		end

		if v46() == "Killer" and t3.Aimbot_Enabled then
			t7.lockedAimbotTarget = lib6.GetUnifiedTarget("Aimbot")

			if t7.lockedAimbotTarget then
				t7.isAimbotHolding = true
			end
		end
	elseif v338 then
		if v46() == "Killer" then
			local v363 = v35.GetKillerUI()
			local attack = v363 and v363:FindFirstChild("Controls") and v363.Controls:FindFirstChild("attack")

			if attack and attack.Visible then
				local Position2 = input.Position
				local AbsolutePosition2 = attack.AbsolutePosition
				local AbsoluteSize2 = attack.AbsoluteSize

				if AbsolutePosition2.X <= Position2.X and Position2.X <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y <= Position2.Y and Position2.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y and t3.Aimbot_Enabled then
					t7.lockedAimbotTarget = lib6.GetUnifiedTarget("Aimbot")

					if t7.lockedAimbotTarget then
						t7.isAimbotHolding = true
					end
				end
			end
		end

		if t3.Aim_Silent or t3.PistolV2_Enabled or t3.Flash_Silent then
			local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
			local GuiMob = PlayerGui and PlayerGui:FindFirstChild("Survivor-mob") and PlayerGui["Survivor-mob"]:FindFirstChild("Controls") and PlayerGui["Survivor-mob"].Controls:FindFirstChild("Gui-mob")

			if GuiMob then
				local v370 = Character and v54(Character)

				if GuiMob.Visible or v370 then
					local Position2 = input.Position
					local AbsolutePosition2 = GuiMob.AbsolutePosition
					local AbsoluteSize2 = GuiMob.AbsoluteSize

					if AbsoluteSize2.X <= 0 or AbsoluteSize2.Y <= 0 then
						local Parent = GuiMob.Parent

						if Parent then
							AbsolutePosition2 = Parent.AbsolutePosition
							AbsoluteSize2 = Parent.AbsoluteSize
						end
					end

					if AbsolutePosition2.X <= Position2.X and Position2.X <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y <= Position2.Y and Position2.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y then
						if t3.Aim_Silent then
							t7.isChargingPistol = true
							t7.currentTouchInput = input
							t5.locked = lib6.GetUnifiedTarget("Pistol")
						end

						if t3.PistolV2_Enabled then
							t5.PistolV2_IsAiming = true
							t5.PistolV2_TouchInput = input
						end

						if t3.Flash_Silent then
							t7.isAimingFlash = true
							t7.currentTouchInput = input
						end
					end
				end
			end
		end

		if t3.Butcher_Aim then
			local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
			local move1 = PlayerGui and PlayerGui:FindFirstChild("Slasher-mob") and PlayerGui["Slasher-mob"]:FindFirstChild("Controls") and PlayerGui["Slasher-mob"].Controls:FindFirstChild("move1")

			if move1 and move1.Visible then
				Position = input.Position
				AbsolutePosition = move1.AbsolutePosition
				AbsoluteSize = move1.AbsoluteSize

				if AbsolutePosition.X <= Position.X and Position.X <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y <= Position.Y and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
					t7.isChargingButcher = true
					t7.currentTouchInput = input
				end
			end
		end
	end
end)
t1.UserInputService.InputEnded:Connect(function(input)
	local v377 = input.UserInputType == Enum.UserInputType.Touch

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		if t7.isChargingPistol then
			t7.isChargingPistol = false
			t5.locked = nil
		end

		if t3.PistolV2_Enabled then
			t5.PistolV2_IsAiming = false
			t5.PistolV2_IsHoldingBypass = false

			local Character = t1.LocalPlayer.Character

			if Character then
				Character:SetAttribute("Aiming", false)
			end

			if t5.PistolV2_LaserBeam then
				t5.PistolV2_LaserBeam.Transparency = 1
			end
		end

		if t7.isAimingFlash then
			t7.isAimingFlash = false
		end
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 or v377 then
		t7.isAimbotHolding = false
		t7.lockedAimbotTarget = nil

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			t5.isHoldingLunge = false
		end
	end

	if v377 and input == t5.touchLunge then
		t5.isHoldingLunge = false
		t5.touchLunge = nil
	end

	if v377 and input == t5.currentTouch then
		t5.isHolding = false
		t5.currentTouch = nil
	end

	if t7.isChargingSpear and (input == t7.currentTouchInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
		t7.isChargingSpear = false

		if t7.currentTouchInput == input then
			t7.currentTouchInput = nil
		end

		if t5.spearSwitchCooldown then
			return
		end

		lib6.VeilCache()
	end

	if t7.isChargingButcher and input == t7.currentTouchInput then
		t7.isChargingButcher = false
		t7.currentTouchInput = nil
		lib6.ButcherCache(t3.leadButcher)
	end

	if v377 then
		if input == t7.currentTouchInput or input == t5.PistolV2_TouchInput then
			if t3.PistolV2_Enabled and input == t5.PistolV2_TouchInput then
				t5.PistolV2_IsAiming = false
				t5.PistolV2_TouchInput = nil

				local u379 = false

				pcall(function()
					local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
					local cancelaim = PlayerGui and PlayerGui:FindFirstChild("Survivor-mob") and PlayerGui["Survivor-mob"]:FindFirstChild("Controls") and PlayerGui["Survivor-mob"].Controls:FindFirstChild("Gui-mob") and PlayerGui["Survivor-mob"].Controls["Gui-mob"]:FindFirstChild("cancelaim")

					if cancelaim and cancelaim.Visible then
						local Position = input.Position
						local AbsolutePosition = cancelaim.AbsolutePosition
						local AbsoluteSize = cancelaim.AbsoluteSize

						if AbsolutePosition.X <= Position.X and Position.X <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y <= Position.Y and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
							u379 = true
						end
					end
				end)

				if not u379 then
					lib6.FirePistolV2Bypass()
				end

				local Character = t1.LocalPlayer.Character

				if Character then
					Character:SetAttribute("Aiming", false)
				end

				if t5.PistolV2_LaserBeam then
					t5.PistolV2_LaserBeam.Transparency = 1
				end
			end

			if t7.isChargingPistol then
				t7.isChargingPistol = false
				t7.currentTouchInput = nil

				local u386 = false

				pcall(function()
					local PlayerGui = t1.LocalPlayer:FindFirstChild("PlayerGui")
					local cancelaim = PlayerGui and PlayerGui:FindFirstChild("Survivor-mob") and PlayerGui["Survivor-mob"]:FindFirstChild("Controls") and PlayerGui["Survivor-mob"].Controls:FindFirstChild("Gui-mob") and PlayerGui["Survivor-mob"].Controls["Gui-mob"]:FindFirstChild("cancelaim")

					if cancelaim and cancelaim.Visible then
						local Position = input.Position
						local AbsolutePosition = cancelaim.AbsolutePosition
						local AbsoluteSize = cancelaim.AbsoluteSize

						if AbsolutePosition.X <= Position.X and Position.X <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y <= Position.Y and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
							u386 = true
						end
					end
				end)

				if not u386 then
					lib6.AimFire()
				end

				t5.locked = nil
			end

			if t7.isAimingFlash then
				t7.isAimingFlash = false
				t7.currentTouchInput = nil
			end
		end
	end
end)

local t23 = {}

local function v393(p196)
	if not p196 or t23[p196] then
		return
	end

	t23[p196] = true

	local Humanoid2 = p196:WaitForChild("Humanoid", 5)

	if not Humanoid2 then
		return
	end

	local Animator = Humanoid2:FindFirstChildOfClass("Animator") or Humanoid2:WaitForChild("Animator", 5)

	if not Animator then
		return
	end

	local connection2

	connection2 = Humanoid2.ChildAdded:Connect(function(child)
		if child:IsA("Animator") then
			t23[p196] = nil

			if connection2 then
				connection2:Disconnect()
			end

			v393(p196)
		end
	end)
	p196.AncestryChanged:Connect(function(child, parent)
		if not parent then
			t23[p196] = nil

			if not connection2 then
				return
			end

			connection2:Disconnect()
		end
	end)
	Animator.AnimationPlayed:Connect(function(p197)
		local match = (p197.Animation and p197.Animation.AnimationId or ""):match("%d+")

		if (match == v36.ID.v1 or match == v36.ID.v2) and t3.Surv_CrouchV then
			local Character = t1.LocalPlayer.Character
			local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
			local HumanoidRootPart3 = p196:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart2 and HumanoidRootPart3 and HumanoidRootPart2.Parent and HumanoidRootPart3.Parent and (HumanoidRootPart2.Position - HumanoidRootPart3.Position).Magnitude <= 35 then
				local v401 = Vector3.new(HumanoidRootPart2.Position.X, 0, HumanoidRootPart2.Position.Z) - Vector3.new(HumanoidRootPart3.Position.X, 0, HumanoidRootPart3.Position.Z)

				if v401.Magnitude > 0 then
					local Unit = v401.Unit
					local vector3 = Vector3.new(HumanoidRootPart3.CFrame.LookVector.X, 0, HumanoidRootPart3.CFrame.LookVector.Z)

					if vector3.Magnitude > 0.001 then
						if vector3.Unit:Dot(Unit) >= 0.7 then
							v36.TriggerCrouch(0.3)
						end
					end
				end
			end
		end

		local v404 = v36.VALID_PARRY_IDS[match]

		if not v404 then
			return
		end

		if match == v36.ID.abys and t3.Surv_AutoCrouch then
			local Character = t1.LocalPlayer.Character

			if not v53(Character) then
				if v59(Character) then
					local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
					local HumanoidRootPart3 = p196:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart2 and HumanoidRootPart3 and HumanoidRootPart2.Parent and HumanoidRootPart3.Parent and (HumanoidRootPart2.Position - HumanoidRootPart3.Position).Magnitude <= 35 then
						task.delay(0.5, function()
							v36.TriggerCrouch(1)
						end)
					end

					return
				end
			end

			return
		end

		if not t3.Surv_Parry then
			return
		end

		if t3.Ignored_Skills_List and t3.Ignored_Skills_List[v404] then
			return
		end

		local Character = t1.LocalPlayer.Character
		local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
		local HumanoidRootPart3 = p196:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart2 or not HumanoidRootPart3 then
			return
		end

		if match == v36.ID.hdnS1 then
			if v53(Character) or not v59(Character) then
				return
			end

			if HumanoidRootPart2.Parent and HumanoidRootPart3.Parent and (HumanoidRootPart2.Position - HumanoidRootPart3.Position).Magnitude <= 30 then
				local v411 = Vector3.new(HumanoidRootPart2.Position.X, 0, HumanoidRootPart2.Position.Z) - Vector3.new(HumanoidRootPart3.Position.X, 0, HumanoidRootPart3.Position.Z)

				if v411.Magnitude > 0 then
					local Unit = v411.Unit
					local vector3 = Vector3.new(HumanoidRootPart3.CFrame.LookVector.X, 0, HumanoidRootPart3.CFrame.LookVector.Z)

					if vector3.Magnitude > 0.001 then
						if (t3.Surv_ParryFace or 0.7) <= vector3.Unit:Dot(Unit) then
							task.delay(0.5, function()
								v36.ExecuteParry()
							end)
						end
					end
				end
			end

			return
		end

		local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart3.Position).Magnitude

		if t3.Surv_ParryAggressive then
			if t3.Surv_ParryRadius < Magnitude then
				return
			end

			local connection3
			local now = os.clock()

			connection3 = t1.RunService.Heartbeat:Connect(function()
				if os.clock() - now >= 0.7 or not HumanoidRootPart2 or not HumanoidRootPart2.Parent or not HumanoidRootPart3 or not HumanoidRootPart3.Parent then
					connection3:Disconnect()

					return
				end

				if v53(Character) then
					connection3:Disconnect()

					return
				end

				if (HumanoidRootPart2.Position - HumanoidRootPart3.Position).Magnitude <= 10 and v59(Character) then
					local v417 = Vector3.new(HumanoidRootPart2.Position.X, 0, HumanoidRootPart2.Position.Z) - Vector3.new(HumanoidRootPart3.Position.X, 0, HumanoidRootPart3.Position.Z)

					if v417.Magnitude > 0 then
						local Unit = v417.Unit
						local vector3 = Vector3.new(HumanoidRootPart3.CFrame.LookVector.X, 0, HumanoidRootPart3.CFrame.LookVector.Z)

						if vector3.Magnitude > 0.001 then
							if (t3.Surv_ParryFace or 0.7) <= vector3.Unit:Dot(Unit) then
								v36.ExecuteParry()
								connection3:Disconnect()
							end
						else
							v36.ExecuteParry()
							connection3:Disconnect()
						end
					else
						v36.ExecuteParry()
						connection3:Disconnect()
					end
				end
			end)
		else
			if t3.Surv_ParryRadius < Magnitude then
				return
			end

			if v53(Character) or not v59(Character) then
				return
			end

			if HumanoidRootPart2.Parent and HumanoidRootPart3.Parent then
				local v420 = Vector3.new(HumanoidRootPart2.Position.X, 0, HumanoidRootPart2.Position.Z) - Vector3.new(HumanoidRootPart3.Position.X, 0, HumanoidRootPart3.Position.Z)

				if not (v420.Magnitude > 0) then
					return
				end

				local Unit = v420.Unit
				local vector3 = Vector3.new(HumanoidRootPart3.CFrame.LookVector.X, 0, HumanoidRootPart3.CFrame.LookVector.Z)

				if vector3.Magnitude > 0.01 then
					if vector3.Unit:Dot(Unit) < (t3.Surv_ParryFace or 0.7) then
						return
					end
				end

				v36.ExecuteParry()
			end
		end
	end)
end
local function v423(p198)
	if p198 ~= t1.LocalPlayer and v47(p198) and p198.Character then
		v393(p198.Character)
	end
end
local function v424(p199)
	if p199 == t1.LocalPlayer then
		return
	end

	p199.CharacterAdded:Connect(function()
		v423(p199)
	end)
	p199:GetPropertyChangedSignal("Team"):Connect(function()
		v423(p199)
	end)

	if p199.Character then
		v423(p199)
	end
end

for _, player in ipairs(t1.Players:GetPlayers()) do
	v424(player)
	player:GetPropertyChangedSignal("Team"):Connect(v74)
end

t1.Players.PlayerAdded:Connect(function(player)
	v74()
	player:GetPropertyChangedSignal("Team"):Connect(v74)
	v424(player)
end)
t1.Players.PlayerRemoving:Connect(function()
	v74()
end)
t1.RunService.RenderStepped:Connect(function()
	if t3.Surv_Fov and t1.Camera.FieldOfView ~= t3.Surv_FOV_Value then
		t1.Camera.FieldOfView = t3.Surv_FOV_Value
	end

	if t7.isAimingFlash and t3.Flash_Silent then
		local Flash = lib6.GetUnifiedTarget("Flash")
		local Character = t1.LocalPlayer.Character
		local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")

		if Flash and HumanoidRootPart2 and (HumanoidRootPart2.Position - Flash.Position).Magnitude <= 50 then
			local v430 = Flash.Position + Vector3.new(0, t3.Flash_YOffset or 0, 0)
			local CurrentCamera = t1.Workspace.CurrentCamera
			local Flash_Smoothness = t3.Flash_Smoothness or 0.2

			CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position, v430), Flash_Smoothness)
			HumanoidRootPart2.CFrame = HumanoidRootPart2.CFrame:Lerp(CFrame.lookAt(HumanoidRootPart2.Position, Vector3.new(v430.X, HumanoidRootPart2.Position.Y, v430.Z)), Flash_Smoothness)
		end
	end

	if t7.isChargingPistol and t3.Aim_Lock then
		local ok = not t5.locked or not t5.locked.Parent

		if not ok then
			ok = not t5.locked.Parent:FindFirstChild("Humanoid") or not (t5.locked.Parent.Humanoid.Health > 0)
		end

		if ok then
			t5.locked = lib6.GetUnifiedTarget("Pistol")
		else
			lib6.FaceTarget(t5.locked)
		end
	end

	local Character = u25 or t1.LocalPlayer.Character
	local HumanoidRootPart2 = HumanoidRootPart or Character and Character:FindFirstChild("HumanoidRootPart")

	if not Humanoid and Character then
		Character:FindFirstChildOfClass("Humanoid")
	end

	if t3.Killer_HitEspCircle and t3.Killer_SpamHit and HumanoidRootPart2 then
		if not t5.SpamHit or t5.SpamHit.Parent ~= HumanoidRootPart2 then
			if t5.SpamHit then
				t5.SpamHit:Destroy()
			end

			t5.SpamHit = Instance.new("CylinderHandleAdornment")
			t5.SpamHit.Name = "SpamHitCircleESP"
			t5.SpamHit.Height = 0.05
			t5.SpamHit.Color3 = Color3.fromRGB(255, 0, 0)
			t5.SpamHit.Transparency = 0.3
			t5.SpamHit.Adornee = HumanoidRootPart2
			t5.SpamHit.Parent = HumanoidRootPart2
			t5.SpamHit.ZIndex = 0
			t5.SpamHit.AlwaysOnTop = false
		end

		t5.SpamHit.Radius = t3.Killer_SpamHitRadius
		t5.SpamHit.InnerRadius = math.max(0.1, t3.Killer_SpamHitRadius - 0.15)
		t5.SpamHit.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)
	elseif t5.SpamHit then
		t5.SpamHit:Destroy()
		t5.SpamHit = nil
	end

	if t3.Surv_ParryCircle and (t3.Surv_Parry or t3.Surv_ParryV2) and HumanoidRootPart2 then
		if not t5.autoParry or t5.autoParry.Parent ~= HumanoidRootPart2 then
			if t5.autoParry then
				t5.autoParry:Destroy()
			end

			t5.autoParry = Instance.new("CylinderHandleAdornment")
			t5.autoParry.Name = "AutoParryCircleESP"
			t5.autoParry.Height = 0.05
			t5.autoParry.Transparency = 0.3
			t5.autoParry.Adornee = HumanoidRootPart2
			t5.autoParry.Parent = HumanoidRootPart2
			t5.autoParry.ZIndex = 0
			t5.autoParry.AlwaysOnTop = false
		end

		local Surv_ParryRadius = t3.Surv_ParryRadius

		if t3.Surv_ParryAggressive then
			Surv_ParryRadius += 5
		end

		t5.autoParry.Radius = Surv_ParryRadius
		t5.autoParry.InnerRadius = math.max(0.1, Surv_ParryRadius - 0.15)
		t5.autoParry.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)

		if t3.Surv_ParryAggressive then
			t5.autoParry.Color3 = Color3.fromRGB(255, 0, 0)
		else
			t5.autoParry.Color3 = Color3.fromRGB(0, 255, 255)
		end
	elseif t5.autoParry then
		t5.autoParry:Destroy()
		t5.autoParry = nil
	end

	if t3.Aimbot_Enabled and t1.LocalPlayer.Character then
		if v46() == "Survivor" then
			local Aimbot = lib6.GetUnifiedTarget("Aimbot")

			if Aimbot and HumanoidRootPart2 then
				local Position = Aimbot:IsA("Model") and Aimbot:GetPivot().Position or Aimbot:IsA("BasePart") and Aimbot.Position or nil
				local v439 = v51(Position)

				if v439 < 100 then
					Position += t1.Camera.CFrame.RightVector * ((100 - v439) * t3.Aimbot_Predict)
				end

				t1.Camera.CFrame = t1.Camera.CFrame:Lerp(CFrame.new(t1.Camera.CFrame.Position, Position), t3.Aimbot_Smoothness)
				HumanoidRootPart2.CFrame = HumanoidRootPart2.CFrame:Lerp(CFrame.new(HumanoidRootPart2.Position, Vector3.new(Position.X, HumanoidRootPart2.Position.Y, Position.Z)), t3.Aimbot_Smoothness)
			end
		elseif v46() == "Killer" then
			if t7.isAimbotHolding and t7.lockedAimbotTarget then
				local Parent = t7.lockedAimbotTarget.Parent
				local Humanoid2 = Parent and Parent:FindFirstChild("Humanoid")

				if not Humanoid2 or Humanoid2.Health <= 0 or v53(Parent) then
					t7.lockedAimbotTarget = lib6.GetUnifiedTarget("Aimbot")
				end

				if t7.lockedAimbotTarget and HumanoidRootPart2 then
					local Position = t7.lockedAimbotTarget.Position

					if t3.Aimbot_MaxDist < v51(Position) then
						t7.lockedAimbotTarget = lib6.GetUnifiedTarget("Aimbot")
					else
						t1.Camera.CFrame = t1.Camera.CFrame:Lerp(CFrame.new(t1.Camera.CFrame.Position, Position), t3.Aimbot_Smoothness)
						HumanoidRootPart2.CFrame = HumanoidRootPart2.CFrame:Lerp(CFrame.new(HumanoidRootPart2.Position, Vector3.new(Position.X, HumanoidRootPart2.Position.Y, Position.Z)), t3.Aimbot_Smoothness)
					end
				end
			else
				t7.lockedAimbotTarget = nil
			end
		end
	end

	local vector2 = Vector2.new(t1.Camera.ViewportSize.X / 2, t1.Camera.ViewportSize.Y / 2)
	local visible = false
	local n6 = 0
	local color3 = Color3.fromRGB(255, 255, 255)
	local Butcher_TargetPart

	if Character then
		local v448 = Character:GetAttribute("spearmode") == true
		local v449 = Character and Character:GetAttribute("special") == true
		local v450 = Character and Character:GetAttribute("IsStunned") == true

		if t3.Aimbot_Enabled and t3.Aimbot_ShowFOV then
			visible = true
			n6 = t3.Aimbot_Radius
			color3 = lib6.GetUnifiedTarget("Aimbot") ~= nil and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 100)
		elseif t3.Aim_SilentVeil and t3.Veil_ShowFOV and v448 then
			visible = true
			n6 = t3.Veil_FOV

			if v449 then
				color3 = Color3.fromRGB(0, 255, 100)
			else
				color3 = Color3.fromRGB(150, 150, 150)
			end
		elseif (t3.Aim_Silent or t3.PistolV2_Enabled) and t3.Pistol_ShowFOV and t3.Pistol_FOVMode then
			visible = true
			n6 = t3.Pistol_FOV
			color3 = Color3.fromRGB(255, 255, 255)
		end

		if t12.FOV then
			t12.FOV.Frame.Visible = visible

			if visible then
				t12.FOV.Frame.Size = UDim2.new(0, n6 * 2, 0, n6 * 2)
				t12.FOV.Frame.Position = UDim2.new(0, vector2.X, 0, vector2.Y)
				t12.FOV.Stroke.Color = color3
			end
		end

		if t7.isChargingPistol and t3.Aim_Silent then
			local Pistol = lib6.GetUnifiedTarget("Pistol")

			if Pistol then
				local LeftArm = Character:FindFirstChild("Left Arm") or Character:FindFirstChild("LeftHand")
				local Position = LeftArm and LeftArm.Position or Character:GetPivot().Position
				local Position2 = Pistol.Position
				local AssemblyLinearVelocity = Pistol.AssemblyLinearVelocity
				local v456 = Position2 + Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) * ((Position2 - Position).Magnitude / 400) + Vector3.new(0, t3.Pistol_AimOffset, 0)

				if t3.Pistol_ShowLaser then
					Part.Parent = workspace

					local Magnitude = (v456 - Position).Magnitude

					Part.Size = Vector3.new(0.05, 0.05, Magnitude)
					Part.CFrame = CFrame.new(Position, v456) * CFrame.new(0, 0, -Magnitude / 2)
				elseif Part.Parent ~= nil then
					Part.Parent = nil
				end
			elseif Part.Parent ~= nil then
				Part.Parent = nil
			end
		elseif Part.Parent ~= nil then
			Part.Parent = nil
		end

		if t7.isChargingButcher and t3.Butcher_Aim then
			lib6.ButcherCache(t7.lockedButcherTarget)

			if t5.Butcher_HasCache and t5.Butcher_TargetPart then
				Butcher_TargetPart = t5.Butcher_TargetPart
				Highlight.FillColor = t6.Colors.Player
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				Highlight.Parent = Butcher_TargetPart.Parent
			else
				Highlight.Parent = nil
			end
		else
			if not t7.isChargingSpear or not t3.Aim_SilentVeil or not v448 or v450 then
				v134()
				Highlight.Parent = nil

				return
			end

			lib6.VeilCache()

			if t5.Veil_HasCache and t5.Veil_TargetPart then
				local Veil_TargetPart = t5.Veil_TargetPart

				Highlight.FillColor = Color3.fromRGB(255, 0, 0)
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				Highlight.Parent = Veil_TargetPart.Parent
				v137(t5.Veil_CachedStartPos, t5.Veil_CachedDir, t5.Veil_CachedSpeed, t5.Veil_CachedGrav or t3.SPEAR_Gravity, t1.LocalPlayer.Character, Veil_TargetPart, t5.Veil_CachedPredictedPos)
			else
				Highlight.Parent = nil
				v134()
			end
		end
	else
		if t3.Aimbot_Enabled and t3.Aimbot_ShowFOV then
			visible = true
			n6 = t3.Aimbot_Radius
			color3 = lib6.GetUnifiedTarget("Aimbot") ~= nil and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 100)
		else
			if t3.Aim_SilentVeil then
			end

			if (t3.Aim_Silent or t3.PistolV2_Enabled) and t3.Pistol_ShowFOV and t3.Pistol_FOVMode then
				visible = true
				n6 = t3.Pistol_FOV
				color3 = Color3.fromRGB(255, 255, 255)
			end
		end

		if t12.FOV then
			t12.FOV.Frame.Visible = visible

			if visible then
				t12.FOV.Frame.Size = UDim2.new(0, n6 * 2, 0, n6 * 2)
				t12.FOV.Frame.Position = UDim2.new(0, vector2.X, 0, vector2.Y)
				t12.FOV.Stroke.Color = color3
			end
		end

		if t7.isChargingPistol and t3.Aim_Silent then
			local Pistol = lib6.GetUnifiedTarget("Pistol")

			if Pistol then
				local LeftArm = Character:FindFirstChild("Left Arm") or Character:FindFirstChild("LeftHand")
				local Position = LeftArm and LeftArm.Position or Character:GetPivot().Position
				local Position2 = Pistol.Position
				local AssemblyLinearVelocity = Pistol.AssemblyLinearVelocity
				local v464 = Position2 + Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) * ((Position2 - Position).Magnitude / 400) + Vector3.new(0, t3.Pistol_AimOffset, 0)

				if t3.Pistol_ShowLaser then
					Part.Parent = workspace

					local Magnitude = (v464 - Position).Magnitude

					Part.Size = Vector3.new(0.05, 0.05, Magnitude)
					Part.CFrame = CFrame.new(Position, v464) * CFrame.new(0, 0, -Magnitude / 2)
				elseif Part.Parent ~= nil then
					Part.Parent = nil
				end
			elseif Part.Parent ~= nil then
				Part.Parent = nil
			end
		elseif Part.Parent ~= nil then
			Part.Parent = nil
		end

		if t7.isChargingButcher and t3.Butcher_Aim then
			lib6.ButcherCache(t7.lockedButcherTarget)

			if t5.Butcher_HasCache and t5.Butcher_TargetPart then
				Butcher_TargetPart = t5.Butcher_TargetPart
				Highlight.FillColor = t6.Colors.Player
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				Highlight.Parent = Butcher_TargetPart.Parent
			else
				Highlight.Parent = nil
			end
		else
			if t7.isChargingSpear then
			end

			v134()
			Highlight.Parent = nil
		end
	end
end)
t1.RunService.Stepped:Connect(function()
	if not t3.Misc_Noclip then
		return
	end

	local Character = t1.LocalPlayer.Character

	if not Character then
		return
	end

	if Character ~= t5.lastNoclipChar then
		table.clear(t5.cachedNoclipParts)

		for _, descendant in ipairs(Character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				table.insert(t5.cachedNoclipParts, descendant)
			end
		end

		t5.lastNoclipChar = Character
	end

	for _, cachedNoclipPart in ipairs(t5.cachedNoclipParts) do
		cachedNoclipPart.CanCollide = false
	end
end)
t1.Lighting.ChildAdded:Connect(function(child)
	if child:IsA("Atmosphere") then
		Atmosphere = child
	end
end)
t1.RunService.Heartbeat:Connect(function(dt)
	if t5.Unloaded then
		return
	end

	local Character = t1.LocalPlayer.Character
	local Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")
	local now = tick()
	local v474 = v50()
	local v475 = math.max(0.15, (t3.Killer_SpamHitDelay or 100) / 1000)

	if t3.Killer_SpamHit and v475 <= now - t5.lastSpam then
		t5.lastSpam = now

		if v474 and v46() == "Killer" then
			local v476 = Attacks:FindFirstChild(t3.Killer_AttackMode)
			local v477 = false

			for _, player in pairs(t1.Players:GetPlayers()) do
				if player ~= t1.LocalPlayer and not v47(player) and player.Character then
					local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
					local Humanoid3 = player.Character:FindFirstChildOfClass("Humanoid")

					if not player.Character:GetAttribute("isHooked") and HumanoidRootPart2 and Humanoid3 and Humanoid3.Health > 0 and (v474.Position - HumanoidRootPart2.Position).Magnitude <= t3.Killer_SpamHitRadius then
						v477 = true

						break
					end
				end
			end

			if v477 and v476 then
				pcall(function()
					v476:FireServer()
				end)
			end
		end
	end

	local now2

	if Humanoid2 then
		if t3.Killer_WalkSpeedToggle and Humanoid2.WalkSpeed < t3.Killer_WalkSpeed and Humanoid2.MoveDirection.Magnitude > 0 then
			Character:TranslateBy(Humanoid2.MoveDirection * ((t3.Killer_WalkSpeed - Humanoid2.WalkSpeed) * dt))
		end

		if t3.Misc_HighJump then
			Humanoid2.UseJumpPower = true
			Humanoid2.JumpPower = t3.Misc_JumpPower
		end

		if t3.Surv_GodMode then
			local v483 = Character:GetAttribute("Knocked") == true

			if v483 or v53(Humanoid2) then
				Humanoid2.Health = Humanoid2.MaxHealth

				if v483 then
					Character:SetAttribute("Knocked", false)
				end
			end

			if t3.Killer_BreakS and v46() ~= "Survivor" then
				Character:SetAttribute("breakspeed", t3.Killer_BreakSpeed)
			end

			if Character and v46() ~= "Killer" then
				if t3.Surv_Perks then
					if Character:GetAttribute("vaultspeed") ~= t3.Surv_VaultSpeed then
						Character:SetAttribute("vaultspeed", t3.Surv_VaultSpeed)
					end

					if Character:GetAttribute("skillcheckspeed") ~= t3.Surv_SkillSpeed then
						Character:SetAttribute("skillcheckspeed", t3.Surv_SkillSpeed)
					end
				end

				if t3.Surv_FastVault then
					local v484 = not t5.FlowstateOnCD

					if Character:GetAttribute("Flowstate") ~= v484 then
						Character:SetAttribute("Flowstate", v484)
					end
				elseif Character:GetAttribute("Flowstate") == true then
					Character:SetAttribute("Flowstate", false)
				end
			end

			if t3.ESP_Hitbox then
				lib4.UpdateKillerCone()
			end

			if t3.ESP_FaceLine then
				lib4.UpdateKillerFaceLine()
			end

			if t3.ESP_Master then
				now2 = tick()

				if now2 - t5.lastUpdate > 1 then
					lib4.UpdatePlayerESP()
					lib4.UpdateSCPESP()
					t5.lastUpdate = now2

					return
				end
			end
		else
			if t3.Killer_BreakS and v46() ~= "Survivor" then
				Character:SetAttribute("breakspeed", t3.Killer_BreakSpeed)
			end

			if not Character or v46() == "Killer" then
				if t3.ESP_Hitbox then
					lib4.UpdateKillerCone()
				end

				if t3.ESP_FaceLine then
					lib4.UpdateKillerFaceLine()
				end

				if t3.ESP_Master then
					now2 = tick()

					if now2 - t5.lastUpdate > 1 then
						lib4.UpdatePlayerESP()
						lib4.UpdateSCPESP()
						t5.lastUpdate = now2

						return
					end
				end
			else
				if t3.Surv_Perks then
					if Character:GetAttribute("vaultspeed") ~= t3.Surv_VaultSpeed then
						Character:SetAttribute("vaultspeed", t3.Surv_VaultSpeed)
					end

					if Character:GetAttribute("skillcheckspeed") ~= t3.Surv_SkillSpeed then
						Character:SetAttribute("skillcheckspeed", t3.Surv_SkillSpeed)
					end
				end

				if t3.Surv_FastVault then
					local v485 = not t5.FlowstateOnCD

					if Character:GetAttribute("Flowstate") == v485 then
						if t3.ESP_Hitbox then
							lib4.UpdateKillerCone()
						end

						if t3.ESP_FaceLine then
							lib4.UpdateKillerFaceLine()
						end

						if t3.ESP_Master then
							now2 = tick()

							if now2 - t5.lastUpdate > 1 then
								lib4.UpdatePlayerESP()
								lib4.UpdateSCPESP()
								t5.lastUpdate = now2

								return
							end
						end
					else
						Character:SetAttribute("Flowstate", v485)

						if t3.ESP_Hitbox then
							lib4.UpdateKillerCone()
						end

						if t3.ESP_FaceLine then
							lib4.UpdateKillerFaceLine()
						end

						if t3.ESP_Master then
							now2 = tick()

							if now2 - t5.lastUpdate > 1 then
								lib4.UpdatePlayerESP()
								lib4.UpdateSCPESP()
								t5.lastUpdate = now2

								return
							end
						end
					end
				elseif Character:GetAttribute("Flowstate") == true then
					Character:SetAttribute("Flowstate", false)

					if t3.ESP_Hitbox then
						lib4.UpdateKillerCone()
					end

					if t3.ESP_FaceLine then
						lib4.UpdateKillerFaceLine()
					end

					if t3.ESP_Master then
						now2 = tick()

						if now2 - t5.lastUpdate > 1 then
							lib4.UpdatePlayerESP()
							lib4.UpdateSCPESP()
							t5.lastUpdate = now2

							return
						end
					end
				else
					if t3.ESP_Hitbox then
						lib4.UpdateKillerCone()
					end

					if t3.ESP_FaceLine then
						lib4.UpdateKillerFaceLine()
					end

					if t3.ESP_Master then
						now2 = tick()

						if now2 - t5.lastUpdate > 1 then
							lib4.UpdatePlayerESP()
							lib4.UpdateSCPESP()
							t5.lastUpdate = now2

							return
						end
					end
				end
			end
		end
	else
		if t3.ESP_Hitbox then
			lib4.UpdateKillerCone()
		end

		if t3.ESP_FaceLine then
			lib4.UpdateKillerFaceLine()
		end

		if t3.ESP_Master then
			now2 = tick()

			if now2 - t5.lastUpdate > 1 then
				lib4.UpdatePlayerESP()
				lib4.UpdateSCPESP()
				t5.lastUpdate = now2
			end
		end
	end
end)

local function v486(p200)
	if not p200 then
		return
	end

	t5.VaultBoostActive = false
	t5.QuickRecoveryOnCD = false

	if t5.VaultBoostThread then
		task.cancel(t5.VaultBoostThread)
		t5.VaultBoostThread = nil
	end

	if t5.SpeedConn then
		t5.SpeedConn:Disconnect()
		t5.SpeedConn = nil
	end

	if v46() == "Survivor" and t3.Surv_Perks and t3.Surv_Spdb then
		p200:SetAttribute("speedboost", t3.Surv_SpeedBoost)
	end

	t5.SpeedConn = p200:GetAttributeChangedSignal("speedboost"):Connect(function()
		if t5.Unloaded or v46() == "Killer" then
			return
		end

		local attribute = p200:GetAttribute("speedboost") or 1
		local Surv_SpeedBoost = t3.Surv_SpeedBoost or 1.1

		if t3.Surv_SpeedAfterVault and t5.VaultBoostActive then
			if attribute ~= 1.35 then
				p200:SetAttribute("speedboost", 1.35)
			end

			return
		end

		if t3.Surv_Perks and t3.Surv_Spdb then
			if attribute == 1 then
				p200:SetAttribute("speedboost", Surv_SpeedBoost)
			elseif attribute < 1 and t3.Surv_NoFall then
				p200:SetAttribute("speedboost", Surv_SpeedBoost)
			end
		end
	end)
end

t1.UserInputService.JumpRequest:Connect(function()
	if t3.Misc_InfJump and t1.LocalPlayer.Character then
		local Humanoid2 = t1.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

		if Humanoid2 then
			Humanoid2:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)
t1.LocalPlayer.CharacterRemoving:Connect(function()
	u25 = nil
	HumanoidRootPart = nil
	Humanoid = nil
end)
t1.LocalPlayer.CharacterAdded:Connect(function(character)
	v44(character)
	v486(character)
	v334(character)
	v79()
	v112(t1.LocalPlayer.Character)

	if not t3.Killer_3rdPerson then
		if v47(t1.LocalPlayer) then
			t1.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
			t1.LocalPlayer.CameraMinZoomDistance = 0.5
			t1.LocalPlayer.CameraMaxZoomDistance = 0.5
		else
			t1.LocalPlayer.CameraMode = Enum.CameraMode.Classic
			t1.LocalPlayer.CameraMinZoomDistance = 8
			t1.LocalPlayer.CameraMaxZoomDistance = 30
		end
	end

	v36.SkillCheck()
end)
t1.LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
	v113()

	local Character = t1.LocalPlayer.Character

	if Character then
		v486(Character)
		v334(Character)
	end
end)

if t1.LocalPlayer.Character then
	v44(t1.LocalPlayer.Character)
	v486(t1.LocalPlayer.Character)
	v334(t1.LocalPlayer.Character)
	v36.SkillCheck()
	v112(t1.LocalPlayer.Character)
	v36.SkillS(t1.LocalPlayer.Character)
end

lib4.ScanMap()
v74()
v113()
task.spawn(function()
	local n7 = 0
	local connection2 = t1.RunService.RenderStepped:Connect(function()
		n7 += 1
	end)
	local Remotes3 = t1.ReplicatedStorage:WaitForChild("Remotes", 5)
	local Healing = Remotes3 and Remotes3:FindFirstChild("Healing")
	local HealEvent = Healing and Healing:FindFirstChild("HealEvent")
	local Halloween = Remotes3 and Remotes3:FindFirstChild("Events") and Remotes3.Events:FindFirstChild("Halloween")
	local Crush = Halloween and Halloween:FindFirstChild("Crush")
	local v498 = false

	if not t5.Unloaded then
		local Animator

		repeat
			task.wait(1)

			local v500 = n7

			n7 = 0

			local n8 = 0

			pcall(function()
				local value = t1.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()

				n8 = math.round(value)
				t5.CurrentPing = value / 1000
			end)

			if t12.Watermark then
				t12.Watermark.Text.Text = string.format("VD_T | %d FPS | %dms", v500, n8)

				if n8 < 80 then
					t12.Watermark.Text.TextColor3 = Color3.fromRGB(85, 255, 127)
				elseif n8 < 150 then
					t12.Watermark.Text.TextColor3 = Color3.fromRGB(255, 255, 0)
				else
					t12.Watermark.Text.TextColor3 = Color3.fromRGB(255, 85, 85)
				end
			end

			lib4.UpdateStaticESP()

			local v503 = false
			local Character = t1.LocalPlayer.Character
			local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")

			if Character and HumanoidRootPart2 and Humanoid2 then
				local v507, v508, v509, v510, hb

				if t3.Surv_SelfHeal and Humanoid2.Health > 0 and Humanoid2.Health < 99 then
					v503 = true
					pcall(function()
						if HealEvent then
							HealEvent:FireServer(HumanoidRootPart2, true)
						end
					end)
					v498 = v503

					if t3.AutoCrush_Pumpkin and Crush and t8.Pumpkins then
						v507, v508, v509 = ipairs(t8.Pumpkins)
						v510 = geniter(v507, v508, v509)

						while true do
							local v512 = table.pack(v510())

							if not v512[1] then
								break
							end

							hb = (v512[3]).hb

							if hb and hb.Parent then
								if (hb.Position - HumanoidRootPart2.Position).Magnitude <= 20 then
									pcall(function()
										Crush:FireServer(hb)
									end)

									break
								end
							end
						end
					end
				else
					local ok = not v498

					if not ok then
						Animator = Humanoid2:FindFirstChildOfClass("Animator")
						ok = not Animator
					end

					if ok then
						v498 = v503

						if t3.AutoCrush_Pumpkin and Crush and t8.Pumpkins then
							v507, v508, v509 = ipairs(t8.Pumpkins)
							v510 = geniter(v507, v508, v509)

							while true do
								local v514 = table.pack(v510())

								if not v514[1] then
									break
								end

								hb = (v514[3]).hb

								if hb and hb.Parent then
									if (hb.Position - HumanoidRootPart2.Position).Magnitude <= 20 then
										pcall(function()
											Crush:FireServer(hb)
										end)

										break
									end
								end
							end
						end
					else
						local v515, v516, v517 = pairs(Animator:GetPlayingAnimationTracks())

						for _, v in v515, v516, v517 do
							v:Stop()
						end

						v498 = v503

						if t3.AutoCrush_Pumpkin and Crush and t8.Pumpkins then
							v507, v508, v509 = ipairs(t8.Pumpkins)
							v510 = geniter(v507, v508, v509)

							while true do
								local v520 = table.pack(v510())

								if not v520[1] then
									break
								end

								hb = (v520[3]).hb

								if hb and hb.Parent then
									if (hb.Position - HumanoidRootPart2.Position).Magnitude <= 20 then
										pcall(function()
											Crush:FireServer(hb)
										end)

										break
									end
								end
							end
						end
					end
				end
			end
		until t5.Unloaded
	end

	connection2:Disconnect()
end)
task.spawn(function()
	local Remotes3 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
	local Mapinfo = Remotes3 and Remotes3:FindFirstChild("Mapinfo", true)

	if Mapinfo and Mapinfo:IsA("RemoteEvent") then
		Mapinfo.OnClientEvent:Connect(function(p201)
			if p201 and t3.Next_Map then
				pcall(function()
					if lib then
						v38("Next Map: " .. tostring(p201), 10, 18595195017)
					end
				end)
			end
		end)
	end
end)
task.spawn(function()
	while not t5.Unloaded do
		task.wait(1)

		for _, player in ipairs(t1.Players:GetPlayers()) do
			local Character = player.Character

			if player ~= t1.LocalPlayer and v47(player) and Character and not Character:GetAttribute("StunEventAdded") then
				Character:SetAttribute("StunEventAdded", true)
				Character:GetAttributeChangedSignal("IsStunned"):Connect(function()
					if t3.Show_Stun then
						if not t5.Unloaded then
							local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")

							if not Character:GetAttribute("IsStunned") then
								if Character:FindFirstChild("StunIn") then
									Character.StunIn:Destroy()
								end

								if HumanoidRootPart2 and HumanoidRootPart2:FindFirstChild("StunHitSound") then
									HumanoidRootPart2.StunHitSound:Destroy()
								end
							elseif HumanoidRootPart2 and not Character:FindFirstChild("StunIn") then
								local Sound = Instance.new("Sound", HumanoidRootPart2)

								Sound.Name = "StunHitSound"
								Sound.Volume = 5
								Sound.SoundId = "rbxassetid://140209514807090"
								Sound:Play()
								Sound.Ended:Connect(function()
									Sound:Destroy()
								end)
								lib4.CreateEsp(Character, "StunIn", {
									name = "stunned",
									color = Color3.fromRGB(255, 255, 0),
									offsetY = 5.5
								})
							end

							return
						end
					end
				end)
			end
		end
	end
end)
task.spawn(function()
	local ok, result = pcall(function()
		local Modules = t1.ReplicatedStorage:WaitForChild("Modules", 5)
		local Survivors = Modules and Modules:WaitForChild("Survivors", 5)

		return Survivors and require(Survivors:WaitForChild("SurvivorVault", 5))
	end)

	if ok and result then
		local evaluate = result.evaluate

		result.evaluate = function(p202, p203)
			if t3.Surv_PerfectVault then
				return true, "ready", 5
			end

			return evaluate(p202, p203)
		end
	end

	local ok2, result2 = pcall(function()
		local Modules = t1.ReplicatedStorage:WaitForChild("Modules", 5)
		local Survivors = Modules and Modules:WaitForChild("Survivors", 5)

		return Survivors and require(Survivors:WaitForChild("SurvivorAnimationsController", 5))
	end)

	if not ok2 or not result2 then
		return
	end

	if rawget(result2, "_onSkillCheckFail") then
		local _onSkillCheckFail = result2._onSkillCheckFail

		result2._onSkillCheckFail = function(p204, p205, p206)
			local v538 = _onSkillCheckFail(p204, p205, p206)

			if t3.Surv_NoFall then
				p204.cantupdatespeed = false

				if p204.humanoidRootPart then
					p204.humanoidRootPart.Anchored = false
				end
			end

			return v538
		end
	end
end)
