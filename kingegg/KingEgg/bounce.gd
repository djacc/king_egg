extends RigidBody2D

@onready var multi_cam = $"../MultiCam"

@export var char_path: NodePath
var bouncer: RigidBody2D
var egg_exists = true
	


func _ready() -> void:
	add_to_group("goal_area")
	#body_entered.connect(Callable(self, "_on_body_entered"))
	
	add_to_group("egg")
	multi_cam.add_target(self)
	linear_damp = 0  # Disable linear damping so velocity is maintained.
	var char_node = get_node(char_path)
	if char_node:
		bouncer = char_node.get_node("Bouncer")  # Adjust the path if Bouncer is nested deeper.
		if bouncer:
			set_gravity_scale(0.4)
		else:
			print("Bouncer not found in Char!")
	else:
		print("Char not found!")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if egg_exists == true:
		if body == bouncer:
			var bounce_multiplier = 2  # Adjust this multiplier as needed.
			var speed = abs(linear_velocity.y) * bounce_multiplier
			var bounce_dir = Vector2(0, -1).rotated(bouncer.rotation)
			linear_velocity = bounce_dir * speed
			$BounceSound.play()


#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Collided with: ", body.name)
	#if body.is_in_group("bouncer"):
		#print("yo")
	#
	#if body == bouncer:
		#print("yo")
		#var bounce_dir = (bouncer.global_position - global_position).normalized()
		#var y_velocit y = bouncer.velocity.y
		#if y_velocity >= 1:
			#linear_velocity = -bounce_dir * 300
		#else:
			#linear_velocity = -bounce_dir * 150

signal goal_met
func _on_goal_body_entered(body):
	if body == self:
		print("EGG ENTERED GOAL")
		emit_signal("goal_met")
		
		
@onready var velocity_indicator = get_node("VelocityIndicator")
@export var egg_break_cap = 400
var last_velocity: Vector2 = Vector2.ZERO
func _physics_process(delta: float) -> void:
	last_velocity = linear_velocity
	if last_velocity.y > egg_break_cap:
		velocity_indicator.add_theme_color_override("font_color", Color(1, 0, 0))
	else:
		velocity_indicator.add_theme_color_override("font_color", Color(1, 1, 1))
	velocity_indicator.text = str(abs(round(linear_velocity.y)))

	velocity_indicator.rotation = -global_rotation
	var offset = Vector2(50, -70)
	velocity_indicator.set_global_position(global_position + offset)

	
signal break_the_egg

func _on_body_entered(body):
	if body is TileMapLayer:
		if last_velocity.y > egg_break_cap:
			print("break the egg")
			break_the_egg.emit()
			egg_exists = false
		elif last_velocity.y <= egg_break_cap:
			print("egg is fine")
