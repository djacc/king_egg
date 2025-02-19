extends RigidBody2D

@export var follow_speed: float = 600.0
@export var target_offset: Vector2 = Vector2(0, -50)
@export var spring_strength: float = 300.0 
@export var damping: float = 5
@export var min_velocity_threshold: float = 5.0 
@export var max_tilt_degrees: float = 15.0
@onready var bouncer = $Sprite2D

func _ready():
	add_to_group("bouncer")
	add_collision_exception_with(get_parent())


func _physics_process(delta: float) -> void:
	var target: Vector2 = get_parent().global_position + target_offset
	var diff: Vector2 = target - global_position

	var spring_force: Vector2 = diff * spring_strength
	var damping_force: Vector2 = -linear_velocity * damping

	linear_velocity += (spring_force + damping_force) * delta
	linear_velocity = linear_velocity.limit_length(follow_speed)
	
	# If the velocity is very low, reset movement and rotation
	if linear_velocity.length() < min_velocity_threshold:
		linear_velocity = Vector2.ZERO
		bouncer.rotation = 0  # Reset rotation when nearly stopped
		return

	var tilt_ratio: float = clamp(abs(linear_velocity.x) / follow_speed, 0, 1)
	var tilt_degrees: float = tilt_ratio * max_tilt_degrees

	if linear_velocity.x > 0:
		bouncer.rotation = deg_to_rad(tilt_degrees)
	elif linear_velocity.x < 0:
		bouncer.rotation = deg_to_rad(-tilt_degrees)
