local max_mobs_sum = creatures.zombie_max
-- hostile mobs
if not minetest.setting_getbool("only_peaceful_mobs") then
	-- zombie
	minetest.register_abm({
		nodenames = creatures.z_spawn_nodes,
  		neighbors = {"air"},
		interval = 40.0,
		chance = 7600,
		action = function(pos, node, active_object_count, active_object_count_wider)
			-- check per mapblock max (max per creature is done by .spawn())
			if active_object_count_wider > max_mobs_sum then
				return
			end
			local n = minetest.get_node_or_nil(pos)
			--if n and n.name and n.name ~= "default:stone" and math.random(1,4)>3 then return end
			pos.y = pos.y+1
			local ll = minetest.get_node_light(pos) or nil
			if not ll then
				return
			end
			if ll >= creatures.z_ll then
				return
			end
			if ll < -1 then
				return
			end
			if minetest.get_node(pos).name ~= "air" then
				return
			end
			pos.y = pos.y+1
			if minetest.get_node(pos).name ~= "air" then
				return
			end
			creatures.spawn(pos, math.random(1,3), "creatures:zombie", 2, 20)
		end})
end
