local pf = potted_farming
local S = pf.S


minetest.register_tool(pf.modname .. ":watering_can", {
	description = S("Watering Can"),
	inventory_image = pf.modname .. "_watering_can.png",
	groups = {watering_can = 1, not_in_creative_inventory = 1},
	liquids_pointable = false,
	stack_max = 1,
	wear = pf.watering_can_max_uses,
	range = 2.5,
	tool_capabilities = {},
})

--[[
	The watering_can usage is defined in the on_rightclick function of each
	individual plant, therefor its add_wear too.
	Furthermore, this allows me to set the plant in whatever state i want,
	and allowing me to change multiple nodes like in the fruit tree situation.
]]
