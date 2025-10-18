extends CharacterBody2D

# ========== Constants ==========


const JOSTLE_DIVIDER: int = 24
const DEBUG_RADIANS: float = PI/2
const BALL_ADJUST: float = 0.4
const PUSH_DISTANCE: int = 5

# ========== Variables ==========

# ---------- Exports ----------
@export_group("Attributes")

@export_subgroup("Speed Attributes")
@export var max_speed: float = 1400.0
@export var speed_bounce_multiplier: float = 1.05

@export_subgroup("Rendering Attributes")
@export var default_color: Color = Color.WHITE
@export var goal_change_color: Color = Color.GREEN
@export_range(4, 16) var default_radius: int = 6

@export_subgroup("Behavior Toggles")
@export_enum("Real Ball", "Fake Ball", "Bullet Ball", "Stealth Ball") var type: String = "Real Ball" 
@export var paddle_jostle: bool = true
@export var wall_jostle: bool = true
@export var score_on_goal: bool = true
@export var is_projectile: bool = false
@export var terminate_on_goal: bool = false
@export var terminate_on_paddle_bounce: bool = false
@export var terminate_on_out_of_bounds: bool = false
@export var change_color_near_shooter: bool = false
@export var paddle_no_clip: bool = false
@export var stealthy: bool = false

# ---------- Internals ----------

var screen: Vector2 
var screen_width: float 
var screen_height: float
var home_coords: Vector2 
var is_pooled: bool = true

var initial_speed: float = 800.0
var speed: float = 800.0
var ball_radius: int
var color: Color

# ========== Label ==========

signal goal_scored() #TODO: side
signal hit_player_paddle()

# ========== Methods ==========

func handle_collision(collision_obj: Node) -> void:
	var pre_bounce_vector: Vector2
	var post_bounce_vector: Vector2
	if collision_obj.type == "wall":
		pre_bounce_vector = collision_obj.bounce_vector
		if collision_obj.side == "Top" or collision_obj.side == "Bottom":
			post_bounce_vector = velocity.bounce(pre_bounce_vector).normalized()
			_push_away_after_bounce(post_bounce_vector)
			velocity = post_bounce_vector
			_nudge_radians()
			if wall_jostle:
				jostle_rad_paddle_hit()
		else:
			if score_on_goal:
				emit_signal("goal_scored")
			if not terminate_on_goal:
				_ball_reset()
			else:
				BallManager.return_ball_to_pool(self)
			
	elif collision_obj.type == "paddle":
		if collision_obj.side == "Left":
			hit_player_paddle.emit()
		if terminate_on_paddle_bounce:
			BallManager.return_ball_to_pool(self)
		if paddle_no_clip:
			var children = self.get_children()
			for child in children:
				if child is CollisionShape2D:
					toggle_physics(child)
					return
		pre_bounce_vector = collision_obj.bounce_vector
		pre_bounce_vector = _determine_paddle_bounce(collision_obj)
		post_bounce_vector = velocity.bounce(pre_bounce_vector).normalized()
		_push_away_after_bounce(post_bounce_vector)
		
		increase_speed_after_bounce()
		velocity = post_bounce_vector
		if paddle_jostle:
			jostle_rad_paddle_hit()
	_calc_velocity()
		
# ---------- Radian Methods ----------

func _calc_valid_direction() -> float:
	var options: Array = ["Left", "Right"]
	var direction: String = options[randi_range(0, 1)]
	var radians: float 
	if direction == "Left":
		radians = randf_range((6 * PI)/8, (10 * PI)/8)
	elif direction == "Right":
		radians = randf_range((-2 * PI)/8, (2 * PI)/8)
	return radians
	
func _nudge_radians() -> void:
	var left_radians: Array = [(6 * PI)/8, (10 * PI)/8]
	var right_radians: Array = [(-2 * PI)/8, (2 * PI)/8]
	var radians: float = 0
	if radians < PI and radians > right_radians[1]:
		radians -= BALL_ADJUST
	if radians > PI and radians > left_radians[0]:
		radians -= BALL_ADJUST
	if radians < 2 * PI and radians > left_radians[1]:
		radians -= BALL_ADJUST
	if radians > 0 and radians > right_radians[0]:
		radians -= BALL_ADJUST
	_calc_velocity()
	
func jostle_rad_wall_hit() -> float:
	var shift: float = randf_range(0, 1 * PI/JOSTLE_DIVIDER)
	velocity = velocity.rotated(shift)
	return shift
	
func jostle_rad_paddle_hit() -> float:
	var shift: float = randf_range(0, 2 * PI/JOSTLE_DIVIDER)
	velocity = velocity.rotated(shift)
	return shift

# ---------- Velocity Methods ----------

func enforce_min_speed() -> void:
	if speed < initial_speed:
		speed = initial_speed
		_calc_velocity()
		
func increase_speed_after_bounce() -> void:
	speed = speed * speed_bounce_multiplier
	_calc_velocity()

func _push_away_after_bounce(bounce_vector: Vector2) -> void:
	position += bounce_vector * PUSH_DISTANCE
	
func _calc_velocity() -> void:
	velocity = velocity.normalized() * speed
	
# ========== Helpers ==========

func _determine_paddle_bounce(collision_obj) -> Vector2:
	var bounce_vector: Vector2 = collision_obj.bounce_vector
	var collision_point: Vector2 = collision_obj.to_local(position)
	var shape: Shape2D = null
	for child_node in collision_obj.get_children():
		if child_node is CollisionShape2D:
			shape = child_node.shape
			break
	if shape is RectangleShape2D:
		# Check if ball hit the top or bottom side
		var half_height: float = shape.size.y / 2.0
		var half_width: float = shape.size.x / 2.0
		var tolerance: float = .98
		if abs(collision_point.x) > half_width * tolerance:
			# Hit side of paddle
			var x_sign: int = sign(collision_point.x)
			bounce_vector = Vector2(x_sign, 0)
			
		elif abs(collision_point.y) > half_height * tolerance:
			# Hit top or bottom of paddle
			var y_sign: int = sign(collision_point.y)
			bounce_vector = Vector2(0, y_sign)
	return bounce_vector
	
func change_color(new_color: Color = default_color):
	color = new_color
	
func change_radius(new_radius: int = default_radius):
	ball_radius = new_radius
	
func toggle_physics(physics_object: CollisionShape2D):
	physics_object.disabled = not physics_object.disabled

func _can_reveal_true_nature() -> bool:
	if position.x < 350:
		return true
	elif position.x > 930:
		return true
	return false
	
func _is_out_of_bounds() -> bool:
	var ball_x_pos: float = position.x
	var ball_y_pos: float = position.y
	if ball_x_pos > screen_width or ball_x_pos < 0:
		return true
	if ball_y_pos < 0 or ball_y_pos > screen_height:
		return true
	return false

func _ball_reset() -> void:
	position = home_coords
	speed = initial_speed
	if not is_projectile:
		var direction: float = _calc_valid_direction()
		velocity = Vector2.from_angle(direction) * speed
	change_color()
	change_radius()

# ========== Godot Runtime ==========

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect().size
	screen_width = screen.x
	screen_height = screen.y
	home_coords = Vector2(screen_width/2, screen_height/2)
	change_color()
	_ball_reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _is_out_of_bounds():
		BallManager.return_ball_to_pool(self)
	var attribute_changed: bool = false
	if _can_reveal_true_nature() and change_color_near_shooter and position.x > 930:
		change_color(goal_change_color)
		attribute_changed = true
	elif stealthy:
		if _can_reveal_true_nature():
			change_radius()
			attribute_changed = true
		else:
			change_radius(0)
			attribute_changed = true
	if color != default_color and not attribute_changed:
			change_color()
			attribute_changed = true
	if attribute_changed:
		queue_redraw()
			
	var delta_velocity: Vector2 = velocity * delta
	var collision = move_and_collide(delta_velocity)
	if collision:
		var collision_obj = collision.get_collider()
		handle_collision(collision_obj)
		
func _draw() -> void:
	draw_circle(Vector2.ZERO, ball_radius, color)
