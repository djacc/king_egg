extends Area2D

signal death(death_type)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "KingEgg":
		death.emit("KingEgg")
	elif body.name == "Char":
		death.emit("Char")
