# Godot v4.5.1
# Author: Shaunythunder

extends Node2D

const SAVE_PATH: String = "user://save_data.json"
const FLAGS_PATH: String = "user://global_flags.json"

@onready var fake_ball_button = $"Menu/Button HBox/Button VBox/Fake Ball Duel Button"
@onready var bullet_ball_button = $"Menu/Button HBox/Button VBox/Bullet Duel Button"
@onready var stealth_ball_button = $"Menu/Button HBox/Button VBox/Stealth Duel Button"
@onready var boss_ball_button = $"Menu/Button HBox/Button VBox/Boss Duel Button"
@onready var survival_mode_button = $"Menu/Button HBox/Button VBox/Survival Mode Button"
@onready var best_survival_score = $"Menu/Control/Best Survival Score"
@onready var background = $"Background2"
@onready var background_sim = $"Background"

func buttons_visible_by_difficulty(current_difficulty):
	if not GlobalUnlocks.save_data[current_difficulty]["pong_ball_completed"]:
		fake_ball_button.visible = true
	if not GlobalUnlocks.save_data[current_difficulty]["fake_ball_completed"]:
		bullet_ball_button.visible = true
	if not GlobalUnlocks.save_data[current_difficulty]["bullet_ball_completed"]:
		stealth_ball_button.visible = true
	if not GlobalUnlocks.save_data[current_difficulty]["stealth_ball_completed"]:
		boss_ball_button.visible = true
	if not GlobalUnlocks.save_data[current_difficulty]["boss_ball_completed"]:
		survival_mode_button.visible = true
		best_survival_score.visible = true

# ========== Godot Runtime ==========
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	background.reparent(PersistentNodes)
	background_sim.reparent(PersistentNodes)
	background_sim.process_mode = Node.PROCESS_MODE_ALWAYS
	BallManager.clear_pools()
	BallManager.initialize_ball_pool()
	if BallManager.available_balls.size() > 0:
		for pool_ball in BallManager.available_balls:
			var ball_node = pool_ball["node"]
			ball_node.goal_scored.connect(_on_goal_scored)
	
	GlobalUnlocks.load_data_from_json()
	buttons_visible_by_difficulty(GlobalFlagManager.global_flags["difficulty"])
	
func _on_pong_ball_duel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game Scenes/PongBallDuel.tscn")


func _on_fake_ball_duel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game Scenes/FakeBallDuel.tscn")


func _on_bullet_duel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game Scenes/BulletBallDuel.tscn")


func _on_stealth_duel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game Scenes/StealthBallDuel.tscn")


func _on_boss_duel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game Scenes/BossDuel.tscn")


func _on_survival_mode_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game Scenes/SurvivalMode.tscn")


func _on_how_to_play_button_pressed() -> void:

	get_tree().change_scene_to_file("res://scenes/Game Scenes/HowToPlay.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_reset_progress_pressed() -> void:
	GlobalUnlocks.reset_progress()
	get_tree().reload_current_scene()


func _on_mouse_mode_item_selected(index: int) -> void:
	if index == 0: 
		GlobalFlagManager.enable_mouse()
	else:
		GlobalFlagManager.disable_mouse()
	GlobalFlagManager.save_data_to_json()


func _on_difficulty_mode_item_selected(index: int) -> void:
	if index == 0:
		GlobalFlagManager.change_difficulty(GlobalConstants.EASY)
	elif index == 1:
		GlobalFlagManager.change_difficulty(GlobalConstants.MEDIUM)
	elif index == 2:
		GlobalFlagManager.change_difficulty(GlobalConstants.HARD)
	elif index == 3:
		GlobalFlagManager.change_difficulty(GlobalConstants.INSANE)
	GlobalFlagManager.save_data_to_json()
	get_tree().reload_current_scene()


func _on_color_picker_button_color_changed(color: Color) -> void:
	GlobalFlagManager.change_color(color)

func _on_goal_scored():
	pass
