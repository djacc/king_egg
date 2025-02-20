extends RigidBody2D

@onready var multi_cam = $"../MultiCam"

@export var char_path: NodePath
var bouncer: RigidBody2D

func _ready() -> void:
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



func _physics_process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == bouncer:
		var bounce_multiplier = 2  # Adjust this multiplier as needed.
		var speed = abs(linear_velocity.y) * bounce_multiplier
		var bounce_dir = Vector2(0, -1).rotated(bouncer.rotation)
		linear_velocity = bounce_dir * speed


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
