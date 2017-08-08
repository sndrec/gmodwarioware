

if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.PrintName			= "SMG1"	
	SWEP.Author				= "Upset"
	SWEP.WepSelectIcon		= surface.GetTextureID("vgui/q3icons/iconw_machinegun")
	killicon.Add("weapon_q3_machinegun", "vgui/q3icons/iconw_machinegun", Color( 255, 255, 255, 255 ))
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
	bullet.HullSize = 4
	bullet.AmmoType = "Pistol"

	self.Owner:FireBullets( bullet )

	self:ShootEffects()

end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:MuzzleQuake()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:EmitSound("weapons/smg1/smg1_fire1.wav",85,100,0.65)
	self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 1)
end

function SWEP:CanSecondaryAttack()
	if CLIENT then
		local world = game.GetWorld()
		if world:GetNWInt("gamestate", 69) ~= 3 then return false end
	elseif gameModeState ~= 3 then return false end
	return true
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Equip()
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_q3_base"
SWEP.Category			= "Quake 3"

SWEP.Spawnable			= true

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Primary.Damage			= 8
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.070
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.Delay		= 1
SWEP.Secondary.Ammo			= "smg1"

SWEP.MuzzleName				= "q3mflash_machinegun"
SWEP.MuzzleForward			= 30
SWEP.MuzzleRight			= 8
SWEP.MuzzleUp				= -14