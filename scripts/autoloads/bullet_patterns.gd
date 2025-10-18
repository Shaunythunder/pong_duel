extends Node

const DEFAULT_BALL_SPEED: int = 500
const DEFAULT_RADIANS: float = 0

func create_shot_pattern(ball_type:String, ball_spawn_position: Vector2, number_of_projectiles: int = 5, main_ball = null):
	for index in range(number_of_projectiles):
		var direction: float = randf_range(3 * PI / 8, -3 * PI / 8)
		var projectile_ball = BallManager.get_ball_from_pool(ball_type, ball_spawn_position, direction)
		if index == number_of_projectiles - 1:
			main_ball.speed = projectile_ball.speed
	if main_ball:
		var ball_direction: float = randf_range(3 * PI / 8, -3 * PI / 8)
		main_ball.position = ball_spawn_position
		main_ball.velocity = Vector2.from_angle(ball_direction) * DEFAULT_BALL_SPEED
	
func create_burst_pattern(ball_type:String, ball_spawn_position: Vector2, number_of_projectiles: int = 5, main_ball = null):
	var real_ball: int = 1
	var total_projectiles: int = number_of_projectiles + real_ball
	var real_ball_index: int = randi_range(0, number_of_projectiles)
	
	var total_rotation: float = 6 * PI / 8
	var current_rotation = total_rotation / 2
	var increment: float = total_rotation / (number_of_projectiles)
	
	for index in range(total_projectiles):
		if index != real_ball_index:
			BallManager.get_ball_from_pool(ball_type, ball_spawn_position, current_rotation, DEFAULT_BALL_SPEED)
			current_rotation -= increment
			print(current_rotation)
		elif index == real_ball_index and main_ball:
			var ball_direction: float = current_rotation
			main_ball.position = ball_spawn_position
			main_ball.velocity = Vector2.from_angle(ball_direction) * DEFAULT_BALL_SPEED
			current_rotation -= increment
			
func create_straight_line_rapid_fire(ball_type:String, shooter, rate_of_fire: float, number_of_projectiles: int = 5, clearance: int = 15, main_ball = null):
	if main_ball:
		main_ball.process_mode = Node.PROCESS_MODE_DISABLED
		main_ball.position = Vector2(999999,999999)
	var ball_spawn_position: Vector2
	for pojectile in range(number_of_projectiles): 
		var ball_spawn_position_x = shooter.position.x + clearance
		var ball_spawn_position_y = shooter.position.y
		ball_spawn_position = Vector2(ball_spawn_position_x, ball_spawn_position_y)
		BallManager.get_ball_from_pool(ball_type, ball_spawn_position, DEFAULT_RADIANS, DEFAULT_BALL_SPEED)
		await get_tree().create_timer(rate_of_fire / 1000.0).timeout
	if main_ball:
		main_ball.process_mode = Node.PROCESS_MODE_PAUSABLE
		main_ball.position = ball_spawn_position
		print(main_ball.position)
		main_ball.velocity = Vector2.from_angle(DEFAULT_RADIANS) * DEFAULT_BALL_SPEED
