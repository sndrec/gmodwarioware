local microgame = Microgame()

microgame.Title = "Rocket jump to the top!"
microgame.Vars = {}
microgame.Vars.music = "minigame_36"
microgame.Vars.length = 7.9
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
	RunConsoleCommand("sv_turbophysics","1")
	for i, v in ipairs(player.GetAll()) do
		local newwep = v:Give("weapon_pdm_hl2_rpg")
		v:GiveAmmo(60,newwep:GetPrimaryAmmoType(),true)
	end
	local plat = ents.Create("prop_physics")
	plat.isPlatform = true
	plat:SetPos(Vector(0,0,512))
	plat:SetModel("models/platformmaster/8x8x1.mdl")
	plat:SetMaterial("jumpbox")
	plat:SetSolid(SOLID_VPHYSICS)
	plat:SetColor(Color(80,200,80))
	plat:Spawn()
	plat:PhysicsInitShadow(false,false)
	local phys = plat:GetPhysicsObject()
	phys:EnableMotion(false)
	local valid = {}
	valid[3] = true
	valid[5] = true
	valid[7] = true
	valid[9] = true
	local rotate = nil
	local num = 1
	for i = 1, 3, 1 do
		for n = 1, 3, 1 do
			if valid[i + n] then
				local tempPlat = ents.Create("prop_physics")
				local dist = 640
				tempPlat:SetPos(Vector((i * dist) - (dist * 2),(n * dist) - (dist * 2),256))
				tempPlat:SetModel("models/platformmaster/4x4x1cyl.mdl")
				tempPlat:SetMaterial("jumpbox")
				tempPlat:SetColor(Color(140,140,140))
				tempPlat:Spawn()
				tempPlat:PhysicsInitShadow(false,false)
				tempPlat:SetSolid(SOLID_VPHYSICS)
				local phys = tempPlat:GetPhysicsObject()
				phys:EnableMotion(false)
				if math.random() > 0 then
					tempPlat:PhysicsInitShadow(false,false)
					local phys = tempPlat:GetPhysicsObject()
					phys:EnableMotion(true)
					tempPlat:SetParent(rotate)
					tempPlat.think = true
					tempPlat.baseTime = CurTime()
					tempPlat.dist = dist
					tempPlat.num = num
					function tempPlat:Think()
						local phys = self:GetPhysicsObject()
						local rotVec = Vector(math.cos((CurTime() - self.baseTime) * 0.25), math.sin((CurTime() - self.baseTime) * 0.25), 0)
						rotVec:Rotate(Angle(0, (self.num - 1) * 90, 0))
						rotVec:Normalize()
						phys:UpdateShadow(Vector(0,0, 256) + (rotVec * self.dist),Angle(0,0,0),FrameTime())
					end
				end
				num = num + 1
			end
		end
	end
	local thinkTable = {}
	for i, v in ipairs(ents.GetAll()) do
		if v.think then
			table.insert(thinkTable, v)
		end
	end
	hook.Add("Think", "RJThink", function()
		for i, v in ipairs(thinkTable) do
			v:Think()
		end
	end)
	hook.Add("PlayerTick", "RJHook", function(pl, move)
		if pl:OnGround() then
			local tr = util.TraceHull({
				start = move:GetOrigin(),
				endpos = move:GetOrigin() + Vector(0,0,-4),
				filter = player.GetAll(),
				mins = pl:OBBMins(),
				maxs = pl:OBBMaxs()
			})
			if tr.Hit then
				if tr.Entity.isPlatform then
					WinMinigame(pl, "You got it!")
				end
			end
			if tr.StartSolid and tr.Hit and tr.Entity.isPlatform then
				move:SetOrigin(move:GetOrigin() + Vector(0,0,1))
			end
		end
	end)
	hook.Add("EntityTakeDamage", "RJHook", function(target, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if attacker ~= target then
			dmginfo:ScaleDamage(0)
		end
	end)
end
function microgame:End()
	RunConsoleCommand("sv_turbophysics","0")
	hook.Remove("PlayerTick", "RJHook")
	hook.Remove("EntityTakeDamage", "RJHook")
	hook.Remove("Think", "RJThink")
	local deleteProps = {}
	deleteProps["models/platformmaster/4x4x1.mdl"] = true
	deleteProps["models/platformmaster/8x8x1.mdl"] = true
	deleteProps["models/platformmaster/1x1x1.mdl"] = true
	deleteProps["models/platformmaster/4x4x1cyl.mdl"] = true
	for i, v in ipairs(ents.FindByClass("prop_physics")) do
		if deleteProps[v:GetModel()] then v:Remove() end
	end
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end