
minetest.register_craftitem("skytest:cloth_fiber", {
	description = "Cloth Fiber",
    inventory_image = "sieve_cloth_fiber.png",
	})
minetest.register_craftitem("skytest:pebble", {
	description = "Pebble",
	inventory_image = "pebble.png",
	})
minetest.register_tool("skytest:grass_seeds", {
        description = "Grass seeds",
        inventory_image = "farming_cotton_seed.png",
        on_use = function(itemstack, user, pointed_thing)
			  if minetest.get_node(pointed_thing.under).name == "group:soil" then
				minetest.set_node(pointed_thing.under, {name = "default:dirt_with_grass"})
				itemstack:take_item()
				return itemstack
			end
	end,
	stack_max = 99,
    })
minetest.register_craftitem("skytest:silk", {
    description = "Silk",
    inventory_image = "silk.png",
})
minetest.register_craftitem("skytest:silk_mesh", {
    description = "Silk mesh",
    inventory_image = "silk_mesh.png",
})
minetest.register_craft({
        output = "skytest:silk_mesh",
        recipe = {
            {"skytest:silk","skytest:silk","skytest:silk"},
            {"skytest:silk","default:stick","skytest:silk"},
            {"skytest:silk","skytest:silk","skytest:silk"},
        }
    })
minetest.register_craft({
        output = "farming:cotton 2",
        recipe = {
            {"skytest:silk","",""},
            {"","",""},
            {"","",""},
        }
    })
for name, data in pairs({
    jungle_tree = {
        mat = "default:junglesapling",
	tex = "farming_cotton_seed.png",
    },
    aspen_tree = {
        mat = "default:aspen_sapling",
	tex = "farming_cotton_seed.png",
    },
    acacia_tree = {
        mat = "default:acacia_sapling",
        tex = "farming_cotton_seed.png",
    },
    pine_tree = {
        mat = "default:pine_sapling",
	tex = "farming_cotton_seed.png",
    },
    oak_tree = {
        mat = "default:sapling",
	tex = "farming_cotton_seed.png",
    },
    papyrus = {
        mat = "default:papyrus",
	tex = "bamboo_sprout.png",
    },
    cactus = {
        mat = "default:cactus",
	tex = "uranium_lump.png",
    },
}) do
minetest.register_craftitem("skytest:"..name.."_seeds", {
	description = ""..name.." seeds",
	inventory_image = data.tex,
})
minetest.register_craft({
        output = data.mat,
        recipe = {
            {"skytest:"..name.."_seeds","skytest:"..name.."_seeds",""},
            {"skytest:"..name.."_seeds","skytest:"..name.."_seeds",""},
            {"","",""},
        }
    })
end
-- Mesh
minetest.register_craftitem("skytest:mesh", {
	description = "Fiber Mesh",
    inventory_image = "sieve_mesh.png",
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
--Auto Legs
minetest.register_craftitem("skytest:auto_sieve_legs", {
    description = "Auto Sieve Legs",
    inventory_image = "sieve_auto_legs.png",
})


minetest.register_craft({
    output = "skytest:cloth_fiber",
    recipe = {
        {"default:leaves", "", "default:leaves"},
        {"", "default:wood", ""},
        {"default:leaves", "", "default:leaves"}
    }
})
minetest.register_craft({
        output = "default:cobble",
        recipe = {
            {"skytest:pebble","skytest:pebble",""},
            {"skytest:pebble","skytest:pebble",""},
            {"","",""},
        }
    })
minetest.register_craft({
        output = "skytest:pebble",
        recipe = {
            {"default:dirt","",""},
            {"","",""},
            {"","",""},
        }
    })
minetest.register_craft({
        output = "skytest:mesh",
        recipe = {
            {"group:wood","skytest:cloth_fiber","group:wood"},
            {"skytest:cloth_fiber","skytest:silk_mesh","skytest:cloth_fiber"},
            {"group:wood","skytest:cloth_fiber","group:wood"},
        }
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
minetest.register_craft({
    output = "skytest:hand_sieve",
    recipe = {
        {"group:stick", "group:stick", "group:stick"},
        {"group:wood", "skytest:mesh", "group:wood"},
        {"group:wood", "group:wood", "group:wood"}
    }
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
minetest.register_craftitem("skytest:redstone", {
	description = "Redstone",
	inventory_image = "redstone.png",
})
minetest.register_craftitem("skytest:lapis", {
	description = "Lapis Lazuli",
	inventory_image = "lapis.png",
})

minetest.register_craftitem("skytest:glowstone", {
	description = "Glowstone Dust",
	inventory_image = "glowstone.png",
})


minetest.register_craft({
	output = 'skytest:redstone_block',
	recipe = {
		{'skytest:redstone', 'skytest:redstone', 'skytest:redstone'},
		{'skytest:redstone', 'skytest:redstone', 'skytest:redstone'},
		{'skytest:redstone', 'skytest:redstone', 'skytest:redstone'},
	}
})

minetest.register_craft({
	output = 'skytest:redstone 9',
	recipe = {
		{'skytest:redstone_block'},
	}
})
minetest.register_craft({
	output = 'skytest:lapis_block',
	recipe = {
		{'skytest:lapis', 'skytest:lapis', 'skytest:lapis'},
		{'skytest:lapis', 'skytest:lapis', 'skytest:lapis'},
		{'skytest:lapis', 'skytest:lapis', 'skytest:lapis'},
	}
})

minetest.register_craft({
	output = 'skytest:lapis 9',
	recipe = {
		{'skytest:lapis_block'},
	}
})


minetest.register_craft({
	output = 'skytest:glowstone_block',
	recipe = {
		{'skytest:glowstone', 'skytest:glowstone'},
		{'skytest:glowstone', 'skytest:glowstone'},
	}
})