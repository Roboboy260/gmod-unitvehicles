include("shared.lua")

local mat = Material("sprites/light_glow02_add")
local matr = Matrix()
local Headlights = GetConVar("unitvehicle_enableheadlights")

function ENT:Initialize()
	
	self:GetModelData()

	if not self.RotorSounds then
		self.RotorSounds = {
			"<chopper/mwheli.wav",
			"<chopper/mwheli2.wav",
			"<chopper/mwheli3.wav",
			"<chopper/mwheli4.wav",
		}
	end

	for i=1, #self.RotorSounds do
		self["RotorSoundPatch"..i] = self.RotorSounds[i]
		self["RotorSound"..i] = CreateSound(self, self["RotorSoundPatch"..i])
		self["RotorSound"..i]:SetSoundLevel(85)
		self["RotorSound"..i]:Play()
	end
	
	self.Spotlight = ProjectedTexture()
	self.Spotlight:SetTexture("effects/flashlight001")
	self.Spotlight:SetFarZ(2048)
	self.Spotlight:SetFOV(50)
	self.Spotlight:SetColor(color_white)
	local pos,ang = LocalToWorld(self.SpotlightPos,Angle(),self:GetPos(),self:GetAngles())
	self.Spotlight:SetPos(pos)
	self.Spotlight:SetAngles(ang)
	self.Spotlight:SetEnableShadows(false)
	self.Spotlight:Update()

	self.Skyhammer = ProjectedTexture()
	self.Skyhammer:SetTexture("effects/flashlight001")
	self.Skyhammer:SetFarZ(2500)
	self.Skyhammer:SetFOV(50)
	self.Skyhammer:SetColor(Color(254,72,108))
	self.Skyhammer:SetPos(pos)
	self.Skyhammer:SetAngles(ang)
	self.Skyhammer:SetEnableShadows(false)
	self.Skyhammer:Update()
	
	self:DrawShadow(true)
	self.Scale = Vector(1,1,1)

	self.canusespotlight = false

	timer.Create("UVAirSpotlight" .. self:EntIndex(), 1, 0, function()
		if not IsValid(self) then
			return
		end

		if Headlights:GetInt() == 0 then
			self.canusespotlight = false
			return
		elseif Headlights:GetInt() == 2 then
			self.canusespotlight = true
			return
		end

	    if not IsValid(self:GetTarget()) then 
			self.canusespotlight = false
			return 
		end

	    local c = render.ComputeLighting( self:GetTarget():GetPos(), Vector( 0, 0, 1 ) )
	    local avg = ( c[1] * 0.2126 ) + ( c[2] * 0.7152 ) + ( c[3] * 0.0722 ) -- Luminosity method
	    local shouldBeOn = Either( self.canusespotlight, avg < 1.3, avg < 0.2 )

	    self.canusespotlight = shouldBeOn
	end)
end

function ENT:Draw()
	local vel = WorldToLocal(self:GetVelocity(),Angle(),Vector(),Angle(0,self:GetAngles().y,0))
	local speed = self:GetVelocity():Length2D()
	
	self.Scale = Vector(1,1,1)
	matr:SetScale(self.Scale)

	self:EnableMatrix("RenderMultiply",matr)
	self:DrawModel()

	if not self.GotAllLights then return end
	
	local spotpos = self.Spotlight:GetPos()
	local strobepos = LocalToWorld(self.StrobePos*self.Scale,Angle(),self:GetPos(),self:GetAngles())
	local strobepos2 = LocalToWorld(self.StrobePos2*self.Scale,Angle(),self:GetPos(),self:GetAngles())
	local portpos = LocalToWorld(self.PortPos*self.Scale,Angle(),self:GetPos(),self:GetAngles())
	local starboardpos = LocalToWorld(self.StarboardPos*self.Scale,Angle(),self:GetPos(),self:GetAngles())
	local sternpos = LocalToWorld(self.SternPos*self.Scale,Angle(),self:GetPos(),self:GetAngles())
	
	local spotdist = EyePos():Distance(spotpos)
	local strobedist = EyePos():Distance(strobepos)
	local strobedist2 = EyePos():Distance(strobepos2)
	local portdist = EyePos():Distance(portpos)
	local starboarddist = EyePos():Distance(starboardpos)
	local sterndist = EyePos():Distance(sternpos)
	
	if IsValid(self:GetTarget()) and spotdist<10000 and util.TraceLine({start = EyePos(),endpos = spotpos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		if self.canusespotlight and not self.skyhammeractive then
			mat:SetInt("$ignorez",0)
			
				render.SetMaterial(mat)
				render.DrawSprite(spotpos,256,256,Color(255,255,255,255-spotdist/10000*255))
			
			mat:SetInt("$ignorez",1)
		end

		if self.skyhammeractive then
			mat:SetInt("$ignorez",0)
		
				render.SetMaterial(mat)
				render.DrawSprite(spotpos,256,256,Color(254,72,108,255-spotdist/10000*255))
		
			mat:SetInt("$ignorez",1)
		end
	end
	
	if strobedist<10000 and math.floor(CurTime()*1)==math.Round(CurTime()*1) and util.TraceLine({start = EyePos(),endpos = strobepos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(strobepos,128,128,Color(255,0,0,255-strobedist/10000*255))
		
		mat:SetInt("$ignorez",1)
	end

	if strobedist2<10000 and math.floor(CurTime()*1.1)==math.Round(CurTime()*1.1) and util.TraceLine({start = EyePos(),endpos = strobepos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(strobepos2,128,128,Color(255,0,0,255-strobedist2/10000*255))
		
		mat:SetInt("$ignorez",1)
	end

	if portdist<10000 and util.TraceLine({start = EyePos(),endpos = portpos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(portpos,64,64,Color(255,0,0,255-portdist/10000*255))
		
		mat:SetInt("$ignorez",1)
	end

	if starboarddist<10000 and util.TraceLine({start = EyePos(),endpos = starboardpos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(starboardpos,64,64,Color(0,255,0,255-starboarddist/10000*255))
		
		mat:SetInt("$ignorez",1)
	end

	if sterndist<10000 and util.TraceLine({start = EyePos(),endpos = sternpos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(sternpos,64,64,Color(255,255,255,255-sterndist/10000*255))
		
		mat:SetInt("$ignorez",1)
	end

end

function ENT:Think()
	local speed = self:GetVelocity():Length()

	for i=1, #self.RotorSounds do
		self["RotorSound"..i]:ChangePitch(100+math.Round(math.Clamp(speed/80,0,5),1),1)
	end
	
	if self.GotAllLights then
		self.Spotlight:SetPos(LocalToWorld(self.SpotlightPos*self.Scale,Angle(),self:GetPos(),self:GetAngles()))
		self.Skyhammer:SetPos(LocalToWorld(self.SpotlightPos*self.Scale,Angle(),self:GetPos(),self:GetAngles()))
		if IsValid(self:GetTarget()) then
			if self.canusespotlight and not self.skyhammeractive then
				self.Spotlight:SetBrightness(10)
				self.Spotlight:SetAngles((self:GetTargetPos()-self.Spotlight:GetPos()):Angle())
			else
				self.Spotlight:SetBrightness(0)
			end

			if self.skyhammeractive then
				self.Skyhammer:SetBrightness(10)
				self.Skyhammer:SetAngles((self:GetTargetPos()-self.Skyhammer:GetPos()):Angle())
			else
				self.Skyhammer:SetBrightness(0)
			end
		else
			self.Spotlight:SetBrightness(0)
			self.Skyhammer:SetBrightness(0)
		end
		self.Spotlight:Update()
		self.Skyhammer:Update()
	end

	if not self.NextGroundFX then self.NextGroundFX = 0 end

	local pos = self:GetPos()
	local floor = util.TraceLine({
		start = pos,
		endpos = pos - Vector(0,0,1000),
		filter = self,
		mask = MASK_ALL
	})

	if floor.Hit then
		local height = pos.z - floor.HitPos.z

		if height < 600 and CurTime() > self.NextGroundFX then
			local strength = math.Clamp(1 - (height / 600), 0, 1)

			local effectdata = EffectData()
			effectdata:SetOrigin( floor.HitPos )
			effectdata:SetScale( strength * 1000 )
			effectdata:SetEntity( self )
			util.Effect( "ThumperDust", effectdata )

			local watereffectdata = EffectData()
			watereffectdata:SetOrigin( floor.HitPos )
			watereffectdata:SetScale( strength * 100 )
			watereffectdata:SetEntity( self )
			util.Effect( "waterripple", watereffectdata )

			self.NextGroundFX = CurTime() + Lerp(strength, 0.15, 0.06)
		end
	end	
end

function ENT:OnRemove()
	for i=1, #self.RotorSounds do
		self["RotorSound"..i]:Stop()
	end
	
	if self.Spotlight and IsValid(self.Spotlight) then
		self.Spotlight:Remove()
	end

	if self.Skyhammer and IsValid(self.Skyhammer) then
		self.Skyhammer:Remove()
	end
end