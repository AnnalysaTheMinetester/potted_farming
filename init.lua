potted_farming = {}

local pf = potted_farming
pf.version = 3.9
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
  ["basil"] =     { {"default:dirt_with_grass", "default:dirt", "ethereal:praire_dirt", "ethereal:grove_dirt"},                            pf.plant_settings.basil.scale, 0,  250, 11, 15,},
  ["rosemary"] =  { {"default:dirt_with_coniferous_litter", "default:dirt_with_snow", "ethereal:gray_dirt", "ethereal:cold_dirt"},         pf.plant_settings.rosemary.scale, 10, 300, 10, 15,},
  ["sage"] =      { {"default:permafrost_with_moss", "default:permafrost_with_stones", "default:dirt_with_grass", "ethereal:cold_dirt"},   pf.plant_settings.sage.scale, 30, 400, 12, 15,},
  ["parsley"] =   { {"default:dirt_with_grass", "ethereal:praire_dirt", "default:dirt_with_dry_grass", "default:dry_dirt_with_dry_grass"}, pf.plant_settings.parsley.scale, 0,  300, 12, 15,},
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
  --name                sapling_name,            fruit_name,              leaves_name,
  ["lemon"]  = {"ethereal:lemon_tree_sapling",  "ethereal:lemon",   "ethereal_lemon_leaves.png",},
  ["orange"] = {"ethereal:orange_tree_sapling", "ethereal:orange",  "ethereal_orange_leaves.png",},
  ["apple"]  = {"default:sapling",              "default:apple",    "default_leaves.png",},
}

for k, v in pairs(pf.fruit_tree_list) do
  local ps = pf.plant_settings[k]
  if ps.definable and minetest.registered_items[v[2]] then
  	pf.register_fruit_tree(k, v[1], v[2], v[3])
  end
end


minetest.log("ACTION", "[MOD] " .. pf.modname .. " successfully loaded.")
