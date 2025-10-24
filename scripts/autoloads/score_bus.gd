extends Node

const PLAYER: String = "Player"
const AI: String = "AI"

var player_lives: int = 0
var ai_lives: int = 0

var fake_lives: int = 0
var bullet_lives: int = 0
var stealth_lives: int = 0

var game_has_ended: bool = false

signal game_over(winner: String)
signal update_lives(player_lives: int, ai_lives: int)
signal update_boss_lives(fake_lives: int, bullet_lives: int, stealth_lives: int)

func initialize_lives(player_lives_amount: int, ai_lives_amount: int):
	player_lives = player_lives_amount
	ai_lives = ai_lives_amount
	update_lives.emit(player_lives, ai_lives)
	
func initialize_boss_lives(
	player_lives_amount: int, 
	fake_lives_amount: int,
	bullet_lives_amount: int,
	stealth_lives_amount: int,
	):
	player_lives = player_lives_amount
	fake_lives = fake_lives_amount
	bullet_lives = bullet_lives_amount
	stealth_lives = stealth_lives_amount
	update_lives.emit(player_lives, ai_lives)
	update_boss_lives.emit(fake_lives, bullet_lives, stealth_lives)
	
func boss_hit(mode: String):
	print()
	if mode == "Fake":
		fake_lives -= 1
	elif mode == "Bullet":
		bullet_lives -= 1
	elif mode == "Stealth":
		stealth_lives -= 1
	if fake_lives == 0 and bullet_lives == 0 and stealth_lives == 0:
		game_has_ended = true
		game_over.emit(PLAYER)
	update_boss_lives.emit(fake_lives, bullet_lives, stealth_lives)
		
func player_scored():
	ai_lives -= 1
	update_lives.emit(player_lives, ai_lives)
	if ai_lives == 0:
		game_has_ended = true
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
		game_has_ended = true
		game_over.emit(AI)

func _on_tree_changed() -> void:
	player_lives = 0
	ai_lives = 0
	update_lives.emit(player_lives, ai_lives)
