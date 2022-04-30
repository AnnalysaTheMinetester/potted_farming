local pf = potted_farming
local S = pf.S

local h_k = minetest.get_modpath("homedecor_kitchen") ~= nil
local h_b = minetest.get_modpath("homedecor_bathroom") ~= nil
local h_e = minetest.get_modpath("homedecor_exterior") ~= nil

local water_list = {
	["default:water_source"] = true,
	["default:water_flowing"] = true,
	["default:river_water_source"] = true,
	["default:river_water_flowing"] = true,
	["homedecor:kitchen_cabinet_colorable_with_sink"] = h_k,
	["homedecor:kitchen_cabinet_colorable_with_sink_locked"] = h_k,
	["homedecor:kitchen_faucet"] = h_b,
	["homedecor:sink"] = h_b,
	["homedecor:taps"] = h_b,
	["homedecor:taps_brass"] = h_b,
	["homedecor:well"] = h_e,
}

minetest.register_craftitem(pf.modname .. ":empty_watering_can", {
	description = S("Empty Watering Can"),
	inventory_image = pf.modname .. "_empty_watering_can.png",
	groups = {watering_can = 1},
	liquids_pointable = true,
	stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		if not pos then return itemstack end
		local name = minetest.get_node(pos).name
		-- minetest.get_item_group(minetest.get_node(pos).name , "water") >= 1
		if  player:is_player() and pointed_thing.type == "node" and water_list[name] then
			itemstack:replace(pf.modname .. ":watering_can")                          -- so that it isnt given on another
                                                                                          -- inv slot and can be
                                                                                           -- immediatelly used
			local n = math.random(1, 2)
			minetest.sound_play("water-splash-0".. n, {pos=pos, gain=1.2})
		end

		return itemstack

	end,
})
