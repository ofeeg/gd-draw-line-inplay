extends Path2D
var can_select = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		can_select = !can_select
		self.selectable = !self.selectable


func path_draw_save(num, n_name):
	var p_s = PackedScene.new()
	var name = "res://Paths/" + n_name + String(num) + get_parent().name + String(self.position) + ".tscn"
	p_s.pack(get_tree().get_current_scene().get_node(self.get_path()))
	var a = p_s.instance()
	a.position = Vector2.ZERO
	p_s.pack(a)
	ResourceSaver.save(name, p_s)

func path_draw_undo(num, position, n_name, obj) -> void:
	var name =  "res://Paths/" + n_name + String(num-1) + get_parent().name + String(obj.position) + ".tscn"
	var other
	var oi
	if num  <= 2:
		oi = load("res://path_enemy.tscn").instance()
		oi.position = position
		oi.selectable = obj.selectable
		oi.selected = obj.selected
		oi.dname = n_name
		oi.change_count = 0
		num = 0
		get_parent().add_child(oi)
		queue_free()
		return
	elif num >  2:
		other = load(name)
		oi = other.instance()
		oi.change_count = num-1
		oi.position = position
		oi.selectable = obj.selectable
		oi.selected = obj.selected
		oi.dname = n_name
		get_parent().add_child(oi)
		queue_free()


func path_draw_set_point(event):
	var idx = 0
	for p in self.curve.get_point_count():
		if self.curve.get_point_position(p).distance_to(event.position) < 100:
			idx = p
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
