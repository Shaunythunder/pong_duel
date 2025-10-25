extends CharacterBody2D

# ========== Constants ==========

const type: String = "paddle"
const Y_TARGET_ZONE: float = 20.0
const PASSIVE_THROTTLE: float = 0.3
const SPECIAL_ATTACK_THRESHOLD: float = 8.0

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
var ball_dangerous_throttle_default: float


var x_pos_home: float = position.x
var scalar_speed: int = 600
var outside_throttle: float = 1.0
var bounce_vector: Vector2 = Vector2.ZERO
var ai_bounce_count: int = 0
var direction: int = 1
var special_attack_charge: float = ai_bounce_count / SPECIAL_ATTACK_THRESHOLD
var difficulty: String

var attack_throttle: float
var rapid_fire_rate: int
var rapid_fire_amount: int

signal special_attack_status(special_attack_charge: float)

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
	
func oscillate_movement(overall_throttle: float = 1.0) -> void:
	swap_directions_if_valid()
	velocity.y = -direction * scalar_speed * overall_throttle

func launch_special_attack():
	BulletPatterns.create_straight_line_rapid_fire("Bullet Ball", self, rapid_fire_rate, rapid_fire_amount, GlobalConstants.SHOT_CLEARANCE, ball)
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
	
func set_difficulty_weights():
	if difficulty == GlobalConstants.EASY:
		scalar_speed = GlobalConstants.BULLET_PADDLE_SPEED_EASY
		ball_dangerous_throttle_default = GlobalConstants.BALL_DANGEROUS_THROTTLE_EASY
		attack_throttle = GlobalConstants.ATTACK_THROTTLE_EASY
		rapid_fire_amount = GlobalConstants.RAPID_FIRE_AMOUNT_EASY
		rapid_fire_rate =  GlobalConstants.RAPID_FIRE_RATE_EASY
	elif difficulty == GlobalConstants.MEDIUM:
		scalar_speed = GlobalConstants.BULLET_PADDLE_SPEED_MEDIUM
		ball_dangerous_throttle_default = GlobalConstants.BALL_DANGEROUS_THROTTLE_MEDIUM
		attack_throttle = GlobalConstants.ATTACK_THROTTLE_MEDIUM
		rapid_fire_amount = GlobalConstants.RAPID_FIRE_AMOUNT_MEDIUM
		rapid_fire_rate =  GlobalConstants.RAPID_FIRE_RATE_MEDIUM
	elif difficulty == GlobalConstants.HARD:
		scalar_speed = GlobalConstants.BULLET_PADDLE_SPEED_HARD
		ball_dangerous_throttle_default = GlobalConstants.BALL_DANGEROUS_THROTTLE_HARD
		attack_throttle = GlobalConstants.ATTACK_THROTTLE_HARD
		rapid_fire_amount = GlobalConstants.RAPID_FIRE_AMOUNT_HARD
		rapid_fire_rate =  GlobalConstants.RAPID_FIRE_RATE_HARD
	elif difficulty == GlobalConstants.INSANE:
		scalar_speed = GlobalConstants.BULLET_PADDLE_SPEED_INSANE
		ball_dangerous_throttle_default = GlobalConstants.BALL_DANGEROUS_THROTTLE_INSANE
		attack_throttle = GlobalConstants.ATTACK_THROTTLE_INSANE
		rapid_fire_amount = GlobalConstants.RAPID_FIRE_AMOUNT_INSANE
		rapid_fire_rate =  GlobalConstants.RAPID_FIRE_RATE_INSANE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	difficulty = GlobalFlagManager.difficulty
	set_difficulty_weights()
	ball.ball_dangerous.connect(_on_ball_dangerous)
	ball.ball_not_dangerous.connect(_on_ball_not_dangerous)
	ball.hit_ai_paddle.connect(_on_ball_hit_ai_paddle)
	if side == "Left":
		bounce_vector = Vector2(1, 0)
	if side == "Right":
		bounce_vector = Vector2(-1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if can_special_attack():
		launch_special_attack()
	if _is_ball_visible():
		if _is_threatened_by_ball():
			track_and_match_entity(ball, 1.0)
		else:
			track_and_match_entity(ball, PASSIVE_THROTTLE)
	else:
		oscillate_movement(attack_throttle)
	move_and_slide()
	_enforce_home_x()

# ========== Callbacks ==========

func _calc_special_attack_status() -> void:
	special_attack_charge = float(ai_bounce_count / SPECIAL_ATTACK_THRESHOLD)

func _on_ball_hit_ai_paddle() -> void:
	ai_bounce_count += 1
	_calc_special_attack_status()
	special_attack_status.emit(special_attack_charge)

func _on_ball_dangerous():
	ball_dangerous_throttle = ball_dangerous_throttle_default

func _on_ball_not_dangerous():
	ball_dangerous_throttle = 1.0
