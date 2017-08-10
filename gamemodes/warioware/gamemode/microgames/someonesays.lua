local microgame = Microgame()

microgame.Title = "Someone says"
microgame.Vars = {}
microgame.Vars.music = "minigame_9"
microgame.Vars.length = 4
microgame.Vars.respawnAtStart = false
microgame.Vars.curSpawnVolume = {}
microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
microgame.Vars.props = {}
microgame.Vars.ents = {}
microgame.Vars.gameWinnable = false
function microgame:Start()
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
function microgame:End()
	hook.Remove("PlayerTick", "SomeoneHook")
end