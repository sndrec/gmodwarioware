include("shared.lua")

function ENT:Initialize()
	self.angle = self:GetAngles()
	self.trackerMat = Material("sprites/hud/v_crosshair1")
end

function ENT:OnRemove()
	hook.Remove( "DrawRPGHalo", "AddHalos" )
end

function ENT:Draw()
	if self:GetVelocity():Length() == 0 and (CurTime() - self:GetCreationTime()) < 1 then return end
	if self.Owner == LocalPlayer() and not LocalPlayer():IsLineOfSightClear(self:GetPos()) then
		local posTable = self:GetPos():ToScreen()
		cam.Start2D()
		surface.SetMaterial(self.trackerMat,true)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(posTable.x - 16,posTable.y - 16,32,32)
		cam.End2D()
	end
	self:DrawModel()
	self:SetRenderAngles(Angle(self.angle.p, self.angle.y, (CurTime() * 180) % 360))
	if self.effectdelay == nil or self.effectdelay + .03 < CurTime() then
		self.effectdelay = CurTime()
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() -self:GetAngles():Forward() *4)
		effectdata:SetScale(1.5)
		util.Effect("q3smoketrail", effectdata)
	end
end