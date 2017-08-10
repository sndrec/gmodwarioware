local microgame = Microgame()

microgame.ShowTitle = false
microgame.Title = "Bombers 2"
microgame.Vars = {}
microgame.Vars.music = "minigame_2"
microgame.Vars.length = 4
microgame.Vars.respawnAtEnd = false
microgame.Vars.gameWinnable = false
function microgame:Start()
	local playerTable = player.GetAll()
	local bomberTable = {}
	for i = 1, math.ceil(#playerTable * 0.2), 1 do
		local randompl = table.Random(playerTable)
		if not randompl.bomber then
			randompl.gameWon = false
			randompl:SetMaxSpeed(400)
			randompl:SetWalkSpeed(400)
			randompl:SetRunSpeed(400)
			randompl:SetCanJump(false)
			randompl:SetMarked(true)
			randompl.bomber = true
			randompl:Give("weapon_pdm_led")
			table.insert(bomberTable, randompl)
		end
	end
	for i, v in ipairs(playerTable) do
		if not v.bomber then
			CreateClientText(v, "Don't get blown up!", 4, "CCBig", 0.5, 0.3, Color(255,255,255))
		else
			CreateClientText(v, "Blow up at least 1 player!", 4, "CCBig", 0.5, 0.3, Color(255,100,100))
		end
	end
end
function microgame:End()
	for i, v in ipairs(player.GetAll()) do
		v:SetMaxSpeed(320)
		v:SetWalkSpeed(320)
		v:SetRunSpeed(320)
		v.bomber = nil
		v:StripWeapons()
		v:SetMarked(false)
		v:SetCanJump(true)
	end
	local remove = {}
	remove["ww_bomb"] = true
	remove["weapon_pdm_led"] = true
	for i, v in ipairs(ents.GetAll()) do
		if remove[v:GetClass()] then
			v:Remove()
		end
	end
end