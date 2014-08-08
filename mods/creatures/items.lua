-- drop items
minetest.register_craftitem("creatures:flesh", {
	description = "Flesh",
	inventory_image = "creatures_flesh.png",
	on_use = minetest.item_eat(4),
	stack_max = 60,
})

minetest.register_craftitem("creatures:rotten_flesh", {
	description = "Rotten Flesh",
	inventory_image = "creatures_rotten_flesh.png",
	on_use = minetest.item_eat(1),
	stack_max = 60,
})

-- spawn-eggs
minetest.register_craftitem("creatures:zombie_spawn_egg", {
	description = "Zombie spawn-egg",
	inventory_image = "creatures_egg_zombie.png",
	liquids_pointable = false,
	stack_max = 60,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local p = pointed_thing.above
			p.y = p.y+1
			creatures.spawn(p, 1, "creatures:zombie", 1, 1)
			if not minetest.setting_getbool("creative_mode") then itemstack:take_item() end
			return itemstack
		end
	end,

})
