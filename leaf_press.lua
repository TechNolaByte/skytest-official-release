

local function formspec(pos)
	local spos = pos.x..','..pos.y..','..pos.z
	local formspec =
		'size[8,8.5]'..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		'list[nodemeta:'..spos..';src;0,0;8,1;]'..
		'list[nodemeta:'..spos..';dst;3.5,2;1,1;]'..
		'list[current_player;main;0,4.25;8,1;]'..
		'list[current_player;main;0,5.5;8,3;8]'..
		'listring[nodemeta:'..spos ..';dst]'..
		'listring[current_player;main]'..
		'listring[nodemeta:'..spos ..';src]'..
		'listring[current_player;main]'..
		default.get_hotbar_bg(0, 4.25)
	return formspec
end

local function is_compostable(input)
	if minetest.get_item_group(input, 'meltable') > 0 or 

minetest.get_item_group(input, 'meltable') > 0 then
		return true
	else
		return false
	end
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function count_input(pos)
	local q = 0
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k, v in pairs(stacks) do
		q = q + inv:get_stack('src', k):get_count()
	end
	return q
end

local function is_empty(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k, v in pairs(stacks) do
		if not inv:get_stack('src', k):is_empty() then
			return false
		end
	end
	if not inv:get_stack('dst', 1):is_empty() then
		return false
	end
	return true
end

local function update_nodebox(pos)
	if is_empty(pos) then
		swap_node(pos, "skytest:leaf_press_empty")
	else
		swap_node(pos, "skytest:leaf_press")
	end
end

local function update_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local meta = minetest.get_meta(pos)
	local count = count_input(pos)
	if not timer:is_started() and count >= 1 then
		timer:start(1)
		meta:set_int('progress', 0)
		meta:set_string('infotext', 'progress: 0%')
		return
	end
	if timer:is_started() and count < 8 then
		timer:stop()
meta:set_string('infotext', "Empty leaf press.\nTo get water, add some dense leaves.")
		meta:set_int('progress', 0)
	end
end

local function create_compost(pos)
	local q = 8
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k, v in pairs(stacks) do
		local stack = inv:get_stack('src', k)
		if not stack:is_empty() then
			local count = stack:get_count()
			if count <= q then
				inv:set_stack('src', k, '')
				q = q - count
			else
				inv:set_stack('src', k, stack:get_name() .. ' ' .. (count - q))
				q = 0
				break
			end
		end
	end
	local dirt_count = inv:get_stack('dst', 1):get_count()
	inv:set_stack('dst', 1, 'default:water_source ' .. (dirt_count + 1))
end

local function on_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local meta = minetest.get_meta(pos)
	local progress = meta:get_int('progress') + 1
	if progress >= 100 then
		create_compost(pos)
		meta:set_int('progress', 0)
	else
		meta:set_int('progress', progress)
	end
	if count_input(pos) >= 8 then
		meta:set_string('infotext', 'progress: ' .. progress .. '%')
		return true
	else
		timer:stop()
		meta:set_string('infotext', 'Empty leaf press.\nTo get water, add some dense leaves.')
		meta:set_int('progress', 0)
		return false
	end
end

local function on_construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size('src', 8)
	inv:set_size('dst', 1)
	meta:set_string('infotext','Empty leaf press.\nTo get water, add some dense leaves.')
	meta:set_int('progress', 0)
end

local function on_rightclick(pos, node, clicker, itemstack)
	minetest.show_formspec(
		clicker:get_player_name(),
		'skytest:leaf_press',
		formspec(pos)
	)
end

local function can_dig(pos,player)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	if inv:is_empty('src') and inv:is_empty('dst') then
		return true
	else
		return false
	end
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if listname == 'src' and is_compostable(stack:get_name()) then
		return stack:get_count()
	else
		return 0
	end
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	update_timer(pos)
	update_nodebox(pos)
	minetest.log('action', player:get_player_name() .. ' moves stuff to leaf press at ' .. minetest.pos_to_string(pos))
	return
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
	update_timer(pos)
	update_nodebox(pos)
	minetest.log('action', player:get_player_name() .. ' takes stuff from leaf press at ' .. minetest.pos_to_string(pos))
	return
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, 

to_index, count, player)
	local inv = minetest.get_meta(pos):get_inventory()
	if from_list == to_list then 
		return inv:get_stack(from_list, from_index):get_count()
	else
		return 0
	end
end

local function on_punch(pos, node, player, pointed_thing)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local wielded_item = player:get_wielded_item()
	if not wielded_item:is_empty() then
		local wielded_item_name = wielded_item:get_name()
		local wielded_item_count = wielded_item:get_count()
		if is_compostable(wielded_item_name) and inv:room_for_item('src', wielded_item_name) then
			player:set_wielded_item('')
			inv:add_item('src', wielded_item_name .. ' ' .. wielded_item_count)
			minetest.log('action', player:get_player_name() .. ' moves stuff to leaf press at ' .. minetest.pos_to_string(pos))
			update_nodebox(pos)
			update_timer(pos)
		end
	end
	local compost_count = inv:get_stack('dst', 1):get_count()
	local wielded_item = player:get_wielded_item() --recheck
	if compost_count > 0 and wielded_item:is_empty() then
		inv:set_stack('dst', 1, '')
		player:set_wielded_item('default:water_source ' .. compost_count)
		minetest.log('action', player:get_player_name() .. ' takes stuff from leaf press at ' .. minetest.pos_to_string(pos))
		update_nodebox(pos)
		update_timer(pos)
	end
end

minetest.register_node("skytest:leaf_press_empty", {
	description = "Empty leaf press",
	tiles = {
		"default_stone.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/2, 1/2, -3/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -1/2, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -1/2, 3/8, 1/2, 1/2, 1/2},
			{-3/8, -1/2, -3/8, 3/8, 3/8, 3/8},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
        },
	is_ground_content = false,
	groups = {choppy = 3},
	sounds =  default.node_sound_wood_defaults(),
	on_timer = on_timer,
	on_construct = on_construct,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
	on_punch = on_punch,

})

minetest.register_node("skytest:leaf_press", {
	description = "leaf press",
	tiles = {
		"default_stone.png^default_leaves.png",
                "default_stone.png",
	},
	drawtype = "nodebox",
        paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/2, 1/2, -3/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -1/2, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -1/2, 3/8, 1/2, 1/2, 1/2},
			{-3/8, -1/2, -3/8, 3/8, 3/8, 3/8}},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	is_ground_content = false,
	groups = {choppy = 5, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),
	on_timer = on_timer,
	on_construct = on_construct,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
	on_punch = on_punch,
})

minetest.register_craft({
	output = "skytest:leaf_press_empty",
	recipe = {
		{"skytest:leaf_weight", "skytest:leaf_weight", "skytest:leaf_weight"},
		{"group:wood", "skytest:leaf_weight", "group:wood"},
		{"group:wood", "group:wood", "group:wood"}
	}
})