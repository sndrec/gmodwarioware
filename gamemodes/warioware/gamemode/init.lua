AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sounds.lua" )
include( "shared.lua" )
include( "sounds.lua" )
include( "minigames.lua" )
include( "bossminigames.lua" )
util.AddNetworkString("ClientSound")
util.AddNetworkString("CreateClientText")
util.AddNetworkString("DamageKnockback")
util.AddNetworkString("KeyGamePress")
util.AddNetworkString("StopMusic")
util.AddNetworkString("RequestState")
resource.AddWorkshop("999854920")
resource.AddFile("resource/fonts/Comical Cartoon.ttf")

function EndMinigame()
	nextState = CurTime()
	net.Start("StopMusic")
	net.Send(player.GetAll())
end

function StopMusic()
	net.Start("StopMusic")
	net.Send(player.GetAll())
end

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerInitialSpawn(pl)
	pl:SetWWPoints(0)
	pl:SetWWMovement(0)
	pl:SetCanJump(true)
	pl.initSpawn = true
	GAMEMODE:PlayerSpawnAsSpectator(pl)
	timer.Simple(0.1, function()
		pl:KillSilent()
	end)
end

function SpawnAsSpec(pl)
	GAMEMODE:PlayerSpawnAsSpectator(pl)
end

function GM:PlayerSpawn(pl)
	player_manager.SetPlayerClass( pl, "player_ww" )
	BaseClass.PlayerSpawn( self, pl )
	if pl:Team() ~= 1 then
		pl:SetTeam(1)
	end

	local newPos = Vector(math.random(curSpawnVolume.mins.x, curSpawnVolume.maxs.x), math.random(curSpawnVolume.mins.y, curSpawnVolume.maxs.y), curSpawnVolume.maxs.z)
	local tr = util.TraceHull({
		start = newPos,
		endpos = newPos - Vector(0,0,8192),
		mask = MASK_SOLID,
		mins = pl:OBBMins(),
		maxs = pl:OBBMaxs()
	})

	pl:SetPos(tr.HitPos)
	pl.gameWon = false
end

--hook.Add("PlayerTick", "SpectateShit", function(pl, move)
--
--	if pl:GetObserverMode() == OBS_MODE_NONE then return end
--
--	local plTable = player.GetAll()
--	for i = #plTable, 1, -1 do
--		if plTable[i] == pl or plTable[i]:GetObserverMode() ~= OBS_MODE_NONE or plTable[i] == nil then
--			table.remove(plTable, i)
--		end
--	end
--
--	if #plTable < 1 then return end
--
--	if pl.curSpec == nil or plTable[pl.curSpec] == nil then
--		local newpl, k = table.Random(plTable)
--		pl.curSpec = k
--		pl:SpectateEntity(plTable[pl.curSpec])
--	end
--
--	if pl:KeyPressed( IN_ATTACK ) then
--		if pl:GetObserverMode() == OBS_MODE_IN_EYE or pl:GetObserverMode() == OBS_MODE_CHASE then
--			pl.curSpec = pl.curSpec + 1
--			if plTable[pl.curSpec] ~= nil and plTable[pl.curSpec]:IsPlayer() then
--				pl:SpectateEntity(plTable[pl.curSpec])
--			else
--				pl.curSpec = 1
--				pl:SpectateEntity(plTable[pl.curSpec])
--			end
--		end
--	end
--
--	if pl:KeyPressed( IN_ATTACK2 ) then
--		if pl:GetObserverMode() == OBS_MODE_IN_EYE or pl:GetObserverMode() == OBS_MODE_CHASE then
--			pl.curSpec = pl.curSpec - 1
--			if plTable[pl.curSpec] ~= nil and plTable[pl.curSpec]:IsPlayer() then
--				pl:SpectateEntity(plTable[pl.curSpec])
--			else
--				pl.curSpec = #plTable
--				pl:SpectateEntity(plTable[pl.curSpec])
--			end
--		end
--	end
--
--	if pl:KeyPressed( IN_JUMP ) then
--		pl:SetPos(plTable[pl.curSpec]:GetPos())
--		if pl:GetObserverMode() == OBS_MODE_IN_EYE then
--			pl:SetObserverMode(OBS_MODE_CHASE)
--		elseif pl:GetObserverMode() == OBS_MODE_CHASE then
--			pl:SetObserverMode(OBS_MODE_ROAMING)
--		else
--			pl:SetObserverMode(OBS_MODE_IN_EYE)
--		end
--		pl:SetPos(plTable[pl.curSpec]:GetPos())
--	end
--
--end)

nextState = CurTime() + 1
curState = 0
curTimeScale = 1
curRound = 1
bossMicrogame = false
respawnAtEnd = false
forceMiniGame = nil
roundsTilSpeedup = 5
roundsTilBoss = 20
speedUpFactor = 0.1

net.Receive("RequestState", function(len, pl)
	net.Start("RequestState")
	net.WriteInt(curState, 16)
	net.Send(pl)
end)

StopMusic()
timer.Simple(0.05, function()
	net.Start("RequestState")
	net.WriteInt(0, 16)
	net.Send(player.GetAll())
end)

function PlayGlobalSound(script)
	for i, v in ipairs(player.GetAll()) do
		v:EmitSound(script)
	end
end

game.SetTimeScale(1)

function GM:CanPlayerSuicide( pl )
	return pl:BroadAlive()
end

function GM:Tick()
	--[[
	
	0 = waiting for players
	-1 = microgame start
	-2 = microgame over
	-3 = speeding up
	-4 = boss microgame intro
	-5 = game over
	1 and above = microgame
	
	]]
	if CurTime() > nextState then
		local curTable = {}
		if bossMicrogame then
			curTable = bossMinigames
		else
			curTable = minigames
		end
		if curState > 0 then
			curTable[curState].End()
			curState = -2
			nextState = CurTime() + 2
		elseif curState == -5 then
			for i, v in ipairs(player.GetAll()) do
				v:SetWWPoints(0)
				v.ultimateWinner = nil
				v:StripWeapons()
				v:SetHealth(200)
				hook.Remove("EntityTakeDamage", "EndGameHook")
			end
			curState = -1
			nextState = CurTime() + 2
		elseif curState == -4 then
			curState = -1
			bossMicrogame = true
			nextState = CurTime() + 2
		elseif curState == -3 then
			game.SetTimeScale( game.GetTimeScale() + speedUpFactor )
			curState = -1
			nextState = CurTime() + 2
		elseif curState == -2 then
			if curRound % roundsTilBoss == 0 then
				curState = -4
				nextState = CurTime() + 4
			elseif curRound % roundsTilSpeedup == 0 then
				curState = -3
				nextState = CurTime() + 3.8
			elseif bossMicrogame then
				curState = -5
				nextState = CurTime() + 8
			else
				curState = -1
				nextState = CurTime() + 2
			end
		elseif curState == -1 then
			for i, v in ipairs(player.GetAll()) do
				v.gameWon = false
			end
			if forceMiniGame == nil then
				curState = math.random(1, #curTable)
			else
				curState = forceMiniGame
			end
			nextState = CurTime() + curTable[curState].Vars.length
			--print("length.. " .. curTable[curState].Vars.length)
		elseif curState == 0 then
			StopMusic()
			curState = -1
			nextState = CurTime() + 2
			for i, v in ipairs(player.GetAll()) do
				v:SetWWPoints(0)
			end
			timer.Simple(0.1, function()
				PlayGlobalSound("warioware_intro")
			end)
		end
		--print("new state.. " .. curState)

		if curState == -1 then
			PlayGlobalSound("warioware_intro")
				for i, v in ipairs(player.GetAll()) do
					if not v:BroadAlive() then
						v:Spawn()
					end
					v:SetHealth(200)
				end
		elseif curState == -2 then
			curSpawnVolume.mins = Vector(-700,-700,256)
			curSpawnVolume.maxs = Vector(700,700,300)
			for i, v in ipairs(player.GetAll()) do
				if v.gameWon then
					SendSound("gamesound/tf2ware/warioman_win.mp3", v, 100, 0.5)
					CreateClientText(v, "You passed!", 2, "CCBig", 0.5, 0.3, Color(60,255,60))
					if bossMicrogame then
						v:SetWWPoints(v:GetWWPoints() + 5)
					else
						v:SetWWPoints(v:GetWWPoints() + 1)
					end
				else
					SendSound("gamesound/tf2ware/warioman_fail.mp3", v, 100, 0.5)
					CreateClientText(v, "You lost...", 2, "CCBig", 0.5, 0.3, Color(255,60,60))
				end
				if respawnAtEnd then
					v:Spawn()
				end
				if not v:BroadAlive() then
					v:Spawn()
				end
				v:SetHealth(200)
				v:Give("weapon_crowbar", true)
				v:ConCommand("r_cleardecals")
				v:StripWeapons()
			end
			curRound = curRound + 1
			if bossMicrogame then
				curRound = 1
			end
			respawnAtEnd = false
		elseif curState == -3 then
			CreateClientText("all", "Speed up!", 4, "CCBig", 0.5, 0.3, Color(255,255,255))
			PlayGlobalSound("warioware_speedup")
		elseif curState == -4 then
			game.SetTimeScale(1)
			CreateClientText("all", "Boss round!", 4, "CCBig", 0.5, 0.3, Color(255,255,255))
			CreateClientText("all", "Worth 5 points!", 4, "CCSmall", 0.5, 0.35, Color(255,255,255))
			PlayGlobalSound("warioware_boss")
		elseif curState == -5 then
			CreateClientText("all", "Game over!", 8, "CCBig", 0.5, 0.3, Color(255,255,255))
			PlayGlobalSound("warioware_gameover")
			local highest = 0
			for i, v in ipairs(player.GetAll()) do
				if v:GetWWPoints() > highest then
					highest = v:GetWWPoints()
				end
			end
			for i, v in ipairs(player.GetAll()) do
				if v:GetWWPoints() == highest then
					local newwep = v:Give("weapon_pdm_hl2_smg1")
					v:GiveAmmo(60,newwep:GetPrimaryAmmoType(),true)
					v.ultimateWinner = true
				end
			end
			hook.Add("EntityTakeDamage", "EndGameHook", function(target, dmginfo)
				if dmginfo:GetAttacker():IsPlayer() and not target.ultimateWinner then
					dmginfo:ScaleDamage(500)
				end
				if target.ultimateWinner then
					dmginfo:SetDamage(0)
				end
			end)
			bossMicrogame = false
		elseif curState > 0 then
			if curTable[curState].Vars.respawnAtStart then
				curSpawnVolume.mins = curTable[curState].Vars.curSpawnVolume.mins
				curSpawnVolume.maxs = curTable[curState].Vars.curSpawnVolume.maxs
			end
			if curTable[curState].Vars.gameWinnable then
				for i, v in ipairs(player.GetAll()) do
					v.gameWon = false
				end
			else
				for i, v in ipairs(player.GetAll()) do
					v.gameWon = true
				end
			end
			if curTable[curState].Vars.respawnAtEnd then
				respawnAtEnd = true
			end
			if #curTable[1].Vars.props > 0 then
				--print("blah")
			end
			if #curTable[1].Vars.ents > 0 then
				--print("blah")
			end
			if curTable[curState].ShowTitle ~= false then
				CreateClientText("all", curTable[curState].Title, 4, "CCBig", 0.5, 0.3, Color(255,255,255))
			end
			PlayGlobalSound(curTable[curState].Vars.music)
			curTable[curState].Start()
		end
		--print(curRound)
	end
end





function GM:CheckPassword( steamid, networkid, server_password, password, name )
	if server_password ~= "" then
		for i, v in ipairs(player.GetAll()) do
			v:ChatPrint(name .. " just tried to join with the password " .. password)
		end
		if password ~= "benis" and password ~= "bepis" then
			return false, "this is not gud paswort sori"
		end
	end
	return true
end

function GM:PlayerDeathThink(pl)
	if curState == 0 then
		pl:Spawn()
	end
end

function CreateClientText(pl, text, time, font, posx, posy, color)
	net.Start("CreateClientText")
	net.WriteString(text)
	net.WriteFloat(CurTime() + time)
	net.WriteString(font)
	net.WriteFloat(posx)
	net.WriteFloat(posy)
	net.WriteColor(color)
	if pl == "all" then
		net.Send(player.GetAll())
	else
		net.Send(pl)
	end
end

local spawnMenuTable = {}
spawnMenuTable["STEAM_0:0:18689500"] = true
spawnMenuTable["STEAM_0:1:19422930"] = true
spawnMenuTable["STEAM_0:1:23343982"] = true
spawnMenuTable["STEAM_0:0:139136309"] = true

function GM:PlayerNoClip( pl, desiredState )
	return spawnMenuTable[pl:SteamID()]
end

function GM:EntityTakeDamage(ent, dmginfo)

	local attacker = dmginfo:GetAttacker()
	local damage = dmginfo:GetDamage()
	local dir = dmginfo:GetDamageForce()
	dir:Normalize()
	local knockback = math.min(damage, 200)
	
	if ent:IsPlayer() and ent:BroadAlive() then
		if not attacker:IsWorld() and attacker:GetClass() ~= "trigger_hurt" then
			local g_knockback = cvars.Number("q3_g_knockback", 1000)
			local mass = 150
			local kvel = dir * (g_knockback * knockback / mass)
			ent.knockbackVel = kvel
		end
		if ent:HasGodMode() then return true end
	end

	if ent == attacker then
		damage = 0
	end

	if damage < 0 then
		damage = 0
	end
	local take = damage

	if take then
		if not ent:IsPlayer() and ent:Health() <= 0 then return end
		ent:SetHealth(ent:Health() - take)
		local health = ent:Health()
		if ent:IsPlayer() then hook.Call("PlayerHurt", GAMEMODE, ent, attacker, health, damage) end
		if health <= 0 then
			if health < -999 then
				ent:SetHealth(-999)
			end
			return false
		end
	end
	return true
end

function GM:GetFallDamage( pl, speed )
	if speed > 1500 then
		return 1000
	else
		return 0
	end
end

function GM:InitPostEntity()
	RunConsoleCommand("sv_gravity","800")
	RunConsoleCommand("sbox_noclip","0")
	RunConsoleCommand("sv_accelerate","40")
	RunConsoleCommand("sv_friction","20")
	RunConsoleCommand("sv_stopspeed","200")
	RunConsoleCommand("sv_airaccelerate","0")
	RunConsoleCommand("mp_falldamage","1")
end