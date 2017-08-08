

if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.PrintName			= "Shotgun"			
	SWEP.Author				= "Upset"
	SWEP.WepSelectIcon		= surface.GetTextureID("vgui/q3icons/iconw_shotgun")
	killicon.Add("weapon_q3_shotgun", "vgui/q3icons/iconw_shotgun", Color( 255, 255, 255, 255 ))
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.Q3Slot				= 2
	
end

function SWEP:ShootBullet(damage, num_bullets, aimcone)

	local bullet = {}

	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )	-- Aim Cone
	bullet.Tracer	= 4 -- Show a tracer on every x bullets
	bullet.Force	= 1 -- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.HullSize = 16

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

function SWEP:CanSecondaryAttack()
	if CLIENT then
		local world = game.GetWorld()
		if world:GetNWInt("gamestate", 69) ~= 3 then return false end
	elseif gameModeState ~= 3 then return false end
	return true
end

function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() then return end
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:MuzzleQuake()
	self:WeaponSound(self.Secondary.Sound)
	self:ShootBullet(self.Primary.Damage, self.Primary.NumShots * 2, self.Primary.Cone * 2.5, 0)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_q3_base"
SWEP.Category			= "Quake 3"
SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire7.wav")
SWEP.Primary.Damage			= 4
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= 0.1
SWEP.Primary.Delay			= 0.75
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Secondary.Delay		= 1
SWEP.Secondary.Sound		= Sound("weapons/shotgun/shotgun_dbl_fire7.wav")

SWEP.MuzzleName				= "q3mflash_shotgun"
SWEP.MuzzleForward			= 30
SWEP.MuzzleRight			= 6
SWEP.MuzzleUp				= -21