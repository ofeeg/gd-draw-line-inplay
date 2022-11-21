extends Node2D


onready var path = get_node("Path2D")
var idx = 0
var c = Color.red
var dragging = false

func _input(event):
	if event is InputEventMouseButton:
		dragging = true
		#SELECT POINTS
		if event.button_index == BUTTON_LEFT:
			for p in path.curve.get_point_count():
				if path.curve.get_point_position(p).distance_to(event.position) < 40:
					idx = p
					update()
				else:
					path.curve.add_point(event.position)
					idx = path.curve.get_point_count()-1
					update()

	#SELECT HANDLES
				var a = path.curve.get_point_position(p) - path.curve.get_point_out(p)
				var b = path.curve.get_point_position(p) - path.curve.get_point_in(p)

				if a.distance_to(event.position) < 40:
					idx = p

				if b.distance_to(event.position) < 40:
					idx = p

		if event is InputEventMouseMotion:
			print("dragging")
#DRAG POINTS
			for p in path.curve.get_point_count():
				if path.curve.get_point_position(p).distance_to(event.position) < 40 :
					path.curve.set_point_position(idx, path.curve.get_point_position(idx) + event.relative)
					update()

#DRAG HANDLES
				var a = path.curve.get_point_position(p) - path.curve.get_point_out(p)
				var b = path.curve.get_point_position(p) - path.curve.get_point_in(p)
				var d = path.curve.get_point_position(p) - event.position

				if a.distance_to(event.position) < 40:
					path.curve.set_point_in(idx, -d + event.relative)
					path.curve.set_point_out(idx, d + event.relative)
					update()

				if b.distance_to(event.position) < 40:
					path.curve.set_point_out(idx, -d + event.relative)
					path.curve.set_point_in(idx, d + event.relative)
					update()
		update()

#DRAW
func _draw():
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
