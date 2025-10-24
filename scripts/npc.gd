extends CharacterBody2D


const SPEED = 1000.0
var facing = "down"
var idle = true

@onready var new_pos = position

@onready var anim = $AnimatedSprite2D
@export var wander_radius = 40;
func _ready():
	$Wander/CollisionShape2D.shape.radius = wander_radius
func _physics_process(delta: float) -> void:
	if idle == true and velocity != Vector2.ZERO:
		idle = false
		if velocity.x > 0:
			anim.play("walk_right")
			facing = "right"
		elif velocity.x < 0:
			anim.play("walk_left")
			facing = "left"
		if velocity.y > 0:
			anim.play("walk_down")
			facing = "down"
		elif velocity.y < 0:
			anim.play("walk_up")
			facing = "up"
	
	if idle == false and velocity.x == 0 and velocity.y == 0:
		anim.play("idle_"+facing)
		idle = true
		
	var pos_difference = position - new_pos
	if pos_difference.x < 1 and pos_difference.x > -1 and pos_difference .y <1 and pos_difference.y > -1:
		new_pos = position
		velocity = Vector2.ZERO
		
	else:
		velocity = position.direction_to(new_pos) * SPEED * delta
	move_and_slide()


func _on_move_timer_timeout() -> void:
	if G.rng.randi_range(0,10) > 3:
		new_pos = position + Vector2(G.rng.randi_range(-20,20), G.rng.randi_range(-20,20))
