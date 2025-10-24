extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	G.current_level = name
	if G.player_pos != Vector2.ZERO:
		$Player.position = G.player_pos
		G.player_pos = Vector2.ZERO
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		G.player_pos = body.position + Vector2(0,50) #TEMPOORARY DELETE ME
		get_tree().change_scene_to_file("res://scenes/synthesis.tscn")
