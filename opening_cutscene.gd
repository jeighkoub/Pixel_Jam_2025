extends Node2D

@onready var camera = $Camera2D 
@onready var color_rect = $CanvasLayer/ColorRect  

var tween: Tween

func _ready():
	
	camera.position = Vector2(160, 90) 
	camera.limit_left = 0
	camera.limit_right = 640 
	camera.limit_top = 0
	camera.limit_bottom = 180
	
	if color_rect:
		color_rect.size = Vector2(320, 180)
		color_rect.position = Vector2(0, 0)
		color_rect.color = Color(0, 0, 0, 0)
		color_rect.z_index = 100 
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	start_cutscene()

func start_cutscene():
	await get_tree().create_timer(5.0).timeout
	tween = create_tween()
	tween.tween_property(camera, "position", Vector2(480, 90), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await get_tree().create_timer(5.0).timeout
	

	if color_rect:
		color_rect.color = Color(0, 0, 0, 0)
		var fade_to = Color(0, 0, 0, 1.0)
		tween = create_tween()
		tween.tween_property(color_rect, "color", fade_to, 1.0).set_trans(Tween.TRANS_LINEAR)
		await tween.finished

		get_tree().change_scene_to_file("res://main.tscn")
