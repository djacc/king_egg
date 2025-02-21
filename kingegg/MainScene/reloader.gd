# Reloader.gd
extends Node

# Define a signal that takes two arguments.
signal reload_current_level(arg1, arg2)

# A helper function that emits the signal.
func call_reload_current_level(arg1, arg2):
	emit_signal("reload_current_level", arg1, arg2)
