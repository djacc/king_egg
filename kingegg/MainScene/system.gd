extends Node

signal gamecloser
var current_level_number: int = 1
@onready var story_button = $"../ClickSound"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		gamecloser.emit()
		await get_tree().create_timer(0.05).timeout
		get_tree().quit()
	elif Input.is_action_just_pressed("respawn"):
		#get_tree().reload_current_scene()
		reload_current_level()

func _ready():
	story_button.play()
	#GameEvents.connect("reload_current_level", Callable(self, "reload_current_level"))
	var total_levels = 0
	while ResourceLoader.exists("res://Levels/level_%d.tscn" % (total_levels + 1), "PackedScene"):
		total_levels += 1
	print("Total levels available: %d" % total_levels)
	GameEvents.connect("global_signal", Callable(self, "_on_global_signal"))
	
	
	
	

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
	var main_scene = self
	
	var current_level_path = "res://Levels/level_%d.tscn" % current_level_number
	var current_level_node = main_scene.get_node("Level_%d" % current_level_number)

	if current_level_node:
		current_level_node.call_deferred("queue_free")
		print("Removed Level_%d." % current_level_number)
	else:
		print("Current level 'Level_%d' not found!" % current_level_number)
	
	# Determine the next level number and file path.
	var next_level_number = current_level_number + 1
	var next_level_path = "res://Levels/level_%d.tscn" % next_level_number
	
	# Check if the next level scene file exists.
	if not ResourceLoader.exists(next_level_path, "PackedScene"):
		print("No more levels. Game completed.")
		var endScreenScene = load("res://MainScene/end_screen.tscn")
		if endScreenScene:
			var endScreenInstance = endScreenScene.instantiate()
			add_child(endScreenInstance)
		else:
			print("Error: Could not load end screen scene!")
		return

	var next_level_scene = load(next_level_path)
	if next_level_scene == null:
		print("Error: Could not load next level scene from: ", next_level_path)
		return
	
	var next_level_instance = next_level_scene.instantiate()
	next_level_instance.name = "Level_%d" % next_level_number
	
	main_scene.call_deferred("add_child", next_level_instance)
	
	current_level_number = next_level_number
	print("Switched to Level_%d." % current_level_number)
	
	call_deferred("_connect_goal_area")

@onready var canvas_layer = $"../CanvasLayer"	



func reload_current_level():
	
	

	# Remove old level
	var node = get_node_or_null("Level_%d" % current_level_number)
	if node:
		node.queue_free()
	
	# Wait one frame so removal is processed.
	await get_tree().create_timer(0).timeout
	
	# Now add the new node.
	var level_scene = load("res://Levels/level_%d.tscn" % current_level_number)
	var new_level_instance = level_scene.instantiate()
	new_level_instance.name = "Level_%d" % current_level_number
	add_child(new_level_instance)
	_connect_goal_area()
	print("GET THIS SHIT OUTTA HERE")

func _on_global_signal():
	reload_current_level()


func _on_start_button_pressed() -> void:
	story_button.play()
	var level1_scene = load("res://Levels/level_1.tscn")
	if level1_scene:
		var level1_instance = level1_scene.instantiate()
		level1_instance.name = "Level_1"
		add_child(level1_instance)
		print("Instantiated Level_1.")
		_connect_goal_area()
	else:
		print("Error: Could not load Level_1 scene!")
	canvas_layer.queue_free()

func _on_story_button_pressed() -> void:
	story_button.play()
	print("story button pressed")
	var story_scene = preload("res://story.tscn")
	if story_scene:
		var level1_instance = story_scene.instantiate()
		level1_instance.name = "Story"
		add_child(level1_instance)
		print("Instantiated story")
	else:
		print("Error: Could not load Level_1 scene!")
	canvas_layer.queue_free()
		
	
