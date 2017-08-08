if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "LED"
	SWEP.Author = "Upset"
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/q3icons/iconw_rocket")
	killicon.Add("q3_rocket", "vgui/q3icons/iconw_rocket", Color(255, 255, 255, 255))
end

function SWEP:Initialize()
	if SERVER then
		self:SetNPCMinBurst(30)
		self:SetNPCMaxBurst(30)
		self:SetNPCFireRate(0.01)
	end
	self:SetHoldType(self.HoldType)
	self:SetModelScale(0.5,0)
	self:SetMaterial("bomb")
end

if CLIENT then

	local model = ClientsideModel( "models/ww/bomb.mdl" )
	model:SetMaterial("bomb")
	model:SetNoDraw(true)
	model:SetModelScale(0.5,0)
	local offsetvec = Vector(-2,-3,-1)
	local offsetang = Angle(200,20,30)

	local offsetVecWorld = Vector(4,-4,0)
	local offsetAngWorld = Angle(180,0,0)

	function SWEP:PostDrawViewModel( vm, weapon, pl )
		if weapon:GetClass() == "weapon_pdm_led" then
			vm:ManipulateBonePosition( 1, Vector(0,0,-50) )
			vm:ManipulateBonePosition( 44, Vector(0,0,-50) )
			vm:ManipulateBonePosition( 45, Vector(0,0,-50) )
			local matrix = vm:GetBoneMatrix( 24 )

			if not matrix then
				return
			end
		
			local newpos, newang = LocalToWorld( offsetvec, offsetang, matrix:GetTranslation(), matrix:GetAngles() )
		
			model:SetPos( newpos )
			model:SetAngles( newang )
			model:SetupBones()
			model:DrawModel()
		end
		local dir = EyeVector()
		dir.z = 0
		dir:Normalize()
		cam.Start3D()
		render.SetColorMaterial()
		render.DrawSphere( LocalPlayer():GetPos() + (dir * 440), 32, 32, 16, Color(40,40,40,255) )
		render.DrawSphere( LocalPlayer():GetPos() + (dir * 440), 200, 32, 16, Color(255,50,50,100) )
		cam.End3D()
	end

	function SWEP:DrawWorldModel()
		model:SetModelScale(0.5,0)
		local matrix = self.Owner:GetBoneMatrix(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if matrix == nil then return end
		local newpos, newang = LocalToWorld( offsetVecWorld, offsetAngWorld, matrix:GetTranslation(), matrix:GetAngles() )
		self:SetRenderOrigin(newpos)
		self:SetRenderAngles(newang)
		self:DrawModel()
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local ang = self.Owner:EyeAngles()
	local tempang = ang
	tempang.p = -15
	local dir = tempang:Forward()
	local pos = self.Owner:GetShootPos() + dir
	if SERVER then
		local bomb = ents.Create("ww_bomb")
		bomb:SetPos(pos)
		bomb:SetOwner(self:GetOwner())
		bomb:Spawn()
		local phys = bomb:GetPhysicsObject()
		print(dir)
		phys:SetVelocity(dir * 750)
		self:Remove()
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SpecialThink()
end

SWEP.HoldType = "knife"
SWEP.Base = "weapon_q3_base"
SWEP.Category = "Quake 3"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/ww/bomb.mdl"
SWEP.Primary.Sound = Sound("weapons/slam/throw.wav")
SWEP.Primary.Delay = 0.8
SWEP.Primary.Ammo = "RPG_Round"