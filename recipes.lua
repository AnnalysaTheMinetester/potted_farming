local pf = potted_farming

--if minetest.registered_craftitems["flowerpot:empty"] then
minetest.register_craft({
	output = pf.modname .. ":pot_with_soil",
	recipe = {
		{"", "", ""},
		{"default:clay_brick", "default:dirt", "default:clay_brick"},
		{"dye:orange", "default:clay_brick", "dye:brown"},
	}
})

minetest.register_craft({
	output = pf.modname .. ":empty_watering_can",
	recipe = {
		{"default:tin_ingot", "", "dye:green"},
		{"default:tin_ingot", "", "default:tin_ingot"},
		{"dye:green", "default:tin_ingot", "dye:green"},
	}
})
