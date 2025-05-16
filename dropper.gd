extends Node2D

@export var scoop: Scoop

@export var blue: Resource
@export var green: Resource
@export var red: Resource


func create_scoop(color: String) -> void:
	pass

func drop():
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space_bar"):
		drop();
