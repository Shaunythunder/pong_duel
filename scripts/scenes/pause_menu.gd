extends Control

@export var pause_menu = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if pause_menu:
		GlobalPause.pause_toggle.connect(_on_pause_toggle)

func _on_pause_toggle():
	if GlobalPause.game_paused:
		show()
	else:
		hide()

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(GlobalConstants.MAIN_MENU_PATH)
