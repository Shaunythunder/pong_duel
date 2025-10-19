extends Node

const DEFAULT_BALL_SPEED: int = 700
const DEFAULT_RADIANS: float = PI

signal attack_ended

func create_burst_pattern(ball_type:String, ball_spawn_position: Vector2, number_of_projectiles: int = 5, main_ball = null):
	var real_ball: int = 1
	var total_projectiles: int = number_of_projectiles + real_ball
	var real_ball_index: int = randi_range(0, number_of_projectiles)
	
	var total_rotation: float = 3 * PI / 4
	var starting_rotation: float = 11 * PI / 4
	var current_rotation = starting_rotation/ 2
	var increment: float = total_rotation / (number_of_projectiles)
	for index in range(total_projectiles):
		if index != real_ball_index:
			BallManager.get_ball_from_pool(ball_type, ball_spawn_position, current_rotation, DEFAULT_BALL_SPEED)
			current_rotation -= increment
		elif index == real_ball_index and main_ball:
			var ball_direction: float = current_rotation
			main_ball.position = ball_spawn_position
			main_ball._set_temp_speed(DEFAULT_BALL_SPEED)
			main_ball.velocity = Vector2.from_angle(ball_direction) * main_ball.speed
			current_rotation -= increment
	attack_ended.emit()
			
func create_straight_line_rapid_fire(ball_type:String, shooter, rate_of_fire: float, number_of_projectiles: int = 5, clearance: int = 15, main_ball = null):
	if main_ball:
		main_ball.process_mode = Node.PROCESS_MODE_DISABLED
		main_ball.position = Vector2(999999,999999)
	var ball_spawn_position: Vector2
	for pojectile in range(number_of_projectiles): 
		var ball_spawn_position_x = shooter.position.x - clearance
		var ball_spawn_position_y = shooter.position.y
		ball_spawn_position = Vector2(ball_spawn_position_x, ball_spawn_position_y)
		BallManager.get_ball_from_pool(ball_type, ball_spawn_position, DEFAULT_RADIANS, GlobalConstants.RAPID_FIRE_SPEED)
		await get_tree().create_timer(rate_of_fire / 1000.0).timeout
	if main_ball:
		main_ball.process_mode = Node.PROCESS_MODE_PAUSABLE
		main_ball.position = ball_spawn_position
		print(main_ball.position)
		main_ball.velocity = Vector2.from_angle(DEFAULT_RADIANS) * GlobalConstants.RAPID_FIRE_SPEED
	attack_ended.emit()
