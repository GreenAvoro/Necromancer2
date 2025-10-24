extends Area2D
var speed = 10
var next_pos = Vector2.ZERO
@onready var area:CollisionShape2D = $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var randx = G.rng.randi_range(0-area.shape.size.x/2,0+area.shape.size.x/2)
	var randy = G.rng.randi_range(0-area.shape.size.y/2,0+area.shape.size.y/2)
	next_pos = Vector2(randx,randy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if $AnimatedSprite2D.position.x - next_pos.x < 1 and $AnimatedSprite2D.position.x - next_pos.x > -1 and $AnimatedSprite2D.position.y - next_pos.y < 1 and $AnimatedSprite2D.position.y - next_pos.y > -1:
		var randx = G.rng.randi_range(0-area.shape.size.x/2,0+area.shape.size.x/2)
		var randy = G.rng.randi_range(0-area.shape.size.y/2,0+area.shape.size.y/2)
		next_pos = Vector2(randx,randy)
	else:
		$AnimatedSprite2D.position += $AnimatedSprite2D.position.direction_to(next_pos) * speed * delta
