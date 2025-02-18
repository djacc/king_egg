extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -800.0
@export var normal_fall_speed: float = 1800  # Gravity (pixels per second squared)
@export var fall_multiplier: float = 9
@export var jump_cut_multiplier: float = 0.03
@export var air_jumps: int = 1  # Extra in-air jumps allowed

# Time (in seconds) to reach full speed from 0 (acceleration) and to come to a complete stop (deceleration)
@export var acceleration_time: float = 0.07  
@export var deceleration_time: float = 0.15 

var jumps_remaining: int = 0
var last_horizontal_direction: int = 0  # -1 for left, 1 for right

func _input(event):
	# Track the last horizontal input direction.
	if event.is_action_pressed("left"):
		last_horizontal_direction = -1
	elif event.is_action_pressed("right"):
		last_horizontal_direction = 1

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var current_gravity = Vector2(0, normal_fall_speed)
		if Input.is_action_pressed("down"):
			current_gravity *= fall_multiplier
		velocity += current_gravity * delta

func handle_jump() -> void:
	# Handle jump initiation and in-air jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif jumps_remaining > 0:
			velocity.y = jump_velocity
			jumps_remaining -= 1

	# Cut jump short if the jump button is released early
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

func update_horizontal_movement(delta: float) -> void:
	var left_pressed = Input.is_action_pressed("left")
	var right_pressed = Input.is_action_pressed("right")
	var horizontal_direction: int = 0

	# Determine intended direction:
	if left_pressed and not right_pressed:
		horizontal_direction = -1
	elif right_pressed and not left_pressed:
		horizontal_direction = 1
	elif left_pressed and right_pressed:
		horizontal_direction = last_horizontal_direction
	
	# If input exists, accelerate; otherwise, decelerate to 0.
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
func _on_jump_cut_multiplier_slider_value_changed(value):
	jump_cut_multiplier = value
	print("jump_cut_multiplier: ", value)


func _on_system_gamecloser():
	print("==========")
	print("speed: ", speed)
	print("jump_velocity: ", jump_velocity)
	print("normal_fall_speed: ", normal_fall_speed)
	print("fall_multiplier: ", fall_multiplier)
	print("jump_cut_multiplier: ", jump_cut_multiplier)
	
