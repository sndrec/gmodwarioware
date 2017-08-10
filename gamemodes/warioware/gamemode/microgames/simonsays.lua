local microgame = Microgame()

microgame.Title = "Simon says"
microgame.Vars = {}
microgame.Vars.music = "minigame_9"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = true
function microgame:Start()
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
function microgame:End()
	hook.Remove("PlayerTick", "SimonHook")
end
