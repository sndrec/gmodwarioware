DEFINE_BASECLASS( "gamemode_base" )
include( "proptables.lua" )
include( "goalvolumes.lua" )

function WinMinigame(pl, msg)
	if pl.gameWon then return end
	for i, v in ipairs(player.GetAll()) do
		if v ~= pl then
			SendSound("gamesound/tf2ware/complete_you.mp3", v, 100, 0.2)
		end
	end
	SendSound("gamesound/tf2ware/complete_me.mp3", pl, 100, 1)
	pl.gameWon = true
	if msg then
		CreateClientText(pl, msg, 2, "CCMed", 0.5, 0.6, Color(80,220,80))
	end
end

function LoseMinigame(pl, msg)
	if pl:BroadAlive() then
		pl:Kill()
	end
	if pl.gameWon then
		pl.gameWon = false
		if msg then
			CreateClientText(pl, msg, 2, "CCMed", 0.5, 0.6, Color(220,80,80))
		end
	end
end

curSpawnVolume = {}
curSpawnVolume.mins = Vector(-700,-700,256)
curSpawnVolume.maxs = Vector(700,700,300)
minigames = {}

local curMID = 1
minigames[curMID] = {}
minigames[curMID].Title = "Type the answer in chat!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_21"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	local p1 = math.random(-5,10) * math.random(1,3)
	local p2 = math.random(2, 5) * math.random(1,3)
	local equ = math.random(1,3)
	local answer = 0
	local gameString = ""
	if equ == 1 then
		answer = p1 + p2
		gameString = p1 .. " + " .. p2 .. " = ?"
	elseif equ == 2 then
		answer = p1 - p2
		gameString = p1 .. " - " .. p2 .. " = ?"
	else
		answer = p1 * p2
		gameString = p1 .. " x " .. p2 .. " = ?"
	end
	CreateClientText("all", gameString, 4, "CCMed", 0.5, 0.4, Color(255,255,255))
	hook.Add("PlayerSay", "EquationSay", function(pl, text, team)
		print("player typed")
		if tonumber(text) == answer then
			local tempTable = {"You got it!", "Quick thinking!", "Nice!", "Mathematical!"}
			WinMinigame(pl, table.Random(tempTable))
			return ""
		end
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerSay", "EquationSay")
end

--curMID = curMID + 1
--minigames[curMID] = {}
--minigames[curMID].Title = "Type the word in chat!"
--minigames[curMID].Vars = {}
--minigames[curMID].Vars.music = "minigame_21"
--minigames[curMID].Vars.length = 4
--minigames[curMID].Vars.respawnAtStart = false
--minigames[curMID].Vars.curSpawnVolume = {}
--minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
--minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
--minigames[curMID].Vars.props = {}
--minigames[curMID].Vars.ents = {}
--minigames[curMID].Vars.gameWinnable = true
--minigames[curMID].Start = function()
--	local colourTextTable = {"Red", "Blue", "Yellow", "Green", "Purple", "Pink", "White", "Black"}
--	local randomColourTable = {Color(255,60,60), Color(60,60,255), Color(255,255,60), Color(60,255,60), Color(160,60,160), Color(255,105,180), Color(255,255,255), Color(20, 20, 20)}
--	local answer = table.Random(colourTextTable)
--	local colour = table.Random(randomColourTable)
--	CreateClientText("all", answer, 4, "CCMed", 0.5, 0.4, colour)
--	hook.Add("PlayerSay", "WordSay", function(pl, text, team)
--		print("player typed")
--		if string.lower(text) == string.lower(answer) then
--			WinMinigame(pl, "You got it!")
--			return ""
--		end
--	end)
--end
--minigames[curMID].End = function()
--	hook.Remove("PlayerSay", "WordSay")
--end
--
--curMID = curMID + 1
--minigames[curMID] = {}
--minigames[curMID].Title = "Type the color in chat!"
--minigames[curMID].Vars = {}
--minigames[curMID].Vars.music = "minigame_21"
--minigames[curMID].Vars.length = 4
--minigames[curMID].Vars.respawnAtStart = false
--minigames[curMID].Vars.curSpawnVolume = {}
--minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
--minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
--minigames[curMID].Vars.props = {}
--minigames[curMID].Vars.ents = {}
--minigames[curMID].Vars.gameWinnable = true
--minigames[curMID].Start = function()
--	local colourTextTable = {"Red", "Blue", "Yellow", "Green", "Purple", "Pink", "White", "Black"}
--	local randomColourTable = {Color(255,60,60), Color(60,60,255), Color(255,255,60), Color(60,255,60), Color(160,60,160), Color(255,105,180), Color(255,255,255), Color(20, 20, 20)}
--	local answer, k1 = table.Random(colourTextTable)
--	local colour, k2 = table.Random(randomColourTable)
--	CreateClientText("all", answer, 4, "CCMed", 0.5, 0.4, colour)
--	hook.Add("PlayerSay", "WordSay", function(pl, text, team)
--		print("player typed")
--		if string.lower(text) == string.lower(colourTextTable[k2]) then
--			WinMinigame(pl, "You got it!")
--			return ""
--		end
--	end)
--end
--minigames[curMID].End = function()
--	hook.Remove("PlayerSay", "WordSay")
--end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Simon says"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_9"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	local randomTable = {"jump!", "crouch!", "look up!", "look down!", "stop moving!", "don't stop moving!"}
	local choice, choicekey = table.Random(randomTable)
	if choicekey == 5 or choicekey == 6 then
		for i, v in ipairs(player.GetAll()) do
			v.gameWon = true
		end
	end
	CreateClientText("all", choice, 4, "CCMed", 0.5, 0.4, Color(255,255,255))
	timer.Simple(1.5, function()
		hook.Add("PlayerTick", "SimonHook", function(pl, move)
			if choicekey == 1 and move:KeyDown(IN_JUMP) or choicekey == 1 and not pl:OnGround() then
				WinMinigame(pl)
			end
			if choicekey == 2 and move:KeyDown(IN_DUCK) then
				WinMinigame(pl)
			end
			if choicekey == 3 and move:GetAngles().p < -75 then
				WinMinigame(pl)
			end
			if choicekey == 4 and move:GetAngles().p > 75 then
				WinMinigame(pl)
			end
			if choicekey == 5 and move:GetVelocity():LengthSqr() > 90000 then
				LoseMinigame(pl)
			end
			if choicekey == 6 and move:GetVelocity():LengthSqr() < 10000 then
				LoseMinigame(pl)
			end
		end)
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "SimonHook")
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Someone says"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_9"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = false
minigames[curMID].Start = function()
	local randomTable = {"jump!", "crouch!", "look up!", "look down!"}
	local choice, choicekey = table.Random(randomTable)
	CreateClientText("all", choice, 4, "CCMed", 0.5, 0.4, Color(255,255,255))
	timer.Simple(1.5, function()
		hook.Add("PlayerTick", "SomeoneHook", function(pl, move)
			if choicekey == 1 and move:KeyDown(IN_JUMP) then
				LoseMinigame(pl, "Simon didn't say it!")
			end
			if choicekey == 2 and move:KeyDown(IN_DUCK) then
				LoseMinigame(pl, "Simon didn't say it!")
			end
			if choicekey == 3 and move:GetAngles().p < -75 then
				LoseMinigame(pl, "Simon didn't say it!")
			end
			if choicekey == 4 and move:GetAngles().p > 75 then
				LoseMinigame(pl, "Simon didn't say it!")
			end
		end)
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "SomeoneHook")
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Hit another player!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_1"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	local randomTable = {"weapon_shotgun", "weapon_pistol", "weapon_357"}
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
minigames[curMID].End = function()
	hook.Remove("EntityTakeDamage", "HitPlayerHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Hit three targets!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_35"
minigames[curMID].Vars.length = 7.96
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	for i, v in ipairs(player.GetAll()) do
		local newwep = v:Give("weapon_357")
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
minigames[curMID].End = function()
	hook.Remove("EntityTakeDamage", "HitTargetHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
	for i, v in ipairs(ents.FindByModel("models/combine_helicopter/helicopter_bomb01.mdl")) do
		v:Remove()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Rocket jump!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_5"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	for i, v in ipairs(player.GetAll()) do
		local newwep = v:Give("weapon_rpg")
		v:GiveAmmo(60,newwep:GetPrimaryAmmoType(),true)
	end
	hook.Add("PlayerTick", "RJHook", function(pl, move)
		if move:GetOrigin().z > 128 then
			WinMinigame(pl, "You got it!")
		end
	end)
	hook.Add("EntityTakeDamage", "RJHook", function(target, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if attacker ~= target then
			dmginfo:ScaleDamage(0)
		end
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "RJHook")
	hook.Remove("EntityTakeDamage", "RJHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Jump on a platform!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_11"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	minigames[curMID].Vars.existingPropTable = {}
	local randomChance = math.random()
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
			table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
		end
	end
	if randomChance > 0.25 then
		local randomChance = math.random()
		local tempPlat = ents.Create("prop_physics")
		tempPlat:SetModel("models/platformmaster/2x2x1.mdl")
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(0,0,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		local tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:EnableMotion(false)
		tempPhys:UpdateShadow( Vector(0,0,32), Angle(0,0,0), 0.5 )
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end
	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(-512,512,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end
	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(-512,-512,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end
	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(512,-512,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end
	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(512,512,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end

	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(0,512,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end

	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(512,0,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end

	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(-512,0,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end

	randomChance = math.random()
	if randomChance > 0.5 then
		local tempPlat = ents.Create("prop_physics")
		local randomModels = {"models/platformmaster/2x2x1.mdl", "models/platformmaster/1x1x1.mdl"}
		local choice = table.Random(randomModels)
		tempPlat:SetModel(choice)
		tempPlat:SetMaterial("jumpbox")
		tempPlat:SetPos(Vector(0,-512,-40))
		tempPlat:Spawn()
		tempPlat:PhysicsInitShadow(false,false)
		tempPlat:SetSolid(SOLID_VPHYSICS)
		tempPlat:SetColor(Color(80,200,80))
		tempPhys = tempPlat:GetPhysicsObject()
		tempPhys:UpdateShadow( tempPhys:GetPos() + Vector(0,0,32), Angle(0,0,0), 0.5 )
		tempPhys:EnableMotion(false)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
	end

	for i, v in ipairs(minigames[curMID].Vars.existingPropTable) do
		if not v.deathPlat then
			v.isPlatform = true
		end
	end

	hook.Add("PlayerTick", "PlatformHook", function(pl, move)
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
				elseif tr.Entity.deathPlat then
					LoseMinigame(pl, "Ouch...")
				end
			end
			if tr.StartSolid and tr.Hit and tr.Entity.isPlatform then
				move:SetOrigin(move:GetOrigin() + Vector(0,0,1))
			end
		end
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "PlatformHook")
	for k, v in pairs(minigames[curMID].Vars.existingPropTable) do
		v:Remove()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].ShowTitle = false
minigames[curMID].Title = "Bombers"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_2"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = false
minigames[curMID].Start = function()
	local playerTable = player.GetAll()
	local bomberTable = {}
	for i = 1, math.ceil(#playerTable * 0.2), 1 do
		local randompl = table.Random(playerTable)
		if not randompl.bomber then
			print(randompl:Nick())
			randompl.gameWon = false
			randompl:SetMaxSpeed(500)
			randompl:SetWalkSpeed(500)
			randompl:SetRunSpeed(500)
			randompl:SetJumpPower(0)
			randompl.bomber = true
			randompl.light = ents.Create( "light_dynamic" )
			randompl.light:SetKeyValue("_cone","30")
			randompl.light:SetKeyValue("_inner_cone","20")
			randompl.light:SetKeyValue("_light","255 200 110 200")
			randompl.light:SetKeyValue("brightness","10")
			randompl.light:SetKeyValue("distance","200")
			randompl.light:SetKeyValue("pitch","-90")
			randompl.light:SetKeyValue("spotlight_radius","200")
			randompl.light:Spawn()
			randompl.light:SetParent( randompl )
			randompl.light:SetPos( randompl:GetPos() + Vector(0,0,100) )
			randompl.glow = ents.Create( "env_sprite" )
			randompl.glow:SetKeyValue( "rendercolor","200 120 100" )
			randompl.glow:SetKeyValue( "GlowProxySize","10.0" )
			randompl.glow:SetKeyValue( "HDRColorScale","1.0" )
			randompl.glow:SetKeyValue( "renderfx","14" )
			randompl.glow:SetKeyValue( "rendermode","3" )
			randompl.glow:SetKeyValue( "renderamt","255" )
			randompl.glow:SetKeyValue( "disablereceiveshadows","0" )
			randompl.glow:SetKeyValue( "mindxlevel","0" )
			randompl.glow:SetKeyValue( "maxdxlevel","0" )
			randompl.glow:SetKeyValue( "model","sprites/flare1.spr" )
			randompl.glow:SetKeyValue( "spawnflags","0" )
			randompl.glow:SetKeyValue( "scale","2" )
			randompl.glow:Spawn()
			randompl.glow:SetParent( randompl )
			randompl.glow:SetPos( randompl:GetPos() + Vector(0,0,40) )
			timer.Simple(3, function()
				randompl.glow:Remove()
				randompl.light:Remove()
				local kills = 0
				for n, v in ipairs(player.GetAll()) do
					if v:GetPos():Distance(randompl:GetPos()) < 300 and not v.bomber then
						v:Kill()
						if v ~= randompl then
							kills = kills + 1
							LoseMinigame(v, "Better luck next time...")
						end
					end
				end
				if kills > 0 then
					WinMinigame(randompl, "You got it!")
				end
				local effectData = EffectData()
				effectData:SetOrigin(randompl:GetPos() + Vector(0,0,20))
				util.Effect("Explosion",effectData)
				randompl:Kill()
			end)
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
minigames[curMID].End = function()
	for i, v in ipairs(player.GetAll()) do
		v:SetMaxSpeed(320)
		v:SetWalkSpeed(320)
		v:SetRunSpeed(320)
		v:SetJumpPower(300)
		v.bomber = nil
	end
end
curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Don't get crushed!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_11"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = false
minigames[curMID].Start = function()
	minigames[curMID].Vars.existingPropTable = {}
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
		timer.Simple(2, function()
			tempPhys:UpdateShadow( Vector(tempPhys:GetPos().x,tempPhys:GetPos().y,0), Angle(0,0,0), 0.2 )
		end)
		timer.Simple(2.2, function()
			tempPhys:UpdateShadow( tempPhys:GetPos(), Angle(0,0,0), FrameTime() )
			util.ScreenShake( tempPhys:GetPos(),10, 3, 0.5, 512 )
			tempPhys:EnableMotion(false)
			tempPlat:SetPos(Vector(newPos.x, newPos.y, 32 + ( math.random() * 8)))
			tempPlat:EmitSound("physics/concrete/boulder_impact_hard1.wav",100,100,1)
		end)
		table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)

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
		table.insert(minigames[curMID].Vars.existingPropTable, tempShadow)
	end

	for i, v in ipairs(minigames[curMID].Vars.existingPropTable) do
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
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "PlatformHook")
	for k, v in pairs(minigames[curMID].Vars.existingPropTable) do
		v:Remove()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Break a totem!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_8"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
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
minigames[curMID].End = function()
	hook.Remove("EntityTakeDamage", "HitTargetHook")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
	for i, v in ipairs(ents.FindByModel("models/props_docks/dock01_pole01a_128.mdl")) do
		v:Remove()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Smash an enemy with a ball!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_29"
minigames[curMID].Vars.length = 3.9
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	for i, v in ipairs(player.GetAll()) do
		v:Give("weapon_physcannon")
		v:SetHealth(1)
	end

	for i, v in ipairs(player.GetAll()) do
		local tempProp = ents.Create("prop_physics")
		local newAng = v:EyeAngles()
		local tr = util.TraceLine({
			start = v:GetPos() + Vector(0,0,60),
			endpos = v:GetShootPos() + (newAng:Forward() * 64) + (v:GetVelocity() * FrameTime() * 4),
			filter = v
		})
		tempProp:SetPos(tr.HitPos)
		tempProp:SetModel("models/roller.mdl")
		tempProp:PhysicsInitSphere(16,"metal_bouncy")
		tempProp:Spawn()
		local tempPhys = tempProp:GetPhysicsObject()
		tempPhys:SetMass(250)
		v:ConCommand("+attack2")
		timer.Simple(0.1, function()
			v:ConCommand("-attack2")
		end)
	end

	hook.Add("GravGunPunt", "SpaceJamHook", function(pl, ent)
		ent.Punter = pl
		timer.Simple(0.01, function()
			local phys = ent:GetPhysicsObject()
			phys:SetVelocity(phys:GetVelocity())
		end)
	end)
	hook.Add("PlayerDeath", "SpaceJamDeath", function(victim, inflictor, attacker)
		WinMinigame(attacker)
		if inflictor.Punter then
			WinMinigame(inflictor.Punter)
		end
	end)
end
minigames[curMID].End = function()
	hook.Remove("GravGunPunt", "SpaceJamHook")
	hook.Remove("PlayerDeath", "SpaceJamDeath")
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
		v:SetHealth(200)
	end
	local deleteModels = {}
	deleteModels["models/platformmaster/2x2x1cyl.mdl"] = true
	deleteModels["models/roller.mdl"] = true
	deleteModels["models/platformmaster/4x4x1.mdl"] = true
	deleteModels["models/platformmaster/8x1x1.mdl"] = true
	for i, v in ipairs(ents.GetAll()) do
		if deleteModels[v:GetModel()] then
			v:Remove()
		end
	end
end


curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Step on two panels!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_30"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	minigames[curMID].Vars.existingPropTable = {}
	for i = 1, 24, 1 do
		for n = 1, 24, 1 do
			local randomChance = math.random()
			if randomChance < (#player.GetAll() * 0.01) then
				local tempPlat = ents.Create("prop_physics")
				tempPlat:SetModel("models/platformmaster/1x1x1.mdl")
				tempPlat:SetMaterial("jumpbox")
				tempPlat:SetPos(Vector((i * 64) - 768 - 32,(n * 64) - 768 - 32,-32))
				tempPlat:Spawn()
				tempPlat:PhysicsInitShadow(false,false)
				tempPlat:SetSolid(SOLID_VPHYSICS)
				if (i + n) % 2 == 0 then
					tempPlat:SetColor(Color(226,98,105))
				else
					tempPlat:SetColor(Color(78,174,233))
				end
				local tempPhys = tempPlat:GetPhysicsObject()
				tempPhys:EnableMotion(false)
				tempPhys:UpdateShadow(tempPlat:GetPos() + Vector(0,0,6),Angle(0,0,0),0.25)
				table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
			end
		end
	end

	for i, v in ipairs(minigames[curMID].Vars.existingPropTable) do
		v.isPlatform = true
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
			if tr.Hit and tr.Entity.isPlatform then
				pl.stepped = pl.stepped + 1
				pl:EmitSound("buttons/button3.wav",75,100,1)
				tr.Entity:Remove()
			end
			if pl.stepped and pl.stepped >= 2 then
				WinMinigame(pl)
			end
			if tr.StartSolid and tr.Hit and tr.Entity.isPlatform then
				move:SetOrigin(move:GetOrigin() + Vector(0,0,1))
			end
		end
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "PlatformHook")
	for k, v in pairs(minigames[curMID].Vars.existingPropTable) do
		if v:IsValid() then
			v:Remove()
		end
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Reach the end!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_31"
minigames[curMID].Vars.length = 8
minigames[curMID].Vars.respawnAtEnd = true
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
	minigames[curMID].Vars.instancedProps = {}
	local randomChoice = math.random(1,7)
	print("Current random level: " .. randomChoice)
	LoadPropTable("RTEShort" .. randomChoice)
	local spikeTable = {}
	spikeTable["models/platformmaster/1x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x4x1spike.mdl"] = true
	hook.Add("PlayerTick", "ReachEnd", function(pl, move)
		if move:GetOrigin():WithinAABox(propTable.goalVolume.mins,propTable.goalVolume.maxs) and pl:BroadAlive() then
			WinMinigame(pl, "Congratulations!")
		end
		if not pl:BroadAlive() then
			LoseMinigame(pl, "Ouch! Let's try that again.")
		else
			pl:SetHealth(math.min(pl:Health() + 1, pl:GetMaxHealth()))
		end
		local spikeTR = util.TraceHull({
			start = move:GetOrigin(),
			endpos = move:GetOrigin() + (move:GetVelocity() * FrameTime()),
			filter = pl,
			mins = pl:OBBMins(),
			maxs = pl:OBBMaxs()
		})
		if spikeTR.Hit and spikeTable[spikeTR.Entity:GetModel()] and pl:BroadAlive() then
			pl:Kill()
		end
		if pl:OnGround() then
			local spikeTR2 = util.TraceHull({
				start = move:GetOrigin(),
				endpos = move:GetOrigin() + (move:GetVelocity() * FrameTime()) - Vector(0,0,4),
				filter = pl,
				mins = pl:OBBMins(),
				maxs = pl:OBBMaxs()
			})
			if spikeTR2.Hit and spikeTable[spikeTR2.Entity:GetModel()] and pl:BroadAlive() then
				pl:Kill()
			end
		end
	end)
	curSpawnVolume.mins = propTable.spawnVolume.mins
	curSpawnVolume.maxs = propTable.spawnVolume.maxs
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		if propTable.spawnAng then
			v:SetEyeAngles(propTable.spawnAng)
		end
		v:SetMaxHealth(100)
		v:SetHealth(100)
		v:SetRealSpeed(400)
	end
end
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "ReachEnd")
	DestroyPropTable()
	for k, v in pairs(curInstancedPropTable) do
		if v:IsValid() then
			v:Remove()
		end
	end
	for i, v in ipairs(player.GetAll()) do
		v:SetMaxHealth(200)
		v:SetHealth(200)
		v:SetRealSpeed(320)
	end
end

















for i, v in ipairs(minigames) do
	print(i .. " = " .. v.Title)
end

function SendSound(newSound, pl, pitch, volume)
	net.Start("ClientSound")
	net.WriteString(newSound)
	net.WriteFloat(pitch)
	net.WriteFloat(volume)
	if pl then
		net.Send(pl)
	else
		net.Send(player.GetAll())
	end
end
