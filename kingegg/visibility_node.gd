extends Node2D
# Called when the node enters the scene tree for the first time.

@onready var multi_cam = $"../MultiCam"	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Char":
		multi_cam.add_target(self)
		print("added")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Char":
		multi_cam.remove_target(self)
	print("removed")
