extends Node2D
class_name Scoop

func setup(txtr: Resource) -> void:
	get_node("Sprite2D").texture = txtr
