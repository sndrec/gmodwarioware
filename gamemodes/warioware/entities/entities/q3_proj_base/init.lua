
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:SetDamage(dmg, inflictor)
	self.Damage = dmg
	self.Inflictor = inflictor
end

function ENT:RadiusDamage(origin, inflictor, attacker, damage, radius, hitent, dmgtype)
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
		if dist >= radius then
			continue
		end
		
		local points = damage * (1 - dist / radius)
		points = math.max(15, points)
		
		local dir = ent:GetPos() - origin
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(attacker)
		dmginfo:SetInflictor(inflictor)
		dmginfo:SetReportedPosition(origin)
		dmginfo:SetDamageType(dmgtype)
		// splash damage doesn't apply to person directly hit
		if ent != hitent then
			dir[3] = dir[3] + 64
			dmginfo:SetDamageForce(dir)
			dmginfo:SetDamage(points)
			ent:TakeDamageInfo(dmginfo)
		else
			dir[3] = dir[3] + 24
			dmginfo:SetDamageForce(dir)
			dmginfo:SetDamage(damage)
			ent:TakeDamageInfo(dmginfo)
		end
	end	
end