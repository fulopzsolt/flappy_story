-- requires 


local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local mydata = require( "mydata" )
local score = require( "score" )
-----------------------------
-----------------------------
-----------------------------
-----------------------------
-- function myfb()
-- -- 	local fb = require('fb')
-- -- fb:setUpAppId('1408482976102015')
-- -- fb:postMessageToFacebook('playin fckin flappy f')
-- -- fb:logOut()


-- local libFacebook = require("lib_facebook")
--    libFacebook.FB_App_ID = "1408482976102015"
--    libFacebook.isDebug = true
 
--    local function onRequestComplete( event )
--        if event.isError then
--            print("Facebook request error: " .. event.response.error.message)
--        else
--            -- Success - process my friends list
--            print("Friends list fetched with request: " .. event.request.path)
--            for _, friend in pairs(event.response.data) do
--                 print("  Facebook friend: " .. friend.name .. ", id: " .. friend.id)
--            end
--        end
--    end
 
--    local function onLoginComplete( event )
--        if event.phase ~= "login" then
--            print("Facebook login not successful")
--        elseif event.isError then
--            print("Facebook login error, details: " .. event.response.error.message)
--        else
--            -- Successfully logged in, now list my friends
--            libFacebook.request("me/friends", "GET", {limit = "10"}, onRequestComplete)
--        end
--    end
 
--    libFacebook.login({"publish_stream"}, onLoginComplete)
-- end


-----------------------------
-----------------------------
-----------------------------
-----------------------------
-- background

function restartGame(event)
     if event.phase == "ended" then
     	-- myfb()
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
	
	gameOver = display.newImage("gameOver.png")
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













