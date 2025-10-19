extends CharacterBody2D

# ========== Constants ==========

const type: String = "paddle"
const Y_TARGET_ZONE: float = 20.0
const PASSIVE_THROTTLE: float = 0.3
const ATTACK_THROTTLE: float = 0.75
const SPECIAL_ATTACK_THRESHOLD: float = 5.0

# ========== Variables ==========

# ---------- On Ready ----------

@onready var ball: CharacterBody2D = get_node("../../Projectiles/Ball")
@onready var player: CharacterBody2D = get_node("../Player Paddle (Left)")
@onready var screen_width: float  = get_viewport_rect().size.x
@onready var screen_height: float  = get_viewport_rect().size.y

# ---------- Export ----------

@export_enum("Left", "Right") var side: String = "Right"

# ---------- Variables ----------
var ball_dangerous: float = false
var ball_dangerous_throttle: float = 1.0

var time_of_last_player_hit: float = 0
var acceptable_travel_delay: float = 0.5
var can_launch_stealth_ball: bool = false


var x_pos_home: float = position.x
var scalar_speed: int = 600
var outside_throttle: float = 1.0
var bounce_vector: Vector2 = Vector2.ZERO
var ai_bounce_count: int = 0
var direction: int = 1
var special_attack_charge: float = ai_bounce_count / SPECIAL_ATTACK_THRESHOLD

signal special_attack_status(special_attack_charge: float)
signal attack_ended()

# ========== Methods ==========

func track_and_match_entity(entity: CharacterBody2D, overall_throttle: float = 1.0) -> void:
	var entity_pos_y: float = entity.position.y
	var distance_to_entity: float = entity_pos_y - position.y
	var percent_throttle: float = abs(entity_pos_y - position.y) / 50.0
	if percent_throttle > 1.0:
		percent_throttle = 1.0

	if abs(distance_to_entity) >= Y_TARGET_ZONE:
		velocity.y = entity.velocity.y

	var _direction = sign(distance_to_entity)
	velocity.y = _direction * scalar_speed * percent_throttle * overall_throttle * ball_dangerous_throttle

func _can_launch_stealth_ball() -> bool:
	var speed_mulitplier: float = GlobalConstants.BALL_BOUNCE_SPEED_MULITPLIER
	var stealth_ball_speed: float = GlobalConstants.STEALTH_BALL_SPEED
	var player_x: float = player.position.x
	var ai_x: float = position.x
	var distance_x: float = abs(player_x - ai_x)
	var ball_velocity_x: float = abs(ball.velocity.x)
	var time_to_next_player_hit: float = distance_x / ball_velocity_x + distance_x / (ball_velocity_x * speed_mulitplier)
	var stealth_ball_travel_time: float = distance_x/stealth_ball_speed
	var time_difference: float = abs(time_to_next_player_hit - stealth_ball_travel_time)

	if time_difference > acceptable_travel_delay:
		can_launch_stealth_ball = true
		return true
	else:
		can_launch_stealth_ball = false
		return false
	
func oscillate_movement(overall_throttle: float = 1.0) -> void:
	swap_directions_if_valid()
	velocity.y = -direction * scalar_speed * overall_throttle

func launch_special_attack():
		var ball_spawn_position_x = position.x - GlobalConstants.SHOT_CLEARANCE
		var ball_spawn_position_y = position.y
		var ball_spawn_position = Vector2(ball_spawn_position_x, ball_spawn_position_y)
		BallManager.get_ball_from_pool("Stealth Ball", ball_spawn_position, PI, GlobalConstants.STEALTH_BALL_SPEED)
		attack_ended.emit()
		ai_bounce_count = 0

# ========== Conditionals  ==========
func swap_directions_if_valid():
	if position.y < 65:
		direction = -1
	elif position.y > 655:
		direction = 1

func _enforce_home_x() -> void:
	if position.x != x_pos_home:
		position.x = x_pos_home

func can_special_attack() -> bool:
	if ai_bounce_count >= SPECIAL_ATTACK_THRESHOLD:
		return true
	return false
	
func _is_ball_visible() -> bool:
	if ball:
		var ball_x_pos: float = ball.position.x
		var ball_y_pos: float = ball.position.y
		if ball:
			if ball_x_pos > screen_width or ball_x_pos < 0:
				return false
			if ball_y_pos < 0 or ball_y_pos > screen_height:
				return false
			return true
	return false
	
func _is_threatened_by_ball() -> bool:
	var ball_direction: float = ball.velocity.x
	if side == "Left" and ball_direction < 0 or ball.position.x > position.x + 300:
		return true
	elif side == "Right" and ball_direction > 0 or ball.position.x > position.x - 300:
		return true
	return false
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball.ball_dangerous.connect(_on_ball_dangerous)
	ball.ball_not_dangerous.connect(_on_ball_not_dangerous)
	ball.hit_ai_paddle.connect(_on_ball_hit_ai_paddle)
	ball.hit_player_paddle.connect(_on_ball_hit_player_paddle)
	if side == "Left":
		bounce_vector = Vector2(1, 0)
	if side == "Right":
		bounce_vector = Vector2(-1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _is_ball_visible():
		if _is_threatened_by_ball():
			track_and_match_entity(ball, 1.0)
		else:
			track_and_match_entity(ball, PASSIVE_THROTTLE)
	move_and_slide()
	_enforce_home_x()

# ========== Callbacks ==========

func _calc_special_attack_status() -> void:
	special_attack_charge = float(ai_bounce_count / SPECIAL_ATTACK_THRESHOLD)

func _on_ball_hit_ai_paddle() -> void:
	ai_bounce_count += 1
	_calc_special_attack_status()
	special_attack_status.emit(special_attack_charge)

func _on_ball_hit_player_paddle() -> void:
	_can_launch_stealth_ball()
	if can_special_attack() and can_launch_stealth_ball:
		launch_special_attack()

func _on_ball_dangerous():
	ball_dangerous_throttle = GlobalConstants.BALL_DANGEROUS_THROTTLE

func _on_ball_not_dangerous():
	ball_dangerous_throttle = 1.0

