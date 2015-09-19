local lifetime = tonumber(minetest.setting_get("remove_items")) or 300

local function get_flowing_dir(npos)
	local pos = table.copy(npos)
		local param2 = minetest.get_node(pos).param2
		for i, d in ipairs({-1, 1, -1, 1}) do
			if i < 3 then
				pos.x = pos.x + d
			else
				pos.z = pos.z + d
			end

			local name = minetest.get_node(pos).name
			local par2 = minetest.get_node(pos).param2
			if name == "default:water_flowing" and par2 < param2 then
				return pos
			end

			if i < 3 then
				pos.x = pos.x - d
			else
				pos.z = pos.z - d
			end
		end
end

minetest.register_entity(":__builtin:item", {
	initial_properties = {
		hp_max = 1,
		physical = true,
		collisionbox = {-0.17, -0.17, -0.17, 0.17, 0.17, 0.17},
		visual = "wielditem",
		visual_size = {x = 0.25, y = 0.25},
		textures = {"unknown_item.png"},
		is_visible = false,
		timer = 0,
		collide_with_objects = false,
		automatic_rotate = math.pi * 0.25
	},

	itemstring = "",
	physical_state = true,

	set_item = function(self, itemstring)
		self.itemstring = itemstring
		local stack = ItemStack(itemstring)
		local itemtable = stack:to_table()
		local itemname = nil
		if itemtable then
			itemname = stack:to_table().name
		end
		local item_texture = nil
		local item_type = ""
		local def = minetest.registered_items[itemname]
		if def then
			item_texture = def.inventory_image
			item_type = def.type
		end
		local prop = {
			is_visible = true,
			visual = "wielditem",
			textures = {itemname}
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		--return self.itemstring
		return minetest.serialize({
			itemstring = self.itemstring,
			always_collect = self.always_collect,
			timer = self.timer,
		})
	end,

	on_activate = function(self, staticdata, dtime_s)
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = minetest.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				self.always_collect = data.always_collect
				self.timer = data.timer
				if not self.timer then
					self.timer = 0
				end
				self.timer = self.timer + dtime_s
			end
		else
			self.itemstring = staticdata
		end
		self.object:set_armor_groups({immortal = 1})
		self.object:setvelocity({x = 0, y = 2, z = 0})
		self.object:setacceleration({x = 0, y = -10, z = 0})
		self:set_item(self.itemstring)
	end,

	on_step = function(self, dtime)
		if not self.timer then
			self.timer = 0
		end
		self.timer = self.timer + dtime

		if lifetime ~= 0 and (self.timer > lifetime) then
			self.object:remove()
		end

		local pos = self.object:getpos()
		local nn = minetest.get_node(pos).name
		local ndef = minetest.registered_nodes[nn]

		if nn == "default:lava_flowing" or nn == "default:lava_source" then
			minetest.sound_play("builtin_item_lava", {pos = pos})
			self.timer = lifetime + 1
			self.object:remove()
			return
		end

		if ndef.liquidtype == "flowing" then
			local vec = get_flowing_dir(pos)
			if vec then
				local v = self.object:getvelocity()
				if vec and vec.x - pos.x > 0 then
					self.object:setvelocity({x = 0.5, y = v.y, z = 0})
				elseif vec and vec.x - pos.x < 0 then
					self.object:setvelocity({x = -0.5, y = v.y, z = 0})
				elseif vec and vec.z - pos.z > 0 then
					self.object:setvelocity({x = 0, y = v.y, z = 0.5})
				elseif vec and vec.z - pos.z < 0 then
					self.object:setvelocity({x = 0,y = v.y, z = -0.5})
				end

				self.object:setacceleration({x = 0, y = -10, z = 0})
				self.physical_state = true
				self.object:set_properties({physical = true})
				return
			end
		end

		pos.y = pos.y - 0.3
		nn = minetest.get_node_or_nil(pos).name
		ndef = minetest.registered_nodes[nn]
		-- If node is not registered or node is walkably solid
		if not ndef or ndef.walkable then
			if self.physical_state then
				self.object:setvelocity({x = 0, y = 0, z = 0})
				self.object:setacceleration({x = 0, y = 0, z = 0})
				self.physical_state = false
				self.object:set_properties({physical = false})
			end
		else
			if not self.physical_state then
				self.object:setvelocity({x = 0, y = 0, z = 0})
				self.object:setacceleration({x = 0, y =- 10, z = 0})
				self.physical_state = true
				self.object:set_properties({physical = true})
			end
		end
	end,

	on_punch = function(self, hitter)
		if self.itemstring ~= '' then
			local left = hitter:get_inventory():add_item("main", self.itemstring)
			if not left:is_empty() then
				self.itemstring = left:to_string()
				return
			end
		end
		self.object:remove()
	end,
})
