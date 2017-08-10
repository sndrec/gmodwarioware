local microgame = BossMicrogame()

microgame.Title = "Dodge the blocks!"
microgame.Vars = {}
microgame.Vars.music = "minigame_34"
microgame.Vars.length = 90
microgame.Vars.respawnAtStart = true
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(4672, 1411, 4128)
microgame.Vars.curSpawnVolume.maxs = Vector(6586, 1534, 4200)
microgame.Vars.respawnAtEnd = true
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.walls = {}
microgame.Vars.gameWinnable = false
function microgame:Start()
	local deathDelay = CurTime() + 1
	LoadPropTable("dodgetheprops")
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetHealth(100)
		v.gameWon = true
		v:SetEyeAngles(Angle(0,90,0))
		v:SetRealSpeed(0.01)
	end
	timer.Simple(1, function()
		for i, v in ipairs(player.GetAll()) do
			v:SetRealSpeed(400)
		end
	end)
	hook.Add("PlayerTick", "DodgePlayerTickHook", function(pl, move)
		if CurTime() > deathDelay and pl:BroadAlive() and move:GetOrigin().z < 3500 then
			dmg = DamageInfo()
			dmg:SetDamage(500)
			dmg:SetAttacker(game.GetWorld())
			dmg:SetInflictor(game.GetWorld())
			pl:TakeDamageInfo(dmg)
		end
	end)
	hook.Add("PlayerDeathThink", "DodgeDeathThink", function(pl)
		if pl.respawnTime and CurTime() > pl.respawnTime then
			pl:Spawn()
			SpawnAsSpec(pl)
		end
	end)
	hook.Add("PlayerDeath", "DodgeDeath", function(victim, inflictor, attacker)
		victim.respawnTime = CurTime() + 3
		LoseMinigame(victim, "Better luck next time...")
		local numAlive = 0
		for i, v in ipairs(player.GetAll()) do
			if v:BroadAlive() then
				numAlive = numAlive + 1
			end
		end
		print(numAlive)
		if numAlive <= 1 then
			timer.Simple(3, function()
				EndMinigame()
			end)
		end
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
	local len = self.Vars.length
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
			newEnt:SetColor(HSVToColor((percentDone * 320) + 40,1,0.75))
			newEnt.spawnTime = CurTime()
			newEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			local tempPhys = newEnt:GetPhysicsObject()
			tempPhys:SetMass(10000)
			tempPhys:UpdateShadow(newEnt:GetPos() - Vector(0,2000,0),newEnt:GetAngles(),6 / ((percentDone * 3) + 1))
			timer.Simple(6 / ((percentDone * 3) + 1), function()
				if newEnt:IsValid() then
					newEnt:Remove()
				end
			end)
		end
		for i, v in ipairs(ents.FindByClass("prop_physics")) do
			if v.spawnTime then
				v:SetColor(Color(v:GetColor().r,v:GetColor().g,v:GetColor().b, math.min((CurTime() - v.spawnTime) * 500, 255)))
			end
		end
	end)
end
function microgame:End()
	DestroyPropTable()
	hook.Remove("PlayerTick", "DodgePlayerTickHook")
	hook.Remove("PlayerDeathThink", "DodgeDeathThink")
	hook.Remove("PlayerDeath", "DodgeDeath")
	hook.Remove("Tick", "DodgeTick")
	for i, v in ipairs(player.GetAll()) do
		v:SetRealSpeed(320)
	end
end