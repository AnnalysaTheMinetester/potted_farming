local lib = potted_farming
local S = lib.S


--[[
        **************************************************
        **                                              **
        **           is_acceptable_source               **
        **                                              **
        **************************************************
        need modname:itemname
--]]

function lib.is_acceptable_source (itemname)
    for i= 1, #lib.plant_list do
            local name = itemname:split(":")[2]
            if name == lib.plant_list[i][1] .. "_stem" then
                return true, lib.plant_list[i][1]

            end -- if name ==

    end -- for i
    return false, "no"

end -- lib.is_acceptable_source

--[[
        **************************************************
        **                                              **
        **                 check_light                  **
        **                                              **
        **************************************************
--]]

function lib.check_light(pos)
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


--[[
        **************************************************
        **                                              **
        **                register_abm                  **
        **            growing_potted_plant              **
        **                                              **
        **************************************************
--]]

function lib.register_abm(nodename, next_step_nodename, delay, percentage)
    minetest.register_abm({
        label = "growing_potted_plant_abm",
        nodenames = {nodename},
        --neighbors = {"default:air"}, --can be omitted
        interval = delay,
        chance = percentage,
        action = function(pos, node, active_object_count, active_object_count_wider)
        local nodepos = pos
        if(lib.check_light(nodepos)) then
            minetest.swap_node(nodepos, {name = next_step_nodename})

        end -- if(lib.check

                end, -- action =

  }) -- register_abm

end -- lib.register_abm

--[[
        **************************************************
        **                                              **
        **                plant_stem                    **
        **                                              **
        **************************************************
--]]

function lib.plant_stem(node_def, pointed_thing)
    if(pointed_thing.type == "node") then
        local node = minetest.get_node(minetest.get_pointed_thing_position(pointed_thing, under))

        if (node.name == lib.modname .. ":pot_with_soil") then
            minetest.set_node(pointed_thing.under, {name = node_def.nodename .. "_stem"})
            return true

        end -- if(node.name

    end -- if(pointed_thing

    return false -- pointed thing isn't a node

end -- lib.plant_stem

--[[
        **************************************************
        **                                              **
        **              register_plant                  **
        **                                              **
        **************************************************
        plant_name = "basil" or "rosemary" etc
--]]

function lib.register_plant(plant_name)
    local plant_desc =    plant_name:gsub("_", " "):gsub("(%a)(%a+)",
                        function(a, b)
                            return string.upper(a) .. string.lower(b)

                        end)


    -- HERB/LEAVES DEFINITION --
    local craftitem_def = {
        description = plant_desc,
        inventory_image = lib.modname .. "_".. plant_name ..".png",
        groups = {},
    }

    craftitem_def.groups["food_".. plant_name] = 1
    minetest.register_craftitem(lib.modname .. ":".. plant_name, table.copy(craftitem_def) )

    -- STEM DEFINITION --
    minetest.register_craftitem(lib.modname .. ":".. plant_name .."_stem", {
        description = plant_desc ..S(" Stem"),
        inventory_image = lib.modname .. "_".. plant_name .."_stem.png",
        groups = {stem = 1, flammable = 2,},
        --the planting mechanism is in the pot on_rightclick

    }) -- register_craftitem(


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

    } -- plant_def

    -- POTTED plant_name STAGE 1 : just planted, gives stem back in case of accidental planting -----------------------
    plant_def.tiles[3] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.tiles[4] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.tiles[5] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.tiles[6] = "pot_with_soil_side.png^" .. lib.modname .. "_".. plant_name .."_1.png"
    plant_def.drop = {
        items = {
            {items = {lib.modname .. ":pot_with_soil"} },
            {items = {lib.modname .. plant_name .."_stem"} },

            },

        } -- plant_def.drop

    minetest.register_node(lib.modname .. ":pot_with_".. plant_name .."_1",  table.copy(plant_def) )

    lib.register_abm(lib.modname .. ":pot_with_".. plant_name .."_1",
                              lib.modname .. ":pot_with_".. plant_name .."_2", 10, 20)

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

    lib.register_abm(lib.modname .. ":pot_with_".. plant_name .."_2",
                                    "potted_farming:pot_with_".. plant_name .."_3", 15, 25)

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
            if itemstack:is_empty() == true then

                local q = math.random(2, 4)                                                -- number of leaves taken
                local stem = math.random(1, 5)                                             -- chance of getting a stem

                local inv = player:get_inventory()
                if inv:room_for_item("main", lib.modname .. ":"..plant_name .." ".. q) then
                    inv:add_item("main", lib.modname .. ":".. plant_name .." ".. q)

                else
                    minetest.add_item(pos, lib.modname .. ":".. plant_name .." ".. q)

                end

                if stem == 1 then
                    if inv:room_for_item("main", lib.modname .. ":"..plant_name .."_stem") then
                        inv:add_item("main", lib.modname .. ":".. plant_name .."_stem")
                    else

                        minetest.add_item(pos, lib.modname .. ":".. plant_name .."_stem")

                    end -- if inv.room

                end -- if stem

                minetest.set_node(pos, {name = lib.modname .. ":pot_with_".. plant_name .."_2"})

            end -- itemstack empty

        end-- player is a player

        return itemstack

    end -- plant_def.on_rightclick

    minetest.register_node(lib.modname.. ":pot_with_".. plant_name .."_3",  table.copy(plant_def) )

    lib.register_abm(   lib.modname .. ":pot_with_".. plant_name .."_3",
                        lib.modname .. ":pot_with_".. plant_name .."_4", 30, 10)

    -- POTTED PLANT STAGE 4 : needs water, no stem, few leaves --------------------------------------------------------
    plant_def.tiles[3] = "pot_with_soil_side.png^potted_farming_basil_4.png"
    plant_def.tiles[4] = "pot_with_soil_side.png^potted_farming_basil_4.png"
    plant_def.tiles[5] = "pot_with_soil_side.png^potted_farming_basil_4.png"
    plant_def.tiles[6] = "pot_with_soil_side.png^potted_farming_basil_4.png"
    plant_def.drop = {
        items = {
            {items = {lib.modname .. ":pot_with_soil"} },
            {items = {lib.modname .. ":" .. plant_name }},
            {items = {lib.modname .. ":".. plant_name }, rarity = 3},

        }, -- items

    } -- plant_def.drop

    plant_def.on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        if player:is_player() then
        local itemname = itemstack:get_name()
        if itemstack:is_empty() == false and itemname == lib.modname .. ":watering_can" then
                local max_uses = 5
                itemstack:add_wear(65535 / (max_uses - 1))
                local wear = itemstack:get_wear()
                if wear < 1 then
                    --minetest.chat_send_player(player:get_player_name(), "wear "..wear)
                    itemstack:replace(lib.modname .. ":watering_can")

                end -- if wear

                local n = math.random(3, 4)
                minetest.sound_play("water_splash-0".. n, {pos=pos, gain=1.2})
                minetest.set_node(pos, {name = lib.modname .. ":pot_with_".. plant_name .."_3"})

        end -- itemstack is watering_can

        end -- player is a player
        return itemstack

	end -- plant_def.on_rightclick

    minetest.register_node(lib.modname .. ":pot_with_" .. plant_name .."_4",  table.copy(plant_def) )

end -- register_plant

function lib.register_wild_variant(plant_name, nodes, s, min, max)

    minetest.register_node(lib.modname .. ":wild_".. plant_name , {
    description = S("Wild ").. plant_name,
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
