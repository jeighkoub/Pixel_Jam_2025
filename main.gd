extends Node2D


# Reference to the particle component
@export var particle_component: Node2D
@export var target: Target
@export var dropper: Node2D
@export var main_scoop: Scoop #reuse the same scoop to aovid rewiring

# State to prevent repeated triggers
var is_order_active: bool = false

func _ready() -> void:
	
	#connections
	#target.hit_target.connect(_on_hit_target)
	var err = target.hit_target.connect(_on_hit_target)
	if err != OK:
		push_error("Signal connection failed: ", err)
	
	# Hide WalkPause sprite (access Sprite2D inside WalkPause scene)
	if has_node("WalkPause/Sprite"):
		$WalkPause/Sprite.visible = false
	else:
		push_error("WalkPause/Sprite node not found!")
	
	

func _on_hit_target():
	main_scoop.visible = false
	main_scoop.velocity = Vector2.ZERO
	main_scoop.global_position += Vector2(0,-200) # move away from collision detection
	
	#plop particles
	
	#score
	
	#wait and reload dropper
	

func _process(delta: float) -> void:
	# Trigger customer order on spacebar (replace with your event)
	if Input.is_action_just_pressed("ui_accept") and not is_order_active:
		customer_order()

func customer_order() -> void:
	# Prevent re-triggering
	is_order_active = true
	
	# Show WalkPause sprite
	if has_node("WalkPause/Sprite"):
		$WalkPause.visible = true
	else:
		push_error("WalkPause/Sprite node not found!")
	
	# Play WalkStart
	if has_node("WalkStart"):
		$WalkStart.play()
	else:
		push_error("WalkStart node not found!")
	
	# Wait for WalkStart to finish
	if $WalkStart is AnimationPlayer:
		await $WalkStart.animation_finished
	elif $WalkStart is AudioStreamPlayer:
		await $WalkStart.finished
	
	# Reset state
	is_order_active = false
	if has_node("WalkPause/Sprite"):
		$WalkPause.visible = false
