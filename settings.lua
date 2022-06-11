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
pf.plant_settings.basil.max_light = minetest.settings:get("basil_max_light") or 14

-- Rosemary
pf.plant_settings.rosemary = {}
pf.plant_settings.rosemary.definable = minetest.settings:get_bool("rosemary",         true)
pf.plant_settings.rosemary.scale     = minetest.settings:get("rosemary_scale")     or 0.0005
pf.plant_settings.rosemary.min_hight = minetest.settings:get("rosemary_min_hight") or 10
pf.plant_settings.rosemary.max_hight = minetest.settings:get("rosemary_max_hight") or 300
pf.plant_settings.rosemary.min_light = minetest.settings:get("rosemary_min_light") or 11
pf.plant_settings.rosemary.max_light = minetest.settings:get("rosemary_max_light") or 14

-- Sage
pf.plant_settings.sage = {}
pf.plant_settings.sage.definable = minetest.settings:get_bool("sage",         true)
pf.plant_settings.sage.scale     = minetest.settings:get("sage_scale")     or 0.0004
pf.plant_settings.sage.min_hight = minetest.settings:get("sage_min_hight") or 30
pf.plant_settings.sage.max_hight = minetest.settings:get("sage_max_hight") or 400
pf.plant_settings.sage.min_light = minetest.settings:get("sage_min_light") or 12
pf.plant_settings.sage.max_light = minetest.settings:get("sage_max_light") or 14

-- Parsley
pf.plant_settings.parsley = {}
pf.plant_settings.parsley.definable = minetest.settings:get_bool("parsley",         true)
pf.plant_settings.parsley.scale     = minetest.settings:get("parsley_scale")     or 0.0003
pf.plant_settings.parsley.min_hight = minetest.settings:get("parsley_min_hight") or 0
pf.plant_settings.parsley.max_hight = minetest.settings:get("parsley_max_hight") or 300
pf.plant_settings.parsley.min_light = minetest.settings:get("parsley_min_light") or 11
pf.plant_settings.parsley.max_light = minetest.settings:get("parsley_max_light") or 14

-- Mint
pf.plant_settings.mint = {}
pf.plant_settings.mint.definable = minetest.settings:get_bool("mint",         true)
pf.plant_settings.mint.scale     = minetest.settings:get("mint_scale")     or 0.0007
pf.plant_settings.mint.min_hight = minetest.settings:get("mint_min_hight") or 20
pf.plant_settings.mint.max_hight = minetest.settings:get("mint_max_hight") or 250
pf.plant_settings.mint.min_light = minetest.settings:get("mint_min_light") or 12
pf.plant_settings.mint.max_light = minetest.settings:get("mint_max_light") or 14

-- Oregano
pf.plant_settings.oregano = {}
pf.plant_settings.oregano.definable = minetest.settings:get_bool("oregano",         true)
pf.plant_settings.oregano.scale     = minetest.settings:get("oregano_scale")     or 0.0007
pf.plant_settings.oregano.min_hight = minetest.settings:get("oregano_min_hight") or 20
pf.plant_settings.oregano.max_hight = minetest.settings:get("oregano_max_hight") or 250
pf.plant_settings.oregano.min_light = minetest.settings:get("oregano_min_light") or 11
pf.plant_settings.oregano.max_light = minetest.settings:get("oregano_max_light") or 14

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
pf.plant_settings.lemon.min_light = minetest.settings:get("lemon_min_light") or 13
pf.plant_settings.lemon.max_light = minetest.settings:get("lemon_max_light") or 14

-- Orange Fruit Tree
pf.plant_settings.orange = {}
pf.plant_settings.orange.definable = minetest.settings:get_bool("orange",         true)
pf.plant_settings.orange.min_light = minetest.settings:get("orange_min_light") or 13
pf.plant_settings.orange.max_light = minetest.settings:get("orange_max_light") or 14

-- Apple Fruit Tree
pf.plant_settings.apple = {}
pf.plant_settings.apple.definable = minetest.settings:get_bool("apple",         true)
pf.plant_settings.apple.min_light = minetest.settings:get("apple_min_light") or 12
pf.plant_settings.apple.max_light = minetest.settings:get("apple_max_light") or 14

-- Cherry Fruit Tree
pf.plant_settings.cherry = {}
pf.plant_settings.cherry.definable = minetest.settings:get_bool("cherry",         true)
pf.plant_settings.cherry.min_light = minetest.settings:get("cherry_min_light") or 12
pf.plant_settings.cherry.max_light = minetest.settings:get("cherry_max_light") or 14

-- Plum Fruit Tree
pf.plant_settings.plum = {}
pf.plant_settings.plum.definable = minetest.settings:get_bool("plum",         true)
pf.plant_settings.plum.min_light = minetest.settings:get("plum_min_light") or 12
pf.plant_settings.plum.max_light = minetest.settings:get("plum_max_light") or 14

-- Pomegranate Fruit Tree
pf.plant_settings.pomegranate = {}
pf.plant_settings.pomegranate.definable = minetest.settings:get_bool("pomegranate",         true)
pf.plant_settings.pomegranate.min_light = minetest.settings:get("pomegranate_min_light") or 13
pf.plant_settings.pomegranate.max_light = minetest.settings:get("pomegranate_max_light") or 14

-- Banana Fruit Tree
pf.plant_settings.banana = {}
pf.plant_settings.banana.definable = minetest.settings:get_bool("banana",         true)
pf.plant_settings.banana.min_light = minetest.settings:get("banana_min_light") or 13
pf.plant_settings.banana.max_light = minetest.settings:get("banana_max_light") or 14

-- Replace with existing item
pf.plant_settings.support = {}
-- Rosemary
pf.plant_settings.support.rosemary = {}
pf.plant_settings.support.rosemary.can_swap = minetest.settings:get_bool("support_rosemary",        false)
pf.plant_settings.support.rosemary.itemname = minetest.settings:get("support_rosemary_itemname") or "cucina_vegana:rosemary"
-- Parsley
pf.plant_settings.support.parsley = {}
pf.plant_settings.support.parsley.can_swap = minetest.settings:get_bool("support_parsley",        false)
pf.plant_settings.support.parsley.itemname = minetest.settings:get("support_parsley_itemname") or "farming:parsley"
-- Mint
pf.plant_settings.support.mint = {}
pf.plant_settings.support.mint.can_swap = minetest.settings:get_bool("support_mint",        false)
pf.plant_settings.support.mint.itemname = minetest.settings:get("support_mint_itemname") or "farming:mint_leaf"
-- Lemon
pf.plant_settings.support.lemon = {}
pf.plant_settings.support.lemon.can_swap = minetest.settings:get_bool("support_lemon", false)
-- Orange
pf.plant_settings.support.orange = {}
pf.plant_settings.support.orange.can_swap = minetest.settings:get_bool("support_orange", false)
-- Apple
pf.plant_settings.support.apple = {}
pf.plant_settings.support.apple.can_swap = minetest.settings:get_bool("support_apple", false)
-- Cherry
pf.plant_settings.support.cherry = {}
pf.plant_settings.support.cherry.can_swap = minetest.settings:get_bool("support_cherry", true)
