class_name SynthesisController extends Node

enum STATES {CHOOSE_RECIPE, CHOOSE_INGREDIENTS, WAIT_ANIMATION}
var state = STATES.CHOOSE_RECIPE
var used_ingredients = []

var recipe_cx = 0
var recipe_cy = 0

var ing_c = 0

var item_controller = null

signal update_ui
signal toggle_ingredients_screen

func _process(delta: float) -> void:
	var cx = 0
	var cy = 0
	var select = false
	var back = false
	
	if Input.is_action_just_pressed("left"):
		cx = -1
	elif  Input.is_action_just_pressed("right"):
		cx = 1
	elif Input.is_action_just_pressed("up"):
		cy = -1
	elif Input.is_action_just_pressed("down"):
		cy = 1
	elif Input.is_action_just_pressed("select"):
		select = true
	elif Input.is_action_just_pressed("back"):
		back = true
		
	#If there was a cursor change then process the change
	if cx != 0 or cy != 0:
		if state == STATES.CHOOSE_RECIPE:
			recipe_cursor_change(cx,cy)
		elif state == STATES.CHOOSE_INGREDIENTS:
			ingredients_cursor_change(cx,cy)
			
	#Check what the user tried to select
	if select:
		if state == STATES.CHOOSE_RECIPE:
			select_recipe()
		elif state == STATES.CHOOSE_INGREDIENTS:
			select_ingredient()
	
	if back:
		if state == STATES.CHOOSE_RECIPE:
			get_tree().change_scene_to_file("res://scenes/cottage.tscn")
		elif state == STATES.CHOOSE_INGREDIENTS:
			toggle_ingredients_screen.emit()
			state = STATES.CHOOSE_RECIPE
			ing_c = 0
		
func recipe_cursor_change(cx,cy):
	
	var can_select = item_controller.update_selected(recipe_cx + cx, recipe_cy + cy)
	if can_select:
		recipe_cx += cx
		recipe_cy += cy
		update_ui.emit()
		

func ingredients_cursor_change(cx,cy):
	var old_ing_c = ing_c
	ing_c = ing_c + cx
	ing_c = ing_c + cy * 15
	
	if ing_c >= G.inventory.size() or ing_c < 0:
		ing_c = old_ing_c
		return
	update_ui.emit()
func get_ing_cursor_pos():
	return Vector2(ing_c%15 * 48, floor(ing_c/15) * 48)
func select_ingredient():
	var recipe_copy = item_controller.get_recipe()
	
func select_recipe():
	state = STATES.CHOOSE_INGREDIENTS
	toggle_ingredients_screen.emit()
	
	
	
