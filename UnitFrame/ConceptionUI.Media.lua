IGAS:NewAddon "IGAS_UI.UnitFrame"

import "System.Widget"
import "System.Widget.Unit"

--==========================
-- Resources for UnitFrame
--==========================
local path = [[Interface\AddOns\ConceptionUI\media\]]

TextureMap = {
	Blank			= path..[[texture\blank]],
	Raidicon		= path..[[texture\raidicons]],
	ArrowD			= path..[[texture\arrowD]],
	ArrowL			= path..[[texture\arrowL]],
	ArrowR			= path..[[texture\arrowR]],
	Vignetting		= path..[[texture\vignetting]],
	Button			= path..[[texture\button]],
	ButtonShadow	= path..[[texture\buttonShadow]],
	ButtonOverlay	= path..[[texture\buttonOverlay]],
	BackdropShadow	= path..[[texture\backdropShadow]],
	BackdropPixel	= path..[[texture\backdropPixel]],
	DEATHKNIGHT		= path..[[texture\class\dk]],
	WARRIOR			= path..[[texture\class\war]],
	PALADIN			= path..[[texture\class\pal]],
	PRIEST			= path..[[texture\class\pri]],
	SHAMAN			= path..[[texture\class\shm]],
	DRUID			= path..[[texture\class\dru]],
	ROGUE			= path..[[texture\class\rog]],
	MAGE			= path..[[texture\class\mag]],
	WARLOCK			= path..[[texture\class\wlk]],
	HUNTER			= path..[[texture\class\hun]],
	Fire			= path..[[texture\misc\fire]],
	CoreDrill		= path..[[texture\misc\coreDrill]],
	CoreDrill_glow	= path..[[texture\misc\coreDrill_glow]],

	Backdrop 		= { bgFile = path..[[texture\blank]] },
	BarBackdrop 	= {
		bgFile		= path..[[texture\blank]],
		edgeFile	= path..[[texture\backdropShadow]],
		edgeSize	= 3,
		insets		= { left=3, right=3, top=3, bottom=3 },
		tile		= false
	},

	FocusOffColor	= ColorType(0, 0, 0, 0),
	FocusOnColor	= ColorType(0, 0, 0, .382),

	BackdropColor	= ColorType(0, 0, 0, 0),
	BarBackdropColor= ColorType(0, 0, 0, 0.6),

	CASTBAR_COLOR	= ColorType(1, 1, 1),

	DefaultBarColor	= ColorType(1, 1, 1),
	BackgroundColor	= ColorType(0, 0, 0),

	Dropshadow = {
		bgFile		= nil,
		edgeFile	= path..[[texture\backdropShadow]],
		edgeSize	= 5,
		insets		= {left=5, right=5, top=5, bottom=5},
		tile		= false
	},
}

FontMap = {
	Edo			= path..[[fonts\edo.ttf]],
	Pixel			= path..[[fonts\edo.ttf]],
	Pepsi			= path..[[fonts\edo.ttf]],
	Invisible		= path..[[fonts\edo.ttf]],
	HandelGotD		= path..[[fonts\edo.ttf]]
}