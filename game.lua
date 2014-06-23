local physics = require "physics"
-- local rotation = require ("rotationfix")
physics.start()
physics.setGravity( 0, 0 )

local mydata = require( "mydata" )
local storyboard = require ("storyboard")
local scene = storyboard.newScene()

mydata.score = 0

level = 1

pickupSound = audio.loadSound("pickup.wav")
deadSound = audio.loadSound("dead.wav")


mydata.coins = 0

function scene:createScene(event)

	physics.setDrawMode("hybrid")
	local screenGroup = self.view

    bg = display.newImageRect('bg2.png',1200,1425)
	bg.anchorX = 0
	bg.anchorY = 1
	bg.x = 0
	bg.y = display.contentHeight
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
	
	coinsIcon = display.newImageRect('coins.png',50,50)
	coinsIcon.anchorX = 0
	coinsIcon.anchorY = 0
	coinsIcon.x = 10
	coinsIcon.y = 10
	
	levelText = display.newText("LEVEL:",500, 5, "Arial", 58)
	levelText:setFillColor(0,0,0)
	levelText.alpha = 1
	levelText.anchorX = 0
	levelText.anchorY = 0
	screenGroup:insert(levelText)
	
	levelNr = display.newText(level,740, 5, "Arial", 58)
	levelNr:setFillColor(0,0,0)
	levelNr.alpha = 1
	levelNr.anchorX = 0
	levelNr.anchorY = 0
	screenGroup:insert(levelNr)
	
	coinsNr = display.newText(mydata.score,70, 5, "Arial", 58)
	coinsNr:setFillColor(0,0,0)
	coinsNr.alpha = 1
	coinsNr.anchorX = 0
	coinsNr.anchorY = 0
	screenGroup:insert(coinsNr)
	screenGroup:insert(coinsIcon)
	
	p_options = 
	{
		-- Required params
		width = 80,
		height = 42,
		numFrames = 2,
		-- content scaling
		sheetContentWidth = 160,
		sheetContentHeight = 42,
	}

	playerSheet = graphics.newImageSheet( "bat.png", p_options )
	player = display.newSprite( playerSheet, { name="player", start=1, count=2, time=500 } )
	player.anchorX = 0.5
	player.anchorY = 0.5
	player.x = display.contentCenterX - 150
	player.y = display.contentCenterY
	
	physics.addBody(player, "static", {density=10, bounce=0, friction=0})
	player.isFixedRotation = true
	player:applyForce(0, -300, player.x, player.y)
	player:play()
	screenGroup:insert(player)
	
	scoreText = display.newText(mydata.score,display.contentCenterX,
	150, "Arial", 58)
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0
	screenGroup:insert(scoreText)
	
	instructions = display.newImageRect("instructions.png",400,328)
	instructions.anchorX = 0.5
	instructions.anchorY = 0.5
	instructions.x = display.contentCenterX
	instructions.y = display.contentCenterY
	screenGroup:insert(instructions)
	
end

function onCornCollision( self, event )

	-- body
	if ( event.phase == "began" ) then
		if mydata.sound == true then
		pickup = audio.play(pickupSound, {channel=1})
		end

		mydata.coins = mydata.coins + 50
		coinsNr.text = mydata.coins

		self:removeSelf()
		self.object2 = nil
	end
	
end

function onCollision( self, event )
	if ( event.phase == "began" ) then
	if mydata.sound == true then
		dead = audio.play(deadSound, {channel=1})
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

			-- if (mydata.bannerShowed == false) then
			-- 	displayAd()
			-- 	mydata.bannerShowed = true
			-- end

			if (mydata.bannerShowed == false) then
				displayAd()
				mydata.bannerShowed = true
			end

			paused = false
			Runtime:addEventListener( "key", pauseGame )
			player.bodyType = "dynamic"
			instructions.alpha = 0
			scoreText.alpha = 1
			addColumns()
			moveColumnTimer = timer.performWithDelay(2, moveColumns, -1)

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

		for a = elements.numChildren,1,-1  do
			elements[a]:addEventListener( "touch", doTouch )
			-- elements[a].tag ='column'
			-- elements[a]:addEventListener("touch", addDragMove)
			if(elements[a].x < display.contentCenterX - 170) then
				if elements[a].scoreAdded == false then
					if elements[a].type == "column" then
					mydata.score = mydata.score + 1
					scoreText.text = mydata.score
					if mydata.score == 2 then
					level = level + 1
					levelNr.text=level
					print(level)
					end
					end
					elements[a].scoreAdded = true
				end
			end
			if(elements[a].x < display.contentCenterX - distanceHelper) then

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
			end
			
			if(elements[a].x > -100) then
				
					elements[a].x = elements[a].x - (3 + 2* level)
			else 
				-- print(elements[a].tag.."________-")
				elements[a]:removeEventListener("touch", addDragMove)
				elements[a]:removeEventListener("collision", elements[a])
				elements[a]:removeEventListener("touch", doTouch)
				elements[a]:removeSelf()
				elements[a] = nil
				-- elements:remove(elements[a])
			end	
		end	
		
end

function addDragMove(event)

	if event.phase == "began" then
		if (event.target.tag == "column") then
		    event.target.markY = event.y	
		    event.target.goodTouch = true
		end
	-- return false
	elseif event.phase == "moved" then
		if (event.target.tag == "column") and (event.target.goodTouch == true)then
			if (event.target.y > display.contentHeight - 163) then	
				event.target.y = display.contentHeight - 163
				if (event.target.type == "extra") then
					if (corn.isVisible ) then
						corn.y = display.contentHeight - 163 - 120
					end
				end
			elseif (event.target.y < 80) then 
				event.target.y = 80
			elseif (event.y <= display.contentHeight - 180) then	
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

function doTouch( event )

    if ( event.phase == "began" ) then      
        event.target.alpha = 0.7
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
	

	height = 500
	local physicsData = (require "column").physicsData(scaleFactor)
	if (mydata.score % 2 == 0) then
		column = display.newImageRect('greekColumn.png',124,1800)
		physics.addBody( column, "kinematic", physicsData:get("column") )
	else
		column = display.newImageRect('greekColumn2.png',71,1800)
		physics.addBody( column, "kinematic", physicsData:get("column") )
	end
	column.anchorX = 0.5
	column.anchorY = 0.5
	column.x = display.contentWidth + 100
	column.y = height - 160
	column.tag = 'column'
	column.type = 'column'
	column.added = false
	column.scoreAdded = false
	column.newColumnCreated = false
	column.collision = onCollision
	column:addEventListener( "collision", column )
	column:addEventListener("touch", addDragMove)
	elements:insert(column)
	
	if (mydata.score % 2 == 0) then
		specialColumn = display.newImageRect('bottomColumn.png',127,936)
		specialColumn.type = 'extra'
		specialColumn.anchorX = 0.5
		specialColumn.anchorY = 0
		specialColumn.x = display.contentWidth + 400
		specialColumn.y = height + 360
		specialColumn.tag = 'column'
		specialColumn.scoreAdded = false
		specialColumn.collision = onCollision
		specialColumn:addEventListener( "collision", specialColumn )
		corn = display.newImageRect('corn.png',70,75)
		corn.anchorX = 0.5
		corn.anchorY = 0.5
		corn.x = display.contentWidth + 400
		corn.y = height + 240
		corn.tag = 'corn'
		corn.type = 'extra'
		corn.collision = onCornCollision
		corn:addEventListener( "collision", corn )
		print(corn.tag..'__megvagyok')
		specialColumn.scoreAdded = false
		physics.addBody( specialColumn, "kinematic", physicsData:get("bottomColumn") )
		physics.addBody( corn, "static", {density = 2, friction = 0, bounce = 0} ) --physicsData:get("corn")
		specialColumn:addEventListener("touch", addDragMove)
		elements:insert(specialColumn)
		elements:insert(corn)
	end

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
	bg:addEventListener("touch", start)
	
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
	bg:removeEventListener("touch", start)
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