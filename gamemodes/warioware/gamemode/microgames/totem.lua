local microgame = Microgame()

microgame.Title = "Break a totem!"
microgame.Vars = {}
microgame.Vars.music = "minigame_8"
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
		v:Give("weapon_crowbar")
	end
	local mins = Vector(-600,-600,50)
	local maxs = Vector(600,600,50)

	for i = 1, math.ceil(#player.GetAll() * 1.2), 1 do
	local newTarget = ents.Create("prop_dynamic")
	newTarget:SetPos(Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(mins.z,maxs.z)))
	newTarget:SetModel("models/props_docks/dock01_pole01a_128.mdl")
	newTarget:PhysicsInitShadow(false, false)
	newTarget:SetSolid(SOLID_VPHYSICS)
	newTarget:PrecacheGibs()
	newTarget:Spawn()
	end
	hook.Add("EntityTakeDamage", "HitTargetHook", function(target, dmginfo)
		if dmginfo:GetAttacker():IsPlayer() then
			dmginfo:ScaleDamage(0)
		end
		if target:GetModel() == "models/props_docks/dock01_pole01a_128.mdl" then
			WinMinigame(dmginfo:GetAttacker(), "You got it!")
			target:GibBreakClient( target:EyeAngles():Forward() * 256 )
			target:Remove()
		end
	end)
end
function microgame:End()
	hook.Remove("EntityTakeDamage", "HitTargetHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
	for i, v in ipairs(ents.FindByModel("models/props_docks/dock01_pole01a_128.mdl")) do
		v:Remove()
	end
end