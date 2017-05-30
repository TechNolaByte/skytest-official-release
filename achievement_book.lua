local FORMNAME = "skytest:tos_fs"

local TOS = [[

------------------------Wood Age-------------------------
A new age dawns before you! You don't have anything to work with but this tree, so let's make the most of it!

>Expand The platform with wooden planks of any kind.
>Use any Crook on leaves to get saplings and a Silkworm.
>Craft a compressed Crook to get more saplings and Silkworms from leaves.
>Craft any Leaf collector to get those leaves that you just can't reach .
>Make Dirt by composting saplings, leaves, or most flowers and plants in any wooden Barrel.
>Infest leaves with a Silkworm.
>Use any Crook on Infested Leaves to get silk.
>Craft a Empty Sieve, silkmesh, mesh.
>Place empty sieve and use mesh on it to make a sieve.(sieve atleast 5 blocks)
>Craft and use a leaf press on any empty barrel to prepare it for pressing leaves.
>Press leaves or cactus in any wodden barrel with press to get water.
>Craft a wooden bucket.
>Craft and place one of every shelf/drawer to store your things.
>Craft Cobblestone from the pebbles that drop from sifting Dirt.
>Use a Hammer to turn Cobble into Gravel, Gravel into Sand and Sand into Dust.
>Sift 5 Gravel, 5 Sand, 5 dirt, and 5 Dust in a Sieve.
>Sift a growth crystal in a Sieve.
>Make Clay by putting Dust into a water filled Barrel.
>Craft and cook a Crucible.
>Create an infinate water source.
>Heat a Crucible with a Torch and insert Stones or Cobble to make Lava.
>Build and place a Level 1 Cobblestone generator.

------------------------Stone Age------------------------
Now that you have a good source of blocks it's time to expand, upgrade, and improve your island a bit!

>Build a second layer to your island atleast 5x5, below the level you started from.
>Make Obsidian with lava + water.
>Automate your Cobble generator with a Node breaker from pipeworks.
>Process sieve materials to obtain 20 ingots.
>Lose your achievement book and be forced to craft another one.
>Craft and place a Level 2 cobble gen
>Craft an advanced compost bin to save time making dirt

------------------------Farming Age----------------------
Time to fight back against this cold empty void and grow some things!

>Prepare a farming space for several crops.
>Craft and place a Growth crystal.
>Craft and place any Infused soil.
>Craft any hoe
>Use a Growth crystal to activate any 2 Infused soil.
>Start a food farm and a Infused soil farm.
>Craft and place 3 of each Infused soil.
>Craft and place any Super Infused soil.
>Craft and place 3 of each Super Infused soil.

------------------------Age of Exploration---------------
With the right tools you no longer have to be confined to your small island. Time to get out and stretch our legs! Try not to die...

>Die
>Craft a jetpack and manage to fly and land on your platform.
>Craft a pair o'wings and use them for smoother flight.
>Use an Angel Block and your ability to fly to start a new island somewhere else.
>Craft and use a node disrupter to break the game and get unobtain able items.
>Craft a Draxel.

------------------------Age Of Machines------------------
Your skill with technology is growing. Automation is key.

>Craft and place an Auto Sieve.
>Sieve 10 gravel, 10 sand, 10 dirt, 10 dust, and 10 growth crystals on an auto sieve.
>Automate turning Cobblestone into Gravel with a grinder(from technic) or a node breaker(from pipeworks).
>Set up a working technic machine grid/system.
>Automate crop harvesting with pipeworks constructers or node breakers and placers.
>Craft and place a DSU(Deep Storage Unit).


------------------------Age Of Power---------------------
Once you start on this path, how much is enough?

>Create and use a reactor from the Technic Mod.
>Cause a reactor to meltdown.

------------------------Age Of Insanity------------------
At last you've got your production going and your machines are hard at work. It's time to REALLY have some fun!

>Fill DSU (deep storage unit) with anything.
>Fill a 16x16 area completely with Triple Compressed cobble.(Ssundee)
>Fill a 16x16 area completely with Triple Compressed dirt.(Mr.Crainer)
>Craft and use a node enhancer to break the game and double items/blocks.

------------------------Most Important-------------------

>Send money me all of your money

------------------------The End--------------------------

You have completed 100% of the achieventnts listed, remember to test yourself. What achievements can you come up with?
]]
local TOS_list = { } -- list[paragraph][word]
local par_wordlist
par_wordlist = { }
for line in TOS:gmatch("(.-)\n") do
	if line == "" then
		table.insert(TOS_list, par_wordlist)
		par_wordlist = { }
	end
	for word in line:gmatch("[%w][%w'_-]*") do
		table.insert(par_wordlist, word)
	end
end

local ord_suffix = { "st", "nd", "rd", [11] = "th", [12] = "th", [13] = "th" }
local function make_formspec()
	local fs = { "size[9,8]" }
	table.insert(fs, "textarea[0.5,0.5;8,7;TOS;Achievements;"..TOS.."]")
	return table.concat(fs)
end
minetest.register_craftitem("skytest:achievement_book", {
	description = "Achievement book",
	_doc_items_longdesc = "Allows you to access the achievements.",
	_doc_items_usagehelp = "Wield it, then leftclick to access the achievements.",
	_doc_items_hidden = false,
	stack_max = 1,
	inventory_image = "achievement_book.png",
	wield_image = "achievement_book.png",
	wield_scale = { x=1, y=1, z=2.25 },
	on_use = function(itemstack, user)
minetest.show_formspec(user:get_player_name(), FORMNAME, make_formspec())
	end,
	groups = { book=1 },
})
	minetest.register_craft({
		output = "skytest:achievement_book",
		recipe = {
			{ "default:book" },
			{ "" },
			{ "default:book" },
		}
	})


minetest.register_craft({
	type = "fuel",
	recipe = "skytest:achievement_book",
	burntime = 6,
})
minetest.register_privilege("tos_accepted", "TOS Accepted")