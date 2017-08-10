DEFINE_BASECLASS( "gamemode_base" )
include( "proptables.lua" )
include( "goalvolumes.lua" )

curSpawnVolume = {}
curSpawnVolume.mins = Vector(-700,-700,256)
curSpawnVolume.maxs = Vector(700,700,300)
minigames = {}

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

function Microgame()
	local tempTable = {}
	table.insert(minigames, tempTable)
	return tempTable
end

--microgame.Title = "Smash an enemy with a ball!"
--microgame.Vars = {}
--microgame.Vars.music = "minigame_29"
--microgame.Vars.length = 3.9
--microgame.Vars.respawnAtStart = false
--microgame.Vars.curSpawnVolume = {}
--microgame.Vars.curSpawnVolume.mins = Vector(0,0,0)
--microgame.Vars.curSpawnVolume.maxs = Vector(0,0,0)
--microgame.Vars.props = {}
--microgame.Vars.ents = {}
--microgame.Vars.gameWinnable = true
--function microgame:Start()
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
--function microgame:End()
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

--microgame.ShowTitle = false
--microgame.Title = "Pick the right object!"
--microgame.Vars = {}
--microgame.Vars.music = "minigame_2"
--microgame.Vars.length = 8
--microgame.Vars.respawnAtEnd = false
--microgame.Vars.gameWinnable = false
--function microgame:Start()
--	local correctTable = {}
--	correctTable[1] = "Fart"
--	local correct = table.Random(correctTable)
--
--	for i, v in ipairs(player.GetAll()) do
--		CreateClientText(v, "Pick up a " .. correct .. "!", 4, "CCBig", 0.5, 0.3, Color(255,255,255))	
--	end
--end
--function microgame:End()
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
