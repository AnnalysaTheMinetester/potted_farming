local lib = potted_farming
local S = lib.S

local pot_def = {
	groups = {flammable = 2, crumbly = 2, cracky = 3, attached_node = 1, not_in_creative_inventory = 1},
	tiles = {
			"pot_with_soil_top.png",
			"pot_with_soil_bottom.png",
			"pot_with_soil_side.png",
			"pot_with_soil_side.png",
			"pot_with_soil_side.png",
			"pot_with_soil_side.png"

	}, -- tiles
	drawtype = "nodebox",
	paramtype = "light",
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
					{-0.25, -0.5, -0.25, 0.25, -0.1875, 0.25},                                 -- selection

			}

	}, -- selection_box

	collision_box = {
			type = "fixed",
			fixed = {
					{-0.25, -0.5, -0.25, 0.25, -0.1875, 0.25},                                 -- selection

			}

	}, -- collsion_box

	on_rotate = function(pos, node)
		return false
	end,
}


--[[
        **************************************************
        **                                              **
        **            is_acceptable_source              **
        **                                              **
        **************************************************
        need modname:itemname
--]]

function lib.is_acceptable_source (itemname)
	local name = itemname:split(":")[2]
	local plant = name:split("_")[1]

	if plant == nil then plant = ""	end

	-- if plant is present in table AND the item in hand is the stem of that plant
	if lib.plant_list[plant] and string.find(name , "_stem") and lib.plant_list[plant][1] then
		return true, "plant", plant
	end
	for k,v in pairs(lib.mushroom_list) do
		if v[2] == itemname and v[1] then
			return true, "mushroom", k
		end
	end
	for k,v in pairs(lib.fruit_tree_list) do
		if v[2] == itemname and v[1] then
			return true, "fruit_tree", k
		end
	end

	return false, "no", nil

end -- lib.is_acceptable_source


--[[
        **************************************************
        **                                              **
        **                 check_light                  **
        **                                              **
        **************************************************
--]]

function lib.check_light(pos, min_light, max_light)
  local checkpos = pos
	if minetest.get_node(checkpos).name == "ignore" then
		return false
	end

  local pot_light = minetest.get_node_light(checkpos)
	minetest.chat_send_all("pot light".. pot_light)
	--"if you need to get the light value ontop of target node you need to get the light value of position above the target."
	--this is a potted plant, can stay inside a house, not on soil, therefore there is no need to check the light from the node above.
	local min = min_light
	local max = max_light

	if min < 1 then min = 1	end
	if max > 15 then max = 15	end

	if min <= pot_light and pot_light <= max then
		return true
	end

  return false

end -- function lib.check_light


--[[
        **************************************************
        **                                              **
        **             register_plant_abm               **
        **            growing_potted_plant              **
        **                                              **
        **************************************************
--]]

function lib.register_plant_abm(nodename, next_step_nodename, delay, percentage)
		-- if the register_plant_abm function is called, then surely the plant is defined and registerable
		-- mod_name:pot_with_PLANT_N
		local plant_name = nodename:split(":")[2]:split("_")[3] -- as per naming convention, [3] is the given plant_name
		local potted_plant = lib.plant_list[plant_name]
		local n = 6
		if potted_plant == nil then
			potted_plant = lib.mushroom_list[plant_name]
			n = 3
		end
    minetest.register_abm({
        label = "growing_potted_".. plant_name .."_abm",
        nodenames = {nodename},
        --neighbors = {"default:air"}, --can be omitted
        interval = delay,
        chance = percentage,
        action = function(pos, node, active_object_count, active_object_count_wider)
		      local nodepos = pos
	        if(lib.check_light(nodepos, potted_plant[n], potted_plant[n+1] ) ) then
	            minetest.swap_node(nodepos, {name = next_step_nodename})

	        end -- if(lib.check

    		end, -- action =

  	}) -- register_plant_abm

end -- lib.register_plant_abm


--[[
        **************************************************
        **                                              **
        **            add_watering_can_wear             **
        **                                              **
        **************************************************
--]]

function add_watering_can_wear(itemstack)
	local max_uses = lib.watering_can_max_uses
	itemstack:add_wear(65535 / (max_uses))
	local wear = itemstack:get_wear()
	if wear >= 65535 then
			itemstack:replace(lib.modname .. ":empty_watering_can")

	end -- if wear

	return itemstack

end -- add_watering_can_wear


--[[
        **************************************************
        **                                              **
        **              register_plant                  **
        **                                              **
        **************************************************
        plant_name = "basil" or "rosemary" etc
--]]

function lib.register_plant(plant_name)
    local plant_desc = plant_name:gsub("_", " "):gsub("(%a)(%a+)",
                        function(a, b)
                            return string.upper(a) .. string.lower(b)

                        end)


    -- HERB/LEAVES DEFINITION --
    local craftitem_def = {
        description = S(plant_desc),
        inventory_image = lib.modname .. "_".. plant_name ..".png",
        groups = {},
    }

    craftitem_def.groups["food_".. plant_name] = 1
    minetest.register_craftitem(lib.modname .. ":".. plant_name, table.copy(craftitem_def) )

    -- STEM DEFINITION --
    minetest.register_craftitem(lib.modname .. ":".. plant_name .."_stem", {
        description = S(plant_desc) .. S(" Stem"),
        inventory_image = lib.modname .. "_".. plant_name .."_stem.png",
        groups = {stem = 1, flammable = 2,},
        --the planting mechanism is in the pot on_rightclick

    }) -- register_craftitem(


    local plant_def = table.copy(pot_def)
		plant_def.description = S("Pot with ") .. S(plant_desc)

    -- POTTED plant_name STAGE 1 : just planted, gives stem back in case of accidental planting -----------------------
    plant_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.drop = {
        items = {
            {items = {lib.modname .. ":pot_with_soil"} },
            {items = {lib.modname .. ":" .. plant_name .."_stem"} },

            },

        } -- plant_def.drop

    minetest.register_node(lib.modname .. ":pot_with_".. plant_name .."_1",  table.copy(plant_def) )

    lib.register_plant_abm(lib.modname .. ":pot_with_".. plant_name .."_1",
                              lib.modname .. ":pot_with_".. plant_name .."_2", 30, 10)

    -- POTTED PLANT STAGE 2 : growing, gives nothing yet --------------------------------------------------------------
    plant_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_2.png"
    plant_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_2.png"
    plant_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_2.png"
    plant_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_2.png"
    plant_def.drop = {
        items = {
            {items = {lib.modname .. ":pot_with_soil"} },
            },

        } -- plant_def.drop

    minetest.register_node(lib.modname .. ":pot_with_".. plant_name .."_2",  table.copy(plant_def) )

    lib.register_plant_abm(lib.modname .. ":pot_with_".. plant_name .."_2",
                                    "potted_farming:pot_with_".. plant_name .."_3", 30, 15)

    -- POTTED PLANT STAGE 3 : fully grown, chance of giving stem, gives most leaves -----------------------------------
    plant_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_3.png"
    plant_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_3.png"
    plant_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_" ..plant_name .."_3.png"
    plant_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_3.png"
    plant_def.drop = {
        items = {
            {items = {lib.modname .. ":pot_with_soil"} },
            {items = {lib.modname .. ":".. plant_name .." 2"}, rarity = 1},
            {items = {lib.modname .. ":".. plant_name }, rarity = 2},
            {items = {lib.modname .. ":".. plant_name }, rarity = 5},
            {items = {lib.modname .. ":".. plant_name .."_stem" }, rarity = 5},
        }, -- items

    } -- plant_def.drop

    plant_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        if player:is_player() then
            local itemname = itemstack:get_name()
            if itemname ~= lib.modname ..":watering_can" then

							local nodepos = pos
              local q = math.random(2, 4)                                                -- number of leaves taken
              local stem = math.random(1, 5)                                             -- chance of getting a stem
							local leftover

							local item = ItemStack(lib.modname .. ":".. plant_name .." ".. q)

              local inv = player:get_inventory()
              if inv:room_for_item("main", item) then
                  leftover = inv:add_item("main", item)
									if not leftover:is_empty() then
										minetest.add_item(player:get_pos(), leftover)
									end
              else

                  minetest.add_item(player:get_pos(), item)

              end
							local stem_item = lib.modname .. ":"..plant_name .."_stem"

              if stem == 1 then
                  if inv:room_for_item("main", stem_item) then
                      leftover = inv:add_item("main", stem_item)
											if not leftover:is_empty() then
												minetest.add_item(player:get_pos(), leftover)
											end
                  else

                      minetest.add_item(player:get_pos(), stem_item)

                  end -- if inv.room

              end -- if stem

              local n = math.random(1, 3)
              minetest.sound_play("foliage-0".. n, {pos=nodepos, gain=1.2})

              minetest.set_node(nodepos, {name = lib.modname .. ":pot_with_".. plant_name .."_2"})

            end -- itemstack empty

        end-- player is a player

        return itemstack

    end -- plant_def.on_rightclick

    minetest.register_node(lib.modname.. ":pot_with_".. plant_name .."_3",  table.copy(plant_def) )

    lib.register_plant_abm(   lib.modname .. ":pot_with_".. plant_name .."_3",
                        lib.modname .. ":pot_with_".. plant_name .."_4", 40, 30)

    -- POTTED PLANT STAGE 4 : needs water, no stem, few leaves --------------------------------------------------------
    plant_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_4.png"
    plant_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_4.png"
    plant_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_4.png"
    plant_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_4.png"
    plant_def.drop = {
        items = {
            {items = {lib.modname .. ":pot_with_soil"} },
            {items = {lib.modname .. ":" .. plant_name .." 2"}},
            {items = {lib.modname .. ":".. plant_name }, rarity = 3},

        }, -- items

    } -- plant_def.drop

    plant_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        if player:is_player() then
        local itemname = itemstack:get_name()
        if itemstack:is_empty() == false and itemname == lib.modname .. ":watering_can" then
								local nodepos = pos
								local max_uses = lib.watering_can_max_uses
                itemstack:add_wear(65535 / (max_uses))
                local wear = itemstack:get_wear()
                if wear >= 65535 then
                    --minetest.chat_send_player(player:get_player_name(), "wear "..wear)
                    itemstack:replace(lib.modname .. ":empty_watering_can")

                end -- if wear

                local n = math.random(3, 4)
                minetest.sound_play("water-splash-0".. n, {pos=nodepos, gain=1.2})
                minetest.set_node(nodepos, {name = lib.modname .. ":pot_with_".. plant_name .."_3"})

        end -- itemstack is watering_can

        end -- player is a player
        return itemstack

	end -- plant_def.on_rightclick

    minetest.register_node(lib.modname .. ":pot_with_" .. plant_name .."_4",  table.copy(plant_def) )

end -- register_plant


--[[
        **************************************************
        **                                              **
        **            register_wild_variant             **
        **                                              **
        **************************************************

--]]

function lib.register_wild_variant(plant_name, nodes, s, min, max)

    minetest.register_node(lib.modname .. ":wild_".. plant_name , {
    description = S("Wild ").. S(plant_name),
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    paramtype2 = "facedir",
    tiles = {lib.modname .. "_wild_".. plant_name ..".png"},
    inventory_image = lib.modname .. "_wild_".. plant_name ..".png",
    wield_image = lib.modname .. "_wild_".. plant_name ..".png",
    groups = {  snappy = 3, dig_immediate = 1, flammable = 2, plant = 1,
                flora = 1, attached_node = 1, not_in_creative_inventory = 1 },
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
            fixed = { {-4 / 16, -0.5, -4 / 16, 4 / 16, 5 / 16, 4 / 16},	},

            }, -- selection_box

    drop =  {
        items = {
            {items = {lib.modname .. ":".. plant_name .." 2"}, rarity = 1},
            {items = {lib.modname .. ":".. plant_name}, rarity = 2},
            {items = {lib.modname .. ":".. plant_name .."_stem"}, rarity = 1},

        } -- items

    }, -- drop

  }) -- register_node

  minetest.register_decoration({
    deco_type = "simple",
    place_on = nodes,
    sidelen = 16,
    noise_params = {
        offset = 0,
        scale = s,
        spread = {x = 70, y = 70, z = 70},
        seed = 2570,
        octaves = 3,
        persist = 0.6

    }, -- noise_params
    y_min = min,
    y_max = max,
    decoration = lib.modname .. ":wild_".. plant_name,

  }) -- register_decoration

end -- function lib.register_wild_variant


--[[
        **************************************************
        **                                              **
        **              register_mushroom               **
        **                                              **
        **************************************************
        mushroom_name = "brown" or "chanterelle" etc
--]]


function lib.register_mushroom(mushroom_name, full_mushroom_name)
	-- the check if the mushroom item exists is done when calling the function, not inside

	local mushroom_desc = mushroom_name:gsub("_", " "):gsub("(%a)(%a+)",
											function(a, b)
													return string.upper(a) .. string.lower(b)

											end)

	local mushroom_def = table.copy(pot_def)
	mushroom_def.description = S("Pot with ") .. S(mushroom_desc)

	--POTTED MUSHROOM STAGE 1 : just planted, gives back one mushroom
	mushroom_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_1.png"
	mushroom_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_1.png"
	mushroom_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_1.png"
	mushroom_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_1.png"
	mushroom_def.drop = {
			items = {
					{items = {lib.modname .. ":pot_with_soil"} },
					{items = {full_mushroom_name} },

					},

			} -- mushroom_def.drop

	minetest.register_node(lib.modname .. ":pot_with_".. mushroom_name .."_1",  table.copy(mushroom_def) )

	lib.register_plant_abm(lib.modname .. ":pot_with_".. mushroom_name .."_1",
									 lib.modname .. ":pot_with_".. mushroom_name .."_2", 30, 15)


	--POTTED MUSHROOM STAGE 2 : growing, if you click you will get one mushroom, and goes back to 1
	mushroom_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_2.png"
	mushroom_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_2.png"
	mushroom_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_" ..mushroom_name .."_2.png"
	mushroom_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_2.png"
	mushroom_def.drop = {
			items = {
					{items = {lib.modname .. ":pot_with_soil"} },
					{items = {full_mushroom_name } },
					{items = {full_mushroom_name }, rarity = 2},

			}, -- items

	} -- mushroom_def.drop

	mushroom_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
			if player:is_player() then
					local itemname = itemstack:get_name()
					if itemname ~= lib.modname ..":watering_can" then

						local nodepos = pos
						local q = math.random(1, 2)
						local leftover

						local inv = player:get_inventory()
						if inv:room_for_item("main", full_mushroom_name .." ".. q) then
								leftover = inv:add_item("main", full_mushroom_name .." ".. q)
								if not leftover:is_empty() then
									minetest.add_item(player:get_pos(), leftover)
								end
						else
								minetest.add_item(player:get_pos(), full_mushroom_name .." ".. q)

						end

						local n = math.random(1, 3)
						minetest.sound_play("foliage-0".. n, {pos=nodepos, gain=1.2})

						minetest.set_node(nodepos, {name = lib.modname .. ":pot_with_".. mushroom_name .."_1"})

					end -- itemstack empty

			end-- player is a player

			return itemstack

	end -- mushroom_def.on_rightclick

	minetest.register_node(lib.modname.. ":pot_with_".. mushroom_name .."_2",  table.copy(mushroom_def) )

	lib.register_plant_abm(lib.modname .. ":pot_with_".. mushroom_name .."_2",
									 lib.modname .. ":pot_with_".. mushroom_name .."_3", 30, 10)


	--POTTED MUSHROOM STAGE 3 : fully grown, click to get 2-4 mushrooms, goes back to 2, FINAL STAGE

	mushroom_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_3.png"
	mushroom_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_3.png"
	mushroom_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_" ..mushroom_name .."_3.png"
	mushroom_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_3.png"
	mushroom_def.drop = {
			items = {
					{items = {lib.modname .. ":pot_with_soil"} },
					{items = {full_mushroom_name .." 2"}, rarity = 1},
					{items = {full_mushroom_name }, rarity = 2},
					{items = {full_mushroom_name }, rarity = 4},

			}, -- items

	} -- mushroom_def.drop

	mushroom_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
			if player:is_player() then
					local itemname = itemstack:get_name()
					if itemname ~= lib.modname ..":watering_can" then

						local nodepos = pos
						local q = math.random(2, 4)																									-- number of mushrooms taken
						local leftover

						local inv = player:get_inventory()
						if inv:room_for_item("main", full_mushroom_name .." ".. q) then
								leftover = inv:add_item("main", full_mushroom_name .." ".. q)
								if not leftover:is_empty() then
									minetest.add_item(player:get_pos(), leftover)
								end
						else
								minetest.add_item(nodepos, full_mushroom_name .." ".. q)

						end

						local n = math.random(1, 3)
						minetest.sound_play("foliage-0".. n, {pos=nodepos, gain=1.2})

						minetest.set_node(nodepos, {name = lib.modname .. ":pot_with_".. mushroom_name .."_1"})

					end -- itemstack empty

			end-- player is a player

			return itemstack

	end -- mushroom_def.on_rightclick

	minetest.register_node(lib.modname.. ":pot_with_".. mushroom_name .."_3",  table.copy(mushroom_def) )


	--POTTED MUSHROOM STAGE 4 : too much sun exposure, dryed up, ALL STAGES can get to this one if the lightlevel is too high
	mushroom_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_4.png"
	mushroom_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_4.png"
	mushroom_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_" ..mushroom_name .."_4.png"
	mushroom_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. mushroom_name .."_4.png"
	mushroom_def.drop = {
			items = {
					{items = {lib.modname .. ":pot_with_soil"} },
					{items = {full_mushroom_name .." 2"}, rarity = 1},
					{items = {full_mushroom_name }, rarity = 2},

			}, -- items

	} -- mushroom_def.drop

	mushroom_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
			if player:is_player() then
					local itemname = itemstack:get_name()
					if itemname ~= lib.modname ..":watering_can" then

						local nodepos = pos
						local q = math.random(1, 3) 																								-- number of mushrooms taken
						local leftover

						local inv = player:get_inventory()
						if inv:room_for_item("main", full_mushroom_name .." ".. q) then
								leftover = inv:add_item("main", full_mushroom_name .." ".. q)
								if not leftover:is_empty() then
									minetest.add_item(player:get_pos(), leftover)
								end
						else
								minetest.add_item(nodepos, full_mushroom_name .." ".. q)

						end

						local n = math.random(1, 3)
						minetest.sound_play("foliage-0".. n, {pos=nodepos, gain=1.2})

						minetest.set_node(nodepos, {name = lib.modname .. ":pot_with_soil"})

				end -- itemstack empty

			end-- player is a player

			return itemstack

	end -- mushroom_def.on_rightclick

	minetest.register_node(lib.modname.. ":pot_with_".. mushroom_name .."_4",  table.copy(mushroom_def) )

	-- DRYING UP ABM

  minetest.register_abm({
      label = "drying_potted_mushroom_abm",
      nodenames = {
				lib.modname.. ":pot_with_".. mushroom_name .."_1",
				lib.modname.. ":pot_with_".. mushroom_name .."_2",
				lib.modname.. ":pot_with_".. mushroom_name .."_3",
			},
      --neighbors = {"default:air"},
      interval = 30,
      chance = 40,
      action = function(pos, node, active_object_count, active_object_count_wider)
				local potted_plant = lib.mushroom_list[mushroom_name]
	      local nodepos = pos
				local can_grow = lib.check_light(nodepos, potted_plant[3], potted_plant[4])
        if can_grow == false then
            minetest.swap_node(nodepos, {name = lib.modname.. ":pot_with_".. mushroom_name .."_4"})

        end -- if(lib.check

  		end, -- action =

	}) -- register_abm

end -- function lib.register_mushroom


--[[
        **************************************************
        **                                              **
        **            check_free_space_above            **
        **                                              **
        **************************************************

--]]

function lib.check_free_space_above(pot_pos)
	local above_pos = vector.add(pot_pos, vector.new(0, 1, 0))
	local above_node = minetest.get_node(above_pos)

	if above_node.name == "air" then
		return true
	end
	return false

end -- function lib.check_free_space_above


--[[
        **************************************************
        **                                              **
        **             register_sapling_abm             **
        **                                              **
        **************************************************

--]]

function lib.register_sapling_abm(nodename, shrub_nodename, leaves_nodename, fruit , delay, percentage)
	local potted_plant = lib.fruit_tree_list[fruit]

	minetest.register_abm({
			label = "growing_potted_".. fruit .."_sapling_abm",
			nodenames = {nodename},
			--neighbors = {"default:air"}, --can be omitted
			interval = delay,
			chance = percentage,
			action = function(pos, node, active_object_count, active_object_count_wider)
				local nodepos = pos
				local above_nodepos = vector.add(nodepos, vector.new(0, 1, 0))
				local enough_light = lib.check_light(above_nodepos, potted_plant[5], potted_plant[6])

				if lib.check_free_space_above(nodepos) and enough_light then
						minetest.swap_node(nodepos, {name = shrub_nodename})
						minetest.swap_node(above_nodepos, {name = leaves_nodename})

					end -- if(lib.check

			end, -- action =

	})

end -- function lib.register_sapling_abm


	--[[
	        **************************************************
	        **                                              **
	        **             register_leaves_abm              **
	        **                                              **
	        **************************************************

	--]]

function lib.register_leaves_abm(nodename, fruit_leaves_nodename, thirsty_leaves_nodename, fruit, delay, percentage)
	local potted_plant = lib.fruit_tree_list[fruit]

	minetest.register_abm({
			label = "growing_potted_".. fruit .."_leaves_abm",
			nodenames = {nodename},
			--neighbors = {"default:air"}, --can be omitted
			interval = delay,
			chance = percentage,
			action = function(pos, node, active_object_count, active_object_count_wider)
				local nodepos = pos
				local leaves_nodename = thirsty_leaves_nodename
				local enough_light = lib.check_light(nodepos, potted_plant[5], potted_plant[6] )

				local meta = minetest.get_meta(nodepos)
				local pot_light = meta:get_int("lightlevel")

				minetest.chat_send_all("leaves abm ".. fruit .. " enough_light ".. tostring(enough_light) .." light at pos ".. pot_light)
				if enough_light then
					local growth = math.random(1, 3)

					if growth == 1 then
						leaves_nodename = fruit_leaves_nodename
					end

				end -- if(lib.check
				minetest.swap_node(nodepos, {name = leaves_nodename} )

			end, -- action =

	})

end -- function lib.register_leaves_abm


		--[[
							**************************************************
							**                                              **
							**             register_fruit_tree              **
							**                                              **
							**************************************************
		sapling_name = "ethereal:lemon_tree_sapling", full_fruit_name = "ethereal:lemon"
		--]]

function lib.register_fruit_tree (k, sapling_name, full_fruit_name, original_leaves_png)
	-- from sapling a litte potted tree
	local fruit_mod_name = full_fruit_name:split(":")[1]
	local fruit_name = k

	local leaves_png = original_leaves_png
	if leaves_png == nil then
		leaves_png = "default_leaves.png"
	end

	local shrub_def = table.copy(pot_def)
	shrub_def.description = S("Pot with ") .. S(fruit_name)

	-- STAGE 1 pot with sapling : grows into pot with shrub after quite a while, will not grow unless there is space above
	shrub_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. fruit_name .."_sapling.png"
	shrub_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. fruit_name .."_sapling.png"
	shrub_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_" ..fruit_name .."_sapling.png"
	shrub_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. fruit_name .."_sapling.png"
	shrub_def.drop = {
			items = {
					{items = {lib.modname .. ":pot_with_soil"} },
					{items = {sapling_name} },

			}, -- items

	} -- shrub_def.drop

	minetest.register_node(lib.modname.. ":pot_with_".. fruit_name .."_sapling",  table.copy(shrub_def) )

	lib.register_sapling_abm(lib.modname.. ":pot_with_".. fruit_name .."_sapling",
													 lib.modname.. ":pot_with_shrub",
													 lib.modname.. ":".. fruit_name .."_leaves_1", fruit_name, 20, 10)

	-- STAGE 2 pot with shrub : does not grow but is the base for the leaf node above

	-- MOVED to nodes.lua , registering one and only one shrub, im keeping the register_sapling_abm as it is
	--											because i could have plants with a different shrub, like banana

	-- ABOVE shrub, leaves : if the leaves are destroyed, the pot below is destroyed too, and viceversa
	local fruit_desc = fruit_name:gsub("(%a)(%a+)",
											function(a, b)
													return string.upper(a) .. string.lower(b)

											end)

	local leaves_def = {
		description = S(fruit_desc) .. S(" (Leaves)"),
		drawtype = "plantlike",
		visual_scale = 1.4,
		walkable = false,
		paramtype = light,
		tiles = { leaves_png },
		sunlight_propagates = true,
		groups = {snappy = 3, attached_node = 1, leaves = 1, flammable = 2, not_in_creative_inventory = 1 },
		drop = {
			items = {
				{items = {sapling_name}, rarity = 5},
			}
		},
		sounds = default.node_sound_leaves_defaults(),

	} -- leaves_def

	-- STAGE 1 : lemon leaves 1 : grows into leaves with lemon, OR leaves that needs water

	minetest.register_node(lib.modname.. ":".. fruit_name .."_leaves_1",  table.copy(leaves_def) )

	-- special abm, with some randomness to determine wheather leaves should go to fruit leaves or thristy leaves
	lib.register_leaves_abm(lib.modname.. ":".. fruit_name .."_leaves_1",
	 												lib.modname.. ":".. fruit_name .."_leaves_2",
													lib.modname.. ":".. fruit_name .."_leaves_3", fruit_name, 5, 30)

	-- STAGE 2 : lemon leaves 2 : gives 2-3 lemons, does not grow more, goes back to leaves 1 when harvested

	leaves_def.tiles = {lib.modname .."_".. fruit_name .."_on_leaves.png^".. leaves_png }
	leaves_def.drop = {
		items = {
			{items = {full_fruit_name .." 2"}},
		}
	}
	leaves_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
			if player:is_player() then
					local itemname = itemstack:get_name()
					if itemname ~= lib.modname ..":watering_can" then

						local nodepos = pos
						local q = math.random(2, 3)																									-- number of fruit taken
						local leftover
						local item = ItemStack(full_fruit_name .." ".. q)

						local inv = player:get_inventory()
						if inv:room_for_item("main", item) then
								leftover = inv:add_item("main", item)
								if not leftover:is_empty() then
									minetest.add_item(player:get_pos(), leftover)
								end
						else
								minetest.add_item(player:get_pos(), item)

						end

						local n = math.random(1, 3)
						minetest.sound_play("foliage-0".. n, {pos=nodepos, gain=1.2})

						minetest.set_node(nodepos, {name = lib.modname.. ":".. fruit_name .."_leaves_1"})

					end -- itemstack empty

			end-- player is a player

			return itemstack

	end -- leaves_def.on_rightclick

	minetest.register_node(lib.modname.. ":".. fruit_name .."_leaves_2",  table.copy(leaves_def) )

	-- lemon leaves 3 : needs water, does not grow, goes back to leaves 1 when the POT is watered

	leaves_def.tiles = { leaves_png .. "^[colorize:yellow:30" }
	leaves_def.drop = {}

	minetest.register_node(lib.modname.. ":".. fruit_name .."_leaves_3",  table.copy(leaves_def) )

end -- function lib.register_fruit_tree
