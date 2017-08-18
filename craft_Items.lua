minetest.register_craftitem("skytest:cloth_fiber", {
	description = "Cloth Fiber",
    inventory_image = "sieve_cloth_fiber.png",
	})
minetest.register_craft({
        output = "skytest:enchanted_fiber",
        recipe = {
            {"skytest:silk","skytest:silk","skytest:silk"},
            {"skytest:silk","skytest:enchanted_block","skytest:silk"},
            {"skytest:silk","skytest:silk","skytest:silk"},
        }
    })
minetest.register_craft({
        output = "skytest:enchanted_fabric",
        recipe = {
            {"skytest:enchanted_fiber","skytest:enchanted_fiber","skytest:enchanted_fiber"},
            {"skytest:enchanted_fiber","skytest:enchanted_fiber","skytest:enchanted_fiber"},
            {"skytest:enchanted_fiber","skytest:enchanted_fiber","skytest:enchanted_fiber"},
        }
    })
minetest.register_craftitem("skytest:enchanted_fiber", {
	description = "Enchanted Fiber",
    inventory_image = "5.png",
	})
minetest.register_craftitem("skytest:enchanted_fabric", {
	description = "Enchanted Fabric",
    inventory_image = "2.png",
	})
minetest.register_craftitem("skytest:enchanted_crystal", {
	description = "Enchanted crystal",
    inventory_image = "enchanted_crystal.png",
	})
minetest.register_craftitem("skytest:pebble", {
	description = "Pebble",
        _doc_items_usagehelp = "Obtained from sifting dirt.",
	inventory_image = "pebble.png",
	})
minetest.register_craftitem("skytest:grass_seeds", {
        description = "Grass seeds",
        _doc_items_usagehelp = "Use to turn dirt into grass.",
        inventory_image = "farming_cotton_seed.png",
        on_use = function(itemstack, user, pointed_thing)
			  if minetest.get_node(pointed_thing.under).name == "default:dirt" then
				minetest.set_node(pointed_thing.under, {name = "default:dirt_with_grass"})
				itemstack:take_item()
				return itemstack
			end
	end,
    })
minetest.register_craftitem("skytest:silk", {
    description = "Silk",
    _doc_items_usagehelp = "Obtained from mining infested leaves with a crook or compressed crook.",
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
    jungle_tree_seeds = {
        mat = "default:junglesapling",
	tex = "farming_cotton_seed.png",
    },
    aspen_tree_seeds = {
        mat = "default:aspen_sapling",
	tex = "farming_cotton_seed.png",
    },
    acacia_tree_seeds = {
        mat = "default:acacia_sapling",
        tex = "farming_cotton_seed.png",
    },
    pine_tree_seeds = {
        mat = "default:pine_sapling",
	tex = "farming_cotton_seed.png",
    },
    oak_tree_seeds = {
        mat = "default:sapling",
	tex = "farming_cotton_seed.png",
    },
    papyrus_seeds = {
        mat = "default:papyrus",
	tex = "bamboo_sprout.png",
    },
    cactus_seeds = {
        mat = "default:cactus",
	tex = "uranium_lump.png",
    },
    strawberrybush_seeds = {
        mat = "bushes:strawberry_empty",
	tex = "redseed.png",
    },
    raspberrybush_seeds = {
        mat = "bushes:raspberry_empty",
	tex = "redseed.png",
    },
    iron_ore_chunks = {
        mat = "default:iron_lump",
	tex = "iron_chunks.png",
    },
    diamond_chunks = {
        mat = "default:diamond",
	tex = "diamond_chunks.png",
    },
    gold_ore_chunks = {
        mat = "default:gold_lump",
	tex = "gold_chunks.png",
    },
    tin_ore_chunks = {
        mat = "default:tin_lump",
	tex = "tin_chunks.png",
    },
    copper_ore_chunks = {
        mat = "default:copper_lump",
	tex = "copper_chunks.png",
    },
}) do
minetest.register_craftitem("skytest:"..name.."", {
	description = ""..name.."",
        _doc_items_usagehelp = "craft in a 2x2 to get "..data.mat..".",
	inventory_image = data.tex,
})
minetest.register_craft({
        output = data.mat,
        recipe = {
            {"skytest:"..name.."","skytest:"..name.."",""},
            {"skytest:"..name.."","skytest:"..name.."",""},
            {"","",""},
        }
    })
end
-- Mesh
minetest.register_craftitem("skytest:mesh", {
	description = "Fiber Mesh",
    _doc_items_usagehelp = "Use on empty sieve to turn it into a sieve.",
    inventory_image = "sieve_mesh.png",
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
        output = "skytest:mesh",
        recipe = {
            {"group:wood","skytest:cloth_fiber","group:wood"},
            {"skytest:cloth_fiber","skytest:silk_mesh","skytest:cloth_fiber"},
            {"group:wood","skytest:cloth_fiber","group:wood"},
        }
    })
minetest.register_craft({
    output = "skytest:empty_sieve",
    recipe = {
        {"group:wood", "", "group:wood"},
        {"group:wood", "group:stick", "group:wood"},
        {"group:stick", "", "group:stick"}
    }
})
minetest.register_craft({
    output = "skytest:enchanted_crystal",
    recipe = {
            {"skytest:glowstone","skytest:redstone","skytest:lapis"},
            {"skytest:glowstone","skytest:lapis","skytest:glowstone"},
            {"skytest:lapis","skytest:redstone","skytest:glowstone"},
    }
})
minetest.register_craft({
    output = "skytest:enchanted_crystal 9",
    recipe = {
            {"skytest:glowstone_block","skytest:redstone_block","skytest:lapis_block"},
            {"skytest:glowstone_block","skytest:lapis_block","skytest:glowstone_block"},
            {"skytest:lapis_block","skytest:redstone_block","skytest:glowstone_block"},
    }
})
minetest.register_craft({
    output = "skytest:enchanted_crystal 9",
    recipe = {
            {"skytest:enchanted_block"},
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
minetest.register_craftitem("skytest:cooked_silkworm", {
        description = "Rosted silkworm",
        _doc_items_usagehelp = "can be eaten",
        inventory_image = "silkworm.png",
	on_use = minetest.item_eat(2),
    })

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "skytest:cooked_silkworm",
	recipe = "skytest:silkworm"
})
