extends Node

var properties := {}

func _ready():
	load_properties("res://resources/properties.csv")

func load_properties(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open property file: " + path)
		return
	
	# Skip header row
	var header = file.get_csv_line()
	
	# Read all property rows
	while !file.eof_reached():
		var line = file.get_csv_line()
		
		# Skip empty lines
		if line.size() < 2 or line[0] == "":
			continue
		
		var prop = {
			"property_name": line[0],
			"value": float(line[1]),
			"target_attribute": line[2],
			"rarity": int(line[3])
		}
		
		properties[line[0]] = prop
	
	file.close()
	print("Loaded %d properties" % properties.size())

func get_property(property_name: String) -> Dictionary:
	if properties.has(property_name):
		return properties[property_name]
	push_warning("Property not found: " + property_name)
	return {}

func get_value(property_name: String) -> float:
	if properties.has(property_name):
		return properties[property_name]["value"]
	return 0.0

# Choose a random value between 1 - 100. If the prop rarity is greater than the value then it's added
# to a list to be choosen at random from
func get_random_property():
	var random = randf_range(1,100)
	var names_to_select = []
	for key in properties:
		if properties[key]['rarity'] >= random:
			names_to_select.push_back(properties[key])
	return names_to_select[randi_range(0,names_to_select.size()-1)]
