potted_farming = {}

local pf = potted_farming
pf.version = 3.0
pf.modname = minetest.get_current_modname()
pf.path = minetest.get_modpath(pf.modname)
pf.watering_can_max_uses = 5

local S

if(minetest.get_translator) then
   S = minetest.get_translator(pf.modname)

else
    S = function ( s ) return s end

end

pf.S = S

dofile(pf.path .. "/lib.lua")
dofile(pf.path .. "/nodes.lua")
dofile(pf.path .. "/items.lua")
dofile(pf.path .. "/tools.lua")
dofile(pf.path .. "/recipes.lua")

pf.plant_list = {
-- name,          definable, wild parameters: place_on (found on),                                                     scale, y min max; min max lightlevel to grow
  ["basil"] =     {true,   {"default:dirt_with_grass", "default:dirt", "ethereal:praire_dirt", "ethereal:grove:dirt"},  0.0003, 0, 250, 11, 15},
  ["rosemary"] =  {true,   {"default:dirt_with_coniferous_litter", "default:dirt_with_snow", "ethereal:gray_dirt"},     0.0005, 10, 300, 10, 15},
  ["sage"] =      {false,  {"default:permafrost_with_moss", "default:dirt_with_grass", "ethereal:cold_dirt"},           0.0004, 0, 250, 12, 15},

}

for k, v in pairs(pf.plant_list) do
  if v[1] then
  	pf.register_plant(k)
  	pf.register_wild_variant(k, v[2], v[3], v[4], v[5] )
  end
end

pf.mushroom_list = {
  --name      definable, full_mushroom_name, min max lightlevel to grow
  ["brown"]        = {true, "flowers:mushroom_brown",       0, 11},
  ["cantharellus"] = {true, "herbs:mushroom_cantharellus",  0, 11},
  ["boletus"]      = {false, "herbs:mushroom_boletus",      0, 12},
}

for k, v in pairs(pf.mushroom_list) do
  if v[1] and minetest.registered_items[v[2]] then
  	pf.register_mushroom(k, v[2])
  end
end

pf.fruit_tree_list = {
  --name      definable,       sapling_name,            fruit_name,              leaves_name,           min max lightlevel to grow
  ["lemon"]  = {true, "ethereal:lemon_tree_sapling",  "ethereal:lemon",   "ethereal_lemon_leaves.png",  12, 15},
  ["orange"] = {true, "ethereal:orange_tree_sapling", "ethereal:orange",  "ethereal_orange_leaves.png", 12, 15},
  ["apple"]  = {true, "default:sapling",              "default:apple",    "default_leaves.png",         12, 15},
}

for k, v in pairs(pf.fruit_tree_list) do
  if v[1] and minetest.registered_items[v[2]] then
  	pf.register_fruit_tree(k, v[2], v[3], v[4])
  end
end

minetest.log("ACTION", "[MOD] " .. pf.modname .. " successfully loaded.")
