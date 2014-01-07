local _, D = unpack(select(2,...))
local path = [[Interface\AddOns\ConceptionUI\media\]]

D.MEDIA = {
	TEXTURE = {
		blank			= path..[[texture\blank]],
		raidicon		= path..[[texture\raidicons]],
		arrowD		= path..[[texture\arrowD]],
		arrowL		= path..[[texture\arrowL]],
		arrowR		= path..[[texture\arrowR]],
		vignetting		= path..[[texture\vignetting]],
		button		= path..[[texture\button]],
		buttonShadow	= path..[[texture\buttonShadow]],
		buttonOverlay	= path..[[texture\buttonOverlay]],
		backdropShadow	= path..[[texture\backdropShadow]],
		backdropPixel	= path..[[texture\backdropPixel]],
		DEATHKNIGHT		= path..[[texture\class\dk]],
		WARRIOR		= path..[[texture\class\war]],
		PALADIN		= path..[[texture\class\pal]],
		PRIEST		= path..[[texture\class\pri]],
		SHAMAN		= path..[[texture\class\shm]],
		DRUID			= path..[[texture\class\dru]],
		ROGUE			= path..[[texture\class\rog]],
		MAGE			= path..[[texture\class\mag]],
		WARLOCK		= path..[[texture\class\wlk]],
		HUNTER		= path..[[texture\class\hun]],
		fire			= path..[[texture\misc\fire]],
		coreDrill		= path..[[texture\misc\coreDrill]],
		coreDrill_glow	= path..[[texture\misc\coreDrill_glow]],

		backdrop = { -- unitframe,
			bgFile	= path..[[texture\blank]],
			edgeFile	= path..[[texture\backdropShadow]],
			edgeSize	= 3,
			insets	= {left=3, right=3, top=3, bottom=3},
			tile		= false
		},

		buttonBorder = { -- action bar buttons
			bgFile	= nil,
			edgeFile	= path..[[texture\backdropPixel]],
			edgeSize	= 2,
			insets	= {left=2, right=2, top=2, bottom=2},
			tile		= false
		},

		dropshadow = {
			bgFile	= nil,
			edgeFile	= path..[[texture\backdropShadow]],
			edgeSize	= 5,
			insets	= {left=5, right=5, top=5, bottom=5},
			tile		= false
		}
	},

	SOUND = {
		Initial		= path..[[sounds\initial.mp3]],
		Ready			= path..[[sounds\ready.mp3]],
		Check			= path..[[sounds\check.mp3]],
		Error			= path..[[sounds\error.mp3]],
		Whisper		= path..[[sounds\whisper.mp3]],
		Excellent		= path..[[sounds\excellent.mp3]],
		Damn			= path..[[sounds\damn.mp3]]
	},

	FONT = {
		edo			= path..[[fonts\edo.ttf]],
		pixel			= path..[[fonts\pixel.ttf]],
		pepsi			= path..[[fonts\pepsi.ttf]],
		invisible		= path..[[fonts\invisible.ttf]],
		HandelGotD		= path..[[fonts\HandelGotD.ttf]]
	}
}