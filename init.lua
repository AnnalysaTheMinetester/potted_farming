potted_farming = {}

local pf = potted_farming
pf.version = 4.0
pf.modname = minetest.get_current_modname()
pf.path = minetest.get_modpath(pf.modname)
pf.plant_settings = {}
pf.watering_can_max_uses = 5

local S

if(minetest.get_translator) then
   S = minetest.get_translator(pf.modname)

else
    S = function ( s ) return s end

end

pf.S = S

dofile(pf.path .. "/settings.lua")
dofile(pf.path .. "/lib.lua")
dofile(pf.path .. "/nodes.lua")
dofile(pf.path .. "/items.lua")
dofile(pf.path .. "/tools.lua")
dofile(pf.path .. "/recipes.lua")

pf.plant_list = {
-- name,          wild parameters: place_on (found on)
  ["basil"] =     { { "default:dirt_with_grass",
                      "default:dirt",
                      "ethereal:praire_dirt",
                      "ethereal:grove_dirt",
                    },},
  ["rosemary"] =  { { "default:dirt_with_coniferous_litter",
                      "default:dirt_with_snow",
                      "ethereal:gray_dirt",
                      "ethereal:cold_dirt",
                    },},
  ["sage"] =      { { "default:permafrost_with_moss",
                      "default:permafrost_with_stones",
                      "default:dirt_with_grass",
                      "ethereal:cold_dirt",
                    },},
  ["parsley"] =   { { "default:dirt_with_grass",
                      "ethereal:praire_dirt",
                      "default:dirt_with_dry_grass",
                      "default:dry_dirt_with_dry_grass",
                    },},
}

for k, v in pairs(pf.plant_list) do
  local ps = pf.plant_settings[k]
  if ps.definable then
  	pf.register_plant(k)
  	pf.register_wild_variant(k, v[1], ps.scale, ps.min_hight, ps.max_hight )
  end
end

pf.mushroom_list = {
  --name              full_mushroom_name
  ["brown"]        = {"flowers:mushroom_brown",},
  ["cantharellus"] = {"herbs:mushroom_cantharellus",},
  ["boletus"]      = {"herbs:mushroom_boletus",},
}

for k, v in pairs(pf.mushroom_list) do
  local ps = pf.plant_settings[k]
  if ps.definable and minetest.registered_items[v[1]] then
  	pf.register_mushroom(k, v[1])
  end
end

pf.fruit_tree_list = {
  --name         sapling_name, fruit_name, leaves_name,
  ["lemon"]  = {"ethereal:lemon_tree_sapling",
                "ethereal:lemon",
                "ethereal_lemon_leaves.png",
               },
  ["orange"] = {"ethereal:orange_tree_sapling",
                "ethereal:orange",
                "ethereal_orange_leaves.png",
               },
  ["apple"]  = {"default:sapling",
                "default:apple",
                "default_leaves.png",
               },
}

local fruit_tree_alternatives = {
  --name         sapling_name, fruit_name, leaves_name,
  ["lemon"]  = { "lemontree",
                { "lemontree:sapling",
                  "lemontree:lemon",
                  "lemontree_leaves.png",
                },
               },
  ["orange"] = { "clementinetree",
                { "clementinetree:sapling",
                  "clementinetree:clementine",
                  "clementinetree_leaves.png",
                },
               },
   ["apple"] = { "moretrees",
                {"moretrees:apple_tree_sapling",
                 "default:apple",
                 "moretrees_apple_tree_leaves.png",
                },
               },
}

if minetest.get_modpath("ethereal") then
    -- can items be swapped?
    for k,v in pairs(pf.fruit_tree_list) do
      s = pf.plant_settings.support

      if s[k] ~= nil and s[k].can_swap == true then

        local f = fruit_tree_alternatives[k]
        if minetest.get_modpath(f[1]) then
          pf.fruit_tree_list[k] = f[2]
        end -- if the mod is present

      end -- if fruit is in the main list, and can swap

    end -- for fruit_tree_list


end-- if ethereal is present

for k, v in pairs(pf.fruit_tree_list) do
  local ps = pf.plant_settings[k]
  -- i still need to check if the item exists, just in case.
  if ps.definable and minetest.registered_items[v[2]] then
  	pf.register_fruit_tree(k, v[1], v[2], v[3])
  end
end

minetest.log("ACTION", "[MOD] " .. pf.modname .. " successfully loaded.")
