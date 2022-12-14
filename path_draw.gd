extends Path2D
onready var pathFollow = $PathFollow2D
export var traverseTime = 5
export var activeTime = 0
var pathLength = 0
var dir = 1
#onready var path = self
#DEBUG USE VARIABLES
var idx = 0
var selectable = false
var selected = false
var changed = false
var unselected_color = Color.white
var selected_color = Color.red
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hit down arrow key to make paths selectable.")
	pathLength = self.curve.get_baked_length()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if changed:
		changed = false
		pathLength = self.curve.get_baked_length()
		var p_s = PackedScene.new()
		var name = "res://Paths/" + self.get_name() + ".tscn"
		p_s.pack(get_tree().get_current_scene().get_node(self.get_path()))
		ResourceSaver.save(name, p_s)
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
					for p in self.curve.get_point_count():
						if self.curve.get_point_position(p).distance_to(event.position) < 100:
							idx = p
							update()
						#SELECT HANDLES
						var a = self.curve.get_point_position(p) - self.curve.get_point_out(p)
						var b = self.curve.get_point_position(p) - self.curve.get_point_in(p)
						if a.distance_to(event.position) < 10:
							idx = p
						if b.distance_to(event.position) < 10:
							idx = p
					if idx == 0:
						self.curve.add_point(Vector2(event.position.x - self.position.x, event.position.y - self.position.y))
						idx = self.curve.get_point_count()-1
						self.changed = true
						update()
			if event.position.distance_to(self.position) < 50:
				self.selected = true
				update()
	else:
		if self.selected: 
			self.selected = false
			update()
	idx = 0


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
