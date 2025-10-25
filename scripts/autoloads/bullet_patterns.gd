extends Node

const DEFAULT_RADIANS: float = PI

var fake_speed: int
var bullet_speed:int
var difficulty: String

signal attack_ended

func update_difficulty():
	difficulty = GlobalFlagManager.difficulty
	if difficulty == GlobalConstants.EASY:
		fake_speed = GlobalConstants.BALL_SPEED_EASY
		bullet_speed = GlobalConstants.BALL_SPEED_EASY
	if difficulty == GlobalConstants.MEDIUM:
		fake_speed = GlobalConstants.BALL_SPEED_MEDIUM
		bullet_speed = GlobalConstants.BALL_SPEED_MEDIUM
	if difficulty == GlobalConstants.HARD:
		fake_speed = GlobalConstants.BALL_SPEED_HARD
		bullet_speed = GlobalConstants.BALL_SPEED_HARD
	if difficulty == GlobalConstants.INSANE:
		fake_speed = GlobalConstants.BALL_SPEED_INSANE
		bullet_speed = GlobalConstants.BALL_SPEED_INSANE

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

func create_burst_pattern(ball_type:String, ball_spawn_position: Vector2, number_of_projectiles: int = 5, main_ball = null):
	update_difficulty()
	var real_ball: int = 1
	var total_projectiles: int = number_of_projectiles + real_ball
	var real_ball_index: int = randi_range(0, number_of_projectiles)
	
	var total_rotation: float = 3 * PI / 4
	var starting_rotation: float = 11 * PI / 4
	var current_rotation = starting_rotation/ 2
	var increment: float = total_rotation / (number_of_projectiles)
	for index in range(total_projectiles):
		if index != real_ball_index:
			BallManager.get_ball_from_pool(ball_type, ball_spawn_position, current_rotation, fake_speed)
			current_rotation -= increment
		elif index == real_ball_index and main_ball:
			var ball_direction: float = current_rotation
			main_ball.position = ball_spawn_position
			main_ball._set_temp_speed(fake_speed)
			main_ball.velocity = Vector2.from_angle(ball_direction) * main_ball.speed
			current_rotation -= increment
	attack_ended.emit()
			
func create_straight_line_rapid_fire(ball_type: String, shooter, rate_of_fire: float, number_of_projectiles: int = 5, clearance: int = 15, main_ball = null):
	update_difficulty()
	if main_ball:
		main_ball.process_mode = Node.PROCESS_MODE_DISABLED
		main_ball.position = Vector2(999999,999999)
	var ball_spawn_position: Vector2
	for projectile in range(number_of_projectiles): 
		print(projectile)
		while get_tree().paused:
			await get_tree().process_frame
		if is_instance_valid(shooter):
			var ball_spawn_position_x = shooter.position.x - clearance
			var ball_spawn_position_y = shooter.position.y
			ball_spawn_position = Vector2(ball_spawn_position_x, ball_spawn_position_y)
			BallManager.get_ball_from_pool(ball_type, ball_spawn_position, DEFAULT_RADIANS, bullet_speed)
			var timer = Timer.new()
			add_child(timer)
			timer.process_mode = Node.PROCESS_MODE_PAUSABLE
			timer.wait_time = 1 / rate_of_fire
			timer.start()
			await timer.timeout
	if main_ball:
		main_ball.process_mode = Node.PROCESS_MODE_PAUSABLE
		main_ball.position = ball_spawn_position
		print(main_ball.position)
		main_ball.velocity = Vector2.from_angle(DEFAULT_RADIANS) * bullet_speed
	attack_ended.emit()
