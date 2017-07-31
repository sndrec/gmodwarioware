DEFINE_BASECLASS( "gamemode_base" )
include( "proptables.lua" )
include( "goalvolumes.lua" )

bossMinigames = {}

local curID = 1
bossMinigames[curID] = {}
bossMinigames[curID].Title = "Reach the end!"
bossMinigames[curID].Vars = {}
bossMinigames[curID].Vars.music = "minigame_6"
bossMinigames[curID].Vars.length = 53
bossMinigames[curID].Vars.respawnAtStart = true
bossMinigames[curID].Vars.curSpawnVolume = {}
bossMinigames[curID].Vars.curSpawnVolume.mins = Vector(5217,2657,4127)
bossMinigames[curID].Vars.curSpawnVolume.maxs = Vector(6000,3300,4302)
bossMinigames[curID].Vars.respawnAtEnd = true
bossMinigames[curID].Vars.props = {}
bossMinigames[curID].Vars.ents = {}
bossMinigames[curID].Vars.gameWinnable = true
bossMinigames[curID].Start = function()
	bossMinigames[curID].Vars.instancedProps = {}
	local randomChoice = math.random(1,4)
	print("random choice = " .. randomChoice)
	LoadPropTable("RTELong" .. randomChoice)
	local spikeTable = {}
	spikeTable["models/platformmaster/1x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x4x1spike.mdl"] = true
	hook.Add("PlayerTick", "ReachEnd", function(pl, move)
		if move:GetVelocity().z < -1500 then
			LoseMinigame(pl, "Ouch! Let's try that again.")
		end
		if move:GetOrigin():WithinAABox(propTable.goalVolume.mins,propTable.goalVolume.maxs) and pl:BroadAlive() then
			WinMinigame(pl, "Congratulations!")
		end
		if not pl:BroadAlive() then
			LoseMinigame(pl, "Ouch! Let's try that again.")
		end
		local spikeTR = util.TraceHull({
			start = move:GetOrigin(),
			endpos = move:GetOrigin() + (move:GetVelocity() * FrameTime()),
			filter = pl,
			mins = pl:OBBMins(),
			maxs = pl:OBBMaxs()
		})
		if spikeTR.Hit and spikeTable[spikeTR.Entity:GetModel()] and pl:BroadAlive() then
			pl:Kill()
		end
		if pl:OnGround() then
			local spikeTR2 = util.TraceHull({
				start = move:GetOrigin(),
				endpos = move:GetOrigin() + (move:GetVelocity() * FrameTime()) - Vector(0,0,4),
				filter = pl,
				mins = pl:OBBMins(),
				maxs = pl:OBBMaxs()
			})
			if spikeTR2.Hit and spikeTable[spikeTR2.Entity:GetModel()] and pl:BroadAlive() then
				pl:Kill()
			end
		end
	end)
	hook.Add("PlayerDeathThink", "ReachEndThink", function(pl)
		if pl.respawnTime and CurTime() > pl.respawnTime then
			pl:Spawn()
		end
	end)
	hook.Add("PlayerDeath", "ReachEndRespawn", function(pl)
		pl.respawnTime = CurTime() + 2
	end)
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetEyeAngles(propTables["ReachTheEnd" .. randomChoice].spawnAng)
		v:SetMaxHealth(100)
		v:SetHealth(100)
	end
end
bossMinigames[curID].End = function()
	DestroyPropTable()
	hook.Remove("PlayerTick", "ReachEnd")
	hook.Remove("PlayerDeathThink", "ReachEndThink")
	hook.Remove("PlayerDeath", "ReachEndRespawn")
	for i, v in ipairs(bossMinigames[curID].Vars.instancedProps) do
		if v:IsValid() then
			v:Remove()
		end
	end
	for i, v in ipairs(player.GetAll()) do
		v:SetMaxHealth(200)
		v:SetHealth(200)
	end
end

curID = curID + 1
bossMinigames[curID] = {}
bossMinigames[curID].Title = ""
bossMinigames[curID].Vars = {}
bossMinigames[curID].Vars.music = "minigame_28"
bossMinigames[curID].Vars.length = 89
bossMinigames[curID].Vars.respawnAtStart = true
bossMinigames[curID].Vars.curSpawnVolume = {}
bossMinigames[curID].Vars.curSpawnVolume.mins = Vector(5632, 0, 4500) - Vector(512,512, 0)
bossMinigames[curID].Vars.curSpawnVolume.maxs = Vector(5632, 0, 4600) + Vector(512,512, 0)
bossMinigames[curID].Vars.respawnAtEnd = true
bossMinigames[curID].Vars.props = {}
bossMinigames[curID].Vars.ents = {}
bossMinigames[curID].Vars.walls = {}
bossMinigames[curID].Vars.gameWinnable = false
bossMinigames[curID].Start = function()
	for i = 1, 8, 1 do
		for n = 1, 8, 1 do
			local tempPlat = ents.Create("prop_physics")
			tempPlat:SetModel("models/platformmaster/4x4x1.mdl")
			tempPlat:SetMaterial("jumpbox")
			tempPlat:SetPos(Vector(5632, 0, 4096) + Vector(((i - 4) * 256) + 128, ((n - 4) * 256) + 128, 0))
			tempPlat:Spawn()
			tempPlat:PhysicsInitShadow(false,false)
			tempPlat:SetSolid(SOLID_VPHYSICS)
			tempPlat:SetColor(Color(180,80,80))
			local tempPhys = tempPlat:GetPhysicsObject()
			tempPhys:EnableMotion(false)
			table.insert(bossMinigames[curID].Vars.props, tempPlat)
		end
	end
	for i = 1, 8, 1 do
		local tempPlat = ents.Create("prop_physics")
		tempPlat:SetModel("models/platformmaster/4x4x1.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(5632, 0, 4096) + Vector(1024 + 256, ((i - 4) * 256) + 128, 128 + 32))
		tempPlat:SetAngles(Angle(90,0,0))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(180,80,80))
		table.insert(bossMinigames[curID].Vars.props, tempPlat)
		table.insert(bossMinigames[curID].Vars.walls, tempPlat)
	end
	for i = 1, 8, 1 do
		local tempPlat = ents.Create("prop_physics")
		tempPlat:SetModel("models/platformmaster/4x4x1.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(5632, 0, 4096) + Vector(-512 - 256, ((i - 4) * 256) + 128, 128 + 32))
		tempPlat:SetAngles(Angle(-90,0,0))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(180,80,80))
		table.insert(bossMinigames[curID].Vars.props, tempPlat)
		table.insert(bossMinigames[curID].Vars.walls, tempPlat)
	end
	for i = 1, 8, 1 do
		local tempPlat = ents.Create("prop_physics")
		tempPlat:SetModel("models/platformmaster/4x4x1.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(5632, 0, 4096) + Vector(((i - 4) * 256) + 128, 1024 + 256, 128 + 32))
		tempPlat:SetAngles(Angle(90,90,0))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(180,80,80))
		table.insert(bossMinigames[curID].Vars.props, tempPlat)
		table.insert(bossMinigames[curID].Vars.walls, tempPlat)
	end
	for i = 1, 8, 1 do
		local tempPlat = ents.Create("prop_physics")
		tempPlat:SetModel("models/platformmaster/4x4x1.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(5632, 0, 4096) + Vector(((i - 4) * 256) + 128, -512 - 256, 128 + 32))
		tempPlat:SetAngles(Angle(-90,90,0))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(180,80,80))
		table.insert(bossMinigames[curID].Vars.props, tempPlat)
		table.insert(bossMinigames[curID].Vars.walls, tempPlat)
	end
	local playerTable = player.GetAll()
	local taggerTable = {}

	for i = 1, math.ceil(#player.GetAll() * 0.25), 1 do
		local tagger, key = table.Random(playerTable)
		table.insert(taggerTable, tagger)
		table.remove(playerTable, key)
	end
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetMaxHealth(100)
		v:SetHealth(100)
		print(v:GetViewOffset())
	end
	for i, v in ipairs(playerTable) do
		CreateClientText(v, "Don't get tagged!", 4, "CCMed", 0.5, 0.35, Color(80,220,80))
		v.runner = true
		v:SetModelScale(0.75, 0)
		v:SetRealSpeed(400)
		v:SetPos(Vector(5300, 0, 4200) + Vector(0,(1200 / #playerTable) * i, 0))
		v:SetViewOffset(Vector(0,0,48))
	end
	for i, v in ipairs(taggerTable) do
		CreateClientText(v, "Tag every runner!", 4, "CCMed", 0.5, 0.35, Color(80,220,80))
		v.tagger = true
		v:SetModelScale(1.5, 0)
		v:SetRealSpeed(270)
		v:SetPos(Vector(6300, 0, 4200) + Vector(0,(400 / #taggerTable) * i, 0))
		v:SetEyeAngles(Angle(0,180,0))
		v:SetViewOffset(Vector(0,0,92))
	end
	for i, v in ipairs(bossMinigames[curID].Vars.walls) do
		local tempPhys = v:GetPhysicsObject()
		tempPhys:EnableMotion(true)
		tempPhys:UpdateShadow(v:GetPos() + (v:GetAngles():Up() * -512), v:GetAngles(), 75)
	end
	hook.Add("PlayerTick", "TaggersTick", function(pl, move)
		if pl.tagger and pl:BroadAlive() then
			local vel2D = move:GetVelocity()
			vel2D.z = 0
			local tr = util.TraceHull({
				start = move:GetOrigin(),
				endpos = move:GetOrigin() + (vel2D * FrameTime() * 3),
				filter = pl,
				mins = pl:OBBMins() - Vector(24,24,0),
				maxs = pl:OBBMaxs() + Vector(24,24,0)
			})
			if tr.Hit and tr.Entity.runner and tr.Entity:BroadAlive() then
				LoseMinigame(tr.Entity, "Better luck next time...")
				local allTagged = true
				for i, v in ipairs(player.GetAll()) do
					if v.runner and v:BroadAlive() then
						allTagged = false
					end
				end
				if allTagged == true then
					for i, v in ipairs(taggerTable) do
						WinMinigame(v, "You got 'em all!")
					end
					timer.Simple(4, function()
						EndMinigame()
					end)
				end
			end
		end
	end)
	hook.Add("PlayerDeathThink", "TaggerDeathThink", function(pl)
		if pl.respawnTime and CurTime() > pl.respawnTime then
			pl:Spawn()
			SpawnAsSpec(pl)
		end
	end)
	hook.Add("PlayerDeath", "TaggerDeath", function(victim, inflictor, attacker)	
		victim.respawnTime = CurTime() + 3
	end)
end
bossMinigames[curID].End = function()
	hook.Remove("PlayerTick", "TaggersTick")
	hook.Remove("PlayerDeathThink", "TaggerDeathThink")
	hook.Remove("PlayerDeath", "TaggerDeath")
	for i, v in ipairs(bossMinigames[curID].Vars.props) do
		if v:IsValid() then
			v:Remove()
		end
	end
	bossMinigames[curID].Vars.props = {}
	bossMinigames[curID].Vars.walls = {}
	for i, v in ipairs(player.GetAll()) do
		if v:BroadAlive() and v.runner then
			v.gameWon = true
		end
		v.runner = false
		v.tagger = false
		v:SetModelScale(1, 0)
		v:SetWWMovement(0)
		v:SetViewOffset(Vector(0,0,64))
	end
end

curID = curID + 1
bossMinigames[curID] = {}
bossMinigames[curID].Title = "Don't fall!"
bossMinigames[curID].Vars = {}
bossMinigames[curID].Vars.music = "minigame_33"
bossMinigames[curID].Vars.length = 41.4
bossMinigames[curID].Vars.respawnAtStart = true
bossMinigames[curID].Vars.curSpawnVolume = {}
bossMinigames[curID].Vars.curSpawnVolume.mins = Vector(2670, -760, 4725)
bossMinigames[curID].Vars.curSpawnVolume.maxs = Vector(3425, -156, 4800)
bossMinigames[curID].Vars.respawnAtEnd = true
bossMinigames[curID].Vars.props = {}
bossMinigames[curID].Vars.ents = {}
bossMinigames[curID].Vars.walls = {}
bossMinigames[curID].Vars.gameWinnable = false
bossMinigames[curID].Start = function()
	LoadPropTable("hexagons")
	local hexProps = {}
	local newTimer = CurTime() + 15
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetHealth(5000000)
		v:Give("weapon_fists")
		v.gameWon = true
	end
	for i, v in ipairs(ents.FindByClass("prop_physics")) do
		v:SetPos(v:GetPos() - Vector(0,0,math.random() * 100))
		table.insert(hexProps, v)
	end
	hook.Add("EntityTakeDamage", "DFBossDamageHook", function(target, dmginfo)
		local newAng = dmginfo:GetAttacker():EyeAngles() + Angle(-35,0,0)
		newAng.p = math.Clamp(newAng.p, -65, -35)
		dmginfo:SetDamageForce(newAng:Forward())
		dmginfo:SetDamage(120)
		local tr = util.TraceHull({
			start = target:GetPos(),
			endpos = target:GetPos() + Vector(0,0,8),
			filter = player.GetAll(),
			mins = target:OBBMins(),
			maxs = target:OBBMaxs()
		})
		target:SetPos(tr.HitPos)
		target.lastHitter = dmginfo:GetAttacker()
		target.lastHit = CurTime()
	end)
	local deathDelay = CurTime() + 1
	hook.Add("PlayerTick", "DFPlayerTickHook", function(pl, move)

		if CurTime() > deathDelay and move:GetOrigin().z < 3500 then
			LoseMinigame(pl, "Better luck next time...")
		end
		if pl:BroadAlive() and pl:OnGround() and pl.lastHit and CurTime() > pl.lastHit + 1 then
			pl.lastHitter = nil
		end
	end)
	hook.Add("PlayerDeathThink", "DFDeathThink", function(pl)
		if pl.respawnTime and CurTime() > pl.respawnTime then
			pl:Spawn()
			SpawnAsSpec(pl)
			local twoAlive = 0
			for i, v in ipairs(player.GetAll()) do
				if v:BroadAlive() then
					twoAlive = twoAlive + 1
				end
			end
			if twoAlive <= 1 then
				EndMinigame()
			end
		end
	end)
	hook.Add("PlayerDeath", "DFDeath", function(victim, inflictor, attacker)
		victim.respawnTime = CurTime() + 3
		if victim.lastHitter then
			CreateClientText(victim.lastHitter, "You knocked out " .. victim:Nick() .. "!", 2, "CCSmall", 0.5, 0.65, Color(80,220,80))
			SendSound("ui/beepclear.wav", victim.lastHitter, 100, 0.75)
		end
	end)
	hook.Add("Tick", "DFTick", function()
		if CurTime() > newTimer then
			newTimer = CurTime() + 1.5
			local randProp, key = table.Random(hexProps)
			randProp:SetColor(Color(200,100,100))
			table.remove(hexProps, key)
			timer.Simple(1.5, function()
				if not randProp:IsValid() then return end
				randProp:SetColor(Color(80,80,80))
				randProp:GetPhysicsObject():UpdateShadow(randProp:GetPos() - Vector(0,0,2000),randProp:GetAngles(),2)
			end)
		end
	end)
end
bossMinigames[curID].End = function()
	DestroyPropTable()
	hook.Remove("EntityTakeDamage", "DFBossDamageHook")
	hook.Remove("PlayerTick", "DFPlayerTickHook")
	hook.Remove("PlayerDeathThink", "DFDeathThink")
	hook.Remove("PlayerDeath", "DFDeath")
	hook.Remove("Tick", "DFTick")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end

curID = curID + 1
bossMinigames[curID] = {}
bossMinigames[curID].Title = "Dodge the blocks!"
bossMinigames[curID].Vars = {}
bossMinigames[curID].Vars.music = "minigame_34"
bossMinigames[curID].Vars.length = 90
bossMinigames[curID].Vars.respawnAtStart = true
bossMinigames[curID].Vars.curSpawnVolume = {}
bossMinigames[curID].Vars.curSpawnVolume.mins = Vector(4672, 1411, 4128)
bossMinigames[curID].Vars.curSpawnVolume.maxs = Vector(6586, 1534, 4200)
bossMinigames[curID].Vars.respawnAtEnd = true
bossMinigames[curID].Vars.props = {}
bossMinigames[curID].Vars.ents = {}
bossMinigames[curID].Vars.walls = {}
bossMinigames[curID].Vars.gameWinnable = false
bossMinigames[curID].Start = function()
	local deathDelay = CurTime() + 1
	LoadPropTable("dodgetheprops")
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetHealth(100)
		v.gameWon = true
		v:SetEyeAngles(Angle(0,90,0))
		v:SetRealSpeed(0)
	end
	timer.Simple(1, function()
		for i, v in ipairs(player.GetAll()) do
			v:Spawn()
			v:SetHealth(100)
			v.gameWon = true
			v:SetEyeAngles(Angle(0,90,0))
			v:SetRealSpeed(400)
		end
	end)
	hook.Add("PlayerTick", "DodgePlayerTickHook", function(pl, move)
		if CurTime() > deathDelay and move:GetOrigin().z < 3500 then
			LoseMinigame(pl, "Better luck next time...")
		end	
	end)
	hook.Add("PlayerDeathThink", "DodgeDeathThink", function(pl)
		if pl.respawnTime and CurTime() > pl.respawnTime then
			pl:Spawn()
			SpawnAsSpec(pl)
			local twoAlive = 0
			for i, v in ipairs(player.GetAll()) do
				if v:BroadAlive() then
					twoAlive = twoAlive + 1
				end
			end
			if twoAlive == 0 then
				EndMinigame()
			end
		end
	end)
	hook.Add("PlayerDeath", "DodgeDeath", function(victim, inflictor, attacker)
		victim.respawnTime = CurTime() + 3
	end)
	modelTable = {}
	table.insert(modelTable, "models/platformmaster/1x1x1.mdl")
	table.insert(modelTable, "models/platformmaster/2x1x1.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x1.mdl")
	table.insert(modelTable, "models/platformmaster/4x1x1.mdl")
	table.insert(modelTable, "models/platformmaster/4x2x2.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x1.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x2.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x1l.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x2l.mdl")
	table.insert(modelTable, "models/platformmaster/3x2x1t.mdl")
	table.insert(modelTable, "models/platformmaster/3x2x2t.mdl")
	table.insert(modelTable, "models/platformmaster/3x3x1c.mdl")
	table.insert(modelTable, "models/platformmaster/3x3x2c.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x1l.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x2l.mdl")
	table.insert(modelTable, "models/platformmaster/6x4x1t.mdl")
	table.insert(modelTable, "models/platformmaster/6x4x2t.mdl")
	table.insert(modelTable, "models/platformmaster/6x6x1c.mdl")
	table.insert(modelTable, "models/platformmaster/6x6x2c.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x2cyl.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x1cyl.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x2cyl.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x1cyl.mdl")
	table.insert(modelTable, "models/platformmaster/3x2x1l.mdl")
	table.insert(modelTable, "models/platformmaster/3x2x1z.mdl")
	table.insert(modelTable, "models/platformmaster/3x2x2l.mdl")
	table.insert(modelTable, "models/platformmaster/3x2x2z.mdl")
	--table.insert(modelTable, "models/platformmaster/4x2x4bracket.mdl")
	--table.insert(modelTable, "models/platformmaster/4x2x4tunnel.mdl")
	--table.insert(modelTable, "models/platformmaster/4x4x4benis.mdl")
	--table.insert(modelTable, "models/platformmaster/4x4x4bracket.mdl")
	--table.insert(modelTable, "models/platformmaster/4x4x4corner.mdl")
	--table.insert(modelTable, "models/platformmaster/4x4x4tunnel.mdl")
	table.insert(modelTable, "models/platformmaster/6x4x1l.mdl")
	table.insert(modelTable, "models/platformmaster/6x4x1z.mdl")
	table.insert(modelTable, "models/platformmaster/6x4x2l.mdl")
	table.insert(modelTable, "models/platformmaster/6x4x2z.mdl")
	table.insert(modelTable, "models/platformmaster/1x1x1tri.mdl")
	table.insert(modelTable, "models/platformmaster/1x1x2tri.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x1tri.mdl")
	table.insert(modelTable, "models/platformmaster/2x2x2tri.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x1tri.mdl")
	table.insert(modelTable, "models/platformmaster/4x4x2tri.mdl")
	local minSpawn = Vector(4611, 2999, 3968)
	local maxSpawn = Vector(6654, 3001, 4149)
	local spawnTime = CurTime() + 1.8823
	local minigameStart = CurTime()
	local len = bossMinigames[curID].Vars.length
	timer.Simple(86, function()
		spawnTime = CurTime() + 1000
	end)
	hook.Add("Tick", "DodgeTick", function()
		local percentDone = (CurTime() - minigameStart) / len
		if CurTime() > spawnTime then
			spawnTime = CurTime() + (0.3 / ((percentDone * 3) + 1))
			local newEnt = ents.Create("prop_physics")
			newEnt:SetModel(table.Random(modelTable))
			newEnt:SetPos(Vector(math.random(minSpawn.x, maxSpawn.x),math.random(minSpawn.y, maxSpawn.y),math.random(minSpawn.z, maxSpawn.z)))
			newEnt:SetAngles(Angle(math.random(0,3) * 90, math.random(0,3) * 90, math.random(0,3) * 90))
			newEnt:Spawn()
			newEnt:SetMaterial("jumpbox")
			newEnt:PhysicsInitShadow(true,true)
			newEnt:SetModelScale(0,0)
			newEnt:SetModelScale(1,0.5)
			newEnt:SetColor(HSVToColor((percentDone * 320) + 40,1,0.75))
			local tempPhys = newEnt:GetPhysicsObject()
			tempPhys:SetMass(10000)
			tempPhys:UpdateShadow(newEnt:GetPos() - Vector(0,2000,0),newEnt:GetAngles(),6 / ((percentDone * 3) + 1))
			timer.Simple(6 / ((percentDone * 3) + 1), function()
				if newEnt:IsValid() then
					newEnt:Remove()
				end
			end)
		end
	end)
end
bossMinigames[curID].End = function()
	DestroyPropTable()
	hook.Remove("PlayerTick", "DodgePlayerTickHook")
	hook.Remove("PlayerDeathThink", "DodgeDeathThink")
	hook.Remove("PlayerDeath", "DodgeDeath")
	hook.Remove("Tick", "DodgeTick")
	for i, v in ipairs(player.GetAll()) do
		v:SetRealSpeed(320)
	end
end

--mins = Vector(1536, -4096, 0)
--maxs = Vector(9728, 4096, 8192)
--middle = Vector(5632, 0, 4096)

--curID = curID + 1
--bossMinigames[curID] = {}
--bossMinigames[curID].Title = "Reach the end!"
--bossMinigames[curID].Vars = {}
--bossMinigames[curID].Vars.music = "minigame_6"
--bossMinigames[curID].Vars.length = 53
--bossMinigames[curID].Vars.respawnAtStart = true
--bossMinigames[curID].Vars.curSpawnVolume = {}
--bossMinigames[curID].Vars.curSpawnVolume.mins = Vector(5217,2657,4127)
--bossMinigames[curID].Vars.curSpawnVolume.maxs = Vector(6000,3300,4302)
--bossMinigames[curID].Vars.respawnAtEnd = true
--bossMinigames[curID].Vars.props = {}
--bossMinigames[curID].Vars.ents = {}
--bossMinigames[curID].Vars.gameWinnable = true
--bossMinigames[curID].Start = function()
--end
--bossMinigames[curID].End = function()
--end