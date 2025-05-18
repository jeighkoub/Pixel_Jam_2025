extends Control


func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			$AudioStreamPlayer.play()
			get_tree().change_scene_to_file("res://assets/cutscene_scenes/opening_cutscene.tscn")
 
