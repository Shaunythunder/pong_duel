extends Control

# ========== Constants ==========

# ========== Godot Runtime ==========

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# ========== Button Callbacks ==========

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(GlobalConstants.MAIN_MENU_PATH)
