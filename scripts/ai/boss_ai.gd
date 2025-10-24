extends CharacterBody2D

# ========== Constants ==========

const type: String = "paddle"
const Y_TARGET_ZONE: float = 20.0
const PASSIVE_THROTTLE: float = 0.3
const ATTACK_THROTTLE: float = 0.75

const FAKE_ATTACKS_TO_LAUNCH: int = 2
const BULLET_ATTACKS_TO_LAUNCH: int = 1
const STEALTH_ATTACKS_TO_LAUNCH: int = 4

const FAKE_ATTACK_THRESHOLD: float = 5.0
const BULLET_ATTACK_THRESHOLD: float = 8.0
const STEALTH_ATTACK_THRESHOLD: float = 2.0

const FAKE_STYLE: String = "Fake Ball"
const BULLET_STYLE: String = "Bullet Ball"
const STEALTH_STYLE: String = "Stealth Ball"

const FAKE_COLOR: Color = Color.GREEN
const BULLET_COLOR: Color = Color.RED
const STEALTH_COLOR: Color = Color.BLUE


# ========== Variables ==========

# ---------- On Ready ----------

@onready var ball: CharacterBody2D = get_node("../../Projectiles/Ball")
@onready var player: CharacterBody2D = get_node("../Player Paddle (Left)")
@onready var screen_width: float  = get_viewport_rect().size.x
@onready var screen_height: float  = get_viewport_rect().size.y

# ---------- Export ----------

@export_enum("Left", "Right") var side: String = "Right"
@export_enum("Boss", "Survival") var mode: String = "Boss"

# ---------- Variables ----------
var ball_dangerous: float = false
var ball_dangerous_throttle: float = 1.0

var current_attack_style: String = FAKE_STYLE
var last_attack_style: String = STEALTH_STYLE
var current_color: Color = FAKE_COLOR
var attack_style_color: Color = FAKE_COLOR
var special_attack_threshold: float = FAKE_ATTACK_THRESHOLD

var acceptable_travel_delay: float = .5
var can_launch_stealth_ball: bool = false

var fake_health: int = GlobalConstants.FAKE_LIVES
var bullet_health: int = GlobalConstants.BULLET_LIVES
var stealth_health: int = GlobalConstants.STEALTH_LIVES

var attacks_launched: int = 0

var x_pos_home: float = position.x
var scalar_speed: int = 600
var outside_throttle: float = 1.0
var bounce_vector: Vector2 = Vector2.ZERO
var ai_bounce_count: int = 0
var direction: int = 1
var special_attack_charge: float = ai_bounce_count / special_attack_threshold

signal boss_attack_status(special_attack_charge: float, attack_style_color: Color)
signal stealth_attack_ended()
signal change_color(attack_style_color: Color)
signal boss_hit(mode: String)

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
	

func launch_special_attack():
	var ball_spawn_position_x = position.x - GlobalConstants.SHOT_CLEARANCE
	var ball_spawn_position_y = position.y
	var ball_spawn_position = Vector2(ball_spawn_position_x, ball_spawn_position_y)

	if current_attack_style == FAKE_STYLE:
		BulletPatterns.create_burst_pattern(
			"Fake Ball", 
			ball_spawn_position, 
			GlobalConstants.BOSS_FAKE_BALL_AMOUNT, 
			ball,
			)

	elif current_attack_style == BULLET_STYLE:
		BulletPatterns.create_straight_line_rapid_fire(
			"Bullet Ball", 
			self, 
			GlobalConstants.BOSS_RAPID_FIRE_RATE, 
			GlobalConstants.BOSS_RAPID_FIRE_AMOUNT, 
			GlobalConstants.SHOT_CLEARANCE, 
			ball,
			)

	elif current_attack_style == STEALTH_STYLE:
		BallManager.get_ball_from_pool(
			"Stealth Ball", 
			ball_spawn_position, 
			PI, 
			GlobalConstants.BOSS_STEALTH_BALL_SPEED
			)
		stealth_attack_ended.emit()
	
	attacks_launched += 1
	ai_bounce_count = 0
	
	_determine_attack_style()

# ========== Fake Specific Methods ==========

# ========== Bullet Specific Methods ==========

func swap_directions_if_valid():
	if position.y < 65:
		direction = -1
	elif position.y > 655:
		direction = 1

func oscillate_movement(overall_throttle: float = 1.0) -> void:
	swap_directions_if_valid()
	velocity.y = -direction * scalar_speed * overall_throttle

# ========== Stealth Specific Methods ==========

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

# ========== Conditionals  ==========

func _enforce_home_x() -> void:
	if position.x != x_pos_home:
		position.x = x_pos_home

func can_special_attack() -> bool:
	if ai_bounce_count >= special_attack_threshold:
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
	
## Determine elligible attack style, previous attack style only has 25% of triggering
func _determine_attack_style(dead: bool = false, initial_check: bool = false) -> void:
	if initial_check:
		var d_three_roll = randi_range(1, 3)
		if d_three_roll == 1:
			current_attack_style = FAKE_STYLE
		if d_three_roll == 2:
			current_attack_style = BULLET_STYLE
		if d_three_roll == 3:
			current_attack_style = STEALTH_STYLE
	else:
		if not dead:
			if current_attack_style == FAKE_STYLE and attacks_launched < FAKE_ATTACKS_TO_LAUNCH:
				if fake_health >= 0:
					return
			if current_attack_style == BULLET_STYLE and attacks_launched < BULLET_ATTACKS_TO_LAUNCH:
				if bullet_health >= 0:
					return
			if current_attack_style == STEALTH_STYLE and attacks_launched < STEALTH_ATTACKS_TO_LAUNCH:
				if stealth_health >= 0:
					return
				
		var available_styles: Array = [FAKE_STYLE, BULLET_STYLE, STEALTH_STYLE]
		if fake_health <= 0:
			available_styles.erase(FAKE_STYLE)
		if bullet_health <= 0:
			available_styles.erase(BULLET_STYLE)
		if stealth_health <= 0:
			available_styles.erase(STEALTH_STYLE)
		
		var elligble_styles: Array[String] = []
		# Array arrangement chances: [75%, 25%]
		if current_attack_style == FAKE_STYLE and last_attack_style == BULLET_STYLE:
			elligble_styles = [STEALTH_STYLE, BULLET_STYLE]
		elif current_attack_style == FAKE_STYLE and last_attack_style == STEALTH_STYLE:
			elligble_styles = [BULLET_STYLE, STEALTH_STYLE]
		elif current_attack_style == BULLET_STYLE and last_attack_style == STEALTH_STYLE:
			elligble_styles = [FAKE_STYLE, STEALTH_STYLE]
		elif current_attack_style == BULLET_STYLE and last_attack_style == FAKE_STYLE:
			elligble_styles = [STEALTH_STYLE, FAKE_STYLE]
		elif current_attack_style == STEALTH_STYLE and last_attack_style == BULLET_STYLE:
			elligble_styles = [FAKE_STYLE, BULLET_STYLE]
		elif current_attack_style == STEALTH_STYLE and last_attack_style == FAKE_STYLE:
			elligble_styles = [BULLET_STYLE, FAKE_STYLE]
		
		if FAKE_STYLE in elligble_styles and FAKE_STYLE not in available_styles:
			elligble_styles.erase(FAKE_STYLE)
		if BULLET_STYLE in elligble_styles and BULLET_STYLE not in available_styles:
			elligble_styles.erase(BULLET_STYLE)
		if STEALTH_STYLE in elligble_styles and STEALTH_STYLE not in available_styles:
			elligble_styles.erase(STEALTH_STYLE)
		
		
		if elligble_styles.size() > 1:
			var d_four_roll = randi_range(1, 4)
			var selection: int
			if d_four_roll <= 3:
				selection = 0
			else:
				selection = 1
			last_attack_style = current_attack_style
			current_attack_style = elligble_styles[selection]
		elif elligble_styles.size() == 0:
			return
		else:
			current_attack_style = elligble_styles[0]
		
	if current_attack_style == FAKE_STYLE:
		attack_style_color = FAKE_COLOR
	elif current_attack_style == BULLET_STYLE:
		attack_style_color = BULLET_COLOR
	elif current_attack_style == STEALTH_STYLE:
		attack_style_color = STEALTH_COLOR

	if current_attack_style == FAKE_STYLE:
		special_attack_threshold = FAKE_ATTACK_THRESHOLD
	elif current_attack_style == BULLET_STYLE:
		special_attack_threshold = BULLET_ATTACK_THRESHOLD
	elif current_attack_style == STEALTH_STYLE:
		special_attack_threshold = STEALTH_ATTACK_THRESHOLD

	attacks_launched = 0
# ========== Helper ==========

func _change_color() -> void:
	change_color.emit(attack_style_color)
	current_color = attack_style_color

# ========== Godot Runtime ==========

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball.ball_dangerous.connect(_on_ball_dangerous)
	ball.ball_not_dangerous.connect(_on_ball_not_dangerous)
	ball.hit_ai_paddle.connect(_on_ball_hit_ai_paddle)
	ball.hit_player_paddle.connect(_on_ball_hit_player_paddle)
	ball.goal_scored.connect(_on_goal_scored)
	_determine_attack_style(false, true)
	_change_color()
	if side == "Left":
		bounce_vector = Vector2(1, 0)
	if side == "Right":
		bounce_vector = Vector2(-1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if can_special_attack() and not current_attack_style == STEALTH_STYLE:
		launch_special_attack()
	if _is_ball_visible():
		if _is_threatened_by_ball():
			track_and_match_entity(ball, 1.0)
		else:
			track_and_match_entity(ball, PASSIVE_THROTTLE)
	else:
		oscillate_movement(ATTACK_THROTTLE)
	move_and_slide()
	_enforce_home_x()

# ========== Callbacks ==========

func _calc_special_attack_status() -> void:
	special_attack_charge = float(ai_bounce_count / special_attack_threshold)

func _on_ball_hit_ai_paddle() -> void:
	ai_bounce_count += 1
	_calc_special_attack_status()
	boss_attack_status.emit(special_attack_charge, attack_style_color)

func _on_ball_hit_player_paddle() -> void:
	if current_attack_style == STEALTH_STYLE:
		_can_launch_stealth_ball()
		if can_special_attack() and can_launch_stealth_ball:
			launch_special_attack()
	if current_color != attack_style_color:
		_change_color()
		
func _on_goal_scored(score_side: String):
	if mode == "Boss":
		if score_side == "Right":
			if current_attack_style == FAKE_STYLE:
				fake_health -= 1
				boss_hit.emit("Fake")
				if fake_health <= 0:
					_determine_attack_style(true)
					_change_color()
					ai_bounce_count = 0
					boss_attack_status.emit(0, attack_style_color)
			elif current_attack_style == BULLET_STYLE:
				bullet_health -= 1
				boss_hit.emit("Bullet")
				if bullet_health <= 0:
					_determine_attack_style(true)
					_change_color()
					ai_bounce_count = 0
					boss_attack_status.emit(0, attack_style_color)
			elif current_attack_style == STEALTH_STYLE:
				stealth_health -= 1
				boss_hit.emit("Stealth")
				if stealth_health <= 0:
					_determine_attack_style(true)
					_change_color()
					ai_bounce_count = 0
					boss_attack_status.emit(0, attack_style_color)
					

func _on_ball_dangerous():
	ball_dangerous_throttle = GlobalConstants.BALL_DANGEROUS_THROTTLE

func _on_ball_not_dangerous():
	ball_dangerous_throttle = 1.0
