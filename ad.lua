-- requires 


local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local mydata = require( "mydata" )
local score = require( "score" )

----------------------------------
----------------------------------
-- ----AD-------------------------
function displayAd()
	-- -- Hide the status bar
	-- display.setStatusBar( display.HiddenStatusBar )

	-- -- The name of the ad provider.
	-- local provider = "admob"

	-- -- Your application ID
	-- local appID = "ca-app-pub-4047264809121768/6483277533"

	-- -- Load Corona 'ads' library
	-- local ads = require "ads"

	-- --------------------------------------------------------------------------------
	-- -- Setup ad provider
	-- --------------------------------------------------------------------------------

	-- -- Create a text object to display ad status
	-- local statusText = display.newText( "", 0, 0, native.systemFontBold, 22 )
	-- statusText:setFillColor( 255 )
	-- -- statusText:setReferencePoint( display.CenterReferencePoint )
	-- statusText.x, statusText.y = display.contentWidth * 0.5, 160

	-- local showAd

	-- -- Set up ad listener.
	-- local function adListener( event )
	-- 	-- event table includes:
	-- 	-- 		event.provider
	-- 	--		event.isError (e.g. true/false )
		
	-- 	local msg = event.response

	-- 	-- just a quick debug message to check what response we got from the library
	-- 	print("Message received from the ads library: ", msg)

	-- 	if event.isError then
	-- 		statusText:setFillColor( 255, 0, 0 )
	-- 		statusText.text = "Error Loading Ad"
	-- 		statusText.x = display.contentWidth * 0.5

	-- 		showAd( "banner" )
	-- 	else
	-- 		statusText:setFillColor( 0, 255, 0 )
	-- 		statusText.text = "Successfully Loaded Ad"
	-- 		statusText.x = display.contentWidth * 0.5
	-- 	end
	-- end

	-- -- Initialize the 'ads' library with the provider you wish to use.
	-- if appID then
	-- 	ads.init( provider, appID )
	-- end

	-- --------------------------------------------------------------------------------
	-- -- UI
	-- --------------------------------------------------------------------------------

	-- -- initial variables
	-- local sysModel = system.getInfo("model")
	-- local sysEnv = system.getInfo("environment")

	-- statusText:toFront()

	-- -- Shows a specific type of ad
	-- showAd = function( adType )
	-- 	local adX, adY = display.screenOriginX, display.screenOriginY
	-- 	statusText.text = ""
	-- 	ads.show( adType, { x=adX, y=adY } )
	-- end

	-- -- if on simulator, let user know they must build for device
	-- if sysEnv == "simulator" then
	-- 	-- local font, size = native.systemFontBold, 22
	-- 	-- local warningText = display.newText( "Please build for device or Xcode simulator to test this sample.", 0, 0, 290, 300, font, size )
	-- 	-- warningText:setFillColor( 255 )
	-- 	-- -- warningText:setReferencePoint( display.CenterReferencePoint )
	-- 	-- warningText.x, warningText.y = display.contentWidth * 0.5, display.contentHeight * 0.5
	-- else
	-- 	-- start with banner ad
	-- 	showAd( "interstitial" )
	-- end

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
	--scoreTransition = transition.to(scoreBg,{time=600, alpha = 1})
	scoreTransition = transition.to(yourScore,{time=600, alpha = 1,onComplete=showStart})
	
end

function showGameOver()
	fadeTransition = transition.to(gameOver,{time=600, alpha=1,onComplete=showScore})
end

function loadScore()
	local prevScore = score.load()
	if prevScore ~= nil then
		if prevScore <= mydata.totalScore then
			score.set(mydata.totalScore)
		else 
			score.set(prevScore)	
		end
	else 
		score.set(mydata.totalScore)	
		score.save()
	end
end

function saveScore()
	score.save()
end

function scene:createScene(event)

	mydata.totalScore = mydata.score + mydata.coins
	tav = (display.contentHeight-1120)/6
	print(display.contentHeight,tav)

	local screenGroup = self.view
	background = display.newImage("bg2.png")
	background.anchorX = 0.5
	background.anchorY = 1
	background.x = display.contentCenterX
	background.y = display.contentHeight -165
	screenGroup:insert(background)
	
	mask = display.newImage("mask2.png")
	mask.anchorX = 0.5
	mask.anchorY = 1
	mask.x = display.contentWidth * 0.5
	mask.y = display.contentHeight
	screenGroup:insert(mask)
	
	-- background = display.newImageRect("bg.png",900,1425)
	-- background.anchorX = 0.5
	-- background.anchorY = 0.5
	-- background.x = display.contentCenterX
	-- background.y = display.contentCenterY
	-- screenGroup:insert(background)
	
	gameOver = display.newImage("gameOver.png",500,100)
	gameOver.anchorX = 0.5
	gameOver.anchorY = 0
	gameOver.x = display.contentCenterX 
	gameOver.y = tav
	gameOver.alpha = 0
	screenGroup:insert(gameOver)
	
	tableS = display.newImage("tableS.png")
	tableS.anchorX = 0.5
	tableS.anchorY = 0
	tableS:scale(0.9,0.9)
	tableS.x = display.contentCenterX 
	tableS.y = gameOver.y + gameOver.contentHeight + tav
	tableS.alpha = 1
	screenGroup:insert(tableS)
	
	yourScore = display.newImage("yourScore.png")
	yourScore.anchorX = 0.5
	yourScore.anchorY = 0
	yourScore.x = display.contentCenterX 
	yourScore.y = tableS.y + tableS.contentHeight + tav
	yourScore.alpha = 0
	screenGroup:insert(yourScore)
	
	highScore = display.newImage("highScore.png")
	highScore.anchorX = 0.5
	highScore.anchorY = 0
	highScore.x = display.contentCenterX 
	highScore.y = tableS.y + 100 
	highScore.alpha = 1
	screenGroup:insert(highScore)
	
	pointCol = display.newImage('pointCol.png')
	pointCol.anchorX = 0.5
	pointCol.anchorY = 0
	pointCol:scale(1.5,1.5)
	pointCol.x = 110
	pointCol.y = yourScore.y + yourScore.contentHeight + tav 
	screenGroup:insert(pointCol)
	
	pointVase = display.newImage('pointVase.png')
	pointVase.anchorX = 0.5
	pointVase.anchorY = 0
	pointVase:scale(1.5,1.5)
	pointVase.x = display.contentWidth - 110
	pointVase.y = pointCol.y 
	screenGroup:insert(pointVase)
	
	
	
	restart = display.newImageRect("start_btn.png",320,180)
	restart.anchorX = 0.5
	restart.anchorY = 1
	restart.x = display.contentCenterX
	restart.y = display.contentHeight - 160 - tav
	restart.alpha = 0
	screenGroup:insert(restart) 
	
	scoreText = display.newText(mydata.score,pointCol.x,
	pointCol.y + 100, "DIOGENES", 70)
	scoreText:setFillColor(0,0,0)
	scoreText.anchorY = 0
	scoreText.alpha = 0 
	screenGroup:insert(scoreText)
	
	coinText = display.newText(mydata.coins,pointVase.x,
	scoreText.y, "DIOGENES", 70)
	coinText:setFillColor(0,0,0)
	coinText.anchorY = 0
	coinText.alpha = 1 
	screenGroup:insert(coinText)
	
	totalScoreText = display.newText(mydata.totalScore,display.contentCenterX,
	pointCol.y - 20, "DIOGENES", 120)
	totalScoreText.anchorY = 0
	totalScoreText:setFillColor(1,0,0)
	totalScoreText.alpha = 1 
	screenGroup:insert(totalScoreText)
		
	bestText = score.init({
	fontSize = 80,
	font = "DIOGENES",
	x = display.contentCenterX,
	y = highScore.y + 140,
	maxDigits = 1,
	leadingZeros = false,
	filename = "scorefile.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText:setFillColor(0,0,0)
	screenGroup:insert(bestText)
	
	loadScore()
end

function scene:enterScene(event)
	storyboard.removeScene("game")
	restart:addEventListener("touch", restartGame)
	showGameOver()
	displayAd()
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