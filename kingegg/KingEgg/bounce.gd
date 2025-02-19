extends RigidBody2D

@onready var multi_cam = $"../MultiCam"

@export var char_path: NodePath  # Set this to your Char node in the main scene.
var bouncer: RigidBody2D

func _ready() -> void:
	multi_cam.add_target(self)
	
	# Get the Char node using the exported path.
	var char_node = get_node(char_path)
	if char_node:
		# Retrieve the Bouncer node from the Char scene.
		bouncer = char_node.get_node("Bouncer")  # Adjust the path if Bouncer is nested deeper.
		if bouncer:
			set_gravity_scale(0.3)
			#print("Bouncer found!")
		else:
			print("Bouncer not found in Char!")
	else:
		print("Char not found!")

func _physics_process(delta: float) -> void:
	rotation = 0

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
