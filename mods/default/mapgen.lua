-- mods/default/mapgen.lua

--
-- Aliases for map generator outputs
--

minetest.register_alias("mapgen_air", "air")
minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_tree", "default:dead_tree")
minetest.register_alias("mapgen_leaves", "air")
minetest.register_alias("mapgen_jungletree", "air")
minetest.register_alias("mapgen_jungleleaves", "air")
minetest.register_alias("mapgen_apple", "air")
minetest.register_alias("mapgen_water_source", "air")
minetest.register_alias("mapgen_dirt", "default:dry_dirt")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_clay", "default:hardened_clay")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_dirt_with_grass", "default:dry_dirt")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_stone_with_coal", "default:stone_with_coal")
minetest.register_alias("mapgen_stone_with_iron", "default:stone_with_iron")
minetest.register_alias("mapgen_mese", "default:stone")
minetest.register_alias("mapgen_desert_sand", "default:dry_dirt")
minetest.register_alias("mapgen_desert_stone", "default:stone")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")

--
-- Ore generation
--

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 8*8*8,
	clust_num_ores = 8,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = 64,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 24*24*24,
	clust_num_ores = 27,
	clust_size     = 6,
	height_min     = -31000,
	height_max     = 0,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 12*12*12,
	clust_num_ores = 3,
	clust_size     = 2,
	height_min     = -15,
	height_max     = 2,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 9*9*9,
	clust_num_ores = 5,
	clust_size     = 3,
	height_min     = -63,
	height_max     = -16,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 7*7*7,
	clust_num_ores = 5,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -64,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 24*24*24,
	clust_num_ores = 27,
	clust_size     = 6,
	height_min     = -31000,
	height_max     = -64,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_gold",
	wherein        = "default:stone",
	clust_scarcity = 15*15*15,
	clust_num_ores = 3,
	clust_size     = 2,
	height_min     = -255,
	height_max     = -64,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_gold",
	wherein        = "default:stone",
	clust_scarcity = 13*13*13,
	clust_num_ores = 5,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -256,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_diamond",
	wherein        = "default:stone",
	clust_scarcity = 17*17*17,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -255,
	height_max     = -128,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_diamond",
	wherein        = "default:stone",
	clust_scarcity = 15*15*15,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -256,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 12*12*12,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -63,
	height_max     = -16,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 9*9*9,
	clust_num_ores = 5,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -64,
	flags          = "absheight",
})

if minetest.setting_get("mg_name") == "indev" then
	-- Floatlands and high mountains springs
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:water_source",
		ore_param2     = 128,
		wherein        = "default:stone",
		clust_scarcity = 40*40*40,
		clust_num_ores = 8,
		clust_size     = 3,
		height_min     = 100,
		height_max     = 31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:lava_source",
		ore_param2     = 128,
		wherein        = "default:stone",
		clust_scarcity = 50*50*50,
		clust_num_ores = 5,
		clust_size     = 2,
		height_min     = 10000,
		height_max     = 31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:sand",
		wherein        = "default:stone",
		clust_scarcity = 20*20*20,
		clust_num_ores = 5*5*3,
		clust_size     = 5,
		height_min     = 500,
		height_max     = 31000,
	})

	-- Underground springs
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:water_source",
		ore_param2     = 128,
		wherein        = "default:stone",
		clust_scarcity = 25*25*25,
		clust_num_ores = 8,
		clust_size     = 3,
		height_min     = -10000,
		height_max     = -10,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:lava_source",
		ore_param2     = 128,
		wherein        = "default:stone",
		clust_scarcity = 35*35*35,
		clust_num_ores = 5,
		clust_size     = 2,
		height_min     = -31000,
		height_max     = -100,
	})
end

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:hardened_clay",
	wherein        = "default:sand",
	clust_scarcity = 15*15*15,
	clust_num_ores = 64,
	clust_size     = 5,
	height_max     = 0,
	height_min     = -10,
})

function make_dead_tree(pos, size)
	if size == nil then
		size = math.random(3,6)
	end
	for y=0,size-1 do
		local p = {x=pos.x, y=pos.y+y, z=pos.z}
		local nn = minetest.get_node(p).name
		if minetest.registered_nodes[nn] and
		   minetest.registered_nodes[nn].buildable_to then
			minetest.after(0.2,function()
			  minetest.swap_node(p, {name="default:dead_tree"})
			end)
		else
			return
		end
	end
end

local dirt_snow = minetest.get_content_id("default:dirt_with_snow")
local dirt_dry = minetest.get_content_id("default:dry_dirt")
local leaves = minetest.get_content_id("default:leaves")
local snow = minetest.get_content_id("default:snow")
local air = minetest.get_content_id("air")

local SNOW_START = 24

local function make_snow(min,max,data,va,rnd)
	local cnt = max.x-min.x
	for yi=0, cnt do
	 if max.y-yi>=SNOW_START+rnd then
	  for xi=0, cnt do
	   for zi=0, cnt do
		local p = {x=min.x+xi,y=max.y-yi,z=min.z+zi}
		local pi = va:indexp(p)
		if data[pi] == dirt_dry then
			data[pi] = dirt_snow
		end
		if data[pi] == dirt_snow then-- and p.y > SNOW_START+3+rnd then
			p.y = p.y+1
			local opi = va:indexp(p)
			if data[opi] == air then-- and data[pi] ~= air then
				data[pi] = snow
			end
		end
	   end
	  end
	 end
	end
	return data
end

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed+1)
	if maxp.y >= 2 and minp.y <= 0 then
		-- old trees
		local perlin1 = minetest.get_perlin(230, 3, 0.6, 100)
		-- Assume X and Z lengths are equal
		local divlen = 16
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			-- Determine dead tree amount from perlin noise
			local amount = math.floor(perlin1:get2d({x=x0, y=z0}) * 2 - 3)
			-- Find random positions for dead trees
			for i=0,amount do
				local x = pr:next(x0, x1)
				local z = pr:next(z0, z1)
				-- Find ground level (0...15)
				local ground_y = nil
				local ground_n = nil
				for y=20,0,-1 do
					ground_n = minetest.get_node_or_nil({x=x,y=y,z=z})
					if ground_n and ground_n.name ~= "air" then
						ground_y = y
						break
					end
				end
				-- If dry dirt make dead tree
				if ground_y and ground_n and ground_n.name == "default:dry_dirt" then
					make_dead_tree({x=x,y=ground_y+1,z=z})
				end
			end
		end
		end

	end
	--[[TODO: dont produce that much lags!!minerals
	local MINERAL_MAX = -11
	--if maxp.y < MINERAL_MAX then
	 local cnt = maxp.x-minp.x
		for yi=0, cnt do
		 if minp.y+yi<MINERAL_MAX then
		  for xi=0, cnt do
		   for zi=0, cnt do
		   local p = {x=minp.x+xi,y=minp.y+yi,z=minp.z+zi}
		    local n = minetest.get_node(p)
		    p.y = p.y+1
		    local nn = minetest.get_node(p)
		    p.y = p.y-1
		    if nn and nn.name == "air" and n and n.name and n.name == "default:sand" then
		     minetest.swap_node(p, {name="default:mineralsand"})
		    end
		   end
		  end
		 end
		end

	--end]]


		-- Generate dry grass
		local perlin1 = minetest.get_perlin(480, 3, 0.6, 100)
		-- Assume X and Z lengths are equal
		local divlen = 16
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			-- Determine grass amount from perlin noise
			local grass_amount = math.floor(perlin1:get2d({x=x0, y=z0}) ^ 3 * 4)
			-- Find random positions for grass based on this random
			local pr = PseudoRandom(seed+1)
			for i=0,grass_amount do
				local x = pr:next(x0, x1)
				local z = pr:next(z0, z1)
				-- Find ground level (0...15)
				local ground_y = nil
				for y=20,0,-1 do
					if minetest.get_node({x=x,y=y,z=z}).name ~= "air" then
						ground_y = y
						break
					end
				end
				
				if ground_y then
					local p = {x=x,y=ground_y+1,z=z}
					local nn = minetest.get_node(p).name
					-- Check if the node can be replaced
					if minetest.registered_nodes[nn] and
						minetest.registered_nodes[nn].buildable_to then
						nn = minetest.get_node({x=x,y=ground_y,z=z}).name
						-- If desert sand, add dry shrub
						if nn == "default:dry_dirt" then
							minetest.swap_node(p,{name="default:dry_shrub"})
						end
					end
				end
				
			end
		end
		end

	-- snowcaps
	local snow_height_rnd = pr:next(0,3)
	if maxp.y >= SNOW_START then--+snow_height_rnd then
		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local data = vm:get_data()
		local va = VoxelArea:new{ MinEdge = emin, MaxEdge = emax }
		data = make_snow(minp,maxp,data, va,snow_height_rnd)
		vm:set_data(data)
		vm:calc_lighting()
		vm:write_to_map(data)
	end		
end)

