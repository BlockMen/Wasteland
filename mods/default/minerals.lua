local n
local n2
local pos

function apple_leave()
	if math.random(0, 10) == 3 then
		return {name = "default:apple"}
	else
		return {name = "default:leaves"}
	end
end

function air_leave()
	if math.random(0, 50) == 3 then
		return {name = "air"}
	else
		return {name = "default:leaves"}
	end
end

function generate_tree(pos, trunk, leaves)
	pos.y = pos.y-1
	local nodename = minetest.env:get_node(pos).name
		
	pos.y = pos.y+1

	node = {name = ""}
	for dy=1,4 do
		pos.y = pos.y+dy
		if minetest.env:get_node(pos).name ~= "air" then
			return
		end
		pos.y = pos.y-dy
	end
	node = {name = "default:tree"}
	for dy=0,4 do
		pos.y = pos.y+dy
		minetest.env:set_node(pos, node)
		pos.y = pos.y-dy
	end

	node = {name = "default:leaves"}
	pos.y = pos.y+3
	local rarity = 0
	if math.random(0, 10) == 3 then
		rarity = 1
	end
	for dx=-2,2 do
		for dz=-2,2 do
			for dy=0,3 do
				pos.x = pos.x+dx
				pos.y = pos.y+dy
				pos.z = pos.z+dz

				if dx == 0 and dz == 0 and dy==3 then
					if minetest.env:get_node(pos).name == "air" and math.random(1, 5) <= 4 then
						minetest.env:set_node(pos, node)
						if rarity == 1 then
							minetest.env:set_node(pos, apple_leave())
						else
							minetest.env:set_node(pos, air_leave())
						end
					end
				elseif dx == 0 and dz == 0 and dy==4 then
					if minetest.env:get_node(pos).name == "air" and math.random(1, 5) <= 4 then
						minetest.env:set_node(pos, node)
						if rarity == 1 then
							minetest.env:set_node(pos, apple_leave())
						else
							minetest.env:set_node(pos, air_leave())
						end
					end
				elseif math.abs(dx) ~= 2 and math.abs(dz) ~= 2 then
					if minetest.env:get_node(pos).name == "air" then
						minetest.env:set_node(pos, node)
						if rarity == 1 then
							minetest.env:set_node(pos, apple_leave())
						else
							minetest.env:set_node(pos, air_leave())
						end
					end
				else
					if math.abs(dx) ~= 2 or math.abs(dz) ~= 2 then
						if minetest.env:get_node(pos).name == "air" and math.random(1, 5) <= 4 then
							minetest.env:set_node(pos, node)
						if rarity == 1 then
							minetest.env:set_node(pos, apple_leave())
						else
							minetest.env:set_node(pos, air_leave())
						end
						end
					end
				end
				pos.x = pos.x-dx
				pos.y = pos.y-dy
				pos.z = pos.z-dz
			end
		end
	end
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
			generate_tree(pos, "default:tree", "default:leaves")
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