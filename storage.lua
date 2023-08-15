
drawers = {}
drawers.drawer_visuals = {}
function drawers.node_tiles_front_other(front, other)
	return {other, other, other, other, other, front}
end
if core.get_modpath("default") and default then
drawers.WOOD_SOUNDS = default.node_sound_wood_defaults()
drawers.WOOD_ITEMSTRING = "group:wood"
	drawers.CHEST_ITEMSTRING = "default:chest"
else
	drawers.WOOD_ITEMSTRING = "group:wood"
	drawers.CHEST_ITEMSTRING = "chest"
end


drawers.enable_1x1 = not core.setting_getbool("drawers_disable_1x1")
drawers.enable_1x2 = not core.setting_getbool("drawers_disable_1x2")
drawers.enable_2x2 = not core.setting_getbool("drawers_disable_2x2")


drawers.node_box_simple = {
	{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5},
	{-0.5, -0.5, -0.5, -0.4375, 0.5, -0.4375},
	{0.4375, -0.5, -0.5, 0.5, 0.5, -0.4375},
	{-0.4375, 0.4375, -0.5, 0.4375, 0.5, -0.4375},
	{-0.4375, -0.5, -0.5, 0.4375, -0.4375, -0.4375},
}

-- construct drawer
function drawers.drawer_on_construct(pos)
	local node = core.get_node(pos)
	local ndef = core.registered_nodes[node.name]
	local drawerType = ndef.groups.drawer

	local base_stack_max = core.nodedef_default.stack_max or 99
	local stack_max_factor = ndef.drawer_stack_max_factor or 24 -- 3x8
	stack_max_factor = math.floor(stack_max_factor / drawerType) -- drawerType => number of drawers in node

	-- meta
	local meta = core.get_meta(pos)

	local i = 1
	while i <= drawerType do
		local vid = i
		-- 1x1 drawers don't have numbers in the meta fields
		if drawerType == 1 then vid = "" end
		meta:set_string("name"..vid, "")
		meta:set_int("count"..vid, 0)
		meta:set_int("max_count"..vid, base_stack_max * stack_max_factor)
		meta:set_int("base_stack_max"..vid, base_stack_max)
		meta:set_string("entity_infotext"..vid, drawers.gen_info_text("Empty", 0,
			stack_max_factor, base_stack_max))
		meta:set_int("stack_max_factor"..vid, stack_max_factor)

		i = i + 1
	end

	drawers.spawn_visuals(pos)
end

-- destruct drawer
function drawers.drawer_on_destruct(pos)
	drawers.remove_visuals(pos)

	-- clean up visual cache
	if drawers.drawer_visuals[core.serialize(pos)] then
		drawers.drawer_visuals[core.serialize(pos)] = nil
	end
end

-- drop all items
function drawers.drawer_on_dig(pos, node, player)
	local drawerType = 1
	if core.registered_nodes[node.name] then
		drawerType = core.registered_nodes[node.name].groups.drawer
	end

	local meta = core.get_meta(pos)

	local k = 1
	while k <= drawerType do
		-- don't add a number in meta fields for 1x1 drawers
		local vid = tostring(k)
		if drawerType == 1 then vid = "" end
		local count = meta:get_int("count"..vid)
		local name = meta:get_string("name"..vid)

		-- drop the items
		local stack_max = ItemStack(name):get_stack_max()

		local j = math.floor(count / stack_max) + 1
		local i = 1
		while i <= j do
			local rndpos = drawers.randomize_pos(pos)
			if not (i == j) then
				core.add_item(rndpos, name .. " " .. stack_max)
			else
				core.add_item(rndpos, name .. " " .. count % stack_max)
			end
			i = i + 1
		end
		k = k + 1
	end

	-- remove node
	core.node_dig(pos, node, player)
end

function drawers.drawer_insert_object(pos, node, stack, direction)
	local drawer_visuals = drawers.drawer_visuals[core.serialize(pos)]
	if not drawer_visuals then return stack end

	local leftover = stack
	for _, visual in pairs(drawer_visuals) do
		leftover = visual.try_insert_stack(visual, leftover, true)
	end
	return leftover
end

function drawers.register_drawer(name, def)
	def.description = def.description or "Wooden"
	def.drawtype = "nodebox"
	def.node_box = {type = "fixed", fixed = drawers.node_box_simple}
	def.collision_box = {type = "regular"}
	def.selection_box = {type = "fixed", fixed = drawers.node_box_simple}
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.groups = def.groups or {}
	def.drawer_stack_max_factor = def.drawer_stack_max_factor or 24

	-- events
	def.on_construct = drawers.drawer_on_construct
	def.on_destruct = drawers.drawer_on_destruct
	def.on_dig = drawers.drawer_on_dig

	if minetest.get_modpath("screwdriver") and screwdriver then
		def.on_rotate = def.on_rotate or screwdriver.disallow
	end

	if minetest.get_modpath("pipeworks") and pipeworks then
		def.groups.tubedevice = 1
		def.groups.tubedevice_receiver = 1
		def.tube = def.tube or {}
		def.tube.insert_object = def.tube.insert_object or
			drawers.drawer_insert_object
		def.tube.connect_sides = {left = 1, right = 1, back = 1, top = 1,
			bottom = 1}
		def.after_place_node = pipeworks.after_place
		def.after_dig_node = pipeworks.after_dig
	end

	if drawers.enable_1x1 then
		-- normal drawer 1x1 = 1
		local def1 = table.copy(def)
		def1.description = "@1 Drawer", def.description
		def1.tiles = def.tiles or def.tiles1
		def1.tiles1 = nil
		def1.tiles2 = nil
		def1.tiles4 = nil
		def1.groups.drawer = 1
		core.register_node(name .. "1", def1)
		core.register_alias(name, name .. "1") -- 1x1 drawer is the default one
	end

	if drawers.enable_1x2 then
		-- 1x2 = 2
		local def2 = table.copy(def)
		def2.description = "@1 Drawers (1x2)", def.description
		def2.tiles = def.tiles2
		def2.tiles1 = nil
		def2.tiles2 = nil
		def2.tiles4 = nil
		def2.groups.drawer = 2
		core.register_node(name .. "2", def2)
	end

	if drawers.enable_2x2 then
		-- 2x2 = 4
		local def4 = table.copy(def)
		def4.description = "@1 Drawers (2x2)", def.description
		def4.tiles = def.tiles4
		def4.tiles1 = nil
		def4.tiles2 = nil
		def4.tiles4 = nil
		def4.groups.drawer = 4
		core.register_node(name .. "4", def4)
	end

	if (not def.no_craft) and def.material then
		if drawers.enable_1x1 then
			core.register_craft({
				output = name .. "1",
				recipe = {
					{def.material, def.material, def.material},
					{    "", drawers.CHEST_ITEMSTRING,  ""   },
					{def.material, def.material, def.material}
				}
			})
		end
		if drawers.enable_1x2 then
			core.register_craft({
				output = name .. "2 2",
				recipe = {
					{def.material, drawers.CHEST_ITEMSTRING, def.material},
					{def.material,       def.material,       def.material},
					{def.material, drawers.CHEST_ITEMSTRING, def.material}
				}
			})
		end
		if drawers.enable_2x2 then
			core.register_craft({
				output = name .. "4 4",
				recipe = {
					{drawers.CHEST_ITEMSTRING, def.material, drawers.CHEST_ITEMSTRING},
					{      def.material,       def.material,       def.material      },
					{drawers.CHEST_ITEMSTRING, def.material, drawers.CHEST_ITEMSTRING}
				}
			})
		end
	end
end

if core.get_modpath("default") and default then
	drawers.register_drawer("skytest:wood", {
		description = "Wooden",
		tiles1 = drawers.node_tiles_front_other("drawers_wood_front_1.png",
			"drawers_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_wood_front_2.png",
			"drawers_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_wood_front_4.png",
			"drawers_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 8, -- normal chest size
		material = drawers.WOOD_ITEMSTRING
	})
	drawers.register_drawer("skytest:acacia_wood", {
		description = "Acacia Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_acacia_wood_front_1.png",
			"drawers_acacia_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_acacia_wood_front_2.png",
			"drawers_acacia_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_acacia_wood_front_4.png",
			"drawers_acacia_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 8, -- normal mcl chest size
		material = "default:acacia_wood"
	})
	drawers.register_drawer("skytest:aspen_wood", {
		description = "Aspen Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_aspen_wood_front_1.png",
			"drawers_aspen_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_aspen_wood_front_2.png",
			"drawers_aspen_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_aspen_wood_front_4.png",
			"drawers_aspen_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 8, -- normal chest size
		material = "default:aspen_wood"
	})
	drawers.register_drawer("skytest:junglewood", {
		description = "Junglewood",
		tiles1 = drawers.node_tiles_front_other("drawers_junglewood_front_1.png",
			"drawers_junglewood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_junglewood_front_2.png",
			"drawers_junglewood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_junglewood_front_4.png",
			"drawers_junglewood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 8, -- normal mcl chest size
		material = "default:junglewood"
	})
	drawers.register_drawer("skytest:pine_wood", {
		description = "Pine Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_pine_wood_front_1.png",
			"drawers_pine_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_pine_wood_front_2.png",
			"drawers_pine_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_pine_wood_front_4.png",
			"drawers_pine_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 8, -- normal chest size
		material = "default:pine_wood"
	})
elseif core.get_modpath("mcl_core") and mcl_core then
	drawers.register_drawer("skytest:oakwood", {
		description = "Oak Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_oak_wood_front_1.png",
			"drawers_oak_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_oak_wood_front_2.png",
			"drawers_oak_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_oak_wood_front_4.png",
			"drawers_oak_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 9, -- normal mcl chest size
		material = drawers.WOOD_ITEMSTRING
	})
	drawers.register_drawer("skytest:acaciawood", {
		description = "Acacia Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_acacia_wood_mcl_front_1.png",
			"drawers_acacia_wood_mcl.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_acacia_wood_mcl_front_2.png",
			"drawers_acacia_wood_mcl.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_acacia_wood_mcl_front_4.png",
			"drawers_acacia_wood_mcl.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 9, -- normal mcl chest size
		material = "mcl_core:acaciawood"
	})
	drawers.register_drawer("skytest:birchwood", {
		description = "Birch Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_birch_wood_front_1.png",
			"drawers_birch_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_birch_wood_front_2.png",
			"drawers_birch_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_birch_wood_front_4.png",
			"drawers_birch_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 9, -- normal mcl chest size
		material = "mcl_core:birchwood"
	})
	drawers.register_drawer("skytest:darkwood", {
		description = "Dark Oak Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_dark_oak_wood_front_1.png",
			"drawers_dark_oak_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_dark_oak_wood_front_2.png",
			"drawers_dark_oak_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_dark_oak_wood_front_4.png",
			"drawers_dark_oak_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 9, -- normal mcl chest size
		material = "mcl_core:darkwood"
	})
	drawers.register_drawer("skytest:junglewood", {
		description = "Junglewood",
		tiles1 = drawers.node_tiles_front_other("drawers_junglewood_mcl_front_1.png",
			"drawers_junglewood_mcl.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_junglewood_mcl_front_2.png",
			"drawers_junglewood_mcl.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_junglewood_mcl_front_4.png",
			"drawers_junglewood_mcl.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 9, -- normal mcl chest size
		material = "mcl_core:junglewood"
	})
	drawers.register_drawer("skytest:sprucewood", {
		description = "Spruce Wood",
		tiles1 = drawers.node_tiles_front_other("drawers_spruce_wood_front_1.png",
			"drawers_spruce_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_spruce_wood_front_2.png",
			"drawers_spruce_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_spruce_wood_front_4.png",
			"drawers_spruce_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 9, -- normal mcl chest size
		material = "mcl_core:sprucewood"
	})

	-- backwards compatibility
	core.register_alias("skytest:wood1", "skytest:oakwood1")
	core.register_alias("skytest:wood2", "skytest:oakwood2")
	core.register_alias("skytest:wood4", "skytest:oakwood4")
else
	drawers.register_drawer("skytest:wood", {
		description = "Wooden",
		tiles1 = drawers.node_tiles_front_other("drawers_wood_front_1.png",
			"drawers_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_wood_front_2.png",
			"drawers_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_wood_front_4.png",
			"drawers_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 3 * 8, -- normal chest size
		material = drawers.WOOD_ITEMSTRING
	})
end

function drawers.gen_info_text(basename, count, factor, stack_max)
	local maxCount = stack_max * factor
	local percent = count / maxCount * 100
	-- round the number (float -> int)
	percent = math.floor(percent + 0.5)

	if count == 0 then
		return "@1 (@2% full)", basename, tostring(percent)
	else
		return "@1 @2 (@3% full)", tostring(count), basename, tostring(percent)
	end
end

function drawers.get_inv_image(name)
	local texture = "blank.png"
	local def = core.registered_items[name]
	if not def then return end

	if def.inventory_image and #def.inventory_image > 0 then
		texture = def.inventory_image
	else
		if not def.tiles then return texture end
		local tiles = table.copy(def.tiles)

		for k,v in pairs(tiles) do
			if type(v) == "table" then
				tiles[k] = v.name
			end
		end

		-- tiles: up, down, right, left, back, front
		-- inventorycube: up, front, right
		if #tiles <= 2 then
			texture = core.inventorycube(tiles[1], tiles[1], tiles[1])
		elseif #tiles <= 5 then
			texture = core.inventorycube(tiles[1], tiles[3], tiles[3])
		else -- full tileset
			texture = core.inventorycube(tiles[1], tiles[6], tiles[3])
		end
	end

	return texture
end

function drawers.spawn_visuals(pos)
	local node = core.get_node(pos)
	local ndef = core.registered_nodes[node.name]
	local drawerType = ndef.groups.drawer

	-- data for the new visual
	drawers.last_drawer_pos = pos
	drawers.last_drawer_type = drawerType

	if drawerType == 1 then -- 1x1 drawer
		drawers.last_visual_id = ""
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name"))

		local bdir = core.facedir_to_dir(node.param2)
		local fdir = vector.new(-bdir.x, 0, -bdir.z)
		local pos2 = vector.add(pos, vector.multiply(fdir, 0.438))

		local obj = core.add_entity(pos2, "skytest:visual")

		if bdir.x < 0 then obj:setyaw(0.5 * math.pi) end
		if bdir.z < 0 then obj:setyaw(math.pi) end
		if bdir.x > 0 then obj:setyaw(1.5 * math.pi) end

		drawers.last_texture = nil
	elseif drawerType == 2 then
		local bdir = core.facedir_to_dir(node.param2)

		local fdir1
		local fdir2
		if node.param2 == 2 or node.param2 == 0 then
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x, -0.5, -bdir.z)
		else
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x, -0.5, -bdir.z)
		end

		local objs = {}

		drawers.last_visual_id = 1
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name1"))
		local pos1 = vector.add(pos, vector.multiply(fdir1, 0.438))
		objs[1] = core.add_entity(pos1, "skytest:visual")

		drawers.last_visual_id = 2
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name2"))
		local pos2 = vector.add(pos, vector.multiply(fdir2, 0.438))
		objs[2] = core.add_entity(pos2, "skytest:visual")

		for i,obj in pairs(objs) do
			if bdir.x < 0 then obj:setyaw(0.5 * math.pi) end
			if bdir.z < 0 then obj:setyaw(math.pi) end
			if bdir.x > 0 then obj:setyaw(1.5 * math.pi) end
		end
	else -- 2x2 drawer
		local bdir = core.facedir_to_dir(node.param2)

		local fdir1
		local fdir2
		local fdir3
		local fdir4
		if node.param2 == 2 then
			fdir1 = vector.new(-bdir.x + 0.5, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x - 0.5, 0.5, -bdir.z)
			fdir3 = vector.new(-bdir.x + 0.5, -0.5, -bdir.z)
			fdir4 = vector.new(-bdir.x - 0.5, -0.5, -bdir.z)
		elseif node.param2 == 0 then
			fdir1 = vector.new(-bdir.x - 0.5, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x + 0.5, 0.5, -bdir.z)
			fdir3 = vector.new(-bdir.x - 0.5, -0.5, -bdir.z)
			fdir4 = vector.new(-bdir.x + 0.5, -0.5, -bdir.z)
		elseif node.param2 == 1 then
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z + 0.5)
			fdir2 = vector.new(-bdir.x, 0.5, -bdir.z - 0.5)
			fdir3 = vector.new(-bdir.x, -0.5, -bdir.z + 0.5)
			fdir4 = vector.new(-bdir.x, -0.5, -bdir.z - 0.5)
		else
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z - 0.5)
			fdir2 = vector.new(-bdir.x, 0.5, -bdir.z + 0.5)
			fdir3 = vector.new(-bdir.x, -0.5, -bdir.z - 0.5)
			fdir4 = vector.new(-bdir.x, -0.5, -bdir.z + 0.5)
		end

		local objs = {}

		drawers.last_visual_id = 1
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name1"))
		local pos1 = vector.add(pos, vector.multiply(fdir1, 0.438))
		objs[1] = core.add_entity(pos1, "skytest:visual")

		drawers.last_visual_id = 2
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name2"))
		local pos2 = vector.add(pos, vector.multiply(fdir2, 0.438))
		objs[2] = core.add_entity(pos2, "skytest:visual")

		drawers.last_visual_id = 3
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name3"))
		local pos3 = vector.add(pos, vector.multiply(fdir3, 0.438))
		objs[3] = core.add_entity(pos3, "skytest:visual")

		drawers.last_visual_id = 4
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name4"))
		local pos4 = vector.add(pos, vector.multiply(fdir4, 0.438))
		objs[4] = core.add_entity(pos4, "skytest:visual")


		for i,obj in pairs(objs) do
			if bdir.x < 0 then obj:setyaw(0.5 * math.pi) end
			if bdir.z < 0 then obj:setyaw(math.pi) end
			if bdir.x > 0 then obj:setyaw(1.5 * math.pi) end
		end
	end
end

function drawers.remove_visuals(pos)
	local objs = core.get_objects_inside_radius(pos, 0.537)
	if not objs then return end

	for _, obj in pairs(objs) do
		if obj and obj:get_luaentity() and
				obj:get_luaentity().name == "skytest:visual" then
			obj:remove()
		end
	end
end

function drawers.randomize_pos(pos)
	local rndpos = table.copy(pos)
	local x = math.random(-50, 50) * 0.01
	local z = math.random(-50, 50) * 0.01
	rndpos.x = rndpos.x + x
	rndpos.y = rndpos.y + 0.25
	rndpos.z = rndpos.z + z
	return rndpos
end

core.register_entity("skytest:visual", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.4374, -0.4374, 0,  0.4374, 0.4374, 0}, -- for param2 0, 2
		visual = "upright_sprite", -- "wielditem" for items without inv img?
		visual_size = {x = 0.6, y = 0.6},
		textures = {"blank.png"},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		is_visible = true,
	},

	get_staticdata = function(self)
		return core.serialize({
			drawer_posx = self.drawer_pos.x,
			drawer_posy = self.drawer_pos.y,
			drawer_posz = self.drawer_pos.z,
			texture = self.texture,
			drawerType = self.drawerType,
			visualId = self.visualId
		})
	end,

	on_activate = function(self, staticdata, dtime_s)
		-- Restore data
		local data = core.deserialize(staticdata)
		if data then
			self.drawer_pos = {
				x = data.drawer_posx,
				y = data.drawer_posy,
				z = data.drawer_posz,
			}
			self.texture = data.texture
			self.drawerType = data.drawerType or 1
			self.visualId = data.visualId or ""

			-- backwards compatibility
			if self.texture == "drawers_empty.png" then
				self.texture = "blank.png"
			end
		else
			self.drawer_pos = drawers.last_drawer_pos
			self.texture = drawers.last_texture or "blank.png"
			self.visualId = drawers.last_visual_id
			self.drawerType = drawers.last_drawer_type
		end

		-- add self to public drawer visuals
		-- this is needed because there is no other way to get this class
		-- only the underlying LuaEntitySAO
		-- PLEASE contact me, if this is wrong
		local vId = self.visualId
		if vId == "" then vId = 1 end
		local posstr = core.serialize(self.drawer_pos)
		if not drawers.drawer_visuals[posstr] then
			drawers.drawer_visuals[posstr] = {[vId] = self}
		else
			drawers.drawer_visuals[posstr][vId] = self
		end


		local node = core.get_node(self.drawer_pos)

		-- collisionbox
		local colbox
		if self.drawerType ~= 2 then
			if node.param2 == 1 or node.param2 == 3 then
				colbox = {0, -0.4374, -0.4374,  0, 0.4374, 0.4374}
			else
				colbox = {-0.4374, -0.4374, 0,  0.4374, 0.4374, 0} -- for param2 = 0 or 2
			end
			-- only half the size if it's a small drawer
			if self.drawerType > 1 then
				for i,j in pairs(colbox) do
					colbox[i] = j * 0.5
				end
			end
		else
			if node.param2 == 1 or node.param2 == 3 then
				colbox = {0, -0.2187, -0.4374,  0, 0.2187, 0.4374}
			else
				colbox = {-0.4374, -0.2187, 0,  0.4374, 0.2187, 0} -- for param2 = 0 or 2
			end
		end

		-- visual size
		local visual_size = {x = 0.6, y = 0.6}
		if self.drawerType >= 2 then
			visual_size = {x = 0.3, y = 0.3}
		end


		-- drawer values
		local meta = core.get_meta(self.drawer_pos)
		local vid = self.visualId
		self.count = meta:get_int("count"..vid)
		self.itemName = meta:get_string("name"..vid)
		self.maxCount = meta:get_int("max_count"..vid)
		self.itemStackMax = meta:get_int("base_stack_max"..vid)
		self.stackMaxFactor = meta:get_int("stack_max_factor"..vid)


		-- infotext
		local infotext = meta:get_string("entity_infotext"..vid) .. "\n\n\n\n\n"

		self.object:set_properties({
			collisionbox = colbox,
			infotext = infotext,
			textures = {self.texture},
			visual_size = visual_size
		})

		-- make entity undestroyable
		self.object:set_armor_groups({immortal = 1})
	end,

	on_rightclick = function(self, clicker)
		local leftover = self.try_insert_stack(self, clicker:get_wielded_item(),
			not clicker:get_player_control().sneak)

		clicker:set_wielded_item(leftover)
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local meta = core.get_meta(self.drawer_pos)

		if self.count <= 0 then
			return
		end

		local removeCount = 1
		if not puncher:get_player_control().sneak then
			removeCount = ItemStack(self.itemName):get_stack_max()
		end
		if removeCount > self.count then removeCount = self.count end

		local stack = ItemStack(self.itemName)
		stack:set_count(removeCount)

		local inv = puncher:get_inventory()
		if not inv:room_for_item("main", stack) then
			return
		end

		inv:add_item("main", stack)
		self.count = self.count - removeCount
		meta:set_int("count"..self.visualId, self.count)

		-- update infotext
		local itemDescription = ""
		if core.registered_items[self.itemName] then
			itemDescription = core.registered_items[self.itemName].description
		end

		if self.count <= 0 then
			self.itemName = ""
			meta:set_string("name"..self.visualId, self.itemName)
			self.texture = "blank.png"
			itemDescription = "Empty"
		end

		local infotext = drawers.gen_info_text(itemDescription,
			self.count, self.stackMaxFactor, self.itemStackMax)
		meta:set_string("entity_infotext"..self.visualId, infotext)

		self.object:set_properties({
			infotext = infotext .. "\n\n\n\n\n",
			textures = {self.texture}
		})
	end,

	try_insert_stack = function(self, itemstack, insert_stack)
		local stackCount = itemstack:get_count()
		local stackName = itemstack:get_name()

		-- if nothing to be added, return
		if stackCount <= 0 then return itemstack end
		-- if no itemstring, return
		if stackName == "" then return itemstack end

		-- only add one, if player holding sneak key
		if not insert_stack then
			stackCount = 1
		end

		-- if current itemstring is not empty
		if self.itemName ~= "" then
			-- check if same item
			if stackName ~= self.itemName then return itemstack end
		else -- is empty
			self.itemName = stackName
			self.count = 0

			-- get new stack max
			self.itemStackMax = ItemStack(self.itemName):get_stack_max()
			self.maxCount = self.itemStackMax * self.stackMaxFactor
		end

		-- Don't add items stackable only to 1
		if self.itemStackMax == 1 then
			return itemstack
		end

		-- set new counts:
		-- if new count is more than max_count
		if (self.count + stackCount) > self.maxCount then
			itemstack:set_count(self.count + stackCount - self.maxCount)
			self.count = self.maxCount
		else -- new count fits
			self.count = self.count + stackCount
			-- this is for only removing one
			itemstack:set_count(itemstack:get_count() - stackCount)
		end

		-- get meta
		local meta = core.get_meta(self.drawer_pos)

		-- update infotext
		local itemDescription
		if core.registered_items[self.itemName] then
			itemDescription = core.registered_items[self.itemName].description
		else
			itemDescription = "Empty"
		end
		local infotext = drawers.gen_info_text(itemDescription,
			self.count, self.stackMaxFactor, self.itemStackMax)
		meta:set_string("entity_infotext"..self.visualId, infotext)

		-- texture
		self.texture = drawers.get_inv_image(self.itemName)

		self.object:set_properties({
			infotext = infotext .. "\n\n\n\n\n",
			textures = {self.texture}
		})

		self.saveMetaData(self, meta)

		if itemstack:get_count() == 0 then itemstack = ItemStack("") end
		return itemstack
	end,

	saveMetaData = function(self, meta)
		meta:set_int("count"..self.visualId, self.count)
		meta:set_string("name"..self.visualId, self.itemName)
		meta:set_int("max_count"..self.visualId, self.maxCount)
		meta:set_int("base_stack_max"..self.visualId, self.itemStackMax)
		meta:set_int("stack_max_factor"..self.visualId, self.stackMaxFactor)
	end
})

core.register_lbm({
	name = "skytest:restore_visual",
	nodenames = {"group:drawer"},
	run_at_every_load = true,
	action  = function(pos, node)
		local drawerType = core.registered_nodes[node.name].groups.drawer
		local foundVisuals = 0
		local objs = core.get_objects_inside_radius(pos, 0.537)
		if objs then
			for _, obj in pairs(objs) do
				if obj and obj:get_luaentity() and
						obj:get_luaentity().name == "skytest:visual" then
					foundVisuals = foundVisuals + 1
				end
			end
		end
		-- if all drawer visuals were found, return
		if foundVisuals == drawerType then
			return
		end

		-- not enough visuals found, remove existing and create new ones
		drawers.remove_visuals(pos)
		drawers.spawn_visuals(pos)
	end
})
local function format(str, ...)
	local args = { ... }
	local function repl(escape, open, num, close)
		if escape == "" then
			local replacement = tostring(args[tonumber(num)])
			if open == "" then
				replacement = replacement..close
			end
			return replacement
		else
			return "@"..open..num..close
		end
	end
	return (str:gsub("(@?)@(%(?)(%d+)(%)?)", repl))
end

local tiers = {
}
if (minetest.get_modpath("extra_util")~=nil) then
 tiers = {
	{	name = "dsu",
		description = "DSU(Deep Storage Unit)",
		capacity = 2000000000,
		material = "extra_util:bedrockium_ingot",
		base = "skytest:enchanted_block",
		texture = "dsu_front.png"
	},
}
end
local default_texture = "default_obsidian_glass_detail.png"

-- update cache button toggles

local function update_formspec(pos)
	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local locked = meta:get_int("locked")
	local output = meta:get_int("output")

	if locked == 0 then
		locks = "lock;Lock"
	else
		locks = "unlock;Unlock"
	end
	if output == 0 then
		outs = "output;Output"
	else
		outs = "stop;Stop"
	end

	meta:set_string("showform", "size[4,3]"..
			default.gui_bg..
			default.gui_bg_img..
			default.gui_slots..
			"button_exit[0,0;2,1;store;Store]"..
			"button_exit[2,0;2,1;take;Take]"..
			"button_exit[0,1;2,1;"..locks.."]"..
			"button_exit[2,1;2,1;"..outs.."]"..
			"button_exit[1,2;2,1;transfer;Transfer]"
		)
end

-- find the entity associated with a cache, if any

local function find_visual(pos)
	local objs = minetest.get_objects_inside_radius(pos, 0.65)
	if objs then
		for _, obj in pairs(objs) do
			if obj and obj:get_luaentity() and
					obj:get_luaentity().name == "skytest:visual" then
				return obj
			end
		end
	end
end

-- get inventory image

local function get_inv_image(name)
	local t = default_texture
	local d = minetest.registered_items[name]
	if name ~= "air" and d then
		if d.inventory_image and #d.inventory_image > 0 then
			t = d.inventory_image
		else
			local c = #d.tiles
			local x = {}
			for i, v in ipairs(d.tiles) do
				if type(v) == "table" then
					x[i] = v.name
				else
					x[i] = v
				end
				i = i + 1
			end
			if not x[3] then x[3] = x[1] end
			if not x[4] then x[4] = x[3] end
			t = minetest.inventorycube(x[1], x[3], x[4])
		end
	end
	return t
end

-- update info about this cache

local function update_infotext(pos)
	local meta = minetest.get_meta(pos)
	local capacity = meta:get_int("capacity")
	local count = meta:get_int("count")
	local name = meta:get_string("name")
	local locked = meta:get_int("locked")

	local item = ""
	if name ~= "air" then
		local def = minetest.registered_items[name]
		if def and def.description then item = def.description end
	end

	meta:set_string("infotext", item.." "..tostring(count).." / "..
		tostring(capacity))

	-- update visual

	local obj = find_visual(pos)
	if not obj then
		local node = minetest.get_node(pos)
		local bdir = minetest.facedir_to_dir(node.param2)
		local fdir = vector.new(-bdir.x, 0, -bdir.z)
		local pos2 = vector.add(pos, vector.multiply(fdir, 0.51))
		obj = minetest.add_entity(pos2, "skytest:visual")
		if bdir.x < 0 then obj:setyaw(0.5 * math.pi) end
		if bdir.z < 0 then obj:setyaw(math.pi) end
		if bdir.x > 0 then obj:setyaw(1.5 * math.pi) end
	end
	if obj then
		local t = get_inv_image(name)
		if locked > 0 then t = t.."^caches_locked.png" end
		obj:set_properties({textures = {t}})
	end
end

-- put indicated stack of items into cache, returns leftovers

local function add_item(pos, stack)
	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local capacity = meta:get_int("capacity")
	local cache_count = meta:get_int("count")
	local locked = meta:get_int("locked")
	local left_over = ItemStack(stack)
	local stack_count = stack:get_count()

	-- cancel if itemstack is 0 or a unique thing
	if stack_count == 0 then return stack end

	if (locked == 0 and cache_count == 0) or stack:get_name() == name then
		if cache_count < capacity then
			local real_count = math.min(capacity - cache_count, stack_count)
			meta:set_int("count", cache_count + real_count)
			if stack:get_name() ~= name then
				meta:set_string("name", stack:get_name())
			end
			if stack_count == real_count then
				left_over:clear()
			else
				left_over:set_count(stack_count - real_count)
			end
			update_infotext(pos)
		end
	end
	
	return left_over
end

-- return whether the the stack fully fits within the cache

local function room_for_item(pos, stack)
	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local capacity = meta:get_int("capacity")
	local cache_count = meta:get_int("count")
	local locked = meta:get_int("locked")

	-- cancel if itemstack is 0 or a unique thing
	if stack:get_count() == 0 or stack:get_stack_max() == 1 then return false end

	if (locked == 0 and cache_count == 0) or stack:get_name() == name then
		if cache_count + stack:get_count() <= capacity then
			return true
		else
			return false
		end
	end
end

-- take items from cache and transfer them to inv
-- do_stack is an optional bool indicating whether to take a max stack
-- returns true if anything was transferred

local function remove_item(pos, inv, listname, do_stack)
	local meta = minetest.get_meta(pos)
	local cache_count = meta:get_int("count")
	local locked = meta:get_int("locked")

	if cache_count > 0 then
		local name = meta:get_string("name")
		local real_count = 1
		if do_stack then
			real_count = ItemStack(name):get_stack_max()
		end
		if real_count > cache_count then real_count = cache_count end

		local stack = ItemStack(name)
		stack:set_count(real_count)
		if inv:room_for_item(listname, stack) then
			inv:add_item(listname, stack)
			meta:set_int("count", cache_count - real_count)
			if cache_count == real_count and locked == 0 then
				meta:set_string("name", "air")
			end
			update_infotext(pos)
			return true
		end
	end

	return false
end

-- check whether the player has access to the cache

local function can_access(pos, player)
	if minetest.is_protected(pos, player) then
		minetest.chat_send_player(player:get_player_name(),
			"You are not permitted to access caches in this area.")
		return false
	end
	return true
end

-- other features

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if string.sub(formname, 1, 12) ~= "skytest:cache" then return end
	local pos = minetest.string_to_pos(string.sub(formname, 13))

	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local capacity = meta:get_int("capacity")
	local count = meta:get_int("count")
	local locked = meta:get_int("locked")

	if fields.store then
		local inv = player:get_inventory()
		if inv then
			local n = name
			local wield = player:get_wielded_item()
			if count == 0 and locked == 0 then
				n = wield:get_name()
			end
			local full_stack = ItemStack(n)
			full_stack:set_count(full_stack:get_stack_max())
			local stack = inv:remove_item("main", full_stack)
			while room_for_item(pos, stack) and not stack:is_empty() do
				add_item(pos, stack)
				stack = inv:remove_item("main", full_stack)
			end
			if not stack:is_empty() then
				local left = add_item(pos, stack)
				inv:add_item("main", left)
			end
		end
	end

	if fields.take then
		local inv = player:get_inventory()
		if inv then
			local b = true
			while b do
				b = remove_item(pos, inv, "main", true)
			end
		end
	end

	if fields.lock and name ~= "air" then
		meta:set_int("locked", 1)
		update_infotext(pos)
	end
	if fields.unlock then
		meta:set_int("locked", 0)
		update_infotext(pos)
	end
	if fields.output then
		meta:set_int("output", 1)
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end
	if fields.stop then meta:set_int("output", 0) end

	if fields.transfer then
		local inv = player:get_inventory()
		local data = { name = name, count = count, locked = locked }
		local item = ItemStack(minetest.get_node(pos).name)
		item:set_metadata(minetest.serialize(data))
		if inv:room_for_item("main", item) then
			inv:add_item("main", item)
		else
			minetest.add_item(player:getpos(), item)
		end
		minetest.remove_node(pos)
		local obj = find_visual(pos)
		if obj then obj:remove() end
	end
	update_formspec(pos)
end)

-- putting stuff in place

local function on_rightclick(pos, node, clicker, itemstack, pointed_thing)
	if can_access(pos, clicker) then
		if itemstack and not itemstack:is_empty() then
			if clicker:get_player_control().sneak then
				if add_item(pos, ItemStack(itemstack:get_name())):is_empty() then
					itemstack:take_item()
				end
				return itemstack
			else
				return add_item(pos, itemstack)
			end
		else
			local meta = minetest.get_meta(pos)
			local formspec = meta:get_string("showform")
			local formname = "skytest:cache"..minetest.pos_to_string(pos)
			minetest.show_formspec(clicker:get_player_name(), formname, formspec)
		end
	end
	return itemstack
end

-- restore proper function to core.item_place for my nodes
-- (so I can actually use the sneak key)

local old_item_place = core.item_place

local function caches_item_place(itemstack, placer, pointed_thing, param2)
	if pointed_thing.type == "node" and placer then
		local n = minetest.get_node(pointed_thing.under)
		local nn = n.name

		if minetest.get_item_group(nn, "caches") > 0 then

			-- need to get the real name and not fake ones
			local i = itemstack:get_name()
			local d = minetest.registered_items[i]
			if d and d.drop then
				-- ignore default items and non-strings
				if type(d.drop) == "string" and not string.match(i, "default:.+") then
					itemstack:set_name(d.drop)
				end
			end
			return on_rightclick(pointed_thing.under, n,
					placer, itemstack, pointed_thing) or itemstack, false
		end
	end

	return old_item_place(itemstack, placer, pointed_thing, param2)
end

core.item_place = caches_item_place

-- handle transfer of meta on crafted upgrades

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if minetest.get_item_group(itemstack:get_name(), "caches") > 0 then
		local i = 1
		local craft_size = player:get_inventory():get_size("craft")
		while i <= craft_size do
			local old = old_craft_grid[i]
			i = i + 1
			if minetest.get_item_group(old:get_name(), "caches") > 0 then
				-- copy old cache meta to output stack
				itemstack:set_metadata(old:get_metadata())
				return
			end
		end
	end
end)

-- output a stack below the cache

local function do_output(pos)
	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local cache_count = meta:get_int("count")

	if cache_count > 0 then
		local count = ItemStack(name):get_stack_max()
		if count > cache_count then count = cache_count end

		local stack = ItemStack(name)
		stack:set_count(count)
		technic.tube_inject_item(pos, pos, vector.new(0, -1, 0), stack)
	
		meta:set_int("count", cache_count - count)
		if cache_count == count and locked == 0 then
			meta:set_string("name", "air")
		end
		update_infotext(pos)
	end
end

-- output mode = do an output once per second

local function cache_node_timer(pos, elapsed)
	local meta = minetest.get_meta(pos)
	local output = meta:get_int("output")
	if output > 0 then
		do_output(pos)
	else
		local timer = minetest.get_node_timer(pos)
		timer:stop()
		return false
	end
	return true
end

-- register item visual

minetest.register_entity("skytest:visual", {
	visual = "upright_sprite",
	visual_size = {x=0.6, y=0.6},
	collisionbox = {0},
	physical = false,
	textures = {default_texture},
})

-- register LBM to fix textures in visuals

minetest.register_lbm(
{
	name = "skytest:restore_visuals",
	nodenames = {"group:caches"},
	run_at_every_load = true,
	action = function(pos, node)
		update_infotext(pos)
	end,
})

-- register caches

for _, tier in pairs(tiers) do
	minetest.register_node("skytest:"..tier.name, {
		description = tier.description,
		groups = { caches=1, tubedevice=1, tubedevice_receiver=1 },
		tiles = { tier.texture },
		paramtype2 = "facedir",
		stack_max = 1,
		tube = {
			insert_object = function(pos, node, stack, direction)
				return add_item(pos, stack)
			end,
			can_insert = function(pos, node, stack, direction)
				return room_for_item(pos, stack)
			end,
			connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
		},
		after_place_node = function(pos, placer, stack)
			local meta = minetest.get_meta(pos)
			local data = minetest.deserialize(stack:get_metadata())
			local name = "air"
			local count = 0
			local locked = 0
			if data then
				name = data.name
				count = data.count
				locked = data.locked
			end
			meta:set_string("name", name)
			meta:set_int("count", count)
			meta:set_int("locked", locked)
			meta:set_int("capacity", tier.capacity)
			update_formspec(pos)
			update_infotext(pos)
			pipeworks.scan_for_tube_objects(pos)
		end,
		after_destruct = function(pos, oldnode)
			pipeworks.scan_for_tube_objects(pos)
		end,
		on_punch = function(pos, node, puncher, pointed_thing)
			if can_access(pos, puncher) then
				local ctrl = puncher:get_player_control()
				local inv = puncher:get_inventory()
				if inv then
					remove_item(pos, inv, "main", not ctrl.sneak)
				end
			end
		end,
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			if itemstack and not itemstack:is_empty() then
				local left = on_rightclick(pos, node, clicker, itemstack, pointed_thing)
				if left:get_count() ~= itemstack:get_count() then
					-- if we're here, this is some custom on_place thing
					-- and this is in the twilight zone
					minetest.after(0.1, function(clicker, left)
						clicker:set_wielded_item(left)
					end, clicker, left)
				end
				return left		-- this value is pointless
			end
		end,
		on_timer = cache_node_timer,
		on_rotate = screwdriver.disallow,
		mesecons = {effector = {action_on = do_output}},

		diggable = false,
		can_dig = function() return false end,
		on_blast = function() end,
	})

	minetest.register_craft({
		output = "skytest:"..tier.name,
		recipe = {
			{tier.material, tier.material, tier.material},
			{tier.material, tier.base, tier.material},
			{tier.material, tier.material, tier.material},
		}
	})

end
