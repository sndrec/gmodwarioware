
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_missile_launch.mdl")
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)

	self.trail = util.SpriteTrail( self, 0, Color(255, 255, 255, 100), false, 12, 12, 2, 0.01, "materials/trails/smoke.vmt" )
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0)
	end
	
	self.trackspeed = 512
	self.flysound = CreateSound(self, "weapons/rocket/rockfly.wav")
	self.flysound:Play()
end

function ENT:PhysicsCollide(data, physobj)
	if self.projDisabled then return end
	local start = data.HitPos + data.HitNormal
    local endpos = data.HitPos - data.HitNormal
	
	local tr = util.TraceLine({
		start = endpos,
		endpos = start,
		filter = self
	})
	
	if tr.HitWorld then
		if tr.HitSky then self:PrepareToRemove() return end
	end

	self:ExplodeRocket(tr, data, physobj)
end

function ENT:ExplodeRocket(tr, data, physobj)
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos )
	util.Effect( "HelicopterMegaBomb", effectdata )
	self:EmitSound( "weapons/explode" .. math.random(3,5) .. ".wav", 90, 100)
	if IsValid(self:GetOwner()) then
		local radius = 145
		self:RadiusDamage(tr.HitPos, self, self:GetOwner(), self.Damage, radius, data.HitEntity)
	else
		self:RadiusDamage(tr.HitPos, self, game.GetWorld(), self.Damage, radius, data.HitEntity)
	end
	self:PrepareToRemove()
end

function ENT:PrepareToRemove()

	if self.Owner:Alive() and self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetClass() == "weapon_pdm_hl2_rpg" then
		self.Owner:GetActiveWeapon():SetNextPrimaryFire(CurTime() + 0.65)
	end
	self.projDisabled = true
	if self.flysound then self.flysound:Stop() end
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	self:SetNoDraw(true)
	timer.Simple(2, function() self:Remove() end)

end

function ENT:OnRemove()
end

function ENT:Think()
	if not self.Owner:IsValid() or not self.Owner:Alive() then return end
	local phys = self:GetPhysicsObject()
	--print(trackspeed)
	local posTrack = (self:GetPos() - self.Owner:GetEyeTrace().HitPos):GetNormalized() * self.trackspeed
	local vel = self:GetVelocity() - posTrack
	vel:Normalize()
	vel = vel * self.speed
	phys:SetVelocity(vel)
	self:NextThink(CurTime() + 0.05)
	return true
end