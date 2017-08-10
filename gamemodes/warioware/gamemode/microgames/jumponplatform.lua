local microgame = Microgame()

microgame.Title = "Jump on a platform!"
microgame.Vars = {}
microgame.Vars.music = "minigame_11"
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
	local randomChance = math.random()
	RunConsoleCommand("sv_turbophysics","1")
	for i = -3, 3, 1 do
		for n = -3, 3, 1 do
			local tempPlat = ents.Create("prop_physics")
			tempPlat:SetModel("models/platformmaster/4x4x1.mdl")
			tempPlat:SetMaterial("jumpbox")
			tempPlat:SetPos(Vector(i * 256,n * 256,-40))
			tempPlat:Spawn()
			tempPlat:PhysicsInitShadow(false,false)
			tempPlat:SetSolid(SOLID_VPHYSICS)
			tempPlat:SetColor(Color(80,20,20))
			local tempPhys = tempPlat:GetPhysicsObject()
			tempPhys:EnableMotion(false)
			timer.Simple(2, function()
				tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,16), Angle(0,0,0), 0.5 )
			end)
			tempPlat.deathPlat = true
			table.insert(self.Vars.existingPropTable, tempPlat)
		end
	end

	local thinkTable = {}
	local num = 1
	local chance = math.random()
	for i = 1, 8, 1 do
		local tempPlat = ents.Create("prop_physics")
		tempPlat.num = num
		tempPlat.baseTime = CurTime()
		tempPlat.dist = math.random(100,700)
		local rotVec = Vector(math.cos((CurTime() - tempPlat.baseTime) * (tempPlat.dist * 0.1)), math.sin((CurTime() - tempPlat.baseTime) * (tempPlat.dist * 0.1)), 0)
		rotVec:Rotate(Angle(0, (tempPlat.num - 1) * 45, 0))
		rotVec:Normalize()
		tempPlat:SetPos((rotVec * tempPlat.dist) - Vector(0,0,40))
		tempPlat:SetModel("models/platformmaster/2x2xhalfcyl.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetColor(Color(60, 200, 60))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		local tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:EnableMotion(false)
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,54), Angle(0,0,0), 0.5 )
		tempPlat.isPlatform = true
		if chance > 0 then
			timer.Simple(0.5, function()
				tempPlat:PhysicsInitShadow(false,false)
				local phys = tempPlat:GetPhysicsObject()
				phys:EnableMotion(true)
				tempPlat.think = true
				tempPlat.baseTime = CurTime()
				function tempPlat:Think()
					local phys = self:GetPhysicsObject()
					local rotVec = Vector(math.cos((CurTime() - self.baseTime) * (150 / self.dist)), math.sin((CurTime() - self.baseTime) * (150 / self.dist)), 0)
					rotVec:Rotate(Angle(0, (self.num - 1) * 45, 0))
					rotVec:Normalize()
					phys:UpdateShadow(Vector(0,0, 16) + (rotVec * self.dist),Angle(0,0,0),FrameTime())
				end
				table.insert(thinkTable, tempPlat)
			end)
		end
		num = num + 1
	end


	local centerPlat = ents.Create("prop_physics")
	centerPlat:SetPos(Vector(0,0,-40))
	centerPlat:SetModel("models/platformmaster/2x2x1cyl.mdl")
	centerPlat:SetMaterial("jumpbox")
	centerPlat:SetColor(Color(60, 200, 60))
	centerPlat:Spawn()
	centerPlat:PhysicsInitShadow(false,false)
	centerPlat:SetSolid(SOLID_VPHYSICS)
	local tempPhys = centerPlat:GetPhysicsObject()
	tempPhys:EnableMotion(false)
	tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,70), Angle(0,0,0), 0.5 )
	centerPlat.isPlatform = true

	hook.Add("Think", "RJThink", function()
		for i, v in ipairs(thinkTable) do
			v:Think()
		end
	end)

	hook.Add("PlayerTick", "PlatformHook", function(pl, move)
		if pl:OnGround() and pl:BroadAlive() then
			if pl:GetGroundEntity().isPlatform then
				WinMinigame(pl, "You got it!")
			elseif pl:GetGroundEntity().deathPlat then
				LoseMinigame(pl, "Ouch...")
			end
		end
	end)
end
function microgame:End()
	hook.Remove("PlayerTick", "PlatformHook")
	hook.Remove("Think", "RJThink")
	local removeTable = {}
	removeTable["models/platformmaster/4x4x1.mdl"] = true
	removeTable["models/platformmaster/2x2x1cyl.mdl"] = true
	removeTable["models/platformmaster/2x2xhalfcyl.mdl"] = true
	RunConsoleCommand("sv_turbophysics","0")
	for i, v in ipairs(ents.FindByClass("prop_physics")) do
		if removeTable[v:GetModel()] then v:Remove() end
	end
end