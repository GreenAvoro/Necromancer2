extends Node

var items := {}
var recipes := {}
var selected_item

func _ready():
	load_items("res://resources/items.csv")
	selected_item = items['potion']

func load_items(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open items file: " + path)
		return
	
	# Skip header row
	var header = file.get_csv_line()
	
	# Read all item rows
	while !file.eof_reached():
		var line = file.get_csv_line()
		
		# Skip empty lines
		if line.size() < 2 or line[0] == "":
			continue
		
		var item = {
			"item_id": line[0],
			"name": line[1],
			"category": line[2],
			"region_x": line[3],
			"region_y": line[4],
			"description": line[5],
			"phys_power": line[6],
			"mag_power": line[7],
			"heal_power": line[8]
		}
		
		items[line[0]] = item
	
	file.close()
	print("Loaded %d items" % items.size())
	
	#Now load required_items based on the pivot table
	var ingredients_file = FileAccess.open("res://resources/recipe_pivot.csv", FileAccess.READ)
	if not ingredients_file:
		push_error("Could not open recipe_pivot.csv")
		return
	
	# Skip header
	ingredients_file.get_csv_line()
	
	while !ingredients_file.eof_reached():
		var line = ingredients_file.get_csv_line()
		if line.size() < 2:
			continue
		
		if not line[0] in recipes:
			recipes[line[0]] = [line[1]]
		else:
			recipes[line[0]].append(line[1])
	ingredients_file.close()
	print("Loaded %d recipes" % recipes.size())
func get_item(item_id: String):
	return items[item_id]
func get_items():
	return items
func get_recipe():
	if recipes.has(selected_item['item_id']):
		return recipes[selected_item['item_id']]
	return []
func set_selected(index):
	var i = 0
	for key in items:
		if items[key]['category'] != 'material':
			if i == index:
				selected_item = items[key]
				return true
			i += 1
	return false
