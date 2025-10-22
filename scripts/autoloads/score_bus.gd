extends Node

const PLAYER: String = "Player"
const AI: String = "AI"

var player_lives: int = 0
var ai_lives: int = 0

signal game_over(winner: String)
signal update_lives(player_lives: int, ai_lives: int)

func initialize_lives(player_lives_amount: int, ai_lives_amount: int):
	player_lives = player_lives_amount
	ai_lives = ai_lives_amount
	update_lives.emit(player_lives, ai_lives)
	
func player_scored():
	ai_lives -= 1
	update_lives.emit(player_lives, ai_lives)
	if ai_lives == 0:
		game_over.emit(PLAYER)
		
func player_scored_survival():
	ai_lives += 1
	update_lives.emit(player_lives, ai_lives)
	
func get_player_score() -> int:
	return ai_lives
	
func ai_scored():
	player_lives -= 1
	update_lives.emit(player_lives, ai_lives)
	if player_lives == 0:
		print("Game Over!")
		game_over.emit(AI)
	

func _on_tree_changed() -> void:
	player_lives = 0
	ai_lives = 0
	update_lives.emit(player_lives, ai_lives)
