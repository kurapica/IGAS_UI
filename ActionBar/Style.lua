-----------------------------------------
-- Style Interface for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

-----------------------------------------------
--- IFStyle
-- @type interface
-- @name IFStyle
-----------------------------------------------
interface "IFStyle"
	_PLAYER_CLASS_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	_PLAYER_CLASS_COLOR.a = 1

	_PUSH_COLOR = ColorType(1 - _PLAYER_CLASS_COLOR.r, 1-_PLAYER_CLASS_COLOR.g, 1-_PLAYER_CLASS_COLOR.b)

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

	_BorderTexture = [[Interface\Addons\IGAS_UI\Resource\border.tga]]

	_IconLoc = {
		AnchorPoint("TOPLEFT", 2, -2),
		AnchorPoint("BOTTOMRIGHT", -2, 2),
	}

	local function OnSizeChanged(self)
		local size = math.min(self.Width, self.Height)
		local border = math.max(2, math.ceil(size/24))

		self:GetChild("Icon").Location = {
			AnchorPoint("TOPLEFT", border, -border),
			AnchorPoint("BOTTOMRIGHT", -border, border),
		}

		self:GetChild("HotKey").Location = { AnchorPoint("TOPRIGHT", -border, -border) }
		self:GetChild("Count").Location = { AnchorPoint("BOTTOMRIGHT", -border, border) }
		self:GetChild("Name").Location = { AnchorPoint("BOTTOM", 0, border) }
	end

    function IFStyle(self)
    	self.UseBlizzardArt = false

		self.NormalTexturePath = _BorderTexture
		self.NormalTexture:ClearAllPoints()
		self.NormalTexture:SetAllPoints()
		self.NormalTexture.VertexColor = _PLAYER_CLASS_COLOR

		self.PushedTexturePath = _BorderTexture
		self.PushedTexture.VertexColor = _PUSH_COLOR

		self:GetChild("Icon").Location = _IconLoc

		self.OnSizeChanged = self.OnSizeChanged + OnSizeChanged
    end
endinterface "IFStyle"

class "IActionButton"
	extend "IFStyle"

	property "Icon" {
		Get = function(self)
			return self:GetChild("Icon").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Icon").TexturePath = value
			if value then
				self:GetChild("Icon"):SetTexCoord(0.06, 0.94, 0.06, 0.94)
			end
		end,
		Type = String+Number,
	}
endclass "IActionButton"