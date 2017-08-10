local microgame = Microgame()

microgame.Title = "Avoid the lasers!"
microgame.Vars = {}
microgame.Vars.music = "minigame_4"
microgame.Vars.length = 3.9
microgame.Vars.respawnAtEnd = false
microgame.Vars.gameWinnable = false
function microgame:Start()
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
function microgame:End()
	for i, v in ipairs(ents.FindByClass("ww_laser")) do
		v:Remove()
	end
end
