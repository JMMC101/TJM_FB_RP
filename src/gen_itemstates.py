from minecraft_model_generation.simple_itemstate import gen_basic_itemstates as gen


items_fish:list[str] = [
    'angry', 'askri', 'cassie', 'clownfish', 'dirt', 'fishaxe', 'get_names.py', 'gledder', 'goldfish', 'ice', 'jm', 'obsidian'
]

gen(
    'assets/frostbite/items/fish/',
    items_fish,
    'frostbite:item/fish/'
)