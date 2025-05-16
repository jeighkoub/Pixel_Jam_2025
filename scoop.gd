extends Node2D
class_name Scoop

var velocity : Vector2 = Vector2.ZERO

func setup(txtr: Resource) -> void:
	get_node("Sprite2D").texture = txtr

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
