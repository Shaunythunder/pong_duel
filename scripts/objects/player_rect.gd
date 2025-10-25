extends ColorRect

# ========== Constants ==========

# ========== Variables ==========

# ========== Methods ==========

# ========== Helpers ==========

# ========== Godot Runtime ==========


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_color = GlobalFlagManager.global_flags["player_color"]
	print(new_color)
	if new_color is not Color:
		color = str_to_var("Color%s" % new_color)
	else:
		color = new_color
	print(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
