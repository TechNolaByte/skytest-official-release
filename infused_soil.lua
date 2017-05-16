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
}) do
    
minetest.register_node("skytest:"..name.."_infused_soil", {
	description = ""..name.." infused soil",
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
	drop = data.mat,
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
	interval = 5,
	chance = 5,
	action = function(pos, node)
	pos.y = pos.y+1
	minetest.set_node(pos, {name="skytest:"..name.."papy"})
	return true
end,
})
minetest.register_node("skytest:super_"..name.."_infused_soil", {
	description = ""..name.." infused soil",
	tiles = {"brilliance_grass.png", "brilliance_grass.png", "brilliance_grass.png^"..data.tex..""},
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
})      

minetest.register_craft({
        output = "skytest:super_"..name.."_infused_soil",
        recipe = {
            {"skytest:"..name.."_infused_soil",data.mat,"skytest:"..name.."_infused_soil"},
            {data.mat,"skytest:"..name.."_infused_soil",data.mat},
            {"skytest:"..name.."_infused_soil","skytest:cobblegen","skytest:"..name.."_infused_soil"},
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

end