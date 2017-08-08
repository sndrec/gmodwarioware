if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Rocket Launcher"
	SWEP.Author = "Upset"
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/q3icons/iconw_rocket")
	killicon.Add("q3_rocket", "vgui/q3icons/iconw_rocket", Color(255, 255, 255, 255))
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.Q3Slot				= 2
end

function SWEP:RadiusDamage(origin, inflictor, attacker, damage, radius, hitent, dmgtype)
	inflictor = IsValid(inflictor) and inflictor or self
	dmgtype = dmgtype or DMG_BLAST
	local mins = Vector()
	local maxs = Vector()
	local v = Vector()

	if radius < 1 then
		radius = 1
	end

	for i = 1, 3 do
		mins[i] = origin[i] - radius
		maxs[i] = origin[i] + radius
	end

	local numListedEntities = ents.FindInBox(mins, maxs)

	for _, ent in pairs(numListedEntities) do
		local absmin, absmax = ent:WorldSpaceAABB()

		for i = 1, 3 do
			if origin[i] < absmin[i] then
				v[i] = absmin[i] - origin[i]
			elseif origin[i] > absmax[i] then
				v[i] = origin[i] - absmax[i]
			else
				v[i] = 0
			end
		end

		local dist = v:Length()
		if dist >= radius then continue end
		local points = damage * (1 - dist / radius)
		points = math.max(15, points)
		local dir = ent:GetPos() - origin
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(attacker)
		dmginfo:SetInflictor(inflictor)
		dmginfo:SetReportedPosition(origin)
		dmginfo:SetDamageType(dmgtype)

		-- splash damage doesn't apply to person directly hit
		if ent ~= hitent then
			dir[3] = dir[3] + 64
			dmginfo:SetDamageForce(dir)
			dmginfo:SetDamage(points)
			if not ent:IsWorld() then
				ent:TakeDamageInfo(dmginfo)
			end
		else
			dir[3] = dir[3] + 24
			dmginfo:SetDamageForce(dir)
			dmginfo:SetDamage(damage)
			if not ent:IsWorld() then
				ent:TakeDamageInfo(dmginfo)
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local rockVel = 1400
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:MuzzleQuake()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:WeaponSound(self.Primary.Sound)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		self.Owner:SetLagCompensated(true)
		local ang = self.Owner:GetAimVector()
		local pos = self.Owner:GetShootPos()
		ang = ang:Angle()
		pos = pos + ang:Forward()
		local ent = ents.Create("hl2_rocket")
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:SetOwner(self.Owner)
		ent:SetDamage(100, self)
		ent.speed = rockVel
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(ang:Forward() * rockVel)
		end
		self.Owner:SetLagCompensated(false)
	end
end

SWEP.HoldType = "ar2"
SWEP.Base = "weapon_q3_base"
SWEP.Category = "Quake 3"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/v_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.Primary.Sound = Sound("weapons/rpg/rocketfire1.wav")
SWEP.Primary.Delay = 10
SWEP.Primary.Ammo = "RPG_Round"
SWEP.MuzzleName = "q3mflash_rocketl"
SWEP.MuzzleRight = 10
SWEP.MuzzleUp = -15