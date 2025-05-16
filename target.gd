extends Node2D
class_name Target

signal hit_target()
@export var falling_scoop: Scoop

func _ready():
	var area2d = get_node("Area2D") # or "SomeChild/Area2D" if nested
	area2d.area_entered.connect(_on_area_2d_area_entered)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == falling_scoop:
		emit_signal("hit_target")
