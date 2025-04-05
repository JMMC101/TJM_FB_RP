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


if 1:
    items_pickaxes:list[str] = [
        'amethyst'
    ]


    gen(
        'assets/frostbite/models/item/tool/pickaxe/',
        items_pickaxes,
        'frostbite:item/tool/pickaxe/'
    )

if 1:
    items_swords:list[str] = [
        'wooden.shattered','wooden.baton','stone.healthy','stone.dagger','lightsaber','iron.longsword','iron.longsword.heavy'
    ]


    gen(
        'assets/frostbite/models/item/weapon/sword/',
        items_swords,
        'frostbite:item/weapon/sword/'
    )



if 1:
    items_elytra_pieces:list[str] = [
        '0','1','2','3','4','5','6','7','8'
    ]


    gen(
        'assets/frostbite/models/item/other/broken_elytra_part/',
        items_elytra_pieces,
        'frostbite:item/other/broken_elytra_part/'
    )




if 1:
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
        'assets/frostbite/textures/item/weapon/crossbow/broken/'
    )
    gen(
        'assets/frostbite/models/item/weapon/crossbow/minigun/',
        states_crossbow,
        'assets/frostbite/textures/item/weapon/crossbow/minigun/'
    )