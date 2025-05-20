extends Node2D


# Reference to the particle component
@export var particle_component: Node2D
@export var target: Target
@export var dropper: Node2D
@export var main_scoop: Scoop #reuse the same scoop to aovid rewiring
@export var tower: Tower
@export var scoop_scene: PackedScene
# State to prevent repeated triggers
var is_order_active: bool = false

@export var success_scene: PackedScene
@export var fail_scene: PackedScene
var tier: int = 0
var arr = [
	"res://assets/cutscene_scenes/trashed_truck_cutscene.tscn",
	"res://assets/cutscene_scenes/clean_truck_cutscene.tscn",
	"res://assets/cutscene_scenes/gold_truck_cutscene.tscn"
]


var scoop_colors: Array
func next_color() -> String:
	var colors = ["green", "red", "blue"]
	return colors[randi() % colors.size()]

var num_scoops_successful: int = 0
var num_scoops_goal: int = 5


# SO WE CAN CYCLE THROUGH RANDOM TRACKS
@onready var music1: AudioStreamPlayer = $Music1
@onready var music2: AudioStreamPlayer = $Music2
@onready var music3: AudioStreamPlayer = $Music3

func _ready() -> void:
	var random_number = GlobalAudio.rng.randi_range(1, 3)
	match random_number:
		1:
			music1.play()
		2:
			music2.play()
		3:
			music3.play()

	#connections
	#target.hit_target.connect(_on_hit_target)
	var err = target.hit_target.connect(_on_hit_target)
	if err != OK:
		print("signal err")
		push_error("Signal connection failed: ", err)
	main_scoop.scoop_missed.connect(_on_scoop_missed)
	
	# Hide WalkPause sprite (access Sprite2D inside WalkPause scene)
	if self.has_node("WalkPause/Sprite"):
		$WalkPause/Sprite.visible = false
	else:
		print("no walkpause")
		push_error("WalkPause/Sprite node not found!")

	



func _on_hit_target():
	if not main_scoop.visible:
		print("skipping _on_hit_target")
		return
	main_scoop.visible = false
	main_scoop.velocity = Vector2.ZERO
	main_scoop.set_physics_process(false)
	main_scoop.global_position = Vector2(-100,0) # move away from collision detection
	var target_position = main_scoop.global_position
	
	
	#plop particles
	#TODO  Add color checker
	$Plop.play() #sound?
	
	#put scoop on tower
	var scoops_arr: Array = tower.scoops
	var new_scoop: Scoop = scoop_scene.instantiate()
	tower.add_child(new_scoop)
	new_scoop.setup(main_scoop.get_node("Sprite2D").texture)
	scoops_arr.insert(scoops_arr.size()-1, new_scoop) # shift target to end
	
	
	#score
	num_scoops_successful += 1
	var score_node = %Score
	score_node.points += 100 * num_scoops_successful
	
	#move dropper and camera up
	$Dropper.global_position += Vector2(0,-16) #diameter of scoop is 16
	var target_pos = $Camera2D.global_position + Vector2(0, -16)
	var tween := get_tree().create_tween()
	tween.tween_property($Camera2D, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	#wait and reload dropper
	dropper.create_scoop(next_color())


func _process(delta: float) -> void:
	
	# Trigger customer order on spacebar (replace with your event)
	if Input.is_action_just_pressed("ui_accept") and not is_order_active:
		customer_order()
	#print("tower: ", tower.z_index, "\ninterior: ", $TruckInterior.z_index)

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
	
func game_end() -> void:
	var next_scene
	if num_scoops_successful >= num_scoops_goal:
		next_scene = success_scene.instantiate()
		next_scene.tier = self.tier + 1
	else:
		next_scene = fail_scene.instantiate()
		next_scene.tier = self.tier
		next_scene.profit_number = 0
	#change scene
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(next_scene)
	get_tree().current_scene = next_scene
	
		
		
	
func _on_scoop_missed() -> void:
	print("scoop missed")
	game_end()
