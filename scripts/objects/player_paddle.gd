extends CharacterBody2D

# ========== Constants ==========

const type: String = "paddle"
const INACTIVE: String = "inactive"
const PLAYER_BOOST_MODIFIER: float = 1.75
const PLAYER_SLOW_MODIFIER: float = 0.5
const PLAYER_DISTANCE_TO_CLEAR: int = 15

# ========== Variables ==========
@onready var ball: CharacterBody2D = get_node("../../Projectiles/Ball")

@export_category("Object Variables")

@export_range(600, 1000) var speed: int = 800
@export_enum("Left", "Right") var side: String = "Left"

@export var move_down_action: String = "move_down"
@export var move_up_action: String = "move_up"
@export var boost_action: String = "boost"
@export var spawn_fake_ball: String = "spawn_fake_ball"
@export var spawn_bullet_ball: String = "spawn_bullet_ball"
@export var spawn_stealth_ball: String = "spawn_stealth_ball"

var bounce_vector: Vector2 = Vector2.ZERO
var x_pos_home: float = position.x
var boost_factor: float = 1.0
var mouse_mode: bool

# ========== Methods ==========

func get_player_move_input():
	if mouse_mode:
		var mouse_y_pos: float = get_global_mouse_position().y
		if mouse_y_pos < 40:
			mouse_y_pos = 40
		if mouse_y_pos > 680:
			mouse_y_pos = 680
		position.y = mouse_y_pos
		return
	var player_boosting: bool = Input.is_action_pressed("boost")
	var player_slowing_down: bool = Input.is_action_pressed("slow_down")
	if player_boosting:
		boost_factor = PLAYER_BOOST_MODIFIER
	elif player_slowing_down:
		boost_factor = PLAYER_SLOW_MODIFIER
	else: 
		boost_factor = 1.0
	var player_input_vector = Input.get_vector(INACTIVE, INACTIVE, move_up_action, move_down_action)
	velocity = player_input_vector * speed * boost_factor

func force_x_pos():
	if position.x != x_pos_home:
		position.x = x_pos_home
	
# ========== Godot Runtime ==========
func _ready() -> void:
	mouse_mode = GlobalFlagManager.global_flags["mouse_enabled"]
	if side == "Left":
		bounce_vector = Vector2(1, 0)
	if side == "Right":
		bounce_vector = Vector2(-1, 0)

func _physics_process(_delta: float) -> void:
	get_player_move_input()
	move_and_slide()
	force_x_pos()
