local pf = potted_farming
local S = pf.S
local max_uses = pf.watering_can_max_uses

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
			local acceptable, type, plant = pf.is_acceptable_source(itemname)
			local step = "1"
			if type == "fruit_tree" then step = "sapling"	end
			if acceptable then
				local n = math.random(1, 3)
  			minetest.sound_play("dirt-0".. n, {pos=pos, gain=1.2})
				minetest.set_node(pos, {name = pf.modname .. ":pot_with_".. plant .. "_" .. step})
				itemstack:take_item()
			end
		end
	end,

	on_rotate = function(pos, node)
		return false
	end,

}) -- minetest.register_node(pot

local pot_with_shrub = {
	description = S("Pot with Shrub"),
	groups = {flammable = 2, crumbly = 1, cracky = 1, attached_node = 1, not_in_creative_inventory = 1},
	tiles = {
			"pot_with_soil_top.png",
			"pot_with_soil_bottom.png",
			"pot_with_soil_side.png^" .. pf.modname .. "_shrub.png",
			"pot_with_soil_side.png^" .. pf.modname .. "_shrub.png",
			"pot_with_soil_side.png^" .. pf.modname .. "_shrub.png",
			"pot_with_soil_side.png^" .. pf.modname .. "_shrub.png"

	}, -- tiles
	drawtype = "nodebox",
	paramtype = "light",
	walkable = true,
	node_box = {
			type = "fixed",
			fixed = {
					{-0.1875, -0.5, -0.1875, 0.1875, -0.1875, 0.1875},                         -- base_center
					{-0.25, -0.375, -0.125, -0.1875, -0.1875, 0.125},                          -- base1
					{-0.125, -0.375, 0.1875, 0.125, -0.1875, 0.25},                            -- base2
					{0.1875, -0.375, -0.125, 0.25, -0.1875, 0.125},                            -- base3
					{-0.125, -0.375, -0.25, 0.125, -0.1875, -0.1875},                          -- base4
					{-0.5, -0.5, 0, 0.5, 0.5, 0},                                              -- plant1X
					{0, -0.5, -0.5, 0, 0.5, 0.5},                                              -- plant2Z

			} -- fixed

	}, -- node_box
	selection_box = {
			type = "fixed",
			fixed = {
					{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},                                 -- selection

			}

	}, -- selection_box

	collision_box = {
			type = "fixed",
			fixed = {
					{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},                                 -- selection

			}

	}, -- collsion_box

	drop = {
		items = {
			{items = {pf.modname .. ":pot_with_soil"} },
			{items = {"default:stick"} },

		}, -- items

	}, -- drop

	on_rightclick = function (pos, node, player, itemstack, pointed_thing)
		if player:is_player() then
			local itemname = itemstack:get_name()
			if itemstack:is_empty() == false and itemname == pf.modname .. ":watering_can" then
				local nodepos = pos
				local possible_leaf_pos = vector.add(nodepos, vector.new(0, 1, 0))
				local possible_leaf = minetest.get_node(possible_leaf_pos)

				local fruit_name = nil
				for k, v in pairs(pf.fruit_tree_list) do
					if possible_leaf.name == pf.modname ..":".. k .."_leaves_3" then
						fruit_name = k
					end
				end -- fruit_tree_list iteration

				if fruit_name ~= nil then
					itemstack = pf.add_watering_can_wear(itemstack)

					local n = math.random(3, 4)
					minetest.sound_play("water-splash-0".. n, {pos=nodepos, gain=1.2})
					minetest.swap_node(possible_leaf_pos, {name = pf.modname .. ":".. fruit_name .."_leaves_1", param2 = 2})

				end -- if node above is ANY thirsty leaves

			end -- itemstack is watering_can

		end -- player is a player
		return itemstack

	end, -- on_rightclick
	-- no further action is required, the leaves should fall on their own, as they too are an attached_node

	on_rotate = function(pos, node)
		return false
	end,

} -- pot_with_shrub table

minetest.register_node(pf.modname ..":pot_with_shrub",  table.copy(pot_with_shrub) )

-- different shrub for a different plant, that differes only in texture
-- unfortunately i have to make another node just for this difference

pot_with_shrub.description = S("Pot with Plantain")
pot_with_shrub.tiles = {
		"pot_with_soil_top.png",
		"pot_with_soil_bottom.png",
		"pot_with_soil_side.png^" .. pf.modname .. "_plantain.png",
		"pot_with_soil_side.png^" .. pf.modname .. "_plantain.png",
		"pot_with_soil_side.png^" .. pf.modname .. "_plantain.png",
		"pot_with_soil_side.png^" .. pf.modname .. "_plantain.png"

} -- plantain tiles

minetest.register_node(pf.modname ..":pot_with_plantain",  table.copy(pot_with_shrub) )
