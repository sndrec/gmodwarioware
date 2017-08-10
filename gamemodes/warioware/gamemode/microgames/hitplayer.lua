local microgame = Microgame()

microgame.Title = "Hit another player!"
microgame.Vars = {}
microgame.Vars.music = "minigame_1"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
	local randomTable = {"weapon_pdm_hl2_shotgun", "weapon_pdm_hl2_pistol", "weapon_pdm_hl2_magnum"}
	local choice, choicekey = table.Random(randomTable)
	for i, v in ipairs(player.GetAll()) do
		local newwep = v:Give(choice)
		v:GiveAmmo(60,newwep:GetPrimaryAmmoType(),true)
	end
	hook.Add("EntityTakeDamage", "HitPlayerHook", function(target, dmginfo)
		if dmginfo:GetAttacker():IsPlayer() then
			dmginfo:ScaleDamage(500)
			WinMinigame(dmginfo:GetAttacker(), "Nice shot!")
		end
	end)
end
function microgame:End()
	hook.Remove("EntityTakeDamage", "HitPlayerHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end