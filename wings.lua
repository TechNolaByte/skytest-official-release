if(minetest.get_modpath("3d_armor")~=nil) then
wings = {
  huds = {}
}

wings.set = function(defs)
	--set the wings hud
	if wings.huds[defs.player][1] == nil then
                local hud_id=defs.player:hud_add({
		hud_elem_type = "image",
		position = {x = 0.5, y = 0.5},
		scale = {
			x = -1,
			y = -1
			},
			text = "wings.png"
		})
		wings.huds[defs.player][1] = hud_id;
	elseif not string.match(armor["textures"][defs.player:get_player_name()].armor, "wings_helmet.png") then
		local player = defs.player
		local armor_texture = armor["textures"][player:get_player_name()].armor
		armor_texture = armor_texture.."^wings_helmet.png"
		armor["textures"][player:get_player_name()].armor = armor_texture
		armor.update_player_visuals(armor,player)
		
		--attempt to update the preview
		local preview = armor["textures"][player:get_player_name()].preview
		print(dump(armor["textures"][player:get_player_name()]))
		
		preview = preview.."^wings_preview.png"
		
		armor["textures"][player:get_player_name()].preview = preview
		
		
	end
	
end

wings.add = function (defs)
  defs.darkness = math.max(defs.darkness + #wings.huds[defs.player], 0)
  wings.set(defs)
end
wings.del = function(defs)
	if wings.huds[defs.player][1] ~= nil then
		-- removing huds
		defs.player:hud_remove(wings.huds[defs.player][1])
		wings.huds[defs.player][1] = nil
	end
end
wings.remove = function (defs)
  defs.darkness = math.max(defs.darkness + #wings.huds[defs.player], 0)
  wings.del(defs)
end

--make this do something more efficient
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv = player:get_inventory()
		for i=1, 6 do
			local stack = inv:get_stack("armor", i)
			local item = stack:get_name()
                        if item == "skytest:wings" then
				wings.set({player = player})
				local playername = player:get_player_name()
				local privs = minetest.get_player_privs(playername)
				privs.fly = true
				minetest.set_player_privs(playername, privs)
				return
			else 
				local playername = player:get_player_name()
				local privs = minetest.get_player_privs(playername)
		privs.fly = nil
		minetest.set_player_privs(playername, privs)
end
		end
		wings.del({player = player})
	end
end)

minetest.register_on_joinplayer(function (player)
  wings.huds[player] = {}
end)

minetest.register_craftitem("skytest:wings", {
	description = "A pair o' wings",
	inventory_image = "wings_item.png",
        stack_max = 1,
})
minetest.register_craft({
	output = "skytest:wings",
	recipe = {
		{"dye:white", "", "dye:white"},
		{"skytest:enchanted_fabric", "skytest:enchanted_block", "skytest:enchanted_fabric"},
		{"skytest:enchanted_fabric", "skytest:enchanted_fabric", "skytest:enchanted_fabric"}
	}
})
end