extends Node2D
@onready var bullet_ball = $"../../Bullet Ball"

# Called when the node enters the scene tree for the first time.
func _ready():
	var proto = bullet_ball # Access child directly
	var test_bullet = proto.duplicate()
	add_child(test_bullet)
	test_bullet.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
