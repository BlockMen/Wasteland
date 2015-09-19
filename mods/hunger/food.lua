local register_food = hunger.register_food

register_food("default:apple", 2)
register_food("default:old_apple", 1, "", 1)
register_food("default:old_bread", 4, "", 3)

if minetest.get_modpath("farming") ~= nil then
	register_food("farming:bread", 4)
end

if minetest.get_modpath("creatures") ~= nil then
	--register_food("creatures:meat", 6)
	register_food("creatures:flesh", 5)
	register_food("creatures:rotten_flesh", 4, "", 3)
end
