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

		await get_tree().create_timer(3.0).timeout

		tween = create_tween()
		tween.tween_property(color_rect, "color", Color(0, 0, 0, 1.0), 1.0).set_trans(Tween.TRANS_LINEAR)
		await tween.finished

		#get_tree().change_scene_to_file("res://assets/cutscene_scenes/game_over.tscn") #TODO end of game. move to main menu?
		var scn = load("res://assets/cutscene_scenes/game_over.tscn").instantiate()
		scn.profit = 1 << 63
		get_tree().current_scene.queue_free()
		get_tree().root.add_child(scn)
		get_tree().current_scene = scn
