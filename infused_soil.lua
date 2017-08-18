minetest.register_node("skytest:magicly_infused_soil", {
	description = "magicly infused soil",
	tiles = {"brilliance_dirt.png"},
	is_ground_content = false,
	groups = {soil=1,oddly_breakable_by_hand=1},
})

minetest.register_craft({
        output = "skytest:magicly_infused_soil",
        recipe = {
            {"default:mese_crystal_fragment","group:soil","default:mese_crystal_fragment"},
            {"default:mese_crystal_fragment","group:soil","default:mese_crystal_fragment"},
            {"default:mese_crystal_fragment","group:soil","default:mese_crystal_fragment"},
        }
    })
minetest.register_craftitem("skytest:magicly_infused_bonemeal", {
	description = "Growth essence",
	inventory_image = "wrathful_soul_fragment.png",
})
minetest.register_craft({
        output = "skytest:magicly_infused_bonemeal 9",
        recipe = {
            {"skytest:blank_seed","skytest:growth_crystal","skytest:blank_seed"},
            {"skytest:growth_crystal","skytest:silkworm","skytest:growth_crystal"},
            {"skytest:blank_seed","skytest:growth_crystal","skytest:blank_seed"},
        }
    })
minetest.register_craft({
        output = "skytest:magicly_infused_soil",
        recipe = {
            {"skytest:enchanted_crystal","group:soil"},
        }
    })
minetest.register_craftitem("skytest:blank_seed", {
	description = "Blank seeds",
	inventory_image = "farming_cotton_seed.png",
})
minetest.register_craft({
        output = "skytest:blank_seed",
        recipe = {
            {"group:seed","skytest:enchanted_crystal","group:seed"},
            {"skytest:enchanted_crystal","group:seed","skytest:enchanted_crystal"},
            {"group:seed","skytest:enchanted_crystal","group:seed"},
        }
    })
for name, data in pairs({
    copper = {
        mat = "default:copper_ingot",
        tex = "copperwood.png",
    },
    steel = {
        mat = "default:steel_ingot",
        tex = "ironwood.png",
    },
    coal = {
        mat = "default:coal_lump",
        tex = "coalwood.png",
    },
    gold = {
        mat = "default:gold_ingot",
        tex = "goldwood.png",
    },
    diamond = {
        mat = "default:diamond",
        tex = "diamondwood.png",
    },
    mese = {
        mat = "default:mese_crystal",
        tex = "mesewood.png",
    },
    glowstone_dust = {
        mat = "skytest:glowstone",
        tex = "glowstone.png",
    },
    redstone_dust = {
        mat = "skytest:redstone",
        tex = "redstone.png",
    },
    lapis_lazuli = {
        mat = "skytest:lapis",
        tex = "lapis.png",
    },
    tin = {
        mat = "default:tin_ingot",
        tex = "default_tin_ingot.png",
    },
}) do
    
minetest.register_node("skytest:"..name.."_infused_soil", {
	description = ""..name.." infused soil",
        _doc_items_usagehelp = "When touching water will slowly grow "..name.." papyrus wich can be broken to drop"..data.mat.."(will grow higher and higher untill broken).",
	tiles = {"brilliance_dirt.png", "brilliance_dirt.png", "brilliance_dirt.png^"..data.tex..""},
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
})      

minetest.register_craft({
        output = "skytest:"..name.."_infused_soil",
        recipe = {
            {data.mat,data.mat,data.mat},
            {data.mat,"skytest:magicly_infused_soil",data.mat},
            {data.mat,data.mat,data.mat},
        }
    })

minetest.register_node("skytest:"..name.."papy", {
	description = ""..name.."papy",
	drawtype = "plantlike",
	stack_max = 999,
	tiles = {"default_papyrus.png^"..data.tex..""},
	inventory_image = data.tex,
	wield_image = data.tex,
	paramtype = "light",
	walkable = false,
	climbable = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {snappy=3,flammable=2},
	sounds = default.node_sound_leaves_defaults(),
        after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
})
minetest.register_craft({
        output = data.mat,
        recipe = {
            {"skytest:"..name.."papy","skytest:"..name.."papy","skytest:"..name.."papy"},
            {"skytest:"..name.."papy","skytest:"..name.."papy","skytest:"..name.."papy"},
            {"skytest:"..name.."papy","skytest:"..name.."papy","skytest:"..name.."papy"},
        }
    })
minetest.register_abm({
	nodenames = {"skytest:"..name.."_infused_soil"},
	neighbors = {"default:water_source"},
	interval = 5,
	chance = 5,
	action = function(pos, node)
	pos.y = pos.y+1
	minetest.set_node(pos, {name="skytest:"..name.."papy"})
	end,
})
minetest.register_abm({
	nodenames = {"skytest:"..name.."papy"},
	neighbors = {"air"},
	interval = 20,
	chance = 20,
	action = function(pos, node)
	pos.y = pos.y+1
	minetest.set_node(pos, {name="skytest:"..name.."papy"})
	return true
end,
})
minetest.register_node("skytest:super_"..name.."_infused_soil", {
	description = ""..name.." infused soil",
        _doc_items_usagehelp = "When touching a growth crystal will rapidly grow "..name.." sprouts wich can be broken to drop"..data.mat.."(will only grow one high).",
	tiles = {"brilliance_grass.png", "brilliance_grass.png", "brilliance_grass.png^"..data.tex..""},
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
})      

minetest.register_craft({
        output = "skytest:super_"..name.."_infused_soil",
        recipe = {
            {"skytest:"..name.."_infused_soil",data.mat,"skytest:"..name.."_infused_soil"},
            {data.mat,"skytest:"..name.."_infused_soil",data.mat},
            {"skytest:"..name.."_infused_soil","skytest:enchanted_block","skytest:"..name.."_infused_soil"},
        }
    })

minetest.register_node("skytest:super_"..name.."_sprout", {
	description = "super "..name.." sprout",
	drop = data.mat,
	drawtype = "plantlike",
	stack_max = 999,
	tiles = {"sprout.png^"..data.tex..""},
	inventory_image = data.tex,
	wield_image = data.tex,
	paramtype = "light",
	walkable = false,
	climbable = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {snappy=3,flammable=2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	nodenames = {"skytest:super_"..name.."_infused_soil"},
	neighbors = {"skytest:growth_crystal"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
	pos.y = pos.y+1
	minetest.set_node(pos, {name="skytest:super_"..name.."_sprout"})
	end,
})



minetest.register_craftitem("skytest:"..name.."_seed", {
	description = name.." seeds",
	inventory_image = "farming_cotton_seed.png",
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "skytest:"..name.."_1")
	end
})

minetest.register_node("skytest:"..name.."_1", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	drop = "",
	tiles = {"special_plant_1.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+5/16, 0.5}
		},
	},
	drop = {
		max_items = 1,
		items = {
			{ items = {'skytest:'..name..'_seed'} }
		}
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1,plant=1},
	sounds = default.node_sound_leaves_defaults(),
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if itemstack:get_name() == "skytest:magicly_infused_bonemeal" then
            minetest.set_node(pos, {name="skytest:"..name})
	    itemstack:take_item(1)
            return itemstack
         end
    end,
})

minetest.register_node("skytest:"..name.."_2", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	drop = "",
	tiles = {"special_plant_2.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+8/16, 0.5}
		},
	},
	drop = {
		max_items = 1,
		items = {
			{ items = {'skytest:'..name..'_seed'} }
		}
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1,plant=1},
	sounds = default.node_sound_leaves_defaults(),
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if itemstack:get_name() == "skytest:magicly_infused_bonemeal" then
            minetest.set_node(pos, {name="skytest:"..name})
	    itemstack:take_item(1)
            return itemstack
         end
    end,
})

minetest.register_node("skytest:"..name.."_3", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	drop = "",
	tiles = {"special_plant_3.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+13/16, 0.5}
		},
	},
	drop = {
		max_items = 1,
		items = {
			{ items = {'skytest:'..name..'_seed'} }
		}
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1,plant=1},
	sounds = default.node_sound_leaves_defaults(),
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if itemstack:get_name() == "skytest:magicly_infused_bonemeal" then
            minetest.set_node(pos, {name="skytest:"..name})
	    itemstack:take_item(1)
            return itemstack
         end
    end,
})

minetest.register_node("skytest:"..name, {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	tiles = {"special_plant_4.png^"..data.tex..""},
	drop = {
		max_items = 1,
		items = {
			{ items = {'skytest:'..name..'_seed'} }
		}
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1,plant=1},
	sounds = default.node_sound_leaves_defaults(),
	on_rightclick = function(pos, node)
		minetest.set_node(pos, {name="skytest:"..name.."_1"})
		pos.y = pos.y + 0.5
		minetest.add_item(pos, "skytest:"..name.."_essence")
	end,
})

minetest.register_craftitem("skytest:"..name.."_essence", {
	description = name.." essence",
	inventory_image = data.tex.."^special_plant_essence.png",
})

minetest.register_craft({
        output = data.mat,
        recipe = {
            {"skytest:"..name.."_essence","skytest:"..name.."_essence"},
            {"skytest:"..name.."_essence","skytest:"..name.."_essence"}
            }
    })
minetest.register_craft({
        output = "skytest:"..name.."_seed",
        recipe = {
            {"skytest:blank_seed",data.mat,"skytest:blank_seed"},
            {data.mat,"skytest:enchanted_block",data.mat},
            {"skytest:blank_seed",data.mat,"skytest:blank_seed"},
        }
    })
farming.add_plant("skytest:"..name, {"skytest:"..name.."_1", "skytest:"..name.."_2", "skytest:"..name.."_3"}, 5, 5)
end