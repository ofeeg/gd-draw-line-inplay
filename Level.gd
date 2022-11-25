extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_select = false
onready var enemy_path2 = $Path2D2
onready var enemy_path = $Path2D
# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		
		can_select = !can_select
		enemy_path2.selectable = !enemy_path2.selectable
		enemy_path.selectable = !enemy_path.selectable
		print("Select now!", can_select)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
