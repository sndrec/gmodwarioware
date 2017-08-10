local microgame = Microgame()


microgame.Title = "Remember the path!"
microgame.Vars = {}
microgame.Vars.music = "minigame_37"
microgame.Vars.length = 8
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(5298,3070,4030)
microgame.Vars.curSpawnVolume.maxs = Vector(5300,3072,4032)
microgame.Vars.respawnAtStart = true
microgame.Vars.respawnAtEnd = true
microgame.Vars.gameWinnable = false
function microgame:Start()
	LoadPropTable("invis" .. math.random(1, 20))
	local invisTable = {}
	for i, v in ipairs(ents.FindByClass("prop_physics")) do
		v:SetRenderMode(RENDERMODE_TRANSALPHA)
		table.insert(invisTable, v)
	end
	LoadPropTable("baseinvis")
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetCanJump(false)
		v:SetEyeAngles(Angle(0,-180,0))
		v:SetRenderMode(RENDERMODE_TRANSALPHA)
		v:SetColor(Color(255,255,255,0))
		v:SetRealSpeed(0.01)
		CreateClientText(v, "4...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
	end
	timer.Simple(1, function()
		for i, v in ipairs(player.GetAll()) do
			CreateClientText(v, "3...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	timer.Simple(2, function()
		for i, v in ipairs(player.GetAll()) do
			CreateClientText(v, "2...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	timer.Simple(3, function()
		for i, v in ipairs(player.GetAll()) do
			CreateClientText(v, "1...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	timer.Simple(4, function()
		for i, v in ipairs(player.GetAll()) do
			v:SetRealSpeed(320)
			v:SetCanJump(true)
			v:SetRenderMode(RENDERMODE_NORMAL)
			v:SetColor(Color(255,255,255,255))
			CreateClientText(v, "Go!", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	local startTime = CurTime() + 3
	hook.Add("Think", "InvisThink", function()
		local newAlpha = 255 - math.Clamp((CurTime() - startTime) * 255, 0, 255)
		for i, v in ipairs(invisTable) do
			if v:IsValid() then
				v:SetColor(Color(v:GetColor().r, v:GetColor().g, v:GetColor().b, newAlpha))
			end
		end
	end)
	local spikeTable = {}
	spikeTable["models/platformmaster/1x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x4x1spike.mdl"] = true
	hook.Add("PlayerTick", "InvisTick", function(pl, move)
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
		local tr = util.TraceHull({
			start = move:GetOrigin(),
			endpos = move:GetOrigin() - Vector(0,0,5000),
			filter = player.GetAll(),
			mins = pl:OBBMins(),
			maxs = pl:OBBMaxs()
		})
		if tr.Hit and tr.Entity:IsValid() and tr.Entity.Vars["winplat"] then
			WinMinigame(pl, "Nice job!")
		end
		if move:GetOrigin().z < 3200 then
			LoseMinigame(pl, "Oops...")
		end
	end)
end
function microgame:End()
	DestroyPropTable()
	hook.Remove("Think", "InvisThink")
	hook.Remove("PlayerTick", "InvisTick")
end