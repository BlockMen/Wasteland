local n
local n2
local pos

function generate_tree(pos)
	
		local nu =  minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		local is_soil = minetest.get_item_group(nu, "soil")
		if is_soil == 0 then
			return
		end
		
		minetest.log("action", "A sapling grows into a tree at "..minetest.pos_to_string(pos))
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
pos = pointed_thing.under
n = minetest.env:get_node(pos)
if n.name == "" then return end
local stage = ""
if n.name == "default:sapling" then
	if minetest.env:get_node_light(pos) then
		if math.random(1,3) < 3 then
			minetest.env:set_node(pos, {name="air"})
			generate_tree(pos)
		end
	end
elseif string.find(n.name, "farming:wheat_") ~= nil then
	stage = tonumber(string.sub(n.name, 15))
	if math.random(1,7) < stage/3 then
		minetest.env:set_node(pos, {name="farming:wheat_8"})
	elseif stage < 7 then
		minetest.env:set_node(pos, {name="farming:wheat_"..stage+math.random(1,2)})
	--else
		--minetest.env:set_node(pos, {name="farming:wheat_"..math.random(2,3)})
	end
elseif string.find(n.name, "farming:cotton_") ~= nil then
	stage = tonumber(string.sub(n.name, 16))
	if stage == 1 then
		minetest.env:set_node(pos, {name="farming:cotton_"..math.random(stage,2)})
	else
		minetest.env:set_node(pos, {name="farming:cotton"})
	end
elseif string.find(n.name, "farming:pumpkin_") ~= nil then
	stage = tonumber(string.sub(n.name, 17))
	if stage == 1 then
		minetest.env:set_node(pos, {name="farming:pumpkin_"..math.random(stage,2)})
	else
		minetest.env:set_node(pos, {name="farming:pumpkin"})
	end
	
elseif n.name == "default:dirt_with_grass" then
	for i = -2, 3, 1 do
		for j = -3, 2, 1 do
			pos = pointed_thing.under
			pos = {x=pos.x+i, y=pos.y, z=pos.z+j}
			n = minetest.env:get_node(pos)
			--n2 = minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z})

			if n and n.name and n.name == "default:dirt_with_grass" and minetest.find_node_near(pos, 6, {"group:water"}) then
				if math.random(0,5) > 3 then
					--minetest.env:set_node(pos, {name=plant_tab[math.random(0, rnd_max)]})
					minetest.env:set_node(pointed_thing.under, {name="default:grass"})
				else
					minetest.env:set_node(pos, {name="default:grass"})
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
	--stack_max = 99,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" then
			duengen(pointed_thing)
			if not minetest.setting_getbool("creative_mode") then itemstack:take_item() end
			return itemstack
		end
	end,

})