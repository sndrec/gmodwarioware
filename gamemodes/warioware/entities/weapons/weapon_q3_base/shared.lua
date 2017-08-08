
game.AddAmmoType({name = "q3_chaingun"})

if SERVER then

	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

else

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 65
	SWEP.ViewModelFlip		= false
	SWEP.BobScale			= 0
	SWEP.SwayScale			= .5
end

SWEP.Author					= "Upset"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.Category				= "Quake 3"
SWEP.Spawnable				= false

SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.DrySound				= Sound("weapons/noammo.wav")
SWEP.HolsterSound			= Sound("weapons/change.wav")
SWEP.MuzzleLight			= "q3muzzlelight"

SWEP.DelayBeforeShot		= 5
SWEP.EquipAmmoAmount		= 10
SWEP.EnableHS				= false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(self.DelayBeforeShot)
end

function SWEP:WeaponSound(snd, pitch)
	local myPitch = pitch or 100
	self:EmitSound(snd, 100, myPitch, 1, CHAN_STATIC)
end

function SWEP:CanPrimaryAttack()
	return true
end

//thanks to Slade for this

local wep = {}
wep[9] = {"weapon_q3_gauntlet",nil}
wep[8] = {"weapon_q3_machinegun","smg1"}
wep[7] = {"weapon_q3_shotgun","Buckshot"}
wep[6] = {"weapon_q3_grenadelauncher","Grenade"}
wep[5] = {"weapon_q3_rocketlauncher","RPG_Round"}
wep[4] = {"weapon_q3_lightninggun","GaussEnergy"}
wep[3] = {"weapon_q3_railgun","StriderMinigun"}
wep[2] = {"weapon_q3_plasmagun","AR2"}
wep[1] = {"weapon_q3_bfg10k","CombineCannon"}

function SWEP:ShootBullet(dmg, numbul, cone, ric)
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone, cone, 0)
	bullet.Tracer	= 4
	bullet.Force	= 4
	bullet.Damage	= dmg
	if ric == 1 then
		bullet.Callback	= Ricochet
	end

	self.Owner:FireBullets(bullet)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:MuzzleQuake()
	if IsFirstTimePredicted() then
		local fx = EffectData()
		fx:SetEntity(self)
		fx:SetOrigin(self.Owner:GetShootPos() +self.Owner:GetForward() *30 +self.Owner:GetRight() *self.MuzzleRight +self.Owner:GetUp() *self.MuzzleUp)
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(1)
		util.Effect(self.MuzzleName, fx)
		util.Effect(self.MuzzleLight, fx)
	end
end

local sndkit

local function SetSoundKit(plmodel)
	for k, v in pairs(GetValidQ3Model()) do
		if plmodel == player_manager.TranslatePlayerModel(v) then
			sndkit = player_manager.TranslateToPlayerModelName(plmodel)
			return true
		end
	end
end

if SERVER then return end

local t = 1

function SWEP:GetViewModelPosition(pos, ang)
	if !IsValid(self.Owner) then return end
	
	local vel = self.Owner:GetVelocity()
	local xyspeed = vel:Length2D()	
	local bob
	
	local cl_bobmodel_side = 1.1
	local cl_bobmodel_up = .22
	local cl_bobmodel_speed = 8.75

	local s = CurTime() * cl_bobmodel_speed
	if (!game.SinglePlayer() and IsFirstTimePredicted()) or game.SinglePlayer() then
		if self.Owner:IsOnGround() then
			t = Lerp(FrameTime()*6, t, 1)
		else
			t = math.max(Lerp(FrameTime()*6, t, 0.01), 0)
		end
	end

	local bspeed = math.Clamp(xyspeed, 0, 700) * 0.01
	bob = bspeed * cl_bobmodel_side * math.sin (s) * t
	ang.y = ang.y + bob
	ang.r = ang.r + bob / 3
	bob = bspeed * cl_bobmodel_up * math.cos (s * 2) * t
	ang.p = ang.p - bob
	
	local scale = xyspeed + 40
	local fracsin = math.sin(CurTime())
	local idle = scale * fracsin * .01
	ang = ang + Angle(idle, idle, idle)
	
	if self.Owner.shakepos then
		pos[3] = pos[3] - self.Owner.shakepos * 1.25
	end

	return pos, ang
end

function SWEP:PostDrawViewModel( vm, weapon, pl )
	vm:ManipulateBonePosition( 1, Vector(0,0,0) )
end