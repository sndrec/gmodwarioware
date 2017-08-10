local microgame = Microgame()

microgame.Title = "Rocket jump to the platform!"
microgame.Vars = {}
microgame.Vars.music = "minigame_5"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
	for i, v in ipairs(player.GetAll()) do
		local newwep = v:Give("weapon_pdm_hl2_rpg")
		v:GiveAmmo(60,newwep:GetPrimaryAmmoType(),true)
	end
	local plat = ents.Create("prop_physics")
	plat.isPlatform = true
	plat:SetPos(Vector(0,0,256))
	plat:SetModel("models/platformmaster/8x8x1.mdl")
	plat:SetMaterial("jumpbox")
	plat:Spawn()
	plat:PhysicsInitShadow(false,false)
	plat:SetSolid(SOLID_VPHYSICS)
	plat:SetColor(Color(80,200,80))
	local phys = plat:GetPhysicsObject()
	phys:EnableMotion(false)
	plat:SetModelScale(0,0)
	plat:SetModelScale(1,0.25)
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
	hook.Remove("PlayerTick", "RJHook")
	hook.Remove("EntityTakeDamage", "RJHook")
	for i, v in ipairs(ents.FindByModel("models/platformmaster/8x8x1.mdl")) do
		v:Remove()
	end
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end