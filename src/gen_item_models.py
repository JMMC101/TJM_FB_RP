from minecraft_model_generation.simple_parented import gen_basic_pareneted as gen

if 0:
    items_fiiiiiishhh:list[str] = [
        'angry', 'askri', 'blind', 'cassie', 'clownfish', 'dirt', 'fishaxe', 'gledder', 'goldfish', 'harry', 'ice', 'jm', 'obsidian', 'og', 'piranha', 'swordfish', 'tosanoide', 'transgender', 'tuna'
    ]


    gen(
        'assets/frostbite/models/item/fish/',
        items_fiiiiiishhh,
        'frostbite:item/fish/'
    )


if 0:
    items_pickaxes:list[str] = [
        'amethyst'
    ]


    gen(
        'assets/frostbite/models/item/tool/pickaxe/',
        items_pickaxes,
        'frostbite:item/tool/pickaxe/'
    )

if 0:
    items_swords:list[str] = [
        'wooden.shattered','wooden.baton','stone.healthy','stone.dagger','lightsaber','iron.longsword','iron.longsword.heavy'
    ]


    gen(
        'assets/frostbite/models/item/weapon/sword/',
        items_swords,
        'frostbite:item/weapon/sword/'
    )



if 0:
    states_crossbow:list[str] = [
        'standby',
        'pulling_0',
        'pulling_1',
        'pulling_2',
        'arrow',
    ]


    gen(
        'assets/frostbite/models/item/weapon/crossbow/broken/',
        states_crossbow,
        'frostbite:item/weapon/crossbow/broken/',
        parent_path='frostbite:item/weapon/crossbow/generic'
    )
    gen(
        'assets/frostbite/models/item/weapon/crossbow/minigun/',
        states_crossbow,
        'frostbite:item/weapon/crossbow/minigun/',
        parent_path='frostbite:item/weapon/crossbow/generic'
    )


if 1:
    horn_types:list[str] = [
        'copper',
        'copper_carved',
        #'emerald.standby',
        #'emerald.tooting',
        'golden',
        'birds_birds_birds'
    ]
    gen(
        'assets/frostbite/models/item/tool/horn/',
        horn_types,
        'frostbite:item/tool/horn/',
        parent_path='frostbite:item/tool/horn/generic'
    )