extends Control
func _ready() -> void:
	$AudioStreamPlayer.play()
	
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			$AudioStreamPlayer2.play()
			get_tree().change_scene_to_file("res://index.tscn")
