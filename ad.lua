-- requires 


local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local mydata = require( "mydata" )
local score = require( "score" )

----------------------------------
----------------------------------
-- ----AD-------------------------
-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- The name of the ad provider.
local provider = "admob"

-- Your application ID
local appID = "ca-app-pub-4047264809121768/6483277533"

-- Load Corona 'ads' library
local ads = require "ads"

--------------------------------------------------------------------------------
-- Setup ad provider
--------------------------------------------------------------------------------

-- Create a text object to display ad status
local statusText = display.newText( "", 0, 0, native.systemFontBold, 22 )
statusText:setFillColor( 255 )
-- statusText:setReferencePoint( display.CenterReferencePoint )
statusText.x, statusText.y = display.contentWidth * 0.5, 160

local showAd

-- Set up ad listener.
local function adListener( event )
	-- event table includes:
	-- 		event.provider
	--		event.isError (e.g. true/false )
	
	local msg = event.response

	-- just a quick debug message to check what response we got from the library
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

-- Initialize the 'ads' library with the provider you wish to use.
if appID then
	ads.init( provider, appID, adListener )
end

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------

-- initial variables
local sysModel = system.getInfo("model")
local sysEnv = system.getInfo("environment")

statusText:toFront()

-- Shows a specific type of ad
showAd = function( adType )
	local adX, adY = display.screenOriginX, display.screenOriginY
	statusText.text = ""
	ads.show( adType, { x=adX, y=adY } )
end

-- if on simulator, let user know they must build for device
if sysEnv == "simulator" then
	local font, size = native.systemFontBold, 22
	local warningText = display.newText( "Please build for device or Xcode simulator to test this sample.", 0, 0, 290, 300, font, size )
	warningText:setFillColor( 255 )
	-- warningText:setReferencePoint( display.CenterReferencePoint )
	warningText.x, warningText.y = display.contentWidth * 0.5, display.contentHeight * 0.5
else
	-- start with banner ad
	showAd( "interstitial" )
end



-- ----AD-------------------------
----------------------------------
----------------------------------

-- background

function restartGame(event)
     if event.phase == "ended" then
		saveScore()
		storyboard.gotoScene("start")
     end
end

function showStart()
	startTransition = transition.to(restart,{time=200, alpha=1})
	scoreTextTransition = transition.to(scoreText,{time=600, alpha=1})
	scoreTextTransition = transition.to(bestText,{time=600, alpha=1})
end

function showScore()
	scoreTransition = transition.to(scoreBg,{time=600, y=display.contentCenterY,onComplete=showStart})
	
end

function showGameOver()
	fadeTransition = transition.to(gameOver,{time=600, alpha=1,onComplete=showScore})
end

function loadScore()
	local prevScore = score.load()
	if prevScore ~= nil then
		if prevScore <= mydata.score then
			score.set(mydata.score)
		else 
			score.set(prevScore)	
		end
	else 
		score.set(mydata.score)	
		score.save()
	end
end

function saveScore()
	score.save()
end

function scene:createScene(event)

	local screenGroup = self.view
	background = display.newImageRect("bg.png",900,1425)
	background.anchorX = 0.5
	background.anchorY = 1
	background.x = display.contentCenterX
	background.y = display.contentHeight
	screenGroup:insert(background)
	-- background = display.newImageRect("bg.png",900,1425)
	-- background.anchorX = 0.5
	-- background.anchorY = 0.5
	-- background.x = display.contentCenterX
	-- background.y = display.contentCenterY
	-- screenGroup:insert(background)
	
	gameOver = display.newImageRect("gameOver.png",500,100)
	gameOver.anchorX = 0.5
	gameOver.anchorY = 0.5
	gameOver.x = display.contentCenterX 
	gameOver.y = display.contentCenterY - 300
	gameOver.alpha = 0
	screenGroup:insert(gameOver)
	
	scoreBg = display.newImageRect("menuBg.png",480,393)
	scoreBg.anchorX = 0.5
	scoreBg.anchorY = 0.5
    scoreBg.x = display.contentCenterX
    scoreBg.y = display.contentHeight + 500
    screenGroup:insert(scoreBg)
	
	restart = display.newImageRect("start_btn.png",300,65)
	restart.anchorX = 0.5
	restart.anchorY = 1
	restart.x = display.contentCenterX
	restart.y = display.contentCenterY + 400
	restart.alpha = 0
	screenGroup:insert(restart)
	
	scoreText = display.newText(mydata.score,display.contentCenterX + 110,
	display.contentCenterY - 60, native.systemFont, 50)
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0 
	screenGroup:insert(scoreText)
		
	bestText = score.init({
	fontSize = 50,
	font = "Helvetica",
	x = display.contentCenterX + 70,
	y = display.contentCenterY + 85,
	maxDigits = 7,
	leadingZeros = false,
	filename = "scorefile.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText:setFillColor(0,0,0)
	screenGroup:insert(bestText)
	
end

function scene:enterScene(event)
	storyboard.removeScene("game")
	restart:addEventListener("touch", restartGame)
	showGameOver()
	loadScore()
end

function scene:exitScene(event)
	restart:removeEventListener("touch", restartGame)
	transition.cancel(fadeTransition)
	transition.cancel(scoreTransition)
	transition.cancel(scoreTextTransition)
	transition.cancel(startTransition)
end

function scene:destroyScene(event)

end


scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene