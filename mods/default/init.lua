-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 14

-- Definitions made by this mod that other mods can use too
default = {}

default.dig = {
	-- Cracky (pick)
	stone = 1,
	cobble = 2,
	coal = 3,
	iron = 4,
	gold = 5,
	diamond = 6,
	sandstone = 7,
	furnace = 8,
	ironblock = 9,
	goldblock = 10,
	diamondblock = 11,
	obsidian = 12,
	ice = 13,
	rail = 14,
	iron_door = 15,
	netherrack = 16,
	netherbrick = 17,
	redstone_ore = 18,
	brick = 19,
	pressure_plate_stone = 20,--+stonebrick,hardclay,grass

	-- Crumbly (shovel)
	dirt_with_grass = 1,
	dirt = 2,
	sand = 3,
	gravel = 4,
	clay = 5,
	snow = 6,
	snowblock = 7,
	nethersand = 8,
	hardclay = 9,

	-- Choppy (axe)
	tree = 1,--+deadtree
	wood = 2,
	bookshelf = 3,
	fence = 4,
	sign = 5,
	chest = 6,
	wooden_door = 7,
	workbench = 8,
	pressure_plate_wood=9,
	deadtree = 10,

	-- Snappy (shears)
	leaves = 1,
	wool = 2,

	-- Dig (tool doesnt matter but count as a use)
	bed = 1,
	cactus = 2,
	glass = 3,
	ladder = 4,
	glowstone = 5,
	lever = 6,
	button = 7,
	instant = 8,
}

-- Load files
dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafting.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/minerals.lua")
dofile(minetest.get_modpath("default").."/player.lua")
dofile(minetest.get_modpath("default").."/trees.lua")

