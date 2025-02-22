extends CanvasLayer
@onready var click_sound = $Button/ClickSound

var pages = [
	"res://PlaceholderAssets/comic/page1.png",
	"res://PlaceholderAssets/comic/page2.png",
	"res://PlaceholderAssets/comic/page3.png",
	"res://PlaceholderAssets/comic/page4.png",	
]

var count

signal main_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = load(pages[0])
	count = 1


func _on_button_pressed() -> void:
	click_sound.play()
	if count == 3:
		$Button.text = "FINISH"
	elif count == 4:
		
		get_tree().reload_current_scene()
		return
		
	$Sprite2D.texture = load(pages[count])
	count += 1
	
