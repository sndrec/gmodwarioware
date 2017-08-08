include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds( Vector(-512,-512,512), Vector(512,512,512), Vector(1024,1024,1024) )
	self.sparkTimer = CurTime() + math.random()
end

function ENT:OnRemove()
end

local laserMat = Material("laser.png", "smooth")

function ENT:Draw()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos() + (self:GetAngles():Forward() * 8192),
		filter = self,
		mins = Vector(-4,-4,-4),
		maxs = Vector(4,4,4)
	})
	if tr.Hit and not tr.HitSky then
		if CurTime() > self.sparkTimer then
			self.sparkTimer = CurTime() + 0.05
			local sparkData = EffectData()
			sparkData:SetOrigin(tr.HitPos + tr.HitNormal)
			sparkData:SetNormal(tr.HitNormal)
			sparkData:SetScale(1)
			sparkData:SetMagnitude(1)
			util.Effect( "ElectricSpark", sparkData )
		end
	end
	render.SetMaterial(laserMat)
	if not tr.HitSky then
		render.DrawBeam(self:GetPos(),tr.HitPos,8,0,1 * tr.Fraction,Color(240,80, 80, 170))
	else
		render.DrawBeam(self:GetPos(),self:GetPos() + self:GetAngles():Forward() * 8192,8,0,1 * tr.Fraction,Color(240,80, 80, 170))
	end
	self:DrawModel()
end