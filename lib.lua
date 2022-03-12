function potted_farming.check_light(pos)
  local checkpos = pos
  local above = {x = checkpos.x, y = checkpos.y + 1, z = checkpos.z}
  local meta = minetest.get_meta(checkpos)
  local lightlevel = meta:get_int("lightlevel")
  local light = 0

  if(minetest.get_node_or_nil(above) ~= nil) then
      light = minetest.get_node_light(above)
      if(light >= lightlevel) then return true end
  end

  return false

end -- lightlevel check


function potted_farming.register_abm(nodename, next_step_nodename, delay, percentage)
  minetest.register_abm({
    label = "growing_potted_plant_amb",
    nodenames = {nodename},
    --neighbors = {"default:air"}, --can be omitted
    interval = delay,
    chance = percentage,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local nodepos = pos
        if(potted_farming.check_light(nodepos)) then
          minetest.swap_node(nodepos, {name = next_step_nodename})
        end
    end,
  })

end

function potted_farming.plant_stem(node_def, pointed_thing)

  if(pointed_thing.type == "node") then
    local node = minetest.get_node(minetest.get_pointed_thing_position(pointed_thing, under))
    if (node.name == "potted_farming:pot_with_soil") then
      minetest.set_node(pointed_thing.under, {name = node_def.nodename .. "_stem"})
      return true
    end
  end
  return false

end

function potted_farming.register_plant(plant_name) -- plant_name = "basil" or "rosemary" etc

  local plant_desc = plant_name:gsub("_", " "):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end)

  -- HERB/LEAVES DEFINITION --
  local craftitem_def = {
    description = plant_desc,
  	inventory_image = "potted_farming_".. plant_name ..".png",
    groups = {},
  }
  craftitem_def.groups["food_".. plant_name] = 1
  minetest.register_craftitem("potted_farming:".. plant_name, table.copy(craftitem_def) )

  -- STEM DEFINITION --
  minetest.register_craftitem("potted_farming:".. plant_name .."_stem", {
    description = plant_desc .." Stem",
    inventory_image = "potted_farming_".. plant_name .."_stem.png",
    groups = {stem = 1, flammable = 2,},
    --the planting mechanism is in the pot on_rightclick
  })

  local plant_def = {
    description = plant_desc,
    groups = {flammable = 2, crumbly = 1, cracky = 1, attached_node = 1, not_in_creative_inventory = 1},
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
  	node_box = {
  		type = "fixed",
  		fixed = {
        {-0.1875, -0.5, -0.1875, 0.1875, -0.1875, 0.1875}, -- base_center
  			{-0.25, -0.375, -0.125, -0.1875, -0.1875, 0.125}, -- base1
  			{-0.125, -0.375, 0.1875, 0.125, -0.1875, 0.25}, -- base2
  			{0.1875, -0.375, -0.125, 0.25, -0.1875, 0.125}, -- base3
  			{-0.125, -0.375, -0.25, 0.125, -0.1875, -0.1875}, -- base4
  			{-0.5, -0.5, 0, 0.5, 0.5, 0}, -- plant1X
  			{0, -0.5, -0.5, 0, 0.5, 0.5}, -- plant2Z
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
  }

  -- POTTED plant_name STAGE 1 : just planted, gives stem back in case of accidental planting -----------------------
  plant_def.tiles[3] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_1.png"
  plant_def.tiles[4] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_1.png"
  plant_def.tiles[5] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_1.png"
  plant_def.tiles[6] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_1.png"
  plant_def.drop = {
    items = {
      {items = {"potted_farming:pot_with_soil"} },
      {items = {"potted_farming:".. plant_name .."_stem"} },
    },
  }
  minetest.register_node("potted_farming:pot_with_".. plant_name .."_1",  table.copy(plant_def) )

  potted_farming.register_abm("potted_farming:pot_with_".. plant_name .."_1",
                              "potted_farming:pot_with_".. plant_name .."_2", 10, 20)

  -- POTTED PLANT STAGE 2 : growing, gives nothing yet --------------------------------------------------------------
  plant_def.tiles[3] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_2.png"
  plant_def.tiles[4] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_2.png"
  plant_def.tiles[5] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_2.png"
  plant_def.tiles[6] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_2.png"
  plant_def.drop = {
    items = {
      {items = {"potted_farming:pot_with_soil"} },
    },
  }
  minetest.register_node("potted_farming:pot_with_".. plant_name .."_2",  table.copy(plant_def) )

  potted_farming.register_abm("potted_farming:pot_with_".. plant_name .."_2",
                              "potted_farming:pot_with_".. plant_name .."_3", 15, 25)

  -- POTTED PLANT STAGE 3 : fully grown, chance of giving stem, gives most leaves -----------------------------------
  plant_def.tiles[3] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_3.png"
  plant_def.tiles[4] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_3.png"
  plant_def.tiles[5] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_3.png"
  plant_def.tiles[6] = "pot_with_soil_side.png^potted_farming_".. plant_name .."_3.png"
  plant_def.drop = {
    items = {
      {items = {"potted_farming:pot_with_soil"} },
      {items = {"potted_farming:".. plant_name .." 2"}, rarity = 1},
      {items = {"potted_farming:".. plant_name }, rarity = 2},
      {items = {"potted_farming:".. plant_name }, rarity = 5},
      {items = {"potted_farming:".. plant_name .."_stem" }, rarity = 5},
    },
  }
  plant_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
		if player:is_player() then
			local itemname = itemstack:get_name()
			if itemstack:is_empty() == true then

        local q = math.random(2, 4) -- number of leaves taken
        local stem = math.random(1, 5) -- 1 in x chance of getting a stem

        local inv = player:get_inventory()
        if inv:room_for_item("main", "potted_farming:"..plant_name .." ".. q) then
					inv:add_item("main", "potted_farming:".. plant_name .." ".. q)
				else
					minetest.add_item(pos, "potted_farming:".. plant_name .." ".. q)
				end

        if stem == 1 then
          if inv:room_for_item("main", "potted_farming:"..plant_name .."_stem") then
    				inv:add_item("main", "potted_farming:".. plant_name .."_stem")
    			else
    				minetest.add_item(pos, "potted_farming:".. plant_name .."_stem")
    			end
        end

				minetest.set_node(pos, {name = "potted_farming:pot_with_".. plant_name .."_2"})
			end -- itemstack empty
		end-- player is a player
    return itemstack
	end
  minetest.register_node("potted_farming:pot_with_".. plant_name .."_3",  table.copy(plant_def) )

  potted_farming.register_abm("potted_farming:pot_with_".. plant_name .."_3",
                              "potted_farming:pot_with_".. plant_name .."_4", 30, 10)

  -- POTTED PLANT STAGE 4 : needs water, no stem, few leaves --------------------------------------------------------
  plant_def.tiles[3] = "pot_with_soil_side.png^potted_farming_basil_4.png"
  plant_def.tiles[4] = "pot_with_soil_side.png^potted_farming_basil_4.png"
  plant_def.tiles[5] = "pot_with_soil_side.png^potted_farming_basil_4.png"
  plant_def.tiles[6] = "pot_with_soil_side.png^potted_farming_basil_4.png"
  plant_def.drop = {
    items = {
      {items = {"potted_farming:pot_with_soil"} },
      {items = {"potted_farming:".. plant_name }},
      {items = {"potted_farming:".. plant_name }, rarity = 3},
    },
  }
  plant_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
		if player:is_player() then
			local itemname = itemstack:get_name()
			if itemstack:is_empty() == false and itemname == "potted_farming:watering_can" then
        local max_uses = 5
        itemstack:add_wear(65535 / (max_uses - 1))
        local wear = itemstack:get_wear()
        if wear < 1 then
          --minetest.chat_send_player(player:get_player_name(), "wear "..wear)
          itemstack:replace("potted_farming:watering_can")
        end
        local n = math.random(3, 4)
        minetest.sound_play("water_splash-0".. n, {pos=pos, gain=1.2})
				minetest.set_node(pos, {name = "potted_farming:pot_with_".. plant_name .."_3"})
			end -- itemstack is watering_can
		end -- player is a player
    return itemstack
	end

  minetest.register_node("potted_farming:pot_with_" .. plant_name .."_4",  table.copy(plant_def) )

end

function potted_farming.register_wild_variant(plant_name, nodes, s, min, max)

  minetest.register_node("potted_farming:wild_".. plant_name , {
  	description = "Wild ".. plant_name,
  	paramtype = "light",
  	walkable = false,
  	drawtype = "plantlike",
  	paramtype2 = "facedir",
  	tiles = {"potted_farming_wild_".. plant_name ..".png"},
  	inventory_image = "potted_farming_wild_".. plant_name ..".png",
  	wield_image = "potted_farming_wild_".. plant_name ..".png",
  	groups = {snappy = 3, dig_immediate = 1, flammable = 2, plant = 1, flora = 1, attached_node = 1, not_in_creative_inventory = 1 },
  	sounds = default.node_sound_leaves_defaults(),
  	selection_box = {
  			type = "fixed",
  			fixed = { {-4 / 16, -0.5, -4 / 16, 4 / 16, 5 / 16, 4 / 16},	},
  	},
    drop =  {
  		items = {
  			{items = {"potted_farming:".. plant_name .." 2"}, rarity = 1},
  			{items = {"potted_farming:".. plant_name}, rarity = 2},
  			{items = {"potted_farming:".. plant_name .."_stem"}, rarity = 1},
  		}
  	},
  })

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
  	},
  	y_min = min,
  	y_max = max,
  	decoration = "potted_farming:wild_".. plant_name,
  })
end

--dofile(potted_farming.path .. "/plants.lua")
