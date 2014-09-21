local storyboard = require ("storyboard")
local scene = storyboard.newScene ()

local function apertarBotao( event )
	storyboard.gotoScene (event.target.destination, {effect = "fade"})
	return true
end