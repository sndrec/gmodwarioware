local microgame = Microgame()

microgame.Title = "Hit three targets!"
microgame.Vars = {}
microgame.Vars.music = "minigame_35"
microgame.Vars.length = 7.96
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
	for i, v in ipairs(player.GetAll()) do
		local newwep = v:Give("weapon_pdm_hl2_magnum")
		if newwep:IsValid() then
			v:GiveAmmo(60,newwep:GetPrimaryAmmoType(),true)
		end
		v.targets = 0
	end
	local mins = Vector(-700,-700,128)
	local maxs = Vector(700,700,512)

	for i = 1, math.ceil(#player.GetAll() * 3.1), 1 do
	local newTarget = ents.Create("prop_dynamic")
	newTarget:SetPos(Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(mins.z,maxs.z)))
	newTarget:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	newTarget:SetMaterial("models/debug/debugwhite")
	newTarget:PhysicsInitShadow(false, false)
	newTarget:SetSolid(SOLID_VPHYSICS)
	newTarget:Spawn()
	newTarget:SetRenderMode(RENDERMODE_TRANSALPHA)
	newTarget:SetColor(Color(255,255,255,1))
	newTarget:SetModelScale(0,0)
	newTarget:SetModelScale(1,0.5)
	end
	hook.Add("EntityTakeDamage", "HitTargetHook", function(target, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if attacker:IsPlayer() then
			dmginfo:ScaleDamage(0)
		end
		if target:GetModel() == "models/combine_helicopter/helicopter_bomb01.mdl" then
			attacker:EmitSound("gamesound/fx/targetbreak.wav",100,100,1)
			attacker.targets = attacker.targets + 1
			local effectData = EffectData()
			effectData:SetOrigin(target:GetPos() + Vector(0,0,20))
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			util.Effect("GlassImpact",effectData)
			target:Remove()
		end
		if attacker.targets >= 3 then
			WinMinigame(attacker, "Clear!")
		end
	end)
end
function microgame:End()
	hook.Remove("EntityTakeDamage", "HitTargetHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
	for i, v in ipairs(ents.FindByModel("models/combine_helicopter/helicopter_bomb01.mdl")) do
		v:Remove()
	end
end