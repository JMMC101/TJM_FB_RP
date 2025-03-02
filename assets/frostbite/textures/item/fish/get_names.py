import os

names = [name[:-4] for name in tuple(os.walk('assets/frostbite/textures/item/fish/'))[-1][-1]]
names.remove('get_name')

print(names, sep=',\n')