extends Node

const SAFETY_BOX = preload("res://safety_box.tscn")

func get_world_mouse_position() -> Vector2:
	var canvas_transform = get_viewport().get_canvas_transform()
	var world_transform = canvas_transform.affine_inverse()
	var mouse_pos = get_viewport().get_mouse_position()
	return world_transform * mouse_pos

func _input(event):
	if Input.is_action_just_pressed("place_box"):
		var safety_box = SAFETY_BOX.instantiate()
		safety_box.position = get_world_mouse_position()
		add_child(safety_box)
		print("Placed safety box at: ", safety_box.position)
