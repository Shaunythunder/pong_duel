extends Control

# ========== Constants ==========

signal pause_balls()

# ========== Godot Runtime ==========

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# ========== Button Callbacks ==========

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(GlobalConstants.MAIN_MENU_PATH)


func _on_bullet_types_pressed() -> void:
	get_tree().change_scene_to_file(GlobalConstants.BULLET_TYPES_PATH)


func _on_how_to_play_2_pressed() -> void:
	get_tree().change_scene_to_file(GlobalConstants.HOW_TO_PLAY_SCENE_PATH)


func _on_pause_balls_pressed() -> void:
	pause_balls.emit()
