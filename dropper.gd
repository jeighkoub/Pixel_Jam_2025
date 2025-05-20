extends Node2D

@export var scoop: Scoop

@export var blue: Resource
@export var green: Resource
@export var red: Resource

signal red_scoop
signal green_scoop
signal blue_scoop

func _ready():
	create_scoop("red")
	red_scoop.emit()

func create_scoop(color: String) -> void:
	print("creating    ", color)
	scoop.set_physics_process(false)
	scoop.global_position = self.global_position
	scoop.velocity = Vector2.ZERO
	match color:
		"blue", "b":
			scoop.get_node("Sprite2D").texture = blue
			blue_scoop.emit()
		"red", "r":
			scoop.get_node("Sprite2D").texture = red
			red_scoop.emit()
		"green", "g":
			scoop.get_node("Sprite2D").texture = green
			green_scoop.emit()

	scoop.visible = true
	
func drop():
	scoop.velocity = Vector2(0,100)
	scoop.set_physics_process(true)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space_bar"):
		drop();
