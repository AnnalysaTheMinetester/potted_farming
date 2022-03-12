local pf = potted_farming
local S = pf.S

-- Pot to plant
minetest.register_node(pf.modname .. ":pot_with_soil", {
	description = S("Pot with Soil"),

	tiles = {
		"pot_with_soil_top.png",
		"pot_with_soil_bottom.png",
		"pot_with_soil_side.png",
		"pot_with_soil_side.png",
		"pot_with_soil_side.png",
		"pot_with_soil_side.png"
	},

	drawtype = "nodebox",
	paramtype = "light",

	groups = {oddly_breakable_by_hand = 4, crumbly = 1, cracky = 1, attached_node = 1},

	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, -0.1875, 0.1875}, -- base_center
			{-0.25, -0.375, -0.125, -0.1875, -0.1875, 0.125}, -- base1
			{-0.125, -0.375, 0.1875, 0.125, -0.1875, 0.25}, -- base2
			{0.1875, -0.375, -0.125, 0.25, -0.1875, 0.125}, -- base3
			{-0.125, -0.375, -0.25, 0.125, -0.1875, -0.1875}, -- base4
		}
	},

	selection_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, -0.1875, 0.25}, -- selection
		}
	},

	collision_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, -0.1875, 0.25}, -- selection
		}
	},

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:is_player() and itemstack:is_empty() == false then
			local itemname = itemstack:get_name()
			local acceptable, plant = pf.is_acceptable_source(itemname)
			if acceptable then
				minetest.set_node(pos, {name = pf.modname .. ":pot_with_".. plant .."_1"})
				itemstack:take_item()
			end
		end
	end,

	on_rotate = function(pos, node)
		return false
	end,

}) -- minetest.register_node(pot

