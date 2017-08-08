

if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.PrintName			= "Shotgun"			
	SWEP.Author				= "Upset"
	SWEP.WepSelectIcon		= surface.GetTextureID("vgui/q3icons/iconw_shotgun")
	killicon.Add("weapon_q3_shotgun", "vgui/q3icons/iconw_shotgun", Color( 255, 255, 255, 255 ))
	
end

function SWEP:ShootBullet(damage, num_bullets, aimcone)

	local bullet = {}

	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )	-- Aim Cone
	bullet.Tracer	= 1 -- Show a tracer on every x bullets
	bullet.Force	= 1 -- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.HullSize = 8
	bullet.AmmoType = "Pistol"

	self.Owner:FireBullets( bullet )

	self:ShootEffects()

end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:MuzzleQuake()
	self:WeaponSound(self.Primary.Sound)
	self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 0)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

SWEP.HoldType			= "revolver"
SWEP.Base				= "weapon_q3_base"
SWEP.Category			= "Quake 3"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.Primary.Sound			= Sound("weapons/357/357_fire2.wav")
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.65
SWEP.Primary.Ammo			= "Buckshot"

SWEP.MuzzleName				= "q3mflash_shotgun"
SWEP.MuzzleForward			= 30
SWEP.MuzzleRight			= 6
SWEP.MuzzleUp				= -21