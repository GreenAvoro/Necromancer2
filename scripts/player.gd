extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var facing="left"

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
func _process(delta: float) -> void:
	animate()
func _physics_process(delta: float) -> void:
	if not G.doing_alchemy:
		if Input.is_action_pressed("left"):
			facing = "left"
			velocity.x = -1
		elif Input.is_action_pressed("right"):
			facing = "right"
			velocity.x = 1
		else:
			velocity.x = 0
		if Input.is_action_pressed("up"):
			facing = "up"
			velocity.y = -1
		elif Input.is_action_pressed("down"):
			facing = "down"
			velocity.y = 1
		else:
			velocity.y = 0
		
		velocity = velocity.normalized() * SPEED
		move_and_slide()

func animate():
	if velocity != Vector2.ZERO:
		anim.play("run_"+facing)
	else:
		anim.play("idle_"+facing)
		
func notify_action(notify):
	$ActionIndicator.visible = notify
		
