local chest_stuff = {
	{name="default:old_apple", max = 1, rarity=1},
	{name="default:old_bread", max = 1, rarity=6},
	{name="farming:seed_wheat", max = 1, rarity=5},
	{name="bucket:bucket_empty", max = 1, rarity=7},
	{name="bucket:bucket_water", max = 1, rarity=9},
	{name="default:sword_wood", max = 1, rarity=9},
	{name="default:sapling", max = 1, rarity=10}

}

minetest.register_node("ruins:chest", {
	description = "Old Chest",
	tiles = {"ruins_chest_top.png", "ruins_chest_top.png", "ruins_chest_side.png",
			"ruins_chest_side.png", "ruins_chest_side.png", "ruins_chest_front.png"},
	paramtype2 = "facedir",
	groups = {choppy = default.dig.old_chest},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults({
		dug = {name = "ruins_chest_break", gain = 0.8},
	}),
	drop = "default:stick 2",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	after_dig_node = default.drop_node_inventory(),
})

--[[local frm = default.chest_formspec
if not default.chest_formspec then
 frm = "size[8,9]"..
	"list[current_name;main;0,0;8,4;]"..
	"list[current_player;main;0,5;8,4;]"
end]]

local function fill_chest(pos)
	minetest.set_node(pos, {name="ruins:chest"})
	minetest.after(2, function()
		if minetest.get_node(pos).name ~= "ruins:chest" then
			return
		end
		local cnt = 0
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		while cnt < 2 do
			local stuff = chest_stuff[math.random(1,#chest_stuff)]
			local stack = {name=stuff.name, count = 1}
			if math.random(1,stuff.rarity) == stuff.rarity
			and not inv:contains_item("main", stack) then
				inv:set_stack("main", math.random(1,32), stack)
				cnt = cnt+1
			end
		end
	end)
end

local function fill_grave(pos)
	minetest.after(2, function()
		local cnt = 0
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",frm)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		while cnt < 1 do
			local stuff = chest_stuff[math.random(1,#chest_stuff)]
			local stack = {name=stuff.name, count = 1}
			if math.random(1,stuff.rarity) == stuff.rarity then
				inv:set_stack("main", math.random(1,32), stack)
				cnt = cnt+1
			end
		end
	end)
end


local function can_replace(pos)
	local n = minetest.get_node_or_nil(pos)
	return not n or not minetest.registered_nodes[n.name].walkable
end


local function ground(pos)
	local p2 = pos
	local cnt = 0
	local mat = "dirt"
	p2.y = p2.y-1
	while can_replace(p2) and cnt < 25 do
		cnt = cnt+1
		if cnt > math.random(2,4) then
			mat = "stone"
		end
		minetest.swap_node(p2, {name="default:"..mat})
		p2.y = p2.y-1
	end
end

local function door(pos, size)
	pos.y = pos.y+1
	local change_both = math.random(2) == 1
	if math.random(2) == 1 then
		if change_both then
			pos.x = pos.x+size.x
		end
		pos.z = pos.z + math.random(1,size.z-1)
	else
		if change_both then
			pos.z = pos.z+size.z
		end
		pos.x = pos.x + math.random(1,size.x-1)
	end
	minetest.remove_node(pos)
	pos.y = pos.y+1
	minetest.remove_node(pos)
end

local function keller(pos, size)
	for yi = 1,4 do
		local remove = yi < math.random(3,4)
		for xi = 1,size.x-1 do
			for zi = 1,size.z-1 do
				local p = {x=pos.x+xi, y=pos.y-yi, z=pos.z+zi}
				if remove then
					minetest.remove_node(p)
				else
					minetest.swap_node(p, {name="default:water_source"})
				end
			end
		end
	end
end

local material = {"cobble", "mossycobble", "glass"}

local function make(pos, size)
	local new
	if math.random(1,10) > 8 then
		new = "wood"
	end
	for yi = 0,4 do
		for xi = 0,size.x do
			for zi = 0,size.z do
				if yi == 0 then
					local p = {x=pos.x+xi, y=pos.y, z=pos.z+zi}
					minetest.swap_node(p, {name="default:"..material[math.random(1,2)]})
					minetest.after(1,ground,p)--(p)
				else
					if xi < 1 or xi > size.x-1 or zi<1 or zi>size.z-1 then
						if math.random(1,yi) == 1 then
							local n = minetest.get_node_or_nil({x=pos.x+xi, y=pos.y+yi-1, z=pos.z+zi})
							if n
							and n.name ~= "air" then
								local new = new
								if yi == 2
								and math.random(1,10) == 3 then
									new = "glass"
								elseif not new then
									new = material[math.random(2)]
								end
								minetest.swap_node({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi}, {name="default:"..new})
							end
						end
					else
						minetest.remove_node({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi})
					end
				end
			end
		end
	end
	if math.random(11) > 8 then
		minetest.after(2,keller, {x=pos.x, y=pos.y, z=pos.z}, size)
	end
	fill_chest({x=pos.x+math.random(1,size.x-1), y=pos.y+1, z=pos.z+math.random(1,size.z-1)})
	door(pos, size)
end

local function make_grave(pos)
	print(dump(pos))
	minetest.add_node(pos, {name="bones:bones"})
	fill_grave({x=pos.x,y=pos.y,z=pos.z})
	pos.y = pos.y+1
	minetest.swap_node(pos, {name="bones:gravestone"})
end


local perl1 = {
	SEED1 = 9130, -- Values should match minetest mapgen V6 desert noise.
	OCTA1 = 3,
	PERS1 = 0.5,
	SCAL1 = 250,
}

local is_set = false
local function set_seed(seed)
	if not is_set then
		math.randomseed(seed)
		is_set = true
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 0
	or math.random(11) < 9 then
		return
	end
	set_seed(seed)

	local perlin1 = minetest.get_perlin(perl1.SEED1, perl1.OCTA1, perl1.PERS1, perl1.SCAL1)
	local noise1 = perlin1:get2d({x=minp.x,y=minp.y})--,z=minp.z})
	if math.abs(noise1) < 0.36 then
		local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
		minetest.after(0.5, function()
			local p2 = minetest.find_node_near(mpos, 25, {"default:dry_dirt"})
			if not p2
			or p2.y < 0 then
				return
			end
			make(p2,{x=math.random(6,9),z=math.random(6,9)})
		end)
	elseif math.abs(noise1) > 0.45 then
		local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
		minetest.after(0.5, function()
			local p2 = minetest.find_node_near(mpos, 25, {"default:dry_dirt"})
			if not p2
			or p2.y < 0 then
				return
			end
			p2.y = p2.y+1
			if minetest.get_node(p2).name == "air" then
				p2.y = p2.y-1
				make_grave(p2)
			end
		end)
	end
end)
