extends Control
func _ready() -> void:
	$AudioStreamPlayer.play()

var tier: int
var arr = [
	"res://assets/cutscene_scenes/trashed_truck_cutscene.tscn",
	"res://assets/cutscene_scenes/clean_truck_cutscene.tscn",
	"res://assets/cutscene_scenes/gold_truck_cutscene.tscn"
]
@export var RevenueNumber: Label
@export var ExpensesNumber: Label
@export var ProfitNumber: Label
var revenue: int
var expenses: int = 100

	
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			$AudioStreamPlayer2.play()
			set_process_input(false)
			await $AudioStreamPlayer2.finished


			#get_tree().change_scene_to_file("res://main.tscn")
			var next_scene = load(arr[tier]).instantiate()
			next_scene.tier = tier#NOT +1 that already happens
			get_tree().current_scene.queue_free()
			get_tree().root.add_child(next_scene)
			get_tree().current_scene = next_scene
