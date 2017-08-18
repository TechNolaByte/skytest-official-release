minetest.register_node("skytest:glow", {
    drawtype = "airlike",
    walkable = false,
    pointable = false,
    diggable = true,
    climbable = false,
    buildable_to = true,
    light_source = 14,
    paramtype = light
})

minetest.register_craft({
    output = "skytest:source",
    recipe = {
        {'default:glass', 'default:glass', 'default:glass'},
        {'default:glass', 'default:torch', 'default:glass'},
        {'default:glass', 'default:glass', 'default:glass'},
    }
})

minetest.register_node("skytest:source", {
    description = "Super Bright Star Light",
  tiles = {"default_obsidian_glass.png^greedy_soul_fragment.png"},
    drawtype = "glasslike",
    groups = { cracky=3, oddly_breakable_by_hand=3 },
    sounds = default.node_sound_glass_defaults(),
    drop = "skytest:source",
    light_source = 14,
    paramtype = light,
    after_place_node = function(pos, placer)
        minetest.get_node_timer(pos):start(1.1)
    end,
    on_destruct = function(pos)
        minetest.get_node_timer(pos):stop()
    end,
    after_destruct = function(pos, oldnode)
        local dist = 6
        local minp = { x=pos.x-dist, y=pos.y-dist, z=pos.z-dist }
        local maxp = { x=pos.x+dist, y=pos.y+dist, z=pos.z+dist }
        local glow_nodes = minetest.find_nodes_in_area(minp, maxp, "skytest:glow")
        for key, npos in pairs(glow_nodes) do
            minetest.remove_node(npos)
            end
    end,
    on_timer = function(pos, elapsed)
        local dist = 6
        local pmod = (pos.x + pos.y + pos.z) %2 
        local minp = { x=pos.x-dist, y=pos.y-dist, z=pos.z-dist }
        local maxp = { x=pos.x+dist, y=pos.y+dist, z=pos.z+dist }
        local air_nodes = minetest.find_nodes_in_area(minp, maxp, "air")
        for key, npos in pairs(air_nodes) do
            if (npos.x + npos.y + npos.z) %2 == pmod then -- 3d checkerboard pattern
                if grounded(npos) then                    -- against lightable surfaces
                    minetest.add_node(npos, {name = "skytest:glow"})
                end
            end
        end
        return true
    end
})

grounded = function(pos)
    -- checks all nodes touching the edges and corners (but not faces) of the given pos
    for nx = -1, 1, 2 do
        for ny = -1, 1, 2 do
            for nz = -1, 1, 2 do
                local npos = { x=pos.x+nx, y=pos.y+ny, z=pos.z+nz }
                local name = minetest.get_node(npos).name
                if minetest.registered_nodes[name].walkable and name ~= "skytest:source" then
                    return true
                end
            end
        end
  end
    return false
end
minetest.register_node("skytest:dust", {
    description = "Dust",
        _doc_items_usagehelp = "Can be sieved.",
    tiles = {"default_sand.png^[colorize:white:120"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
emc = 1,
})
minetest.register_node("skytest:cobblegen", {
    description = "Cobble gen",
        _doc_items_usagehelp = "Will generate cobble ontop of this block.",
        tiles = {"default_lava.png^[colorize:white:120"},
        groups = {cracky=1},
})
minetest.register_node("skytest:enchanted_block", {
    description = "Enchanted block",
        tiles = {"enchanted_block.png"},
        groups = {cracky=1},
})
minetest.register_node("skytest:angel_block", {
    description = "Angel block",
        tiles = {"angel.png^wings_item.png"},
        groups = {cracky=1},
	drop = "skytest:angel_item",
})
minetest.register_craftitem("skytest:angel_item", {
    description = "Angel block",
        inventory_image = "angel.png^wings_item.png",
	range = 1,
        stack_max = 99,
	on_use = function(itemstack, user, pointed_thing)
	local pos=user:getpos()
	pos.y=pos.y-1.5
if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos, {name = "skytest:angel_block"})
				itemstack:take_item()
				return itemstack
			end
end,
})
minetest.register_craft({
        output = "skytest:angel_item",
        recipe = {
            {"skytest:enchanted_crystal","default:obsidian","skytest:enchanted_crystal"},
            }
    })
minetest.register_craft({
        output = "skytest:enchanted_block",
        recipe = {
            {"skytest:enchanted_crystal","skytest:enchanted_crystal","skytest:enchanted_crystal"},
            {"skytest:enchanted_crystal","skytest:enchanted_crystal","skytest:enchanted_crystal"},
            {"skytest:enchanted_crystal","skytest:enchanted_crystal","skytest:enchanted_crystal"},
        }
    })
minetest.register_node("skytest:growth_crystal", {
    description = "Growth crystal",
        _doc_items_usagehelp = "Can be sieved. will activate any super infused soil within a 1 block radias.",
        tiles = {"ant_dirt.png"},
        groups = {cracky=1},
})
minetest.register_craft({
        output = "skytest:growth_crystal",
        recipe = {
            {"group:soil","skytest:enchanted_crystal","group:soil"},
            {"skytest:enchanted_crystal","group:soil","skytest:enchanted_crystal"},
            {"group:soil","skytest:enchanted_crystal","group:soil"},
        }
    })
minetest.register_craft({
        output = "skytest:cobblegen",
        recipe = {
            {"bucket:bucket_water","default:stone","bucket:bucket_lava"},
            {"bucket:bucket_water","default:cobble","bucket:bucket_lava"},
            {"default:stone","default:stone","default:stone"},
        }
    })

minetest.register_abm({
	nodenames = {"skytest:cobblegen"},
	neighbors = {""},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, 

active_object_count_wider)
              pos.y = pos.y+1
		minetest.set_node(pos, {name = "default:cobble"})
	end
})
minetest.register_node("skytest:l2cobblegen", {
    description = "Mk2 Cobble gen",
        _doc_items_usagehelp = "Will generate cobble next to this block.",
        tiles = {"default_lava.png"},
        groups = {cracky=1},
})
minetest.register_abm({
	nodenames = {"air"},
	neighbors = {"skytest:l2cobblegen"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count,active_object_count_wider)
		minetest.set_node(pos, {name = "default:cobble"})
	end
})
minetest.register_craft({
        output = "skytest:l2cobblegen",
        recipe = {
            {"skytest:cobblegen","skytest:glowstone_block","skytest:cobblegen"},
            {"skytest:cobblegen","skytest:glowstone_block","skytest:cobblegen"},
            {"skytest:redstone_block","skytest:lapis_block","skytest:redstone_block"},
        }
    })

minetest.register_node(":default:cobble", {
    description = "Cobblestone",
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
	emc = 1,
	drop = { 
        max_items = 1,
        items = {{
            items = {'node "default:gravel" 1'},
	    tools ={"skytest:stone_hammer","skytest:steel_hammer","skytest:diamond_hammer","skytest:mese_hammer"},
	}, {
	    items = {'node "default:cobble" 1'},
	    tools ={"~pick"},
      }}
    }
})
minetest.register_node(":default:gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults(),
	emc = 1,
	drop = { 
        max_items = 1,
        items = {{
            items = {'node "default:sand" 1'},
	    tools ={"skytest:stone_hammer","skytest:steel_hammer","skytest:diamond_hammer","skytest:mese_hammer"},
}}
    }
})
minetest.register_node(":default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
	emc = 1,
	drop = { 
        max_items = 1,
        items = {{
            items = {'node "skytest:dust" 1'},
	    tools ={"skytest:stone_hammer","skytest:steel_hammer","skytest:diamond_hammer","skytest:mese_hammer"},
}, {
	    items = {'node "default:sand" 1'},
      }}
    }
})
minetest.register_node(":default:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_leaves.png"},
	special_tiles = {"default_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
        drop = {
		max_items = 1,
		items = {{
				items = {'default:sapling'},
				rarity = 20,
			},{
				items = {'skytest:silkworm'},
	                	tools ={"skytest:crook"},
  	                     	rarity = 16,
	
			},{
				items = {'default:sapling'},
	               	 	tools ={"skytest:comp_crook"},
				rarity = 4,
			},{
				items = {'skytest:silkworm'},
	                	tools ={"skytest:comp_crook"},
  	                     	rarity = 4,
	
			},{
				items = {'default:leaves'},
			}}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})
minetest.register_node("skytest:leaf_weight", {
    description = "Leaf weight",
        tiles = {"default_stone.png"},
        groups = {cracky = 3},

            })
minetest.register_node("skytest:infested_leaves", {
    description = "Infested leaves",
	drawtype = "allfaces_optional",
	waving = 1,
        tiles = {"default_leaves.png^[colorize:white:120"},
        groups = {leaves = 1,snappy = 3},
	paramtype = "light",
	is_ground_content = false,
	drop = {
		max_items = 1,
		items = {{
				items = {'skytest:silk'},
	               	 	tools ={"skytest:crook"},
				rarity = 4,
			},{
				items = {'skytest:silk'},
	                	tools ={"skytest:comp_crook"},
  	                     	rarity = 1,
	
			},{
				items = {'skytest:infested_leaves'},
	                	tools ={"skytest:leaf_collector_vm","skytest:leaf_collector_normal","skytest:leaf_collector_3x3x1"},
			}}
	},
	sounds = default.node_sound_leaves_defaults(),
})
minetest.register_abm({
	nodenames = {"group:leaves"},
	neighbors = {"skytest:infested_leaves"},
	interval = 3.0,
	chance = 3,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "skytest:infested_leaves"})
	end
})
minetest.register_craft({
        output = "skytest:dense_leaves",
        recipe = {
            {"group:leaves","group:leaves","group:leaves"},
            {"group:leaves","default:dirt","group:leaves"},
            {"group:leaves","group:leaves","group:leaves"},
        }
    })
minetest.register_craft({
        output = "skytest:leaf_weight",
        recipe = {
            {"group:tree","group:tree","group:tree"},
            {"group:tree","skytest:silk_mesh","group:tree"},
            {"group:tree","group:tree","group:tree"},
        }
    })


minetest.register_node("skytest:glowstone_block", {
	description = "Glowstone",
	tiles = {"glowstone_block.png"},
	is_ground_content = true,
	sounds = default.node_sound_glass_defaults(),
	groups = {cracky=3,oddly_breakable_by_hand=3},
	light_source = 14,
	drop = 'skytest:glowstone 4',
})
minetest.register_node("skytest:redstone_block", {
	description = "Block of Redstone",
	tiles = {"redstone_block.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("skytest:lapis_block", {
	description = "Block of Lapis Lazuli",
	tiles = {"lapis_block.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})
local function count_items()
   local number = 0
   local file = minetest.get_worldpath() .. "/items"
   local output = io.open(file, "w")
   for name, item in pairs(minetest.registered_items) do
      number = number + 1
      output:write(name.."\n")
   end
   io.close(output)
   print("There are "..number.." registered items.")
   minetest.chat_send_player("singleplayer", "There are "..number.." registered items.")
end
minetest.register_node("skytest:item_counter", {
	description = "Counter of items",
	tiles = {"minimap_overlay_round.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
        on_rightclick = count_items,
})

minetest.register_abm({
	nodenames = {"default:nyancat"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local dir = minetest.facedir_to_dir(node.param2)	
		local infrontof = {x=pos.x - dir.x, y=pos.y - dir.y, z=pos.z - dir.z}	
		if minetest.get_node(infrontof).name == "air" then
			minetest.set_node(pos, {name = "default:nyancat_rainbow", param2 = node.param2})
			minetest.set_node(infrontof, {name = "default:nyancat", param2 = node.param2})
		else 
			minetest.set_node(pos, {name = "default:nyancat", param2 = (node.param2+1) % 24})
		end
	end
})

local skytest = {}
screwdriver = screwdriver or {}

local function index_to_xy(idx)
	idx = idx - 1
	local x = idx % 8
	local y = (idx - x) / 8
	return x, y
end

local function xy_to_index(x, y)
	return x + y * 8 + 1
end

function skytest.init(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	
	local formspec = [[ size[8,8.6;]
			bgcolor[#080808BB;true]
			background[0,0;8,8;chess_bg.png]
			button[3.1,7.8;2,2;new;New game]
			list[context;board;0,0;8,8;]
			listcolors[#00000000;#00000000;#00000000;#30434C;#FFF] ]]

	meta:set_string("formspec", formspec)
	meta:set_string("infotext", "Chess Board")
	meta:set_string("playerBlack", "")
	meta:set_string("playerWhite", "")
	meta:set_string("lastMove", "")
	meta:set_string("winner", "")

	meta:set_int("lastMoveTime", 0)
	meta:set_int("castlingBlackL", 1)
	meta:set_int("castlingBlackR", 1)
	meta:set_int("castlingWhiteL", 1)
	meta:set_int("castlingWhiteR", 1)

	inv:set_list("board", {
		"skytest:rook_black_1",
		"skytest:knight_black_1",
		"skytest:bishop_black_1",
		"skytest:queen_black",
		"skytest:king_black",
		"skytest:bishop_black_2",
		"skytest:knight_black_2",
		"skytest:rook_black_2",
		"skytest:pawn_black_1",
		"skytest:pawn_black_2",
		"skytest:pawn_black_3",
		"skytest:pawn_black_4",
		"skytest:pawn_black_5",
		"skytest:pawn_black_6",
		"skytest:pawn_black_7",
		"skytest:pawn_black_8",
		'','','','','','','','','','','','','','','','',
		'','','','','','','','','','','','','','','','',
		"skytest:pawn_white_1",
		"skytest:pawn_white_2",
		"skytest:pawn_white_3",
		"skytest:pawn_white_4",
		"skytest:pawn_white_5",
		"skytest:pawn_white_6",
		"skytest:pawn_white_7",
		"skytest:pawn_white_8",
		"skytest:rook_white_1",
		"skytest:knight_white_1",
		"skytest:bishop_white_1",
		"skytest:queen_white",
		"skytest:king_white",
		"skytest:bishop_white_2",
		"skytest:knight_white_2",
		"skytest:rook_white_2"
	})

	inv:set_size("board", 64)
end

function skytest.move(pos, from_list, from_index, to_list, to_index, _, player)
	if from_list ~= "board" and to_list ~= "board" then
		return 0
	end

	local playerName = player:get_player_name()
	local meta = minetest.get_meta(pos)

	if meta:get_string("winner") ~= "" then
		minetest.chat_send_player(playerName, "This game is over.")
		return 0
	end

	local inv = meta:get_inventory()
	local pieceFrom = inv:get_stack(from_list, from_index):get_name()
	local pieceTo = inv:get_stack(to_list, to_index):get_name()
	local lastMove = meta:get_string("lastMove")
	local thisMove -- will replace lastMove when move is legal
	local playerWhite = meta:get_string("playerWhite")
	local playerBlack = meta:get_string("playerBlack")

	if pieceFrom:find("white") then
		if playerWhite ~= "" and playerWhite ~= playerName then
			minetest.chat_send_player(playerName, "Someone else plays white pieces!")
			return 0
		end		
		if lastMove ~= "" and lastMove ~= "black" then
			minetest.chat_send_player(playerName, "It's not your turn, wait for your opponent to play.")
			return 0
		end
		if pieceTo:find("white") then
			-- Don't replace pieces of same color
			return 0
		end
		playerWhite = playerName
		thisMove = "white"
	elseif pieceFrom:find("black") then
		if playerBlack ~= "" and playerBlack ~= playerName then
			minetest.chat_send_player(playerName, "Someone else plays black pieces!")
			return 0
		end
		if lastMove ~= "" and lastMove ~= "white" then
			minetest.chat_send_player(playerName, "It's not your turn, wait for your opponent to play.")
			return 0
		end
		if pieceTo:find("black") then
			-- Don't replace pieces of same color
			return 0
		end
		playerBlack = playerName
		thisMove = "black"
	end

	-- DETERMINISTIC MOVING

	local from_x, from_y = index_to_xy(from_index)
	local to_x, to_y = index_to_xy(to_index)

	if pieceFrom:sub(11,14) == "pawn" then
		if thisMove == "white" then
			local pawnWhiteMove = inv:get_stack(from_list, xy_to_index(from_x, from_y - 1)):get_name()
			-- white pawns can go up only
			if from_y - 1 == to_y then
				if from_x == to_x then
					if pieceTo ~= "" then
						return 0
					elseif to_index >= 1 and to_index <= 8 then
						inv:set_stack(from_list, from_index, "skytest:queen_white")
					end
				elseif from_x - 1 == to_x or from_x + 1 == to_x then
					if not pieceTo:find("black") then
						return 0
					elseif to_index >= 1 and to_index <= 8 then
						inv:set_stack(from_list, from_index, "skytest:queen_white")
					end
				else
					return 0
				end
			elseif from_y - 2 == to_y then
				if pieceTo ~= "" or from_y < 6 or pawnWhiteMove ~= "" then
					return 0
				end
			else
				return 0
			end
		elseif thisMove == "black" then
			local pawnBlackMove = inv:get_stack(from_list, xy_to_index(from_x, from_y + 1)):get_name()
			-- black pawns can go down only
			if from_y + 1 == to_y then
				if from_x == to_x then
					if pieceTo ~= "" then
						return 0
					elseif to_index >= 57 and to_index <= 64 then
						inv:set_stack(from_list, from_index, "skytest:queen_black")
					end
				elseif from_x - 1 == to_x or from_x + 1 == to_x then
					if not pieceTo:find("white") then
						return 0
					elseif to_index >= 57 and to_index <= 64 then
						inv:set_stack(from_list, from_index, "skytest:queen_black")
					end
				else
					return 0
				end
			elseif from_y + 2 == to_y then
				if pieceTo ~= "" or from_y > 1 or pawnBlackMove ~= "" then
					return 0
				end
			else
				return 0
			end

			-- if x not changed,
			--   ensure that destination cell is empty
			-- elseif x changed one unit left or right
			--   ensure the pawn is killing opponent piece
			-- else
			--   move is not legal - abort

			if from_x == to_x then
				if pieceTo ~= "" then
					return 0
				end
			elseif from_x - 1 == to_x or from_x + 1 == to_x then
				if not pieceTo:find("white") then
					return 0
				end
			else
				return 0
			end
		else
			return 0
		end

	elseif pieceFrom:sub(11,14) == "rook" then
		if from_x == to_x then
			-- moving vertically
			if from_y < to_y then
				-- moving down
				-- ensure that no piece disturbs the way
				for i = from_y + 1, to_y - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- mocing up
				-- ensure that no piece disturbs the way
				for i = to_y + 1, from_y - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, i)):get_name() ~= "" then
						return 0
					end
				end
			end
		elseif from_y == to_y then
			-- mocing horizontally
			if from_x < to_x then
				-- mocing right
				-- ensure that no piece disturbs the way
				for i = from_x + 1, to_x - 1 do
					if inv:get_stack(from_list, xy_to_index(i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- mocing left
				-- ensure that no piece disturbs the way
				for i = to_x + 1, from_x - 1 do
					if inv:get_stack(from_list, xy_to_index(i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			end
		else
			-- attempt to move arbitrarily -> abort
			return 0
		end

		if thisMove == "white" or thisMove == "black" then
			if pieceFrom:sub(-1) == "1" then
				meta:set_int("castlingWhiteL", 0)
			elseif pieceFrom:sub(-1) == "2" then
				meta:set_int("castlingWhiteR", 0)
			end
		end

	elseif pieceFrom:sub(11,16) == "knight" then
		-- get relative pos
		local dx = from_x - to_x
		local dy = from_y - to_y

		-- get absolute values
		if dx < 0 then dx = -dx end
		if dy < 0 then dy = -dy end

		-- sort x and y
		if dx > dy then dx, dy = dy, dx end

		-- ensure that dx == 1 and dy == 2
		if dx ~= 1 or dy ~= 2 then
			return 0
		end
		-- just ensure that destination cell does not contain friend piece
		-- ^ it was done already thus everything ok

	elseif pieceFrom:sub(11,16) == "bishop" then
		-- get relative pos
		local dx = from_x - to_x
		local dy = from_y - to_y

		-- get absolute values
		if dx < 0 then dx = -dx end
		if dy < 0 then dy = -dy end

		-- ensure dx and dy are equal
		if dx ~= dy then return 0 end

		if from_x < to_x then
			if from_y < to_y then
				-- moving right-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- moving right-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		else
			if from_y < to_y then
				-- moving left-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- moving left-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end
		end

	elseif pieceFrom:sub(11,15) == "queen" then
		local dx = from_x - to_x
		local dy = from_y - to_y

		-- get absolute values
		if dx < 0 then dx = -dx end
		if dy < 0 then dy = -dy end

		-- ensure valid relative move
		if dx ~= 0 and dy ~= 0 and dx ~= dy then
			return 0
		end

		if from_x == to_x then
			if from_y < to_y then
				-- goes down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- goes up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end		
		elseif from_x < to_x then
			if from_y == to_y then
				-- goes right
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			elseif from_y < to_y then
				-- goes right-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- goes right-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x + i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end				
		else
			if from_y == to_y then
				-- goes left
				-- ensure that no piece disturbs the way and destination cell does
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y)):get_name() ~= "" then
						return 0
					end
				end
			elseif from_y < to_y then
				-- goes left-down
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y + i)):get_name() ~= "" then
						return 0
					end
				end
			else
				-- goes left-up
				-- ensure that no piece disturbs the way
				for i = 1, dx - 1 do
					if inv:get_stack(from_list, xy_to_index(from_x - i, from_y - i)):get_name() ~= "" then
						return 0
					end
				end
			end		
		end

	elseif pieceFrom:sub(11,14) == "king" then
		local dx = from_x - to_x
		local dy = from_y - to_y
		local check = true
		
		if thisMove == "white" then
			if from_y == 7 and to_y == 7 then
				if to_x == 1 then
					local castlingWhiteL = meta:get_int("castlingWhiteL")
					local idx57 = inv:get_stack(from_list, 57):get_name()

					if castlingWhiteL == 1 and idx57 == "skytest:rook_white_1" then
						for i = 58, from_index - 1 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 57, "")
						inv:set_stack(from_list, 59, "skytest:rook_white_1")
						check = false
					end
				elseif to_x == 6 then
					local castlingWhiteR = meta:get_int("castlingWhiteR")
					local idx64 = inv:get_stack(from_list, 64):get_name()

					if castlingWhiteR == 1 and idx64 == "skytest:rook_white_2" then
						for i = from_index + 1, 63 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 62, "skytest:rook_white_2")
						inv:set_stack(from_list, 64, "")
						check = false
					end
				end
			end
		elseif thisMove == "black" then
			if from_y == 0 and to_y == 0 then
				if to_x == 1 then
					local castlingBlackL = meta:get_int("castlingBlackL")
					local idx1 = inv:get_stack(from_list, 1):get_name()

					if castlingBlackL == 1 and idx1 == "skytest:rook_black_1" then
						for i = 2, from_index - 1 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 1, "")
						inv:set_stack(from_list, 3, "skytest:rook_black_1")
						check = false
					end
				elseif to_x == 6 then
					local castlingBlackR = meta:get_int("castlingBlackR")
					local idx8 = inv:get_stack(from_list, 1):get_name()

					if castlingBlackR == 1 and idx8 == "skytest:rook_black_2" then
						for i = from_index + 1, 7 do
							if inv:get_stack(from_list, i):get_name() ~= "" then
								return 0
							end
						end
						inv:set_stack(from_list, 6, "skytest:rook_black_2")
						inv:set_stack(from_list, 8, "")
						check = false
					end
				end
			end
		end

		if check then
			if dx < 0 then dx = -dx end
			if dy < 0 then dy = -dy end
			if dx > 1 or dy > 1 then return 0 end
		end
		
		if thisMove == "white" then
			meta:set_int("castlingWhiteL", 0)
			meta:set_int("castlingWhiteR", 0)
		elseif thisMove == "black" then
			meta:set_int("castlingBlackL", 0)		
			meta:set_int("castlingBlackR", 0)
		end
	end

	meta:set_string("playerWhite", playerWhite)
	meta:set_string("playerBlack", playerBlack)
	lastMove = thisMove
	meta:set_string("lastMove", lastMove)
	meta:set_int("lastMoveTime", minetest.get_gametime())

	if lastMove == "black" then
		minetest.chat_send_player(playerWhite, "["..os.date("%H:%M:%S").."] "..
				playerName.." moved a "..pieceFrom:match(":(%a+)")..", it's now your turn.")
	elseif lastMove == "white" then
		minetest.chat_send_player(playerBlack, "["..os.date("%H:%M:%S").."] "..
				playerName.." moved a "..pieceFrom:match(":(%a+)")..", it's now your turn.")
	end

	if pieceTo:sub(11,14) == "king" then
		minetest.chat_send_player(playerBlack, playerName.." won the game.")
		minetest.chat_send_player(playerWhite, playerName.." won the game.")
		meta:set_string("winner", thisMove)
	end

	return 1
end

local function timeout_format(timeout_limit)
	local time_remaining = timeout_limit - minetest.get_gametime()
	local minutes = math.floor(time_remaining / 60)
	local seconds = time_remaining % 60

	if minutes == 0 then return seconds.." sec." end
	return minutes.." min. "..seconds.." sec."
end

function skytest.fields(pos, _, fields, sender)
	local playerName = sender:get_player_name()
	local meta = minetest.get_meta(pos)
	local timeout_limit = meta:get_int("lastMoveTime") + 300
	local playerWhite = meta:get_string("playerWhite")
	local playerBlack = meta:get_string("playerBlack")
	local lastMoveTime = meta:get_int("lastMoveTime")
	if fields.quit then return end

	-- timeout is 5 min. by default for resetting the game (non-players only)
	if fields.new and (playerWhite == playerName or playerBlack == playerName) then
		skytest.init(pos)
	elseif fields.new and lastMoveTime ~= 0 and minetest.get_gametime() >= timeout_limit and
			(playerWhite ~= playerName or playerBlack ~= playerName) then
		skytest.init(pos)
	else
		minetest.chat_send_player(playerName, "[!] You can't reset the chessboard, a game has been started.\n"..
				"If you are not a current player, try again in "..timeout_format(timeout_limit))
	end
end

function skytest.dig(pos, player)
	if not player then
		return false
	end
	local meta = minetest.get_meta(pos)
	local playerName = player:get_player_name()
	local timeout_limit = meta:get_int("lastMoveTime") + 300
	local lastMoveTime = meta:get_int("lastMoveTime")

	-- timeout is 5 min. by default for digging the chessboard (non-players only)
	return (lastMoveTime == 0 and minetest.get_gametime() > timeout_limit) or
		minetest.chat_send_player(playerName, "[!] You can't dig the chessboard, a game has been started.\n"..
				"Reset it first if you're a current player, or dig again in "..timeout_format(timeout_limit))
end

function skytest.on_move(pos, from_list, from_index)
	local inv = minetest.get_meta(pos):get_inventory()
	inv:set_stack(from_list, from_index, '')
	return false
end

minetest.register_node("skytest:chessboard", {
	description = "Chess Board",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	inventory_image = "chessboard_top.png",
	wield_image = "chessboard_top.png",
	tiles = {"chessboard_top.png", "chessboard_top.png", "chessboard_sides.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = {type = "fixed", fixed = {-.375, -.5, -.375, .375, -.4375, .375}},
	sunlight_propagates = true,
	on_rotate = screwdriver.rotate_simple,
	can_dig = skytest.dig,
	on_construct = skytest.init,
	on_receive_fields = skytest.fields,
	allow_metadata_inventory_move = skytest.move,
	on_metadata_inventory_move = skytest.on_move,
	allow_metadata_inventory_take = function() return 0 end
})

minetest.register_craft({ 
	output = "skytest:chessboard",
	recipe = {
		{"dye:black", "dye:white", "dye:black"},
		{"group:wood", "group:wood", "group:wood"}
	} 
})

local function register_piece(name, count)
	for _, color in pairs({"black", "white"}) do
	if not count then
		minetest.register_craftitem("skytest:"..name.."_"..color, {
			description = color:gsub("^%l", string.upper).." "..name:gsub("^%l", string.upper),
			inventory_image = name.."_"..color..".png",
			stack_max = 1,
			groups = {not_in_creative_inventory=1}
		})
	else
		for i = 1, count do
			minetest.register_craftitem("skytest:"..name.."_"..color.."_"..i, {
				description = color:gsub("^%l", string.upper).." "..name:gsub("^%l", string.upper),
				inventory_image = name.."_"..color..".png",
				stack_max = 1,
				groups = {not_in_creative_inventory=1}
			})
		end
	end
	end
end

register_piece("pawn", 8)
register_piece("rook", 2)
register_piece("knight", 2)
register_piece("bishop", 2)
register_piece("queen")
register_piece("king")


shapes = {
   {  { x = {0, 1, 0, 1}, y = {0, 0, 1, 1} } },
     
   {  { x = {1, 1, 1, 1}, y = {0, 1, 2, 3} },
      { x = {0, 1, 2, 3}, y = {1, 1, 1, 1} } },

   {  { x = {0, 0, 1, 1}, y = {0, 1, 1, 2} },
      { x = {1, 2, 0, 1}, y = {0, 0, 1, 1} } },

   {  { x = {1, 0, 1, 0}, y = {0, 1, 1, 2} },
      { x = {0, 1, 1, 2}, y = {0, 0, 1, 1} } },

   {  { x = {1, 2, 1, 1}, y = {0, 0, 1, 2} },
      { x = {0, 1, 2, 2}, y = {1, 1, 1, 2} },
      { x = {1, 1, 0, 1}, y = {0, 1, 2, 2} },
      { x = {0, 0, 1, 2}, y = {0, 1, 1, 1} } },

   {  { x = {1, 1, 1, 2}, y = {0, 1, 2, 2} },
      { x = {0, 1, 2, 0}, y = {1, 1, 1, 2} },
      { x = {0, 1, 1, 1}, y = {0, 0, 1, 2} },
      { x = {0, 1, 2, 2}, y = {1, 1, 1, 0} } },

   {  { x = {1, 0, 1, 2}, y = {0, 1, 1, 1} },
      { x = {1, 1, 1, 2}, y = {0, 1, 2, 1} },
      { x = {0, 1, 2, 1}, y = {1, 1, 1, 2} },
      { x = {0, 1, 1, 1}, y = {1, 0, 1, 2} } } }

colors = { "cyan.png", "magenta.png", "red.png",
          "blue.png", "green.png", "orange.png", "yellow.png" }

background = "image[0,0;3.55,6.66;black.png]"
buttons = "button[3,5;0.6,0.6;left;?]"
	.."button[3.6,5;0.6,0.6;rotateleft;L]"
	.."button[4.2,5;0.6,0.6;drop;?]"
	.."button[4.8,5;0.6,0.6;rotateright;R]"
	.."button[5.4,5;0.6,0.6;right;?]"
	.."button[3.5,3.3;2,2;new;New Game]"

formsize = "size[5.9,5.7]"
boardx, boardy = 0, 0
sizex, sizey, size = 0.29, 0.29, 0.31

local comma = ","
local semi = ";"
local close = "]"

local concat = table.concat
local insert = table.insert

draw_shape = function(id, x, y, rot, posx, posy)
	local d = shapes[id][rot]
	local scr = {}

	for i=1,4 do
	   local tmp = { "image[",
	   		 (d.x[i]+x)*sizex+posx, comma,
	   		 (d.y[i]+y)*sizey+posy, semi,
	   		 size, comma, size, semi,
	   		 colors[id], close }
	   scr[#scr+1] = concat(tmp)
	end

	return concat(scr)
end

function step(pos, fields)
	local meta = minetest.get_meta(pos)
	local t = minetest.deserialize(meta:get_string("tetris"))
	local nex = math.random(7)
	
	local function new_game(pos)
	local meta = minetest.get_meta(pos)
	local t = minetest.deserialize(meta:get_string("tetris"))
	local nex = math.random(7)
		t = {
			board = {},
			boardstring = "",
			previewstring = draw_shape(nex, 0, 0, 1, 4, 1),
			score = 0,
			cur = nex,
			nex = nex,
			x=4, y=0, rot=1 
		}

		local timer = minetest.get_node_timer(pos)
		timer:set(0.3, 0)
	end

	local function update_boardstring()
		local scr = {}

		for i, line in pairs(t.board) do
			for _, tile in pairs(line) do
			   local tmp = { "image[",
			      tile[1]*sizex+boardx, comma,
			      i*sizey+boardy, semi,
			      size, comma, size, semi,
			      colors[tile[2] ], close }

			   scr[#scr+1] = concat(tmp)
			end
		end

		t.boardstring = concat(scr)
	end

	local function add()
		local d = shapes[t.cur][t.rot]

		for i=1,4 do
			local l = d.y[i] + t.y
			if not t.board[l] then t.board[l] = {} end
			insert(t.board[l], {d.x[i] + t.x, t.cur})
		end
	end

	local function scroll(l)
		for i=l, 1, -1 do
			t.board[i] = t.board[i-1] or {}
		end
	end

	local function check_lines()
		for i, line in pairs(t.board) do
			if #line >= 10 then
				scroll(i)
				t.score = t.score + 10
			end
		end
	end

	local function check_position(x, y, rot)
		local d = shapes[t.cur][rot]

		for i=1,4 do
			local cx, cy = d.x[i]+x, d.y[i]+y
			
			if cx < 0 or cx > 9 or cy < 0 or cy > 19 then
				return false 
			end

			for _, tile in pairs(t.board[ cy ] or {}) do
				if tile[1] == cx then return false end
			end
		end

		return true
	end

	local function stuck()
		if check_position(t.x, t.y+1, t.rot) then return false end
		return true
	end

	local function tick()
		if stuck() then	
			if t.y <= 0 then
				return false end
			add()
			check_lines()
			update_boardstring()
			t.cur, t.nex = t.nex, nex
			t.x, t.y, t.rot = 4, 0, 1
			t.previewstring = draw_shape(t.nex, 0, 0, 1, 4.1, 0.6)
		else
			t.y = t.y + 1
		end
		return true
	end  

	local function move(dx, dy)
		local newx, newy = t.x+dx, t.y+dy
		if not check_position(newx, newy, t.rot) then return end
		t.x, t.y = newx, newy
	end

	local function rotate(dr)
		local no = #(shapes[t.cur])
		local newrot = (t.rot+dr) % no

		if newrot<1 then newrot = newrot+no end
		if not check_position(t.x, t.y, newrot) then return end
		t.rot = newrot
	end

	local function key()
		if fields.left then
			move(-1, 0)
		end
		if fields.rotateleft then
			rotate(-1)
		end
		if fields.drop then
			t.score = t.score + 1
			move(0, 3)
		end
		if fields.rotateright then
			rotate(1)
		end
		if fields.right then
			move(1, 0)
		end
	end

	local run = true

	if fields then
		if fields.new then
			new_game(pos)
		else
			key(fields)
		end
	else
		run = tick()
	end

	local scr = { formsize, background, 
		t.boardstring, t.previewstring,
		draw_shape(t.cur, t.x, t.y, t.rot, boardx, boardy),
		"label[3.8,0.1;Next...]label[3.8,3;Score: ", 
		t.score, close, buttons }

		meta:set_string("formspec", concat(scr).. default.gui_bg .. default.gui_bg_img .. default.gui_slots)
		meta:set_string("tetris", minetest.serialize(t))

	return run
end

minetest.register_node("skytest:arcade", {
	description="Arcade",
	drawtype = "mesh",
	mesh = "arcade.obj",
	tiles = {"arcade.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
	},
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", formsize.."button[2,2.5;2,2;new;New Game]".. default.gui_bg .. default.gui_bg_img .. default.gui_slots)
	end,
	
	on_timer = function(pos)
		return step(pos, nil)
	end,

	on_receive_fields = function(pos, formanme, fields, sender)
		step(pos, fields)
	end,
	
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		if minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name ~= "air" then
			minetest.chat_send_player(placer:get_player_name(), "No room for place the Arcade !" )
		return end
		local dir = placer:get_look_dir()
		local node = { name="skytest:arcade", param1=0, param2 = minetest.dir_to_facedir(dir)}
		minetest.set_node(pos, node)
		itemstack:take_item(1)
	end,
})

if(minetest.get_modpath("technic")~=nil) then
if(minetest.get_modpath("digilines")~=nil) then
minetest.register_craft({
	output = "skytest:arcade",
	recipe = {
		{"default:steel_ingot","technic:green_energy_crystal","default:steel_ingot"},
		{"technic:control_logic_unit","digilines:lcd","technic:control_logic_unit"},
		{"technic:copper_coil","technic:machine_casing","technic:copper_coil"},
	
},
})
end
end

--
-- Formspecs
--

local function active_formspec(fuel_percent, item_percent)
	local formspec = 
		"size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[current_name;src;2.75,0.5;1,1;]"..
		"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
		(item_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
		"list[current_name;dst;4.75,0.96;2,2;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[current_name;dst]"..
		"listring[current_player;main]"..
		"listring[current_name;src]"..
		"listring[current_player;main]"..
		default.get_hotbar_bg(0, 4.25)
	return formspec
end

local inactive_formspec =
	"size[8,8.5]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;4.75,0.96;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0, 4.25)

--
-- Node callback functions that are the same for active and inactive furnace
--

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("dst") and inv:is_empty("src")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end
local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function freezer_node_timer(pos, elapsed)
	--
	-- Inizialize metadata
	--
	local meta = minetest.get_meta(pos)

	local src_time = meta:get_float("src_time") or 0


	local inv = meta:get_inventory()
	local srclist = inv:get_list("src")

	local dstlist = inv:get_list("dst")

	--
	-- Cooking
	--
local function register_freeze(input, output, leftover)
if inv:contains_item("src", ""..input.."") then
	   inv:remove_item("src", ""..input.."")
	   inv:add_item("dst", ""..output.."")
if leftover ~= false then
	   inv:add_item("src", ""..leftover.."")
	end	
end
end
register_freeze("bucket:bucket_water", "default:ice", false)
register_freeze("skytest:bucket_wood_water", "default:ice", "skytest:bucket_wood_empty")
	   

	      

	-- Check if we have cookable content
	return
end

--
-- Node definitions
--

minetest.register_node("skytest:freezer", {
	description = "Freezer",
	tiles = {
		"freezer_top.png", "freezer_top.png",
		"freezer_side.png", "freezer_side.png",
		"freezer_side.png", "freezer_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky=2,cools_lava=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),

	can_dig = can_dig,

	on_timer = freezer_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", inactive_formspec)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('dst', 4)
	end,

	on_metadata_inventory_move = function(pos)
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "src", drops)
		default.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "skytest:freezer"
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_craft({
	output = "skytest:freezer",
	recipe = {
		{"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"},
		{"default:steel_ingot", "skytest:bucket_clay_water", "default:steel_ingot"},
		{"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"}
	}
})
minetest.register_craft({
      output = "default:snowblock 3",
      type = "shapeless",
      recipe = {
	 "default:ice"
      }
})

minetest.register_privilege("engrave_long_names", "When using the Engraving Table, Player can set names that contain more than 40 characters and/or newlines")

minetest.register_node("skytest:table", {
	description = "Engraving Table",
	tiles = {"engrave_top.png", "engrave_side.png"},
	groups = {choppy=2,flammable=3, oddly_breakable_by_hand=2},
	sounds = default and default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, player)
		local pname=player:get_player_name()
		local stack=player:get_wielded_item()
		if stack:get_count()==0 then
			minetest.chat_send_player(pname, "Please wield the item you want to name, and then click the engraving table again.")
			return
		end
		local idef=minetest.registered_items[stack:get_name()]
		if not idef then
			minetest.chat_send_player(pname, "You can't name an unknown item!")
			return
		end
		local name=idef.description or stack:get_name()
		local what=name or "whatever"
		if stack:get_count()>1 then
			what="stack of "..what
		end
		
		local meta=stack:get_meta()
		if meta then
			local metaname=meta:get_string("description")
			if metaname~="" then
				name=metaname
			end
		end
		local fieldtype = "field"
		if minetest.check_player_privs(pname, {engrave_long_names=true}) then
			fieldtype = "textarea"
		end
		minetest.show_formspec(pname, "engrave", "size[5.5,2.5]"..fieldtype.."[0.5,0.5;5,1;name;Enter a new name for this "..what..";"..name.."]button_exit[1,1.5;3,1;ok;OK]")
	end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname=="engrave" and fields.name and fields.ok then
		local pname=player:get_player_name()
		if (#fields.name>40 or string.match(fields.name, "\n", nil, true)) and not minetest.check_player_privs(pname, {engrave_long_names=true}) then
			minetest.chat_send_player(pname, "Insufficient Privileges: Item names that are longer than 40 characters and/or contain newlines require the 'engrave_long_names' privilege")
			return
		end
		
		local stack=player:get_wielded_item()
		if stack:get_count()==0 then
			minetest.chat_send_player(pname, "Please wield the item you want to name, and then click the engraving table again.")
			return
		end
		local idef=minetest.registered_items[stack:get_name()]
		if not idef then
			minetest.chat_send_player(pname, "You can't name an unknown item!")
			return
		end
		local name=idef.description or stack:get_name()
		
		local meta=stack:get_meta()
		if not meta then
			minetest.chat_send_player(pname, "For some reason, the stack metadata couldn't be acquired. Try again!")
			return
		end
		
		if fields.name==name then
			meta:set_string("description", "")
		else
			meta:set_string("description", fields.name)
		end
		--write back
		player:set_wielded_item(stack)
	end
end)
if(minetest.get_modpath("technic")~=nil) then
minetest.register_craft({
	output = "skytest:table",
	recipe = {
		{"group:wood", "skytest:enchanted_crystal", "group:wood"},
		{"group:wood", "technic:cnc", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})
end
if(minetest.get_modpath("technic")==nil) then
minetest.register_craft({
	output = "skytest:table",
	recipe = {
		{"group:wood", "skytest:enchanted_crystal", "group:wood"},
		{"group:wood", "default:diamond", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})
end
local _pts = minetest.pos_to_string
function minetest.pos_to_string(pos)
	if not pos then
		return "(-,-,-)"
	end
	return _pts(pos)
end

local elapsed_time = 0

-- Makes sure that force load areas are handled correctly
function ForceloadManager(filetoopen, hide_file_errors)
	local blocks = {}
	if filetoopen ~= nil then
		local file = io.open(filetoopen, "r")
		if file then
			local table = minetest.deserialize(file:read("*all"))
			file:close()
			if type(table) == "table" then
				blocks = table
			end
		elseif not hide_file_errors then
			minetest.log("error", "File "..filetoopen.." does not exist!")
		end
	end
	for i = 1, #blocks do
		if not minetest.forceload_block(blocks[i]) then
			minetest.log("error", "Failed to load block " .. minetest.pos_to_string(blocks[i]))
		end
	end
	return {
		_blocks = blocks,
		load = function(self, pos)
			if minetest.forceload_block(pos) then
				table.insert(self._blocks, vector.new(pos))
				return true
			end
			minetest.log("error", "Failed to load block " .. minetest.pos_to_string(pos))
			return false
		end,
		unload = function(self, pos)
			for i = 1, #self._blocks do
				if vector.equals(pos, self._blocks[i]) then
					minetest.forceload_free_block(pos)
					table.remove(self._blocks, i)
					return true
				end
			end
			return false
		end,
		save = function(self, filename)
			local file = io.open(filename, "w")
			if file then
				file:write(minetest.serialize(self._blocks))
				file:close()
			end
		end,
		verify = function(self)
			return self:verify_each(function(pos, block)
				local name = "ignore"
				if block ~= nil then
					name = block.name
				end

				if name == "ignore" then
					if not pos.last or elapsed_time > pos.last + 15 then
						pos.last = elapsed_time
						if not minetest.forceload_block(pos) then
							minetest.log("error", "Failed to force load " .. minetest.pos_to_string(pos))
							pos.remove = true
						end
					end
					return false
				elseif name == "skytest:anchor" then
					pos.last = elapsed_time
					return true
				else
					minetest.log("error", minetest.pos_to_string(pos) .. " shouldn't be loaded")
					pos.remove = true
					return false
				end
			end)
		end,
		verify_each = function(self, func)
			local not_loaded = {}
			for i = 1, #self._blocks do
				local res = minetest.get_node(self._blocks[i])
				if not func(self._blocks[i], res) then
					--[[table.insert(not_loaded, {
						pos = self._blocks[i],
						i = i,
						b = res })]]--
				end
			end
			return not_loaded
		end,
		clean = function(self)
			local i = 1
			while i <= #self._blocks do
				if self._blocks[i].remove then
					minetest.forceload_free_block(self._blocks[i])
					table.remove(self._blocks, i)
				else
					i = i + 1
				end
			end
		end
	}
end

local flm = ForceloadManager(minetest.get_worldpath().."/flm.json", true)

minetest.register_privilege("forceload", "Allows players to use forceload block anchors")

minetest.register_node("skytest:anchor",{
	description = "Block Anchor",
	walkable = false,
	tiles = {"forceload_anchor.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 2},
	after_destruct = function(pos)
		flm:unload(pos)
		flm:save(minetest.get_worldpath().."/flm.json")
	end,
	after_place_node = function(pos, placer)
		if not minetest.check_player_privs(placer:get_player_name(),
				{forceload = true}) then
			minetest.chat_send_player(placer:get_player_name(), "The forceload privilege is required to do that.")
		elseif flm:load(pos) then
			flm:save(minetest.get_worldpath().."/flm.json")
			return
		end
		minetest.set_node(pos, {name="air"})
		return true
	end
})
if(minetest.get_modpath("technic")~=nil) then
minetest.register_craft({
	output = "skytest:anchor",
	recipe = {
		{"skytest:lapis_block", "technic:control_logic_unit", "skytest:lapis_block"},
		{"technic:control_logic_unit", "technic:machine_casing", "technic:control_logic_unit"},
		{"technic:blue_energy_crystal", "technic:control_logic_unit", "technic:blue_energy_crystal"}
	}
})
end
local count = 0
minetest.register_globalstep(function(dtime)
	count = count + dtime
	elapsed_time = elapsed_time + dtime
	if count > 5 then
		count = 0
		--print("Verifying...")
		flm:verify()
		flm:clean()
	end
end)

minetest.register_node("skytest:infinwater", {
    description = "Infinite water source",
    paramtype = "light",
    tiles = {
        "freezer_top.png^water.png",
        "freezer_top.png",
        "sieve_auto_sieve_side.png",
        "sieve_auto_sieve_side.png",
        "sieve_auto_sieve_side.png",
        "sieve_auto_sieve_side.png"
    },
    groups = {choppy = 2, oddly_breakable_by_hand = 2},
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
                {-0.5, 0.1875, -0.5, 0.5, 0.19, 0.5},
                {0.5,0.5,-0.5,-0.5,0,-0.4375},
                {-0.5,0.5,-0.5,-0.4375,0,0.5},
                {0.5,0.5,0.5,-0.5,0,0.4375},
                {0.5,0.5,-0.5,0.4375,0,0.5},
                {-0.5, -0.5, -0.5, -0.4375, 0.5, -0.4375},
                {-0.5, -0.5, 0.5, -0.4375, 0.5, 0.4375},
                {0.5, -0.5, 0.5, 0.4375, 0.5, 0.4375},
                {0.5, -0.5, -0.5, 0.4375, 0.5, -0.4375},
                },
        },
	on_rightclick = function(pos, node, player, itemstack, pointed_thing, clicker)
	  if itemstack:get_name() == "skytest:bucket_wood_empty" then
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "skytest:bucket_wood_water")
            return itemstack
  	end 
	  if itemstack:get_name() == "bucket:bucket_empty" then
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "bucket:bucket_water")

            return itemstack
  	end   
	  if itemstack:get_name() == "skytest:bucket_clay_empty" then
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "skytest:bucket_clay_water")

            return itemstack
  	end   
    end,
})
minetest.register_craft({
	output = "skytest:infinwater",
	recipe = {
		{"skytest:bucket_clay_water", "skytest:lapis_block", "skytest:bucket_clay_water"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"skytest:enchanted_crystal", "default:steel_ingot", "skytest:enchanted_crystal"}
	}
})
minetest.register_craft({
	output = "skytest:infinwater",
	recipe = {
		{"bucket:bucket_water", "skytest:lapis_block", "bucket:bucket_water"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"skytest:enchanted_crystal", "default:steel_ingot", "skytest:enchanted_crystal"}
	}
})
minetest.register_craft({
	output = "skytest:infinwater",
	recipe = {
		{"skytest:bucket_wood_water", "skytest:lapis_block", "skytest:bucket_wood_water"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"skytest:enchanted_crystal", "default:steel_ingot", "skytest:enchanted_crystal"}
	}
})