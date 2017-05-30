minetest.register_node("skytest:dust", {
    description = "Dust",
        _doc_items_usagehelp = "Can be sieved.",
    tiles = {"default_sand.png^[colorize:white:120"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
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

