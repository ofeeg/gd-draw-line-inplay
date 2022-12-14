extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_select = false
onready var enemy_path2 = $second
onready var enemy_path = $first
# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		can_select = !can_select
		enemy_path2.selectable = !enemy_path2.selectable
		enemy_path.selectable = !enemy_path.selectable
		#enemy_path.selected = !enemy_path.selected
		#enemy_path2.selected = !enemy_path2.selected
		#print("Select:", can_select)
		#print(enemy_path.curve.get_point_count(), enemy_path.selected)
		#print(enemy_path2.curve.get_point_count(), enemy_path2.selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
