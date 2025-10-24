extends Node2D

@export_enum("Cottage", "CottageAttic", "NearbyForest", "Village") var to_scene:String
@export var side:String = "down"
@export var spawn_point:int = 0
@onready var shape:CollisionShape2D = $Area2D/CollisionShape2D

func _draw() -> void:
	if side == "down":
		draw_dashed_line(Vector2(0, shape.shape.size.y),Vector2(shape.shape.size.x, shape.shape.size.y), Color.WHITE, 2, 2)
	elif side == "up":
		draw_dashed_line(Vector2(0, 0),Vector2(shape.shape.size.x, 0), Color.WHITE, 2, 2)
	elif side == "left":
		draw_dashed_line(Vector2(0, 0),Vector2(0, shape.shape.size.y), Color.WHITE, 2, 2)
	elif side == "right":
		draw_dashed_line(Vector2(shape.shape.size.x, 0),Vector2(shape.shape.size.x, shape.shape.size.y), Color.WHITE, 2, 2)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if to_scene:
			G.player_pos = G.levels[to_scene].spawns[spawn_point]
			get_tree().change_scene_to_file(G.levels[to_scene].scene)
