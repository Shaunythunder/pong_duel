extends Node2D

# ========== Constants ==========

const MAIN_MENU_PATH: String = "res://scenes/MainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BallManager.initialize_ball_pool()
	
