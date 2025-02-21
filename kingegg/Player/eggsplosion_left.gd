extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2(randf_range(-500, 0), randf_range(-200, -500))
	angular_velocity = randf_range(-10, -20)
