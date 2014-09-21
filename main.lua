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

--> Adciona o player posiciona
local person = display.newImage( "bnk2.png" )
person.x = display.contentWidth/2 - 200
person.y = 150
physics.addBody( person, {bounce = 0, radius = 60, friction =1.0} )
person.isFixedRotation = true

--> Adciona o chão do jogo
local floor = display.newImage( "ground.png" )
floor:scale(display.contentWidth/floor.contentWidth, display.contentHeight/4/floor.contentHeight)         
floor.x = display.contentWidth - floor.contentWidth/2  
floor.y = display.contentHeight - floor.contentHeight/2
floor.x, floor.y = 285, 360
physics.addBody( floor,"static",{bounce = 0, friction =1.0} )

--> cria as paredes para limitar o espaço
local leftWall = display.newRect(0, 0, 0.1, display.contentHeight)
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



--> Criando funcoes
--[[
local function persontouch( event )
	if ( event.phase == "began" ) then
		person:applyForce( 10, -20, person.x, person.y )
	end
	return true
end  ]]

-- make jump forward
local function onScreenTouch( event )
	if event.phase == "began" then
		--if event.xStart == person.x then
			person:applyForce( 10, -20, person.x, person.y )
		--end
	end
	return true
end  

--[[
local function showFPS( event )
	print( display.fps )
end ]]



--> event listeners
--person:addEventListener( "touch", persontouch )
Runtime:addEventListener( "touch", onScreenTouch )
--Runtime:addEventListener( "enterFrame", showFPS )