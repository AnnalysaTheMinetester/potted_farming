local pf = potted_farming

minetest.register_craft({
	output = pf.modname .. ":pot_with_soil",
	recipe = {
		{"", "", ""},
		{"default:brick", "group:dirt", "default:brick"},
		{"dye:orange", "default:brick", "dye:brown"},
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
