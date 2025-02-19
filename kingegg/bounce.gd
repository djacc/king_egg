extends RigidBody2D

@onready var multi_cam: Camera2D = $"../multiCam"


@onready var char: CharacterBody2D = $"../Char"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multi_cam.add_target(self)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == char:
		var bounce_dir = (char.global_position - global_position).normalized()
		
		var y_velocity = char.velocity.y
		
		if y_velocity >= 1:
			linear_velocity = -bounce_dir * 1500
		else:
			linear_velocity = -bounce_dir * 1000
		
		
