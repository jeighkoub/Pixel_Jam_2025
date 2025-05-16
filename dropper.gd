extends Node2D

@export var scoop: Scoop

@export var blue: Resource
@export var green: Resource
@export var red: Resource

func _ready():
	create_scoop("red")

func create_scoop(color: String) -> void:
	scoop.set_physics_process(false)
	scoop.global_position = self.global_position
	scoop.velocity = Vector2.ZERO
	match color:
		"blue", "b":
			scoop.get_node("Sprite2D").texture = blue
		"green", "g":
			scoop.get_node("Sprite2D").texture = green
		"red", "r":
			scoop.get_node("Sprite2D").texture = red
	scoop.visible = true

func drop():
	scoop.velocity = Vector2(0,100)
	scoop.set_physics_process(true)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space_bar"):
		drop();
