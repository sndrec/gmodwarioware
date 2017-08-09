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
	if pl:BroadAlive() and pl:Health() > 1 then
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
minigames[curMID].Title = "Choose the correct answer!"
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
	local negative = false
	local p1 = math.random(-5,10) * math.random(1,3)
	local p2 = math.random(2, 5) * math.random(1,3)
	if p2 < 0 or p1 < 0 then
		negative = true
	end
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
	local ch1 = answer + math.random(1, 10)
	if math.random() > 0.5 then
		ch1 = answer - math.random(1, 10)
	end
	local ch2 = answer + math.random(1, 10)
	if math.random() > 0.5 then
		ch2 = answer - math.random(1, 10)
	end
	local ch3 = answer + math.random(1, 10)
	if math.random() > 0.5 then
		ch3 = answer - math.random(1, 10)
	end
	local ch4 = answer + math.random(1, 10)
	if math.random() > 0.5 then
		ch4 = answer - math.random(1, 10)
	end
	if negative then
		if math.random() > 0.5 then
			ch1 = -ch1
		end
		if math.random() > 0.5 then
			ch2 = -ch2
		end
		if math.random() > 0.5 then
			ch3 = -ch3
		end
		if math.random() > 0.5 then
			ch4 = -ch4
		end
	end
	local real = math.random(1, 4)
	if real == 1 then
		ch1 = answer
	elseif real == 2 then
		ch2 = answer
	elseif real == 3 then
		ch3 = answer
	elseif real == 4 then
		ch4 = answer
	end
	CreateClientText("all", gameString, 4, "CCMed", 0.5, 0.4, Color(255,255,255))
	CreateClientText("all", "1", 4, "CCSmall", 0.35, 0.64, Color(180,180,180))
	CreateClientText("all", "2", 4, "CCSmall", 0.45, 0.64, Color(180,180,180))
	CreateClientText("all", "3", 4, "CCSmall", 0.55, 0.64, Color(180,180,180))
	CreateClientText("all", "4", 4, "CCSmall", 0.65, 0.64, Color(180,180,180))
	CreateClientText("all", ch1, 4, "CCMed", 0.35, 0.69, Color(255,255,255))
	CreateClientText("all", ch2, 4, "CCMed", 0.45, 0.69, Color(255,255,255))
	CreateClientText("all", ch3, 4, "CCMed", 0.55, 0.69, Color(255,255,255))
	CreateClientText("all", ch4, 4, "CCMed", 0.65, 0.69, Color(255,255,255))
	timer.Simple(0.25, function()
		CreateClientText("all", "(Hit your choice on your keyboard!)", 3.75, "CCSmall", 0.5, 0.95, Color(255,255,255))
	end)
	hook.Add("PlayerButtonDown", "EquationButt", function(pl, butt)
		if not pl:BroadAlive() then return end
		local valid = {}
		valid[KEY_1] = true
		valid[KEY_2] = true
		valid[KEY_3] = true
		valid[KEY_4] = true
		if not valid[butt] then return end
		if pl.gameWon then return end
		local winner = nil
		if real == 1 then
			winner = KEY_1
		elseif real == 2 then
			winner = KEY_2
		elseif real == 3 then
			winner = KEY_3
		elseif real == 4 then
			winner = KEY_4
		end
		local tempTable = {"You got it!", "Quick thinking!", "Nice!", "Mathematical!"}
		if butt == winner then
			WinMinigame(pl, table.Random(tempTable))
		else
			LoseMinigame(pl)
			CreateClientText(pl, "Wrong...", 4, "CCMed", 0.5, 0.75, Color(255,80,80))
		end
	end)
	hook.Add("PlayerSay", "EquationSay", function(pl, text, team)
		if not pl:BroadAlive() then return end
		if pl.gameWon then return end
		if tonumber(text) >= 1 and tonumber(text) <= 4 then
			if tonumber(text) == real then
				local tempTable = {"You got it!", "Quick thinking!", "Nice!", "Mathematical!"}
				WinMinigame(pl, table.Random(tempTable))
				return ""
			else
				LoseMinigame(pl)
				CreateClientText(pl, "Wrong...", 4, "CCMed", 0.5, 0.75, Color(255,80,80))
			end
		end
	end)
end
minigames[curMID].End = function()
	hook.Remove("PlayerButtonDown", "EquationButt")
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
minigames[curMID].Title = "Rocket jump to the platform!"
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
minigames[curMID].End = function()
	hook.Remove("PlayerTick", "RJHook")
	hook.Remove("EntityTakeDamage", "RJHook")
	for i, v in ipairs(ents.FindByModel("models/platformmaster/8x8x1.mdl")) do
		v:Remove()
	end
	for i, v in ipairs(player.GetAll()) do
		v:StripWeapons()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Rocket jump to the top!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_36"
minigames[curMID].Vars.length = 7.9
minigames[curMID].Vars.respawnAtStart = false
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
minigames[curMID].Vars.props = {}
minigames[curMID].Vars.ents = {}
minigames[curMID].Vars.gameWinnable = true
minigames[curMID].Start = function()
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
minigames[curMID].End = function()
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
			table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
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
minigames[curMID].End = function()
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

--curMID = curMID + 1
--minigames[curMID] = {}
--minigames[curMID].ShowTitle = false
--minigames[curMID].Title = "Bombers"
--minigames[curMID].Vars = {}
--minigames[curMID].Vars.music = "minigame_2"
--minigames[curMID].Vars.length = 4
--minigames[curMID].Vars.respawnAtStart = false
--minigames[curMID].Vars.curSpawnVolume = {}
--minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
--minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
--minigames[curMID].Vars.props = {}
--minigames[curMID].Vars.ents = {}
--minigames[curMID].Vars.gameWinnable = false
--minigames[curMID].Start = function()
--	local playerTable = player.GetAll()
--	local bomberTable = {}
--	for i = 1, math.ceil(#playerTable * 0.2), 1 do
--		local randompl = table.Random(playerTable)
--		if not randompl.bomber then
--			randompl.gameWon = false
--			randompl:SetMaxSpeed(500)
--			randompl:SetWalkSpeed(500)
--			randompl:SetRunSpeed(500)
--			randompl:SetJumpPower(0)
--			randompl.bomber = true
--			randompl.light = ents.Create( "light_dynamic" )
--			randompl.light:SetKeyValue("_cone","30")
--			randompl.light:SetKeyValue("_inner_cone","20")
--			randompl.light:SetKeyValue("_light","255 200 110 200")
--			randompl.light:SetKeyValue("brightness","10")
--			randompl.light:SetKeyValue("distance","200")
--			randompl.light:SetKeyValue("pitch","-90")
--			randompl.light:SetKeyValue("spotlight_radius","200")
--			randompl.light:Spawn()
--			randompl.light:SetParent( randompl )
--			randompl.light:SetPos( randompl:GetPos() + Vector(0,0,100) )
--			randompl.glow = ents.Create( "env_sprite" )
--			randompl.glow:SetKeyValue( "rendercolor","200 120 100" )
--			randompl.glow:SetKeyValue( "GlowProxySize","10.0" )
--			randompl.glow:SetKeyValue( "HDRColorScale","1.0" )
--			randompl.glow:SetKeyValue( "renderfx","14" )
--			randompl.glow:SetKeyValue( "rendermode","3" )
--			randompl.glow:SetKeyValue( "renderamt","255" )
--			randompl.glow:SetKeyValue( "disablereceiveshadows","0" )
--			randompl.glow:SetKeyValue( "mindxlevel","0" )
--			randompl.glow:SetKeyValue( "maxdxlevel","0" )
--			randompl.glow:SetKeyValue( "model","sprites/flare1.spr" )
--			randompl.glow:SetKeyValue( "spawnflags","0" )
--			randompl.glow:SetKeyValue( "scale","2" )
--			randompl.glow:Spawn()
--			randompl.glow:SetParent( randompl )
--			randompl.glow:SetPos( randompl:GetPos() + Vector(0,0,40) )
--			timer.Simple(3, function()
--				randompl.glow:Remove()
--				randompl.light:Remove()
--				local kills = 0
--				for n, v in ipairs(player.GetAll()) do
--					if v:GetPos():Distance(randompl:GetPos()) < 300 and not v.bomber then
--						v:Kill()
--						if v ~= randompl then
--							kills = kills + 1
--							LoseMinigame(v, "Better luck next time...")
--						end
--					end
--				end
--				if kills > 0 then
--					WinMinigame(randompl, "You got it!")
--				end
--				local effectData = EffectData()
--				effectData:SetOrigin(randompl:GetPos() + Vector(0,0,20))
--				util.Effect("Explosion",effectData)
--				randompl:Kill()
--			end)
--			table.insert(bomberTable, randompl)
--		end
--	end
--	for i, v in ipairs(playerTable) do
--		if not v.bomber then
--			CreateClientText(v, "Don't get blown up!", 4, "CCBig", 0.5, 0.3, Color(255,255,255))
--		else
--			CreateClientText(v, "Blow up at least 1 player!", 4, "CCBig", 0.5, 0.3, Color(255,100,100))
--		end
--	end
--end
--minigames[curMID].End = function()
--	for i, v in ipairs(player.GetAll()) do
--		v:SetMaxSpeed(320)
--		v:SetWalkSpeed(320)
--		v:SetRunSpeed(320)
--		v:SetJumpPower(300)
--		v.bomber = nil
--	end
--end

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

--curMID = curMID + 1
--minigames[curMID] = {}
--minigames[curMID].Title = "Smash an enemy with a ball!"
--minigames[curMID].Vars = {}
--minigames[curMID].Vars.music = "minigame_29"
--minigames[curMID].Vars.length = 3.9
--minigames[curMID].Vars.respawnAtStart = false
--minigames[curMID].Vars.curSpawnVolume = {}
--minigames[curMID].Vars.curSpawnVolume.mins = Vector(0,0,0)
--minigames[curMID].Vars.curSpawnVolume.maxs = Vector(0,0,0)
--minigames[curMID].Vars.props = {}
--minigames[curMID].Vars.ents = {}
--minigames[curMID].Vars.gameWinnable = true
--minigames[curMID].Start = function()
--	for i, v in ipairs(player.GetAll()) do
--		v:Give("weapon_physcannon")
--		v:SetHealth(1)
--	end
--
--	for i, v in ipairs(player.GetAll()) do
--		local tempProp = ents.Create("prop_physics")
--		local newAng = v:EyeAngles()
--		local tr = util.TraceLine({
--			start = v:GetPos() + Vector(0,0,60),
--			endpos = v:GetShootPos() + (newAng:Forward() * 64) + (v:GetVelocity() * FrameTime() * 4),
--			filter = v
--		})
--		tempProp:SetPos(tr.HitPos)
--		tempProp:SetModel("models/roller.mdl")
--		tempProp:PhysicsInitSphere(16,"metal_bouncy")
--		tempProp:Spawn()
--		local tempPhys = tempProp:GetPhysicsObject()
--		tempPhys:SetMass(250)
--		v:ConCommand("+attack2")
--		timer.Simple(0.1, function()
--			v:ConCommand("-attack2")
--		end)
--	end
--
--	hook.Add("GravGunPunt", "SpaceJamHook", function(pl, ent)
--		ent.Punter = pl
--		timer.Simple(0.01, function()
--			local phys = ent:GetPhysicsObject()
--			phys:SetVelocity(phys:GetVelocity())
--		end)
--	end)
--	hook.Add("PlayerDeath", "SpaceJamDeath", function(victim, inflictor, attacker)
--		WinMinigame(attacker)
--		if inflictor.Punter then
--			WinMinigame(inflictor.Punter)
--		end
--	end)
--end
--minigames[curMID].End = function()
--	hook.Remove("GravGunPunt", "SpaceJamHook")
--	hook.Remove("PlayerDeath", "SpaceJamDeath")
--	for i, v in ipairs(player.GetAll()) do
--		v:StripWeapons()
--		v:SetHealth(200)
--	end
--	local deleteModels = {}
--	deleteModels["models/platformmaster/2x2x1cyl.mdl"] = true
--	deleteModels["models/roller.mdl"] = true
--	deleteModels["models/platformmaster/4x4x1.mdl"] = true
--	deleteModels["models/platformmaster/8x1x1.mdl"] = true
--	for i, v in ipairs(ents.GetAll()) do
--		if deleteModels[v:GetModel()] then
--			v:Remove()
--		end
--	end
--end


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
				table.insert(minigames[curMID].Vars.existingPropTable, tempPlat)
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
		v:SetRealSpeed(0.01)
	end
	timer.Simple(0.5, function()
		for i, v in ipairs(player.GetAll()) do
			v:SetRealSpeed(400)
		end
	end)
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


curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Avoid the lasers!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_4"
minigames[curMID].Vars.length = 3.9
minigames[curMID].Vars.respawnAtEnd = false
minigames[curMID].Vars.gameWinnable = false
minigames[curMID].Start = function()
	local numLasers = 24
	for i = 1, numLasers, 1 do
		local laser = ents.Create("ww_laser")
		laser:SetPos(Vector((-768 - (768 / numLasers)) + (i * (1536 / numLasers)), 0, 512))
		laser:Spawn()
		laser:PhysicsInitShadow(false, false)
		if i % 2 == 0 then
			laser:SetAngles(Angle(0,-90,0))
			laser:GetPhysicsObject():UpdateShadow(laser:GetPos(),Angle(25,-90,0),2)
		else
			laser:SetAngles(Angle(0,90,0))
			laser:GetPhysicsObject():UpdateShadow(laser:GetPos(),Angle(25,90,0),2)
		end
		timer.Simple(2, function()
			if i % 2 == 0 then
				laser:GetPhysicsObject():UpdateShadow(laser:GetPos(),Angle(90,-90,0),1.5)
			else
				laser:GetPhysicsObject():UpdateShadow(laser:GetPos(),Angle(90,90,0),1.5)
			end
		end)
	end
end
minigames[curMID].End = function()
	for i, v in ipairs(ents.FindByClass("ww_laser")) do
		v:Remove()
	end
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].Title = "Remember the path!"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_37"
minigames[curMID].Vars.length = 8
minigames[curMID].Vars.curSpawnVolume = {}
minigames[curMID].Vars.curSpawnVolume.mins = Vector(5298,3070,4030)
minigames[curMID].Vars.curSpawnVolume.maxs = Vector(5300,3072,4032)
minigames[curMID].Vars.respawnAtStart = true
minigames[curMID].Vars.respawnAtEnd = true
minigames[curMID].Vars.gameWinnable = false
minigames[curMID].Start = function()
	LoadPropTable("invis" .. math.random(1, 20))
	local invisTable = {}
	for i, v in ipairs(ents.FindByClass("prop_physics")) do
		v:SetRenderMode(RENDERMODE_TRANSALPHA)
		table.insert(invisTable, v)
	end
	LoadPropTable("baseinvis")
	for i, v in ipairs(player.GetAll()) do
		v:Spawn()
		v:SetCanJump(false)
		v:SetEyeAngles(Angle(0,-180,0))
		v:SetRenderMode(RENDERMODE_TRANSALPHA)
		v:SetColor(Color(255,255,255,0))
		v:SetRealSpeed(0.01)
		CreateClientText(v, "4...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
	end
	timer.Simple(1, function()
		for i, v in ipairs(player.GetAll()) do
			CreateClientText(v, "3...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	timer.Simple(2, function()
		for i, v in ipairs(player.GetAll()) do
			CreateClientText(v, "2...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	timer.Simple(3, function()
		for i, v in ipairs(player.GetAll()) do
			CreateClientText(v, "1...", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	timer.Simple(4, function()
		for i, v in ipairs(player.GetAll()) do
			v:SetRealSpeed(320)
			v:SetCanJump(true)
			v:SetRenderMode(RENDERMODE_NORMAL)
			v:SetColor(Color(255,255,255,255))
			CreateClientText(v, "Go!", 1.25, "CCMed", 0.5, 0.38, Color(255,255,255))
		end
	end)
	local startTime = CurTime() + 3
	hook.Add("Think", "InvisThink", function()
		local newAlpha = 255 - math.Clamp((CurTime() - startTime) * 255, 0, 255)
		for i, v in ipairs(invisTable) do
			if v:IsValid() then
				v:SetColor(Color(v:GetColor().r, v:GetColor().g, v:GetColor().b, newAlpha))
			end
		end
	end)
	local spikeTable = {}
	spikeTable["models/platformmaster/1x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/2x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x1x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x2x1spike.mdl"] = true
	spikeTable["models/platformmaster/4x4x1spike.mdl"] = true
	hook.Add("PlayerTick", "InvisTick", function(pl, move)
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
		local tr = util.TraceHull({
			start = move:GetOrigin(),
			endpos = move:GetOrigin() - Vector(0,0,5000),
			filter = player.GetAll(),
			mins = pl:OBBMins(),
			maxs = pl:OBBMaxs()
		})
		if tr.Hit and tr.Entity:IsValid() and tr.Entity.Vars["winplat"] then
			WinMinigame(pl, "Nice job!")
		end
		if move:GetOrigin().z < 3200 then
			LoseMinigame(pl, "Oops...")
		end
	end)
end
minigames[curMID].End = function()
	DestroyPropTable()
	hook.Remove("Think", "InvisThink")
	hook.Remove("PlayerTick", "InvisTick")
end

curMID = curMID + 1
minigames[curMID] = {}
minigames[curMID].ShowTitle = false
minigames[curMID].Title = "Bombers 2"
minigames[curMID].Vars = {}
minigames[curMID].Vars.music = "minigame_2"
minigames[curMID].Vars.length = 4
minigames[curMID].Vars.respawnAtEnd = false
minigames[curMID].Vars.gameWinnable = false
minigames[curMID].Start = function()
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
minigames[curMID].End = function()
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

--curMID = curMID + 1
--minigames[curMID] = {}
--minigames[curMID].ShowTitle = false
--minigames[curMID].Title = "Pick the right object!"
--minigames[curMID].Vars = {}
--minigames[curMID].Vars.music = "minigame_2"
--minigames[curMID].Vars.length = 8
--minigames[curMID].Vars.respawnAtEnd = false
--minigames[curMID].Vars.gameWinnable = false
--minigames[curMID].Start = function()
--	local correctTable = {}
--	correctTable[1] = "Fart"
--	local correct = table.Random(correctTable)
--
--	for i, v in ipairs(player.GetAll()) do
--		CreateClientText(v, "Pick up a " .. correct .. "!", 4, "CCBig", 0.5, 0.3, Color(255,255,255))	
--	end
--end
--minigames[curMID].End = function()
--end
















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
