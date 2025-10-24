class_name Enemy extends Node2D

var hp:int = 1
var max_hp:int = 1
var enemy_name:String = "Default"
var attack_power:int = 1
var physical_defense:int = 1
var magic_defense:int = 1
var frames:SpriteFrames = null
var starting_pos = Vector2.ZERO
var target = false
signal finish_attack

signal die

func setup(data):
	hp = data.hp
	max_hp = data.hp
	enemy_name = data.name
	attack_power = data.attack_power
	physical_defense = data.physical_defense
	magic_defense = data.magic_defense
	frames = data.sprite
	

func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = frames
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$AnimatedSprite2D.play("idle")
	starting_pos = position
	

func attack():
	target = get_parent().allies[G.rng.randi_range(0, len(get_parent().allies)-1)]
	position = target.position + Vector2(64,0)
	$AnimatedSprite2D.play("attack")

func hover(visible):
	$Hover.visible = visible
	
	
func _on_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		$AnimatedSprite2D.play("idle")
		
		if target.has_method("take_damage"):
			target.take_damage(attack_power)
		position = starting_pos
		target = false
		finish_attack.emit()
func take_damage(damage):
	var amount = 0
	amount += (damage['physical_power'] / physical_defense)
	amount += (damage['magic_power'] / magic_defense)
	hp -= floor(amount)
	queue_redraw()
	if hp <= 0:
		die.emit(self)
func _draw():
	var hp_percent = float(hp) / float(max_hp)
	draw_string(ThemeDB.fallback_font, Vector2(-16,30), enemy_name, 0,-1,12)
	draw_rect(Rect2(-16,36,32,4), Color.WHITE)
	draw_rect(Rect2(-16,36,floor(32*hp_percent),4), Color.RED)
