local microgame = BossMicrogame()

microgame.Title = "Don't fall!"
microgame.Vars = {}
microgame.Vars.music = "minigame_33"
microgame.Vars.length = 41.4
microgame.Vars.respawnAtStart = true
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(2670, -760, 4725)
microgame.Vars.curSpawnVolume.maxs = Vector(3425, -156, 4800)
microgame.Vars.respawnAtEnd = true
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.walls = {}
microgame.Vars.gameWinnable = false
function microgame:Start()
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
		end
	end)
	hook.Add("PlayerDeath", "DFDeath", function(victim, inflictor, attacker)
		victim.respawnTime = CurTime() + 3
		if victim.lastHitter then
			print(victim.lastHitter)
			CreateClientText(victim.lastHitter, "You knocked out " .. victim:Nick() .. "!", 2, "CCSmall", 0.5, 0.65, Color(80,220,80))
			SendSound("ui/beepclear.wav", victim.lastHitter, 100, 0.75)
		end
		local numAlive = 0
		for i, v in ipairs(player.GetAll()) do
			if v:BroadAlive() then
				numAlive = numAlive + 1
			end
		end
		print(numAlive)
		if numAlive <= 2 then
			timer.Simple(3, function()
				EndMinigame()
			end)
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
function microgame:End()
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