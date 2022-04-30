local pf = potted_farming
-- the or is to assure a value, there is a bug in mtv5 as per dev.mt which gives nil
-- the names are fine and there are no overlapping

-- Basil
pf.plant_settings.basil = {}
pf.plant_settings.basil.definable = minetest.settings:get_bool("basil",         true)
pf.plant_settings.basil.scale     = minetest.settings:get("basil_scale")     or 0.0003
pf.plant_settings.basil.min_hight = minetest.settings:get("basil_min_hight") or 0
pf.plant_settings.basil.max_hight = minetest.settings:get("basil_max_hight") or 250
pf.plant_settings.basil.min_light = minetest.settings:get("basil_min_light") or 11
pf.plant_settings.basil.max_light = minetest.settings:get("basil_max_light") or 15

-- Rosemary
pf.plant_settings.rosemary = {}
pf.plant_settings.rosemary.definable = minetest.settings:get_bool("rosemary",         true)
pf.plant_settings.rosemary.scale     = minetest.settings:get("rosemary_scale")     or 0.0005
pf.plant_settings.rosemary.min_hight = minetest.settings:get("rosemary_min_hight") or 10
pf.plant_settings.rosemary.max_hight = minetest.settings:get("rosemary_max_hight") or 300
pf.plant_settings.rosemary.min_light = minetest.settings:get("rosemary_min_light") or 11
pf.plant_settings.rosemary.max_light = minetest.settings:get("rosemary_max_light") or 15

-- Sage
pf.plant_settings.sage = {}
pf.plant_settings.sage.definable = minetest.settings:get_bool("sage",         true)
pf.plant_settings.sage.scale     = minetest.settings:get("sage_scale")     or 0.0004
pf.plant_settings.sage.min_hight = minetest.settings:get("sage_min_hight") or 30
pf.plant_settings.sage.max_hight = minetest.settings:get("sage_max_hight") or 400
pf.plant_settings.sage.min_light = minetest.settings:get("sage_min_light") or 12
pf.plant_settings.sage.max_light = minetest.settings:get("sage_max_light") or 15

-- Parsley
pf.plant_settings.parsley = {}
pf.plant_settings.parsley.definable = minetest.settings:get_bool("parsley",         true)
pf.plant_settings.parsley.scale     = minetest.settings:get("parsley_scale")     or 0.0003
pf.plant_settings.parsley.min_hight = minetest.settings:get("parsley_min_hight") or 0
pf.plant_settings.parsley.max_hight = minetest.settings:get("parsley_max_hight") or 300
pf.plant_settings.parsley.min_light = minetest.settings:get("parsley_min_light") or 12
pf.plant_settings.parsley.max_light = minetest.settings:get("parsley_max_light") or 15

-- Brown Mushroom
pf.plant_settings.brown = {}
pf.plant_settings.brown.definable = minetest.settings:get_bool("brown",         true)
pf.plant_settings.brown.min_light = minetest.settings:get("brown_min_light") or 1
pf.plant_settings.brown.max_light = minetest.settings:get("brown_max_light") or 5

-- Cantharellus Mushroom
pf.plant_settings.cantharellus = {}
pf.plant_settings.cantharellus.definable = minetest.settings:get_bool("cantharellus",         true)
pf.plant_settings.cantharellus.min_light = minetest.settings:get("cantharellus_min_light") or 1
pf.plant_settings.cantharellus.max_light = minetest.settings:get("cantharellus_max_light") or 7

-- Boletus Mushroom
pf.plant_settings.boletus = {}
pf.plant_settings.boletus.definable = minetest.settings:get_bool("boletus",         true)
pf.plant_settings.boletus.min_light = minetest.settings:get("boletus_min_light") or 0
pf.plant_settings.boletus.max_light = minetest.settings:get("boletus_max_light") or 5

-- Lemon Fruit Tree
pf.plant_settings.lemon = {}
pf.plant_settings.lemon.definable = minetest.settings:get_bool("lemon",         true)
pf.plant_settings.lemon.min_light = minetest.settings:get("lemon_min_light") or 12
pf.plant_settings.lemon.max_light = minetest.settings:get("lemon_max_light") or 15

-- Orange Fruit Tree
pf.plant_settings.orange = {}
pf.plant_settings.orange.definable = minetest.settings:get_bool("orange",         true)
pf.plant_settings.orange.min_light = minetest.settings:get("orange_min_light") or 12
pf.plant_settings.orange.max_light = minetest.settings:get("orange_max_light") or 15

-- Apple Fruit Tree
pf.plant_settings.apple = {}
pf.plant_settings.apple.definable = minetest.settings:get_bool("apple",         true)
pf.plant_settings.apple.min_light = minetest.settings:get("apple_min_light") or 12
pf.plant_settings.apple.max_light = minetest.settings:get("apple_max_light") or 15

-- Replace with existing item
pf.plant_settings.support = {}
-- Rosemary
pf.plant_settings.support.rosemary = {}
pf.plant_settings.support.rosemary.can_swap = minetest.settings:get_bool("support_rosemary",        false)
pf.plant_settings.support.rosemary.itemname = minetest.settings:get("support_rosemary_itemname") or "cucina_vegana:rosemary"
-- Parsley
pf.plant_settings.support.parsley = {}
pf.plant_settings.support.parsley.can_swap = minetest.settings:get_bool("support_rosemary",        false)
pf.plant_settings.support.parsley.itemname = minetest.settings:get("support_rosemary_itemname") or "farming:parsley"
-- Lemon
pf.plant_settings.support.lemon = {}
pf.plant_settings.support.lemon.can_swap = minetest.settings:get_bool("support_lemon", false)
-- Orange
pf.plant_settings.support.orange = {}
pf.plant_settings.support.orange.can_swap = minetest.settings:get_bool("support_orange", false)
-- Apple
pf.plant_settings.support.apple = {}
pf.plant_settings.support.apple.can_swap = minetest.settings:get_bool("support_apple", true)
