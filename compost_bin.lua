compost = {}
compost.compostable_groups = {"flora", "leaves", "flower", "sapling"}
compost.compostable_nodes = {
	"default:cactus",
	"default:papyrus",
	"default:dry_shrub",
	"default:junglegrass",
	"default:grass_1",
	"default:dry_grass_1",
	"farming:wheat",
	"farming:straw",
	"farming:cotton",
	"skytest:silk",
	"skytest:silkworm",
}
compost.compostable_items = {}
for _, v in pairs(compost.compostable_nodes) do
	compost.compostable_items[v] = true
end
local function is_compostable(input)
	if compost.compostable_items[input] then
		return true
	end
	for _, v in pairs(compost.compostable_groups) do
		if minetest.get_item_group(input, v) > 0 then
			return true
		end
	end
	return false
end
compost.press_groups = {"leaves"}
compost.press_nodes = {
	"default:cactus",
}
compost.press_items = {}
for _, v in pairs(compost.press_nodes) do
	compost.press_items[v] = true
end
local function is_pressable(input)
	if compost.press_items[input] then
		return true
	end
	for _, v in pairs(compost.press_groups) do
		if minetest.get_item_group(input, v) > 0 then
			return true
		end
	end
	return false
end

for name, data in pairs({
    jungle = {
        mat = "default:junglewood",
	tex = "default_junglewood.png",
    },
    aspen = {
        mat = "default:aspen_wood",
	tex = "default_aspen_wood.png",
    },
    acacia = {
        mat = "default:acacia_wood",
        tex = "default_acacia_wood.png",
    },
    pine = {
        mat = "default:pine_wood",
	tex = "default_pine_wood.png",
    },
    oak = {
        mat = "default:wood",
	tex = "default_wood.png",
    },
}) do
minetest.register_craft({
        output = "skytest:"..name.."_wood_barrel_empty",
        recipe = {
            {data.mat,"",data.mat},
            {data.mat,"group:leaves",data.mat},
            {data.mat,data.mat,data.mat},
        }
    })
minetest.register_craft({
        output = "skytest:"..name.."_wood_barrel_empty",
        recipe = {
            {data.mat,"",data.mat},
            {data.mat,"group:flower",data.mat},
            {data.mat,data.mat,data.mat},
        }
    })
minetest.register_craft({
        output = "skytest:"..name.."_wood_barrel_empty",
        recipe = {
            {data.mat,"",data.mat},
            {data.mat,"group:sapling",data.mat},
            {data.mat,data.mat,data.mat},
        }
    })
minetest.register_craft({
        output = "skytest:"..name.."_wood_barrel_empty",
        recipe = {
            {data.mat,"",data.mat},
            {data.mat,"group:flora",data.mat},
            {data.mat,data.mat,data.mat},
        }
    })
minetest.register_node("skytest:"..name.."_wood_barrel_empty", {
	description = "Empty "..name.." barrel",
        _doc_items_usagehelp = "Fill with 8(default:cactus,default:papyrus,default:dry_shrub,default:junglegrass,default:grass_1,default:dry_grass_1,farming:wheat,farming:straw,farming:cotton,skytest:silk,skytest:silkworm(group:flora,group:leaves,group:sapling,group:flower)) to start composting. When composting finishes rightclick to get 1 dirt. OR use leafe press on a  empty barrel then fill with 8 (default:cactus(group:leaves)) to start pressing. Once finished pressing use a empty bucket or wooden bucket to get water.",
	tiles = {
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5},
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5},
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375},
		},
	},
	paramtype = "light",
	is_ground_content = false,
        groups = {oddly_breakable_by_hand=1},
	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin1_8"})
	   	 itemstack:take_item(1)
            	 return itemstack		
	end
         if itemstack:get_name() == "skytest:leaf_weight" then
		 minetest.set_node(pos, {name="skytest:"..name.."_wood_press_empty"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
	  if itemstack:get_name() == "skytest:bucket_wood_water" then
            minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible_full"})
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "skytest:bucket_wood_empty")
            return itemstack
  	end  
	  if itemstack:get_name() == "bucket:bucket_water" then
            minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible_full"})
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "bucket:bucket_empty")
            return itemstack
  	end  
end,
})
minetest.register_node("skytest:"..name.."_wood_press_empty", {
	description = "",
	tiles = {
		data.tex.."^default_stone.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5},
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5},
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375},
		},
	},
	paramtype = "light",
	is_ground_content = false,
	drop = "skytest:"..name.."_wood_barrel_empty",
        groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},
	on_rightclick = function(pos, node, clicker, itemstack)
         if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible1_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
 
end,
})
minetest.register_node("skytest:"..name.."_compostbin1_8", {
	description = "",
        tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
        node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
			if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin2_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin2_8", {
	description = "",
	tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
        drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		minetest.set_node(pos, {name="skytest:"..name.."_compostbin3_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin3_8", {
	description = "",
	tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.0625, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin4_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		

	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin4_8", {
	description = "",
	tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
  	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin5_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		

	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin5_8", {
	description = "",
	tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.1875, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin6_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		

	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin6_8", {
	description = "",
	tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.3125, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin7_8"})
	   	 itemstack:take_item(1)
            	 return itemstack

	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin7_8", {
	description = "",
	tiles = {
		data.tex.."^compost.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_compostable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_compostbin8_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
    end,
})
minetest.register_node("skytest:"..name.."_compostbin8_8", {
	description = "",
	tiles = {{name="compost2.png",animation={type="vertical_frames", length=32.5}},
		data.tex},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),
        on_construct = function(pos, node, player)
        local timer = minetest.get_node_timer(pos)
        timer:start(32)
end,
on_timer = function(pos, node)
        minetest.set_node(pos, {name="skytest:"..name.."_compostbin_full"})
end,
})
minetest.register_node("skytest:"..name.."_compostbin_full", {
	description = "",
	tiles = {
		data.tex.."^compostfull.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing, clicker)
	    minetest.set_node(pos, {name="skytest:"..name.."_wood_barrel_empty"})
	    pos.y = pos.y + 0.5
            minetest.add_item(pos, "default:dirt")
            return itemstack
    end,
})















minetest.register_node("skytest:"..name.."_woodcrucible1_8", {
	description = "",
        tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
        node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
			if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible2_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible2_8", {
	description = "",
	tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
        drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_pressable(itemstack:get_name()) then
		minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible3_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible3_8", {
	description = "",
	tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.0625, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible4_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		

	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible4_8", {
	description = "",
	tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
  	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible5_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		

	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible5_8", {
	description = "",
	tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.1875, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible6_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		

	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible6_8", {
	description = "",
	tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.3125, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible7_8"})
	   	 itemstack:take_item(1)
            	 return itemstack

	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible7_8", {
	description = "",
        tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
	 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},

	on_rightclick = function(pos, node, clicker, itemstack)
		if is_pressable(itemstack:get_name()) then
		 minetest.set_node(pos, {name="skytest:"..name.."_woodcrucible8_8"})
	   	 itemstack:take_item(1)
            	 return itemstack
		
	end
    end,
})
minetest.register_node("skytest:"..name.."_woodcrucible8_8", {
	description = "",
        tiles = {
		data.tex.."^leaves.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),
        on_construct = function(pos, node, player)
        local timer = minetest.get_node_timer(pos)
        timer:start(32)
end,
on_timer = function(pos, node)
minetest.set_node(pos, {name = "skytest:"..name.."_woodcrucible_full"})
end,
})
minetest.register_node("skytest:"..name.."_woodcrucible_full", {
	description = "",
	tiles = {
		data.tex.."^water.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing, clicker)
	  if itemstack:get_name() == "skytest:bucket_wood_empty" then
            minetest.set_node(pos, {name="skytest:"..name.."_wood_barrel_empty"})
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "skytest:bucket_wood_water")
            return itemstack
  	end  
	  if itemstack:get_name() == "bucket:bucket_empty" then
            minetest.set_node(pos, {name="skytest:"..name.."_wood_barrel_empty"})
	    pos.y = pos.y + 0.5
	   	 itemstack:take_item(1)
            minetest.add_item(pos, "bucket:bucket_water")
            return itemstack
  	end  
          if itemstack:get_name() == "skytest:dust" then
            minetest.set_node(pos, {name="skytest:"..name.."_wood_barrel_clay"})
	   	 itemstack:take_item(1)
            return itemstack
  	end  
    end,
})
minetest.register_node("skytest:"..name.."_wood_barrel_clay", {
	description = "",
	tiles = {
		data.tex.."^claybarrel.png",
		data.tex,
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, -0.375, 0.5, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.375}, -- NodeBox7
		},
	},
	paramtype = "light",
	drop = "skytest:"..name.."_wood_barrel_empty",
 groups = {oddly_breakable_by_hand=1, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing, clicker)
            minetest.set_node(pos, {name="skytest:"..name.."_wood_barrel_empty"})
	    pos.y = pos.y + 0.5
            minetest.add_item(pos, "default:clay")
    end,
})
end
