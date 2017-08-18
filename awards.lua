if(minetest.get_modpath("awards")~=nil) then
minetest.register_entity("skytest:achevement_book_open", {
	visual = "sprite",
	visual_size = {x=0.75, y=0.75},
	collisionbox = {0},
	physical = false,
	textures = {"book_open.png"},
	on_activate = function(self)
		local pos = self.object:getpos()
		local pos_under = {x=pos.x, y=pos.y-1, z=pos.z}

		if minetest.get_node(pos_under).name ~= "skytest:achevement_stand" then
			self.object:remove()
		end
	end
})

minetest.register_node("skytest:achevement_stand", {
    description = "Achevement stand",
    tiles = {"a_standtb.png",  "a_standtb.png",
		 "a_standsides.png", "a_standsides.png",
		 "a_standsides.png", "a_standsides.png"},
    groups = {choppy = 1},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	  local name = player:get_player_name()
	  awards.show_to(name, name, nil, false)
end,
	on_construct = function(pos)
          minetest.add_entity({x=pos.x, y=pos.y+0.85, z=pos.z}, "skytest:achevement_book_open")
end,
       on_destruct = function(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.9)) do
		if obj:get_luaentity().name == "skytest:achevement_book_open" then
			obj:remove()
			break
		end
	end
end,
})

minetest.register_craft({
    output = "skytest:achevement_stand",
    recipe = {
        {"group:wood", "group:wood", "group:wood"},
        {"group:wood", "default:book", "group:wood"},
        {"group:wood", "group:wood", "group:wood"}
    }
})

awards.register_achievement("skytest:first_craft",{
		secret = true,
		title = "First craft",
		description = "Learn how to craft.",
		icon = "awards_craft.png",
		trigger = {
			type = "craft",
			target = 1
		}
})
awards.register_achievement("skytest:first_block_mined",{
		secret = true,
		title = "First block mined",
		description = "Learn how to mine.",
		icon = "awards_miniminer.png",
		trigger = {
		type = "dig",
		target = 1
	}
})
awards.register_achievement("skytest:first_block_placed",{
		secret = true,
		title = "First block placed",
		description = "Learn how to place blocks.",
		icon = "awards_novicebuilder.png",
		trigger = {
		type = "place",
		target = 1
	}
})

awards.register_achievement("skytest:first_death",{
		secret = true,
		title = "First death",
		description = "Learn how to Die ;)",
		icon = "bones_bottom.png^skull.png",
		trigger = {
		type = "death",
		target = 1
	}
})
awards.register_achievement("skytest:first_join",{
		secret = true,
		title = "Its a whole new world...",
		description = "Hello world.",
		icon = "star.png",
		trigger = {
		type = "join",
		target = 1
	}
})
awards.register_achievement("skytest:first_food",{
		secret = true,
		title = "Yummy!",
		description = "Eat something.",
		icon = "bread_icon.png",
		trigger = {
		type = "eat",
		target = 1
	}
})



awards.register_achievement("skytest:expand_platform",{
		title = "Elbow room",
		description = "Expand your platform",
		icon = "default_wood.png",
		trigger = {
		type = "place",
		target = 24
	}
})
awards.register_achievement("skytest:craft_crook",{
		title = "Crook",
		description = "Craft a crook",
		icon = "ant_hoe.png",
		trigger = {
		type = "craft",
		item = "skytest:crook",
		target = 1
	}
})
awards.register_achievement("skytest:craft_compressed_crook",{
		title = "Compressed Crook",
		description = "Craft a compressed crook",
		icon = "ant_hoe.png",
		trigger = {
		type = "craft",
		item = "skytest:comp_crook",
		target = 1
	}
})
awards.register_achievement("skytest:craft_wooden_bucket",{
		title = "Wooden Bucket",
		description = "Craft a wooden bucket",
		icon = "wooden_bucket.png",
		trigger = {
		type = "craft",
		item = "skytest:wooden_bucket_empty",
		target = 1
	}
})
awards.register_achievement("skytest:place_cobble_generator_mk1",{
		title = "Cobble generator mk1",
		description = "Craft and place a cobble generator mk1",
		icon = "default_lava.png^[colorize:white:120",
		trigger = {
		type = "place",
		node = "skytest:cobblegen",
		target = 1
	}
})
awards.register_achievement("skytest:place_cobble_generator_mk2",{
		title = "Cobble generator mk2",
		description = "Craft and place a cobble generator mk2",
		icon = "default_lava.png^[colorize:red:120",
		trigger = {
		type = "place",
		node = "skytest:l2cobblegen",
		target = 1
	}
})
awards.register_achievement("skytest:craft_leaf_collector_normal",{
		title = "leaf me alone",
		description = "Craft a normal leaf collector",
		icon = "spears_spear_bronze.png",
		trigger = {
		type = "craft",
		item = "skytest:leaf_collector_normal",
		target = 1
	}
})
awards.register_achievement("skytest:craft_leaf_collector_vm",{
		title = "leaf me alone3",
		description = "Craft a Vein Mineing leaf collector",
		icon = "spears_spear_bronze.png",
		trigger = {
		type = "craft",
		item = "skytest:leaf_collector_vm",
		target = 1
	}
})
awards.register_achievement("skytest:craft_leaf_collector_3x3x1",{
		title = "leaf me alone2",
		description = "Craft a 3x3x1 leaf collector",
		icon = "spears_spear_bronze.png",
		trigger = {
		type = "craft",
		item = "skytest:leaf_collector_3x3x1",
		target = 1
	}
})
awards.register_achievement("skytest:craft_cobble",{
		title = "Cobblestone",
		description = "Craft Cobblestone from the pebbles that drop from sifting Dirt.",
		icon = "default_cobble.png",
		trigger = {
		type = "craft",
		item = "default:cobble",
		target = 1
	}
})
awards.register_achievement("skytest:craft_porcelain",{
		title = "Porcelain",
		description = "Craft porcelain",
		icon = "default_clay_lump.png^[colorize:white:120",
		trigger = {
		type = "craft",
		item = "skytest:porcelain",
		target = 1
	}
})
awards.register_achievement("skytest:place_crucible",{
		title = "Crucible",
		description = "Place a fired crucible",
		icon = "hard_clay.png",
		trigger = {
		type = "place",
		node = "skytest:crucible",
		target = 1
	}
})
awards.register_achievement("skytest:obtain_lava_from_crucible",{
		title = "Lava",
		description = "Get lava from a crucible",
		icon = "default_lava.png",
})
awards.register_achievement("skytest:obtain_dirt_from_composting",{
		title = "Dirt get!",
		description = "Make Dirt by composting saplings, leaves, or most flowers and plants in any wooden Barrel.",
		icon = "default_wood.png^compostfull.png",
})
awards.register_achievement("skytest:obtain_clay_from_barrel",{
		title = "Clay get!",
		description = "Make Clay by putting Dust into a water filled Barrel.",
		icon = "claybarrel.png",
})
awards.register_achievement("skytest:leafpress_barrel",{
		title = "Leaf press",
		description = "Craft and use a leaf press on any empty barrel to prepare it for pressing leaves.",
		icon = "default_stone.png^skytest_ctint1.png",
})
awards.register_achievement("skytest:obtain_water_from_barrel",{
		title = "Water get!",
		description = "Press leaves or cactus in any wodden barrel with press to get water.",
		icon = "water.png",
})
awards.register_achievement("skytest:craft_achievement_book",{
		title = "Woops...",
		description = "Lose your achievement book and be forced to craft another one.",
		icon = "achievement_book.png",
		trigger = {
		type = "craft",
		item = "skytest:achievement_book",
		target = 1
	}
})
awards.register_achievement("skytest:craft_empty_sieve",{
		title = "Empty sieve",
		description = "Craft an empty sieve",
		icon = "sieve_hand_sieve_side.png",
		trigger = {
		type = "craft",
		item = "skytest:empty_sieve",
		target = 1
	}
})
awards.register_achievement("skytest:craft_silkmesh",{
		title = "Silkmesh",
		description = "Craft a silkmesh",
		icon = "silk_mesh.png",
		trigger = {
		type = "craft",
		item = "skytest:silk_mesh",
		target = 1
	}
})
awards.register_achievement("skytest:craft_mesh",{
		title = "mesh",
		description = "Craft a mesh",
		icon = "sieve_mesh.png",
		trigger = {
		type = "craft",
		item = "skytest:mesh",
		target = 1
	}
})
awards.register_achievement("skytest:advanced_compost",{
		title = "Advanced compost bin",
		description = "Craft a advanced compost bin",
		icon = "sieve_mesh.png",
		trigger = {
		type = "craft",
		item = "skytest:machine",
		target = 1
	}
})
end