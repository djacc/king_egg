extends Node2D

@onready var death_timer = Timer.new()  # Create a new Timer instance

signal break_egg


func _ready() -> void:
	#death_timer.wait_time = 3.0  # Set timer duration to 3 seconds
	death_timer.one_shot = true  # Make it trigger only once
	add_child(death_timer)  # Add Timer to the node tree

	death_timer.timeout.connect(_on_death_timer_timeout)

# Function called when the timer reaches 0
func _on_death_timer_timeout():
	print("Death")
	GameEvents.emit_signal("global_signal")

@onready var scream = $DangerZone/Scream
func _on_death(death_type: String) -> void:
	if death_type == "KingEgg":
		death_timer.wait_time = 2
		break_egg.emit()
	elif death_type == "Char":
		death_timer.wait_time = 2
		scream.play()
	
	death_timer.start()
	
