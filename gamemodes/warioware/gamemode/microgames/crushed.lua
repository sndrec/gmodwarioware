local microgame = Microgame()

microgame.Title = "Don't get crushed!"
microgame.Vars = {}
microgame.Vars.music = "minigame_11"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = false
function microgame:Start()
	self.Vars.existingPropTable = {}
	for i = 1, 15, 1 do
		local newPos = Vector(math.random(-750, 750),math.random(-750, 750),math.random(1000,1200))
		local tempPlat = ents.Create("prop_physics")
		tempPlat:SetModel("models/platformmaster/8x8x1.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(newPos)
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(180,80,80))
		tempPlat:SetModelScale(0,0)
		tempPlat:SetModelScale(1,0.5)
		tempPlat.deathblock = true
		local tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:SetMass(50000)
		tempPhys:EnableMotion(true)
		tempPhys:UpdateShadow( tempPhys:GetPos() - Vector(0,0,300), Angle(0,0,0), 2 )
		timer.Simple(2.75, function()
			tempPhys:UpdateShadow( Vector(tempPhys:GetPos().x,tempPhys:GetPos().y,0), Angle(0,0,0), 0.25 )
		end)
		timer.Simple(3, function()
			tempPhys:UpdateShadow( tempPhys:GetPos(), Angle(0,0,0), FrameTime() )
			util.ScreenShake( tempPhys:GetPos(),10, 3, 0.5, 512 )
			tempPhys:EnableMotion(false)
			tempPlat:SetPos(Vector(newPos.x, newPos.y, 32 + ( math.random() * 8)))
			tempPlat:EmitSound("physics/concrete/boulder_impact_hard1.wav",100,100,1)
		end)
		table.insert(self.Vars.existingPropTable, tempPlat)

		local tempShadow = ents.Create("prop_physics")
		tempShadow:SetModel("models/platformmaster/8x8x1.mdl")
		tempShadow:SetMaterial("jumpbox")
		tempShadow:SetPos(Vector(newPos.x, newPos.y, 2))
		tempShadow:Spawn()
		tempShadow:PhysicsInitShadow(false,false)
		tempShadow:SetSolid(SOLID_NONE)
		tempShadow:SetRenderMode(RENDERMODE_TRANSALPHA)
		tempShadow:SetColor(Color(0,0,0,200))
		tempShadow:SetModelScale(0,0)
		tempShadow:SetModelScale(1,0.5)
		local tempShadowPhys = tempShadow:GetPhysicsObject()
		tempShadowPhys:UpdateShadow( tempShadowPhys:GetPos() - Vector(0,0,32), Angle(0,0,0), 0.5 )
		table.insert(self.Vars.existingPropTable, tempShadow)
	end

	for i, v in ipairs(self.Vars.existingPropTable) do
		v.isPlatform = true
	end

	hook.Add("PlayerTick", "PlatformHook", function(pl, move)
		if not pl:Alive() then
			LoseMinigame(pl)
		else
			local tr = util.TraceHull({
				start = move:GetOrigin(),
				endpos = move:GetOrigin(),
				filter = player.GetAll(),
				mins = pl:OBBMins() + Vector(8,8,0),
				maxs = pl:OBBMaxs() - Vector(8,8,0)
			})
			if tr.Hit and tr.Entity.deathblock then
				pl:Kill()
			end
		end
	end)
end
function microgame:End()
	hook.Remove("PlayerTick", "PlatformHook")
	for k, v in pairs(self.Vars.existingPropTable) do
		v:Remove()
	end
end