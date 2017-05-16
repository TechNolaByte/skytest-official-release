minetest.register_node("skytest:dust", {
    description = "Dust",
    tiles = {"default_sand.png"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
})
minetest.register_node("skytest:cobblegen", {
    description = "Cobble gen",
        tiles = {"default_lava.png"},
        groups = {cracky=1},
})
minetest.register_node("skytest:growth_crystal", {
    description = "Growth crystal",
        tiles = {"ant_dirt.png"},
        groups = {cracky=1},
})
minetest.register_craft({
        output = "skytest:growth_crystal",
        recipe = {
            {"skytest:glowstone","skytest:lapis","skytest:glowstone"},
            {"skytest:lapis","group:soil","skytest:lapis"},
            {"skytest:glowstone","skytest:lapis","skytest:glowstone"},
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
	nodenames = {"air"},
	neighbors = {"skytest:cobblegen"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, 

active_object_count_wider)
		minetest.set_node(pos, {name = "default:cobble"})
	end
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
  	                     	rarity = 15,
	
			},{
				items = {'skytest:silk'},
	               	 	tools ={"skytest:silkworm"},
				rarity = 15,
			},{
				items = {'default:sapling'},
	               	 	tools ={"skytest:comp_crook"},
				rarity = 2,
			},{
				items = {'skytest:silkworm'},
	                	tools ={"skytest:comp_crook"},
  	                     	rarity = 2,
	
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
minetest.register_node("skytest:dense_leaves", {
    description = "Dense leaves",
        tiles = {"default_leaves.png"},
        groups = {leaves = 1,snappy = 3},

            })
minetest.register_node("skytest:infested_leaves", {
    description = "Infested leaves",
        tiles = {"default_acacia_leaves.png^default_aspen_leaves.png^default_junglegrass.png^default_grass_4.png^default_junglesapling.png^default_leaves.png^default_papyrus.png^default_pine_needles.png^default_pine_sapling.png"},
        groups = {leaves = 1,snappy = 3},
	drop = {
		max_items = 1,
		items = {{
				items = {'skytest:silk'},
	               	 	tools ={"skytest:crook"},
				rarity = 2,
			},{
				items = {'skytest:silk'},
	                	tools ={"skytest:comp_crook"},
  	                     	rarity = 1,
	
			},{
				items = {'skytest:infested_leaves'},
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

local function accept(stack)
    for _,v in pairs( --these are the items that are accepted as src material
        {'skytest:dust'})
    do
        if stack:get_name() == v then
            return true
        end
    end
    return false
end
local function updateformspec(time) 
    local formspec = "size[8,9;]list[context;src;0,0;1,1;]list[context;fuel;0,3;1,1;]list[context;dst;3,0;5,4;]image[0,1;2,2;sieve_auto_sieve_side.png]list[current_player;main;0,5;8,4;]"
    local imgs = {36,33,30,27,24,21,18,15,12,9,6,3}
    for _,v in pairs(imgs) do
        if time>=v then 
            return formspec.."image[2,1;1,3;sieve_fuel"..v..".png]"
        end
    end
    return formspec.."image[2,1;1,3;sieve_fuel0.png]"
end
local percent = {
--{"itemstack string", exclusive top cuttoff}
--put the list in order from small to large cutoffs (like the original list)
    {"default:diamond 1", 2},
    {"default:mese_crystal 1", 4},
    {"default:mese_crystal_fragment 4", 8},
    {"bushes:strawberry_empty", 10},
    {"bushes:raspberry_empty", 10},
    {"skytest:redstone", 13},
    {"skytest:glowstone", 14},
    {"skytest:lapis", 15},
    {"default:iron_lump 1", 16},
    {"skytest:pine_tree_seeds", 20},
    {"skytest:jungle_tree_seeds", 20},
    {"skytest:acacia_tree_seeds", 20},
    {"skytest:aspen_tree_seeds", 20},
    {"skytest:oak_tree_seeds", 20},
    {"farming_plus:banana_sapling", 20},
    {"farming_plus:cocoa_sapling", 20},
    {"skytest:cactus_seeds", 25},
    {"default:copper_lump 1", 25},
    {"skytest:jungle_tree_seeds", 25},
    {"skytest:papyrus_seeds", 25},
    {"farming_plus:tomato_seed", 30},
    {"farming_plus:rhubarb_seed", 30},
    {"farming_plus:carrot_seed", 30},
    {"morefarming:teosinte", 30},
    {"morefarming:wildcarrot", 30},
    {"crops:tomato_seed", 30},
    {"crops:green_bean_seed", 30},
    {"crops:potato_eyes", 30},
    {"crops:melon_seed", 30},
    {"crops:pumpkin_seed", 30},
    {"crops:corn", 30},
    {"morefarming:carrot", 30},
    {"morefarming:corn", 30},
    {"farming_plus:strawberry_seed", 30},
    {"farming_plus:orange_seed", 30},
    {"farming_plus:potato_seed", 30},
    {"skytest:grass_seeds", 30},
    {"default:gold_lump 1", 35},
    {"farming:seed_wheat", 40},
    {"farming:seed_cotton", 40},
    {"morefarming:seed_wildcarrot", 40},
    {"morefarming:seed_teosinte", 40},
    {"default:coal_lump 1", 45},
    {"default:flint", 48},
    {"tnt:gunpowder", 49},
}
function material()
    local chance = math.random(50)
    for _,v in pairs(percent) do
        if chance<v[2] then
            return ItemStack(v[1])
        end
    end
    return nil
end

minetest.register_node("skytest:hand_sieve", {
    description = "Hand Sieve",
    paramtype = "light",
    tiles = {
    	"sieve_hand_sieve_top.png",
    	"sieve_hand_sieve_bottom.png",
    	"sieve_hand_sieve_side.png",
    	"sieve_hand_sieve_side.png",
    	"sieve_hand_sieve_side.png",
    	"sieve_hand_sieve_side.png"
    },
    groups = {oddly_breakable_by_hand=1},
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0.1875, -0.5, 0.5, 0.19, 0.5}, --top
            {0.5,0.1875,0.5,-0.5,0.5,0.4375},--top
            {-0.5,0.1875,0.5,-0.4375,0.5,-0.5}, --top
            {0.5,0.1875,-0.5,-0.5,0.5,-0.4375}, --top
            {0.5,0.1875,0.5,0.4375,0.5,-0.5}, --top
            {-0.5, -0.5, -0.5, -0.4375, 0.5, -0.4375}, --leg
            {-0.5, -0.5, 0.5, -0.4375, 0.5, 0.4375}, --leg
            {0.5, -0.5, 0.5, 0.4375, 0.5, 0.4375}, --leg
            {0.5, -0.5, -0.5, 0.4375, 0.5, -0.4375}, --leg
        },
    },
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local timer = minetest.get_node_timer(pos)
        if accept(itemstack) and not timer:is_started() then
            itemstack:take_item(1)
            timer:start(3)
            minetest.add_item(pos, material())
            return itemstack
        else
            return nil
        end
    end,
})
minetest.register_node("skytest:auto_sieve", {
    description = "Auto Sieve",
    paramtype = "light",
    tiles = {
        "sieve_auto_sieve_top.png",
        "sieve_auto_sieve_bottom.png",
        "sieve_auto_sieve_side.png",
        "sieve_auto_sieve_side.png",
        "sieve_auto_sieve_side.png",
        "sieve_auto_sieve_side.png"
    },
    is_ground_content = true,
    groups = {choppy = 2, oddly_breakable_by_hand = 2, tubedevice = 1, tubedevice_receiver = 1},
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

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
        "size[8,9;]"..
        "list[context;src;0,0;1,1;]"..
        "list[context;fuel;0,3;1,1;]"..
        "list[context;dst;3,0;5,4;]"..
        "image[0,1;2,2;sieve_auto_sieve_side.png]"..
        "image[2,1;1,3;sieve_fuel0.png]"..
        "list[current_player;main;0,5;8,4;]")
        local inv = meta:get_inventory()
        inv:set_size("src", 1*1)
        inv:set_size("fuel", 1*1)
        inv:set_size("dst", 5*4)
        meta:set_int("fueltime", 0)
    end,

    on_destruct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        for i, item in ipairs(inv:get_list("dst")) do
            minetest.add_item(pos, item)
        end
        minetest.add_item(pos, inv:get_stack("src", 1))
        minetest.add_item(pos, inv:get_stack("fuel", 1))
        minetest.get_node_timer(pos):stop()
    end,
    --Pipeworks Insertion-------------------------------------------------
    tube = {
        insert_object = function(pos, node, stack, direction)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local timer = minetest.get_node_timer(pos)
            local left
            if direction.y==-1 then
                left = inv:add_item("src", stack)
            else
                left = inv:add_item("fuel", stack)
            end

            if not timer:is_started() and inv:get_stack("fuel",1):get_count()>0 and inv:get_stack("src",1):get_count()>0 then
                timer:start(3)
            end
            return left
        end,
        can_insert = function(pos, node, stack, direction)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            if direction.y==-1 then
                return accept(stack) and inv:room_for_item("src", stack)
            else
                return minetest.get_craft_result({method="fuel",width=1,items={stack}}).time > 0 and inv:room_for_item("fuel", stack)
            end
        end,
        connect_sides = {left= 1, right= 1, back= 1, front= 1, bottom= 1, top= 1}
    },
    input_inventory = "dst",
    after_place_node = pipeworks.after_place,
    after_dig_node = pipeworks.after_dig,
    --Manual Insertion-------------------------------------------------
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        return 0
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == 'fuel' then
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time > 0 then
                return stack:get_count()
            else
                return 0
            end
        elseif listname == 'src' then
            if accept(stack) then
                return stack:get_count()
            else
                return 0
            end
        elseif listname == 'dst' then
            return stack:get_count()
        else
            return 0;
        end
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname ~= "dst" then
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local timer = minetest.get_node_timer(pos)
            if not timer:is_started() and inv:get_stack("fuel",1):get_count()>0 and inv:get_stack("src",1):get_count()>0 then
                timer:start(3)
            end
        end
    end,
    on_timer = function(pos, formname, fields, sender)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local timer = minetest.get_node_timer(pos)
        if inv:get_stack("src",1):get_count()>0 and meta:get_int("fueltime")>=3 then
            inv:remove_item("src", inv:get_stack("src",1):take_item(1))
            local reward = material()
            if inv:room_for_item("dst", reward) then
                inv:add_item("dst", reward)
            end
        end
        meta:set_int("fueltime", meta:get_int("fueltime")-3)

        if inv:get_stack("fuel", 1):get_count()>0 and inv:get_stack("src",1):get_count()>0 and meta:get_int("fueltime")<3 then
            meta:set_int("fueltime", minetest.get_craft_result({method="fuel",width=1,items={inv:get_stack("fuel",1)}}).time)
            inv:remove_item("fuel", inv:get_stack("fuel",1):take_item(1))
        end
        meta:set_string("formspec", updateformspec(meta:get_int("fueltime")))
        return meta:get_int("fueltime")>=3
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        return stack:get_count()
    end,
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