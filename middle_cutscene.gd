extends Node2D

@onready var color_rect = $CanvasLayer/ColorRect  

var tween: Tween
var tier: int = 0

func _ready():
	if color_rect:
		color_rect.size = Vector2(320, 180)
		color_rect.position = Vector2(0, 0)
		color_rect.color = Color(0, 0, 0, 1)
		color_rect.z_index = 100 
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	start_cutscene()

func start_cutscene():
	if color_rect:
		tween = create_tween()
		tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.0).set_trans(Tween.TRANS_LINEAR)
		await tween.finished

		await get_tree().create_timer(5.0).timeout

		tween = create_tween()
		tween.tween_property(color_rect, "color", Color(0, 0, 0, 1.0), 1.0).set_trans(Tween.TRANS_LINEAR)
		await tween.finished

		#get_tree().change_scene_to_file("res://assets/cutscene_scenes/quarterly_report.tscn")
		var main_scene = load("res://main.tscn").instantiate()
		main_scene.tier = self.tier  # Pass the tier info

		get_tree().current_scene.queue_free()
		get_tree().root.add_child(main_scene)
		get_tree().current_scene = main_scene
