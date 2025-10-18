extends CharacterBody2D

# ========== Constants ==========

const type = "paddle"
const INACTIVE = "inactive"

# ========== Variables ==========

@export_category("Object Variables")

@export_range(600, 1000) var speed: int = 800
@export_enum("Left", "Right") var side: String = "Left"

@export var move_down_action: String = "move_down"
@export var move_up_action: String = "move_up"

var bounce_vector: Vector2 = Vector2.ZERO
var x_pos_home: float = position.x

# ========== Methods ==========

func get_player_input():
	var player_input_vector = Input.get_vector(INACTIVE, INACTIVE, move_up_action, move_down_action)
	velocity = player_input_vector * speed
	
func force_x_pos():
	if position.x != x_pos_home:
		position.x = x_pos_home
	
# ========== Godot Runtime ==========
func _ready() -> void:
	if side == "Left":
		bounce_vector = Vector2(1, 0)
	if side == "Right":
		bounce_vector = Vector2(-1, 0)

func _physics_process(_delta: float) -> void:
	get_player_input()
	force_x_pos()
	move_and_slide()
