extends Node2D


# Reference to the particle component
@export var particle_component: Node2D
@export var target: Target

# State to prevent repeated triggers
var is_order_active: bool = false

func _ready() -> void:
	# Hide WalkPause sprite (access Sprite2D inside WalkPause scene)
	if has_node("WalkPause/Sprite"):
		$WalkPause/Sprite.visible = false
	else:
		push_error("WalkPause/Sprite node not found!")
	
	#connections
	

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
