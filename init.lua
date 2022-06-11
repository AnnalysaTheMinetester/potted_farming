potted_farming = {}

local pf = potted_farming
pf.version = 4.2
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
  ["sage"] =      { { "default:dirt_with_grass",
                      "default:permafrost_with_moss",
                      "default:permafrost_with_stones",
                      "ethereal:cold_dirt",
                    },},
  ["parsley"] =   { { "default:dirt_with_grass",
                      "default:dirt_with_dry_grass",
                      "default:dry_dirt_with_dry_grass",
                      "ethereal:praire_dirt",
                    },},
  ["mint"]    =   { { "default:dirt_with_grass",
                      "default:dirt_with_snow",
                      "ethereal:praire_dirt",
                      "ethereal:jungle_dirt",
                    },},
  ["oregano"] =   { { "default:dirt_with_grass",
                      "default:dirt_with_dry_grass",
                      "ethereal:praire_dirt",
                      "ethereal:jungle_dirt",
                    },},
}

for k, v in pairs(pf.plant_list) do
  local ps = pf.plant_settings[k]
  if ps ~= nil and ps.definable then
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
  if ps ~= nil and ps.definable and minetest.registered_items[v[1]] then
  	pf.register_mushroom(k, v[1])
  end
end

local shrub = pf.modname ..":pot_with_shrub"
local b_shrub = pf.modname ..":pot_with_plantain"

pf.fruit_tree_list = {
  --name         sapling_name, fruit_name, leaves_name,
  ["lemon"] =       {"ethereal:lemon_tree_sapling",
                     "ethereal:lemon",
                     "ethereal_lemon_leaves.png",
                     shrub,
                    },
  ["orange"] =      {"ethereal:orange_tree_sapling",
                     "ethereal:orange",
                     "ethereal_orange_leaves.png",
                     shrub,
                    },
  ["apple"] =       {"default:sapling",
                     "default:apple",
                     "default_leaves.png",
                     shrub,
                    },
  ["cherry"] =      {"cherrytree:sapling",
                     "cherrytree:cherries",
                     "cherrytree_leaves.png",
                     shrub,
                    },
  ["plum"] =        {"plumtree:sapling",
                     "plumtree:plum",
                     "plumtree_leaves.png",
                     shrub,
                    },
  ["pomegranate"] = {"pomegranate:sapling",
                     "pomegranate:pomegranate",
                     "pomegranate_leaves.png",
                     shrub,
                    },
  ["banana"] =      {"ethereal:banana_tree_sapling",
                     "ethereal:banana",
                     "ethereal_banana_leaf.png",
                     b_shrub,
                    },
}

local fruit_tree_alternatives = {
  --name         sapling_name, fruit_name, leaves_name,
  ["lemon"]  = {  "lemontree",
                { "lemontree:sapling",
                  "lemontree:lemon",
                  "lemontree_leaves.png",
                  shrub,
                },
               },
  ["orange"] = {  "clementinetree",
                { "clementinetree:sapling",
                  "clementinetree:clementine",
                  "clementinetree_leaves.png",
                  shrub,
                },
               },
  ["apple"] =  {  "moretrees",
                { "moretrees:apple_tree_sapling",
                  "default:apple",
                  "moretrees_apple_tree_leaves.png^nature_blossom.png",
                  shrub,
                },
               },
  ["cherry"] = {  "cherrytree",
                { "cherrytree:sapling",
                  "cherrytree:cherries",
                  "cherrytree_blossom_leaves.png",
                  shrub,
                },
               },
}

-- can items be swapped? need to check and modify fruit_tree_list before register
for k,v in pairs(pf.fruit_tree_list) do
  local modname = v[1]:split(":")[1]

  if minetest.get_modpath(modname) then

    local s = pf.plant_settings.support
    if s[k] ~= nil and s[k].can_swap == true then

      local f = fruit_tree_alternatives[k]
      if minetest.get_modpath(f[1]) then
        pf.fruit_tree_list[k] = f[2]
      end -- if the alternative mod is present

    end -- if fruit is in the main list, and can swap

  end-- if mod with fruit is present

end -- for fruit_tree_list

for k, v in pairs(pf.fruit_tree_list) do
  local ps = pf.plant_settings[k]
  -- i still need to check if the item exists, just in case.
  if ps ~= nil and ps.definable == true and minetest.registered_items[v[2]] then
  	pf.register_fruit_tree(k, v[1], v[2], v[3], v[4])
  end
end

minetest.log("ACTION", "[MOD] " .. pf.modname .. " successfully loaded.")
