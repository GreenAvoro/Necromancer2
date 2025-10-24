class_name Ally extends Node2D

var ally_name:String = ""
var hp:int = 1
var max_hp:int = 1
var attack_power = 3
var physical_defense = 1
var magic_defense = 1
var using_item:Item = null


var starting_pos = Vector2.ZERO

signal finish_attack
signal took_damage
signal die

var target = null

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	starting_pos = position
	if ally_name != "Lulu":
		anim.sprite_frames = load("res://resources/"+ally_name.to_lower()+"_battle_frames.tres")



func setup(a_name, a_hp, a_max_hp, a_attack ):
	ally_name = a_name
	hp = a_hp
	max_hp = a_max_hp
	attack_power = a_attack

func attack(enemy):
	target = enemy
	position = enemy.position -Vector2(64,0)
	$AnimatedSprite2D.play("attack")
func use_item(item:Item, enemy):
	target = enemy
	using_item = item
	$AnimatedSprite2D.play("use_item")
func take_damage(amount):
	hp -= amount
	took_damage.emit()
	if hp <= 0:
		die.emit(self)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if target.has_method("take_damage"):
		if $AnimatedSprite2D.animation == "attack":
			target.take_damage({"physical_power":attack_power, "magic_power": 0})
		else:
			target.take_damage(using_item.deal_damage())
	position = starting_pos
	$AnimatedSprite2D.play("idle")
	target = null
	using_item = null
	finish_attack.emit()
