extends Control

var scene: PackedScene
var tier: int
@export var profit_number_label: Label
var profit_number: int = -1

#might go in quarterly oops
var arr = [
	"res://assets/cutscene_scenes/trashed_truck_cutscene.tscn",
	"res://assets/cutscene_scenes/clean_truck_cutscene.tscn",
	"res://assets/cutscene_scenes/gold_truck_cutscene.tscn"
]

func setup(curr_tier: int) -> void:
	tier = curr_tier
	
func _ready() -> void:
	$AudioStreamPlayer.play()
	profit_number_label.text = str(profit_number)

	
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			$AudioStreamPlayer2.play()
			set_process_input(false)
			await $AudioStreamPlayer2.finished
			get_tree().change_scene_to_file("res://index.tscn")
			#back to main memnu after game over ig
