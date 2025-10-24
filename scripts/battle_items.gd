class_name BattleItems extends NinePatchRect

const TILE_SIZE = 48
var cx = 0
var cy = 0
const tiles_x = 15
const tiles_y = 3

func _ready() -> void:
	queue_redraw()
	
func cursor_up():
	cy -= 1
	if cy < 0:
		cy = tiles_y-1
	queue_redraw()
func cursor_down():
	cy += 1
	if cy > tiles_y-1:
		cy = 0
	queue_redraw()
func cursor_left():
	cx -= 1
	if cx < 0:
		cx = tiles_x-1
	queue_redraw()
func cursor_right():
	cx += 1
	if cx > tiles_x -1:
		cx = 0
	queue_redraw()
func cursor_reset():
	cx = 0
	cy = 0
	
func select_item():
	if len(G.basket) > cy*tiles_x + cx:
		var item = G.basket[cy*tiles_x + cx]
		return item
func _draw():

	var y_offset = -2
	var x_offset = 0
	var index = 0
	for y in range(tiles_y):
		y_offset += 2
		x_offset = 0
		for x in range(tiles_x):
			var tile_color = Color.WHITE
			if cx == x and cy == y:
				tile_color = Color.AQUA
			draw_rect(Rect2(10 + x*TILE_SIZE+x_offset, 10 + y*TILE_SIZE+y_offset, TILE_SIZE,TILE_SIZE), tile_color)
			if len(G.basket) > index:
				draw_texture_rect(G.basket[index].sprite,Rect2(10 + x*TILE_SIZE+x_offset+(TILE_SIZE/6), 10 + y*TILE_SIZE+y_offset+(TILE_SIZE/6), TILE_SIZE/3*2,TILE_SIZE/3*2), false)
			x_offset += 2
			index += 1
