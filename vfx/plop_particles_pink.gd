extends Node2D


func _ready():
	for child in get_children():
		if child is GPUParticles2D:
			child.emitting = false


func trigger_particles():
	for child in get_children():
		if child is GPUParticles2D:
			child.restart()
			child.emitting = true  
