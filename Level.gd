extends Node2D

func _ready():
	print("Hit down arrow key to make paths selectable. Click first to select,\n click once more to select a start point, click again and so on to create curves.\n Every time you add a point, a copy is created in res://Paths/.\n Home is the undo button, and there is a bug on the second batch of undos after going back\n to default position.\n Press End and then Home in order to go back to the original position.")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
"""var can_select = false
onready var enemy_path2 = $second
onready var enemy_path = $first
# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		can_select = !can_select
		enemy_path2.selectable = !enemy_path2.selectable
		enemy_path.selectable = !enemy_path.selectable

"""
