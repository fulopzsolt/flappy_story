-- requires 
local physics = require "physics"
physics.start()
local mydata = require( "mydata" )

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

local player2

-------------------------------------------------------------------------------------

function startGame(event)

     if event.phase == "ended" then
     	mydata.score = 0
		storyboard.gotoScene("game")
     end
	 
end

function groundScroller(self,event)
	
	if self.x < (-1529 + (self.speed*2)) then
		self.x = 1529
	else 
		self.x = self.x - self.speed
	end
	
end

function titleTransitionDown()

	downTransition = transition.to(titleGroup,{time=750, y=titleGroup.y+20,onComplete=titleTransitionUp})
	
end

function titleTransitionUp()

	upTransition = transition.to(titleGroup,{time=750, y=titleGroup.y-20, onComplete=titleTransitionDown})
	
end

function titleAnimation()

	titleTransitionDown()
	
end

-------------------------------------------------------------------------------------

function scene:createScene(event)

	local screenGroup = self.view
	
	--mydata.sound = false

	background = display.newImage("bg3.png")
	background.anchorX = 0.5
	background.anchorY = 1
	background.x = display.contentWidth * 0.5
	background.y = display.contentHeight - 165
	screenGroup:insert(background)
	
	mask = display.newImage("mask.png")
	mask.anchorX = 0.5
	mask.anchorY = 1
	mask.x = display.contentWidth * 0.5
	mask.y = display.contentHeight
	screenGroup:insert(mask)
	
	--[[tabla = display.newImageRect('table.png',600,780)
	tabla.anchorX = 0.5
	tabla.anchorY = 0.5
	tabla.x = display.contentCenterX
	tabla.y = display.contentCenterY+20
	screenGroup:insert(tabla)--]]
	
	title = display.newImageRect("title.png",500,100)
	title.anchorX = 0.5
	title.anchorY = 0.5
	title.x = display.contentCenterX - 80
	title.y = display.contentCenterY 
	screenGroup:insert(title)
	
	platform = display.newImageRect('platform.png',1529,53)
	platform.anchorX = 0
	platform.anchorY = 1
	platform.x = 0
	platform.y = display.viewableContentHeight - 110
	physics.addBody(platform, "static", {density=.1, bounce=0.1, friction=.2})
	platform.speed = 4
	screenGroup:insert(platform)

	platform2 = display.newImageRect('platform.png',1529,53)
	platform2.anchorX = 0
	platform2.anchorY = 1
	platform2.x = platform2.width
	platform2.y = display.viewableContentHeight - 110
	physics.addBody(platform2, "static", {density=.1, bounce=0.1, friction=.2})
	platform2.speed = 4
	screenGroup:insert(platform2)
	
	start = display.newImageRect("start_btn.png",320,180)
	start.anchorX = 0.5
	start.anchorY = 0.5
	start.x = display.contentCenterX
	start.y = background.y - 700
	screenGroup:insert(start)
	
	sound = display.newImageRect("sound_btn.png",320,180)
	sound.anchorX = 0.5
	sound.anchorY = 0.5
	sound.x = display.contentCenterX
	sound.y = start.y + 210
	screenGroup:insert(sound)
	
	negyzet = display.newImageRect("negyzet.png",40,40)
	negyzet.anchorX = 0.5
	negyzet.anchorY = 0.5
	negyzet.x = display.contentCenterX +200
	negyzet.y = sound.y + 10
	screenGroup:insert(negyzet)
	
	pipa = display.newImage("pipa.png")
	pipa.anchorX = 0.5
	pipa.anchorY = 0.5
	pipa.x = display.contentCenterX +205
	pipa.y = negyzet.y
	if mydata.sound == true then
	pipa.alpha = 1
	else
	pipa.alpha = 0
	end
	
	screenGroup:insert(pipa) 
	
	help = display.newImageRect("help_btn.png",320,180)
	help.anchorX = 0.5
	help.anchorY = 0.5
	help.x = display.contentCenterX
	help.y = sound.y + 210
	screenGroup:insert(help)
	
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
	player.x = display.contentCenterX + 240
	player.y = display.contentCenterY 
	player:scale(1.5,1.5)
	player:play()
	screenGroup:insert(player)
	
	titleGroup = display.newGroup()
	titleGroup.anchorChildren = true
	titleGroup.anchorX = 0.5
	titleGroup.anchorY = 0.5
	titleGroup.x = display.contentCenterX
	titleGroup.y = display.contentCenterY - 450
	titleGroup:insert(title)
	titleGroup:insert(player)
	screenGroup:insert(titleGroup)
	titleAnimation()

end

-----------------------------------------------HELP-------------------------------------------------------

function helpTransitionUp()

	helpUpTransition = transition.to(player2,{time=4000, y=player2.y-450, onComplete=helpTransitionDown})

end

function helpTransitionDown()
	
	helpDownTransition = transition.to(player2,{time=4000, y=player2.y+450, onComplete=helpTransitionUp})

	end

function helpAnimation()

	helpTransitionDown()

end

function helpHandColumn()

	hand.x = column2.x+10
	hand.y = column2.y+magassag

end

function helpRemove()

	animacioVege = true
	helpGroup:removeSelf()
	helpGroup = nil
	transition.cancel()

end

function helpEltunik()

	column2.alpha=0
	Runtime:removeEventListener("enterFrame",helpHandColumn)
	transition.to(helpGroup,{time=100, alpha = 0, onComplete=helpRemove})
	help:addEventListener("touch", helpWindow)

end

function helpFollowHeight()

	column2.y = player2.y
	if column2.x<player2.x-50 then
		Runtime:removeEventListener("enterFrame",helpFollowHeight)
		transition.to(hand,{time=550, alpha = 0})
		timer.performWithDelay( 1000, helpEltunik, 1 )
	end
	
end

function helpMeghivo()

	Runtime:addEventListener("enterFrame",helpFollowHeight)

end

function helpHand()

	if hand.x> column2.x+20 then
		HandTransition = transition.to(hand,{time=50, x=hand.x-15, y=hand.y-20, onComplete=helpHand})
	else if helpHC == false then
		helpHC = true
		magassag = hand.y-column2.y
		Runtime:addEventListener("enterFrame",helpHandColumn)
		ColumnTransition2 = transition.to(column2,{time=550, y=player2.y+50, onComplete=helpMeghivo})
	end	
	end
	
end	


function helpColumn()

	if (column2.x < display.contentCenterX+170) and (kezMeghivva == false) then
		kezMeghivva = true
		hand = display.newImage('hand.png')
		hand.anchorX = 0.5
		hand.anchorY = 0.5
		hand.x = display.contentWidth - 200
		hand.y =  display.contentHeight*0.5+80
		hand.alpha=0
		helpGroup:insert(hand)
		transition.to(hand,{time=150, alpha = 1})
		helpHC = false
		helpHand()
	end
	if column2.x> display.contentCenterX - 200 then
		ColumnTransition = transition.to(column2,{time=300, x=column2.x-30, onComplete=helpColumn})
	end	

end

function helpDemo()

	
	animacioVege=false
	
	p2_options = 
		{
			-- Required params
			width = 99,
			height = 81,
			numFrames = 2,
			-- content scaling
			sheetContentWidth = 198,
			sheetContentHeight = 81,
		}

	player2Sheet = graphics.newImageSheet( "bird.png", p2_options )
	player2 = display.newSprite( player2Sheet, { name="player2", start=1, count=2, time=500 } )
	player2.anchorX = 0.5
	player2.anchorY = 0.5
	player2.x = display.contentCenterX - 20
	player2.y = display.contentCenterY -150
	player2:play()
	helpGroup:insert(player2)
	helpAnimation()	
	kezMeghivva = false
	column2 = display.newImage('greekColumn2.png')
	column2.anchorX = 0.5
	column2.anchorY = 0.5
	column2:scale(0.7,0.7)

	column2.x = display.contentWidth - 230
	column2.y =  display.contentHeight - 550
	helpGroup:insert(column2)
	
	helpbg:toFront()
	platform:toFront()
	platform2:toFront()
	mask2:toFront()
	helpColumn()

end

function helpWindow()

	helpGroup = display.newGroup()
	help:removeEventListener("touch", helpWindow)
	helpbg= display.newImage("trimBg.png")
	helpbg.anchorX = 0.5
	helpbg.anchorY = 1
	--helpbg.alpha = 0
	helpbg.x = display.contentCenterX
	helpbg.y = background.y
	helpGroup:insert(helpbg)
	
	helpbg2= display.newImage("trimBg2.png")
	helpbg2.anchorX = 0.5
	helpbg2.anchorY = 1
	--helpbg.alpha = 0
	helpbg2.x = display.contentCenterX
	helpbg2.y = background.y - 96
	helpGroup:insert(helpbg2)
	
	mask2 = display.newImage("mask2.png")
	mask2.anchorX = 0.5
	mask2.anchorY = 1
	mask2.x = display.contentWidth * 0.5
	mask2.y = display.contentHeight
	helpGroup:insert(mask2)
	helpGroup.alpha = 0
	grow = transition.to(helpGroup,{time=700, alpha=1, onComplete= helpDemo})
	
end
---------------------------------------------------------------------------------------------

function soundOption(event)
 if event.phase == "began" then
 
	if mydata.sound == true then
		mydata.sound = false
		pipa.alpha = 0
	else 
		mydata.sound = true
		pipa.alpha = 1
	end
 end
end	

function scene:enterScene(event)

	storyboard.removeScene("ad")
	start:addEventListener("touch", startGame)
	help:addEventListener("touch", helpWindow)
	sound:addEventListener("touch", soundOption)
	platform.enterFrame = groundScroller
	Runtime:addEventListener("enterFrame", platform)
	platform2.enterFrame = groundScroller
	Runtime:addEventListener("enterFrame", platform2)

end

function scene:exitScene(event)

	start:removeEventListener("touch", startGame)
	sound:removeEventListener("touch", soundOption)
	Runtime:removeEventListener("enterFrame", platform)
	Runtime:removeEventListener("enterFrame", platform2)
	transition.cancel(downTransition)
	transition.cancel(upTransition)
	
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene













