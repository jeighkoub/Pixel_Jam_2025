extends Node2D

@export var scoop: Scoop

@export var blue: Resource
@export var green: Resource
@export var red: Resource


func create_scoop(color: String) -> void:
	scoop.global_position = self.global_position
	match color:
		"blue":
			scoop.get_node("Sprite2D").texture = blue
		"green":
			scoop.get_node("Sprite2D").texture = green
		"red":
			scoop.get_node("Sprite2D").texture = red

func drop():
	scoop.velocity = Vector2(0,100)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space_bar"):
		drop();
