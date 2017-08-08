
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel("models/props_lab/tpplug.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:NextThink(CurTime())
	self.soundHandler = ents.Create("prop_dynamic")
	self.soundHandler:SetModel("models/props_lab/tpplug.mdl")
	self.soundHandler:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.soundHandler:SetColor(0,0,0,0)
	self.soundHandler:SetModelScale(0,0)
	self.soundHandler.playing = false
end

function ENT:Think()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos() + (self:GetAngles():Forward() * 8192),
		filter = self,
		mins = Vector(-4,-4,-4),
		maxs = Vector(4,4,4)
	})
	if tr.Hit and not tr.HitSky then
		if self.soundHandler.playing == false then
			self.soundHandler.playing = true
			self.soundHandler:EmitSound( "wwlaser", 100, 100, 1 )
		end
		if tr.Entity:IsPlayer() then
			dmginfo = DamageInfo()
			dmginfo:SetAttacker(game.GetWorld())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(1000)
			tr.Entity:TakeDamageInfo(dmginfo)
		end
	end
	self.soundHandler:SetPos(tr.HitPos)
	if tr.HitSky and self.soundHandler.playing == true then
		self.soundHandler:StopSound("wwlaser")
		self.soundHandler.playing = false
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("wwlaser")
	self.soundHandler:StopSound("wwlaser")
	self.soundHandler:Remove()
end