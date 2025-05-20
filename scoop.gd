extends Node2D
class_name Scoop

var velocity: Vector2 = Vector2.ZERO
var _particles_played: bool = false  

signal scoop_missed

func setup(txtr: Resource) -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite and sprite is Sprite2D:
		sprite.texture = txtr
	else:
		push_error("scoop.gd: Sprite2D not found or is not a Sprite2D node.")
		
	for child in get_children():
		if child is GPUParticles2D:
			child.emitting = false
			child.one_shot = true  

func _physics_process(delta: float) -> void:
	if not self.visible:
		return
	global_position += velocity * delta
	

	if velocity.is_zero_approx():

		if not _particles_played:
			for child in get_children():
				if child is GPUParticles2D:

					child.global_position = global_position

					child.restart()
					child.emitting = true
			_particles_played = true  
	else:
		_particles_played = false

func trigger_particles() -> void:
	for child in get_children():
		if child is GPUParticles2D:
			child.global_position = global_position
			child.restart()
			child.emitting = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	emit_signal("scoop_missed")
