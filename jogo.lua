local storyboard = require ("storyboard")
local scene = storyboard.newScene ()

local function apertarBotao( event )
	storyboard.gotoScene (event.target.destination, {effect = "fade"})
	return true
end
-- -------------------------------------
-- main.lua  >> ( SoftShoes ) <<
-- -------------------------------------
print( "Height: ", display.contentHeight )
print( "Width: ", display.contentWidth )

--> add physics
local physics = require( "physics" )
physics.start()
physics.setGravity(0, 9.8)
--system.activate( "multitouch" )
--physics.setDrawMode( "hybrid" )


--> add background
local background = display.newImage( "background.png" )
background:scale(display.contentWidth/background.contentWidth, display.contentHeight/background.contentHeight)         
background.x = display.contentWidth/2         
background.y = display.contentHeight/2


--> Caixas para colisão 
local caixa = display.newImage("caixa.png")
caixa:scale(display.contentWidth/background.contentWidth, display.contentHeight/background.contentHeight)         
caixa.x = display.contentWidth/2         
caixa.y = display.contentHeight/2  
---> caixa mover


--> Adiciona o personagem e  posiciona
local person = display.newImage("person.gif")
person.x = display.contentWidth - 900
person.y = 100
physics.addBody( person, {bounce = 0, radius = 110, friction =1.0} )
person.isFixedRotation = true

--> Adiciona o chão do jogo
local floor = display.newImage("ground.png")
floor:scale(display.contentWidth/floor.contentWidth, display.contentHeight/4/floor.contentHeight)         
floor.x = display.contentWidth - floor.contentWidth/2  
floor.y = display.contentHeight - floor.contentHeight/2
floor.x, floor.y = 480, 700
physics.addBody( floor,"static",{bounce = 0.1, friction =1.0} )

--> cria as paredes para limitar o espaço
local leftWall = display.newRect(0, 0, 0, display.contentHeight)
leftWall.x = 0
leftWall.y = display.contentHeight/2
physics.addBody( leftWall, "static", {density = 5.0, friction = 0.3, bounce = 0.2} )

local rightWall = display.newRect(display.contentWidth, 0, 0.1, display.contentHeight)
rightWall.x = display.contentWidth
rightWall.y = display.contentHeight/2
physics.addBody( rightWall, "static", {density = 1.0, friction = .6, bounce = 0.2} )

local topWall = display.newRect(0, 0, display.contentWidth, 0.1)
topWall.x = display.contentWidth / 2
topWall.y = 0
physics.addBody( topWall, "static", {density = 1.0, friction = 0.6, bounce = 0.2} )

-- make jump forward
local function onScreenTouch( event )
	if event.phase == "began" then
		--if event.xStart == person.x then
			person:applyForce( 0, -45 , person.x, person.y )
		--end
	end
	return true
end  


--> event listeners
--person:addEventListener( "touch", persontouch )
Runtime:addEventListener( "touch", onScreenTouch )
--Runtime:addEventListener( "enterFrame", showFPS )



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