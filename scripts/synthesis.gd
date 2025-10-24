extends Control

@onready var item_controller = ItemController.new()
@onready var synth_controller: SynthesisController = SynthesisController.new()

#Recipe select screen
@onready var recipes_grid: Panel = %RecipesGrid
@onready var recipe_info: Panel = %RecipeInfoPanel
@onready var inventory_grid: Panel = %InventoryGrid
@onready var cursor: AnimatedSprite2D = %Cursor

#Ingredients Screen
@onready var invent_cursor: AnimatedSprite2D = %InventCursor
@onready var recipe_sprite: TextureRect = %RecipeSprite
@onready var recipe_name: Label = %RecipeName

func _ready() -> void:
	synth_controller.state = synth_controller.STATES.CHOOSE_RECIPE
	synth_controller.item_controller = item_controller
	synth_controller.update_ui.connect(_update_ui)
	synth_controller.toggle_ingredients_screen.connect(_toggle_ingredients_screen)
	add_child(synth_controller)
	_create_ui()
	_update_ui()
	
func _create_ui():
	var icons = item_controller.get_recipe_icons()
	var inventory_icons = item_controller.get_inventory_icons()
	for icon in icons:
		recipes_grid.add_child(icon)
	for icon in inventory_icons:
		inventory_grid.add_child(icon)
			
func _update_ui():
	#Clear the cards from the info panel so the new ones can be inserted
	for c in recipe_info.get_children():
		c.queue_free()
	
	recipe_info.add_child(item_controller.get_recipe_card())
	for icon in recipes_grid.get_children():
		if icon.name == item_controller.get_selected_id():
			icon.grab_focus()
			cursor.position = icon.position+Vector2(24,24)
	invent_cursor.position = synth_controller.get_ing_cursor_pos()+Vector2(40,40)
	recipe_name.text = item_controller.get_selected()['name']
	recipe_sprite.texture.region = Rect2(float(item_controller.get_selected()['region_x']), float(item_controller.get_selected()['region_y']),48.0,48.0)
func _toggle_ingredients_screen():
	%IngredientsScreen.visible = !%IngredientsScreen.visible
