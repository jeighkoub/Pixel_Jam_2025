extends Node2D
class_name Target

signal hit_target()
@export var falling_scoop: Scoop

var previous_color: String = "Red"  
var current_color: String = "" 

var first_drop: bool = true 

func _ready():
	var area2d = get_node("Area2D") 
	area2d.area_entered.connect(_on_area_2d_area_entered)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == falling_scoop:
		emit_signal("hit_target")
		if not first_drop:
			_play_particles(previous_color)  
		first_drop = false 


func _on_dropper_blue_scoop() -> void:
	_store_current_color("Blue")  
	_play_particles("Blue")  

func _on_dropper_green_scoop() -> void:
	_store_current_color("Green")
	_play_particles("Green")

func _on_dropper_red_scoop() -> void:
	_store_current_color("Red")
	_play_particles("Red")


func _store_current_color(color: String) -> void:
	previous_color = current_color  
	current_color = color


func _play_particles(color: String) -> void:
	var all_colors = ["Red", "Green", "Blue"]
	for c in all_colors:
		var group_name = c + "Particles"  
		var nodes = get_tree().get_nodes_in_group(group_name)  
		for node in nodes:
			if node is GPUParticles2D:
				node.emitting = (c == color) 
				if node.emitting:
					node.restart()
