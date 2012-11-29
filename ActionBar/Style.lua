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
	_PLAYER_CLASS_COLOR = IGAS:CopyTable(_G.RAID_CLASS_COLORS[select(2, UnitClass("player"))])
	_PLAYER_CLASS_COLOR.a = 0.8

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

    function IFStyle(self)
    	self.UseBlizzardArt = false

		self.NormalTexturePath = nil

		self:SetBackdrop(_BackDrop)
		self.BackdropBorderColor = _PLAYER_CLASS_COLOR
    end
endinterface "IFStyle"

partclass "IActionButton"
	extend "IFStyle"
endclass "IActionButton"