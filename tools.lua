local pf = potted_farming
local S = pf.S


minetest.register_tool(pf.modname .. ":watering_can", {
	description = S("Watering Can"),
	inventory_image = pf.modname .. "_watering_can.png",
	groups = {watering_can = 1, not_in_creative_inventory = 1},
	liquids_pointable = false,
	stack_max = 1,
	wear = 10,
	range = 2.5,
	tool_capabilities = {},
	on_use = function(itemstack, player, pointed_thing)
		--local n = math.random(1, 2)
		minetest.sound_play("water_splash-01", {pos=pos, gain=0.8})
		return itemstack
	end,
})
