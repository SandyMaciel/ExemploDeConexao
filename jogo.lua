local storyboard = require ("storyboard")
local scene = storyboard.newScene ()

local function teste( event )
	storyboard.gotoScene (event.target.destination, {effect = "fade"})
	return true
end
-- -------------------------------------
-- main.lua  >> ( Shoeaholic) <<
-- -------------------------------------
print( "Height: ", display.contentHeight )
print( "Width: ", display.contentWidth )


--> add physics
local physics = require( "physics" )
physics.start()
physics.setGravity(0, 10)
--system.activate( "multitouch" )
--physics.setDrawMode( "hybrid" )


--> add background
local background = display.newImage( "background.png" )
background:scale(display.contentWidth/background.contentWidth, display.contentHeight/background.contentHeight)         
background.x = display.contentWidth/2         
background.y = display.contentHeight/2


--> Caixas para colisão 
caixas = {}
i = 0;
speed = 10

-- De 0 a 100 qual o percentual de vezes que aparece cada item
caixa  = 30
sapato = 50 + caixa
cartao = 20 + sapato

function createbox()
    caixaSapatoOuCartao = math.random(0,cartao)
    if(caixaSapatoOuCartao < caixa) then
        caixas[i] = display.newImage("caixa.png")
        caixas[i].myName = "caixa"
    elseif(caixaSapatoOuCartao < sapato) then
        caixas[i] = display.newImage("sapato.jpg")
        caixas[i].myName = "sapato"
    else
        caixas[i] = display.newImage("cartao.jpg")
        caixas[i].myName = "cartao"
    end

    caixas[i].x = display.contentWidth-10
    caixas[i].y = math.random(0, display.contentHeight)
    physics.addBody(caixas[i], "dynamic")
    caixas[i].gravityScale = 0;
    i=i+1;
end

function moverCaixas()
    for j = 0, i do
        if(caixas[j] ~= nil) then
            caixas[j].x = caixas[j].x - speed
        end
    end
end

function aumentarVelocidadeCaixa ()
	speed = speed+ 1
end

timer.performWithDelay(30000,aumentarVelocidadeCaixa,100000000000000000000000000000)




local function bateuEmAlgo(event, algo)
    return (event.object1.myName == algo and event.object2.myName == "boneca") or
            (event.object1.myName == "boneca" and event.object2.myName == algo)
end

local function perdeuPlayboya()
    print( "acabou o jogo")
--    storyboard.gotoScene ("menu", {effect = "fade"})
end

local function lascouOMarido()
    print("Ganhou pontos de dinheiro aqui")
end

local function eeeebaaaaSapatoGratis()
    print("Sei la o que sapatos batendo em meninas significa para a lida!")
end

local function onCollision( event )

    if ( event.phase == "began" ) then
        if(bateuEmAlgo(event,"caixa")) then
            perdeuPlayboya()
        end
        if(bateuEmAlgo(event,"cartao")) then
            lascouOMarido()
        end
        if(bateuEmAlgo(event,"sapato")) then
            eeeebaaaaSapatoGratis()
        end
    end
end



--> Adiciona o personagem e  posiciona
local person = display.newImage("person.gif")
person.myName = "boneca"
person.x = display.contentWidth - 1100
person.y = 100
physics.addBody( person, {bounce = -10, radius = 110, friction =1} )
person.isFixedRotation = true


--> Adiciona o chão do jogo
local floor = display.newImage("ground.png")
floor:scale(display.contentWidth/floor.contentWidth, display.contentHeight/4/floor.contentHeight)         
floor.x = display.contentWidth - floor.contentWidth/2
floor.y = display.contentHeight - floor.contentHeight/2 
floor.x, floor.y = 570, 700 --onde a imagem do chao ta aparecendo
physics.addBody( floor,"static",{bounce = 0.5, friction =1.0} )

--> cria as paredes para limitar o espaço

local leftWall = display.newRect(0, 0,0 , display.contentHeight)
leftWall.myName = "paredeLeft"
leftWall.x = 0
leftWall.y = display.contentHeight/2 
physics.addBody( leftWall, "static", {density = 0, friction = 0, bounce = 0} )

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
Runtime:addEventListener("enterFrame", moverCaixas)
timer.performWithDelay( 3000, createbox, 100 )
Runtime:addEventListener( "collision", onCollision )

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

function scene:enterFrame(event)
	local group = self.view
	-- usado para mover as caixas
end



scene:addEventListener ("createScene", scene)
scene:addEventListener ("enterScene", scene)
scene:addEventListener ("exitScene", scene)
scene:addEventListener ("destroyScene", scene)
scene:addEventListener ("enterFrame", scene)


return scene