extends Node

const BALL_CREATOR_PATH: String = "res://scenes/Back End Scenes/BallCreator.tscn"
const REAL_BALLS_TARGET_QUANTITY: int = 1
const FAKE_BALLS_TARGET_QUANTITY: int = 200
const BULLET_BALLS_TARGET_QUANTITY: int = 200
const STEALTH_BALLS_TARGET_QUANTITY: int = 200
const OFFSCREEN_COORDINATES: Vector2 = Vector2(99999, 99999)

var spawn_target_quantities: Array = [
	{"type": "Real Ball", "quantity": REAL_BALLS_TARGET_QUANTITY},
	{"type": "Fake Ball", "quantity": FAKE_BALLS_TARGET_QUANTITY},
	{"type": "Bullet Ball", "quantity": BULLET_BALLS_TARGET_QUANTITY},
	{"type": "Stealth Ball", "quantity": STEALTH_BALLS_TARGET_QUANTITY},
]
var available_spawn_types: Dictionary = {}
var available_balls: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ball_creator = load(BALL_CREATOR_PATH).instantiate()
	for child_node in ball_creator.get_children():
		available_spawn_types[child_node.type] = child_node.duplicate()
	ball_creator.queue_free()

func initialize_ball_pool() -> void:
	for ball_type in spawn_target_quantities:
		var ball_name = ball_type["type"]
		if not ball_type["type"] in available_spawn_types:
			push_error("Cannot find %s in available spawn types." % [ball_name])
			continue
		var ball_to_spawn = available_spawn_types[ball_name]
		for index in ball_type["quantity"]:
			var ball = ball_to_spawn.duplicate()
			get_tree().current_scene.add_child(ball)
			ball.global_position = OFFSCREEN_COORDINATES
			ball.process_mode = Node.PROCESS_MODE_DISABLED
			available_balls.append({"node": ball, "type": ball_name})

func get_ball_from_pool(ball_type: String, position: Vector2, radians: float, speed: int = 500) -> Node2D:
	var ball
	for available_ball in available_balls:
		if available_ball["type"] == ball_type:
			ball = available_ball["node"]
			available_balls.erase(available_ball)
			break
	if ball == null:
		expand_ball_pool_by_type(ball_type)
		get_ball_from_pool(ball_type, position, radians)
		return
	ball.global_position = position
	ball.velocity = Vector2.from_angle(radians) * speed
	ball.process_mode = Node.PROCESS_MODE_PAUSABLE
	return ball
	
func return_ball_to_pool(ball: Node2D) -> void:
	var ball_type: String = ball.type
	if not ball_type in available_spawn_types:
		push_warning("Invalid return for ball type: %s, terminating instead" % [ball_type])
		ball.queue_free()
		return
	ball.process_mode = Node.PROCESS_MODE_DISABLED
	ball.global_position = OFFSCREEN_COORDINATES
	ball.velocity = Vector2.ZERO
	available_balls.append({"node": ball, "type": ball_type})

func expand_ball_pool_by_type(ball_type: String, quantity: int = 5) -> void:
	if not ball_type in available_spawn_types:
		push_error("Cannot find %s in available spawn types." % [ball_type])
		return
	var ball_to_spawn = available_spawn_types[ball_type]
	for index in quantity:
		var ball = ball_to_spawn.duplicate()
		get_tree().current_scene.add_child(ball)
		ball.global_position = OFFSCREEN_COORDINATES
		ball.process_mode = Node.PROCESS_MODE_DISABLED
		available_balls.append(ball)
