local chest_stuff = {
	{name="default:old_apple", max = 1, rarity=1},
	{name="default:old_bread", max = 1, rarity=6},
	{name="farming:seed_wheat", max = 1, rarity=5},
	{name="bucket:bucket", max = 1, rarity=7},
	{name="bucket:bucket_water", max = 1, rarity=9},
	{name="default:sword_wood", max = 1, rarity=9},
	{name="default:sapling", max = 1, rarity=10}

}

local frm = default.chest_formspec
if not default.chest_formspec then
 frm = "size[8,9]"..
	"list[current_name;main;0,0;8,4;]"..
	"list[current_player;main;0,5;8,4;]"
end

local function fill_chest(pos)
	minetest.set_node(pos, {name="default:chest", metadata=""})
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		local cnt = 0
		if n ~= nil then
			if n.name == "default:chest" then
				local meta = minetest.get_meta(pos)
				meta:set_string("formspec",frm)
				meta:set_string("infotext", "Chest")
				local inv = meta:get_inventory()
				inv:set_size("main", 8*4)
				while cnt < 2 do
					local stuff = chest_stuff[math.random(1,#chest_stuff)]
					local stack = {name=stuff.name, count = 1}
					if math.random(1,stuff.rarity) == stuff.rarity then
					 if not inv:contains_item("main", stack) then
						 inv:set_stack("main", math.random(1,32), stack)
						cnt = cnt+1
					 end
					end
				end
			end
		end
	end)
end

local function fill_grave(pos)
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		local cnt = 0
		if n ~= nil then
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
		end
	end)
end


local function can_replace(pos)
	local n = minetest.get_node_or_nil(pos)
	if n and n.name and minetest.registered_nodes[n.name] and not minetest.registered_nodes[n.name].walkable then
		return true
	elseif not n then
		return true
	else
		return false
	end
end


local function ground(pos)
	local p2 = pos
	local cnt = 0
	local mat = "dirt"
	p2.y = p2.y-1
	while can_replace(p2)==true do
		cnt = cnt+1
		if cnt > 25 then break end
		if cnt>math.random(2,4) then mat = "stone"end
		minetest.set_node(p2, {name="default:"..mat})
		p2.y = p2.y-1
	end
end

local function door(pos, size)
	pos.y = pos.y+1
	if math.random(0,1) > 0 then
		if math.random(0,1)>0 then pos.x=pos.x+size.x end
		pos.z = pos.z + math.random(1,size.z-1)
	else
		if math.random(0,1)>0 then pos.z=pos.z+size.z end
		pos.x = pos.x + math.random(1,size.x-1)
	end
	minetest.remove_node(pos)
	pos.y = pos.y+1
	minetest.remove_node(pos)
end

local function keller(pp, size)
 local pos = pp--{x=pp.x, y=pp.y, z=pp.z}
 for yi = 1,4 do
	local w_h = math.random(3,4)
	for xi = 1,size.x-1 do
		for zi = 1,size.z-1 do
			local p = {x=pos.x+xi, y=pos.y-yi, z=pos.z+zi}
			if yi < w_h then
				minetest.remove_node(p)
			else
				minetest.set_node(p, {name="default:water_source"})
			end
		end
	end
 end
end

local material = {}
material[1] = "cobble"
material[2] = "mossycobble"
material[3] = "glass"

local function make(pos, size)
local wood = false
if math.random(1,10) > 8 then wood = true end
 for yi = 0,4 do
	for xi = 0,size.x do
		for zi = 0,size.z do
			if yi == 0 then
				local p = {x=pos.x+xi, y=pos.y, z=pos.z+zi}
				minetest.set_node(p, {name="default:"..material[math.random(1,2)]})
				minetest.after(1,ground,p)--(p)
			else
				if xi < 1 or xi > size.x-1 or zi<1 or zi>size.z-1 then
					if math.random(1,yi) == 1 then
						local new = material[math.random(1,2)]
						if wood then new = "wood" end
						if yi == 2 and math.random(1,10) == 3 then new = "glass" end
						local n = minetest.get_node_or_nil({x=pos.x+xi, y=pos.y+yi-1, z=pos.z+zi})
						if n and n.name ~= "air" then
							minetest.set_node({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi}, {name="default:"..new})
						end
					end
				else
					minetest.remove_node({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi})
				end
			end
		end
	end
 end
 if math.random(0,10) >7 then
 	minetest.after(2,keller, {x=pos.x, y=pos.y, z=pos.z}, size)
 end
 fill_chest({x=pos.x+math.random(1,size.x-1), y=pos.y+1, z=pos.z+math.random(1,size.z-1)})
 door(pos, size)
end

local function make_grave(pos)
	print(dump(pos))
	minetest.add_node(pos, {name="bones:bones", param2=param2})
	fill_grave({x=pos.x,y=pos.y,z=pos.z})
	pos.y = pos.y+1
	minetest.set_node(pos, {name="bones:gravestone", param2=param2})
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

	if maxp.y < 0 then return end
	if math.random(0,10)<8 then return end
	set_seed(seed)

	local perlin1 = minetest.env:get_perlin(perl1.SEED1, perl1.OCTA1, perl1.PERS1, perl1.SCAL1)
	local noise1 = perlin1:get2d({x=minp.x,y=minp.y})--,z=minp.z})
	if noise1 < 0.36 or noise1 > -0.36 then
		local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
		minetest.after(0.5, function()
		 p2 = minetest.find_node_near(mpos, 25, {"default:dirt_with_grass"})	
		 if not p2 or p2 == nil or p2.y < 0 then return end
		
		  make(p2,{x=math.random(6,9),z=math.random(6,9)})
		end)
	end
	if noise1 < -0.45 or noise1 > 0.45 then
		
		local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
		minetest.after(0.5, function()
		 p2 = minetest.find_node_near(mpos, 25, {"default:dirt_with_grass"})	
		 if not p2 or p2 == nil or p2.y < 0 then return end
		  p2.y = p2.y+1
		  local n = minetest.get_node(p2)
		  p2.y = p2.y-1
		  if n and n.name and n.name == "air" then
			make_grave(p2)
		  end
		end)
	end
end)