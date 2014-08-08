minetest.register_node("coffin:gravestone", {
	description = "Gravestone",
	tiles = {"default_stone.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate = 1, cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:cobblestone",
	drawtype = "nodebox",
	node_box = {type = "fixed",
		fixed = {
		{-0.5,-0.5,-0.1,0.5,-0.3,0.5},
		{-0.3,-0.3,0.1,0.3,0.7,0.3},

		}
	}
})

minetest.register_node("coffin:coffin", {
	description = "Coffin",
	tiles = {
		"coffin_top.png",
		"coffin_top.png",
		"coffin_side.png",
		"coffin_side.png",
		"coffin_side.png",
		"coffin_side.png",
	},
	paramtype2 = "facedir",
	groups = {dig_immediate = 2},
	sounds = default.node_sound_wood_defaults({
		dug = {name = "ruins_chest_break", gain = 0.6},
	}),
	drop = "default:stick 2",
	after_dig_node = default.drop_node_inventory(),
})

minetest.register_alias("bones:bones", "coffin:coffin")
minetest.register_alias("bones:gravestone", "coffin:gravestone")

minetest.register_on_dieplayer(function(player)
	minetest.after(0.5, function()
	if minetest.setting_getbool("creative_mode") then
		return
	end
	
	local pos = player:getpos()
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y-0.5)
	pos.z = math.floor(pos.z+0.5)
	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	
	local nn = minetest.get_node(pos).name
	if minetest.registered_nodes[nn].can_dig and
		not minetest.registered_nodes[nn].can_dig(pos, player) then
		local player_inv = player:get_inventory()

		for i=1,player_inv:get_size("main") do
			player_inv:set_stack("main", i, nil)
		end
		for i=1,player_inv:get_size("craft") do
			player_inv:set_stack("craft", i, nil)
		end
		return
	end
	minetest.dig_node(pos)
	minetest.add_node(pos, {name="coffin:coffin", param2=param2})
	pos.y = pos.y+1
	minetest.set_node(pos, {name="coffin:gravestone", param2=param2})
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", "RIP "..player:get_player_name())
	pos.y = pos.y-1
	
	meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local player_inv = player:get_inventory()
	inv:set_size("main", 8*4)
	
	local empty_list = inv:get_list("main")
	inv:set_list("main", player_inv:get_list("main"))
	player_inv:set_list("main", empty_list)
	
	for i=1,player_inv:get_size("craft") do
		inv:add_item("main", player_inv:get_stack("craft", i))
		player_inv:set_stack("craft", i, nil)
	end
	end)
end)
