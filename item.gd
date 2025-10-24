class_name Item extends Node

var id:String = ""
var item_name: String = ""
var region_x = 0
var region_y = 0
var category = ""
#Stats
var quality = 0
var physical_power = 0
var magic_power = 0
var healing_power = 0

var traits = []

func setup(i_name):
	var data = ItemRegistry.get_item(i_name)
	quality = G.rng.randi_range(1,20)
	id = data["item_id"]
	item_name = data["name"]
	region_x = data["region_x"]
	region_y = data["region_y"]
	physical_power = data["phys_power"]
	magic_power = data["mag_power"]
	healing_power = data["heal_power"]
	
	for t in range(0, G.rng.randi_range(1,3)):
		traits.append(PropertyRegistry.get_random_property())
func deal_damage():
	return {
		"physical_power": physical_power * (quality/100+1),
		"magic_power": magic_power * (quality/100+1)
		}
		
func use_item():
	if healing_power > 0:
		G.player_health += healing_power
		if G.player_health > G.player_max_health:
			G.player_health = G.player_max_health
		return true
	return false
