extends CharacterBody2D


const SPEED = 1500.0

var target = null

func _ready() -> void:
	#Unload this enemy if the player wins a battle against them
	if G.enemy_unload == name:
		G.enemy_unload = null
		queue_free()
		return
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	if target:
		velocity = global_position.direction_to(target.global_position) * SPEED * delta
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()


func _on_detect_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
		$AnimatedSprite2D.play("move")


func _on_detect_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		target = null
		$AnimatedSprite2D.play("idle")


func _on_start_battle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		G.player_pos = body.position
		G.enemy_unload = self.name
		get_tree().change_scene_to_packed(load("res://scenes/battle.tscn"))
