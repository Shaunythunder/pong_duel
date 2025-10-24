extends Node2D

@onready var player_score = $"HBoxContainer/Player Score"
@onready var fake_score = $"HBoxContainer2/VBoxContainer/Fake Score"
@onready var bullet_score = $"HBoxContainer2/VBoxContainer/Bullet Score"
@onready var stealth_score = $"HBoxContainer2/VBoxContainer/Stealth Score"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreBus.update_lives.connect(_on_update_lives)
	ScoreBus.update_boss_lives.connect(_on_update_boss_lives)
	player_score.text = "0"
	fake_score.text = "0"
	bullet_score.text = "0"
	stealth_score.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_update_lives(player_lives: int, _ai_lives: int):
	player_score.text = str(player_lives)
	
func _on_update_boss_lives(fake_lives: int, bullet_lives: int, stealth_lives: int):
	fake_score.text = str(fake_lives)
	bullet_score.text = str(bullet_lives)
	stealth_score.text = str(stealth_lives)
