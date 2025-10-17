# DELETE WHAT YOU DONT NEED

# Ball

extends CharacterBody2D

# ================= ATTRIBUTES =================

@export_category("Attributes")

@export_group("Common Variables")
@export var base_int: int = 0
@export var base_float: float = 0.0
@export var base_string: String = "String"
@export var base_boolean: bool = false
@export var base_array: Array = []
@export var base_dictionary: Dictionary = {}
@export var base_color: Color = Color.BLACK
@export var base_vector2: Vector2 = Vector2.ZERO

@export_group("Advanced Variables")
@export_subgroup("Ranges")
@export_range(0, 100) var base_intRange: int = 0
@export_range(0.0, 100.0) var base_floatRange: float = 0.0

@export_subgroup("Enumerations")
@export_enum("Option1", "Option2") var base_enum_string: String = "Option1"
@export_enum("0", "1", "2") var base_enum_int: int = 0

@export_group("Special Variables")
@export var base_resource: Resource
@export var base_node: Node

# ================= METHODS =================

func function1():
	pass

# ================= SETUP AND RUN LOOPS =================

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
