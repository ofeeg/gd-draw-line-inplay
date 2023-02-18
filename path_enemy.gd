extends "res://path_draw.gd"
onready var pathFollow = $PathFollow2D
export var traverseTime = 5
export var activeTime = 0
var pathLength = 0
var dir = 1
onready var change_count = 0
#onready var path = self
#DEBUG USE VARIABLES
var selectable = false
var selected = false
var changed = false
var unselected_color = Color.white
var selected_color = Color.red

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hit down arrow key to make paths selectable. Click first to select, click once more to select a start point, click again and so on to create curves.")
	pathLength = self.curve.get_baked_length()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if changed:
		changed = false
		change_count += 1
		pathLength = self.curve.get_baked_length()
		path_draw_save(change_count-1)
	if (activeTime >= traverseTime):
		dir = -1
	if (activeTime <= 0):
		dir = 1
	activeTime += _delta * dir
	pathFollow.set_offset((activeTime/traverseTime) * pathLength)


func _input(event):
	if self.selectable:
		if event is InputEventMouseButton:
			if self.selected:
				if event.button_index == BUTTON_LEFT && event.is_pressed():
						path_draw_set_point(event)
						update()
			if event.position.distance_to(self.position) < 50:
				self.selected = true
				update()
	else:
		if self.selected: 
			self.selected = false
			update()

#DRAW
func _draw():
	var c
	if selected:
		c = selected_color
	else:
		c = unselected_color
	draw_polyline(self.curve.get_baked_points(), c, 1, true)
	for p in self.curve.get_point_count():
		if p != 0 and p != self.curve.get_point_count() - 1:
			var a = self.curve.get_point_position(p) - self.curve.get_point_in(p) * -1
			var b = self.curve.get_point_position(p) - self.curve.get_point_out(p) * -1
			var cp = self.curve.get_point_position(p)
			draw_polyline(PoolVector2Array([a, cp]), c, 1, true)
			draw_polyline(PoolVector2Array([b, cp]), c, 1, true)
	update()
