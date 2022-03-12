potted_farming = {}
potted_farming.version = 1.0
potted_farming.path = minetest.get_modpath(minetest.get_current_modname())
potted_farming.plant_list = {
-- name 			found on																	 scale	y min max
	{"basil", {"default:dirt_with_grass", "default:dirt"}, 0.0003, 0, 250},
} -- parsley, sage, rosemary, mint, cinnamon?

local function is_accettable_source (itemname)
	for i=1,#potted_farming.plant_list do
			local name = itemname:split(":")[2]
			if name == potted_farming.plant_list[i][1] .. "_stem" then
				return true, potted_farming.plant_list[i][1]
			end
	end
	return false, "no"
end
--register pot
minetest.register_node("potted_farming:pot_with_soil", {
	description = "Pot with Soil",
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
			local accettable, plant = is_accettable_source(itemname)
			if accettable then
				minetest.set_node(pos, {name = "potted_farming:pot_with_".. plant .."_1"})
				itemstack:take_item()
			end
		end
	end,
	on_rotate = function(pos, node)
		return false
	end,
})
minetest.register_craft({
	output = "potted_farming:pot_with_soil",
	recipe = {
		{"", "", ""},
		{"default:brick", "group:dirt", "default:brick"},
		{"dye:orange", "default:brick", "dye:brown"},
	}
})

minetest.register_craftitem("potted_farming:empty_watering_can", {
	description = "Watering Can",
	inventory_image = "potted_farming_empty_watering_can.png",
	groups = {watering_can = 1},
	liquids_pointable = true,
	stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		if not pos then return itemstack end
		--
		if player:is_player() and pointed_thing.type == "node" and minetest.get_item_group(minetest.get_node(pos).name , "water") >= 1 then
			itemstack:replace("potted_farming:watering_can") -- so that it isnt given on another inv slot and can be immediatelly used
			local n = math.random(1, 2)
			minetest.sound_play("water_splash-0".. n, {pos=pos, gain=0.8})
		end
		return itemstack
	end,
})
minetest.register_craft({
	output = "potted_farming:empty_watering_can",
	recipe = {
		{"default:tin_ingot", "", "dye:green"},
		{"default:tin_ingot", "", "default:tin_ingot"},
		{"dye:green", "default:tin_ingot", "dye:green"},
	}
})
minetest.register_tool("potted_farming:watering_can", {
	description = "Watering Can",
	inventory_image = "potted_farming_watering_can.png",
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

dofile(potted_farming.path .. "/lib.lua")
--potted_farming.register_plant("basil")
for i=1, #potted_farming.plant_list do
	potted_farming.register_plant(potted_farming.plant_list[i][1])
	potted_farming.register_wild_variant(potted_farming.plant_list[i][1], potted_farming.plant_list[i][2],
		potted_farming.plant_list[i][3], potted_farming.plant_list[i][4], potted_farming.plant_list[i][5] )
end
