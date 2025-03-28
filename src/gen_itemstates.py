from minecraft_model_generation.simple_itemstate import gen_basic_itemstates as gen

if 0:
    items_fish:list[str] = [
        'angry', 'askri', 'blind', 'cassie', 'clownfish', 'dirt', 'fishaxe', 'gledder', 'goldfish', 'harry', 'ice', 'jm', 'obsidian', 'og', 'piranha', 'swordfish', 'tosanoide', 'transgender', 'tuna'
    ]

    gen(
        'assets/frostbite/items/fish/',
        items_fish,
        'frostbite:item/fish/'
    )

if 0:
    items_picamds:list[str] = [
        'amethyst'
    ]

    gen(
        'assets/frostbite/items/tool/pickaxe/',
        items_picamds,
        'frostbite:item/tool/pickaxe/'
    )

if 1:
    items_picamds:list[str] = [
        'amethyst'
    ]

    gen(
        'assets/frostbite/items/tool/pickaxe/',
        items_picamds,
        'frostbite:item/tool/pickaxe/'
    )

if 1:
    items_swords:list[str] = [
        'wooden.shattered','wooden.baton','stone.healthy','stone.dagger','lightsaber','iron.longsword','iron.longsword.heavy'
    ]


    gen(
        'assets/frostbite/items/weapon/sword/',
        items_swords,
        'frostbite:item/weapon/sword/'
    )