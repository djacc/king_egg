extends Node2D

@onready var final_win = $FinalWin

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(.5).timeout

	final_win.play()
