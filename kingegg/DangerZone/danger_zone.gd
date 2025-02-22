extends Area2D

signal death(death_type)
@onready var shock = $Shock
@onready var egg_crack = $EggCrack

func _on_body_entered(body: Node2D) -> void:
	if body.name == "KingEgg":
		death.emit("KingEgg")
		shock.play()
		egg_crack.play()
	elif body.name == "Char":
		death.emit("Char")
