extends Node2D

@onready var player_score = $"HBoxContainer/Player Score"
@onready var ai_score = $"HBoxContainer/AI Score"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreBus.update_lives.connect(_on_update_lives)
	player_score.text = "0"
	ai_score.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_update_lives(player_lives: int, ai_lives: int):
	player_score.text = str(player_lives)
	ai_score.text = str(ai_lives)
