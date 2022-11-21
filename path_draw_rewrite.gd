extends Node2D
var selected = false
onready var path = $Path2D
var idx = 0
var unselected_color = Color.white
var selected_color = Color.blue
var dummy_pos = Vector2(50,50)

func _input(event):
	if event is InputEventMouseButton:
		if event.position.distance_to(self.position) < 50:
			selected = true
		if selected:
			if event.button_index == BUTTON_LEFT:
				for p in path.curve.get_point_count():
					if path.curve.get_point_position(p).distance_to(event.position) < 100:
						idx = p
						update()
					else:
						path.curve.add_point(Vector2(event.position.x - self.position.x, event.position.y - self.position.y))
						idx = path.curve.get_point_count()-1
						update()
					#SELECT HANDLES
					var a = path.curve.get_point_position(p) - path.curve.get_point_out(p)
					var b = path.curve.get_point_position(p) - path.curve.get_point_in(p)
					if a.distance_to(event.position) < 10:
						idx = p
					if b.distance_to(event.position) < 10:
						idx = p



#DRAW
func _draw():
	var c
	if selected:
		c = selected_color
	else:
		c = unselected_color
	draw_polyline(path.curve.get_baked_points(), c, 1, true)
	for p in path.curve.get_point_count():
		if p != 0 and p != path.curve.get_point_count() - 1:
			draw_circle(path.curve.get_point_position(p), 8, c)
			draw_circle(path.curve.get_point_position(p) - path.curve.get_point_in(p) * -1, 5, c)
			draw_circle(path.curve.get_point_position(p) - path.curve.get_point_out(p) * -1, 5, c)
			var a = path.curve.get_point_position(p) - path.curve.get_point_in(p) * -1
			var b = path.curve.get_point_position(p) - path.curve.get_point_out(p) * -1
			var cp = path.curve.get_point_position(p)
			draw_polyline(PoolVector2Array([a, cp]), c, 1, true)
			draw_polyline(PoolVector2Array([b, cp]), c, 1, true)
	update()
