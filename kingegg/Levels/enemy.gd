extends CharacterBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var enemy_death = $EnemyDeath
@onready var collision_shape_2d_hitbox = $CanBeKilled/CollisionShape2D

var is_alive = true


#func _process(delta: float) -> void:
	#if not is_alive and not is_dead_handled:
		
		# Wait 2 seconds (adjust the time as needed) before removing the node
		
		  # or perform any other action after the delay
		

func _on_can_be_killed_body_entered(body):
	if "KingEgg" in body.name:
		print("killed")
		is_alive = false
		sprite_2d.visible = false
		#collision_shape_2d_hitbox.disabled = true
		
		enemy_death.play()  # Play the death sound.
		# Wait until the sound finishes.
		await get_tree().create_timer(.2).timeout  
		collision_shape_2d.disabled = true
		await enemy_death.finished
		queue_free()
