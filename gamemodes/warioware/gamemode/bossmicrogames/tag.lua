local microgame = BossMicrogame()

microgame.Title = "Taggers and Runners"
microgame.ShowTitle = false
microgame.Vars = {}
microgame.Vars.music = "minigame_28"
microgame.Vars.length = 89
microgame.Vars.respawnAtStart = true
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(5632, 0, 4500) - Vector(512,512, 0)
microgame.Vars.curSpawnVolume.maxs = Vector(5632, 0, 4600) + Vector(512,512, 0)
microgame.Vars.respawnAtEnd = true
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.walls = {}
microgame.Vars.gameWinnable = false
function microgame:Start()
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
			table.insert(self.Vars.props, tempPlat)
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
		table.insert(self.Vars.props, tempPlat)
		table.insert(self.Vars.walls, tempPlat)
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
		table.insert(self.Vars.props, tempPlat)
		table.insert(self.Vars.walls, tempPlat)
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
		table.insert(self.Vars.props, tempPlat)
		table.insert(self.Vars.walls, tempPlat)
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
		table.insert(self.Vars.props, tempPlat)
		table.insert(self.Vars.walls, tempPlat)
	end
	local playerTable = player.GetAll()
	local taggerTable = {}
	local numTaggers = math.Clamp(math.ceil(#player.GetAll() * 0.25), 1, 2)
	for i = 1, numTaggers, 1 do
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
		CreateClientText(v, "Tag every runner!", 4, "CCMed", 0.5, 0.35, Color(220,80,80))
		v:SetMarked(true)
		v.tagger = true
		v:SetModelScale(1.5, 0)
		if numTaggers == 1 then
			v:SetRealSpeed(320)
		else
			v:SetRealSpeed(240)
		end
		v:SetPos(Vector(6300, 0, 4200) + Vector(0,(400 / #taggerTable) * i, 0))
		v:SetEyeAngles(Angle(0,180,0))
		v:SetViewOffset(Vector(0,0,92))
	end
	for i, v in ipairs(self.Vars.walls) do
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
					timer.Simple(3, function()
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
function microgame:End()
	hook.Remove("PlayerTick", "TaggersTick")
	hook.Remove("PlayerDeathThink", "TaggerDeathThink")
	hook.Remove("PlayerDeath", "TaggerDeath")
	for i, v in ipairs(self.Vars.props) do
		if v:IsValid() then
			v:Remove()
		end
	end
	self.Vars.props = {}
	self.Vars.walls = {}
	for i, v in ipairs(player.GetAll()) do
		if v:BroadAlive() and v.runner then
			v.gameWon = true
		end
		v:SetMarked(false)
		v.runner = false
		v.tagger = false
		v:SetModelScale(1, 0)
		v:SetWWMovement(0)
		v:SetViewOffset(Vector(0,0,64))
	end
end