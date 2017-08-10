local microgame = BossMicrogame()

microgame.Title = "Reach the end!"
microgame.Vars = {}
microgame.Vars.music = "minigame_6"
microgame.Vars.length = 53
microgame.Vars.respawnAtStart = true
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(5217,2657,4127)
microgame.Vars.curSpawnVolume.maxs = Vector(6000,3300,4302)
microgame.Vars.respawnAtEnd = true
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
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
	hook.Add("PlayerSpawn", "ReachEndSpawn", function(pl)
		pl:SetEyeAngles(propTables["ReachTheEnd" .. randomChoice].spawnAng)
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
	end
end
function microgame:End()
	DestroyPropTable()
	hook.Remove("PlayerSpawn", "ReachEndSpawn")
	hook.Remove("PlayerTick", "ReachEnd")
	hook.Remove("PlayerDeathThink", "ReachEndThink")
	hook.Remove("PlayerDeath", "ReachEndRespawn")
	for i, v in ipairs(player.GetAll()) do
		v:SetMaxHealth(200)
		v:SetHealth(200)
	end
end