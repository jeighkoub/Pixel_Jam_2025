extends Node2D
class_name Scoop

var velocity : Vector2 = Vector2.ZERO


func setup(txtr: Resource) -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite and sprite is Sprite2D:
		sprite.texture = txtr
	else:
		push_error("scoop.gd: Sprite2D not found or is not a Sprite2D node.")

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
