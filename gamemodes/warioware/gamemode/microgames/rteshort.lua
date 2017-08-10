local microgame = Microgame()

microgame.Title = "Reach the end!"
microgame.Vars = {}
microgame.Vars.music = "minigame_31"
microgame.Vars.length = 8
microgame.Vars.respawnAtEnd = true
microgame.Vars.gameWinnable = true
function microgame:Start()
	local randomChoice = math.random(1,7)
	LoadPropTable("RTEShort" .. randomChoice)
	local spikeTable = {}
	spikeTable["models/platformmaster/1x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x4x1spike.mdl"] = true
	hook.Add("PlayerTick", "ReachEnd", function(pl, move)
		if move:GetOrigin():WithinAABox(propTable.goalVolume.mins,propTable.goalVolume.maxs) and pl:BroadAlive() then
			WinMinigame(pl, "Congratulations!")
		end
		if not pl:BroadAlive() then
			LoseMinigame(pl, "Ouch! Let's try that again.")
		else
			pl:SetHealth(math.min(pl:Health() + 1, pl:GetMaxHealth()))
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
	curSpawnVolume.mins = propTable.spawnVolume.mins
	curSpawnVolume.maxs = propTable.spawnVolume.maxs
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		if propTable.spawnAng then
			v:SetEyeAngles(propTable.spawnAng)
		end
		v:SetMaxHealth(100)
		v:SetHealth(100)
		v:SetRealSpeed(0.01)
	end
	timer.Simple(0.5, function()
		for i, v in ipairs(player.GetAll()) do
			v:SetRealSpeed(400)
		end
	end)
end
function microgame:End()
	hook.Remove("PlayerTick", "ReachEnd")
	DestroyPropTable()
	for k, v in pairs(curInstancedPropTable) do
		if v:IsValid() then
			v:Remove()
		end
	end
	for i, v in ipairs(player.GetAll()) do
		v:SetMaxHealth(200)
		v:SetHealth(200)
		v:SetRealSpeed(320)
	end
end