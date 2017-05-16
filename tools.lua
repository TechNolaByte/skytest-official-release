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
		{'', 'group:wood', ''},
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
minetest.register_tool("skytest:stone_hammer", {
        description = "Stone Hammer",
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
        inventory_image = "skytest_hammer_diamond.png",
        tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=20, maxlevel=3},
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
minetest.register_tool("skytest:silkworm", {
        description = "Silkworm",
        inventory_image = "silkworm.png",
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
        on_use = function(itemstack, user, pointed_thing)
			  if minetest.get_node(pointed_thing.under).name == "default:leaves" then
				minetest.set_node(pointed_thing.under, {name = "skytest:infested_leaves"})
				itemstack:take_item()
				return itemstack
			end
	end,
	sound = {breaks = "default_tool_breaks"},
	stack_max = 99,
    })
minetest.register_tool("skytest:leaf_collector_vm", {
        description = "leaf collector(vein mine leaves)",
        inventory_image = "spears_spear_bronze.png",
        tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=10, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=10, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=10}
		},
		damage_groups = {fleshy=6},
	},
	sound = {breaks = "default_tool_breaks"},
	range = 12,
    })
minetest.register_tool("skytest:leaf_collector_normal", {
        description = "leaf collector(extra reach)",
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

minetest.register_on_dignode(function(pos, oldnode, digger)
	local item = digger:get_wielded_item():to_string()
	if string.match(item, "skytest:leaf_collector_vm") then
		if minetest.get_item_group(oldnode.name, "leaves") ~= 0 then
			leaffeller_loop(pos,digger)
		end
	end
end)


--have this recursively check for tree/leaves around it (1 node radius)
leaffeller_loop = function(pos,digger)

	local min = {x=pos.x-1,y=pos.y-1,z=pos.z-1}
	local max = {x=pos.x+1,y=pos.y+1,z=pos.z+1}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")
	for x = -1,1  do
		for z = -1,1  do
			for y = -1,1  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local pos2 = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local name = minetest.get_name_from_content_id(data[p_pos])
				
				
				
				if placed == nil or placed == "" then
					if minetest.get_item_group(name, "leaves") ~= 0 then
						data[p_pos] = air
						minetest.after(0,function(pos2)
					        leaffeller_loop(pos2)
						end, pos2)
						minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)	
						
					end
				end
			end
		end
	end
	vm:update_liquids()
	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_map()
end

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
minetest.register_craft({
        output = "skytest:leaf_collector_vm",
        recipe = {
            {"skytest:comp_crook","skytest:comp_crook","skytest:comp_crook"},
            {"skytest:comp_crook","skytest:leaf_collector_3x3x1","skytest:comp_crook"},
            {"skytest:comp_crook","skytest:comp_crook","skytest:comp_crook"},
        }
    })