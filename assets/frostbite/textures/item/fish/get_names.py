import os
# works like trash
names = [name[:-4] for name in tuple(os.walk('assets/frostbite/textures/item/fish/'))[-1]]

print(names, sep=',\n')