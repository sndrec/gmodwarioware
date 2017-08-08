include( "player_class/player_ww.lua" )

GM.Name			= "Warioware"
GM.Author		= "Garry Newman"
GM.Email		= "garrynewman@gmail.com"
GM.Website		= "www.garry.tv"
GM.TeamBased	= false

function GM:CreateTeams()
   team.SetUp( 1, "Microgamers", Color(100,100,240), true )
end

function CappedAccelerate(pl, move, wishdir, wishspeed, accel)
   local playerVelocity = move:GetVelocity()
   local currentspeed = playerVelocity:Dot(wishdir)
   local addspeed = wishspeed - currentspeed
   if (addspeed <= 0) then return end
   local accelspeed = accel * FrameTime() * wishspeed
   if (accelspeed > addspeed) then
      accelspeed = addspeed
   end
   playerVelocity = playerVelocity + (wishdir * accelspeed)
   local oldVel = move:GetVelocity()
   if oldVel:Length2DSqr() > move:GetMaxSpeed() * move:GetMaxSpeed() and playerVelocity:Length2DSqr() > oldVel:Length2DSqr() then
      local newVel = Vector(0,0,playerVelocity.z)
      playerVelocity.z = 0
      local newpower = oldVel:Length2D()
      local newdir = playerVelocity:GetNormalized()
      playerVelocity = newVel + (newpower * newdir)
   end
   move:SetVelocity(playerVelocity)
end

function Accelerate(pl, move, wishdir, wishspeed, accel)
   local playerVelocity = move:GetVelocity()
   local currentspeed = playerVelocity:Dot(wishdir)
   local addspeed = wishspeed - currentspeed
   if (addspeed <= 0) then return end
   if pl:Crouching() then accel = accel / 3 end
   local accelspeed = accel * FrameTime() * wishspeed

   if (accelspeed > addspeed) then
      accelspeed = addspeed
   end
   playerVelocity = playerVelocity + (wishdir * accelspeed)
   move:SetVelocity(playerVelocity)
end

local function TestPlayerPos(pl, pos)
   local stuckTrOrig = util.TraceHull({
      start = pl:GetPos(),
      endpos = pl:GetPos() + Vector(0,0,1),
      filter = pl,
      mins = pl:OBBMins(),
      maxs = pl:OBBMaxs(),
   })
   if not stuckTrOrig.StartSolid then return true end
   local stuckTr = util.TraceHull({
      start = pl:GetPos() + pos,
      endpos = pl:GetPos(),
      filter = pl,
      mins = pl:OBBMins(),
      maxs = pl:OBBMaxs(),
   })
   if stuckTr.StartSolid or stuckTr.AllSolid then return true end
   return false, stuckTr.HitPos
end

function GM:SetupMove(pl, move, cmd)
   if not pl:BroadAlive() then return end
   local stuckTr1 = util.TraceHull({
      start = pl:GetPos(),
      endpos = pl:GetPos(),
      filter = pl,
      mins = pl:OBBMins(),
      maxs = pl:OBBMaxs(),
   })

   if stuckTr1.StartSolid and not stuckTr1.Entity:IsPlayer() and stuckTr1.Entity:GetModel() ~= "models/weapons/w_missile_launch.mdl" then
      local hit, newPos = TestPlayerPos(pl, Vector(0,0,16))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(16,0,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(-16,0,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(0,16,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(0,-16,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(16,16,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(-16,16,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(16,-16,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
      hit, newPos = TestPlayerPos(pl, Vector(-16,-16,0))
      if not hit then
         move:SetOrigin(newPos)
         return
      end
   end
end

function GM:Move(pl, move)
   if pl:GetCanJump() and move:KeyPressed(IN_JUMP) and pl:OnGround() then
      local addVel = Vector(0,0,0)
      local groundEnt = pl:GetGroundEntity()
      if groundEnt:IsValid() and groundEnt:GetClass() == "prop_physics" then
         addVel = groundEnt:GetVelocity()
      end
      move:SetOrigin(move:GetOrigin() + Vector(0,0,2))
      pl:SetGroundEntity(nil)
      move:SetVelocity(move:GetVelocity() + Vector(0,0,300) + addVel)
   end
   if GetConVar("sv_turbophysics"):GetInt() == 1 and pl:OnGround() then
      local groundEnt = pl:GetGroundEntity()
      if groundEnt:IsValid() and groundEnt:GetClass() == "prop_physics" then
         move:SetOrigin(move:GetOrigin() + (groundEnt:GetVelocity() * FrameTime()))
      end
   end
   if pl:GetWWMovement() == 0 then
      if not pl:OnGround() then
         local aim = move:GetMoveAngles()
         local forward, right = aim:Forward(), aim:Right()
         local fmove = move:GetForwardSpeed()
         local smove = move:GetSideSpeed()
         forward[3], right[3] = 0, 0
         forward:Normalize()
         right:Normalize()
         local wishvel = forward * fmove + right * smove
         wishvel[3] = 0
         local wishspeed = wishvel:Length()
   
         local wishdir = wishvel:GetNormal()
         CappedAccelerate(pl, move, wishdir, wishspeed, 0.20)
      end
   elseif pl:GetWWMovement() == 1 then
      if not pl:OnGround() then
         local aim = move:GetMoveAngles()
         local forward, right = aim:Forward(), aim:Right()
         local fmove = move:GetForwardSpeed()
         local smove = move:GetSideSpeed()
         forward[3], right[3] = 0, 0
         forward:Normalize()
         right:Normalize()
         local wishvel = forward * fmove + right * smove
         wishvel[3] = 0
         local wishspeed = wishvel:Length()
   
         if (wishspeed > move:GetMaxSpeed()) then
            wishvel = wishvel * (move:GetMaxSpeed() / wishspeed)
            wishspeed = move:GetMaxSpeed()
         end
   
         local wishdir = wishvel:GetNormal()
         local strafeAccel = 1
         local airAccel = 30
         Accelerate(pl, move, wishdir, wishspeed, strafeAccel)
   
         if (wishspeed > 50) then
            wishvel = wishvel * (50 / wishspeed)
            wishspeed = 50
         end
         Accelerate(pl, move, wishdir, wishspeed, airAccel)
      end
   end
   if pl.knockbackVel then
      local kvel = pl.knockbackVel
      local velocity = move:GetVelocity()
      move:SetVelocity(velocity + kvel)
      pl.knockbackVel = nil
   end
end

hook.Add( "EntityEmitSound", "TimeWarpSounds", function( t )

   local p = t.Pitch

   if game.GetTimeScale() ~= 1 then
      p = p * game.GetTimeScale()
   end

   if p ~= t.Pitch then
      t.Pitch = math.Clamp( p, 0, 255 )
      return true
   end

end )

local PLAYERMETA = FindMetaTable("Player")
function PLAYERMETA:SetWWPoints(var)
   self:SetDTInt(1,var)
end
function PLAYERMETA:GetWWPoints()
   return self:GetDTInt(1)
end
function PLAYERMETA:SetWWMovement(var)
   self:SetDTInt(2,var)
end
function PLAYERMETA:GetWWMovement()
   return self:GetDTInt(2)
end
function PLAYERMETA:SetCanJump(var)
   self:SetDTBool(1,var)
end
function PLAYERMETA:GetCanJump()
   return self:GetDTBool(1)
end
function PLAYERMETA:SetMarked(var)
   self:SetDTBool(2,var)
end
function PLAYERMETA:GetMarked()
   return self:GetDTBool(2)
end
function PLAYERMETA:SetRealSpeed(var)
   self:SetMaxSpeed(var)
   self:SetWalkSpeed(var)
   self:SetRunSpeed(var)
end
function PLAYERMETA:BroadAlive()
   return self:Alive() and self:GetObserverMode() == OBS_MODE_NONE
end