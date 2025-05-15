extends Control


func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://opening_cutscene.tscn")
 
