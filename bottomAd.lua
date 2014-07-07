local M = {}
M.ready = false
M.visible = false
local function adListener( event )
	if event.isError == "false" then
		M.ready = true
		display()
	end
end
function M.init( options )
	display.setStatusBar( display.HiddenStatusBar )
	local provider = "admob"
	local appID = "ca-app-pub-4047264809121768/2045757936"
	local ads = require "ads"
	local statusText = display.newText( "", 0, 0, native.systemFontBold, 22 )
	statusText:setFillColor( 255 )
	statusText.x, statusText.y = display.contentWidth * 0.5, 160
	if appID then
		ads.init( provider, appID, adListener )
	end
end
local function display()
	if sysEnv ~= "simulator" then
		local adX, adY = display.screenOriginX, display.contentHeight - 120
		ads.show( "banner", { x=adX, y=adY } )
	end	
end

return M