-------------------------------------------------------------------------
-- Wasteland
-- Copyright (C) 2015 BlockMen <blockmen2015@gmail.de>
--
-- This file is part of Wasteland
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------


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
	minetest.set_node(pos, {name="ruins:chest", metadata=""})
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		local cnt = 0
		if n ~= nil then
			if n.name == "ruins:chest" then
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				inv:set_size("main", 8*4)
				while cnt < 2 do
					local stuff = chest_stuff[math.random(1, #chest_stuff)]
					local stack = {name=stuff.name, count = 1}
					if math.random(1, stuff.rarity) == stuff.rarity then
						if not inv:contains_item("main", stack) then
							inv:set_stack("main", math.random(1, 32), stack)
							cnt = cnt + 1
						end
					end
				end -- end while
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
				local stuff = chest_stuff[math.random(1, #chest_stuff)]
				local stack = {name=stuff.name, count = 1}
				if math.random(1, stuff.rarity) == stuff.rarity then
					inv:set_stack("main", math.random(1, 32), stack)
					cnt = cnt + 1
				end
			end -- end while
		end
	end)
end


local function can_replace(pos)
	local n = minetest.get_node_or_nil(pos)
	local ndef = minetest.registered_nodes[n.name]
	if (ndef and not ndef.walkable) or not n then
		return true
	else
		return false
	end
end


local function ground(pos)
	local p = table.copy(pos)
	local cnt = 0
	local mat = "dirt"
	p.y = p.y - 1
	while can_replace(p) == true do
		cnt = cnt + 1
		if cnt > 25 then
			break
		end
		if cnt>math.random(2, 4) then
			mat = "stone"
		end
		minetest.swap_node(p, {name = "default:" .. mat})
		p.y = p.y - 1
	end
end

local function door(pos, size)
	local p = table.copy(pos)
	p.y = p.y + 1
	if math.random() > 0 then
		if math.random() > 0 then
			p.x = p.x + size.x
		end
			p.z = p.z + math.random(1, size.z - 1)
	else
		if math.random() > 0 then
			p.z = p.z + size.z
		end
		p.x = p.x + math.random(1, size.x - 1)
	end
	minetest.remove_node(p)
	p.y = p.y + 1
	minetest.remove_node(p)
end

local function keller(pos, size)
	for yi = 1, 4 do
		local w_h = math.random(3, 4)
		for xi = 1, size.x - 1 do
		for zi = 1, size.z - 1 do
			local p = {x = pos.x + xi, y = pos.y - yi, z = pos.z + zi}
			if yi < w_h then
				minetest.remove_node(p)
			else
				minetest.swap_node(p, {name = "default:water_source"})
			end
		end
		end
	end
end

local material = {}
material[1] = "cobble"
material[2] = "mossycobble"
material[3] = "glass"

local function generate_sized(pos, size)
	local wood = false
	if math.random(1, 10) > 8 then
		wood = true
	end
 	for yi = 0, 4 do
	for xi = 0, size.x do
	for zi = 0, size.z do
		local p = {x = pos.x + xi, y = pos.y + yi, z = pos.z + zi}
		if yi == 0 then
			minetest.swap_node(p, {name = "default:" .. material[math.random(1, 2)]})
			minetest.after(1, ground, p)
		else
			if xi < 1 or xi > size.x - 1 or zi < 1 or zi > size.z - 1 then
				if math.random(1, yi) == 1 then
					local mat = "wood"
					if not wood then
						new = material[math.random(1, 2)]
					end
					if yi == 2 and math.random(1, 10) == 3 then
						mat = "glass"
					end
					p.y = p.y - 1
					local n = minetest.get_node_or_nil(p)
					p.y = p.y + 1
					if n and n.name ~= "air" then
						minetest.swap_node(p, {name = "default:" .. mat})
					end
				end
			else
				minetest.remove_node(p)
			end
		end
	end
	end
	end

	if math.random(0, 10) > 7 then
		minetest.after(2, keller, pos, size)
	end

	fill_chest({
		x = pos.x + math.random(1, size.x - 1),
		y = pos.y + 1,
		z = pos.z + math.random(1, size.z - 1)
	})
	door(pos, size)
end

local function generate_coffin(pos)
	minetest.add_node(pos, {name = "coffin:coffin"})
	fill_grave({x=pos.x,y=pos.y,z=pos.z})
	pos.y = pos.y + 1
	minetest.swap_node(pos, {name = "coffin:gravestone"})
end


local perl = {SEED = 9130, OCTA = 3, PERS = 0.5, SCAL = 250}
local perlin = PerlinNoise(perl.SEED, perl.OCTA, perl.PERS, perl.SCAL)

local is_set = false
local function set_seed(seed)
	if not is_set then
		math.randomseed(seed)
		is_set = true
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 0 or (math.random(0, 10) < 8) then
		return
	end

	set_seed(seed)

	local noise = perlin:get2d({x = minp.x, y = minp.y})--,z=minp.z})

	if noise < 0.36 or noise > -0.36 then
		local mpos = {
			x = math.random(minp.x, maxp.x),
			y = math.random(minp.y, maxp.y),
			z = math.random(minp.z, maxp.z)
		}
		minetest.after(0.1, function()
			local point = minetest.find_node_near(mpos, 25, {"default:dry_dirt"})
			if not point or point == nil or point.y < 0 then
				return
			end

			generate_sized(point, {x = math.random(6, 9), z = math.random(6, 9)})
		end)
	end

	if noise < -0.45 or noise > 0.45 then
		local mpos = {
			x = math.random(minp.x, maxp.x),
			y = math.random(minp.y, maxp.y),
			z = math.random(minp.z, maxp.z)
		}
		minetest.after(0.1, function()
			local point = minetest.find_node_near(mpos, 25, {"default:dry_dirt"})
			if not point or point == nil or point.y < 0 then
				return
			end
			point.y = point.y + 1
			local n = minetest.get_node(point)
			point.y = point.y - 1
			if n and n.name and n.name == "air" then
				generate_coffin(point)
			end
		end)
	end
end)
