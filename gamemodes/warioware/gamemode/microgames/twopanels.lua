local microgame = Microgame()

microgame.Title = "Step on two panels!"
microgame.Vars = {}
microgame.Vars.music = "minigame_30"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
	self.Vars.existingPropTable = {}
	for i = 1, 24, 1 do
		for n = 1, 24, 1 do
			if math.random() < (#player.GetAll() * 0.0075) + 0.0115 then
				local tempPlat = ents.Create("prop_physics")
				tempPlat:SetModel("models/platformmaster/1x1x1.mdl")
				tempPlat:SetMaterial("jumpbox")
				tempPlat:SetPos(Vector((i * 64) - 768 - 32,(n * 64) - 768 - 32,-32))
				tempPlat:Spawn()
				tempPlat:PhysicsInitShadow(false,false)
				tempPlat:SetSolid(SOLID_VPHYSICS)
				tempPlat.isPlatform = true
				if (i + n) % 2 == 0 then
					tempPlat:SetColor(Color(226,98,105))
				else
					tempPlat:SetColor(Color(78,174,233))
				end
				local tempPhys = tempPlat:GetPhysicsObject()
				tempPhys:EnableMotion(false)
				tempPhys:UpdateShadow(tempPlat:GetPos() + Vector(0,0,6),Angle(0,0,0),0.25)
				table.insert(self.Vars.existingPropTable, tempPlat)
				local trTest = util.TraceHull({
					start = tempPlat:GetPos(),
					endpos = tempPlat:GetPos() + Vector(0,0,100),
					filter = ents.FindByClass("prop_physics"),
					mins = Vector(-72,-72,-1),
					maxs = Vector(72,72,1),
					ignoreworld = true
				})
				if math.random() < 0.22 and not trTest.Hit then
					tempPlat:SetMaterial("badjumpbox")
					tempPlat:SetColor(Color(255,255,255))
					tempPlat.isPlatform = nil
					tempPlat.evilPlat = true
				end
			end
		end
	end

	for i, v in ipairs(player.GetAll()) do
		v.stepped = 0
	end

	hook.Add("PlayerTick", "PlatformHook", function(pl, move)
		if pl:OnGround() then
			local tr = util.TraceHull({
				start = move:GetOrigin(),
				endpos = move:GetOrigin() + Vector(0,0,-4),
				filter = pl,
				mins = pl:OBBMins(),
				maxs = pl:OBBMaxs()
			})
			if tr.Hit then
				if tr.Entity.isPlatform then
					pl.stepped = pl.stepped + 1
					pl:EmitSound("buttons/button3.wav",75,100,1)
					tr.Entity:Remove()
				elseif tr.Entity.evilPlat then
					LoseMinigame(pl, "Watch your step!")
					pl:EmitSound("buttons/button2.wav",75,100,1)
					tr.Entity:Remove()
				end
			end
			if pl.stepped and pl.stepped >= 2 then
				WinMinigame(pl, "You got it!")
			end
			if tr.StartSolid and tr.Hit and tr.Entity.isPlatform then
				move:SetOrigin(move:GetOrigin() + Vector(0,0,1))
			end
		end
	end)
end
function microgame:End()
	hook.Remove("PlayerTick", "PlatformHook")
	for k, v in pairs(self.Vars.existingPropTable) do
		if v:IsValid() then
			v:Remove()
		end
	end
end