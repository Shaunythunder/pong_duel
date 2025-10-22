# Godot v4.5.1
# Author: Shaunythunder

extends Control

@onready var fake_ball_button = $"Button HBox/Button VBox/Fake Ball Duel Button"
@onready var bullet_ball_button = $"Button HBox/Button VBox/Bullet Duel Button"
@onready var stealth_ball_button = $"Button HBox/Button VBox/Stealth Duel Button"
@onready var boss_ball_button = $"Button HBox/Button VBox/Boss Duel Button"
@onready var survival_mode_button = $"Button HBox/Button VBox/Survival Mode Button"

# ========== Godot Runtime ==========
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not GlobalUnlocks.save_data["pong_ball_completed"]:
		fake_ball_button.visible = false
	if not GlobalUnlocks.save_data["fake_ball_completed"]:
		bullet_ball_button.visible = false
	if not GlobalUnlocks.save_data["bullet_ball_completed"]:
		stealth_ball_button.visible = false
	if not GlobalUnlocks.save_data["stealth_ball_completed"]:
		boss_ball_button.visible = false
	if not GlobalUnlocks.save_data["boss_ball_completed"]:
		survival_mode_button.visible = false
	
	
	
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
