# Godot v4.5.1
# Author: Shaunythunder

extends Control

# ========== Constants ==========

const DUEL_SCENE_PATH: String = "res://scenes/Game Scenes/Duel.tscn"
const HOW_TO_PLAY_SCENE_PATH: String = "res://scenes/Game Scenes/HowToPlay.tscn"

# ========== Godot Runtime ==========
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# ========== Button Callbacks ==========

## Change to Duel scene
func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file(DUEL_SCENE_PATH)

## Change to Duel scene
func _on_how_to_play_button_pressed() -> void:
	get_tree().change_scene_to_file(HOW_TO_PLAY_SCENE_PATH)
	
## Quit Game
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
