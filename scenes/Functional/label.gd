extends Label

# ========== Constants ==========

# ========== Variables ==========

# ========== Methods ==========

# ========== Helpers ==========

# ========== Godot Runtime ==========


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreBus.game_over.connect(_on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_game_over(_f) -> void:
	text = "Score: %s" % ScoreBus.get_player_score()
