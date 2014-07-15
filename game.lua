local physics = require "physics"
-- local rotation = require ("rotationfix")
physics.start()
physics.setGravity( 0, 0 )

local mydata = require( "mydata" )
local storyboard = require ("storyboard")
local scene = storyboard.newScene()

local introNr

mydata.score = 0

level = 1

pickupSound = audio.loadSound("pickup.wav")
deadSound = audio.loadSound("dead.wav")


mydata.coins = 0

function intro()

	introNr = introNr-1
	if introNr<0 then
	
	introNr:removeSelf()
	introNr=nil
	start()
	end

	end	

function scene:createScene(event)

	-- physics.setDrawMode("hybrid")
	local screenGroup = self.view

    bg = display.newImage('bg3.png')
	bg.anchorX = 0.5
	bg.anchorY = 1
	bg.x = display.contentWidth * 0.5
	bg.y = display.contentHeight -165
	bg.speed = 4
	screenGroup:insert(bg)
    
    elements = display.newGroup()
	elements.anchorChildren = true
	elements.anchorX = 0
	elements.anchorY = 1
	elements.x = 0
	elements.y = 0
	screenGroup:insert(elements)

	ground = display.newImageRect('ground.png',900,162)
	ground.anchorX = 0
	ground.anchorY = 1
	ground.x = 0
	ground.y = display.contentHeight
	screenGroup:insert(ground)

	platform = display.newImageRect('platform.png',900,53)
	platform.anchorX = 0
	platform.anchorY = 1
	platform.x = 0
	platform.y = display.viewableContentHeight - 110
	physics.addBody(platform, "static", {density=.1, bounce=0.1, friction=.2})
	platform.speed = 4
	screenGroup:insert(platform)
	
	platform2 = display.newImageRect('platform.png',900,53)
	platform2.anchorX = 0
	platform2.anchorY = 1
	platform2.x = platform2.width
	platform2.y = display.viewableContentHeight - 110
	physics.addBody(platform2, "static", {density=.1, bounce=0.1, friction=.2})
	platform2.speed = 4
	screenGroup:insert(platform2)
	
	pointRect = display.newRect( 0, 0, display.contentWidth, 160 )
	pointRect.anchorX = 0
	pointRect.alpha = 0.2
	pointRect:setFillColor(0.84,0.33,0.03)
	screenGroup:insert(pointRect)
	
	pointVase = display.newImage('pointVase.png')
	pointVase.anchorX = 0
	pointVase.anchorY = 0
	pointVase.x = display.contentCenterX + 200
	pointVase.y = 10
	screenGroup:insert(pointVase)
	
	pointCol = display.newImage('pointCol.png')
	pointCol.anchorX = 0
	pointCol.anchorY = 0
	pointCol.x = display.contentCenterX - 350
	pointCol.y = 10
	screenGroup:insert(pointCol)
	
	
	if "Win" == system.getInfo( "platformName" ) then
    DIOGENES = "Diogenes Regular"
	elseif "Android" == system.getInfo( "platformName" ) then
    DIOGENES = "DIOGENES"
	end
	
	levelTextX = display.newText("x",pointCol.x + 90, 5, "DIOGENES", 58)
	levelTextX:setFillColor(255,255,255)
	levelTextX.alpha = 1
	levelTextX.anchorX = 0
	levelTextX.anchorY = 0
	screenGroup:insert(levelTextX)
	
	levelText = display.newText(level*10,pointCol.x + 130, 5, "DIOGENES", 58)
	levelText:setFillColor(255,255,255)
	levelText.alpha = 1
	levelText.anchorX = 0
	levelText.anchorY = 0
	screenGroup:insert(levelText)
	
	levelNr = display.newText(level,740, 5, "DIOGENES", 58)
	levelNr:setFillColor(255,255,255)
	levelNr.alpha = 0
	levelNr.anchorX = 0
	levelNr.anchorY = 0
	screenGroup:insert(levelNr)
	
	coinsNr = display.newText(mydata.score, pointVase.x+75, 5, "DIOGENES", 58)
	coinsNr:setFillColor(255,255,255)
	coinsNr.alpha = 1
	coinsNr.anchorX = 0
	coinsNr.anchorY = 0
	screenGroup:insert(coinsNr)
	
	p_options = 
	{
		-- Required params
		width = 99,
		height = 81,
		numFrames = 2,
		-- content scaling
		sheetContentWidth = 198,
		sheetContentHeight = 81,
	}

	playerSheet = graphics.newImageSheet( "bird.png", p_options )
	player = display.newSprite( playerSheet, { name="player", start=1, count=2, time=1500 } )
	player.anchorX = 0.5
	player.anchorY = 0.5
	player.x = display.contentCenterX - 450
	player.y = display.contentCenterY
	local physicsData = (require "player").physicsData(scaleFactor)
	
	-- physics.addBody(player, "static", {density=10, bounce=0, friction=0})
	physics.addBody(player, "static", physicsData:get("single_bird") )
	player.isFixedRotation = true
	player:applyForce(0, -300, player.x, player.y)
	player:play()
	screenGroup:insert(player)
	
	scoreText = display.newText(mydata.score,display.contentCenterX,
	150, "DIOGENES", 58)
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0
	screenGroup:insert(scoreText)
	
	introTransition = transition.to(player,{time=2500, x = display.contentCenterX - 170, onComplete = start})
	
	introNr = 3
	
	--introText = display.newText(introNr,display.contentCenterX,500, "DIOGENES", 58)
	--scoreText:setFillColor(0,0,0)
	
	--timer.performWithDelay(1000, intro, 3)
	
end

function eltolodas()

	local vx, vy = player:getLinearVelocity()
	print("madar sebesseg", vx, vy)
	if player.x ~= display.contentCenterX - 170 then 
	player:setLinearVelocity(0, vy)
	player.x = display.contentCenterX - 170
	player.y = aktH
	print("madar sebesseg", vx, vy)
	end
end	

function onCornCollision( self, event )

	-- body
	if ( event.phase == "began" ) then
		if mydata.sound == true then
		pickup = audio.play(pickupSound, {channel=1})
		end

		mydata.coins = mydata.coins + level * 30
		coinsNr.text = mydata.coins
		
		self:removeSelf()
		self.object2 = nil
		
		aktH = player.y

		eltolodasEllenorzes = timer.performWithDelay( 1, eltolodas, 1 )
	end
	
end

function onCollision( self, event )
	if ( event.phase == "began" ) then
	if mydata.sound == true then
		dead = audio.play(deadSound, {channel=2})
		end
		storyboard.gotoScene( "ad" )
		-- print(event.object2.tag.."   ____collision with")
		-- if (event.object2.tag == "corn") then
		-- 	event.object2:removeSelf()
		-- 	event.object2 = nil
		-- 	-- event.object2.alpha = 0
		-- elseif (event.object1.tag == "corn") then
		-- 	event.object1:removeSelf()
		-- 	event.object1 = nil
		-- 	-- event.object2.alpha = 0
		-- else
		-- 	storyboard.gotoScene( "ad" )
		-- 	-- storyboard.gotoScene( "restart" )	
		-- 	-- storyboard.gotoScene( "displayAd" )
		-- end
	end

end

function platformScroller(self,event)
	
	if self.x < (-900 + (self.speed*2)) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
	
end

function getNextHeight()

	local nextY = math.random(player.y - 50, player.y + 50)
	if (nextY > 40 and nextY < display.viewableContentHeight - 200) then
	 	return nextY
	else
		nextY = getNextHeight()
	end
	
end

local gameStarted = false
local nextHeight = getNextHeight()

function displayAd()

	display.setStatusBar( display.HiddenStatusBar )
	local provider = "admob"
	local appID = "ca-app-pub-4047264809121768/2045757936"
	local ads = require "ads"
	local statusText = display.newText( "", 0, 0, native.systemFontBold, 22 )
	statusText:setFillColor( 255 )
	statusText.x, statusText.y = display.contentWidth * 0.5, 160
	local showAd
	local function adListener( event )
		local msg = event.response
		print("Message received from the ads library: ", msg)

		if event.isError then
			statusText:setFillColor( 255, 0, 0 )
			statusText.text = "Error Loading Ad"
			statusText.x = display.contentWidth * 0.5
			showAd( "banner" )
		else
			statusText:setFillColor( 0, 255, 0 )
			statusText.text = "Successfully Loaded Ad"
			statusText.x = display.contentWidth * 0.5
		end
	end

	if appID then
		ads.init( provider, appID )
	end

	local sysModel = system.getInfo("model")
	local sysEnv = system.getInfo("environment")

	statusText:toFront()

	showAd = function( adType )
		local adX, adY = display.screenOriginX, display.contentHeight - 120
		statusText.text = ""
		ads.show( adType, { x=adX, y=adY } )
	end

	if sysEnv == "simulator" then
		-- local font, size = native.systemFontBold, 22
		-- local warningText = display.newText( "Please build for device or Xcode simulator to test this sample.", 0, 0, 290, 300, font, size )
		-- warningText:setFillColor( 255 )
		-- -- warningText:setReferencePoint( display.CenterReferencePoint )
		-- warningText.x, warningText.y = display.contentWidth * 0.5, display.contentHeight * 0.5
	else
		-- start with banner ad
		-- showAd( "interstitial" )
		showAd( "banner" )
	end

end
---------------------------------------------------------------PAUSE----------------------------------------------------------
function pause()

		transition.pause()
		timer.pause(moveColumnTimer)
		timer.pause(flyTheBirdTimer)
		physics.pause()
		
end		

function resume()

		transition.resume()
		timer.resume(moveColumnTimer)
		timer.resume(flyTheBirdTimer)
		physics.start()
end
		
function pauseGame(event)

   local phase = event.phase
   local keyName = event.keyName
   if ( "back" == keyName and phase == "up" ) then
   local function onComplete( event )
			if "clicked" == event.action then
				if paused == true then
				paused = false
				resume()
				end
				local i = event.index
				if 1 == i then
					native.cancelAlert( alert )
					
				elseif 2 == i then
					native.requestExit()
				end
			end
		end
		if paused == false then
		paused = true
		pause()
		else
		paused = false
		resume()
		end
		local alert = native.showAlert( "PAUSE", "ARE YOU READY TO CONTINUE?", { "CONTINUE", "EXIT" }, onComplete )
		group:insert(alert);
		return true
   end
   return false  --SEE NOTE BELOW
end 
-------------------------------------------------------------------------------------------------------
function start(event)
   
		if (gameStarted == false) then

			if (mydata.bannerShowed == false) then
				displayAd()
				mydata.bannerShowed = true
			end

			if (mydata.bannerShowed == false) then
				displayAd()
				mydata.bannerShowed = true
			end

			paused = false
			Runtime:addEventListener( "key", pauseGame )
			player.bodyType = "dynamic"
			scoreText.alpha = 1
			addColumns()
			moveColumnTimer = timer.performWithDelay(1, moveColumns, -1)

		 	flyTheBirdTimer = timer.performWithDelay(100, flyTheBird, -1)
			gameStarted = true
			
			--player:applyForce(0, -300, player.x, player.y)
		end

end

function flyTheBird()

		if (player.y < nextHeight - 20) then 
			player:applyForce(0, 200, player.x, player.y)
		elseif (player.y > nextHeight + 20 ) then 
			player:applyForce(0, -200, player.x, player.y)
		else 
			nextHeight = getNextHeight()
		end
		
end

local distanceHelper = 170

function moveColumns()

		local physicsData = (require "columns").physicsData(scaleFactor)

		for a = elements.numChildren,1,-1  do
			elements[a]:addEventListener( "touch", doTouch )
			-- elements[a].tag ='column'
			-- elements[a]:addEventListener("touch", addDragMove)
			
			if(elements[a].x < display.contentCenterX - 170) then
			
				if elements[a].scoreAdded == false then
					if elements[a].type == "column" then
					mydata.score = mydata.score + level*10
					scoreText.text = mydata.score
					--if mydata.score == 2 then
					level = level + 1
					levelNr.text=level
					levelText.text = level *10
					--print(level)
					--end
					end
					elements[a].scoreAdded = true
				end
			end
			--[[if(elements[a].x < display.contentCenterX - distanceHelper) then

				if (elements[a].newColumnCreated == false) then
					if ((mydata.score % 2 == 0) and (distanceHelper > 50)) then
						-- distanceHelper = distanceHelper - 50
					end
					addColumns()
					elements[a].newColumnCreated = true
				end
			end

			
			if(elements[a].x < display.contentCenterX - 170) then
				if (elements[a].added == false) then
					elements[a].added = true
				end		
			end]]--
			
			if(elements[a].x > -100) then

					elements[a].x = elements[a].x - (3 + 1* level)
			else 
				
				--if (elements[a].newColumnCreated == false) then
					elements[a].x = display.contentWidth + 500
					if elements[a].tag == "column" then
						elements[a].y = height
						
					elseif elements[a].tag == "bottomColumn" then
						elements[a].y = platform.y - 150
						
						if corn.x == nil then
						corn = display.newImage('corn.png')
						corn.anchorX = 0.5
						corn.anchorY = 0.5
						corn.scale=2
						corn.x = specialColumn.x
						corn.y = specialColumn.y - 80
						corn.tag = 'corn'
						corn.type = 'extra'
						corn.collision = onCornCollision
						corn:addEventListener( "collision", corn )
						physics.addBody( corn, "static", physicsData:get("corn") )
						
						--physics.addBody( corn, "static", {density = 2, friction = 0, bounce = 0} ) --physicsData:get("corn")
						elements:insert(corn)
						end
					elseif elements[a].tag == "corn" then
						elements[a].alpha = 1
					end
					elements[a].newColumnCreated = true
					elements[a].scoreAdded = false
			--	end
			
			end
			--[[	-- print(elements[a].tag.."________-")
				elements[a]:removeEventListener("touch", addDragMove)
				elements[a]:removeEventListener("collision", elements[a])
				elements[a]:removeEventListener("touch", doTouch)
				elements:remove(elements[a])
				--elements[a]:removeSelf()
			 	--elements[a] = nil]]--
			end	
		
end

function addDragMove(event)
	local canMoveIt = true
	if event.phase == "began" then
		if ((event.target.tag == "column") or (event.target.tag == "bottomColumn")) then
		    event.target.markY = event.y	
		    event.target.goodTouch = true
		end
	-- return false
	
	elseif event.phase == "moved" then
		if ((event.target.tag == "column") or (event.target.tag == "bottomColumn")) and (event.target.goodTouch == true)then
			if (event.target.y > display.contentHeight - 163) then	
				event.target.y = display.contentHeight - 163
				if (event.target.type == "extra") then
					if (corn.isVisible ) then
						corn.y = display.contentHeight - 163 - 120
					end
					
				end
			elseif (event.target.y < 80) then 
				event.target.y = 80 
			else--if (event.y <= display.contentHeight - 180) then
				local y = (event.y - event.target.markY)
				event.target.y = event.target.y + y
				event.target.markY = event.y
				if (event.target.type == "extra") then
					if (corn.isVisible ) then
						corn.y = corn.y + y
					end
					
				end
					
			end
		end
	end
	return true

end
--regi mozgatas function addDragMove(event)

 --[[	if event.phase == "began" then
 		if (event.target.tag ~= "corn") then
 		    event.target.markY = event.y	
 		    event.target.goodTouch = true
 		end
 	-- return false
 	elseif event.phase == "moved" then
 		if (event.target.tag ~= "corn") and (event.target.goodTouch == true)then
 			if (event.target.y > display.contentHeight - 260) then	
 				event.target.y = display.contentHeight - 260
 				if (event.target.type == "extra") then
 					if (corn.isVisible ) then
 						corn.y = display.contentHeight - 163 - 120
 					end
 					--if (corn2.isVisible ) then
 					--	corn2.y = display.contentHeight - 163 - 120
 					--end
 				end
 			elseif (event.target.y < 80) then 
 				event.target.y = 80
 			elseif (event.y <= display.contentHeight - 180) then
 				local y = (event.y - event.target.markY)
 --				print(y)
 				event.target.y = event.target.y + y
 				event.target.markY = event.y
 				if (event.target.type == "extra") then
 					if (corn.isVisible ) then
 						corn.y = corn.y + y
 					end
 					--if corn2 ~= nil then
		
 					--	if (corn2.isVisible ) then
 					--		corn2.y = corn2.y + y
 					--	end	
 					--end
 				end
				
 			end
 		end
 	end
 	return true

 end]]--



function doTouch( event )

    if ( event.phase == "began" ) then      
        event.target.alpha = 1
        display.getCurrentStage():setFocus( event.target )
    elseif event.phase == "ended" or event.phase == "cancelled" then
        event.target.alpha = 1
        display.getCurrentStage():setFocus(nil)
    end
	
end

function testListener(event, obj)

		if (event.phase == 'began') then
			print('in')
		end
		
	end
	
function addColumns()
	
	height = 600
	local physicsData = (require "columns").physicsData(scaleFactor)
	
		column = display.newImage('greekColumn.png')
		physics.addBody( column, "kinematic", physicsData:get("greekColumn") )
		column.anchorX = 0.5
		column.anchorY = 0.5
		column.x = display.contentWidth + 100
		column.y = height
		column.tag = 'column'
		column.type = 'column'
		column.added = false
		column.scoreAdded = false
		column.newColumnCreated = false
		column.collision = onCollision
		column:addEventListener( "collision", column )
		column:addEventListener("touch", addDragMove)
		elements:insert(column)

		column2 = display.newImage('greekColumn2.png')
		physics.addBody( column2, "kinematic", physicsData:get("greekColumn2") )
		column2.anchorX = 0.5
		column2.anchorY = 0.5
		column2.x = display.contentWidth + 800
		column2.y = height
		column2.tag = 'column'
		column2.type = 'column'
		column2.added = false
		column2.scoreAdded = false
		column2.newColumnCreated = false
		column2.collision = onCollision
		column2:addEventListener( "collision", column2 )
		column2:addEventListener("touch", addDragMove)
		elements:insert(column2)

		specialColumn = display.newImage('bottomColumn.png')
		specialColumn.type = 'extra'
		specialColumn.anchorX = 0.5
		specialColumn.anchorY = 0
		specialColumn.x = display.contentWidth + 450
		specialColumn.y = platform.y - 150
		specialColumn.tag = 'bottomColumn'
		specialColumn.scoreAdded = false
		specialColumn.collision = onCollision
		specialColumn:addEventListener( "collision", specialColumn )
		corn = display.newImage('corn.png')
		corn.anchorX = 0.5
		corn.anchorY = 0.5
		corn.scale=2
		corn.x = specialColumn.x
		corn.y = specialColumn.y - 80
		corn.tag = 'corn'
		corn.type = 'extra'
		corn.collision = onCornCollision
		corn:addEventListener( "collision", corn )
		specialColumn.scoreAdded = false
		physics.addBody( specialColumn, "kinematic", physicsData:get("bottomColumn") )
		physics.addBody( corn, "static", physicsData:get("corn") )--{density = 2, friction = 0, bounce = 0} ) --physicsData:get("corn")
		specialColumn:addEventListener("touch", addDragMove)
		elements:insert(specialColumn)
		elements:insert(corn)

	--[[	specialColumn2 = display.newImage('topColumn.png')
		specialColumn2.type = 'extra'
		specialColumn2.anchorX = 0.5
		specialColumn2.anchorY = 1
		specialColumn2.x = display.contentWidth + 1150
		specialColumn2.y = 360
		specialColumn2.tag = 'topColumn'
		specialColumn2.scoreAdded = false
		specialColumn2.collision = onCollision
		specialColumn2:addEventListener( "collision", specialColumn2 )
		corn2 = display.newImage('corn.png')
		corn2.anchorX = 0.5
		corn2.anchorY = 0.5
		corn2.x = specialColumn2.x
		corn2.y = specialColumn2.y + 120
		corn2.tag = 'corn'
		corn2.type = 'extra'
		corn2.collision = onCornCollision
		corn2:addEventListener( "collision", corn2 )
		specialColumn2.scoreAdded = false
		physics.addBody( specialColumn2, "kinematic", physicsData:get("bottomColumn") )
		physics.addBody( corn2, "static", {density = 2, friction = 0, bounce = 0} ) --physicsData:get("corn")
		specialColumn2:addEventListener("touch", addDragMove)
		elements:insert(specialColumn2)
		elements:insert(corn2)]]--
		
end	

local function checkMemory()

   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )

end


function scene:enterScene(event)

	collectgarbage( "collect" )
	collectgarbage( "restart" )
	storyboard.removeScene("start")
	--bg:addEventListener("touch", start)
	
	platform.enterFrame = platformScroller
	Runtime:addEventListener("enterFrame", platform)

	platform2.enterFrame = platformScroller
	Runtime:addEventListener("enterFrame", platform2)
    
    -- Runtime:addEventListener("collision", onCollision)
	memTimer = timer.performWithDelay( 1000, checkMemory, 0 )

end

function scene:exitScene(event)

	for a = elements.numChildren,1,-1  do
		elements[a]:removeEventListener("collision", elements[a])
	end
	--bg:removeEventListener("touch", start)
	Runtime:removeEventListener("enterFrame", platform)
	Runtime:removeEventListener("enterFrame", platform2)
	-- Runtime:removeEventListener("collision", onCollision)
	timer.cancel(flyTheBirdTimer)
	timer.cancel(moveColumnTimer)
	timer.cancel(memTimer)
	
end

function scene:destroyScene(checkMemory)

end


scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene