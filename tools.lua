local function register_liquid_wood(source, itemname, inventory_image, name, groups)
	if not (source and itemname and inventory_image and name and type(source) == 'string' and type(itemname) == 'string' and type(inventory_image) == 'string') then
		return
	end

	inventory_image = inventory_image..'^wooden_bucket_overlay.png'
	minetest.register_craftitem(itemname, {
		description = name,
		inventory_image = inventory_image,
		stack_max = 1,
		liquids_pointable = true,
		groups = groups,

		on_place = function(itemstack, user, pointed_thing)
			if not (user and pointed_thing) then
				return
			end

			-- Must be pointing to node
			if pointed_thing.type ~= "node" then
				return
			end

			local node = minetest.get_node_or_nil(pointed_thing.under)
			local ndef = node and minetest.registered_nodes[node.name]

			-- Call on_rightclick if the pointed node defines it
			if ndef and ndef.on_rightclick and
				user and not user:get_player_control().sneak then
				return ndef.on_rightclick(pointed_thing.under, node, user, itemstack)
			end

			local lpos

			-- Check if pointing to a buildable node
			if ndef and ndef.buildable_to then
				-- buildable; replace the node
				lpos = pointed_thing.under
			else
				-- not buildable to; place the liquid above
				-- check if the node above can be replaced
				lpos = pointed_thing.above
				local node = minetest.get_node_or_nil(lpos)
				if not node then
					return
				end

				local above_ndef = node and minetest.registered_nodes[node.name]

				if not above_ndef or not above_ndef.buildable_to then
					-- do not remove the bucket with the liquid
					return itemstack
				end
			end

			if minetest.is_protected(lpos, user and user:get_player_name() or "") then
				return
			end

			minetest.set_node(lpos, {name = source})
			return ItemStack("skytest:bucket_wood_empty")
		end
	})
end

for fluid, def in pairs(bucket.liquids) do
	if not fluid:find('flowing') and not fluid:find('lava') and not fluid:find('molten') and not fluid:find('weightless') then
		local item_name = def.itemname:gsub('[^:]+:bucket', 'skytest:bucket_wood')
		local original = minetest.registered_items[def.itemname]
		if original and item_name and item_name ~= def.itemname then
			local new_name = original.description:gsub('Bucket', 'Wooden Bucket')
			local new_image = original.inventory_image
			register_liquid_wood(fluid, item_name, new_image, new_name, original.groups)
		end
	end
end


minetest.register_craft({
	output = 'skytest:bucket_wood_empty 1',
	recipe = {
		{'group:wood', '', 'group:wood'},
		{'default:stick', 'group:wood', 'default:stick'},
	}
})

minetest.register_craftitem("skytest:bucket_wood_empty", {
	description = "Empty Wooden Bucket",
	inventory_image = "wooden_bucket.png",
	stack_max = 99,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		-- Must be pointing to node
		if not (user and pointed_thing and pointed_thing.type == "node") then
			return
		end

		-- Check if pointing to a liquid source
		local node = minetest.get_node(pointed_thing.under)
		if not node then
			return
		end

		local liquiddef = bucket.liquids[node.name]
		if not liquiddef or node.name ~= liquiddef.source then
			return
		end

		if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
			return
		end

		if node and node.name:find('lava') or node.name:find('molten') then
			itemstack:set_count(itemstack:get_count() - 1)
			return itemstack
		end

		local item_count = user:get_wielded_item():get_count()

		-- default set to return filled bucket
		local giving_back = liquiddef.itemname:gsub('^[^:]+:bucket', 'skytest:bucket_wood')

		-- check if holding more than 1 empty bucket
		if item_count > 1 then

			-- if space in inventory add filled bucket, otherwise drop as item
			local inv = user:get_inventory()
			if inv:room_for_item("main", {name=giving_back}) then
				inv:add_item("main", giving_back)
			else
				local pos = user:getpos()
				pos.y = math.floor(pos.y + 0.5)
				minetest.add_item(pos, giving_back)
			end

			-- set to return empty buckets minus 1
			giving_back = "skytest:bucket_wood_empty "..tostring(item_count-1)

		end

		minetest.add_node(pointed_thing.under, {name="air"})

		return ItemStack(giving_back)
	end,
})



local function register_liquid_clay(source, itemname, inventory_image, name, groups)
	if not (source and itemname and inventory_image and name and type(source) == 'string' and type(itemname) == 'string' and type(inventory_image) == 'string') then
		return
	end

	inventory_image = inventory_image..'^wooden_bucket_overlay.png^[colorize:red:120'
	minetest.register_craftitem(itemname, {
		description = name,
		inventory_image = inventory_image,
		stack_max = 1,
		liquids_pointable = true,
		groups = groups,

		on_place = function(itemstack, user, pointed_thing)
			if not (user and pointed_thing) then
				return
			end

			-- Must be pointing to node
			if pointed_thing.type ~= "node" then
				return
			end

			local node = minetest.get_node_or_nil(pointed_thing.under)
			local ndef = node and minetest.registered_nodes[node.name]

			-- Call on_rightclick if the pointed node defines it
			if ndef and ndef.on_rightclick and
				user and not user:get_player_control().sneak then
				return ndef.on_rightclick(pointed_thing.under, node, user, itemstack)
			end

			local lpos

			-- Check if pointing to a buildable node
			if ndef and ndef.buildable_to then
				-- buildable; replace the node
				lpos = pointed_thing.under
			else
				-- not buildable to; place the liquid above
				-- check if the node above can be replaced
				lpos = pointed_thing.above
				local node = minetest.get_node_or_nil(lpos)
				if not node then
					return
				end

				local above_ndef = node and minetest.registered_nodes[node.name]

				if not above_ndef or not above_ndef.buildable_to then
					-- do not remove the bucket with the liquid
					return itemstack
				end
			end

			if minetest.is_protected(lpos, user and user:get_player_name() or "") then
				return
			end

			minetest.set_node(lpos, {name = source})
			return ItemStack("skytest:bucket_clay_empty")
		end
	})
end

for fluid, def in pairs(bucket.liquids) do
	if not fluid:find('flowing') then
		local item_name = def.itemname:gsub('[^:]+:bucket', 'skytest:bucket_clay')
		local original = minetest.registered_items[def.itemname]
		if original and item_name and item_name ~= def.itemname then
			local new_name = original.description:gsub('Bucket', 'clay Bucket')
			local new_image = original.inventory_image
			register_liquid_clay(fluid, item_name, new_image, new_name, original.groups)
		end
	end
end
minetest.register_craft({
	type = "cooking",
	output = "skytest:bucket_clay_empty",
	recipe = "skytest:bucket_clay_raw",
})
minetest.register_craft({
	output = 'skytest:bucket_clay_raw',
	recipe = {
		{'skytest:porcelain', '', 'skytest:porcelain'},
		{'', 'skytest:porcelain', ''},
	}
})

minetest.register_craftitem("skytest:bucket_clay_raw", {
	description = "Raw clay Bucket",
	inventory_image = "clay_bucket_raw.png^[colorize:white:120",
	stack_max = 99,
})
minetest.register_craftitem("skytest:bucket_clay_empty", {
	description = "Empty clay Bucket",
	inventory_image = "clay_bucket_raw.png^[colorize:red:120",
	stack_max = 99,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		-- Must be pointing to node
		if not (user and pointed_thing and pointed_thing.type == "node") then
			return
		end

		-- Check if pointing to a liquid source
		local node = minetest.get_node(pointed_thing.under)
		if not node then
			return
		end

		local liquiddef = bucket.liquids[node.name]
		if not liquiddef or node.name ~= liquiddef.source then
			return
		end

		if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
			return
		end
		local item_count = user:get_wielded_item():get_count()

		-- default set to return filled bucket
		local giving_back = liquiddef.itemname:gsub('^[^:]+:bucket', 'skytest:bucket_clay')

		-- check if holding more than 1 empty bucket
		if item_count > 1 then

			-- if space in inventory add filled bucket, otherwise drop as item
			local inv = user:get_inventory()
			if inv:room_for_item("main", {name=giving_back}) then
				inv:add_item("main", giving_back)
			else
				local pos = user:getpos()
				pos.y = math.floor(pos.y + 0.5)
				minetest.add_item(pos, giving_back)
			end

			-- set to return empty buckets minus 1
			giving_back = "skytest:bucket_clay_empty "..tostring(item_count-1)

		end

		minetest.add_node(pointed_thing.under, {name="air"})

		return ItemStack(giving_back)
	end,
})
minetest.register_tool("skytest:stone_hammer", {
        description = "Stone Hammer",
        _doc_items_usagehelp = "Mine a block of cobble to get gravel, mine gravel to get sand, and mine sand to get dust.",
        inventory_image = "skytest_hammer_stone.png",
        tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=1.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
    })




minetest.register_craft({
        output = "skytest:stone_hammer",
        recipe = {
            {"","group:stone",""},
            {"","default:stick","group:stone"},
            {"default:stick","",""},
        }
    })
 -----
minetest.register_tool("skytest:steel_hammer", {
        description = "Steel Hammer",
        _doc_items_usagehelp = "Mine a block of cobble to get gravel, mine gravel to get sand, and mine sand to get dust.",
        inventory_image = "skytest_hammer_steel.png",
        tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=2.0, [3]=1.00}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=6},
	},
        sound = {breaks = "default_tool_breaks"},
    })
minetest.register_craft({
        output = "skytest:steel_hammer",
        recipe = {
            {"","default:steel_ingot",""},
            {"","default:stick","default:steel_ingot"},
            {"default:stick","",""},
        }
    })
minetest.register_tool("skytest:mese_hammer", {
        description = "Mese Hammer",
        _doc_items_usagehelp = "Mine a block of cobble to get gravel, mine gravel to get sand, and mine sand to get dust.",
        inventory_image = "skytest_hammer_mese.png",
        tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=7},
	},
	sound = {breaks = "default_tool_breaks"},
    })
minetest.register_craft({
        output = "skytest:mese_hammer",
        recipe = {
            {"","default:mese_crystal",""},
            {"","default:stick","default:mese_crystal"},
            {"default:stick","",""},
        }
    })
minetest.register_tool("skytest:diamond_hammer", {
        description = "Diamond Hammer",
        _doc_items_usagehelp = "Mine a block of cobble to get gravel, mine gravel to get sand, and mine sand to get dust.",
        inventory_image = "skytest_hammer_diamond.png",
        tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=20, maxlevel=3},
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=8},
	},
	sound = {breaks = "default_tool_breaks"},
    })
minetest.register_craft({
        output = "skytest:diamond_hammer",
        recipe = {
            {"","default:diamond",""},
            {"","default:stick","default:diamond"},
            {"default:stick","",""},
        }
    })
minetest.register_craft({
        output = "skytest:crook",
        recipe = {
            {"default:stick","default:stick",""},
            {"","default:stick",""},
            {"","default:stick",""},
        }
    })
minetest.register_craft({
        output = "skytest:comp_crook",
        recipe = {
            {"skytest:crook","skytest:crook",""},
            {"","skytest:crook",""},
            {"","skytest:crook",""},
        }
    })

minetest.register_craft({
        output = "skytest:leaf_collector",
        recipe = {
            {"","","skytest:crook"},
            {"","default:stick",""},
            {"default:stick","",""},
        }
    })
minetest.register_tool("skytest:crook", {
        description = "Crook",
        _doc_items_usagehelp = "Mine default:leaves to have a higher chance to get sapplings and a low chance to get a silkworm.",
        inventory_image = "ant_hoe.png",
        tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=25, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=25, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=25}
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
    })
minetest.register_tool("skytest:comp_crook", {
        description = "Compressed Crook",
        _doc_items_usagehelp = "Mine default:leaves to have a MUCH higher chance to get sapplings and a high chance to get a silkworm.",
        inventory_image = "ant_hoe.png",
        tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=100, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=100, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=100}
		},
		damage_groups = {fleshy=6},
	},
	sound = {breaks = "default_tool_breaks"},
    })
minetest.register_craftitem("skytest:silkworm", {
        description = "Silkworm",
        _doc_items_usagehelp = "Use on default:leaves to infest them, infested leaves spread to anything in the group:leaves. infested leaves have a high chance to drop a silkworm when using a crook(crook chances:25%  compressed crook chances:100%). can be cooked and eaten",
        inventory_image = "silkworm.png",
        on_use = function(itemstack, user, pointed_thing)
			  if minetest.get_node(pointed_thing.under).name == "default:leaves" then
				minetest.set_node(pointed_thing.under, {name = "skytest:infested_leaves"})
				itemstack:take_item()
				return itemstack
			end
	end,
    })
minetest.register_tool("skytest:leaf_collector_normal", {
        description = "leaf collector(extra reach)",
        _doc_items_usagehelp = "Use to get those leaves that are just to high.",
        inventory_image = "spears_spear_bronze.png",
        tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=30, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=30, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=30}
		},
		damage_groups = {fleshy=6},
	},
	sound = {breaks = "default_tool_breaks"},
	range = 12,
    })


skytest = {}
skytest.player_inv_width = 8
skytest.get_player_inv_width = function()
	local p = minetest.get_connected_players()
	if p and #p > 0 then
		local i,v = next(p)
		-- I'm kind of assuming that the player inventory has 4 rows, here
		skytest.player_inv_width = math.floor( v:get_inventory():get_size("main") / 4 )
	else
		-- just keep waiting till we get this info
		minetest.after(1.5, skytest.get_player_inv_width)
	end
end

minetest.after(1.5, skytest.get_player_inv_width)

-- break a node and give the default drops

function skytest.drop_node(pos, digger, wielded, rank)
	-- check if we can drop this node
	local node = minetest.get_node(pos)
	local def = ItemStack({name=node.name}):get_definition()

	if not def.diggable or (def.can_dig and not def.can_dig(pos,digger)) then return end
	if minetest.is_protected(pos, digger:get_player_name()) then return end
	if minetest.get_item_group(node.name, "leaves") == 0 then return end
	local level = minetest.get_item_group(node.name, "level")
	if rank >= level then
		local drops = minetest.get_node_drops(node.name, wielded:get_name())
		minetest.handle_node_drops(pos, drops, digger)
		minetest.remove_node(pos)
	end
end
function skytest.get_3x3s(pos, digger)
	local r = {}
	
	local a = 0		-- forward/backward
	if math.abs(pos.x - digger:getpos().x) > 
		math.abs(pos.z - digger:getpos().z) then a = 1 end -- sideways

	local b = 0		-- horizontal (default)
	local q = digger:get_look_pitch()
	if q < -0.78 or q > 0.78 then b = 1 end  -- vertical

	local c = 1
	for x=-1,1 do
	for y=-1,1 do
		if x ~= 0 or y ~= 0 then
			-- determine next perpendicular node
			local k = {x=0, y=0, z=0}
			if a > 0 then
				k.z = pos.z + x
				if b > 0 then
					k.x = pos.x + y
					k.y = pos.y
				else
					k.x = pos.x
					k.y = pos.y + y
				end
			else
				k.x = pos.x + x
				if b > 0 then
					k.y = pos.y
					k.z = pos.z + y
				else
					k.y = pos.y + y
					k.z = pos.z
				end
			end

			r[c] = {x=k.x, y=k.y, z=k.z}
			c = c + 1
		end
	end
	end

	return r
end

-- make a list of supported nodes that a chopped node has just dropped

function skytest.get_chopped(pos, group)
	local r = {}

	-- did the chopped pos have a neighboring log node?
	local b = 0
	local p = {x=pos.x - 1,y=pos.y,z=pos.z}
	if minetest.get_item_group(minetest.get_node(p).name, group) > 0 then b = 1 end
	p.x = p.x + 2
	if minetest.get_item_group(minetest.get_node(p).name, group) > 0 then b = 1 end
	p.x = p.x - 1
	p.z = p.z - 1
	if minetest.get_item_group(minetest.get_node(p).name, group) > 0 then b = 1 end
	p.z = p.z + 2
	if minetest.get_item_group(minetest.get_node(p).name, group) > 0 then b = 1 end

	-- if not, then proceed
	local c = 1
	while b == 0 do
		p.y = p.y + 1
		b = -1

		-- 3x3s upward till we run out of tree
		for x=-1,1 do
		for z=-1,1 do
			p.x = pos.x + x
			p.z = pos.z + z
			if minetest.get_item_group(minetest.get_node(p).name, group) > 0 then
				b = 0
				r[c] = {x=p.x, y=p.y, z=p.z}
				c = c + 1
			end
		end
		end
	end
	return r
end
function skytest.after_collector(pos, oldnode, digger)
	if digger then
		local wielded = digger:get_wielded_item()
		local rank = minetest.get_item_group(wielded:get_name(), "collector")
		if rank > 0 then
			for _,k in ipairs(skytest.get_3x3s(pos, digger)) do
				skytest.drop_node(k, digger, wielded, rank)
			end
		end
	end
end

-- register_on_dignode is used here because after_use does not provide position
-- which is somewhat annoying
minetest.register_on_dignode(skytest.after_collector)

minetest.register_tool("skytest:leaf_collector_3x3x1", {
        description = "leaf collector(3x3x1)",
        _doc_items_usagehelp = "Use to get those leaves that are just to high. Will mine a 3X3X1 cube of leaves.",
        inventory_image = "spears_spear_bronze.png",
	groups = {collector=1},
        tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=7, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=7, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=7}
		},
		damage_groups = {fleshy=6},
	},
	sound = {breaks = "default_tool_breaks"},
	range = 12,
    })

minetest.register_craft({
        output = "skytest:leaf_collector_normal",
        recipe = {
            {"skytest:crook","",""},
            {"","default:stick",""},
            {"","","default:stick"},
        }
    })
minetest.register_craft({
        output = "skytest:leaf_collector_3x3x1",
        recipe = {
            {"skytest:crook","skytest:crook","skytest:crook"},
            {"skytest:crook","skytest:leaf_collector_normal","skytest:crook"},
            {"skytest:crook","skytest:crook","skytest:crook"},
        }
    })
minetest.register_craft({
        output = "skytest:leaf_collector_3x3x1",
        recipe = {
            {"","",""},
            {"skytest:comp_crook","skytest:leaf_collector_normal","skytest:comp_crook"},
            {"","",""},
        }
    })

local USES = 200
local mode = {}

local vert1 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, 
			{0.1875, -0.5, -0.5, 0.5, 0.5, 0.5}, 
			{-0.5, -0.5, -0.5, -0.1875, 0.5, 0.5}, 
		}
	}

local vert2 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.375, 0.5, 0.5, 0.5},
			{0.1875, -0.5, -0.5, 0.5, 0.5, 0.5}, 
			{-0.5, -0.5, -0.5, -0.1875, 0.5, 0.5}, 
		}
	}

local vert3 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.5, 0.5}, 
			{0.1875, -0.5, -0.5, 0.5, 0.5, 0.5}, 
			{-0.5, -0.5, -0.5, -0.1875, 0.5, 0.5}, 
		}
	}

local vert4 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.25, 0.5, 0.5, 0.5},
			{0.1875, -0.5, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.1875, 0.5, 0.5}, 
		}
	}

local hori1 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5},
			{-0.5, 0.1875, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5},   
		}
	}

local hori2 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.375, 0.5, 0.5, 0.5},
			{-0.5, 0.1875, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5},  
		}
	}

local hori3 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.5, 0.5}, 
			{-0.5, 0.1875, -0.5, 0.5, 0.5, 0.5}, 
			{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5},  
		}
	}

local hori4 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.25, 0.5, 0.5, 0.5}, 
			{-0.5, 0.1875, -0.5, 0.5, 0.5, 0.5}, 
			{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5}, 
		}
	}

local cross1 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5},
			{0.1875, -0.5, -0.5, 0.5, -0.1875, 0.5},
			{-0.5, -0.5, -0.5, -0.1875, -0.1875, 0.5},
			{-0.5, 0.1875, -0.5, -0.1875, 0.5, 0.5}, 
			{0.1875, 0.1875, -0.5, 0.5, 0.5, 0.5},
		}
	}

local cross2 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.375, 0.5, 0.5, 0.5},
			{0.1875, -0.5, -0.5, 0.5, -0.1875, 0.5}, 
			{-0.5, -0.5, -0.5, -0.1875, -0.1875, 0.5}, 
			{-0.5, 0.1875, -0.5, -0.1875, 0.5, 0.5},
			{0.1875, 0.1875, -0.5, 0.5, 0.5, 0.5},  
		}
	}

local cross3 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.5, 0.5},
			{0.1875, -0.5, -0.5, 0.5, -0.1875, 0.5},
			{-0.5, -0.5, -0.5, -0.1875, -0.1875, 0.5}, 
			{-0.5, 0.1875, -0.5, -0.1875, 0.5, 0.5},
			{0.1875, 0.1875, -0.5, 0.5, 0.5, 0.5}, 
		}
	}

local cross4 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.25, 0.5, 0.5, 0.5},
			{0.1875, -0.5, -0.5, 0.5, -0.1875, 0.5}, 
			{-0.5, -0.5, -0.5, -0.1875, -0.1875, 0.5}, 
			{-0.5, 0.1875, -0.5, -0.1875, 0.5, 0.5}, 
			{0.1875, 0.1875, -0.5, 0.5, 0.5, 0.5},
		}
	}

local chis1 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5},
			{-0.4375, -0.4375, -0.5, 0.4375, 0.4375, 0.5},
		}
	}

local chis2 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.375, 0.5, 0.5, 0.5}, 
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.5}, 
			{-0.4375, -0.4375, -0.4375, 0.4375, 0.4375, 0.5},
		}
	}

local chis3 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.5, 0.5}, 
			{-0.375, -0.375, -0.4375, 0.375, 0.375, 0.5},
			{-0.4375, -0.4375, -0.375, 0.4375, 0.4375, 0.5},
			{-0.3125, -0.3125, -0.5, 0.3125, 0.3125, 0.5},
		}
	}

local chis4 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.25, 0.5, 0.5, 0.5}, 
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
			{-0.4375, -0.4375, -0.3125, 0.4375, 0.4375, 0.5}, 
			{-0.3125, -0.3125, -0.4375, 0.3125, 0.3125, 0.5}, 
			{-0.25, -0.25, -0.5, 0.25, 0.25, 0.5},
		}
	}

local squar1 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, 0.5, -0.4375},
			{0.3125, -0.5, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, -0.5, -0.5, 0.5, -0.3125, -0.4375},
			{-0.5, 0.3125, -0.5, 0.5, 0.5, -0.4375}, 
		}
	}

local squar2 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.375, 0.5, 0.5, 0.5}, 
			{-0.5, -0.5, -0.5, -0.3125, 0.5, -0.375},
			{0.3125, -0.5, -0.5, 0.5, 0.5, -0.375},
			{-0.5, -0.5, -0.5, 0.5, -0.3125, -0.375},
			{-0.5, 0.3125, -0.5, 0.5, 0.5, -0.375},
		}
	}

local squar3 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, 0.5, -0.3125},
			{0.3125, -0.5, -0.5, 0.5, 0.5, -0.3125},
			{-0.5, -0.5, -0.5, 0.5, -0.3125, -0.3125},
			{-0.5, 0.3125, -0.5, 0.5, 0.5, -0.3125},
		}
	}

local squar4 = {
	type = "fixed",
	fixed = {
			{-0.5, -0.5, -0.25, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, 0.5, -0.25},
			{0.3125, -0.5, -0.5, 0.5, 0.5, -0.25},
			{-0.5, -0.5, -0.5, 0.5, -0.3125, -0.25},
			{-0.5, 0.3125, -0.5, 0.5, 0.5, -0.25},
		}
	}

local default_material = {
		{"default:cobble", "default_cobble", "Cobble", {cracky = 3, not_in_creative_inventory=1}},
		{"default:sandstone","default_sandstone", "Sandstone", {crumbly=2, not_in_creative_inventory=1}},
		{"default:clay","default_clay",  "Clay", {crumbly=3, not_in_creative_inventory=1}},
		{"default:coalblock","default_coal_block",  "Coal Block", {cracky = 3, not_in_creative_inventory=1}},
		{"default:stone","default_stone", "Stone", {cracky = 3, not_in_creative_inventory=1}},
		{"default:desert_stone","default_desert_stone", "Desert Stone", {cracky = 3, not_in_creative_inventory=1}},
		{"default:wood","default_wood", "Wood", {choppy=2, not_in_creative_inventory=1}},
		{"default:acacia_wood","default_acacia_wood", "Acacia Wood", {choppy=2, not_in_creative_inventory=1}},
		{"default:aspen_wood","default_aspen_wood", "Aspen Wood", {choppy=2, not_in_creative_inventory=1}},
		{"default:pine_wood","default_pine_wood", "Pine Wood", {choppy=2, not_in_creative_inventory=1}},
		{"default:desert_cobble","default_desert_cobble", "Desert Cobble", {cracky = 3, not_in_creative_inventory=1}},
		{"default:junglewood","default_junglewood", "Jungle Wood", {choppy=2, not_in_creative_inventory=1}},
		{"default:sandstonebrick","default_sandstone_brick", "Sandstone Brick", {cracky = 2, not_in_creative_inventory=1}},
		{"default:stonebrick","default_stone_brick", "Stone Brick", {cracky = 2, not_in_creative_inventory=1}},
		{"default:desert_stonebrick","default_desert_stone_brick", "Desert Stone Brick", {cracky = 2, not_in_creative_inventory=1}},
		}

for i in ipairs (default_material) do
	local item = default_material [i][1]
	local mat = default_material [i][2]
	local desc = default_material [i][3]
	local gro = default_material [i][4]

minetest.register_node("skytest:vertical_"..mat.."1", {
	description = "Vertical "..desc.."1",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_vtint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = vert1,
	selection_box = vert1,
	on_place = minetest.rotate_node,
})

minetest.register_node("skytest:vertical_"..mat.."2", {
	description = "Vertical "..desc.."2",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_vtint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = vert2,
	selection_box = vert2
})

minetest.register_node("skytest:vertical_"..mat.."3", {
	description = "Vertical "..desc.."3",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_vtint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = vert3,
	selection_box = vert3
})

minetest.register_node("skytest:vertical_"..mat.."4", {
	description = "Vertical "..desc.."4",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_vtint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = vert4,
	selection_box = vert4
})

minetest.register_node("skytest:chiseled_"..mat.."1", {
	description = "Chiseled"..desc.."1",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint1.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = chis1,
	selection_box = chis1,
})

minetest.register_node("skytest:chiseled_"..mat.."2", {
	description = "Chiseled"..desc.."2",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint2.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = chis2,
	selection_box = chis2
})

minetest.register_node("skytest:chiseled_"..mat.."3", {
	description = "Chiseled"..desc.."3",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint3.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = chis3,
	selection_box = chis3
})

minetest.register_node("skytest:chiseled_"..mat.."4", {
	description = "Chiseled"..desc.."4",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint4.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = chis4,
	selection_box = chis4
})

minetest.register_node("skytest:horizontal_"..mat.."1", {
	description = "Horizontal "..desc.."1",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_htint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = hori1,
	selection_box = hori1
})

minetest.register_node("skytest:horizontal_"..mat.."2", {
	description = "Horizontal"..desc.."2",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_htint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = hori2,
	selection_box = hori2
})

minetest.register_node("skytest:horizontal_"..mat.."3", {
	description = "Horizontal"..desc.."3",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_htint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = hori3,
	selection_box = hori3
})

minetest.register_node("skytest:horizontal_"..mat.."4", {
	description = "Horizontal"..desc.."4",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_htint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = hori4,
	selection_box = hori4
})

minetest.register_node("skytest:cross_"..mat.."1", {
	description = "cross "..desc.."1",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = cross1,
	selection_box = cross1
})

minetest.register_node("skytest:cross_"..mat.."2", {
	description = "cross"..desc.."2",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = cross2,
	selection_box = cross2
})

minetest.register_node("skytest:cross_"..mat.."3", {
	description = "cross"..desc.."3",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = cross3,
	selection_box = cross3
})

minetest.register_node("skytest:cross_"..mat.."4", {
	description = "cross"..desc.."4",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_ctint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = cross4,
	selection_box = cross4
})

minetest.register_node("skytest:square_"..mat.."1", {
	description = "cross "..desc.."1",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_stint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = squar1,
	selection_box = squar1
})

minetest.register_node("skytest:square_"..mat.."2", {
	description = "cross"..desc.."2",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_stint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = squar2,
	selection_box = squar2
})

minetest.register_node("skytest:square_"..mat.."3", {
	description = "cross"..desc.."3",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_stint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = squar3,
	selection_box = squar3
})

minetest.register_node("skytest:square_"..mat.."4", {
	description = "cross"..desc.."4",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytest_stint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = item,
	groups = gro,
	node_box = squar4,
	selection_box = squar4

})
minetest.register_node("skytest:"..mat.."_ladder", {
	description =  desc.." Ladder Block",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytesthammer_tint.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	climbable = true,
	drop = item,
	groups = gro,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, 0.3175, -0.3125, 0.5, 0.5},
			{0.3125, -0.5, 0.3175, 0.5, 0.5, 0.5},
			{-0.5, -0.4375, 0.3175, 0.5, -0.3125, 0.5},
			{-0.5, 0.3125, 0.3175, 0.5, 0.4375, 0.5},
			{-0.5, -0.1875, 0.3175, 0.5, -0.0625, 0.5},
			{-0.5, 0.0625, 0.3175, 0.5, 0.1875, 0.5},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.3175, 0.5, 0.5, 0.5},
		}
	},
})
minetest.register_node("skytest:"..mat.."_ladder2", {
	description =  desc.." Ladder Block",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	--climbable = false,
	drop = item,
	groups = gro,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3175, 0.5, 0.5, 0.5},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3175, 0.5, 0.5, 0.5},
		}
	},
})
minetest.register_node("skytest:"..mat.."_ladder3", {
	description =  desc.." Ladder Block",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	--climbable = true,
	drop = item,
	groups = gro,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.3175, 0.5, 0.5, 0.5},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.3175, 0.5, 0.5, 0.5},
		}
	},
})
minetest.register_node("skytest:"..mat.."_foot", {
	description =  desc.." Foot Hold Block",
	drawtype = "nodebox",
	tiles = {
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png",
		mat..".png^skytesthammer_tint2.png",
		},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	climbable = true,
	drop = item,
	groups = gro,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.1875, 0.5, 0.5, 0.5},
			{-0.375, -0.3125, -0.3125, -0.125, -0.125, -0.1875},
			{0.125, 0.1875, -0.3125, 0.375, 0.375, -0.1875},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
		}
	},
   collision_box = {
      type="fixed",
      fixed = {
         {-0.5, -0.5, -0.1875, 0.5, 0.5, 0.5},
      }
   },
})
end

local function parti(pos)
  	minetest.add_particlespawner(25, 0.3,
		pos, pos,
		{x=2, y=0.2, z=2}, {x=-2, y=2, z=-2},
		{x=0, y=-6, z=0}, {x=0, y=-10, z=0},
		0.2, 1,
		0.2, 2,
		true, "skytest_parti.png")
end

	mode = "1"

minetest.register_tool( "skytest:chisel",{
	description = "Chisel",
	inventory_image = "skytest_chisel.png",
	wield_image = "skytest_chisel.png",

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		local pos = pointed_thing.under
		local node = minetest.get_node(pos)

		local default_material = {
			{"default:cobble", "default_cobble", "Cobble"},
			{"default:sandstone","default_sandstone", "Sandstone"},
			{"default:clay","default_clay",  "Clay"},
			{"default:coalblock","default_coal_block",  "Coal Block"},
			{"default:stone","default_stone", "Stone"},
			{"default:desert_stone","default_desert_stone", "Desert Stone"},
			{"default:wood","default_wood", "Wood"},
			{"default:acacia_wood","default_acacia_wood", "Acacia Wood"},
			{"default:aspen_wood","default_aspen_wood", "Aspen Wood"},
			{"default:pine_wood","default_pine_wood", "Pine Wood"},
			{"default:desert_cobble","default_desert_cobble", "Desert Cobble"},
			{"default:junglewood","default_junglewood", "Jungle Wood"},
			{"default:sandstonebrick","default_sandstone_brick", "Sandstone Brick"},
			{"default:stonebrick","default_stone_brick", "Stone Brick"},
			{"default:desert_stonebrick","default_desert_stone_brick", "Desert Stone Brick"},
			}

		for i in ipairs (default_material) do
		local item = default_material [i][1]
		local mat = default_material [i][2]
		local desc = default_material [i][3]

		if pointed_thing.type ~= "node" then
			return
		end

		if minetest.is_protected(pos, user:get_player_name()) then
			minetest.record_protection_violation(pos, user:get_player_name())
			return
		end

		if mode == "1" then

			if node.name == item then
				   minetest.set_node(pos,{name = "skytest:chiseled_"..mat.."1", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:chiseled_"..mat.."1" then
				   minetest.set_node(pos,{name = "skytest:chiseled_"..mat.."2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:chiseled_"..mat.."2" then
				   minetest.set_node(pos,{name = "skytest:chiseled_"..mat.."3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:chiseled_"..mat.."3" then
				   minetest.set_node(pos,{name = "skytest:chiseled_"..mat.."4", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end
		end

		if mode == "2" then

			if node.name == item then
				   minetest.set_node(pos,{name = "skytest:horizontal_"..mat.."1", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:horizontal_"..mat.."1" then
				   minetest.set_node(pos,{name = "skytest:horizontal_"..mat.."2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:horizontal_"..mat.."2" then
				   minetest.set_node(pos,{name = "skytest:horizontal_"..mat.."3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:horizontal_"..mat.."3" then
				   minetest.set_node(pos,{name = "skytest:horizontal_"..mat.."4", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end
		end

		if mode == "3" then

			if node.name == item then
				   minetest.set_node(pos,{name = "skytest:vertical_"..mat.."1", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:vertical_"..mat.."1" then
				   minetest.set_node(pos,{name = "skytest:vertical_"..mat.."2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:vertical_"..mat.."2" then
				   minetest.set_node(pos,{name = "skytest:vertical_"..mat.."3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:vertical_"..mat.."3" then
				   minetest.set_node(pos,{name = "skytest:vertical_"..mat.."4", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end
		end

		if mode == "4" then

			if node.name == item then
				   minetest.set_node(pos,{name = "skytest:cross_"..mat.."1", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:cross_"..mat.."1" then
				   minetest.set_node(pos,{name = "skytest:cross_"..mat.."2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:cross_"..mat.."2" then
				   minetest.set_node(pos,{name = "skytest:cross_"..mat.."3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:cross_"..mat.."3" then
				   minetest.set_node(pos,{name = "skytest:cross_"..mat.."4", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end
		end

		if mode == "5" then

			if node.name == item then
				   minetest.set_node(pos,{name = "skytest:square_"..mat.."1", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:square_"..mat.."1" then
				   minetest.set_node(pos,{name = "skytest:square_"..mat.."2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:square_"..mat.."2" then
				   minetest.set_node(pos,{name = "skytest:square_"..mat.."3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end

			if node.name == "skytest:square_"..mat.."3" then
				   minetest.set_node(pos,{name = "skytest:square_"..mat.."4", param2=minetest.dir_to_facedir(user:get_look_dir())})
				   parti(pos)
			end
		end
		if mode == "6" then
			if node.name == item then
				minetest.set_node(pos,{name = "skytest:"..mat.."_ladder2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			elseif node.name == "skytest:"..mat.."_ladder2" then
				minetest.set_node(pos,{name = "skytest:"..mat.."_ladder3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			elseif node.name == "skytest:"..mat.."_ladder3" then
				minetest.set_node(pos,{name = "skytest:"..mat.."_ladder", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			end
		end
		if mode == "7" then
			if node.name == item then
				minetest.set_node(pos,{name = "skytest:"..mat.."_foot", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			end
		end

	end

		if not minetest.setting_getbool("creative_mode") then
			itemstack:add_wear(65535 / (USES - 1))
		end

		return itemstack

	end,

	on_place = function(itemstack, user, pointed_thing)

		local usr = user:get_player_name()

		if mode == "1" then
			mode = "2"
			minetest.chat_send_player(usr,"Horizontal Groove")

		elseif mode == "2" then
			mode = "3"
			minetest.chat_send_player(usr,"Vertical Groove")

		elseif mode == "3" then
			mode = "4"
			minetest.chat_send_player(usr,"Cross Grooves")

		elseif mode == "4" then
			mode = "5"
			minetest.chat_send_player(usr,"Square")

		elseif mode == "5" then
			mode = "6"
			minetest.chat_send_player(usr,"Chisel ladder")
		elseif mode == "6" then
			mode = "7"
			minetest.chat_send_player(usr,"Chisel Foot Hold")
		elseif mode == "7" then
			mode = "1"
			minetest.chat_send_player(usr,"Chisel 4 Edges")
		end

		if not minetest.setting_getbool("creative_mode") then
			itemstack:add_wear(65535 / (USES - 1))
		end

		return itemstack

	end

})

minetest.register_craft({
		output = "skytest:chisel",
		recipe = {
			{"default:steel_ingot"},
			{"skytest:silk"},
			{"default:stick"},
		},
})
climbing_pick = {}

climbing_pick.pick_on_use = function(itemstack, user, pointed_thing)
    local pt = pointed_thing
    -- check if pointing at a node
    if not pt then
        return
    end
    if pt.type ~= "node" then
        return
    end

    local under = minetest.get_node(pt.under)
    local p = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
    local above = minetest.get_node(p)

    -- return if any of the nodes is not registered
    if not minetest.registered_nodes[under.name] then
        return
    end
    if not minetest.registered_nodes[above.name] then
        return
    end

    -- check if pointing at walkable node
    local nodedef1 = minetest.registered_nodes[under.name]
    if not (nodedef1 and nodedef1.walkable) then
        return
    end

    -- node above must be not walkable
    local nodedef2 = minetest.registered_nodes[above.name]
    if nodedef2 and nodedef2.walkable then
        return
    end

    local tool_definition = itemstack:get_definition()
    local tool_capabilities = tool_definition.tool_capabilities
    -- local punch_interval = tool_capabilities.full_punch_interval    -- not sure how to use correctly

    -- no way to set speed of player
    -- emulate it in ugly way
    -- https://github.com/minetest/minetest/issues/1176 :(
    local plpos = user:get_pos()
    plpos.y = plpos.y + 0.2
    user:moveto(plpos, true)
    plpos = user:get_pos()
    plpos.y = plpos.y + 0.2
    user:moveto(plpos, true)
    plpos = user:get_pos()
    plpos.y = plpos.y + 0.2
    user:moveto(plpos, true)
    plpos = user:get_pos()
    plpos.y = plpos.y + 0.2
    user:moveto(plpos, true)
    plpos = user:get_pos()
    plpos.y = plpos.y + 0.2
    user:moveto(plpos, true)
    if tool_capabilities.groupcaps.climbing.maxlevel > 1 then
        plpos = user:get_pos()
        plpos.y = plpos.y + 0.2
        user:moveto(plpos, true)
        plpos = user:get_pos()
        plpos.y = plpos.y + 0.2
        user:moveto(plpos, true)
        if tool_capabilities.groupcaps.climbing.maxlevel > 2 then
            plpos = user:get_pos()
            plpos.y = plpos.y + 0.2
            user:moveto(plpos, true)
            plpos = user:get_pos()
            plpos.y = plpos.y + 0.2
            user:moveto(plpos, true)
        end
    end

    if not (creative and creative.is_enabled_for
            and creative.is_enabled_for(user:get_player_name()))
    then
        -- wear tool
        local uses = tool_capabilities.groupcaps.climbing.uses
        itemstack:add_wear(65535/(uses-1))
        -- tool break sound
        if itemstack:get_count() == 0 and tool_definition.sound and tool_definition.sound.breaks then
            minetest.sound_play(tool_definition.sound.breaks, {pos = pt.above, gain = 0.5})
        end
    end
    return itemstack
end

minetest.register_tool("skytest:pick_wood", {
	description = "Wooden climbing pick",
	inventory_image = "handholds_tool_wood.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			climbing = {times={[3]=1.60}, uses=40, maxlevel=1},
		},
	},
	groups = {flammable = 2},
    on_use = function(itemstack, user, pointed_thing)
        return climbing_pick.pick_on_use(itemstack, user, pointed_thing)
    end,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("skytest:pick_stone", {
	description = "Stone climbing pick",
	inventory_image = "handholds_tool_stone.png",
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps={
			climbing = {times={[2]=2.0, [3]=1.00}, uses=80, maxlevel=1},
		},
	},
    on_use = function(itemstack, user, pointed_thing)
        return climbing_pick.pick_on_use(itemstack, user, pointed_thing)
    end,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("skytest:pick_steel", {
	description = "Steel climbing pick",
	inventory_image = "handholds_tool_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			climbing = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=80, maxlevel=2},
		},
	},
    on_use = function(itemstack, user, pointed_thing)
        return climbing_pick.pick_on_use(itemstack, user, pointed_thing)
    end,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("skytest:pick_bronze", {
	description = "Bronze climbing pick",
	inventory_image = "handholds_tool_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			climbing = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=120, maxlevel=2},
		},
	},
    on_use = function(itemstack, user, pointed_thing)
        return climbing_pick.pick_on_use(itemstack, user, pointed_thing)
    end,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("skytest:pick_mese", {
	description = "Mese climbing pick",
	inventory_image = "handholds_tool_mese.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			climbing = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=80, maxlevel=3},
		},
	},
    on_use = function(itemstack, user, pointed_thing)
        return climbing_pick.pick_on_use(itemstack, user, pointed_thing)
    end,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("skytest:pick_diamond", {
	description = "Diamond climbing pick",
	inventory_image = "handholds_tool_diamond.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			climbing = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=120, maxlevel=3},
		},
	},
    on_use = function(itemstack, user, pointed_thing)
        return climbing_pick.pick_on_use(itemstack, user, pointed_thing)
    end,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "skytest:pick_wood",
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:stick', 'skytest:cloth_fiber', ''},
		{'group:stick', '', ''},
	},
})

minetest.register_craft({
	output = "skytest:pick_stone",
	recipe = {
		{'group:stone', 'group:stone', 'group:stone'},
		{'group:stick', 'skytest:cloth_fiber', ''},
		{'group:stick', '', ''},
	},
})

minetest.register_craft({
	output = "skytest:pick_steel",
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'group:stick', 'skytest:cloth_fiber', ''},
		{'group:stick', '', ''},
	},
})

minetest.register_craft({
	output = "skytest:pick_bronze",
	recipe = {
		{'default:bronze_ingot', 'default:bronze_ingot', 'default:bronze_ingot'},
		{'group:stick', 'skytest:cloth_fiber', ''},
		{'group:stick', '', ''},
	},
})

minetest.register_craft({
	output = "skytest:pick_mese",
	recipe = {
		{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
		{'group:stick', 'skytest:cloth_fiber', ''},
		{'group:stick', '', ''},
	},
})

minetest.register_craft({
	output = "skytest:pick_diamond",
	recipe = {
		{'default:diamond', 'default:diamond', 'default:diamond'},
		{'group:stick', 'skytest:cloth_fiber', 'skytest:cloth_fiber'},
		{'group:stick', 'skytest:cloth_fiber', 'skytest:cloth_fiber'},
	},
})