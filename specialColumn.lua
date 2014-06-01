-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["bottomColumn"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -49, -357.5  ,  49.5, -356  ,  -44.5, -351  ,  -50.5, -353  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   43.5, -350  ,  49.5, -356  ,  49.5, -352  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   38.5, -339  ,  -33.5, -320  ,  43.5, -350  ,  43.5, -342  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -44.5, -351  ,  49.5, -356  ,  -39.5, -340  ,  -44, -340.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   32.5, -319  ,  -33.5, -320  ,  38.5, -339  ,  38.5, -323  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -39.5, -340  ,  49.5, -356  ,  43.5, -350  ,  -33.5, -320  ,  -39, -321.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -33, 356.5  ,  -33.5, 354  ,  -33.5, -320  ,  32.5, -319  ,  31, 356.5  }
                    }
                    
                    
                    
		},

        ["corn"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   4, -28  ,  -6, -28  ,  -10, -37  ,  4, -37  ,  9.5, -33.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   8, 35  ,  -2, 30  ,  -23, 6  ,  -5.5, -23.5  ,  23.5, -1.5  ,  32.5, 16.5  ,  32.5, 34.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -18, -28  ,  -27, 6  ,  -29.5, -7.5  ,  -31.5, -27.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -34.5, -3.5  ,  -28.5, 9.5  ,  -24, 23  ,  -33.5, 14.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -16, 23  ,  -24, 23  ,  -24, 17  ,  -14.5, 21.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -24, 23  ,  -28.5, 9.5  ,  -24, 17  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -5.5, -23.5  ,  -23, 6  ,  -27, 6  ,  -18, -28  ,  -11, -37  ,  -10, -37  ,  -6, -28  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -27, 6  ,  -28.5, 9.5  ,  -34.5, -3.5  ,  -29.5, -7.5  }
                    }
                    
                    
                    
        }
		
	} }

        -- -- apply scale factor
        -- local s = scale or 1.0
        -- for bi,body in pairs(physics.data) do
        --         for fi,fixture in ipairs(body) do
        --             if(fixture.shape) then
        --                 for ci,coordinate in ipairs(fixture.shape) do
        --                     fixture.shape[ci] = s * coordinate
        --                 end
        --             else
        --                 fixture.radius = s * fixture.radius
        --             end
        --         end
        -- end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M
