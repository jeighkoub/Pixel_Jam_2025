extends Node2D

signal hit_target(area: Area2D)


func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area is Scoop:
		emit_signal("hit_target", area)
