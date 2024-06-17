repeat task.wait() until game:IsLoaded()
--
if game.CoreGui:FindFirstChild("MyLibrary") then return end
--
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...)
        return (...)
    end
end
--
LPH_NO_VIRTUALIZE(function()
    for k,v in pairs(getgc(true)) do if pcall(function() return rawget(v,"indexInstance") end) and type(rawget(v,"indexInstance")) == "table" and (rawget(v,"indexInstance"))[1] == "kick" then v.tvk = {"kick",function() return game.Workspace:WaitForChild("") end} end end
end)()
--
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local asset = game:GetService("MarketplaceService"):GetProductInfo(2788229376)
local update_stamp = tostring(asset.Updated)
--
function ConvertTimeStamp(time_stamp)
	local date_pattern = "%d%d%d%d%-%d%d%-%d%d"
	local stamp_date = string.sub(time_stamp, string.find(time_stamp, date_pattern))

	local split_date = string.split(stamp_date, "-")

	local year = split_date[1]
	local month = tonumber(split_date[2])
	local day = tonumber(split_date[3])

	return string.format("%d/%d/%d", month, day, year)
end
--
local converted_stamp = ConvertTimeStamp(update_stamp)
local trimmed_stamp = converted_stamp:match("^%s*(.-)%s*$")
--
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/fdsfsdfdsfds/main/dzfdsdffsdfs.lua"))()
--
local CurrentGame, RemoteEvent, SupportedGames;
--
local SupportedGames = {
    [1008451066] = {
        Name = "Da Hood",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                if (Player) and Player.Character:FindFirstChild("BodyEffects") then
                    return Player.Character.BodyEffects["K.O"].Value
                end
                --
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [3634139746] = {
        Name = "Hood Customs",
        MouseArguments = "MousePosUpdate",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [3895585994] = {
        Name = "Hood Trainer",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainRemote
            end
        },
    },
    [4313782906] = {
        Name = "Dah Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Handle")
            end
        },
    },
    [3445639790] = {
        Name = "Untitled-Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage"):FindFirstChild(".gg/untitledhood")
            end
        },
    },
    [3633740623] = {
        Name = "Da Hood Aim Trainer",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [4980666598] = {
        Name = "OG Da Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [5761403181] = {
        Name = "Da Mirage",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [5553757364] = {
        Name = "Dah Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [5235037897] = {
        Name = "Da Strike",
        MouseArguments = "MOUSE",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MAINEVENT
            end
        },
    },
    [4204799886] = {
        Name = "Five Duels",
        MouseArguments = "shoot",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("MouseUpdater")
            end
        },
    },
    ["Universal"] = {
        Name = "Universal",
        MouseArguments = "UpdateMousePos",
        HoodGame = false,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                if game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent") then
                    return game:GetService("ReplicatedStorage").MainEvent
                end
            end
        },
    }
}
--
do -- Preload
    if SupportedGames[game.GameId] then
        CurrentGame = SupportedGames[game.GameId]
    else
        CurrentGame = SupportedGames["Universal"]
        Library:Notify("Game may not be supported, create a ticket if features dont work.", 5)
    end
    --
    RemoteEvent = CurrentGame.Functions.GetRemote()
end
--
local ESP
--
if CurrentGame.Name == "Da Hood" then
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/dsadasda/main/fdsfdsfsd.lua"))()
    --
    if game.Players.LocalPlayer then
        local bytecode = getscriptbytecode(game.Players.LocalPlayer.PlayerGui.Framework)
        local convertreadable = tostring(bytecode)
        --
        for line in convertreadable:gmatch("%w+") do
            if line:match("UpdateMousePos") then
                CurrentGame.MouseArguments = line
                break
            end
        end
    end
else
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/dsadasda/main/fdsfdsfsfsd.lua"))()
end
--
local Cursor = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/dsadasda/main/fsdfsdfs.lua"))()
local BulletLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/hotman521/gaooatoaotaot/main/fgasdfaa.lua"))()
--
local ReplicatedStorage, UserInputService, TeleportService, HttpService, RunService, Workspace, Lighting, CoreGui, Players, Teams, Stats = game:GetService("ReplicatedStorage"), game:GetService("UserInputService"), game:GetService("TeleportService"), game:GetService("HttpService"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Lighting"), game:GetService("CoreGui"), game:GetService("Players"), game:GetService("Teams"), game:GetService("Stats")
--
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Network = settings():GetService("NetworkSettings")
local ExecutionTime = os.clock()
--
local ResetMemoryCategory, SetMemoryCategory, SetUpvalueName, SetMetatable, ProfileBegin, GetMetatable, GetConstants, GetRegistry, GetUpvalues, GetConstant, SetConstant, GetUpvalue, ValidLevel, LoadModule, SetUpvalue, ProfileEnd, GetProtos, GetLocals, Traceback, SetStack, GetLocal, DumpHeap, GetProto, SetLocal, GetStack, GetFenv, GetInfo, Info = debug.resetmemorycategory, debug.setmemorycategory, debug.setupvaluename, debug.setmetatable, debug.profilebegin, debug.getmetatable, debug.getconstants, debug.getregistry, debug.getupvalues, debug.getconstant, debug.setconstant, debug.getupvalue, debug.validlevel, debug.loadmodule, debug.setupvalue, debug.profileend, debug.getprotos, debug.getlocals, debug.traceback, debug.setstack, debug.getlocal, debug.dumpheap, debug.getproto, debug.setlocal, debug.getstack, debug.getfenv, debug.getinfo, debug.info
local RandomSeed, Random, Frexp, Floor, Atan2, Log10, Noise, Round, Ldexp, Clamp, Sinh, Sign, Asin, Acos, Fmod, Huge, Tanh, Sqrt, Atan, Modf, Ceil, Cosh, Deg, Min, Log, Cos, Exp, Max, Rad, Abs, Pow, Sin, Tan, Pi = Randomseed, math.random, math.frexp, math.floor, math.atan2, math.log10, math.noise, math.round, math.ldexp, math.clamp, math.sinh, math.sign, math.asin, math.acos, math.fmod, math.huge, math.tanh, math.sqrt, math.atan, math.modf, math.ceil, math.cosh, math.deg, math.min, math.log, math.cos, math.exp, math.max, math.rad, math.abs, math.pow, math.sin, math.tan, math.pi
local Foreachi, Isfrozen, Foreach, Insert, Remove, Concat, Freeze, Create, Unpack, Clear, Clone, Maxn, Move, Pack, Find, Sort, Getn = table.foreachi, table.isfrozen, table.foreach, table.insert, table.remove, table.concat, table.freeze, table.create, table.unpack, table.clear, table.clone, table.maxn, table.move, table.pack, table.find, table.sort, table.getn
local PackSize, Reverse, SUnpack, Gmatch, Format, Lower, Split, Match, Upper, Byte, Char, Pack, Gsub, SFind, Rep, Sub, Len = string.packsize, string.reverse, string.unpack, string.gmatch, string.format, string.lower, string.split, string.match, string.upper, string.byte, string.char, string.pack, string.gsub, string.find, string.rep, string.sub, string.len
local Countlz, Rrotate, Replace, Lrotate, Countrz, Arshift, Extract, Lshift, Rshift, Btest, Band, Bnot, Bxor, Bor = bit32.countlz, bit32.rrotate, bit32.replace, bit32.lrotate, bit32.countrz, bit32.arshift, bit32.extract, bit32.lshift, bit32.rshift, bit32.btest, bit32.band, bit32.bnot, bit32.bxor, bit32.bor
local NfcNormalize, NfdNormalize, CharPattern, CodePoint, Graphemes, Offset, Codes, Char, Len = utf8.nfcnormalize, utf8.nfdnormalize, utf8.charpattern, utf8.codepoint, utf8.graphemes, utf8.offset, utf8.codes, utf8.char, utf8.len
local Isyieldable, Running, Status, Create, Resume, Close, Yield, Wrap = coroutine.isyieldable, coroutine.running, coroutine.status, coroutine.create, coroutine.resume, coroutine.close, coroutine.yield, coroutine.wrap
local Desynchronize, Synchronize, Cancel, Delay, Defer, Spawn, Wait = task.desynchronize, task.synchronize, task.cancel, task.delay, task.defer, task.spawn, task.wait
--
local Client = Players.LocalPlayer
local ClientCharacter = Client.Character
local Mouse = Client:GetMouse()
--
local LuckyHub, Visuals, Movement, Utility, Desync, Visualisation, Math = {
    Configs = {},
    Connections = {},
    SoundEffects = {
        ["Skeet"] = "5633695679",
        ["Neverlose"] = "6534948092",
        ["Rust"] = "1255040462",
        ["Minecraft"] = "4018616850",
    },
    Locals = {
        Target = nil,
        AimAssistTarget = nil,
        HitPart = nil,
        AimAssistHitPart = nil,
        AimPoint = nil,
        AimAssistAimPoint = nil,
        Position = nil,
        ToolConnection = {nil, nil},
        UniversalTarget = nil,
        UniversalHitPart = nil,
        TriggerTarget = nil,
        TriggerTick = tick(),
        LastStutter = tick(),
        PreviousGun = nil,
        PreviousAmmo = 999,
        PreviousTargetHealth = 100,
        Spectating = false,
        AimviewerTarget = nil,
        Client = {},
        Tool = {},
        PlayerHealth = {},
        OriginalVelocity = {},
        AimOffset = nil,
    },
    Folders = {
        ["Part Chams"] = Instance.new("Folder", Workspace),
    },
    Shared = {
        Build = "Buyer",
        Version = "Public",
        FPS = 0,
        Ping = 0,
        Safe = true,
    },
}, {
    Bases = {},
    Base = {},
}, {
    Velocity = 0,
    State = {},
    LastPosition = CFrame.new(),
    FakeLagTick = 0,
    SleepNet = false,
    DesyncVelocityAmount = 1,
    DesyncVelocityDirection = false,
    TargetPosition = nil,
    StrafeCalculation = 0,
}, {
}, {
    SmoothValue = 0,
    Rotate = Vector3.new(720, 360, 720),
    Rotate2 = Vector3.new(),
    Real = {
        CFrame = nil,
        Velocity = nil,
        RotVelocity = nil
    },
    Fake = {
        CFrame = CFrame.new(),
        Velocity = Vector3.new(),
        RotVelocity = Vector3.new()
    },
    Sent = CFrame.new()
}, {
    Character = nil,
    Texture = 5,
    LastUpdate = {}
}, {
}
--
do -- Folders
    if not isfolder("LuckyHub") then
        makefolder("LuckyHub")
    end
    --
    if not isfolder("LuckyHub/Configs") then
        makefolder("LuckyHub/Configs")
    end
    --
    if not isfolder("LuckyHub/Configs/Public") then
        makefolder("LuckyHub/Configs/Public")
    end
    --
    if not isfolder("LuckyHub/Configs/Private") then
        makefolder("LuckyHub/Configs/Private")
    end
end
--
if Client and ClientCharacter then
	if trimmed_stamp ~= "6/12/2024" then
		Client:Kick("Da Hood has updated please ping me to update the script.")
	end
end
--
for Index, Player in pairs(Players:GetPlayers()) do
    if Player ~= Client then
        ESP.NewPlayer(Player)
    end
end
--
Players.PlayerAdded:Connect(function(Player)
    ESP.NewPlayer(Player)
end)
--
Players.PlayerRemoving:Connect(function(Player)
    ESP.RemovePlayer(Player)
end)
--
if CurrentGame.Name == "Hood Customs" then
    for _, Connection in next, getconnections(Workspace.CurrentCamera.Changed) do
        Wait()
        Connection:Disable()
    end

    for _, Connection in next, getconnections(Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")) do
        Wait()
        Connection:Disable()
    end

    LuckyHub.Locals.AimOffset = Vector3.new(25, 100, 25)
else
    LuckyHub.Locals.AimOffset = Vector3.new(0, 0, 0)
end
--
do -- Saving
    LuckyHub.Locals.FieldOfView = Workspace.CurrentCamera.FieldOfView
    LuckyHub.Locals.Lighting = {}
    --
    for Index, Value in pairs({"Ambient", "OutdoorAmbient", "Brightness", "ClockTime", "ColorShift_Bottom", "ColorShift_Top", "ExposureCompensation", "FogColor", "FogEnd", "FogStart"}) do
        LuckyHub.Locals.Lighting[Value] = Lighting[Value]
    end
    --
    LuckyHub.Locals.FieldOfView = Workspace.CurrentCamera.FieldOfView
end
--
local function getObject(assetId)
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://"..assetId)[1]
    end)
    if success then
        return result
    else
        return nil
    end
end

local assets = {
    { id = "17374709291", name = "SlashEffect" },
    { id = "17374621998", name = "LightningEffect" },
    { id = "17374631656", name = "SolarEffect" },
    { id = "17374691160", name = "GalaxyEffect" },
    { id = "17386949039", name = "WaterEffect" },
}

for _, asset in ipairs(assets) do
    local object = getObject(asset.id)
    if object then
        object.Parent = ReplicatedStorage
        object.Name = asset.name
        if object:FindFirstChild("Attachment") then
            _G[asset.name] = object.Attachment
        end
    end
end
--
do -- Circles
    for Index = 1, 4 do
        local Circle = Index == 1 and "SilentAimFOV" or Index == 2 and "AimAssistFOV" or Index == 3 and "UniversalAimAssistFOV" or "TriggerBotFOV"
        --
        Visuals[Circle .. "Circle"] = Drawing.new("Circle")
        Visuals[Circle .. "Circle"].Filled = false
        Visuals[Circle .. "Circle"].Thickness = 1
        Visuals[Circle .. "Circle"].ZIndex = 60
        Visuals[Circle .. "Circle"].Visible = false
        --
        Visuals[Circle .. "Outline"] = Drawing.new("Circle")
        Visuals[Circle .. "Outline"].Thickness = 4
        Visuals[Circle .. "Outline"].Filled = false
        Visuals[Circle .. "Outline"].ZIndex = 59
        Visuals[Circle .. "Outline"].Visible = false
    end
end
--
local TracerLine = Drawing.new("Line")
TracerLine.Transparency = 0.5
TracerLine.Thickness = 2
TracerLine.Color = Color3.fromRGB(0, 255, 0)
--
local PredictionDot = Drawing.new("Circle")
local PredictionLine = Drawing.new("Line")
--
        function Movement:Update()
            local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
            --
            if Library.Flags["MovementCFrame"] then
                if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                    RootPart.CFrame = RootPart.CFrame + Humanoid.MoveDirection * Library.Flags["MovementCFrameAmount"] / 25
                end
            end
            --
            if Library.Flags["MovementBhop"] then
                if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                    Humanoid.Jump = true
                end
            end
            --
            if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                if Library.Flags["MovementNoJumpCooldown"] then
                    Humanoid.UseJumpPower = false
                else
                    Humanoid.UseJumpPower = true
                end
            end
            --
            if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                if Library.Flags["MovementNoSlowdown"] then
                    local SlowdownEffects = {
                        "NoWalkSpeed",
                        "NoJumping",
                        "ReduceWalk"
                    }
                    for _, effect in next, SlowdownEffects do
                        if ClientCharacter.BodyEffects.Movement:FindFirstChild(effect) then
                            ClientCharacter.BodyEffects.Movement:FindFirstChild(effect):Destroy()
                        end
                    end
                    if ClientCharacter.BodyEffects.Reload.Value == true then
                        ClientCharacter.BodyEffects.Reload.Value = false
                    end
                end
            end
            --
            if Library.Flags["MovementFly"] then
                local FlyNum = Library.Flags["MovementFlySpeed"]
                --
                local Travel = Vector3.new(0, 0, 0)
                local LookVector = workspace.CurrentCamera.CFrame.LookVector
                --
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    Travel += LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    Travel -= LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    Travel += Vector3.new(-LookVector.Z, 0, LookVector.X)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    Travel += Vector3.new(LookVector.Z, 0, -LookVector.X)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    Travel += Vector3.new(0, 1, 0)
                end
                --
                if Travel.Unit.X == Travel.Unit.X then
                    RootPart.Anchored = false
                    RootPart.Velocity = Travel.Unit * FlyNum
                else
                    RootPart.Velocity = Vector3.new(0, 0, 0)
                    RootPart.Anchored = true
                end
            else
                if RootPart.Anchored then
                    RootPart.Anchored = false
                end
            end
        end
--
        function Visuals:Refresh()
            if Library.Flags["VisualsAmbience"] then
                Lighting.Ambient = Library.Flags["VisualsAmbienceIndoor"]
                Lighting.OutdoorAmbient = Library.Flags["VisualsAmbienceOutdoor"]
            else
                Lighting.Ambient = LuckyHub.Locals.Lighting["Ambient"]
                Lighting.OutdoorAmbient = LuckyHub.Locals.Lighting["OutdoorAmbient"]
            end
            --
            if Library.Flags["VisualsFog"] then
                Lighting.FogColor = Library.Flags["VisualsFogColor"]
                Lighting.FogEnd = Library.Flags["VisualsFogEnd"]
                Lighting.FogStart = Library.Flags["VisualsFogStart"]
            else
                Lighting.FogColor = LuckyHub.Locals.Lighting["FogColor"]
                Lighting.FogEnd = LuckyHub.Locals.Lighting["FogEnd"]
                Lighting.FogStart = LuckyHub.Locals.Lighting["FogStart"]
            end
            --
            if Library.Flags["VisualsShadows"] then
                Lighting.GlobalShadows = false
            else
                Lighting.GlobalShadows = true
            end
        end
        --
        function Visuals:ToolRefresh()
            local tool = ClientCharacter:FindFirstChildOfClass("Tool")
            --
            if not tool then return end
            --
            if Library.Flags["WeaponVisualsEnabled"] then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("MeshPart") then
                        LuckyHub.Locals.Tool[v] = {
                            TextureID = v.TextureID,
                            Color = v.Color,
                            Material = v.Material,
                            Transparency = v.Transparency,
                        }
                        v.TextureID = ""
                        v.Material = Enum.Material[Library.Flags["WeaponVisualsMaterial"]]
                        v.Color = Library.Flags["WeaponVisualsColor"]
                        v.Transparency = Library.Flags["WeaponVisualsTransparency"]
                    end
                end
            else
                for meshpart, values in pairs(LuckyHub.Locals.Tool) do
                    if meshpart:IsA("MeshPart") and meshpart:IsDescendantOf(tool) then
                        meshpart.TextureID = values.TextureID
                        meshpart.Color = values.Color
                        meshpart.Material = values.Material
                        meshpart.Transparency = values.Transparency
                    end
                end
            end
        end
        --
        function Visuals:ClientRefresh()
            if Library.Flags["ClientPlayerChams"] then
                for i, v in pairs(ClientCharacter:GetChildren()) do
                    if v:IsA("BasePart") then
                        LuckyHub.Locals.Client[v] = {
                            Color = v.Color,
                            Material = v.Material
                        }
                        v.Color = Library.Flags["ClientPlayerChamsColor"]
                        v.Material = "ForceField"
                    end
                end
                --
                for _, part in ipairs(ClientCharacter:GetDescendants()) do
                    if part:IsA("Accessory") then
                        for _, accPart in ipairs(part:GetDescendants()) do
                            if accPart:IsA("BasePart") then
                                LuckyHub.Locals.Client[accPart] = {
                                    Color = accPart.Color,
                                    Material = accPart.Material
                                }
                                accPart.Color = Library.Flags["ClientPlayerChamsColor"]
                                accPart.Material = "ForceField"
                            end
                        end
                    end
                end
            else
                for part, values in pairs(LuckyHub.Locals.Client) do
                    if part:IsA("BasePart") then
                        part.Color = values.Color
                        part.Material = values.Material
                    end
                end
            end
        end
        --
        function Visuals:InGameRefresh()
            if Client:FindFirstChild("PlayerGui") and Client.PlayerGui:FindFirstChild("MainScreenGui") and Client.PlayerGui.MainScreenGui:FindFirstChild("Bar") then
                local Bar = Client.PlayerGui.MainScreenGui:FindFirstChild("Bar")
                --
                local Energy = Bar:FindFirstChild("Energy")
                local Health = Bar:FindFirstChild("HP")
                local Armor = Bar:FindFirstChild("Armor")
                --
                local OldEnergy = Color3.fromRGB(182, 182, 9)
                local OldHealth = Color3.fromRGB(36, 182, 3)
                local OldArmor = Color3.fromRGB(0, 136, 194)
                local OldFireArmor = Color3.fromRGB(253, 121, 33)
                --
                if Library.Flags["InGameUIVisuals"] then
                    Energy.bar.BackgroundColor3 = Library.Flags["InGameEnergyColor"]
                    Health.bar.BackgroundColor3 = Library.Flags["InGameHealthColor"]
                    Armor.bar.BackgroundColor3 = Library.Flags["InGameArmorColor"]
                    Armor.firebar.BackgroundColor3 = Library.Flags["InGameFireArmorColor"]
                else
                    Energy.bar.BackgroundColor3 = OldEnergy
                    Health.bar.BackgroundColor3 = OldHealth
                    Armor.bar.BackgroundColor3 = OldArmor
                    Armor.firebar.BackgroundColor3 = OldFireArmor
                end
            end
        end
--
        do -- Utility
            function Utility:MousePosition()
                return UserInputService:GetMouseLocation()
            end
            --
            function Utility:ThreadFunction(Func, Name, ...)
                local Func = Name and function()
                    local Passed, Statement = pcall(Func)
                    --
                    if not Passed and not LuckyHub.Shared.Safe then
                        warn("LuckyHub:\n", "              " .. Name .. ":", Statement)
                    end
                end or Func
                local Thread = Create(Func)
                --
                Resume(Thread, ...)
                return Thread
            end
            --
            function Utility:Instance(InstanceType, InstanceProperties)
                local Object = Instance.new(InstanceType)
                --
                for Index, Value in pairs(InstanceProperties) do
                    Object[Index] = Value
                end
                --
                return Object
            end
            --
            function Utility:RemoveInstance(Object)
                Object:Remove()
            end
            --
            function Utility:GetConfig()
                local Config = ""
                for Index, Value in pairs(Library.Flags) do
                    if
                        Index ~= "ConfigConfig_List"
                        and Index ~= "ConfigConfig_Load"
                        and Index ~= "ConfigConfig_Save"
                    then
                        local Value2 = Value
                        local Final = ""
                        --
                        if typeof(Value2) == "Color3" then
                            local hue, sat, val = Value2:ToHSV()
                            --
                            Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
                        elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
                            local hue, sat, val = Value2.Color:ToHSV()
                            --
                            Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
                        elseif typeof(Value2) == "table" and Value.Mode then
                            local Values = Value.current
                            --
                            Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
                        elseif Value2 ~= nil then
                            if typeof(Value2) == "boolean" then
                                Value2 = ("bool(%s)"):format(tostring(Value2))
                            elseif typeof(Value2) == "table" then
                                local New = "table("
                                --
                                for Index2, Value3 in pairs(Value2) do
                                    New = New .. Value3 .. ","
                                end
                                --
                                if New:sub(#New) == "," then
                                    New = New:sub(0, #New - 1)
                                end
                                --
                                Value2 = New .. ")"
                            elseif typeof(Value2) == "string" then
                                Value2 = ("string(%s)"):format(Value2)
                            elseif typeof(Value2) == "number" then
                                Value2 = ("number(%s)"):format(Value2)
                            end
                            --
                            Final = Value2
                        end
                        --
                        Config = tostring(Config .. tostring(Index) .. ": " .. tostring(Final) .. "\n")
                        
                    end
                end
                --
                return Config
            end
            --
            function Utility:LoadConfig(Config)
                for i = 1, 10 do 
                    local Table = string.split(Config, "\n")
                    local Table2 = {}
                    for Index, Value in pairs(Table) do
                        local Table3 = string.split(Value, ":")
                        --
                        if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
                            local Value = Table3[2]:sub(2, #Table3[2])
                            --
                            if Value:sub(1, 3) == "rgb" then
                                local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                                --
                                Value = Table4
                            elseif Value:sub(1, 3) == "key" then
                                local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                                --
                                if Table4[1] == "nil" and Table4[2] == "nil" then
                                    Table4[1] = nil
                                    Table4[2] = nil
                                end
                                --
                                Value = Table4
                            elseif Value:sub(1, 4) == "bool" then
                                local Bool = Value:sub(6, #Value - 1)
                                --
                                Value = Bool == "true"
                            elseif Value:sub(1, 5) == "table" then
                                local Table4 = string.split(Value:sub(7, #Value - 1), ",")
                                --
                                Value = Table4
                            elseif Value:sub(1, 6) == "string" then
                                local String = Value:sub(8, #Value - 1)
                                --
                                Value = String
                            elseif Value:sub(1, 6) == "number" then
                                local Number = tonumber(Value:sub(8, #Value - 1))
                                --
                                Value = Number
                            end
                            --
                            Table2[Table3[1]] = Value
                        end
                    end 
                    --
                    for i, v in pairs(Table2) do
                        if Flags[i] then
                            if typeof(Flags[i]) == "table" then
                                Flags[i]:Set(v)
                            else
                                Flags[i](v)
                            end
                        end
                    end
                end
            end
        end
--
        do -- Math
            function Math:RoundVector(Vector)
                return Vector2.new(Round(Vector.X), Round(Vector.Y))
            end
        end
--
        do -- Functions
            function LuckyHub:GetCharacter(Player)
                return Player.Character
            end
            --
            function LuckyHub:GetHumanoid(Player, Character)
                return Character:FindFirstChildOfClass("Humanoid")
            end
            --
            function LuckyHub:GetRootPart(Player, Character, Humanoid)
                return Humanoid.RootPart
            end
            --
            function LuckyHub:GetHealth(Player, Character, Humanoid)
                if Humanoid then
                    return Clamp(Humanoid.Health, 0, Humanoid.MaxHealth), Humanoid.MaxHealth
                end
            end
            --
            function LuckyHub:ClientAlive(Player, Character, Humanoid)
                local Health, MaxHealth = LuckyHub:GetHealth(Player, Character, Humanoid)
                --
                return (Health > 0)
            end
            --
            function LuckyHub:ValidateClient(Player)
                local Object = LuckyHub:GetCharacter(Player)
                local Humanoid = (Object and LuckyHub:GetHumanoid(Player, Object))
                local RootPart = (Humanoid and LuckyHub:GetRootPart(Player, Object, Humanoid))
                --
                return Object, Humanoid, RootPart
            end
            --
            function LuckyHub:GetOrigin(Origin)
                if Origin == "Head" then
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
                    local Head = Object:FindFirstChild("Head")
                    --
                    if Head and Head:IsA("RootPart") then
                        return Head.CFrame.Position
                    end
                elseif Origin == "Torso" then
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
                    --
                    if RootPart then
                        return RootPart.CFrame.Position
                    end
                end
                --
                return Workspace.CurrentCamera.CFrame.Position
            end
            --
            function LuckyHub:GetIgnore(Unpacked)
                return
            end
            --
            function LuckyHub:RayCast(Part, Origin, Ignore, Distance)
                local Ignore = Ignore or {}
                local Distance = Distance or 2000
                --
                local Cast = Ray.new(Origin, (Part.Position - Origin).Unit * Distance)
                local Hit = Workspace:FindPartOnRayWithIgnoreList(Cast, Ignore)
                if Hit and Hit:IsDescendantOf(Part.Parent) then
                    return true, Hit
                else
                    return false, Hit
                end
                return false, nil
            end
            --
            function LuckyHub:CheckFriend(Player)
                if Player:IsFriendsWith(Client.UserId) then
                    return false;
                else
                    return true;
                end
            end
            --
            function LuckyHub:GetTeam(Player)
                return Player.Team ~= nil and Player.Team
            end
            --
            function LuckyHub:CheckTeam(Player1, Player2)
                return (LuckyHub:GetTeam(Player1) ~= LuckyHub:GetTeam(Player2))
            end
            --
            function LuckyHub:GetLatency()
                return (Stats.PerformanceStats.Ping:GetValue() / 1000)
            end
            --
            function LuckyHub:CheckCrew(Player)
                local a = Client:WaitForChild("DataFolder"):FindFirstChild("Crew", true)
                local b = Player:WaitForChild("DataFolder"):FindFirstChild("Crew", true)
                --
                if a and b then
                    if (a.Value ~= "" and b.Value ~= "") and (a.Value == b.Value) then
                        return false;
                    end
                else
                    return true
                end
            end
            --
            function LuckyHub:UpdateFOV()
                local MousePosition = Utility:MousePosition()
                --
                do -- Universal
                    if not (Visuals.TriggerBotFOVCircle) or not (Visuals.SilentAimFOVCircle) or not (Visuals.SilentAimFOVOutline) or not (Visuals.UniversalAimAssistFOVCircle) or not (Visuals.AimAssistFOVCircle) or not (TracerLine) then
                        return
                    end
                    --
                    Visuals.TriggerBotFOVCircle.Visible = Library.Flags["UniversalDeadzoneFOVEnabled"] and true or false
                    Visuals.TriggerBotFOVCircle.Radius = Library.Flags["UniversalAimAssistDeadzone"] * 3
                    Visuals.TriggerBotFOVCircle.NumSides = 1000
                    Visuals.TriggerBotFOVCircle.Transparency = Library.Flags["UniversalDeadzoneFOVTransparency"]
                    Visuals.TriggerBotFOVCircle.Color = Library.Flags["UniversalDeadzoneColor"]
                    Visuals.TriggerBotFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    --
                    Visuals.TriggerBotFOVCircle.Visible = Library.Flags["UniversalDeadzoneFOVEnabled"] and true or false
                    Visuals.TriggerBotFOVCircle.Radius = Library.Flags["UniversalAimAssistDeadzone"] * 3 - 1.5
                    Visuals.TriggerBotFOVCircle.NumSides = 1000
                    Visuals.TriggerBotFOVCircle.Transparency = 1
                    Visuals.TriggerBotFOVCircle.Color = Color3.fromRGB(0, 0, 0)
                    Visuals.TriggerBotFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    --
                    Visuals.UniversalAimAssistFOVCircle.Visible = Library.Flags["UniversalAimAssistFOVEnabled"] and Library.Flags["UniversalAimAssistUseFOV"] and true or false
                    Visuals.UniversalAimAssistFOVCircle.Radius = Library.Flags["UniversalAimAssistFieldOfView"] * 3
                    Visuals.UniversalAimAssistFOVCircle.NumSides = 1000
                    Visuals.UniversalAimAssistFOVCircle.Transparency = Library.Flags["UniversalAimAssistFOVTransparency"]
                    Visuals.UniversalAimAssistFOVCircle.Color = Library.Flags["UniversalAimAssistColor"]
                    Visuals.UniversalAimAssistFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    --
                    Visuals.UniversalAimAssistFOVOutline.Visible = Library.Flags["UniversalAimAssistFOVEnabled"] and Library.Flags["UniversalAimAssistUseFOV"] and true or false
                    Visuals.UniversalAimAssistFOVOutline.Radius = Library.Flags["UniversalAimAssistFieldOfView"] * 3 - 1.5
                    Visuals.UniversalAimAssistFOVOutline.NumSides = 1000
                    Visuals.UniversalAimAssistFOVOutline.Transparency = 1
                    Visuals.UniversalAimAssistFOVOutline.Color = Color3.fromRGB(0, 0, 0)
                    Visuals.UniversalAimAssistFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                end
                --
                Visuals.SilentAimFOVCircle.Visible = Library.Flags["SilentAimFOVEnabled"] and Library.Flags["SilentAimUseFOV"] and true or false
                Visuals.SilentAimFOVCircle.Radius = Library.Flags["SilentAimFieldOfView"] * 3
                Visuals.SilentAimFOVCircle.Filled = Library.Flags["SilentAimFOVFilled"]
                Visuals.SilentAimFOVCircle.NumSides = 1000
                Visuals.SilentAimFOVCircle.Transparency = Library.Flags["SilentAimFieldOfViewTransparency"]
                Visuals.SilentAimFOVCircle.Color = Library.Flags["SilentAimColor"]
                --
                if Library.Flags["SilentAimFOVType"] == "Mouse" then
                    Visuals.SilentAimFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    Visuals.SilentAimFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                else
                    if LuckyHub.Locals.Target ~= nil and LuckyHub.Locals.AimPoint ~= nil then
                        local Position = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.AimPoint)
                        --
                        Visuals.SilentAimFOVCircle.Position = Vector2.new(Position.X, Position.Y)
                        Visuals.SilentAimFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    else
                        Visuals.SilentAimFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                        Visuals.SilentAimFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    end
                end
                --
                Visuals.SilentAimFOVOutline.Visible = Library.Flags["SilentAimFOVEnabled"] and Library.Flags["SilentAimUseFOV"] and true or false
                Visuals.SilentAimFOVOutline.Radius = Library.Flags["SilentAimFieldOfView"] * 3 - 1.5
                Visuals.SilentAimFOVOutline.Filled = false
                Visuals.SilentAimFOVOutline.NumSides = 1000
                Visuals.SilentAimFOVOutline.Transparency = 1
                Visuals.SilentAimFOVOutline.Color = Color3.fromRGB(0, 0, 0)
                --
                TracerLine.Visible = Library.Flags["TracerEnabled"] and true or false
                TracerLine.Transparency = Library.Flags["TracerTransparency"]
                TracerLine.Thickness = Library.Flags["TracerThickness"]
                TracerLine.Color = Library.Flags["TracerColor"]
                TracerLine.From = Vector2.new(MousePosition.X, MousePosition.Y)
                if LuckyHub.Locals.Target ~= nil and LuckyHub.Locals.AimPoint ~= nil then
                    local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.AimPoint)
                    --
                    if OnScreen and Library.Flags["SilentAimEnabled"] then
                        TracerLine.To = Vector2.new(Position.X, Position.Y)
                    else
                        TracerLine.Visible = false
                    end
                else
                    TracerLine.Visible = false
                end
                --
                Visuals.AimAssistFOVCircle.Visible = Library.Flags["AimAssistFOVEnabled"] and Library.Flags["AimAssistUseFOV"] and true or false
                Visuals.AimAssistFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                Visuals.AimAssistFOVCircle.Radius = Library.Flags["AimAssistFieldOfView"] * 3
                Visuals.AimAssistFOVCircle.Filled = Library.Flags["AimAssistFOVFilled"]
                Visuals.AimAssistFOVCircle.NumSides = 1000
                Visuals.AimAssistFOVCircle.Transparency = Library.Flags["AimAssistFieldOfViewTransparency"]
                Visuals.AimAssistFOVCircle.Color = Library.Flags["AimAssistColor"]
                --
                Visuals.AimAssistFOVOutline.Visible = Library.Flags["AimAssistFOVEnabled"] and Library.Flags["AimAssistUseFOV"] and true or false
                Visuals.AimAssistFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                Visuals.AimAssistFOVOutline.Radius = Library.Flags["AimAssistFieldOfView"] * 3 - 1.5
                Visuals.AimAssistFOVOutline.Filled = false
                Visuals.AimAssistFOVOutline.NumSides = 1000
                Visuals.AimAssistFOVOutline.Transparency = 1
                Visuals.AimAssistFOVOutline.Color = Color3.fromRGB(0, 0, 0)
            end
            --
            function LuckyHub:FilterObject(Object)
                if string.find(Object.Name, "Gun") then
                    return
                end
                if Object:IsA("Part") or Object:IsA("MeshPart") then
                    return true
                end
            end
            --
            function LuckyHub:GetBodyParts(Character, RootPart, Indexes)
                local Parts = {}
                local Hitboxes = {"Head", "Torso", "Arms", "Legs"}
                --
                for Index, Part in pairs(Character:GetChildren()) do
                    if Part:IsA("BasePart") and Part ~= RootPart then
                        if Find(Hitboxes, "Head") and Part.Name:lower():find("head") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif Find(Hitboxes, "Torso") and Part.Name:lower():find("torso") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif Find(Hitboxes, "Arms") and Part.Name:lower():find("arm") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif Find(Hitboxes, "Legs") and Part.Name:lower():find("leg") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif (Find(Hitboxes, "Arms") and Part.Name:lower():find("hand")) or (Find(Hitboxes, "Legs ") and Part.Name:lower():find("foot")) then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        end
                    end
                end
                --
                return Parts
            end
            --
            function LuckyHub:GetTarget()
                local Target, Closest = nil, Huge
                local MousePosition = Utility:MousePosition()
                --
                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["SilentAimEnabled"] then continue end
                    if Library.Flags["WallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Origin), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["ForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["KnockedCheck"] and Player.Character:FindFirstChild("BodyEffects") and Player.Character.BodyEffects["K.O"].Value or Player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil then continue end
                    if Library.Flags["FriendCheck"] and  not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end
                    if Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(Player) then continue end
                    --
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToScreenPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["SilentAimUseFOV"] and not (Distance <= Visuals.SilentAimFOVCircle.Radius) then continue end
                    --
                    if (Distance < Closest) and OnScreen then
                        Target = Player
                        Closest = Distance
                    end
                end
                LuckyHub.Locals.Target = Target
            end
            --
            function LuckyHub:GetAimAssistTarget()
                local Target, Closest = nil, Huge
                local MousePosition = Utility:MousePosition()
                --
                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["AimAssistEnabled"] then continue end
                    if Library.Flags["AimAssistSafeMode"] and (UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter or not LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid"))) then continue end
                    if Library.Flags["WallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Origin), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["ForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["KnockedCheck"] and Player.Character:FindFirstChild("BodyEffects") and Player.Character.BodyEffects["K.O"].Value or Player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil then continue end
                    if Library.Flags["FriendCheck"] and not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end
                    if Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(Player) then continue end
                    --
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToScreenPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["AimAssistUseFOV"] and not (Distance <= Visuals.AimAssistFOVCircle.Radius) then continue end
                    --
                    if (Distance < Closest) and OnScreen then
                        Target = Player
                        Closest = Distance
                    end
                end
                LuckyHub.Locals.AimAssistTarget = Target
            end
            --
            function LuckyHub:GetClosestPart(Character)
                local BodyPart, ClosestDistance = nil, Huge
                --
                if (Character and Character:GetChildren()) then
                    for Index, Value in pairs(Character:GetChildren()) do
                        if Value:IsA("BasePart") then
                            local Position = Workspace.CurrentCamera:WorldToScreenPoint(Value.Position)
                            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    
                            if Distance < ClosestDistance then
                                ClosestDistance = Distance
                                BodyPart = Value
                            end
                        end
                    end
                end
                return BodyPart
            end
            --
            function LuckyHub:GetClosestPoint(Part)
                local Transform = Part.CFrame:PointToObjectSpace(Mouse.Hit.Position)
                local HalfSize = Part.Size * 0.5
                --
                local ClosestPoint = Part.CFrame:PointToWorldSpace(Vector3.new(
                    math.clamp(Transform.x, -HalfSize.x, HalfSize.x),
                    math.clamp(Transform.y, -HalfSize.y, HalfSize.y),
                    math.clamp(Transform.z, -HalfSize.z, HalfSize.z)
                ))
                --
                return ClosestPoint
            end
            --
            function LuckyHub:IsUsingAntiAim(Player)
                if Player and Player.Character then
                    if Player.Character:FindFirstChild("HumanoidRootPart") then
                        if (Player.Character.HumanoidRootPart.Velocity.Y < -5 and Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall) or Player.Character.HumanoidRootPart.Velocity.Y < -50 then
                            return true
                        elseif Player and (Player.Character.HumanoidRootPart.Velocity.X > 35 or Player.Character.HumanoidRootPart.Velocity.X < -35) then
                            return true
                        elseif Player and Player.Character.HumanoidRootPart.Velocity.Y > 60 then
                            return true
                        elseif Player and (Player.Character.HumanoidRootPart.Velocity.Z > 35 or Player.Character.HumanoidRootPart.Velocity.Z < -35) then
                            return true
                        elseif Player and (Player.Character.HumanoidRootPart.Velocity.X == 0 and Player.Character.HumanoidRootPart.Velocity.Y == 0 and Player.Character.HumanoidRootPart.Velocity.Z == 0) then
                            return true
                        else
                            return false
                        end
                    end
                end
            end
            --
            function LuckyHub:GetUniversalAimAssistTarget()
                local Target, Closest = nil, Huge
                local MousePosition = Utility:MousePosition()
                --
                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["UniversalAimAssistEnabled"] then continue end
                    if Library.Flags["UniversalWallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Library.Flags["UniversalAimAssistOrigin"]), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["UniversalAliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["UniversalForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["UniversalTeamCheck"] and not LuckyHub:CheckTeam(Client, Player) then continue end
                    if Library.Flags["UniversalFriendCheck"] and not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end
                    --
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToScreenPoint(RootPart.Position)
                    local ClientPosition = Workspace.CurrentCamera:WorldToScreenPoint(ClientCharacter.HumanoidRootPart.Position)
                    local Distance
                    if Library.Flags["UniversalAimAssistHitScan"] == "Mouse" then
                        Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    else
                        Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(ClientPosition.X, ClientPosition.Y)).Magnitude
                    end
                    --
                    if Library.Flags["UniversalAimAssistUseFOV"] and not (Distance <= Visuals.UniversalAimAssistFOVCircle.Radius) then continue end
                    --
                    if (Distance < Closest) and OnScreen then
                        Target = Player
                        Closest = Distance
                    end
                end
                LuckyHub.Locals.UniversalTarget = Target
            end
            --
            function LuckyHub:GetTriggerBotTarget()
                local Targets = {}
                --
                local MouseLocation = Utility:MousePosition()
                --
                for Index, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["UniversalTriggerBotEnabled"] then continue end
                    if Library.Flags["UniversalWallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Library.Flags["UniversalTriggerBotOrigin"]), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["UniversalAliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["UniversalForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["UniversalTeamCheck"] and not LuckyHub:CheckTeam(Client, Player) then continue end
                    if Library.Flags["UniversalFriendCheck"] and not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end

                    for Index2, Part in pairs(LuckyHub:GetBodyParts(Object, RootPart, false)) do
                        Targets[#Targets + 1] = Part
                    end
                end
                --
                local PointRay = Workspace.CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y, 0)
                local Hit, Position, Normal, Material = Workspace:FindPartOnRayWithWhitelist(Ray.new(PointRay.Origin, PointRay.Direction * 1000), Targets, false, false)
                --
                if Hit then
                    LuckyHub.Locals.TriggerTarget = {
                        Part = Hit,
                        Position = Position,
                        Material = Material
                    }
                else
                    LuckyHub.Locals.TriggerTarget = nil
                end
            end
            --
            function LuckyHub:UniversalAimAssist()
                if LuckyHub.Locals.UniversalTarget and LuckyHub.Locals.UniversalTarget.Character then
                    if Library.Flags["UniversalAimAssistClosestPart"] then
                        LuckyHub.Locals.UniversalHitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.UniversalTarget.Character))
                    else
                        LuckyHub.Locals.UniversalHitPart = Library.Flags["UniversalAimAssistHitPart"]
                    end
                    --
                    local MouseLocation = Utility:MousePosition()
                    local Position = Workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.UniversalTarget.Character[LuckyHub.Locals.UniversalHitPart].CFrame.Position + (LuckyHub.Locals.UniversalTarget.Character[LuckyHub.Locals.UniversalHitPart].Velocity * Library.Flags["UniversalAimAssistPredictionAmount"]))
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MouseLocation.X, MouseLocation.Y)).Magnitude
                    --
                    if ((tick() - LuckyHub.Locals.LastStutter) >= (Library.Flags["UniversalAimAssistStutter"] / 1000)) and (Distance >= Visuals.TriggerBotFOVCircle.Radius) then
                        LuckyHub.Locals.LastStutter = tick()
                        --
                        local MovePosition = Vector2.new(Position.X, Position.Y)
                        local MoveVector =  (MovePosition - MouseLocation)
                        local Smoothness = Vector2.new((Library.Flags["UniversalAimAssistXSmoothingAmount"] / 2), (Library.Flags["UniversalAimAssistYSmoothingAmount"] / 2))
                        --
                        local FinalVector = Vector2.new(MoveVector.X / Smoothness.X, MoveVector.Y / Smoothness.Y)
                        --
                        mousemoverel(FinalVector.X, FinalVector.Y)
                    end
                end
            end
            --
            function LuckyHub:TriggerBot()
                if LuckyHub.Locals.TriggerTarget then
                    local Tick = tick()
                    --
                    if ((Tick - LuckyHub.Locals.TriggerTick) >= (Library.Flags["UniversalTriggerBotInterval"] / 1000)) then
                        LuckyHub.Locals.TriggerTick = Tick
                        --
                        Delay(Library.Flags["UniversalTriggerBotDelay"] / 1000, function()
                            mouse1press()
                            task.Wait(0.05)
                            mouse1release()
                        end)
                    end
                end
            end
            --
            function LuckyHub:VelocityRecalculation(Mode)
                if Mode == "Silent Aim" then
                    if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character then
                        local Root = LuckyHub.Locals.Target.Character.HumanoidRootPart
                        local Character = LuckyHub.Locals.Target.Character
                        --
                        local CurrentPosition = Root.Position
                        local CurrentTime = tick() 
                        --
                        Wait()
                        --
                        local NewPosition = Root.Position
                        local NewTime = tick()
                        --
                        local DistanceTraveled = (NewPosition - CurrentPosition) 
                        --
                        local TimeInterval = NewTime - CurrentTime
                        local Velocity = DistanceTraveled / TimeInterval
                        CurrentPosition = NewPosition
                        CurrentTime = NewTime
                        --
                        return LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position + Velocity * Library.Flags["SilentAimPredictionAmount"]
                    end
                else
                    if LuckyHub.Locals.AimAssistTarget and LuckyHub.Locals.AimAssistTarget.Character then
                        local Root = LuckyHub.Locals.AimAssistTarget.Character.HumanoidRootPart
                        local Character = LuckyHub.Locals.AimAssistTarget.Character
                        --
                        local CurrentPosition = Root.Position
                        local CurrentTime = tick() 
                        --
                        Wait()
                        --
                        local NewPosition = Root.Position
                        local NewTime = tick()
                        --
                        local DistanceTraveled = (NewPosition - CurrentPosition) 
                        --
                        local TimeInterval = NewTime - CurrentTime
                        local Velocity = DistanceTraveled / TimeInterval
                        CurrentPosition = NewPosition
                        CurrentTime = NewTime
                        --
                        return LuckyHub.Locals.Position + Velocity * Library.Flags["AimAssistPredictionAmount"]
                    end
                end
            end
            --
            function LuckyHub:MoveDirection(Mode)
                if Mode == "Silent Aim" then
                    if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character and LuckyHub.Locals.Position then
                        return LuckyHub.Locals.Position + ((LuckyHub.Locals.Target.Character.Humanoid.MoveDirection * LuckyHub.Locals.Target.Character.Humanoid.WalkSpeed) * Library.Flags["SilentAimPredictionAmount"])
                    end
                else
                    if LuckyHub.Locals.AimAssistTarget and LuckyHub.Locals.AimAssistTarget.Character then
                        return LuckyHub.Locals.AimAssistTarget.Character[LuckyHub.Locals.AimAssistHitPart].Position + ((LuckyHub.Locals.AimAssistTarget.Character.Humanoid.MoveDirection * LuckyHub.Locals.AimAssistTarget.Character.Humanoid.WalkSpeed) * Library.Flags["AimAssistPredictionAmount"])
                    end
                end
            end
            --
            function LuckyHub:AutoPrediction()
                if Library.Flags["SilentAimPredictionType"] == "Auto" then
                    local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                    local split = Split(pingvalue, '(')
                    local ping = tonumber(split[1])
                    --
                    local prediction = (0.0006025 * ping) + 0.07892
                    --
                    Library.Flags["SilentAimPredictionAmount"] = prediction
                end
            end
            --
            function LuckyHub:CalculateAimpoint()
                if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character then
                    local MousePosition = Utility:MousePosition()
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(LuckyHub.Locals.Target)
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["SilentAimUseFOV"] and not (Distance <= Visuals.SilentAimFOVCircle.Radius) then
                        Visuals.SilentAimFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                        Cursor.mode = "mouse"
                        return
                    end
                    --
                    if (Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(LuckyHub.Locals.Target, Object, Humanoid)) then
                        return
                    end
                    --
                    if (Library.Flags["KnockedCheck"] and Object:FindFirstChild("BodyEffects") and Object.BodyEffects["K.O"].Value or Object:FindFirstChild("GRABBING_CONSTRAINT") ~= nil) then
                        return
                    end
                    --
                    if (Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(LuckyHub.Locals.Target)) then
                        return
                    end
                    --
                    if Library.Flags["TargetMode"] == "FOV" then
                        if Library.Flags["SilentAimEnabled"] == false then return end
                    end
                    --
                    if Library.Flags["SilentAimClosestPart"] and Library.Flags["SilentAimClosestPartMode"] == "Nearest Part" then
                        LuckyHub.Locals.HitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.Target.Character))
                        LuckyHub.Locals.Position = LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position
                    elseif Library.Flags["SilentAimClosestPart"] and Library.Flags["SilentAimClosestPartMode"] == "Nearest Point" then
                        LuckyHub.Locals.HitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.Target.Character))
                        LuckyHub.Locals.Position = LuckyHub:GetClosestPoint(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart])
                    else
                        LuckyHub.Locals.HitPart = Library.Flags["SilentAimHitPart"]
                        LuckyHub.Locals.Position = LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position
                    end
                    --
                    if Library.Flags["ResolverEnabled"] or LuckyHub:IsUsingAntiAim(LuckyHub.Locals.Target) or Library:GetPlayerFlag(LuckyHub.Locals.Target) == "Resolve" then
                        LuckyHub.Locals.AimPoint = Library.Flags["ResolverMethod"] == "Move Direction" and LuckyHub:MoveDirection("Silent Aim") or Library.Flags["ResolverMethod"] == "Velocity Recalculation" and LuckyHub:VelocityRecalculation("Silent Aim")
                    else
                        if Library.Flags["SilentAimNoGroundShots"] then
                            LuckyHub.Locals.AimPoint = (LuckyHub.Locals.Position) + Vector3.new(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.X, (LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Y * 0.5), LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Z) * Library.Flags["SilentAimPredictionAmount"]
                        else
                            LuckyHub.Locals.AimPoint = (LuckyHub.Locals.Position) + LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity * Library.Flags["SilentAimPredictionAmount"]
                        end
                    end
                    --
                    if Library.Flags["CursorMethod"] == "Sticky" and OnScreen then
                        Cursor.mode = 'custom'
                        Cursor.position = Vector2.new(Position.X, Position.Y)
                    else
                        Cursor.mode = "mouse"
                    end
                else
                    Cursor.mode = "mouse"
                end
            end
            --
            function LuckyHub:AimAssist()
                if LuckyHub.Locals.AimAssistTarget and LuckyHub.Locals.AimAssistTarget.Character then
                    local MousePosition = Utility:MousePosition()
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(LuckyHub.Locals.AimAssistTarget)
                    local Position = Workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["AimAssistUseFOV"] and not (Distance <= Visuals.AimAssistFOVCircle.Radius) then
                        TracerLine.Visible = false
                        return
                    end
                    --
                    if Library.Flags["AimAssistSafeMode"] and (UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter or not LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid"))) then
                        return
                    end
                    --
                    if (Library.Flags["WallCheck"] and not LuckyHub:RayCast(LuckyHub:GetClosestPart(Object), LuckyHub:GetOrigin("Camera"), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)})) then
                        return
                    end
                    --
                    if (Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(LuckyHub.Locals.AimAssistTarget, Object, Humanoid)) then
                        return
                    end
                    --
                    if (Library.Flags["KnockedCheck"] and Object:FindFirstChild("BodyEffects") and Object.BodyEffects["K.O"].Value or Object:FindFirstChild("GRABBING_CONSTRAINT") ~= nil) then
                        return
                    end
                    --
                    if (Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(LuckyHub.Locals.AimAssistTarget)) then
                        return
                    end
                    --
                    if Library.Flags["TargetMode"] == "FOV" then
                        if Library.Flags["AimAssistEnabled"] == false then return end
                    end
                    --
                    if Library.Flags["ResolverEnabled"] or LuckyHub:IsUsingAntiAim(LuckyHub.Locals.AimAssistTarget) or Library:GetPlayerFlag(LuckyHub.Locals.AimAssistTarget) == "Resolve" then
                        LuckyHub.Locals.AimAssistAimPoint = Library.Flags["ResolverMethod"] == "Move Direction" and LuckyHub:MoveDirection("Aim Assist") or Library.Flags["ResolverMethod"] == "Velocity Recalculation" and LuckyHub:VelocityRecalculation("Aim Assist")
                    else
                        if Library.Flags["AimAssistClosestPart"] then
                            LuckyHub.Locals.AimAssistHitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.AimAssistTarget.Character))
                        else
                            LuckyHub.Locals.AimAssistHitPart = Library.Flags["AimAssistHitPart"]
                        end
                        --
                        LuckyHub.Locals.AimAssistAimPoint = LuckyHub.Locals.AimAssistTarget.Character[LuckyHub.Locals.AimAssistHitPart].Position + LuckyHub.Locals.AimAssistTarget.Character[LuckyHub.Locals.AimAssistHitPart].Velocity * Library.Flags["AimAssistPredictionAmount"]
                    end
                    --
                    local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, LuckyHub.Locals.AimAssistAimPoint)
                    --
                    if not Library.Flags["SilentAimOnly"] then
                        if Library.Flags["AimAssistSmoothing"] then
                            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, Library.Flags["AimAssistSmoothingAmount"], Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                        else
                            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, 1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                        end
                    end
                end
            end
            --
            function LuckyHub:GetTool() 
                if ClientCharacter and ClientCharacter:FindFirstChildWhichIsA("Tool") then 
                    return ClientCharacter:FindFirstChildWhichIsA("Tool") 
                end 
            end
            --
            function LuckyHub:CreateBeam(Origin, End, Color1)
                local BeamPart = Instance.new("Part", Workspace)
                BeamPart.Name = "BeamPart"
                BeamPart.Transparency = 1
                --
                local Part = Instance.new("Part", BeamPart)
                Part.Size = Vector3.new(1, 1, 1)
                Part.Transparency = 1
                Part.CanCollide = false
                Part.CFrame = typeof(Origin) == "CFrame" and Origin or CFrame.new(Origin)
                Part.Anchored = true
                local Attachment = Instance.new("Attachment", Part)
                local Part2 = Instance.new("Part", BeamPart)
                Part2.Size = Vector3.new(1, 1, 1)
                Part2.Transparency = 1
                Part2.CanCollide = false
                Part2.CFrame = typeof(End) == "CFrame" and End or CFrame.new(End)
                Part2.Anchored = true
                Part2.Color = Color3.fromRGB(255, 255, 255)
                local Attachment2 = Instance.new("Attachment", Part2)
                local Beam = Instance.new("Beam", Part)
                Beam.FaceCamera = true
                Beam.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color1),
                    ColorSequenceKeypoint.new(1, Color1),
                }
                Beam.Attachment0 = Attachment
                Beam.Attachment1 = Attachment2
                Beam.LightEmission = 6
                Beam.LightInfluence = 1
                Beam.Width0 = 1
                Beam.Width1 = 1
                Beam.Texture = "rbxassetid://7136858729"
                Beam.LightEmission = 1
                Beam.LightInfluence = 1
                Beam.TextureMode = Enum.TextureMode.Wrap
                Beam.TextureLength = 3
                Beam.TextureSpeed = 3
                --
                Delay(1.5, function()
                    for i = 0, 1, 0.05 do
                        Wait()
                        Beam.Transparency = NumberSequence.new(i)
                    end
                    --
                    Beam:Destroy()
                    Part:Destroy()
                    Part2:Destroy()
                    BeamPart:Destroy()
                end)
            end
            --
            function LuckyHub:CreateDrawingBeam(Origin, End, Color1)
                local Line = BulletLibrary:New3DLine()
                Line.Visible = true
                Line.Transparency = 1
                Line.Thickness = 2
                Line.Color = Library.Flags["BulletTracerColor"]
                Line.From = (typeof(Origin) == "CFrame" and Origin or CFrame.new(Origin)).Position
                Line.To = (typeof(End) == "CFrame" and End or CFrame.new(End)).Position
                --
                Delay(1.5, function()
                    for i = 0, 1, 0.05 do
                        Wait()
                        Line.Transparency = 1 - i
                    end
                    --
                    Line:Remove()
                end)
            end
            --
            function LuckyHub:TranslateBeam(Beam)
                local Part = Beam
                --
                if Part ~= nil then
                    local Attachments = Part:GetChildren()
                    if Attachments ~= nil and Attachments[1] ~= nil and Attachments[2] ~= nil then
                        local Origin = Attachments[1].WorldCFrame
                        local End = Attachments[2].WorldCFrame
                        --
                        if Library.Flags["BulletTracerType"] == "Beam" then
                            LuckyHub:CreateBeam(Origin, End, Library.Flags["BulletTracerColor"])
                        else
                            LuckyHub:CreateDrawingBeam(Origin, End, Library.Flags["BulletTracerColor"])
                        end
                        Part.Parent = nil
                    end
                end
            end
            --
            function LuckyHub:RotateCursor()
                if LuckyHub:GetTool() and LuckyHub:GetTool():FindFirstChild("Ammo") then
                    Client.PlayerGui.MainScreenGui.Aim.Visible = Library.Flags["InGameCrosshairVisible"]
                    --
                    if Library.Flags["InGameCrosshairSpin"] and Library.Flags["InGameCrosshairVisible"] then 
                        Client.PlayerGui.MainScreenGui.Aim.Rotation += Library.Flags["InGameCrosshairSpinSpeed"]
                    end
                end
            end
            --
            function LuckyHub:DrawVisualizations()
                if LuckyHub.Locals.Target ~= nil and Library.Flags["PredVisualizersEnabled"] and Library.Flags["SilentAimEnabled"] then
                    local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.AimPoint)
                    local HitPartPosition = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position)
                    local SelectedPartPosition, OnScreen2 = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Position)
                    --
                    if Library.Flags["PredVisualizersDot"] then
                        PredictionDot.Visible = Library.Flags["PredVisualizersHitPoint"] and OnScreen or OnScreen2
                        PredictionDot.Position = Library.Flags["PredVisualizersHitPoint"] and Vector2.new(Position.X, Position.Y) or Vector2.new(SelectedPartPosition.X, SelectedPartPosition.Y)
                        PredictionDot.Radius = 4
                        PredictionDot.Filled = true
                        PredictionDot.Color = Library.Flags["PredVisualizerColor"]
                        PredictionDot.Thickness = 1
                        PredictionDot.NumSides = 1000
                    else
                        PredictionDot.Visible = false
                    end
                    --
                    if Library.Flags["PredVisualizersLine"] then
                        PredictionLine.Visible = Library.Flags["PredVisualizersHitPoint"] and OnScreen or OnScreen2
                        PredictionLine.From = Library.Flags["PredVisualizersHitPoint"] and Vector2.new(HitPartPosition.X, HitPartPosition.Y) or Vector2.new(SelectedPartPosition.X, SelectedPartPosition.Y)
                        PredictionLine.To = Library.Flags["PredVisualizersHitPoint"] and Vector2.new(Position.X, Position.Y) or Vector2.new(SelectedPartPosition.X, SelectedPartPosition.Y)
                        PredictionLine.Color = Library.Flags["PredVisualizerColor"]
                        PredictionLine.Thickness = 2
                        PredictionLine.Transparency = 1
                    else
                        PredictionLine.Visible = false
                    end
                    --
                    if Library.Flags["PredVisualizersChams"] then
                        if Workspace:FindFirstChild("ServerChams") ~= nil then
                            for _, part in next, Workspace:FindFirstChild("ServerChams"):GetChildren() do
                                part.Color = Library.Flags["PredVisualizerColor"]
                                part.Transparency = 0
                                if LuckyHub:IsUsingAntiAim(LuckyHub.Locals.Target) then
                                    part.CFrame = LuckyHub.Locals.Target.Character:FindFirstChild(part.Name).CFrame + ((LuckyHub.Locals.Target.Character.Humanoid.MoveDirection * LuckyHub.Locals.Target.Character.Humanoid.WalkSpeed) * Library.Flags["SilentAimPredictionAmount"])
                                else
                                    part.CFrame = LuckyHub.Locals.Target.Character:FindFirstChild(part.Name).CFrame + (Library.Flags["PredVisualizersHitPoint"] and Vector3.new(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.X, (LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Y * 0.5), LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Z) * Library.Flags["SilentAimPredictionAmount"] or Vector3.new(LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Velocity.X, (LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Velocity.Y * 0.5), LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Velocity.Z) * Library.Flags["SilentAimPredictionAmount"])
                                end
                                part.Material = Enum.Material[Library.Flags["PredVisualizerChamsMaterial"]]
                            end
                        else
                            local fold = Instance.new("Folder", Workspace)
                            fold.Name = "ServerChams"
                            for _, part in next, LuckyHub.Locals.Target.Character:GetChildren() do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    local pee = Instance.new("Part", fold)
                                    pee.Name = part.Name
                                    pee.Size = part.Size
                                    pee.Parent = fold
                                    pee.CanCollide = false
                                    pee.Transparency = 0
                                    pee.Anchored = true
                                    pee.Color = Library.Flags["PredVisualizerColor"]
                                    pee.Material = Enum.Material[Library.Flags["PredVisualizerChamsMaterial"]]
                                end
                            end
                        end
                    else
                        if Workspace:FindFirstChild("ServerChams") ~= nil then
                            for _, part in next, Workspace:FindFirstChild("ServerChams"):GetChildren() do
                                part.Transparency = 1
                            end
                        end
                    end
                else
                    if Workspace:FindFirstChild("ServerChams") ~= nil then
                        for _, part in next, Workspace:FindFirstChild("ServerChams"):GetChildren() do
                            part.Transparency = 1
                        end
                    end
                    PredictionLine.Visible = false
                    PredictionDot.Visible = false
                end
            end
        end
--
        do -- Visualisation
            function Visualisation:CreateVisual(Character)
                local Clone = Utility:Instance("Model", {
                    Name = "Visualisation",
                    Parent = Workspace
                })
                --
                local Head = Character:FindFirstChild("Head")
                --
                local PartsTable = {}
                --
                for Index, Value in pairs(Character:GetChildren()) do
                    if Value:IsA("BasePart") and (Value.Name == "Head" or Value.Name:find("Arm") or Value.Name:find("Torso") or Value.Name:find("Leg") or Value.Name:find("Hand") or Value.Name:find("Foot")) then
                        local Part = Utility:Instance("Part", {
                            Name = Value.Name,
                            Color = Color3.fromRGB(0, 255, 0),
                            Size = Value.Size * 1.025,
                            CFrame = Value.CFrame,
                            CanCollide = false,
                            Transparency = 0,
                            Anchored = true,
                            Material = "SmoothPlastic",
                            BackSurface = "Smooth",
                            BottomSurface = "Smooth",
                            FrontSurface = "Smooth",
                            LeftSurface = "Smooth",
                            RightSurface = "Smooth",
                            TopSurface = "Smooth",
                            Shape = (Value.Name == "Head" and "Cylinder" or "Block"),
                            Parent = Clone
                        })
                        --
                        for Index, Value in pairs({"Back", "Bottom", "Front", "Left", "Right", "Top"}) do
                            local Texture = Utility:Instance("Texture", {
                                Color3 = Color3.fromRGB(0, 255, 0),
                                OffsetStudsU = 0,
                                OffsetStudsV = 0,
                                StudsPerTileU = 12.5,
                                StudsPerTileV = 12.5,
                                Transparency = 0.5,
                                Face = Value,
                                Parent = Part
                            })
                        end
                        --
                        PartsTable[Value] = Part
                    end
                end
                --
                Visualisation.Character = PartsTable
            end
            --
            function Visualisation:DestroyVisual()
                if Visualisation.Character ~= nil then
                    for Index, Value in pairs(Visualisation.Character) do
                        Value:Destroy()
                    end
                end
            end
            --
            function Visualisation:Update(FakeLagging)
                local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
                --
                if RootPart then
                    if Visualisation.Character then
                        local VisualisationColor, VisualisationTransparency = Library.Flags["DesyncVisualizationColor"], 0
                        local VisualisationTransparency2 = Clamp(VisualisationTransparency + 0.25, 0, 1)
                        local ServerPosition = true
                        local VisualisationMaterial = Library.Flags["DesyncVisualizationMaterial"]
                        --
                        if FakeLagging then
                            for Index, Perform in pairs(Visualisation.LastUpdate) do
                                if ServerPosition then Delay(LuckyHub:GetLatency() * 1.75, Perform) else Perform() end
                            end
                        else
                            Visualisation.LastUpdate = {}
                            --
                            for Index, Value in pairs(Visualisation.Character) do
                                if Index then
                                    local OldCFrame = Index.CFrame
                                    --
                                    Value.Material = (VisualisationMaterial == "ForceField" and "ForceField" or VisualisationMaterial == "Plastic" and "SmoothPlastic" or VisualisationMaterial == "Neon" and "Neon" or VisualisationMaterial)
                                    Value.Color = VisualisationColor
                                    Value.Transparency = VisualisationTransparency
                                    --
                                    for Index2, Value2 in pairs(Value:GetChildren()) do
                                        if Value2:IsA("Texture") then
                                            if VisualisationMaterial == "Animated" then
                                                Value2.Color3 = VisualisationColor
                                                Value2.Transparency = VisualisationTransparency2
                                                Value2.Texture = Format("rbxasset://textures/water/normal_%02d.dds", Visualisation.Texture)
                                            else
                                                Value2.Transparency = 1
                                            end
                                        end
                                    end
                                    --
                                    local Perform = function()
                                        local Radius = (Index.Name == "Head" and ((Index.Size.X * (Value:FindFirstChildOfClass("WrapTarget") and 0.45 or 0.275)) + 0.1))
                                        --
                                        Value.Size = Index.Name == "Head" and Vector3.new(Index.Size.Y, Radius * 2, Radius * 2) or (Index.Size * 0.99)
                                        Value.CFrame = OldCFrame * CFrame.Angles(0, 0, Index.Name == "Head" and Rad(90) or 0)
                                    end
                                    --
                                    Visualisation.LastUpdate[Value] = Perform
                                    --
                                    if ServerPosition then Delay(LuckyHub:GetLatency() * 1.75, Perform) else Perform() end
                                else
                                    Value:Remove()
                                end
                            end
                        end
                        --
                        Visualisation.Texture = Visualisation.Texture + 1
                        --
                        if Visualisation.Texture > 25 then
                            Visualisation.Texture = 1
                        end
                    end
                end
            end
        end
        --
        AimviewerBeam = Instance.new("Beam")
        AimviewerBeam.Segments = 1
        AimviewerBeam.Width0 = 0.3
        AimviewerBeam.Width1 = 0.3
        AimviewerBeam.FaceCamera = true
        --
        AimviewerAttachment1 = Instance.new("Attachment")
        AimviewerAttachment2 = Instance.new("Attachment")
        --
        AimviewerBeam.Attachment0 = AimviewerAttachment1
        AimviewerBeam.Attachment1 = AimviewerAttachment2
        AimviewerBeam.Parent = Workspace.Terrain
        AimviewerAttachment1.Parent = Workspace.Terrain
        AimviewerAttachment2.Parent = Workspace.Terrain
        --
        function LuckyHub:DrawAimviewers()
            if LuckyHub.Locals.AimviewerTarget ~= nil then
                local player = LuckyHub.Locals.AimviewerTarget
                --
                if LuckyHub:ClientAlive(player, player.Character, player.Character:FindFirstChild("Humanoid")) and player.Character:FindFirstChildOfClass("Tool") then 
                    AimviewerBeam.Enabled = Library.Flags["AimviewerEnabled"]
                    AimviewerAttachment1.Position = player.Character:FindFirstChild("Head").Position
                    AimviewerAttachment2.Position = player.Character.BodyEffects.MousePos.Value
                    AimviewerBeam.Color = ColorSequence.new(Library.Flags["AimviewerColor"])
                else
                    AimviewerBeam.Enabled = false
                end
            end
        end
        --
        function LuckyHub:AutoBuy(weapon, method)
            if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                for _, obj in next, Workspace.Ignored.Shop:GetChildren() do
                    local objname = obj.Name:gsub(" ", "")
                    if method == "Gun" then
                        if weapon == "Double" then
                            if obj.Name == "[Double-Barrel SG] - $1485" then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        else
                            if SFind(obj.Name, weapon) and not SFind(obj.Name, "Ammo") then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        end
                    else
                        if weapon == "Double" then
                            if obj.Name == "18 [Double-Barrel SG Ammo] - $64" then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        else
                            if SFind(obj.Name, weapon) and SFind(obj.Name, "Ammo") then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        end
                    end
                end
            end
        end
        --
        function LuckyHub:HitEffect(Type, Character)
            local function Weld(x,y)
                local W = Instance.new("Weld")
                W.Part0 = x
                W.Part1 = y
                local CJ = CFrame.new(x.Position)
                local C0 = x.CFrame:inverse()*CJ
                local C1 = y.CFrame:inverse()*CJ
                W.C0 = C0
                W.C1 = C1
                W.Parent = x
            end
            -- 
            if Type == "Slash" then
                local Effect = _G.SlashEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    if v:IsA("ParticleEmitter") then
                        v.Rate = 0
                        if v.Color ~= Color3.fromRGB(0, 0, 0) then
                            v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                        end
                        v:Emit()
                    end
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Solar" then
                local Effect = _G.SolarEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    if v.Color ~= Color3.fromRGB(0, 0, 0) then
                        v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    end
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Lightning" then
                local Effect = _G.LightningEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    if v.Color ~= Color3.fromRGB(133, 134, 134) then
                        v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    end
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Galaxy" then
                local Effect = _G.GalaxyEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Water" then
                local Effect = _G.WaterEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            end 
        end
        --
        function LuckyHub:HitNotification(Message, Delay)
            Library:Notify(Message, Delay)
        end
        -- 
        function LuckyHub:HitSound(Id)
            local Sound = Instance.new("Sound", Workspace); local PitchSound = Instance.new("PitchShiftSoundEffect", Sound)
            -- 
            Sound.SoundId = "rbxassetid://".. Id ..""
            Sound.Volume = 3
            PitchSound.Octave = 1
            Sound:Play()
            Sound.Ended:Connect(function()
                Sound:Destroy()
                PitchSound:Destroy()
            end)	
        end
        --
        function LuckyHub:CreateClone(Player, Color, Material, Parent)
            for i,v in pairs(Player.Character:GetChildren()) do 
                if v:IsA("MeshPart") and v.Name ~= "HumanoidRootPart" then 
                    if v.Name == "UpperTorso" or v.Name == "LowerTorso" then 
                        local ClonedPart = Instance.new("Part")
                        ClonedPart.Anchored = true 
                        ClonedPart.CanCollide = false 
                        ClonedPart.Position = v.Position
                        ClonedPart.Parent = Parent
                        ClonedPart.Material = Enum.Material[Material]
                        ClonedPart.Transparency = 0 
                        ClonedPart.Color = Color
                        ClonedPart.Size = v.Size + Vector3.new(0.01,0.01,0.01)
                        ClonedPart.Name = v.Name
                        ClonedPart.Rotation = v.Rotation
                        ClonedPart.Shape = "Block"
                    else 
                        local ClonedPart = Instance.new("MeshPart")
                        ClonedPart.Anchored = true 
                        ClonedPart.CanCollide = false 
                        ClonedPart.Position = v.Position
                        ClonedPart.Parent = Parent
                        ClonedPart.Material = Enum.Material[Material]
                        ClonedPart.Transparency = 0 
                        ClonedPart.Color = Color
                        ClonedPart.Size = v.Size + Vector3.new(0.01,0.01,0.01)
                        ClonedPart.Name = v.Name
                        ClonedPart.Rotation = v.Rotation
                        ClonedPart.MeshId = v.MeshId
                    end 
                end
            end
        end
        --
        function LuckyHub:UpdateHealth()
            if Library.Flags["HitDetectionEnabled"] then
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player.Character and Player.Character.Humanoid then
                        LuckyHub.Locals.PlayerHealth[Player.Name] = Player.Character.Humanoid.Health
                    end
                end
            end
        end
        --
        function LuckyHub:GetClosestPlayerDamage(Position, MaxRadius)
            local Radius = MaxRadius
            local ClosestPlayer

            for PlayerName, Health in pairs(LuckyHub.Locals.PlayerHealth) do
                local Player = Players:FindFirstChild(PlayerName)
                if Player and Player.Character then
                    local PlayerPosition = Player.Character.PrimaryPart.Position
                    local Distance = (Position - PlayerPosition).Magnitude
                    local CurrentHealth = Player.Character.Humanoid.Health
                    --
                    if (Distance < Radius) and (CurrentHealth < Health) then
                        Radius = Distance
                        ClosestPlayer = Player
                    end
                end
            end
            return ClosestPlayer, Radius
        end
        --
        function LuckyHub:HitDetection()
            local Gun = LuckyHub:GetTool()
            local Connection = LuckyHub["Connections"]["On-Hit-Raycast"]
            --
            if Gun ~= LuckyHub.Locals.PreviousGun and Connection then
                LuckyHub.Locals.PreviousGun = Gun
                LuckyHub.Locals.PreviousAmmo = 999
                Connection:Disconnect()
                LuckyHub["Connections"]["On-Hit-Raycast"] = nil
            end
            --
            if not LuckyHub["Connections"]["On-Hit-Raycast"] and Gun and Gun.Ammo.Value then
                LuckyHub["Connections"]["On-Hit-Raycast"] = Gun.Ammo:GetPropertyChangedSignal("Value"):Connect(function()
                    local NewAmmo = Gun.Ammo.Value
                    if (NewAmmo < LuckyHub.Locals.PreviousAmmo) and LuckyHub.Locals.PreviousAmmo then
                        local ChildAdded
                        local ChildrenAdded = 0
                        ChildAdded = Workspace.Ignored.Siren.Radius.DescendantAdded:Connect(function(Object)
                            if Object.Name == "BULLET_RAYS" then
                                ChildrenAdded += 1
                                if (Find({"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}, Gun.Name) and ChildrenAdded <= 5) or (ChildrenAdded == 1) then
                                    local GunBeam = Object:WaitForChild("GunBeam")
                                    local StartPos, EndPos = Object.Position, GunBeam.Attachment1.WorldPosition
                                    --
                                    if StartPos and EndPos then
                                        if Library.Flags["BulletTracers"] then
                                            GunBeam:Destroy()
                                            --
                                            if Library.Flags["BulletTracerType"] == "Beam" then
                                                LuckyHub:CreateBeam(StartPos, EndPos, Library.Flags["BulletTracerColor"])
                                            else
                                                LuckyHub:CreateDrawingBeam(StartPos, EndPos, Library.Flags["BulletTracerColor"])
                                            end
                                        end
                                        --
                                        if Library.Flags["BulletImpacts"] then
                                            local Impact = Instance.new("Part")
                                            Impact.Anchored = true
                                            Impact.CanCollide = false 
                                            Impact.Parent = Workspace
                                            Impact.Material = "Neon"
                                            Impact.Shape = Enum.PartType.Block 
                                            Impact.Transparency = 0
                                            Impact.Color = Library.Flags["BulletImpactsColor"]
                                            Impact.Size = Vector3.new(0.4, 0.4, 0.4)
                                            Impact.CFrame = CFrame.new(EndPos)
                                            --
                                            Delay(1.5, function()
                                                for i = 0, 1, 0.05 do
                                                    Wait()
                                                    Impact.Transparency = NumberSequence.new(i)
                                                end
                                                --
                                                Impact:Destroy()
                                            end)
                                        end
                                        --
                                        if Library.Flags["HitDetectionEnabled"] then
                                            local Player, Distance = LuckyHub:GetClosestPlayerDamage(EndPos, 20)
                                            --
                                            if Player then
                                                --
                                                if Library.Flags["HitDetectionNotifications"] then
                                                    local Health = Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Humanoid").Health
                                                    local Damage = (LuckyHub.Locals.PlayerHealth[Player.Name] - Health)
                                                    --
                                                    LuckyHub:HitNotification(("Hit %s for %s damage (%s health remaning)"):format(tostring(Player.Name), tostring(math.floor(Damage)), tostring(math.floor(Health))), 2)
                                                end
                                                --
                                                if Library.Flags["HitDetectionEffectType"] ~= "None" then
                                                    if Library.Flags["HitDetectionEffectType"] == "Clone" then
                                                        local Folder = Instance.new("Folder", Workspace)
                                                        --
                                                        LuckyHub:CreateClone(Player, Library.Flags["HitDetectionEffectColor"], Library.Flags["HitDetectionEffectMaterial"], Folder)
                                                        --
                                                        Delay(2, function()
                                                            Folder:Destroy()
                                                        end)
                                                    else
                                                        LuckyHub:HitEffect(Library.Flags["HitDetectionEffectType"], Player.Character)
                                                    end
                                                end
                                                --
                                                if Library.Flags["HitDetectionSoundType"] ~= "None" then
                                                    LuckyHub:HitSound(LuckyHub.SoundEffects[Library.Flags["HitDetectionSoundType"]])
                                                end
                                            end
                                        end
                                    end
                                    --
                                    ChildAdded:Disconnect()
                                end
                            else
                                ChildAdded:Disconnect()
                            end
                        end)
                    end
                    LuckyHub.Locals.PreviousAmmo = NewAmmo
                end)
            end
            --  
        end
--
local ChangingTitle = {
    "",
    "",
    "L",
    "Lu",
    "Luc",
    "Luck",
    "Lucky",
    "LuckyH",
    "LuckyHu",
    "LuckyHub",
    "LuckyHub",
    "LuckyHub",
    "LuckyHu",
    "LuckyH",
    "Lucky",
    "Luck",
    "Luc",
    "Lu",
    "L",
    "",
    "",
}
--
local Main = Library:Window({Name = "LuckyHub", Side = "Center", Icon = "rbxassetid://16863027979", Size = UDim2.new(0, 850, 0, 677), Theme = Color3.fromRGB(0, 255, 0), KeybindList = true, Watermark = true, Indicators = true, VelocityStats = true})
--
local MainTab = Main:CreateTab({Name = "Main", Icon = "rbxassetid://16863175349"})
local UniversalTab = Main:CreateTab({Name = "Universal", Icon = "rbxassetid://16866569883"})
local ESPTab = Main:CreateTab({Name = "ESP", Icon = "rbxassetid://16993859634"})
local VisualsTab = Main:CreateTab({Name = "Visuals", Icon = "rbxassetid://16863266011"})
local MiscTab = Main:CreateTab({Name = "Misc", Icon = "rbxassetid://16864702418"})
local SkinsTab = Main:CreateTab({Name = "Skins", Icon = "rbxassetid://16866165737"})
local PlayersTab = Main:CreateTab({Name = "Players", Icon = "rbxassetid://16863267075", PlayerList = true})
local SettingsTab = Main:CreateTab({Name = "Settings", Icon = "rbxassetid://16863267906"})
--
do -- Main Tab
    local SilentAimSection = MainTab:Section({Name = "Silent Aim", Side = "Left"})
    local FOVSection = MainTab:Section({Name = "FOV Settings", Side = "Left"})
    local AimAssistSection = MainTab:Section({Name = "Aim Assist", Side = "Right"})
    local ChecksSection = MainTab:Section({Name = "Checks", Side = "Right"})
    local ExtraSection = MainTab:Section({Name = "Extra", Side = "Right"})
    --
    do -- Silent Aim
        local SilentAimToggle = SilentAimSection:Toggle({Name = "Silent Aim Enabled", Flag = "SilentAimEnabled"})
        SilentAimToggle:Keybind({Default = "Q"})
        --
        function LuckyHub:GetOldMode2()
            return SilentAimToggle:GetMode()
        end
        --
        function LuckyHub:SetSilentAimMode(Mode)
            SilentAimToggle:SetMode(Mode)
        end
        --
        SilentAimSection:Toggle({Name = "Anti Curve", Default = true, Flag = "SilentAimAntiCurve"})
        --
        SilentAimSection:Toggle({Name = "No Ground Shots", Default = true, Flag = "SilentAimNoGroundShots"})
        --
        SilentAimSection:Toggle({Name = "Use FOV", Default = true, Flag = "SilentAimUseFOV"})
        --
        SilentAimSection:Slider({Name = "Field Of View", Flag = "SilentAimFieldOfView", Min = 1, Max = 300, Default = 50, Decimal = 0.1})
        --
        SilentAimSection:Dropdown({Name = "Predicition Type", Flag = "SilentAimPredictionType", Content = {"Custom", "Auto"}, Default = "Custom"})
        --
        SilentAimSection:TextBox({Default = "0.135", PlaceHolder = "Prediction Amount", NumbersOnly = true, Max = 15, Flag = "SilentAimPredictionAmount"})
        --
        SilentAimSection:Toggle({Name = "Closest Part", Flag = "SilentAimClosestPart"})
        --
        SilentAimSection:Dropdown({Name = "Closest Part Mode", Flag = "SilentAimClosestPartMode", Content = {"Nearest Part", "Nearest Point"}, Default = "Nearest Part"})
        --
        SilentAimSection:Dropdown({Name = "Hit Part", Flag = "SilentAimHitPart", Content = {"Head", "HumanoidRootPart", "LowerTorso", "UpperTorso", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg", "RightFoot", "LeftFoot", "LeftUpperArm", "RightUpperArm", "RightLowerArm", "LeftLowerArm", "LeftHand", "RightHand"}, Default = "HumanoidRootPart"})
    end
    --
    do -- Aim Assist
        local AimAssistToggle = AimAssistSection:Toggle({Name = "Aim Assist Enabled", Flag = "AimAssistEnabled"})
        AimAssistToggle:Keybind({Default = "C", Flag = "KeybindTest"})
        --
        function LuckyHub:GetAimAssistKeybind()
            return AimAssistToggle:GetKeybind()
        end
        --
        function LuckyHub:GetOldMode()
            return AimAssistToggle:GetMode()
        end
        --
        function LuckyHub:SetAimAssistMode(Mode)
            AimAssistToggle:SetMode(Mode)
        end
        --
        AimAssistSection:Toggle({Name = "Safe Mode", Default = true, Flag = "AimAssistSafeMode"})
        --
        AimAssistSection:Toggle({Name = "Smoothing", Default = true, Flag = "AimAssistSmoothing"})
        --
        AimAssistSection:Slider({Name = "Smoothing Amount", Flag = "AimAssistSmoothingAmount", Min = 0.001, Max = 1, Default = 0.1, Decimal = 0.001})
        --
        AimAssistSection:Toggle({Name = "Use FOV", Default = true, Flag = "AimAssistUseFOV"})
        --
        AimAssistSection:Slider({Name = "Field Of View", Flag = "AimAssistFieldOfView", Min = 1, Max = 300, Default = 75, Decimal = 0.1})
        --
        AimAssistSection:TextBox({Default = "0.115", PlaceHolder = "Prediction Amount", NumbersOnly = true, Max = 15, Flag = "AimAssistPredictionAmount"})
        --
        AimAssistSection:Toggle({Name = "Closest Part", Flag = "AimAssistClosestPart"})
        --
        AimAssistSection:Dropdown({Name = "Hit Part", Flag = "AimAssistHitPart", Content = {"Head", "HumanoidRootPart", "LowerTorso", "UpperTorso", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg", "RightFoot", "LeftFoot", "LeftUpperArm", "RightUpperArm", "RightLowerArm", "LeftLowerArm", "LeftHand", "RightHand"}, Default = "HumanoidRootPart"})
    end
    --
    do -- FOV
        local SilentAimFOV = FOVSection:Toggle({Name = "Silent Aim FOV", Flag = "SilentAimFOVEnabled", Default = false})
        SilentAimFOV:ColorPicker({Name = "Silent Aim FOV Color", Flag = "SilentAimColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        FOVSection:Toggle({Name = "Silent Aim FOV Filled", Flag = "SilentAimFOVFilled", Default = false})
        --
        FOVSection:Dropdown({Name = "Silent Aim FOV Type", Flag = "SilentAimFOVType", Content = {"Mouse", "Sticky"}, Default = "Mouse"})
        --
        FOVSection:Slider({Name = "Silent Aim FOV Transparency", Flag = "SilentAimFieldOfViewTransparency", Min = 0, Max = 1, Default = 1, Decimal = 0.01})
        --
        local AimAssistFOV = FOVSection:Toggle({Name = "Aim Assist FOV", Flag = "AimAssistFOVEnabled", Default = false})
        AimAssistFOV:ColorPicker({Name = "Aim Assist FOV Color", Flag = "AimAssistColor", Default = Color3.fromRGB(255, 255, 255)})
        --
        FOVSection:Toggle({Name = "Aim Assist FOV Filled", Flag = "AimAssistFOVFilled", Default = false})
        --
        FOVSection:Slider({Name = "Aim Assist FOV Transparency", Flag = "AimAssistFieldOfViewTransparency", Min = 0, Max = 1, Default = 0.5, Decimal = 0.01})
        --
        local Tracer = FOVSection:Toggle({Name = "Tracer", Flag = "TracerEnabled", Default = false})
        Tracer:ColorPicker({Name = "Tracer Color", Flag = "TracerColor", Default = Color3.fromRGB(255, 255, 255)})
        --
        FOVSection:Slider({Name = "Tracer Transparency", Flag = "TracerTransparency", Min = 0, Max = 1, Default = 1, Decimal = 0.01})
        --
        FOVSection:Slider({Name = "Tracer Thickness", Flag = "TracerThickness", Min = 0.1, Max = 5, Default = 1.5, Decimal = 0.1})
    end
    --
    do -- Checks
        ChecksSection:Toggle({Name = "Wall Check", Default = true, Flag = "WallCheck"})
        --
        ChecksSection:Toggle({Name = "Alive Check", Default = true, Flag = "AliveCheck"})
        --
        ChecksSection:Toggle({Name = "ForceField Check", Flag = "ForceFieldCheck"})
        --
        ChecksSection:Toggle({Name = "Knocked Check", Flag = "KnockedCheck"})
        --
        ChecksSection:Toggle({Name = "Crew Check", Flag = "CrewCheck"})
        --
        ChecksSection:Toggle({Name = "Friend Check", Flag = "FriendCheck"})
    end
    --
    do -- Extra
        ExtraSection:Toggle({Name = "Resolver", Flag = "ResolverEnabled"})
        --
        ExtraSection:Dropdown({Name = "Resolver Method", Flag = "ResolverMethod", Content = {"Move Direction", "Velocity Recalculation"}, Default = "Move Direction"})
        --
        local OldMode = LuckyHub:GetOldMode()
        local OldMode2 = LuckyHub:GetOldMode2()
        --
        ExtraSection:Dropdown({Name = "Target Mode", Flag = "TargetMode", Content = {"FOV", "Target"}, Default = "FOV", Callback = function(State)
            if State == "Target" then
                LuckyHub:SetAimAssistMode("Always")
                LuckyHub:SetSilentAimMode("Always")
            else
                LuckyHub:SetAimAssistMode(OldMode)
                LuckyHub:SetSilentAimMode(OldMode2)
            end
        end})
        --
        ExtraSection:Toggle({Name = "Silent Aim Only", Default = false, Flag = "SilentAimOnly"})
        --
        ExtraSection:Toggle({Name = "Notifications", Default = true, Flag = "NotificationsEnabled"})
    end
end
--
do -- Universal
    local UniversalAimAssist = UniversalTab:Section({Name = "Aim Assist", Side = "Left"})
    local UniversalFOVSettings = UniversalTab:Section({Name = "FOV Settings", Side = "Left"})
    local UniversalTriggerBot = UniversalTab:Section({Name = "Trigger Bot", Side = "Right"})
    local UniversalChecks = UniversalTab:Section({Name = "Checks", Side = "Right"})
    --
    do -- Aim Assist
        local UniversalAimAssistToggle = UniversalAimAssist:Toggle({Name = "Aim Assist Enabled", Flag = "UniversalAimAssistEnabled"})
        UniversalAimAssistToggle:Keybind({Default = "E"})
        --
        UniversalAimAssist:Toggle({Name = "Use FOV", Default = true, Flag = "UniversalAimAssistUseFOV"})
        --
        UniversalAimAssist:Slider({Name = "Field Of View", Flag = "UniversalAimAssistFieldOfView", Min = 1, Max = 300, Default = 50, Decimal = 0.1})
        --
        UniversalAimAssist:Slider({Name = "Horizontal Smoothing Amount", Flag = "UniversalAimAssistXSmoothingAmount", Min = 5, Max = 100, Default = 10, Decimal = 0.01})
        --
        UniversalAimAssist:Slider({Name = "Vertical Smoothing Amount", Flag = "UniversalAimAssistYSmoothingAmount", Min = 5, Max = 100, Default = 10, Decimal = 0.01})
        --
        UniversalAimAssist:TextBox({Default = "0.115", NumbersOnly = true, PlaceHolder = "Prediction Amount", Max = 15, Flag = "UniversalAimAssistPredictionAmount"})
        --
        UniversalAimAssist:Toggle({Name = "Closest Part", Flag = "UniversalAimAssistClosestPart"})
        --
        UniversalAimAssist:Dropdown({Name = "Hit Part", Flag = "UniversalAimAssistHitPart", Content = {"Head", "HumanoidRootPart"}, Default = "HumanoidRootPart"})
        --
        UniversalAimAssist:Dropdown({Name = "Target Priority", Flag = "UniversalAimAssistHitScan", Content = {"Mouse", "Distance"}, Default = "Mouse"})
        --
        UniversalAimAssist:Dropdown({Name = "Hit Scan Priority", Flag = "UniversalAimAssistOrigin", Content = {"Camera", "Head", "Torso"}, Default = "Camera"})
        --
        UniversalAimAssist:Slider({Name = "Deadzone", Flag = "UniversalAimAssistDeadzone", Min = 0, Max = 100, Default = 10, Decimal = 0.01})
        --
        UniversalAimAssist:Slider({Name = "Stutter", Flag = "UniversalAimAssistStutter", Min = 1, Max = 100, Default = 20, Decimal = 0.01})
    end
    --
    do -- FOV Settings
        local UniversalAimAssistFOV = UniversalFOVSettings:Toggle({Name = "Aim Assist FOV", Flag = "UniversalAimAssistFOVEnabled", Default = false})
        UniversalAimAssistFOV:ColorPicker({Name = "Aim Assist FOV Color", Flag = "UniversalAimAssistColor", Default = Color3.fromRGB(255, 255, 255)})
        --
        UniversalFOVSettings:Slider({Name = "Aim Assist FOV Transparency", Flag = "UniversalAimAssistFOVTransparency", Min = 0, Max = 1, Default = 1, Decimal = 0.01})
        --
        local UniversalDeadzoneFOV = UniversalFOVSettings:Toggle({Name = "Deadzone FOV", Flag = "UniversalDeadzoneFOVEnabled", Default = false})
        UniversalDeadzoneFOV:ColorPicker({Name = "Deadzone FOV Color", Flag = "UniversalDeadzoneColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        UniversalFOVSettings:Slider({Name = "Deadzone FOV Transparency", Flag = "UniversalDeadzoneFOVTransparency", Min = 0, Max = 1, Default = 0.5, Decimal = 0.01})
    end
    --
    do -- Trigger Bot
        local UniversalTriggerBotToggle = UniversalTriggerBot:Toggle({Name = "Trigger Bot Enabled", Flag = "UniversalTriggerBotEnabled"})
        UniversalTriggerBotToggle:Keybind({Default = "T"})
        --
        UniversalTriggerBot:Slider({Name = "Delay", Flag = "UniversalTriggerBotDelay", Min = 0, Max = 1000, Default = 10, Decimal = 1})
        --
        UniversalTriggerBot:Slider({Name = "Interval", Flag = "UniversalTriggerBotInterval", Min = 0, Max = 1000, Default = 50, Decimal = 1})
        --
        UniversalTriggerBot:Dropdown({Name = "Hit Scan Priority", Flag = "UniversalTriggerBotOrigin", Content = {"Camera", "Head", "Torso"}, Default = "Camera"})
    end
    --
    do -- Checks
        UniversalChecks:Toggle({Name = "Wall Check", Default = true, Flag = "UniversalWallCheck"})
        --
        UniversalChecks:Toggle({Name = "Alive Check", Default = true, Flag = "UniversalAliveCheck"})
        --
        UniversalChecks:Toggle({Name = "ForceField Check", Flag = "UniversalForceFieldCheck"})
        --
        UniversalChecks:Toggle({Name = "Team Check", Flag = "UniversalTeamCheck"})
        --
        UniversalChecks:Toggle({Name = "Friend Check", Flag = "UniversalFriendCheck"})
    end
end
--
do -- ESP
    local PlayersVisualSection = ESPTab:Section({Name = "Players", Side = "Left"})
    local PlayersSettingsSection = ESPTab:Section({Name = "Players Settings", Side = "Right"})
    local PlayersColorSection = ESPTab:Section({Name = "Player Colors", Side = "Right"})
    --
    do -- Players
        local ESPEnabled = PlayersVisualSection:Toggle({Name = "ESP Enabled", Callback = function(State)
            ESP.Enabled = State
        end})
        ESPEnabled:Keybind({Default = "H"})
        --
        PlayersVisualSection:Toggle({Name = "Dynamic Box", Default = false, Callback = function(State)
            ESP.BoxDynamic = State
        end})
        --
        local BoxSettings = PlayersVisualSection:Toggle({Name = "Box", Default = true, Callback = function(State)
            ESP.BoxEnabled = State
        end})
        BoxSettings:ColorPicker({Name = "Box Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.BoxColor = State
        end})
        --
        PlayersVisualSection:Dropdown({Name = "Box Type", Content = {"Corner", "2D"}, Default = "Corner", Callback = function(State)
            if State == "Corner" then
                ESP.BoxCorners = true
            else
                ESP.BoxCorners = false
            end
        end})
        --
        local BoxFillSettings = PlayersVisualSection:Toggle({Name = "Box Fill", Default = true, Callback = function(State)
            ESP.BoxFill = State
        end})
        BoxFillSettings:ColorPicker({Name = "Box Fill Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.BoxFillColor = State
        end})
        --
        PlayersVisualSection:Slider({Name = "Box Fill Transparency", Min = 0, Max = 1, Default = 0.25, Decimal = 0.01, Callback = function(State)
            ESP.BoxFillTransparency = tonumber(State)
        end})
        --
        PlayersVisualSection:Toggle({Name = "Name", Default = true, Callback = function(State)
            ESP.TextLayout.name.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Tool", Default = true, Callback = function(State)
            ESP.TextLayout.tool.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Distance", Default = true, Callback = function(State)
            ESP.TextLayout.distance.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Health Bar", Default = true, Callback = function(State)
            ESP.BarLayout.health.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Health Number", Default = true, Callback = function(State)
            ESP.TextLayout.health.enabled = State
        end})
        --
        local HealthBarColorFull = PlayersVisualSection:Label({Message = "Health Bar Full"})
        HealthBarColorFull:ColorPicker({Name = "Full Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.BarLayout.health.color_full = State
        end})
        --
        local HealthBarColorEmpty = PlayersVisualSection:Label({Message = "Health Bar Empty"})
        HealthBarColorEmpty:ColorPicker({Name = "Empty Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(State)
            ESP.BarLayout.health.color_empty = State
        end})
        --
        if CurrentGame.Name == "Da Hood" then
            PlayersVisualSection:Toggle({Name = "Armor Bar", Default = true, Callback = function(State)
                ESP.BarLayout.armor.enabled = State
            end})
            --
            PlayersVisualSection:Toggle({Name = "Armor Number", Default = true, Callback = function(State)
                ESP.TextLayout.armor.enabled = State
            end})
            --
            local ArmorBarColorFull = PlayersVisualSection:Label({Message = "Armor Bar Full"})
            ArmorBarColorFull:ColorPicker({Name = "Full Color", Default = Color3.fromRGB(0, 136, 194), Callback = function(State)
                ESP.BarLayout.armor.color_full = State
            end})
            --
            local ArmorBarColorEmpty = PlayersVisualSection:Label({Message = "Armor Bar Empty"})
            ArmorBarColorEmpty:ColorPicker({Name = "Empty Color", Default = Color3.fromRGB(0, 136, 194), Callback = function(State)
                ESP.BarLayout.armor.color_empty = State
            end})
        end
        --
        PlayersVisualSection:Toggle({Name = "Flags", Default = true, Callback = function(State)
            ESP.TextLayout.flags.enabled = State
        end})
        --
        local OutOfViewArrows = PlayersVisualSection:Toggle({Name = "Out Of View Arrows", Default = true, Callback = function(State)
            ESP.OutOfViewArrows = State
        end})
        OutOfViewArrows:ColorPicker({Name = "Out Of View Arrows Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.OutOfViewArrowColor = State
        end})
        --
        PlayersVisualSection:Slider({Name = "Out Of View Arrows Transparency", Min = 0, Max = 1, Default = 0.75, Decimal = 0.01, Callback = function(State)
            ESP.OutOfViewArrowTransparency = tonumber(State)
        end})
        --
        PlayersVisualSection:Toggle({Name = "Out Of View Arrows Filled", Default = true, Callback = function(State)
            ESP.OutOfViewArrowFilled = State
        end})
        --
        local SkeletonSettings = PlayersVisualSection:Toggle({Name = "Skeletons", Callback = function(State)
            ESP.SkeletonEnabled = State
        end})
        SkeletonSettings:ColorPicker({Name = "Skeletons Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.SkeletonColor = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Chams", Callback = function(State)
            ESP.ChamsEnabled = State
        end})
        --
        local ChamsInnerSettings = PlayersVisualSection:Label({Message = "Chams Inner Color"})
        ChamsInnerSettings:ColorPicker({Name = "Inner Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.ChamsInnerColor = State
        end})
        --
        local ChamsOutterSettings = PlayersVisualSection:Label({Message = "Chams Outer Color"})
        ChamsOutterSettings:ColorPicker({Name = "Outer Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.ChamsOuterColor = State
        end})
        --
        PlayersVisualSection:Slider({Name = "Chams Inner Transparency", Min = 0, Max = 1, Default = 0.7, Decimal = 0.01, Callback = function(State)
            ESP.ChamsInnerTransparency = tonumber(State)
        end})
        --
        PlayersVisualSection:Slider({Name = "Chams Outer Transparency", Min = 0, Max = 1, Default = 0.2, Decimal = 0.01, Callback = function(State)
            ESP.ChamsOuterTransparency = tonumber(State)
        end})
    end
    --
    do -- Player Colors
        local ESPHighlightTarget = PlayersColorSection:Toggle({Name = "Highlight Target", Flag = "ESPHighlightTargetEnabled", Default = true, Callback = function(State)
            ESP.HighlightTarget = State
        end})
        ESPHighlightTarget:ColorPicker({Name = "Target Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(State)
            ESP.PriorityColor = State
        end})
        --
        local ESPHighlightTarget = PlayersColorSection:Toggle({Name = "Highlight Friends", Flag = "ESPHighlightFriendsEnabled", Default = true, Callback = function(State)
            ESP.HighlightFriends = State
        end})
        ESPHighlightTarget:ColorPicker({Name = "Friends Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.FriendsColor = State
        end})
    end
    --
    do -- Player Settings
        PlayersSettingsSection:Toggle({Name = "Local Player", Default = false, Callback = function(State)
            if State then
                ESP.NewPlayer(Client, "LocalPlayer")
            else
                ESP.RemovePlayer(Client)
            end
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Target Only", Flag = "ESPTargetOnly", Default = true, Callback = function(State)
            ESP.TargetOnly = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Max Distance", Default = true, Callback = function(State)
            ESP.MaxDistance = State
        end})
        --
        PlayersSettingsSection:Slider({Name = "Max Distance Amount", Min = 50, Max = 2500, Default = 250, Decimal = 1, Callback = function(State)
            ESP.MaxDistanceAmount = tonumber(State)
        end})
        --
        local TextColorSettings = PlayersSettingsSection:Label({Message = "Text Color"})
        TextColorSettings:ColorPicker({Name = "Text Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.TextColor = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Use Display Name", Default = true, Callback = function(State)
            ESP.UseDisplay = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Alive Check", Default = true, Callback = function(State)
            ESP.AliveCheck = State
        end})
        --
        if CurrentGame.Name == "Da Hood" then
            PlayersSettingsSection:Toggle({Name = "Knocked Check", Default = true, Callback = function(State)
                ESP.KnockedCheck = State
            end})
        end
        --
        if CurrentGame.Name ~= "Da Hood" then
            PlayersSettingsSection:Toggle({Name = "Team Check", Default = false, Callback = function(State)
                ESP.TeamCheck = State
            end})
        end
        --
        PlayersSettingsSection:Toggle({Name = "Visible Only", Default = false, Callback = function(State)
            ESP.VisibleOnly = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Wall Check", Default = false, Callback = function(State)
            ESP.WallCheck = State
        end})
        --
        local ESPVisibleColor = PlayersSettingsSection:Label({Message = "Visible Color"})
        ESPVisibleColor:ColorPicker({Name = "Visible Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.VisibleColor = State
        end})
        --
        local ESPNonVisibleColor = PlayersSettingsSection:Label({Message = "Non Visible Color"})
        ESPNonVisibleColor:ColorPicker({Name = "Non Visible Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(State)
            ESP.NonVisibleColor = State
        end})
    end
end
--
do -- Visuals
    local CursorVisualSection = VisualsTab:Section({Name = "Cursor", Side = "Left"})
    local WorldVisualSection = VisualsTab:Section({Name = "World", Side = "Right"})
    local PredVisualizerSection = VisualsTab:Section({Name = "Prediction Visualizer", Side = "Right"})
    --
    do -- World
        WorldVisualSection:Toggle({Name = "Remove Shadows", Flag = "VisualsShadows", Callback = Visuals.Refresh})
        --
        WorldVisualSection:Toggle({Name = "Use Clock Time", Flag = "VisualsClockTimeEnabled"})
        --
        WorldVisualSection:Slider({Name = "Clock Time", Flag = "VisualsClockTime", Min = 1, Max = 24, Default = 12, Decimal = 1})
        --
        WorldVisualSection:Toggle({Name = "Ambience", Flag = "VisualsAmbience", Callback = Visuals.Refresh})
        --
        local WorldVisualsIndoorColor = WorldVisualSection:Label({Message = "Indoor Ambience Color"})
        WorldVisualsIndoorColor:ColorPicker({Name = "Indoor Ambience Color", Flag = "VisualsAmbienceIndoor", Default = Color3.fromRGB(100, 200, 155), Callback = Visuals.Refresh})
        --
        local WorldVisualOutdoorColor = WorldVisualSection:Label({Message = "Outdoor Ambience Color"})
        WorldVisualOutdoorColor:ColorPicker({Name = "Outdoor Ambience Color", Flag = "VisualsAmbienceOutdoor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.Refresh})
        --
        local WorldVisualFog = WorldVisualSection:Toggle({Name = "Fog", Flag = "VisualsFog", Callback = Visuals.Refresh})
        WorldVisualFog:ColorPicker({Name = "Fog Color", Flag = "VisualsFogColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.Refresh})
        --
        WorldVisualSection:Slider({Name = "Fog Start", Flag = "VisualsFogStart", Min = 0, Max = 5000, Default = 35, Decimal = 1, Callback = Visuals.Refresh})
        --
        WorldVisualSection:Slider({Name = "Fog End", Flag = "VisualsFogEnd", Min = 0, Max = 5000, Default = 350, Decimal = 1, Callback = Visuals.Refresh})
    end
    --
    do -- Pred Visualizer
        local PredictionVisualizerEnabled = PredVisualizerSection:Toggle({Name = "Enable Visualizers", Flag = "PredVisualizersEnabled"})
        PredictionVisualizerEnabled:ColorPicker({Name = "Visualizer Color", Flag = "PredVisualizerColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        PredVisualizerSection:Toggle({Name = "Chams", Flag = "PredVisualizersChams"})
        --
        PredVisualizerSection:Dropdown({Name = "Chams Material", Flag = "PredVisualizerChamsMaterial", Content = {"ForceField", "Plastic", "Neon"}, Default = "ForceField"})
        --
        PredVisualizerSection:Toggle({Name = "Dot", Flag = "PredVisualizersDot"})
        --
        PredVisualizerSection:Toggle({Name = "Line", Flag = "PredVisualizersLine"})
        --
        PredVisualizerSection:Toggle({Name = "Hit Point", Flag = "PredVisualizersHitPoint"})
        --
        PredVisualizerSection:Dropdown({Name = "Hit Part Visualization", Flag = "PredVisualizerHitPart", Content = {"Head", "HumanoidRootPart", "LowerTorso", "UpperTorso", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg", "RightFoot", "LeftFoot", "LeftUpperArm", "RightUpperArm", "RightLowerArm", "LeftLowerArm", "LeftHand", "RightHand"}, Default = "HumanoidRootPart"})
    end
    --
    if CurrentGame.Name == "Da Hood" then
        do -- Bullet Tracers
            local BulletTracerSection = VisualsTab:Section({Name = "Bullet Tracers", Side = "Left"})
            --
            local BulletTracerEnabled = BulletTracerSection:Toggle({Name = "Enabled", Flag = "BulletTracers"})
            BulletTracerEnabled:ColorPicker({Name = "Bullet Tracer Color", Flag = "BulletTracerColor", Default = Color3.fromRGB(0, 255, 0)})
            --
            BulletTracerSection:Dropdown({Name = "Bullet Tracer Type", Flag = "BulletTracerType", Content = {"Beam", "Drawing"}, Default = "Beam"})
            --
            local BulletImpactsEnabled = BulletTracerSection:Toggle({Name = "Impacts", Flag = "BulletImpacts"})
            --
            local BulletImpactColor = BulletTracerSection:Label({Message = "Impact Color"})
            BulletImpactColor:ColorPicker({Name = "Impact Color", Flag = "BulletImpactsColor", Default = Color3.fromRGB(0, 255, 0)})
        end
        --
        do -- In game crosshair
            local InGameCrosshairSection = VisualsTab:Section({Name = "In Game Crosshair", Side = "Left"})
            --
            local InGameCursorEnabled = InGameCrosshairSection:Toggle({Name = "Visible", Flag = "InGameCrosshairVisible", Default = true})
            InGameCursorEnabled:ColorPicker({Name = "Crosshair Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
                Client.PlayerGui.MainScreenGui.Aim.BackgroundColor3 = State
                --
                for i, v in next, Client.PlayerGui.MainScreenGui.Aim:GetChildren() do 
                    v.BackgroundColor3 = State
                end
            end})
            --
            InGameCrosshairSection:Toggle({Name = "Spinning", Flag = "InGameCrosshairSpin", Callback = function()
                Client.PlayerGui.MainScreenGui.Aim.Rotation = 0
            end})
            --
            InGameCrosshairSection:Slider({Name = "Spinning Speed", Flag = "InGameCrosshairSpinSpeed", Min = 1, Max = 10, Default = 3, Decimal = 0.1})
        end
        --
        do -- Backtrack
            local BacktrackSection = VisualsTab:Section({Name = "Back Track", Side = "Left"})
            --
            local BacktrackEnabled = BacktrackSection:Toggle({Name = "Enabled", Flag = "BacktrackEnabled"})
            BacktrackEnabled:ColorPicker({Name = "Back Track Color", Flag = "BacktrackColor", Default = Color3.fromRGB(0, 255, 0)})
            --
            BacktrackSection:Slider({Name = "Delay", Flag = "BacktrackDelay", Min = 0.1, Max = 10, Default = 2, Decimal = 0.1})
            --
            BacktrackSection:Dropdown({Name = "Material", Flag = "BacktrackMaterial", Content = {"Neon", "ForceField", "Plastic"}, Default = "ForceField"})
        end
        --
        do -- AimViewer
            local AimviewSection = VisualsTab:Section({Name = "Aimviewer", Side = "Left"})
            --
            local AimviewEnabled = AimviewSection:Toggle({Name = "Enabled", Default = true, Flag = "AimviewerEnabled"})
            AimviewEnabled:ColorPicker({Name = "Aim viewer Color", Flag = "AimviewerColor", Default = Color3.fromRGB(0, 255, 0)})
        end
        --
        do -- Hit Detection
            local HitDetectionSection = VisualsTab:Section({Name = "Hit Detection", Side = "Right"})
            --
            HitDetectionSection:Toggle({Name = "Enabled", Flag = "HitDetectionEnabled"})
            --
            HitDetectionSection:Toggle({Name = "Notifications", Flag = "HitDetectionNotifications"})
            --
            HitDetectionSection:Dropdown({Name = "Sound Type", Flag = "HitDetectionSoundType", Content = {"None", "Skeet", "Neverlose", "Rust", "Minecraft"}, Default = "Skeet"})
            --
            HitDetectionSection:Dropdown({Name = "Effect Type", Flag = "HitDetectionEffectType", Content = {"None", "Clone", "Slash", "Lightning", "Solar", "Galaxy", "Water"}, Default = "Clone"})
            --
            HitDetectionSection:Dropdown({Name = "Effect Material", Flag = "HitDetectionEffectMaterial", Content = {"ForceField", "Neon", "Plastic"}, Default = "ForceField"})
            --
            local HitEffectColor = HitDetectionSection:Label({Message = "Effect Color"})
            HitEffectColor:ColorPicker({Name = "Hit Effect Color", Flag = "HitDetectionEffectColor", Default = Color3.fromRGB(0, 255, 0)})
        end
        --
        do -- Tools
            local ToolsVisualSection = VisualsTab:Section({Name = "Weapons", Side = "Right"})
            --
            local WeaponPlayerChams = ToolsVisualSection:Toggle({Name = "Weapon Chams", Flag = "WeaponVisualsEnabled", Callback = Visuals.ToolRefresh})
            WeaponPlayerChams:ColorPicker({Name = "Weapon Chams Color", Flag = "WeaponVisualsColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.ToolRefresh})
            --
            ToolsVisualSection:Dropdown({Name = "Weapon Material", Flag = "WeaponVisualsMaterial", Content = {"ForceField", "Neon", "Plastic"}, Default = "Neon", Callback = Visuals.ToolRefresh})
            --
            ToolsVisualSection:Slider({Name = "Weapons Transparency", Flag = "WeaponVisualsTransparency", Min = 0, Max = 1, Default = 0, Decimal = 0.01, Callback = Visuals.ToolRefresh})
        end
        --
        do -- Local Player
            local ClientVisualSection = VisualsTab:Section({Name = "Client", Side = "Right"})
            --
            local LocalPlayerChams = ClientVisualSection:Toggle({Name = "Character Chams", Flag = "ClientPlayerChams", Callback = Visuals.ClientRefresh})
            LocalPlayerChams:ColorPicker({Name = "Character Chams Color", Flag = "ClientPlayerChamsColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.ClientRefresh})
            --
            local TrailEffect = ClientVisualSection:Toggle({Name = "Trail", Flag = "ClientVisualsTrail", Callback = function(State)
                if State and ClientCharacter then
                    for i, v in pairs(ClientCharacter:GetChildren()) do
                        if v:IsA("BasePart") then
                            local trail = Instance.new("Trail", v)
                            trail.Texture = "rbxassetid://1390780157"
                            trail.Parent = v
                            local attachment0 = Instance.new("Attachment", v)
                            attachment0.Name = "TrailAttachment0"
                            local attachment1 = Instance.new("Attachment", ClientCharacter.HumanoidRootPart)
                            attachment1.Name = "TrailAttachment1"
                            trail.Attachment0 = attachment0
                            trail.Attachment1 = attachment1
                            trail.Color = ColorSequence.new(Library.Flags["ClientVisualsTrailColor"])
                        end
                    end
                elseif not State or not ClientCharacter then
                    for i, v in pairs(ClientCharacter:GetChildren()) do
                        if v:FindFirstChild("Trail") then
                            v.Trail:Destroy()
                        end
                        if v.Name == "TrailAttachment0" or v.Name == "TrailAttachment1" then
                            v:Destroy()
                        end
                    end
                end
            end})
            TrailEffect:ColorPicker({Name = "Trail Color", Flag = "ClientVisualsTrailColor", Default = Color3.fromRGB(0, 255, 0)})
            --
            ClientVisualSection:Toggle({Name = "In Game UI", Flag = "InGameUIVisuals", Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Energy Color"})
            InGameEnergyUI:ColorPicker({Name = "Energy Color", Flag = "InGameEnergyColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Health Color"})
            InGameEnergyUI:ColorPicker({Name = "Health Color", Flag = "InGameHealthColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Armor Color"})
            InGameEnergyUI:ColorPicker({Name = "Armor Color", Flag = "InGameArmorColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Fire Armor Color"})
            InGameEnergyUI:ColorPicker({Name = "Fire Armor Color", Flag = "InGameFireArmorColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
        end
    end
    --
    do -- Cursor
        local CursorEnabled = CursorVisualSection:Toggle({Name = "Enabled", Callback = function(State)
            Cursor.enabled = State
        end})
        CursorEnabled:ColorPicker({Name = "Cursor Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            Cursor.color = State
        end})
        --
        CursorVisualSection:Toggle({Name = "Text", Callback = function(State)
            Cursor.textenabled = State
        end})
        --
        CursorVisualSection:Toggle({Name = "Pulsing", Callback = function(State)
            Cursor.pulse = State
        end})
        --
        CursorVisualSection:Dropdown({Name = "Cursor Method", Flag = "CursorMethod", Content = {"Mouse", "Sticky"}, Default = "Mouse"})
        --
        CursorVisualSection:Slider({Name = "Width", Min = 0.1, Max = 3, Default = 1, Decimal = 0.1, Callback = function(State)
            Cursor.width = State
        end})
        --
        CursorVisualSection:Slider({Name = "Length", Min = 5, Max = 25, Default = 10, Decimal = 0.1, Callback = function(State)
            Cursor.length = State
        end})
        --
        CursorVisualSection:Slider({Name = "Gap", Min = 5, Max = 25, Default = 10, Decimal = 0.1, Callback = function(State)
            Cursor.radius = State
        end})
        --
        CursorVisualSection:Toggle({Name = "Spinning", Default = true, Callback = function(State)
            Cursor.spin = State
        end})
        --
        CursorVisualSection:Slider({Name = "Spinning Speed", Min = 100, Max = 500, Default = 200, Callback = function(State)
            Cursor.spin_speed = State
        end})
        --
        CursorVisualSection:Dropdown({Name = "Easing Style", Content = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"}, Default = "Back", Callback = function(State)
            Cursor.spin_style = Enum.EasingStyle[State]
        end})
        --
        CursorVisualSection:Toggle({Name = "Resize", Callback = function(State)
            Cursor.resize = State
        end})
        --
        CursorVisualSection:Slider({Name = "Resizing Speed", Min = 50, Max = 500, Default = 150, Callback = function(State)
            Cursor.resize_speed = State
        end})
    end
end
--
do -- Movement
    local MiscAntilockSection = MiscTab:Section({Name = "Anti Aim", Side = "Left"})
    local MiscMovementSection = MiscTab:Section({Name = "Movement", Side = "Left"})
    local MiscTargetStrafeSection = MiscTab:Section({Name = "Target Strafe", Side = "Right"})
    local MiscCommandsSection = MiscTab:Section({Name = "Commands", Side = "Right"})
    --
    do -- Commands
        MiscCommandsSection:Toggle({Name = "Target Command", Default = true, Flag = "MiscTargetCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Target Command", Default = ">Target", Max = 30, Flag = "MiscTargetCommand"})
        --
        MiscCommandsSection:Toggle({Name = "Goto Command", Default = true, Flag = "MiscGotoCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Goto Command", Default = ">Goto", Max = 30, Flag = "MiscGotoCommand"})
        --
        MiscCommandsSection:Toggle({Name = "Spectate Command", Default = true, Flag = "MiscSpectateCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Spectate Command", Default = ">Spec", Max = 30, Flag = "MiscSpectateCommand"})
        --
        MiscCommandsSection:Toggle({Name = "Aimviewer Command", Default = true, Flag = "MiscAimviewerCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Aimviewer Command", Default = ">Aimview", Max = 30, Flag = "MiscAimviewerCommand"})
    end
    --
    do -- Anti Lock
        local AntiLockDesync = MiscAntilockSection:Toggle({Name = "Desync", Flag = "DesyncEnabled"})
        AntiLockDesync:Keybind({Default = "Z"})
        --
        MiscAntilockSection:Dropdown({Name = "Presets", Flag = "DesyncPreset", Content = {"None", "Walkable", "Disabler"}, Default = "None"})
        --
        MiscAntilockSection:Slider({Name = "Velocity X", Flag = "DesyncX", Min = -10000, Max = 10000, Default = 5000, Decimal = 1})
        --
        MiscAntilockSection:Slider({Name = "Velocity Y", Flag = "DesyncY", Min = -10000, Max = 10000, Default = 5000, Decimal = 1})
        --
        MiscAntilockSection:Slider({Name = "Velocity Z", Flag = "DesyncZ", Min = -10000, Max = 10000, Default = 5000, Decimal = 1})
        --[[
        local DesyncVisualization = MiscAntilockSection:Toggle({Name = "Visualization", Flag = "DesyncVisualization", Callback = function(State)
            if State then
                if ClientCharacter then
                    Visualisation:CreateVisual(ClientCharacter)
                end
            else
                Visualisation:DestroyVisual()
            end
        end})
        DesyncVisualization:ColorPicker({Name = "Visualization Color", Flag = "DesyncVisualizationColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        MiscAntilockSection:Dropdown({Name = "Visualization Material", Flag = "DesyncVisualizationMaterial", Content = {"ForceField", "Neon", "Plastic"}, Default = "ForceField"})
        ]]
    end
    --
    do -- Movement
        local MovementCFrame = MiscMovementSection:Toggle({Name = "CFrame Speed", Flag = "MovementCFrame"})
        MovementCFrame:Keybind({Default = "X"})
        --
        MiscMovementSection:Slider({Name = "CFrame Speed Amount", Flag = "MovementCFrameAmount", Min = 1, Max = 100, Default = 20, Decimal = 0.1})
        --
        local MovementFlyEnabled = MiscMovementSection:Toggle({Name = "Fly", Flag = "MovementFly"})
        MovementFlyEnabled:Keybind({Default = "F"})
        --
        MiscMovementSection:Slider({Name = "Fly Speed", Flag = "MovementFlySpeed", Min = 1, Max = 300, Default = 100, Decimal = 0.1})
        --
        MiscMovementSection:Toggle({Name = "Bunny Hop", Flag = "MovementBhop"})
        --
        MiscMovementSection:Toggle({Name = "No Clip", Flag = "MovementNoClip", Callback = function(State)
            local Noclip = nil
            local Clip = nil
            
            function noclip()
                Clip = false
                local function Nocl()
                    if Clip == false and ClientCharacter ~= nil then
                        for _,v in pairs(ClientCharacter:GetDescendants()) do
                            if v:IsA('BasePart') and v.CanCollide then
                                v.CanCollide = false
                            end
                        end
                    end
                    Wait(0.21)
                end
                LuckyHub["Connections"].NoClip = RunService.Stepped:Connect(Nocl)
            end
            --
            function clip()
                if LuckyHub["Connections"].NoClip then LuckyHub["Connections"].NoClip:Disconnect() end
                Clip = true
            end
            --
            if State then
                noclip()
            else
                clip()
            end
        end})
    end
    --
    do -- Target Strafe
        local TargetStrafeEnabled = MiscTargetStrafeSection:Toggle({Name = "Target Strafe Enabled", Flag = "TargetStrafeEnabled"})
        TargetStrafeEnabled:Keybind({Default = "J"})
        --
        MiscTargetStrafeSection:Dropdown({Name = "Strafe Type", Flag = "TargetStrafeType", Content = {"Strafe", "Random"}, Default = "Strafe"})
        --
        MiscTargetStrafeSection:Slider({Name = "Speed", Flag = "TargetStrafeSpeed", Min = 0.1, Max = 25, Default = 3, Decimal = 0.1})
        --
        MiscTargetStrafeSection:Slider({Name = "Distance", Flag = "TargetStrafeDistance", Min = 1, Max = 25, Default = 10, Decimal = 0.1})
        --
        MiscTargetStrafeSection:Slider({Name = "Height", Flag = "TargetStrafeHeight", Min = 0, Max = 15, Default = 5, Decimal = 0.1})
    end
    --
    if CurrentGame.Name == "Da Hood" then
        local MiscAutoBuy = MiscTab:Section({Name = "Auto Buy", Side = "Left"})
        local MiscExtraSection = MiscTab:Section({Name = "Extra", Side = "Right"})
        --
        do -- Auto Buy
            MiscAutoBuy:Dropdown({Name = "Gun", Flag = "MiscGunOption", Content = {"TacticalShotgun", "Revolver", "Double-Barrel SG", "AK-47", "LMG", "P90"}, Default = "Revolver"})
            --
            MiscAutoBuy:Button({Name = "Buy Gun", Flag = "MiscGunBuyButton", Callback = function()
                if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) and not ClientCharacter:FindFirstChild("ForceField") then
                    OldCFrame = ClientCharacter.HumanoidRootPart.CFrame
                    --
                    local Gun = Library.Flags["MiscGunOption"]
                    local RealGunName = Format("[%s]", Gun)
                    --
                    if Library.Flags["MiscGunOption"] ~= "Double-Barrel SG" then
                        if not Client.Backpack:FindFirstChild(RealGunName) then
                            LuckyHub:AutoBuy(Library.Flags["MiscGunOption"], "Gun")
                            Wait(0.6)
                        end
                    else
                        if not Client.Backpack:FindFirstChild("[Double-Barrel SG]") then
                            LuckyHub:AutoBuy("Double", "Gun")
                            Wait(0.6)
                        end
                    end
                    --
                    ClientCharacter.HumanoidRootPart.CFrame = OldCFrame
                end
            end})
            --
            MiscAutoBuy:Button({Name = "Buy Ammo", Flag = "MiscAmmoBuyButton", Callback = function()
                if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) and not ClientCharacter:FindFirstChild("ForceField") then
                    OldCFrame = ClientCharacter.HumanoidRootPart.CFrame
                    --
                    local Gun = Library.Flags["MiscGunOption"]
                    local RealGunName = Format("[%s]", Gun)
                    --
                    if Library.Flags["MiscGunOption"] ~= "Double-Barrel SG" then
                        if Client.Backpack:FindFirstChild(RealGunName) then
                            LuckyHub:AutoBuy(Library.Flags["MiscGunOption"], "Ammo")
                            Wait(0.6)
                        end
                    else
                        if Client.Backpack:FindFirstChild("[Double-Barrel SG]") then
                            LuckyHub:AutoBuy("Double", "Ammo")
                            Wait(0.6)
                        end
                    end
                    --
                    ClientCharacter.HumanoidRootPart.CFrame = OldCFrame
                end
            end})
        end
        --
        do -- Extra
            MiscExtraSection:Toggle({Name = "Auto Reload", Flag = "MiscAutoReload"})
            --
            MiscExtraSection:Toggle({Name = "Auto Armor", Flag = "MiscAutoArmor"})
            --
            MiscExtraSection:Toggle({Name = "Auto Stomp", Flag = "MiscAutoStomp", Callback = function(State)
                if State then
                    LuckyHub["Connections"].AutoStomp = RunService.RenderStepped:Connect(function()
                        RemoteEvent:FireServer("Stomp")
                    end)
                else
                    if LuckyHub["Connections"].AutoStomp then LuckyHub["Connections"].AutoStomp:Disconnect() end
                end
            end})
            --
            MiscExtraSection:Toggle({Name = "No Slow", Flag = "MovementNoSlowdown"})
            --
            local OldCamera
            MiscExtraSection:Toggle({Name = "No Recoil", Flag = "MiscNoRecoil", Callback = function(State)
                if State then
                    local OldCameraCFrame = Workspace.CurrentCamera.CFrame
                    OldCamera = Workspace.CurrentCamera
                    OldCamera.Parent = nil
            
                    NewCamera = Instance.new("Camera", Workspace)
                    NewCamera.CameraSubject = ClientCharacter.Humanoid ~= nil and ClientCharacter.Humanoid
                    NewCamera.CFrame = OldCameraCFrame
                    NewCamera.CameraType = "Custom"
                else
                    if NewCamera then
                        NewCamera:Destroy()
                    end
                    --
                    if OldCamera ~= nil then
                        OldCamera.Parent = Workspace
                    end
                end
            end})
            --
            MiscExtraSection:Toggle({Name = "No Jump Cooldown", Flag = "MovementNoJumpCooldown"})
            --
            MiscExtraSection:Toggle({Name = "Anti Bag", Flag = "MiscAntiBag"})
            --
            MiscExtraSection:Toggle({Name = "Anti Void", Flag = "MiscAntiVoid", Callback = function(State)
                Workspace.FallenPartsDestroyHeight = State and -50000 or -500
            end})
            --
            MiscExtraSection:Toggle({Name = "Infinite Zoom", Flag = "MiscInfiniteZoom", Callback = function(State)
                if State then
                    Client.CameraMaxZoomDistance = Huge
                else
                    Client.CameraMaxZoomDistance = 30
                end
            end})
            --
            MiscExtraSection:Toggle({Name = "Disable Seats", Flag = "MiscRemoveSeats", Callback = function(State)
                if State then
                    ClientCharacter:FindFirstChild("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                else
                    ClientCharacter:FindFirstChild("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                end
            end})
        end
    end
end
--
do -- Settings
    local SettingsUI = SettingsTab:Section({Name = "UI", Side = "Left"})
    local ConfigSettings = SettingsTab:Section({Name = "Configuration", Side = "Right"})
    local UserUISettings = SettingsTab:Section({Name = "User Information", Side = "Right"})
    --
    do -- UI
        SettingsUI:Dropdown({Name = "UI Name Position", Content = {"Left", "Center", "Right"}, Default = "Center", Callback = function(State)
            Main:UpdateTextPosition(State)
        end})
        --
        local TextEffect = SettingsUI:Toggle({Name = "UI Name Text Effect", Flag = "UITextEffect", Default = true})
        local CloseUI = SettingsUI:Toggle({Name = "Open UI", Default = true, Callback = function(State)
            Main:MainUIVisibility(State)
        end})
        CloseUI:Keybind({Default = Enum.KeyCode.LeftAlt, HideFromList = true})
        --
        local WatermarkToggle = SettingsUI:Toggle({Name = "Watermark", Default = true, Callback = function(State) Main:WatermarkVisibility(State) end})
        local KeybindListToggle = SettingsUI:Toggle({Name = "Keybind List", Callback = function(State) Main:KeybindListVisibility(State) end})
        local IndicatorToggle = SettingsUI:Toggle({Name = "Indicators", Callback = function(State) Main:IndicatorVisibility(State) end})
        local VelocityStatsToggle = SettingsUI:Toggle({Name = "Velocity Stats", Callback = function(State) Main:VelocityStatsVisibility(State) end})
    end
    --
    do -- Config
        local ConfigList = ConfigSettings:Dropdown({Name = "Configs", Flag = "ConfigConfig_List"})
        --
        ConfigSettings:TextBox({PlaceHolder = "Config Name", Max = 32, Flag = "ConfigListConfigName"})
        --
        local CurrentList = {};
        --
        local function UpdateConfigList()
			local List = {};
			for idx, file in ipairs(listfiles("LuckyHub/Configs/Public")) do
				local FileName = file:gsub("LuckyHub/Configs/Public\\", ""):gsub(".LuckyHub", "")
				List[#List + 1] = FileName;
			end;

			local IsNew = #List ~= #CurrentList
			if not IsNew then
				for idx, file in ipairs(List) do
					if file ~= CurrentList[idx] then
						IsNew = true;
						break;
					end;
				end;
			end;

			if IsNew then
				CurrentList = List;
                ConfigList:Add("Config", Library.Flags["ConfigListConfigName"])
			end;
		end;
        --
        ConfigSettings:Button({Name = "Create", Flag = "ConfigConfig_Create", Callback = function()
            local ConfigName = Library.Flags["ConfigListConfigName"]
            --
            if ConfigName == "" or isfile("LuckyHub/Configs/Public/" .. ConfigName .. ".LuckyHub") then
				return;
			end
            --
			writefile("LuckyHub/Configs/Public/" .. ConfigName .. ".LuckyHub", Utility:GetConfig())
            --
            UpdateConfigList()
        end})
        --
        ConfigSettings:Button({Name = "Save", Flag = "ConfigConfig_Save", Callback = function()
            local SelectedConfig = Library.Flags["ConfigConfig_List"]
            --
			if SelectedConfig then
				writefile("LuckyHub/Configs/Public/" .. SelectedConfig .. ".LuckyHub", Utility:GetConfig())
			end
        end})
        --
        ConfigSettings:Button({Name = "Load", Flag = "ConfigConfig_Load", Callback = function()
            
        end})
        --
        ConfigSettings:Button({Name = "Delete", Callback = function()
            local SelectedConfig = Library.Flags["ConfigConfig_List"]
            --
			if SelectedConfig then
				delfile("LuckyHub/Configs/Public/" .. SelectedConfig .. ".LuckyHub")
			end
        end})
    end
    --
    do -- User
        local DaysLeft = LPH_OBFUSCATED and string.format("%s Days", tostring((LRM_SecondsLeft ~= math.huge and (LRM_SecondsLeft / 86400)) or "Unlimited")) or "N/A"
        local Executions = LPH_OBFUSCATED and string.format("%s", tostring(LRM_TotalExecutions) or "N/A") or "N/A"
        --
        UserUISettings:Label({Message = ("Username: %s"):format(Client.Name)})
        UserUISettings:Label({Message = ("Subscription: %s"):format(DaysLeft)})
        UserUISettings:Label({Message = ("Executions: %s"):format(Executions)})
        UserUISettings:Label({Message = ("Build Version: %s"):format(LuckyHub.Shared.Build)})
    end
end
--
local temp = tick()
local Tick = tick()
--
RunService.PreRender:Connect(LPH_NO_VIRTUALIZE(function()
	local FPS = math.floor(1 / math.abs(temp - tick()))
	temp = tick()
	local Ping = Stats.Network:FindFirstChild("ServerStatsItem") and tostring(math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())) or "N/A"
	--
	task.spawn(function()
		if (tick() - Tick) > 0.15 then
				Main:UpdateWatermark(string.format("LuckyHub | Build: Buyer | Ping: %s | FPS: %s", tostring(Ping), tostring(FPS)))
			--
			Tick = tick()
		end
	end)
end))
--
RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
        Utility:ThreadFunction(LuckyHub.UpdateFOV, "0x01")
        --
        if Library.Flags["SilentAimEnabled"] and Library.Flags["TargetMode"] == "FOV" then
            Utility:ThreadFunction(LuckyHub.GetTarget, "0x02")
        end
        --
        Utility:ThreadFunction(LuckyHub.CalculateAimpoint, "0x03")
        --
        Utility:ThreadFunction(LuckyHub.AutoPrediction, "0x04")
        --
        Utility:ThreadFunction(LuckyHub.DrawVisualizations, "0x11")
        --
        if Library.Flags["AimAssistEnabled"] and Library.Flags["TargetMode"] == "FOV" then
            Utility:ThreadFunction(LuckyHub.GetAimAssistTarget, "0x05")
        end
        --
        Utility:ThreadFunction(LuckyHub.AimAssist, "0x06")
        --
        Utility:ThreadFunction(Movement.Update, "0x10")
        --
        if CurrentGame.Name == "Da Hood" then
            Utility:ThreadFunction(LuckyHub.RotateCursor, "0x10")
        end
        --
        Utility:ThreadFunction(LuckyHub.GetUniversalAimAssistTarget, "0x119")
        Utility:ThreadFunction(LuckyHub.UniversalAimAssist, "0x120")
        --
        Utility:ThreadFunction(LuckyHub.GetTriggerBotTarget, "0x121")
        Utility:ThreadFunction(LuckyHub.TriggerBot, "0x122")
        --
        Utility:ThreadFunction(LuckyHub.DrawAimviewers, "0x124")
        --
        Utility:ThreadFunction(LuckyHub.UpdateHealth, "0x125")
        --
        if Library.Flags["ESPHighlightTargetEnabled"] and Library.Flags["TargetMode"] == "Target" then
            ESP.UpdateTarget(LuckyHub.Locals.AimAssistTarget)
        end
end))
--
Spawn(function()
    while true do 
        task.wait(Library.Flags["BacktrackDelay"])
        --
        if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character then 
            if Library.Flags["BacktrackEnabled"] then
                LuckyHub:CreateClone(LuckyHub.Locals.Target, Library.Flags["BacktrackColor"], Library.Flags["BacktrackMaterial"], LuckyHub.Folders["Part Chams"]);
                task.wait(Library.Flags["BacktrackDelay"])
                LuckyHub.Folders["Part Chams"]:ClearAllChildren()
            end     
        end 
    end 
end)
--
RunService.PostSimulation:Connect(LPH_NO_VIRTUALIZE(function()
        if Library.Flags["DesyncEnabled"] then 
            if ClientCharacter and LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                oldvel = ClientCharacter.HumanoidRootPart.Velocity
                ClientCharacter.HumanoidRootPart.CFrame = ClientCharacter.HumanoidRootPart.CFrame * CFrame.Angles(0, Rad(0), 0)
                ClientCharacter.HumanoidRootPart.CFrame = ClientCharacter.HumanoidRootPart.CFrame * CFrame.Angles(0, Rad(0.0001), 0)
                ClientCharacter.HumanoidRootPart.Velocity = Vector3.new(Library.Flags["DesyncX"], Library.Flags["DesyncY"], Library.Flags["DesyncZ"])
                RunService.RenderStepped:Wait()
                ClientCharacter.HumanoidRootPart.Velocity = oldvel
                --
                if Library.Flags["DesyncPreset"] ~= "None" then
                    if Library.Flags["DesyncPreset"] == "Walkable" then
                        Library.Flags["DesyncX"] = Random(-10000, 10000)
                        Library.Flags["DesyncY"] = Random(0, 10000)
                        Library.Flags["DesyncZ"] = Random(-10000, 10000)
                    elseif Library.Flags["DesyncPreset"] == "Disabler" then
                        Library.Flags["DesyncX"] = 0
                        Library.Flags["DesyncY"] = 0
                        Library.Flags["DesyncZ"] = 0
                    end
                end
            end
        end
        --
        if Library.Flags["MiscAutoArmor"] then 
            if ClientCharacter.BodyEffects.Armor.Value < 100 then 
                local Pos = ClientCharacter.HumanoidRootPart.CFrame
                ClientCharacter.HumanoidRootPart.CFrame = Workspace.Ignored.Shop["[High-Medium Armor] - $2440"].Head.CFrame
                fireclickdetector(Workspace.Ignored.Shop["[High-Medium Armor] - $2440"].ClickDetector)
                RunService.RenderStepped:Wait()
                ClientCharacter.HumanoidRootPart.CFrame = Pos 
            end 
        end
        --
        if Library.Flags["TargetStrafeEnabled"] and Library.Flags["TargetMode"] == "Target" then
            if LuckyHub.Locals.Target ~= nil then
                if ClientCharacter and LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) and LuckyHub:ClientAlive(LuckyHub.Locals.Target, LuckyHub.Locals.Target.Character, LuckyHub.Locals.Target.Character:FindFirstChild("Humanoid")) then
                    if Library.Flags["TargetStrafeType"] == "Strafe" then
                        Movement.TargetPosition = LuckyHub.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(0, Library.Flags["TargetStrafeHeight"], 0)
                        --
                        Movement.StrafeCalculation += Library.Flags["TargetStrafeSpeed"]
                        --
                        ClientCharacter.HumanoidRootPart.CFrame = CFrame.Angles(0, Rad(Movement.StrafeCalculation), 0) * CFrame.new(0, 0, Library.Flags["TargetStrafeDistance"]) + Movement.TargetPosition
                    else
                        Movement.TargetPosition = LuckyHub.Locals.Target.Character.HumanoidRootPart.Position
                        --
                        ClientCharacter.HumanoidRootPart.CFrame = (CFrame.new(Movement.TargetPosition) + Vector3.new(Random(-Library.Flags["TargetStrafeDistance"], Library.Flags["TargetStrafeDistance"]), Random(0, Library.Flags["TargetStrafeHeight"]), Random(-Library.Flags["TargetStrafeDistance"], Library.Flags["TargetStrafeDistance"])))
                    end
                end
            end
        end
end))
--
do -- UserInput
    UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed then
            if Input.KeyCode == Enum.KeyCode[tostring(LuckyHub:GetAimAssistKeybind()):upper()] then
                if Library.Flags["TargetMode"] == "Target" then
                    if LuckyHub.Locals.AimAssistTarget then
                        LuckyHub.Locals.AimAssistTarget = nil
                        LuckyHub.Locals.Target = nil
                        --
                        Main:UpdateIndicator(LuckyHub.Locals.Target)
                        --
                        if Library.Flags["NotificationsEnabled"] then
                            Library:Notify("Target: nil", 2)
                        end
                    else
                        LuckyHub:GetAimAssistTarget()
                        --
                        if LuckyHub.Locals.AimAssistTarget then
                            LuckyHub.Locals.Target = LuckyHub.Locals.AimAssistTarget
                            --
                            Main:UpdateIndicator(LuckyHub.Locals.Target)
                            --
                            if Library.Flags["NotificationsEnabled"] then
                                Library:Notify(("Target: %s"):format(LuckyHub.Locals.AimAssistTarget.DisplayName), 2)
                            end
                        end
                    end
                end
            end
        end
    end)
end
--
for _, player in next, Players:GetPlayers() do
    if player == Client then continue end
    --
    if player and player:IsFriendsWith(Client.UserId) then
        Library:SetPlayerFlag(player, "Friend")
    end
end

Players.PlayerAdded:Connect(function(player)
    if player and player:IsFriendsWith(Client.UserId) then
        Library:SetPlayerFlag(player, "Friend")
    end
end)
--
do -- Commands
    Client.Chatted:Connect(function(Message)
        local loweredString = string.lower(Message)
        local args = string.split(loweredString," ")
        --
        local TargetCommand = tostring(Library.Flags["MiscTargetCommand"]):lower()
        local GotoCommand = tostring(Library.Flags["MiscGotoCommand"]):lower()
        local SpectateCommand = tostring(Library.Flags["MiscSpectateCommand"]):lower()
        local firstChar = SpectateCommand:sub(1, 1)
        --
        local UnspectateCommand
        --
        if string.match(firstChar, "%p") then
            UnspectateCommand = firstChar .. "un" .. SpectateCommand:sub(2)
        else
            UnspectateCommand = "un" .. SpectateCommand
        end
        --
        local AimviewCommand = tostring(Library.Flags["MiscAimviewerCommand"]):lower()
        --
        if args[1] == TargetCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscTargetCommandEnabled"] then return end
                --
                if Library.Flags["TargetMode"] == "Target" then
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player == Client then continue end
                        --
                        local NameCheck = string.lower(Player.DisplayName or Player.Name)
                        --
                        if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                            if LuckyHub.Locals.AimAssistTarget == nil then
                                LuckyHub.Locals.AimAssistTarget = Player
                                --
                                if LuckyHub.Locals.AimAssistTarget then
                                    LuckyHub.Locals.Target = LuckyHub.Locals.AimAssistTarget
                                    --
                                    Main:UpdateIndicator(LuckyHub.Locals.Target)
                                    --
                                    if Library.Flags["NotificationsEnabled"] then Library:Notify(("Target: %s"):format(LuckyHub.Locals.AimAssistTarget.DisplayName), 2) end
                                end
                                --
                                break
                            end
                        end
                    end
                end
            end
        elseif args[1] == GotoCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscGotoCommandEnabled"] then return end
                --
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local NameCheck = string.lower(Player.DisplayName or Player.Name)
                    --
                    if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                        if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                            ClientCharacter:FindFirstChild("HumanoidRootPart").CFrame = Player.Character:GetPivot()
                            if Library.Flags["NotificationsEnabled"] then Library:Notify(string.format("Successfully teleported to %s at (%s)", Player.Name, tostring(string.format("%.0f, %.0f, %.0f", Player.Character.HumanoidRootPart.Position.X, Player.Character.HumanoidRootPart.Position.Y, Player.Character.HumanoidRootPart.Position.Z)))) end
                            --
                            break
                        end
                    end
                end
            end
        elseif args[1] == SpectateCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscSpectateCommandEnabled"] then return end
                --
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local NameCheck = string.lower(Player.DisplayName or Player.Name)
                    --
                    if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                        if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                            if LuckyHub.Locals.Spectating == false then
                                LuckyHub.Locals.Spectating = true
                                Workspace.CurrentCamera.CameraSubject = Player.Character
                                --
                                break
                            end
                        end
                    end
                end
            end
        elseif args[1] == UnspectateCommand then
            if not Library.Flags["MiscSpectateCommandEnabled"] then return end
            --
            LuckyHub.Locals.Spectating = false
            Workspace.CurrentCamera.CameraSubject = ClientCharacter
        elseif args[1] == AimviewCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscAimviewerCommandEnabled"] then return end
                --
                for _, Player in pairs(Players:GetPlayers()) do
                    local NameCheck = string.lower(Player.DisplayName or Player.Name)
                    --
                    if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                        LuckyHub.Locals.AimviewerTarget = Player
                        --
                        break
                    end
                end
            end
        end
    end)
end
--
local function Ammo()
    LuckyHub:HitDetection()
end
--
LuckyHub["Connections"]["HitDetection"] = {}
--
Client.CharacterAdded:Connect(function(Character)
    repeat Wait() until Character:FindFirstChildOfClass("Humanoid")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    --
    Wait(0.5)
    --
    ClientCharacter = Character
    --
    if Library.Flags["ClientVisualsTrail"] and ClientCharacter then
        for i, v in pairs(ClientCharacter:GetChildren()) do
            if v:IsA("BasePart") then
                local trail = Instance.new("Trail", v)
                trail.Texture = "rbxassetid://1390780157"
                trail.Parent = v
                local attachment0 = Instance.new("Attachment", v)
                attachment0.Name = "TrailAttachment0"
                local attachment1 = Instance.new("Attachment", ClientCharacter.HumanoidRootPart)
                attachment1.Name = "TrailAttachment1"
                trail.Attachment0 = attachment0
                trail.Attachment1 = attachment1
                trail.Color = ColorSequence.new(Library.Flags["ClientVisualsTrailColor"])
            end
        end
    end
    --
    Visuals:ClientRefresh()
    --
    if LuckyHub["Connections"]["HitDetection"][1] then 
        LuckyHub["Connections"]["HitDetection"][1]:Disconnect()
        LuckyHub["Connections"]["HitDetection"][1] = nil
    end
    --
    Character.ChildAdded:Connect(function(child)
        if Library.Flags["MiscAntiBag"] and child.Name == "Christmas_Sock" then
            child:Destroy()
        end
        --
        if child:IsA("Tool") then
            if LuckyHub.Locals.ToolConnection[1] == nil then
                LuckyHub.Locals.ToolConnection[1] = child 
            end

            if LuckyHub.Locals.ToolConnection[1] ~= child and LuckyHub.Locals.ToolConnection[2] ~= nil then 
                LuckyHub.Locals.ToolConnection[2]:Disconnect()
                LuckyHub.Locals.ToolConnection[1] = child
            end

            if not LuckyHub["Connections"]["HitDetection"][child] then 
                LuckyHub["Connections"]["HitDetection"][child] = child:FindFirstChild("Ammo") and child.Ammo:GetPropertyChangedSignal("Value"):Connect(Ammo)
            end

            if child:FindFirstChild("Ammo") then
                Visuals:ToolRefresh()
            end
    
            LuckyHub.Locals.ToolConnection[2] = child.Activated:Connect(function()
                if Library.Flags["MiscAutoReload"] then
                    if child:FindFirstChild("Ammo") ~= nil then
                        --
                        if child["Ammo"].Value == 0 then
                            RemoteEvent:FireServer("Reload", child)
                        end
                    end
                end
                --
                if LuckyHub.Locals.Target ~= nil and Library.Flags["SilentAimEnabled"] and CurrentGame.MouseArguments then
                    RemoteEvent:FireServer(CurrentGame.MouseArguments, LuckyHub.Locals.AimPoint + LuckyHub.Locals.AimOffset)
                end
            end)
        end
    end)
end)
--
Client.CharacterRemoving:Connect(function(Character)
    if Visualisation.Character then
        for Index, Value in pairs(Visualisation.Character) do
            Utility:RemoveInstance(Value)
        end
    end
    --
    for i, v in pairs(ClientCharacter:GetChildren()) do
        if v:FindFirstChild("Trail") then
            v.Trail:Destroy()
        end
        if v.Name == "TrailAttachment0" or v.Name == "TrailAttachment1" then
            v:Destroy()
        end
    end
    --
    Visualisation.Character = nil
end)
--
ClientCharacter.ChildAdded:Connect(function(child)
    if Library.Flags["MiscAntiBag"] and child.Name == "Christmas_Sock" then
        child:Destroy()
    end
    --
    if child:IsA("Tool") then
        if LuckyHub.Locals.ToolConnection[1] == nil then
            LuckyHub.Locals.ToolConnection[1] = child 
        end

        if LuckyHub.Locals.ToolConnection[1] ~= child and LuckyHub.Locals.ToolConnection[2] ~= nil then 
            LuckyHub.Locals.ToolConnection[2]:Disconnect()
            LuckyHub.Locals.ToolConnection[1] = child
        end

        if not LuckyHub["Connections"]["HitDetection"][child] then
            LuckyHub["Connections"]["HitDetection"][child] = child:FindFirstChild("Ammo") and child.Ammo:GetPropertyChangedSignal("Value"):Connect(Ammo)
        end

        if child:FindFirstChild("Ammo") then
            Visuals:ToolRefresh()
        end

        LuckyHub.Locals.ToolConnection[2] = child.Activated:Connect(function()
            if Library.Flags["MiscAutoReload"] then
                if child:FindFirstChild("Ammo") ~= nil then
                    --
                    if child["Ammo"].Value == 0 then
                        RemoteEvent:FireServer("Reload", child)
                    end
                end
            end
            --
            if LuckyHub.Locals.Target ~= nil and Library.Flags["SilentAimEnabled"] and CurrentGame.MouseArguments then
                RemoteEvent:FireServer(CurrentGame.MouseArguments, LuckyHub.Locals.AimPoint + LuckyHub.Locals.AimOffset)
            end
        end)
    end
end)
--
Spawn(function()
    LPH_NO_VIRTUALIZE(function()
        local Counter = 1
        local TotalLength = #ChangingTitle
        local Direction = false
        while true do
            if Library.Flags["UITextEffect"] then
                Main:UpdateTitle(ChangingTitle[Counter])
                    
                if Counter >= TotalLength then
                    Direction = true
                elseif Counter <= 1 then
                    Direction = false
                end

                if Direction == true then
                    Counter -= 1
                else
                    Counter += 1
                end
            else
                Main:UpdateTitle("LuckyHub")
                Counter = 1
            end

            Wait(0.3)
        end
    end)()
end)
--
Library:Init()
--
if ExecutionTime then
    if LPH_OBFUSCATED then
        if LRM_TotalExecutions == 1 then
            Library:Notify(("Welcome to LuckyHub, %s! Succesfully loaded in %s seconds."):format(Client.Name, string.format("%.".."4".."f", os.clock() - ExecutionTime)), 5)
        end
    else
        Library:Notify(("Succesfully loaded in %s seconds."):format(string.format("%.".."4".."f", os.clock() - ExecutionTime)), 5)
    end
end
