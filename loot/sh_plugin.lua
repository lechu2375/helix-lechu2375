PLUGIN.name = "Loot"
PLUGIN.author =  "Lechu2375"

ix.util.Include("sv_loot.lua")



ix.config.Add("ItemSpawnerInterval", 10, "Time between spawning random item in seconds.", RefreshItemSpawnerTimer, {
	data = {min = 1, max = 10000},
	category = "Item Spawner"
})
