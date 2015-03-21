local storyboard = require ("storyboard")
local scene = storyboard.newScene()

local function apertarBotao( event )
	storyboard.gotoScene (event.target.destination, {effect = "fade"})
	return true
end



function scene:createScene( event )
	local group = self.view
	
	local background = display.newImage( "menu.png" )
     background:scale(display.contentWidth/background.contentWidth, display.contentHeight/background.contentHeight)         
     background.x = display.contentWidth/2         
     background.y = display.contentHeight/2
     group:insert(background) 


	local playBtn = display.newText("VOLTAR", 200, 0, "Garamond", 50)
	--playBtn:setTextColor(0, 0, 0)
	playBtn.x = centerX
	playBtn.y = centerY
	playBtn.destination = "menu"
	playBtn:addEventListener ("tap", apertarBotao)
	group:insert(playBtn)






	 
	 
	 
	
	
	settings = {
	
	orientation = {
		default = "landscapeRight",
		supported = { "landscapeRight", }
	},
	
	iphone = {
		plist = {
			UIStatusBarHidden = false,
			UIPrerenderedIcon = true, -- set to false for "shine" overlay
			UIApplicationExitsOnSuspend = true,
		}
	},
	
	--[[ For Android:
	
	androidPermissions = {
  		"android.permission.INTERNET",
  	},
	]]--
}
end


function scene:enterScene( event )
	local group = self.view
	-- Usado pra inicializar contadores, musicas, afins logo ao entrar na cena.
end

function scene:exitScene( event )
	local group = self.view
	-- Usado pra remover músicas, contadores e afins logo ao sair da cena.
end

function scene:destroyScene( event )
	local group = self.view
	-- Usado para remover do grupo "view" os audios, contadores e afins para liberarem memoria.
end

scene:addEventListener ("createScene", scene)
scene:addEventListener ("enterScene", scene)
scene:addEventListener ("exitScene", scene)
scene:addEventListener ("destroyScene", scene)

return scene