class_name ItemController extends RefCounted

var recipe_icon_scene = load("res://scenes/recipe_icon.tscn")
var recipe_card_scene = load("res://scenes/recipe_info_card.tscn")
var registry: ItemRegistry
func _init() -> void:
	registry = ItemRegistry

func get_selected():
	return registry.selected_item
func get_items():
	return registry.get_items()
func get_recipe_icons():
	var i = 0
	var items = registry.get_items()
	var icons = []
	for key in items:
		if items[key]['category'] != 'material':
			var recipe_icon: Control = recipe_icon_scene.instantiate()
			recipe_icon.find_child("ItemSprite").texture.region = Rect2(float(items[key]['region_x']), float(items[key]['region_y']),48.0,48.0)
			recipe_icon.position = Vector2(i*48+16,16)
			i += 1
			recipe_icon.name = key
			icons.append(recipe_icon)
	return icons
func get_selected_id():
	return registry.selected_item['item_id']
func update_selected(cx,cy) -> bool:
	var index = cy*4 + cx
	return registry.set_selected(index) 
	
func get_recipe_card():
	var recipe = registry.get_recipe()
	var card = recipe_card_scene.instantiate()
	for item_id in recipe:
		var item = registry.get_item(item_id)
		var label = Label.new()
		label.text = item['name']
		card.find_child("IngredientsList").add_child(label)
	card.find_child("Name").text = registry.selected_item['name']
	card.find_child("Description").text = registry.selected_item['description']
	return card
	
func get_inventory_icons():
	var items = registry.get_items()
	var icons = []
	var i = 0
	for item in G.inventory:
		var recipe_icon: Control = recipe_icon_scene.instantiate()
		recipe_icon.find_child("ItemSprite").texture.region = Rect2(float(item['region_x']), float(item['region_y']),48.0,48.0)
		recipe_icon.name = item['id']
		recipe_icon.position = Vector2(i%15*48+16,floor(i/15)*48+16)
		icons.append(recipe_icon)
		i += 1
	return icons
