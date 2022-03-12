local pf = potted_farming
local S = pf.S

minetest.register_craftitem(pf.modname .. ":empty_watering_can", {
	description = S("Watering Can"),
	inventory_image = pf.modname .. "_empty_watering_can.png",
	groups = {watering_can = 1},
	liquids_pointable = true,
	stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		if not pos then return itemstack end
		--
		if  player:is_player() and pointed_thing.type == "node" and
            minetest.get_item_group(minetest.get_node(pos).name , "water") >= 1 then
			itemstack:replace(pf.modname .. ":watering_can")                               -- so that it isnt given on another
                                                                                           -- inv slot and can be
                                                                                           -- immediatelly used
			local n = math.random(1, 2)
			minetest.sound_play("water_splash-0".. n, {pos=pos, gain=0.8})
		end

		return itemstack

	end,
})
