extends Node

signal gamecloser

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		gamecloser.emit()
		await get_tree().create_timer(0.05).timeout
		get_tree().quit()
		
	elif Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()
