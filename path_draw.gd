extends Path2D
var selectable = false
var selected = false
var changed = false
onready var pathFollow = $PathFollow2D
export var traverseTime = 5
export var activeTime = 0
var pathLength = 0
var dir = 1
onready var path = self
var idx = 0
var unselected_color = Color.white
var selected_color = Color.red
var dummy_pos = Vector2(50,50)
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hit down arrow key to make paths selectable.")
	pathLength = self.curve.get_baked_length()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if changed:
		pathLength = self.curve.get_baked_length()
		changed = false
	if (activeTime >= traverseTime):
		dir = -1
	if (activeTime <= 0):
		dir = 1
	activeTime += _delta * dir
	pathFollow.set_offset((activeTime/traverseTime) * pathLength)


func _input(event):
	if selectable:
		if event is InputEventMouseButton:
			if event.position.distance_to(self.position) < 50:
				selected = true
			if selected:
				if event.button_index == BUTTON_LEFT && event.is_pressed():
					for p in path.curve.get_point_count():
						if path.curve.get_point_position(p).distance_to(event.position) < 100:
							idx = p
							update()
						else:
							path.curve.add_point(Vector2(event.position.x - self.position.x, event.position.y - self.position.y))
							idx = path.curve.get_point_count()-1
							changed = true
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
			var a = path.curve.get_point_position(p) - path.curve.get_point_in(p) * -1
			var b = path.curve.get_point_position(p) - path.curve.get_point_out(p) * -1
			var cp = path.curve.get_point_position(p)
			draw_polyline(PoolVector2Array([a, cp]), c, 1, true)
			draw_polyline(PoolVector2Array([b, cp]), c, 1, true)
	update()
