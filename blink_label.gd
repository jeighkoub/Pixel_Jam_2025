extends Label

@export var color_one: Color = Color(0.0, 0.0, 0.0, 1.0) # Black
@export var color_two: Color = Color(0.0, 0.5843, 0.9137, 1.0) # #0095e9
@export var swap_interval: float = 0.5 # Seconds
@onready var timer: Timer = $Timer
var is_color_one: bool = true

func _ready() -> void:
	# Initialize color
	modulate = color_one
	
	# Set up Timer
	if not timer:
		timer = Timer.new()
		add_child(timer)
	timer.wait_time = swap_interval
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	# Swap colors
	is_color_one = !is_color_one
	modulate = color_one if is_color_one else color_two
