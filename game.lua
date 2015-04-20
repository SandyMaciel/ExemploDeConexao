--Shoesaholic--

--Storyboard
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Fisica
local physics = require("physics")	
physics.start(); physics.setGravity( 0, 20 )
--physics.setDrawMode( "hybrid" )

local sections = require("sectionData")

local _W = display.contentWidth
local _H = display.contentHeight
local mR = math.random
local mF = math.floor

--Grupos
local mainGroup, firstGroup, objectGroup, extraGroup

--Sounds
local sapatosSound, overSound, jumpSound
local shoesChannel, jumpChannel, overChannel  --usado para os sons

---Variaveis
local singleJump, doubleJump = false, false   
local menuShown, gameOverCalled = false, false  
local distChange, distChange2 = 0, 0  
local gameIsActive = false 
local distance, score = 0, 0
local levelSpeed = 8  

--Imagens...
local bg1, bg2, ground1, ground2, extra1, extra2
local hudBar, distanceText, scoreText


local gameLoop, onCollision, playerJump, createGame, createSection 


local player
local playerSheet, playerSprite 

----Funcoes-----

function scene:createScene( event )
	print( "GAME: createScene event")
	local screenGroup = self.view

	-- criando grupos e colcoando dentro dos views
	firstGroup = display.newGroup()
	objectGroup = display.newGroup()
	extraGroup = display.newGroup()
	screenGroup:insert(firstGroup)
	screenGroup:insert(objectGroup)
	screenGroup:insert(extraGroup) 

	--carregando os sons
	sapatosSound = audio.loadSound("sounds/Collect.mp3")  
	overSound = audio.loadSound("sounds/Defeat2.mp3")
	jumpSound = audio.loadSound("sounds/Jump.mp3")


	--------------------------------------------
	-- chao, pontuacao e distancia
	--------------------------------------------
	hudBar = display.newImageRect(extraGroup, "images/clearheader.png", 480,36)
	hudBar.x = _W*0.5; hudBar.y = 14; hudBar.alpha = 0.5

	distanceText = display.newText(extraGroup, "Distancia: "..distance,0,0,"Arial",17)
	distanceText.anchorX = 1
	distanceText.anchorY = 0.5
	--distanceText:setReferencePoint(display.CenterRightReferencePoint); 
	distanceText:setFillColor(50/255)
	distanceText.x = _W-6; distanceText.y = 14

	scoreText = display.newText(extraGroup, "Pontuação: "..score,0,0,"Arial",17)
	scoreText.anchorX = 0
	scoreText.anchorY = 0.5
	--scoreText:setReferencePoint(display.CenterLeftReferencePoint); 
	scoreText:setFillColor(50/255)
	scoreText.x = 6; scoreText.y = 14


	--------------------------------------------
	-- Play do jogo
	--------------------------------------------
	function playerJump( event )
		if event.phase == "ended" then
			if doubleJump == false then 
				player:setLinearVelocity( 0, 0 )
				player:applyForce(0,-11, player.x, player.y)
				player:setSequence("jump")
				jumpChannel = audio.play(jumpSound)
			end

			if singleJump == false then singleJump = true 
			else doubleJump = true end
		end
		return true
	end

	



	local lastSection = 0
	function createSection()
		local sectInt = mR(1,#sections)
		if sectInt == lastSection then sectInt = mR(1,#sections) end
		lastSection = sectInt

		
		local i
		
		for i=1, #sections[sectInt]["shoe"] do
			local object = sections[sectInt]["shoe"][i]
			local shoes = display.newImageRect(objectGroup, "images/3Small.png", 30, 30)
			shoes.x = object["position"][1]+(480*object["screen"]); shoes.y = object["position"][2]; shoes.name = "shoes"
			physics.addBody( shoes, "static", { isSensor = true } )
		end

	end

	
	function createGame()
		local i 
		for i=objectGroup.numChildren,1,-1 do
			local object = objectGroup[i]
			if object ~= nil then
				display.remove(objectGroup[i])
				objectGroup[i] = nil; 
			end
		end
		
		--display.remove(objectGroup);
		if player then display.remove(player); player = nil; playerSheet = nil; end
		if bg1 then display.remove(bg1); bg1 = nil; end
		if bg2 then display.remove(bg2); bg2 = nil; end
		
		if ground1 then display.remove(ground1); ground1 = nil; end
		if ground2 then display.remove(ground2); ground2 = nil; end
		

		-- adc background
		bg1 = display.newImageRect(firstGroup, "images/bg1.jpg", 480, 320)
		bg1.anchorX = 0.5
		bg1.anchorY = 0
		--bg1:setReferencePoint(display.TopCenterReferencePoint); 
		bg1.x = 240; bg1.y = 0
		bg2 = display.newImageRect(firstGroup, "images/bg2.jpg", 480, 320)
		bg2.anchorX = 0.5
		bg2.anchorY = 0
		--bg2:setReferencePoint(display.TopCenterReferencePoint); 
		bg2.x = 720; bg2.y = 0

		
		local physicsShape = { -240, -20, 240, -20, 240, 22, -240, 22 }
		ground1 = display.newImageRect(extraGroup, "images/clearheader.png", 480, 45)
		ground1.x = 240; ground1.y = _H-22; ground1.name = "floor"
		physics.addBody( ground1,  "static", { friction=0.1, bounce=0, shape=physicsShape} )
		ground2 = display.newImageRect(extraGroup, "images/clearheader.png", 480, 45)
		ground2.x = 720; ground2.y = _H-22; ground2.name = "floor"
		physics.addBody( ground2,  "static", { friction=0.1, bounce=0, shape=physicsShape} )

		
		----------
		--sprites
		--------
		local options = 
		{
			width = 45, height = 62,
			numFrames = 4,
			sheetContentWidth = 180,
			sheetContentHeight = 62
		}
		playerSheet = graphics.newImageSheet( "images/playerSprite.png", options)
		playerSprite = { 
			{name="run", start=1, count=3, time = 400, loopCount = 0 },
			{name="jump", start=4, count=1, time = 1000, loopCount = 1 },
		}

		player = display.newSprite(playerSheet, playerSprite)
		player.anchorX = 0.5
		player.anchorY = 1
		--player:setReferencePoint(display.BottomCenterReferencePoint)
		player.x = 64; player.y = _H*0.6; player.name = "player";
		extraGroup:insert(player); player:play()

		physics.addBody( player,  "dynamic", { friction=0, bounce=0} )	
		player.isFixedRotation = true 	 
		player.isSleepingAllowed = false  


		

 		Runtime:addEventListener("touch", playerJump)

		 
		createSection()
	end
	createGame()
end


 
function scene:enterScene( event )
	print( "GAME: enterScene event" )
	local screenGroup = self.view

 
	storyboard.removeAll()


	 -- fun loop
	local function changeText(amount)
		if amount ~= nil then
			score = score + amount
			scoreText.text = "Pontuação: "..score
			scoreText.anchorX = 0
			scoreText.anchorY = 0.5
			--scoreText:setReferencePoint(display.CenterLeftReferencePoint)
			scoreText.x = 6
		end
	end

	--Main gameLoop function
	function gameLoop( event )
		if gameIsActive == true then
			 
			distance = distance + 1
			distanceText.text = "Distância: "..mF((distance*0.3)+(levelSpeed*0.5)) --So it goes up at a good speed.
			distanceText.anchorX = 1
			distanceText.anchorY = 0.5
			--distanceText:setReferencePoint(display.CenterRightReferencePoint)
			distanceText.x = _W-6

			 
			local i
			for i = objectGroup.numChildren,1,-1 do
				local object = objectGroup[i]
				if object ~= nil and object.y ~= nil then
					object:translate( -levelSpeed, 0)
					if object.x < -200 then 
						display.remove(object); object = nil;
					end
				end
			end

			 
			bg1:translate(-(levelSpeed*0.6),0) 	
			bg2:translate(-(levelSpeed*0.6),0) 
			ground1:translate(-levelSpeed,0)
			ground2:translate(-levelSpeed,0) 
			
			if ground1.x <= -240 then
				ground1.x = ground1.x + 960
			end
			if ground2.x <= -240 then
				ground2.x = ground2.x + 960
				
			end
			if bg1.x <= -240 then bg1.x = bg1.x + 960 end
			if bg2.x <= -240 then bg2.x = bg2.x + 960 end


			 
			distChange2 = distChange2 + levelSpeed
			if distChange2 >= 1440 then 
				distChange2 = 0
				createSection() 
			end


			 
			distChange = distChange + 1 
			if distChange >= 300 then
				lvlChange = 0.8; 
				if distance >= 3000 then lvlChange = 0.6 end
				distChange = 0
				levelSpeed = levelSpeed + lvlChange
			end
		end
	end


	--------------------------------------------
	--colisao iniciar e parar
	--------------------------------------------
 	local function gameOver()
 		Runtime:removeEventListener("touch", playerJump)  
		player:pause()  

 
		local function nowEnd()
			if menuShown == false then
				menuShown = true
				gameIsActive = false

				-- melhor pontuacao e distancia
				local newDistance = mF((distance*0.3)+(levelSpeed*0.5))
				local highScore, highDistance = 0, 0
				local dbPath = system.pathForFile("levelScores.db3", system.DocumentsDirectory)
				local db = sqlite3.open( dbPath )	
				for row in db:nrows("SELECT * FROM scores WHERE id = 1") do
					highScore = tonumber(row.highscore)
					highDistance = tonumber(row.distance)
				end
				
				 
				if score > highScore then
					highScore = score
					local update = "UPDATE scores SET highscore ='"..score.."' WHERE id = 1"
					db:exec(update)
				end
				if newDistance > highDistance then 
					highDistance = newDistance
					local update = "UPDATE scores SET distance ='"..newDistance.."' WHERE id = 1"
					db:exec(update)
				end
				db:close()

				-- reiniciar
				local gameOverGroup = display.newGroup()
				screenGroup:insert(gameOverGroup)

				local menu
				local function restartGame()
					 
					menu:removeEventListener("tap", restartGame)

		 
					local function resetVars()
						display.remove(gameOverGroup); gameOverGroup = nil
						distChange, distChange2 = 0, 0
						distance, score = 0, 0
						levelSpeed = 8
						
						menuShown, gameOverCalled = false, false
						createGame()
						gameIsActive = true
					end
					local trans = transition.to(gameOverGroup, {time=600, y=0, onComplete=resetVars})
				end
				menu = display.newImageRect(gameOverGroup, "images/gameOver.jpg",480, 260)
				menu.x = _W*0.5; menu.y = _H+130
				menu:addEventListener("tap", restartGame)

				local text1 = display.newText(gameOverGroup, "Pontuação: "..score,0,0,native.sytemFontBold,17)
				text1.anchorX = 1
				text1.anchorY = 0.5
				--text1:setReferencePoint(display.CenterRightReferencePoint)
				text1.x = _W*0.36; text1.y = menu.y; text1:setFillColor(0)
				local text2 = display.newText(gameOverGroup, "HighScore: "..highScore,0,0,native.sytemFontBold,17)
				text2.anchorX = 1
				text2.anchorY = 0.5
				--text2:setReferencePoint(display.CenterLeftReferencePoint)
				text2.x = _W*0.36; text2.y = text1.y + 62;  text2:setFillColor(0)

				local text3 = display.newText(gameOverGroup, "Distância: "..newDistance,0,0,native.sytemFont,17)
				text3.anchorX = 1
				text3.anchorY = 0.5
				--text3:setReferencePoint(display.CenterRightReferencePoint)
				text3.x = _W*0.36; text3.y = text1.y+32; text3:setFillColor(0)
				
				
 				local trans = transition.to(gameOverGroup, {time=600, y=-260})
			end
		end
		player:setLinearVelocity( 0, 0 )
		player:applyForce(0,-4, player.x, player.y)
		local trans = transition.to(player, {time=1000, rotation=90, onComplete=nowEnd})
	end

 	function onCollision(event)
		if event.phase == "began" and gameIsActive == true and gameOverCalled == false then
			local name1 = event.object1.name
			local name2 = event.object2.name 


			if name1 == "player" or name2 == "player" then 
				--Hit the floor, reset vars
				if name1 == "floor" or name2 == "floor" or name1 == "platform" or name2 == "platform" then
					singleJump, doubleJump = false, false
					player:setSequence("run")
					player:play()

				--Picking up bones and powerups...
				elseif name1 == "shoes" or name2 == "shoes" then
					if name1 == "shoes" then display.remove(event.object1); event.object1 = nil; 
					else display.remove(event.object2); event.object2 = nil; end
					changeText(1)
					shoesChannel = audio.play(sapatosSound)

				

				end
			end
		end
	end



	
	gameIsActive = true
	Runtime:addEventListener("enterFrame",gameLoop)
	Runtime:addEventListener("collision",onCollision)
end



function scene:exitScene( event )
	print( "GAME: exitScene event" )

	 
	gameIsActive = false
	Runtime:removeEventListener("touch",playerJump)
	Runtime:removeEventListener("enterFrame",gameLoop)
	Runtime:removeEventListener( "collision", onCollision )

	 
	audio.stop(overChannel)
	audio.stop(shoesChannel)
	audio.stop(jumpChannel)
end


 
function scene:destroyScene( event )
	print( "GAME: destroying view" )

	 
	audio.dispose(overSound); overSound=nil
	audio.dispose(sapatosSound); sapatosSound=nil
	audio.dispose(jumpSound); jumpSound=nil
end



 
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )




return scene

