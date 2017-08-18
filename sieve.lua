local percentdirt = {
    {"skytest:strawberrybush_seeds", 1},
    {"skytest:raspberrybush_seeds", 2},
    {"skytest:pine_tree_seeds", 3},
    {"skytest:pebble 7", 4},
    {"skytest:acacia_tree_seeds", 5},
    {"skytest:aspen_tree_seeds", 6},
    {"skytest:oak_tree_seeds", 7},
    {"farming_plus:banana_sapling", 8},
    {"farming_plus:cocoa_sapling", 9},
    {"skytest:jungle_tree_seeds", 10},
    {"skytest:cactus_seeds", 11},
    {"skytest:papyrus_seeds", 12},
    {"farming_plus:tomato_seed", 13},
    {"farming_plus:rhubarb_seed", 14},
    {"skytest:pebble 3", 16},
    {"farming_plus:carrot_seed", 17},
    {"crops:tomato_seed", 18},
    {"crops:green_bean_seed", 19},
    {"crops:potato_eyes", 20},
    {"crops:melon_seed", 20},
    {"crops:pumpkin_seed", 22},
    {"crops:corn", 23},
    {"skytest:pebble 2", 24},
    {"morefarming:seed_corn", 25},
    {"farming_plus:strawberry_seed", 26},
    {"farming_plus:orange_seed", 27},
    {"farming_plus:potato_seed", 28},
    {"skytest:grass_seeds", 29},
    {"farming:seed_wheat", 30},
    {"farming:seed_cotton", 31},
    {"morefarming:seed_wildcarrot", 32},
    {"morefarming:seed_teosinte", 33},
}
local percentgravel = {
    {"skytest:diamond_chunks", 5},
    {"default:mese_crystal_fragment 3", 7},
    {"skytest:gold_ore_chunks", 9},
    {"skytest:lapis", 11},
    {"skytest:redstone", 13},
    {"skytest:glowstone", 15},
    {"skytest:tin_ore_chunks", 17},
    {"skytest:copper_ore_chunks", 19},
    {"skytest:iron_ore_chunks", 24},
    {"default:coal_lump", 28},
    {"default:flint", 34},
}
function gravel()
    local chance = math.random(40)
    for _,v in pairs(percentgravel) do
        if chance<v[2] then
            return ItemStack(v[1])
        end
    end
    return nil
end
function dirt()
    local chance = math.random(35)
    for _,v in pairs(percentdirt) do
        if chance<v[2] then
            return ItemStack(v[1])
        end
    end
    return nil
end
minetest.register_node("skytest:hand_sieve", {
    description = "Hand Sieve",
    _doc_items_usagehelp = "Use to manuly sift dirt, sand, gravel, or dust. Dirt will always drop 1 pebble and may drop one item from this list(rarest to most common):(skytest:strawberrybush_seeds,skytest:raspberrybush_seeds, skytest:pine_tree_seeds, skytest:pebble 7, skytest:acacia_tree_seeds, skytest:aspen_tree_seeds,skytest:oak_tree_seeds,farming_plus:banana_sapling, farming_plus:cocoa_sapling,skytest:jungle_tree_seeds,skytest:cactus_seeds,skytest:papyrus_seeds,farming_plus:tomato_seed, farming_plus:rhubarb_seed, skytest:pebble 3,farming_plus:carrot_seed, crops:tomato_seed, crops:green_bean_seed,crops:potato_eyes, crops:melon_seed, crops:pumpkin_seed, crops:corn,skytest:pebble 2, morefarming:seed_corn, farming_plus:strawberry_seed, farming_plus:orange_seed,  farming_plus:potato_seed, skytest:grass_seeds, farming:seed_wheat, farming:seed_cotton, morefarming:seed_wildcarrot, morefarming:seed_teosinte) gravel will drop 1 item from this list(listed rarest to most common):(skytest:diamond_chunks,default:mese_crystal_fragment 3,skytest:gold_chunks,skytest:lapis,skytest:redstone,skytest:glowstone,skytest:iron_chunks,default:copper_lump,default:coal_lump,default:flint) sand will drop 2 items from the previous list, dust will drop 3. Growth crystals can be sieved and are equevelent to 2 gravel and 2 dirt.",
    paramtype = "light",
    tiles = {
    	"sieve_hand_sieve_top.png",
    	"sieve_hand_sieve_bottom.png",
    	"default_wood.png",
    	"default_wood.png",
    	"default_wood.png",
    	"default_wood.png"
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
        if itemstack:get_name() == "skytest:dust" and not timer:is_started() then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            timer:start(2)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            return itemstack
         end
      	if itemstack:get_name() == "default:dirt" and not timer:is_started() then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            timer:start(2)
            minetest.add_item(pos, dirt())
	    minetest.add_item(pos, "skytest:pebble")
            return itemstack
  	end
	if itemstack:get_name() == "default:gravel" and not timer:is_started() then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            timer:start(2)
            minetest.add_item(pos, gravel())
            return itemstack
  	end
	if itemstack:get_name() == "default:sand" and not timer:is_started() then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            timer:start(2)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            return itemstack
  	end
        if itemstack:get_name() == "skytest:growth_crystal" and not timer:is_started() then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            timer:start(2)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, dirt())
            minetest.add_item(pos, dirt())
            return itemstack
  	end
    end,
    drop = { 
        max_items = 1,
        items = {{
            items = {"skytest:empty_sieve","skytest:mesh"},
	},}
    }
})
minetest.register_node("skytest:empty_sieve", {
    description = "Empty Sieve",
    paramtype = "light",
    tiles = {
    	"default_wood.png",
    	"default_wood.png",
    	"default_wood.png",
    	"default_wood.png"
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
        if itemstack:get_name() == "skytest:mesh" then
            minetest.set_node(pos, {name="skytest:hand_sieve"})
	    itemstack:take_item(1)
            return itemstack
         end
    end,
})
minetest.register_node("skytest:auto_sieve", {
    description = "Auto Sieve",
    _doc_items_usagehelp = "Use to instantly sift dirt, sand, gravel, or dust. Dirt will always drop 1 pebble and may drop two item from this list(rarest to most common):(skytest:strawberrybush_seeds,skytest:raspberrybush_seeds, skytest:pine_tree_seeds, skytest:pebble 7, skytest:acacia_tree_seeds, skytest:aspen_tree_seeds,skytest:oak_tree_seeds,farming_plus:banana_sapling, farming_plus:cocoa_sapling,skytest:jungle_tree_seeds,skytest:cactus_seeds,skytest:papyrus_seeds,farming_plus:tomato_seed, farming_plus:rhubarb_seed, skytest:pebble 3,farming_plus:carrot_seed, crops:tomato_seed, crops:green_bean_seed,crops:potato_eyes, crops:melon_seed, crops:pumpkin_seed, crops:corn,skytest:pebble 2, morefarming:seed_corn, farming_plus:strawberry_seed, farming_plus:orange_seed,  farming_plus:potato_seed, skytest:grass_seeds, farming:seed_wheat, farming:seed_cotton, morefarming:seed_wildcarrot, morefarming:seed_teosinte) gravel will drop 2 item from this list(listed rarest to most common):(skytest:diamond_chunks,default:mese_crystal_fragment 3,skytest:gold_chunks,skytest:lapis,skytest:redstone,skytest:glowstone,skytest:iron_chunks,default:copper_lump,default:coal_lump,default:flint) sand will drop 4 items from the previous list, dust will drop 6. Growth crystals can be sieved and are equevelent to 4 gravel and 4 dirt.",
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
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if itemstack:get_name() == "skytest:dust" then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            return itemstack
         end
      	if itemstack:get_name() == "default:dirt" then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            minetest.add_item(pos, dirt())
            minetest.add_item(pos, dirt())
	    minetest.add_item(pos, "skytest:pebble")
            return itemstack
  	end
	if itemstack:get_name() == "default:gravel" then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            return itemstack
  	end
	if itemstack:get_name() == "default:sand" then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            return itemstack
  	end
        if itemstack:get_name() == "skytest:growth_crystal" then
            pos.y = pos.y + 0.5
	    itemstack:take_item(1)
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, gravel())
            minetest.add_item(pos, dirt())
            minetest.add_item(pos, dirt())
            minetest.add_item(pos, dirt())
            minetest.add_item(pos, dirt())
            return itemstack
  	end
    end,
          
})
--Shaker Motor
minetest.register_craftitem("skytest:shaker_motor", {
    description = "Shaker Motor",
    inventory_image = "sieve_shaker_motor.png",
    })
--Shaker Frame
minetest.register_craftitem("skytest:shaker_frame", {
    description = "Shaker Frame",
    inventory_image = "sieve_shaker_frame.png",
    })
--Auto Top
minetest.register_craftitem("skytest:auto_sieve_top", {
    description = "Auto Sieve Top",
    inventory_image = "sieve_auto_top.png",
})
minetest.register_craft({
    output = "skytest:shaker_motor 2",
    recipe = {
        {"", "",""},
        {"default:cobble", "default:steel_ingot","default:cobble"},
        {"default:cobble", "default:copper_ingot","default:cobble"},
    }
})
minetest.register_craft({
    output = "skytest:shaker_frame 1",
    recipe = {
        {"default:steel_ingot", "skytest:shaker_motor","default:steel_ingot"},
        {"skytest:shaker_motor", "default:furnace","skytest:shaker_motor"},
        {"default:steel_ingot", "skytest:shaker_motor","default:steel_ingot"},
    }
})
--Auto Legs
minetest.register_craftitem("skytest:auto_sieve_legs", {
    description = "Auto Sieve Legs",
    inventory_image = "sieve_auto_legs.png",
})
minetest.register_craft({
    output = "skytest:auto_sieve_top",
    recipe = {
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
        {"default:steel_ingot", "skytest:mesh", "default:steel_ingot"},
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
    }
})
minetest.register_craft({
    output = "skytest:auto_sieve_legs",
    recipe = {
        {"default:steel_ingot", "skytest:shaker_frame", "default:steel_ingot"},
        {"default:steel_ingot", "", "default:steel_ingot"}
    }
})
minetest.register_craft({
    output = "skytest:auto_sieve",
    recipe = {
        {"skytest:auto_sieve_top"},
        {"skytest:auto_sieve_legs"}
    }
})