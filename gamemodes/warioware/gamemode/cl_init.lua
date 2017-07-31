include( "shared.lua" )
include( "sounds.lua" )

net.Receive("ClientSound", function()

	local newSound = net.ReadString()
	local pitch = net.ReadFloat()
	local volume = net.ReadFloat()
	if LocalPlayer():IsValid() then
		LocalPlayer():EmitSound(newSound, 100, pitch, volume, CHAN_AUTO)
	end

end)

net.Receive("StopMusic", function()
	RunConsoleCommand("stopsound")
end)

function CreateGameFonts()
	surface.CreateFont( "CCBig", {
		font = "Comical Cartoon", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 52 * (ScrW() / 1600),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "CCMed", {
		font = "Comical Cartoon", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 32 * (ScrW() / 1600),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "CCSmall", {
		font = "Comical Cartoon", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 18 * (ScrW() / 1600),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end

CreateGameFonts()

net.Receive("CreateClientText", function()

	local textTable = {}
	textTable.text = net.ReadString()
	textTable.time = net.ReadFloat()
	textTable.spawnTime = CurTime()
	textTable.font = net.ReadString()
	textTable.x = net.ReadFloat()
	textTable.y = net.ReadFloat()
	textTable.color = net.ReadColor()
	table.insert(serverClientTextTable, textTable)

end)

serverClientTextTable = {}
local crosshairMat = Material("crosshair.png", "smooth")

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end
local targetMat = Material("target.png", "smooth")
hook.Add("PostDrawOpaqueRenderables", "DrawTargets", function(bool1, bool2)
	for i, v in ipairs(ents.GetAll()) do
		if v:GetModel() == "models/combine_helicopter/helicopter_bomb01.mdl" then
			render.SetMaterial(targetMat)
			render.DrawSprite(v:GetPos(),32 * v:GetModelScale(),32 * v:GetModelScale(),Color(255,255,255))
		end
	end
end)

hook.Add("HUDPaint", "DrawServerText", function()

	for i, v in ipairs(player.GetAll()) do
		if v:BroadAlive() then
			local worldPos = v:GetPos() + Vector(0,0,74)
			local posTable = worldPos:ToScreen()
			draw.SimpleTextOutlined(v:GetWWPoints(),"CCSmall",posTable.x,posTable.y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0))
			draw.SimpleTextOutlined(v:Nick(),"DermaDefaultBold",posTable.x,posTable.y - ScrH() * 0.02,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0))
		end
	end

	surface.SetMaterial(crosshairMat)
	surface.SetDrawColor(255,255,255,255)
	local size = math.max(ScrW() * 0.02, 32)
	surface.DrawTexturedRect((ScrW() * 0.5) - (size * 0.5), (ScrH() * 0.5) - (size * 0.5), size, size )

	for i = #serverClientTextTable, 1, -1 do
		local fadeIn = math.min((CurTime() - serverClientTextTable[i].spawnTime) * 30, 1)
		local fadeOut = math.max(((CurTime() + 0.333) - serverClientTextTable[i].time) * 30, 0)
		local alpha = (fadeIn - fadeOut) * 255
		--print(fadeIn, fadeOut)
		draw.SimpleTextOutlined(serverClientTextTable[i].text,serverClientTextTable[i].font,ScrW() * serverClientTextTable[i].x,ScrH() * serverClientTextTable[i].y,Color(serverClientTextTable[i].color.r, serverClientTextTable[i].color.g, serverClientTextTable[i].color.b, alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0, alpha))
		if CurTime() > serverClientTextTable[i].time then table.remove(serverClientTextTable, i) end
	end
	draw.SimpleTextOutlined("Points: " .. LocalPlayer():GetWWPoints(),"CCMed",ScrW() * 0.25,ScrH() * 0.80,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0))

end)


local bhstop = 0xFFFF - IN_JUMP
local band = bit.band
local shouldjump

function GM:CreateMove(uc)
	
	lp = LocalPlayer()
	
	if !lp:Alive() and lp:Team() != TEAM_SPECTATOR then uc:ClearMovement() end
	
	if lp:WaterLevel() < 2 and lp:Alive() then
		if !lp:InVehicle() and band(uc:GetButtons(), IN_JUMP) > 0 then
			if lp:IsOnGround() then
				shouldjump = nil
			else
				if !shouldjump then return end
				uc:SetButtons( band(uc:GetButtons(), bhstop) )
			end
		end
		
		if !lp:IsOnGround() then
			shouldjump = true
		end
	end
end


function CreateSun()

	local CSMColour = Color(255,255,255)
	local CSMAngle = Angle(39.3, 117.9, 45)
	local NearZ = 5000
	local FarZ = 15000
	local Brightness = 30
	local Pos = EyePos() + -CSMAngle:Forward() * 10000
	
	if CSM1 ~= nil and CSM1:IsValid() then
		CSM1:Remove()
		CSM2:Remove()
	end

	CSM1 = ProjectedTexture()
	CSM1:SetOrthographic(true, 800, 800, 800, 800)
	CSM1:SetColor(CSMColour)
	CSM1:SetTexture("sun/sun-128")
	CSM1:SetNearZ(NearZ)
	CSM1:SetFarZ(FarZ)
	CSM1:SetAngles(CSMAngle)
	CSM1:SetBrightness(Brightness)
	CSM1:SetPos(Pos + LocalPlayer():GetPos())
	CSM1:Update()
	
	CSM2 = ProjectedTexture()
	CSM2:SetOrthographic(true, 3200, 3200, 3200, 3200)
	CSM2:SetColor(CSMColour)
	CSM2:SetTexture("sun/sun-512")
	CSM2:SetNearZ(NearZ)
	CSM2:SetFarZ(FarZ)
	CSM2:SetAngles(CSMAngle)
	CSM2:SetBrightness(Brightness)
	CSM2:SetPos(Pos + LocalPlayer():GetPos())
	CSM2:Update()

	sunSpawned = true

	hook.Add("Think", "ParentSun", function()

		
		if (sunSpawned == true ) then
			CSM1:SetPos(EyePos() + -CSMAngle:Forward() * 10000 + LocalPlayer():GetPos())
			CSM1:Update()
	
			CSM2:SetPos(EyePos() + -CSMAngle:Forward() * 10000 + LocalPlayer():GetPos())
			CSM2:Update()	
		end
	end)
end

function GM:InitPostEntity()
	net.Start("RequestState")
	net.SendToServer()
	RunConsoleCommand("cl_interp","0.033")
	RunConsoleCommand("cl_interp_ratio","0")
	RunConsoleCommand("cl_cmdrate","66")
	RunConsoleCommand("cl_updaterate","66")
	RunConsoleCommand("rate","300000")
	RunConsoleCommand("r_radiosity", "2")
end

local HUDHide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true
}

hook.Add( "HUDShouldDraw", "HUDHide", function( name )
	if ( HUDHide[ name ] ) then return false end
end )

net.Start("RequestState")
net.SendToServer()

net.Receive("RequestState", function()
	local state = net.ReadInt(16)
	if state == 0 then
		LocalPlayer():EmitSound("gamesound/tf2ware/waitingforplayers.mp3",100,100,1,CHAN_AUTO)
	end
end)


local thirdperson = false
hook.Add("PlayerBindPress", "ThirdpersonToggle", function(pl, bind, pressed)
	if bind == "gm_showspare1" and pressed == true then
		if thirdperson == true then
			thirdperson = false
		else
			thirdperson = true
		end
	end
	if bind == "gm_showteam" and pressed == true then
		SettingsMenu()
	end
end)

local pitchAdd = 0

function GM:CalcView(pl, pos, angles, fov)

	local view = {}
	pitchAdd = pitchAdd - (pl:GetVelocity().z * FrameTime() * 0.06)
	pitchAdd = math.Approach( pitchAdd, 0, FrameTime() * pitchAdd * 5)
	angles = pl:EyeAngles()
	local newAng2 = Angle(pitchAdd, 0, 0)
	if pl:Alive() and pl:GetObserverMode() == OBS_MODE_NONE and thirdperson then
		view.fov = GetConVar( "default_fov" ):GetFloat()
		local newP = angles.p
		if angles.p <= -45 then angles.p = (angles.p - 45) * 0.5 newP = (newP - 45) * 0.5 end
		local newAng = Angle(newP, angles.y, angles.r) + newAng2
		local tr = util.TraceLine({
			start = pos,
			endpos = pos - ( newAng:Forward() * 100 ),
			filter = pl
		})

		view.origin = tr.HitPos + Vector(0,0,24)
		view.angles = angles + newAng2
		view.drawviewer = true
	else
		view.fov = GetConVar( "default_fov" ):GetFloat()
		view.origin = pos
		view.angles = angles
	end


	return view
end