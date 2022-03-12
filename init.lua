potted_farming = {}

local pf = potted_farming
pf.version = 1.0
pf.modname = minetest.get_current_modname()
pf.path = minetest.get_modpath(pf.modname)

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
--dofile(pf.path .. "/plants.lua")

pf.plant_list = {
-- name 			found on																	 scale	y min max
	{"basil", {"default:dirt_with_grass", "default:dirt"}, 0.0003, 0, 250},

} -- parsley, sage, rosemary, mint, cinnamon?


--potted_farming.register_plant("basil")
for i=1, #pf.plant_list do
	pf.register_plant(pf.plant_list[i][1])
	pf.register_wild_variant(pf.plant_list[i][1], pf.plant_list[i][2],
		pf.plant_list[i][3], pf.plant_list[i][4], pf.plant_list[i][5] )
end

minetest.log("ACTION", "[MOD] " .. pf.modname .. " successfully loaded.")
