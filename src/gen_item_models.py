from minecraft_model_generation.simple_parented import gen_basic_pareneted as gen


items_regular:list[str] = [
    'angry', 'askri', 'blind', 'cassie', 'clownfish', 'dirt', 'fishaxe', 'gledder', 'goldfish', 'harry', 'ice', 'jm', 'obsidian', 'og', 'piranha', 'swordfish', 'tosanoide', 'transgender', 'tuna'
]


gen(
    'assets/frostbite/models/item/fish/',
    items_regular,
    'frostbite:item/fish/'
)