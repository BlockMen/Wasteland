local function generate_tree(pos)
		local nu =  minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		local is_soil = minetest.get_item_group(nu, "soil")
		if is_soil == 0 then
			return
		end

		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y, z=pos.z-16}, {x=pos.x+16, y=pos.y+16, z=pos.z+16})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		default.grow_tree(data, a, pos, math.random(1, 4) == 1, math.random(1,100000))
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
end

local plant_tab = {}
local rnd_max = 5
minetest.after(0.5, function()
	plant_tab[0] = "air"
	plant_tab[1] = "default:grass_1"
	plant_tab[2] = "default:grass_2"
	plant_tab[3] = "default:grass_3"
	plant_tab[4] = "default:grass_4"
	plant_tab[5] = "default:grass_5"

if minetest.get_modpath("flowers") ~= nil then
	rnd_max = 11
	plant_tab[6] = "flowers:dandelion_white"
	plant_tab[7] = "flowers:dandelion_yellow"
	plant_tab[8] = "flowers:geranium"
	plant_tab[9] = "flowers:rose"
	plant_tab[10] = "flowers:tulip"
	plant_tab[11] = "flowers:viola"
end

end)

local function duengen(pointed_thing)
	local pos = pointed_thing.under
	local n = minetest.get_node_or_nil(pos)

	if not n or not n.name then
		return
	end


	print(n.name)

	local stage = ""
	if n.name == "default:sapling" and minetest.get_node_light(pos) then
		if math.random(1,20) < 5 then
			minetest.set_node(pos, {name="air"})
			generate_tree(pos)
		end

	elseif string.find(n.name, "farming:wheat_") ~= nil then
		stage = tonumber(string.sub(n.name, 15))
		if math.random(1,7) < stage/3 then
			minetest.set_node(pos, {name="farming:wheat_8"})
		elseif stage < 7 then
			minetest.set_node(pos, {name="farming:wheat_"..stage+math.random(1,2)})
		end

	elseif string.find(n.name, "farming:cotton_") ~= nil then
		stage = tonumber(string.sub(n.name, 16))
		if stage == 1 then
			minetest.set_node(pos, {name="farming:cotton_"..math.random(stage,2)})
		else
			minetest.set_node(pos, {name="farming:cotton"})
		end

	elseif string.find(n.name, "farming:pumpkin_") ~= nil then
		stage = tonumber(string.sub(n.name, 17))
		if stage == 1 then
			minetest.set_node(pos, {name="farming:pumpkin_"..math.random(stage,2)})
		else
			minetest.set_node(pos, {name="farming:pumpkin"})
		end
	
	elseif n.name == "default:dry_dirt" then
		for i = -2, 3, 1 do
		for j = -3, 2, 1 do
			local p = {x=pos.x+i, y=pos.y, z=pos.z+j}
			--pos = 
			local n2 = minetest.get_node_or_nil(p)

			if n2 and n2.name and n2.name == "default:dry_dirt" and minetest.find_node_near(p, 6, {"group:water"}) then
				if math.random(1,6) > 3 then
					--minetest.env:set_node(p, {name=plant_tab[math.random(0, rnd_max)]})
					minetest.set_node(pointed_thing.under, {name="default:grass"})
				else
					minetest.set_node(p, {name="default:grass"})
				end
				
				
			end
		end
		end
	end
end


minetest.register_craftitem("default:minerals", {
	description = "Minerals",
	inventory_image = "default_minerals.png",
	liquids_pointable = false,
	stack_max = 60,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" then
			duengen(pointed_thing)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end
	end,

})