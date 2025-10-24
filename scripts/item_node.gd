extends Sprite2D

var items = []
var player_present = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_items = G.levels[get_parent().name].items
	for i in range(3):
		var item = Item.new()
		var id = level_items[G.rng.randi_range(0, len(level_items)-1)]
		item.setup(id)
		items.append(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_present:
		if Input.is_action_just_pressed("select"):
			for item in items:
				G.inventory.append(item)
			queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_present = body
		if body.has_method("notify_action"):
			body.notify_action(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_present = false
		if body.has_method("notify_action"):
			body.notify_action(false)
