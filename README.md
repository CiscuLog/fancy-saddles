# fancy-saddles
A vanilla minecraft shader that allows datapack developers to add custom horse armor using dyed leather horse armor.

Latest version, adds the possibility to add custom wolf armor overlays using the same method, but for dyed wolf armor. This means it's not possible to completely override the wolf armor texture, but the patterns that appear on it when the item has been dyed.

## How it works
This shader allows to expand the leather horse armor file in the x axis to add new custom horse armor textures that depend on the dye applied on the armor.

The pixel at (0,1) must remain ALWAYS white. It's used to set apart the leather horse armor from the rest of textures. Starting from the left, the first armor texture is the default leather horse armor. Retexturing it will apply the changes to the base leather horse armor.

The pixel at the position (n*64,0), starting with n = 0, of the texture file represents a tint color. The texture below it will be applied to the horse armor if it matches the dyed leather horse armor's color.

To add a new texture, simple expand the file in the x axis by 64 pixels and paste your texture in the new available space. Finally, color the pixel at (n*64,0) with the dye the armor must have for the new texture to be displayed.

NOTE: The color is stored as a decimal value in the in-game item. You'll need to convert it to hexadecimal in order to paint it on the texture file. There's multiple calculators on-line that do this for you, just google "dec to hex".

## For Wolf Armor
It's practically the same as horse armor, but with the following exception. The pixel at (0,1) must remain always BLACK, instead of white. It's used to set apart the wolf armor overlay from the rest of textures, as well as from leather horse armor.
