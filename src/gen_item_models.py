from minecraft_model_generation.simple_parented import gen_basic_pareneted as gen


items_regular:list[str] = [
    'angry', 'askri', 'cassie', 'clownfish', 'dirt', 'fishaxe', 'get_names.py', 'gledder', 'goldfish', 'ice', 'jm', 'obsidian'
]


gen(
    'assets/frostbite/models/item/fish/',
    items_regular,
    'frostbite:item/fish/'
)