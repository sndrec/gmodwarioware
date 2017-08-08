
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel("models/ww/bomb.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	phys:SetMass(150)
	self:SetMaterial("bomb")
	self:NextThink(CurTime())
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end

function ENT:Explode()
	data = EffectData()
	data:SetOrigin(self:GetPos())
	util.Effect("Explosion",data)
	for i, v in ipairs(player.GetAll()) do
		if not v.bomber and v:GetPos():Distance(self:GetPos()) < 200 then
			dmg = DamageInfo()
			dmg:SetDamage(300)
			dmg:SetAttacker(self:GetOwner())
			dmg:SetInflictor(self)
			dmg:SetDamageForce(self:GetPos() - v:GetPos())
			v:TakeDamageInfo(dmg)
			WinMinigame(self:GetOwner(), "Nice aim!")
			LoseMinigame(v, "Ouch...")
		end
	end
	self:Remove()
end

function ENT:PhysicsCollide(data, physobj)

	self:Explode()

end

function ENT:OnRemove()
end