extends RigidBody2D

@export var follow_speed: float = 600.0
@export var target_offset: Vector2 = Vector2(0, -30)
@export var spring_strength: float = 300.0 
@export var damping: float = 5
@export var min_velocity_threshold: float = 5.0 
@export var max_tilt_degrees: float = 20.0
@export var fixed_spin_degrees: float = 25.0  # Fixed rotation offset when spin input is pressed

@onready var sprite = $Sprite2D  # Visual representation

# Extra spin (in radians) applied based on input.
var extra_spin: float = 0.0

func _ready():
	add_to_group("bouncer")
	add_collision_exception_with(get_parent())

func _physics_process(delta: float) -> void:
	# Set extra_spin based on input: fixed offset if pressed; otherwise, 0.
	if Input.is_action_pressed("spin_stab_clockwise"):
		extra_spin = deg_to_rad(fixed_spin_degrees)
	elif Input.is_action_pressed("spin_stab_counter_clockwise"):
		extra_spin = deg_to_rad(-fixed_spin_degrees)
	else:
		extra_spin = 0.0
	
	# Follow the target position (character + offset) using spring physics.
	var target: Vector2 = get_parent().global_position + target_offset
	var diff: Vector2 = target - global_position

	var spring_force: Vector2 = diff * spring_strength
	var damping_force: Vector2 = -linear_velocity * damping

	linear_velocity += (spring_force + damping_force) * delta
	linear_velocity = linear_velocity.limit_length(follow_speed)
	
	# Calculate tilt from lateral movement.
	var tilt: float = 0.0
	if linear_velocity.length() < min_velocity_threshold:
		linear_velocity = Vector2.ZERO
		rotation = extra_spin
		return
	else:
		var tilt_ratio: float = clamp(abs(linear_velocity.x) / follow_speed, 0, 1)
		var tilt_degrees: float = tilt_ratio * max_tilt_degrees
		if linear_velocity.x > 0:
			tilt = deg_to_rad(tilt_degrees)
		elif linear_velocity.x < 0:
			tilt = deg_to_rad(-tilt_degrees)
	
	# Apply the combined rotation: tilt from movement plus the fixed extra spin offset.
	rotation = tilt + extra_spin
