extends Node

signal gamecloser

# Track the current level number; assume we start at Level_1.
var current_level_number: int = 1

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		gamecloser.emit()
		await get_tree().create_timer(0.05).timeout
		get_tree().quit()
	elif Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()

func _ready():
	# Count total levels by checking sequentially until a level file does not exist.
	var total_levels = 0
	while ResourceLoader.exists("res://Levels/level_%d.tscn" % (total_levels + 1), "PackedScene"):
		total_levels += 1
	print("Total levels available: %d" % total_levels)
	
	# Connect any goal area already present.
	_connect_goal_area()


func _connect_goal_area() -> void:
	var goal_areas = get_tree().get_nodes_in_group("goal_area")
	if goal_areas.size() > 0:
		for goal in goal_areas:
			var cb = Callable(self, "_on_goal_met")
			if goal.is_connected("goal_met", cb):
				goal.disconnect("goal_met", cb)
			goal.connect("goal_met", cb)
		print("Connected goal area from new level.")
	else:
		print("No goal area found in group 'goal_area' in current level!")

func _on_goal_met() -> void:
	print("Goal has been met! Ready for switching to level %d." % (current_level_number + 1))
	_switch_to_next_level()
	$"../WinSound".play()

func _switch_to_next_level() -> void:
	# Assume that the main scene has the current level as a child named "Level_N".
	var main_scene = get_parent()
	var current_level_node = main_scene.get_node_or_null("Level_%d" % current_level_number)
	if current_level_node:
		# Remove the current level safely.
		current_level_node.call_deferred("queue_free")
	else:
		print("Current level 'Level_%d' not found!" % current_level_number)
	
	# Determine the next level number.
	var next_level_number = current_level_number + 1
	var next_level_path = "res://Levels/level_%d.tscn" % next_level_number
	
	# Check if the next level scene exists.
	if not ResourceLoader.exists(next_level_path, "PackedScene"):
		print("No more levels. Game completed.")
		return
	
	var next_level_scene = load(next_level_path)
	if next_level_scene == null:
		print("Error: Could not load next level scene from: ", next_level_path)
		return
	
	var next_level_instance = next_level_scene.instantiate()
	next_level_instance.name = "Level_%d" % next_level_number
	
	# Add the new level to the main scene using a deferred call.
	main_scene.call_deferred("add_child", next_level_instance)
	
	# Update the current level number.
	current_level_number = next_level_number
	print("Switched to Level_%d." % current_level_number)
	
	# Now that a new level is added, reconnect its goal area signal.
	call_deferred("_connect_goal_area")
