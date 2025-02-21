extends RigidBody2D

@onready var rigid_body_2d = $"../RigidBody2D"
@onready var rigid_body_2d_second = $"../RigidBody2D_second"
@onready var broken_egg = $".."

func _ready():
	# Set this node's rotation to be the negative of the broken egg's rotation.
	self.rotation = -broken_egg.rotation
	
	# Ignore collisions with the other two rigid bodies.
	add_collision_exception_with(rigid_body_2d)
	add_collision_exception_with(rigid_body_2d_second)
