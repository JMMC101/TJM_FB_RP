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

if 1:
    items_elytra_pieces:list[str] = [
        '0','1','2','3','4','5','6','7','8'
    ]


    gen(
        'assets/frostbite/items/other/broken_elytra_part/',
        items_elytra_pieces,
        'frostbite:item/other/broken_elytra_part/'
    )
