# Godot v4.5.1
# Author: Shaunythunder

extends Control

# ========== Godot Runtime ==========
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
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
