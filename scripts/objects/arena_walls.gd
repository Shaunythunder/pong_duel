extends StaticBody2D

# ========== Constants ==========

const type: String = "wall"

# ========== Variables ==========

@export_category("Side")

@export_enum("Top", "Bottom", "Left", "Right") var side: String = "Top"

var bounce_vector: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if side == "Top":
		bounce_vector = Vector2(0, 1)
	elif  side == "Left":
		bounce_vector = Vector2(1, 0)
	elif  side == "Right":
		bounce_vector = Vector2(-1, 0)
	elif  side == "Bottom":
		bounce_vector = Vector2(0, -1)
