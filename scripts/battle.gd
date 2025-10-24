extends Node2D

enum player_states {WAITING, SELECTING_OPTION, SELECTING_ENEMY,SELECTING_ITEM}
var enemies = []
var turn_order = []
var allies = []
var option_cursor = 0
var enemy_select_cursor = 0
var item_cursor = Vector2.ZERO
var player_state = player_states.WAITING
var current_turn = false
var using_item = null

var enemy_positions = [
	Vector2(896,256),
	Vector2(840,320),
	Vector2(896,400)
]

var ally_positions = [
	Vector2(240,320),
	Vector2(200,256),
	Vector2(200,400)
]

var enemy_scene = preload("res://scenes/enemy.tscn")
var ally_scene = preload("res://scenes/ally.tscn")

@onready var battle_items:BattleItems = $BattleCanvas/BattleItems
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Load allies
	#TODO load ally state into this scene.
	var ally_pos_index = 1
	for a in G.allies:
		var ally:Ally = ally_scene.instantiate()
		ally.setup(a['name'],a['hp'], a['max_hp'], a['attack_power'])
		allies.append(ally)
		ally.finish_attack.connect(_finish_attack)
		ally.die.connect(_die)
		ally.took_damage.connect(refresh_ui)
		ally.position = ally_positions[ally_pos_index]
		ally_pos_index += 1
		add_child(ally)
		
		
	#Load Lulu into allies
	var lulu:Ally = ally_scene.instantiate()
	lulu.setup("Lulu", G.player_health, G.player_max_health, G.player_attack_power)
	allies.append(lulu)
	lulu.finish_attack.connect(_finish_attack)
	lulu.die.connect(_die)
	lulu.took_damage.connect(refresh_ui)
	lulu.position = ally_positions[0]
	add_child(lulu)
	
	#Load enemies
	for i in range(0,G.rng.randi_range(1,3)):
		var enemy:Enemy = enemy_scene.instantiate()
		enemy.setup(G.enemies[G.levels[G.current_level].enemies[G.rng.randi_range(0, len(G.levels[G.current_level].enemies) -1)]])
		enemies.append(enemy)
		enemy.position = enemy_positions[i]
		enemy.finish_attack.connect(_finish_attack)
		enemy.die.connect(_die)
		add_child(enemy)
	
	turn_order.append_array(allies)
	turn_order.append_array(enemies)
	turn_order.shuffle()
	refresh_ui()
	move_cursor()
	begin_new_turn()
	

func _process(delta: float) -> void:
	if player_state == player_states.SELECTING_OPTION:
		if Input.is_action_just_pressed("down"):
			option_cursor += 1
			if option_cursor > 3:
				option_cursor = 0
			move_cursor()
		elif Input.is_action_just_pressed("up"):
			option_cursor -= 1
			if option_cursor < 0:
				option_cursor = 3
			move_cursor()
		elif Input.is_action_just_pressed("select"):
			#Basic Attack
			if option_cursor == 0:
				player_state = player_states.SELECTING_ENEMY
				hover_enemies()
			#Select Item
			elif option_cursor ==1:
				player_state = player_states.SELECTING_ITEM
				battle_items.show()
			#Escape
			elif option_cursor == 3:
				player_state = player_states.WAITING
				clean_up_battle()

	elif player_state == player_states.SELECTING_ENEMY:
		if Input.is_action_just_pressed("down"):
			enemy_select_cursor += 1
			if enemy_select_cursor > len(enemies)-1:
				enemy_select_cursor = 0
			hover_enemies()
		elif Input.is_action_just_pressed("up"):
			enemy_select_cursor -= 1
			if enemy_select_cursor < 0:
				enemy_select_cursor = len(enemies)-1
			hover_enemies()
		elif Input.is_action_just_pressed("back"):
			if using_item:
				player_state = player_states.SELECTING_ITEM
				using_item = null
			else:
				player_state = player_states.SELECTING_OPTION
			enemy_select_cursor = 0
			for e in enemies:
				e.hover(false)
		elif Input.is_action_just_pressed("select"):
			player_state = player_states.WAITING
			if using_item:
				current_turn.use_item(using_item, enemies[enemy_select_cursor])
				G.basket.erase(using_item)
				using_item = null
				battle_items.cursor_reset()
				battle_items.hide()
			else:
				current_turn.attack(enemies[enemy_select_cursor])
			enemy_select_cursor = 0
			for e in enemies:
				e.hover(false)
			$BattleCanvas/OptionPanel.hide()
	elif player_state == player_states.SELECTING_ITEM:
		if Input.is_action_just_pressed("back"):
			battle_items.hide()
			battle_items.cursor_reset()
			player_state = player_states.SELECTING_OPTION
		elif Input.is_action_just_pressed("left"): battle_items.cursor_left()
		elif Input.is_action_just_pressed("right"): battle_items.cursor_right()
		elif Input.is_action_just_pressed("up"): battle_items.cursor_up()
		elif Input.is_action_just_pressed("down"): battle_items.cursor_down()
		elif Input.is_action_just_pressed("select"):
			using_item  = battle_items.select_item()
			if using_item:
				hover_enemies()
				player_state = player_states.SELECTING_ENEMY
	
func begin_new_turn():
	for info in $BattleCanvas/AllyPanel.get_children():
		#Hardcoded ogiginal position of the ally info
		info.position.x = 24
	if len(enemies) <= 0:
		clean_up_battle()
	if current_turn:
		turn_order.append(current_turn)
	current_turn = turn_order.pop_front()
	if current_turn is Ally:
		player_state = player_states.SELECTING_OPTION
		$BattleCanvas/OptionPanel.show()
		for i in range(0, len(allies)):
			if current_turn == allies[i]:
				#anim_player.play("player_active_"+str(i+1))
				$BattleCanvas/AllyPanel.get_children()[i].position.x = 54
	elif current_turn is Enemy:
		current_turn.attack()

func move_cursor():
	var index = 0
	for o in find_children("Cursor"):
		o.visible = false
		if index == option_cursor:
			o.visible = true
		index += 1
func hover_enemies():
	var index = 0
	for e in enemies:
		e.hover(false)
		if index == enemy_select_cursor:
			e.hover(true)
		index += 1
		
func _finish_attack():
	begin_new_turn()
func _die(entity):
	if entity is Enemy:
		enemies.erase(entity)
		turn_order.erase(entity)
		entity.queue_free()
		
func refresh_ui():
	for node in find_children("AllyInfo*"):
		node.hide()
	for i in range(0, len(allies)):
		var a = allies[i]
		var node = find_child("AllyInfo"+str(i + 1))
		node.show()
		node.find_child("Label").text = a.ally_name
		node.find_child("ProgressBar").max_value = a.max_hp
		node.find_child("ProgressBar").value = a.hp
		
		
func clean_up_battle():
	for a in allies:
		if a.ally_name == "Lulu":
			G.player_health = a.hp
		elif a.ally_name == "Sarah":
			G.sarah['hp'] = a.hp
	get_tree().change_scene_to_file(G.levels[G.current_level].scene)
