extends CharacterBody2D

@onready var multi_cam = $"../MultiCam"

@export var speed: float = 600.0
@export var jump_velocity: float = -550.0
@export var normal_fall_speed: float = 2300  # Gravity (pixels per second squared)
@export var fall_multiplier: float = 5
@export var jump_hold_multiplier: float = 0.5  # When jump is held, gravity is reduced (50% as strong)
@export var air_jumps: int = 1  # Extra in-air jumps allowed

# Time (in seconds) tao reach full speed from 0 (acceleration) and to come to a complete stop (deceleration)
@export var acceleration_time: float = 0.07  
@export var deceleration_time: float = 0.15 

var jumps_remaining: int = 0
var last_horizontal_direction: int = 0  # -1 for left, 1 for right

@onready var king_egg = $"../KingEgg"

func _ready():
	add_to_group("player")
	multi_cam.add_target(self)
	add_collision_exception_with(king_egg)

func _input(event):
	# Track the last horizontal input direction.
	if event.is_action_pressed("left"):
		last_horizontal_direction = -1
	elif event.is_action_pressed("right"):
		last_horizontal_direction = 1

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		# Start with the normal gravity force.
		var gravity_force: float = normal_fall_speed
		# If the character is moving upward and the jump button is still held, reduce gravity.
		if velocity.y < 0 and Input.is_action_pressed("jump"):
			gravity_force *= jump_hold_multiplier
		# If the player is holding down, apply the fall multiplier.
		if Input.is_action_pressed("down"):
			gravity_force *= fall_multiplier
		# Apply gravity.
		velocity += Vector2(0, gravity_force) * delta

func handle_jump() -> void:
	# Handle jump initiation and in-air jumps.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			$Audio/JumpSingle.play()
		elif jumps_remaining > 0:
			velocity.y = jump_velocity
			jumps_remaining -= 1
			$Audio/JumpDouble.play()
	# Note: The jump cut logic is removed so that releasing jump won't immediately reduce upward velocity.

func update_horizontal_movement(delta: float) -> void:
	var left_pressed = Input.is_action_pressed("left")
	var right_pressed = Input.is_action_pressed("right")
	var horizontal_direction: int = 0

	# Determine intended horizontal direction:
	if left_pressed and not right_pressed:
		horizontal_direction = -1
	elif right_pressed and not left_pressed:
		horizontal_direction = 1
	elif left_pressed and right_pressed:
		horizontal_direction = last_horizontal_direction
	
	# Accelerate or decelerate based on input.
	if horizontal_direction != 0:
		var target_speed: float = horizontal_direction * speed
		var acceleration_rate: float = speed / acceleration_time
		velocity.x = move_toward(velocity.x, target_speed, acceleration_rate * delta)
	else:
		var deceleration_rate: float = speed / deceleration_time
		velocity.x = move_toward(velocity.x, 0, deceleration_rate * delta)

func _physics_process(delta: float) -> void:
	# Reset in-air jumps when on the ground.
	if is_on_floor():
		jumps_remaining = air_jumps

	apply_gravity(delta)
	handle_jump()
	update_horizontal_movement(delta)

	move_and_slide()


# --- Slider callbacks (unchanged) ---
func _on_speed_slider_value_changed(value):
	speed = value
	print("speed: ", value)
func _on_jump_velocity_slider_value_changed(value):
	jump_velocity = value
	print("jump_velocity: ", value)
func _on_normal_fall_speed_slider_value_changed(value):
	normal_fall_speed = value
	print("normal_fall_speed: ", value)
func _on_fall_multiplier_slider_value_changed(value):
	fall_multiplier = value
	print("fall_multiplier: ", value)

func _on_system_gamecloser():
	print("==========")
	print("speed: ", speed)
	print("jump_velocity: ", jump_velocity)
	print("normal_fall_speed: ", normal_fall_speed)
	print("fall_multiplier: ", fall_multiplier)


const BROKEN_EGG = preload("res://Player/broken_egg.tscn")

func _on_king_egg_break_the_egg():
	var broken_instance = BROKEN_EGG.instantiate()
	
	broken_instance.position = king_egg.global_position
	broken_instance.rotation = king_egg.rotation
	
	get_parent().add_child(broken_instance)
	
	if king_egg.has_node("CollisionShape2D"):
		king_egg.get_node("CollisionShape2D").queue_free()
	if king_egg.has_node("Sprite2D"):
		king_egg.get_node("Sprite2D").queue_free()
	if king_egg.has_node("Label"):
		king_egg.get_node("Label").hide()
	
	king_egg.sleeping = true      
	king_egg.linear_velocity = Vector2.ZERO
	king_egg.gravity_scale = 0
