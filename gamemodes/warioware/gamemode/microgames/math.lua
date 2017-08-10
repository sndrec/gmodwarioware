
local microgame = Microgame()

microgame.Title = "Choose the correct answer!"
microgame.Vars = {}
microgame.Vars.music = "minigame_21"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
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
function microgame:End()
	hook.Remove("PlayerButtonDown", "EquationButt")
	hook.Remove("PlayerSay", "EquationSay")
end