extends Node2D
class_name Tower

var scoops: Array
var time: float = 0.0
var tilt_speed = PI/4     # radians per second
var max_angle = PI / 4  # maximum lean angle (45 degrees)
var SCOOP_RADIUS = 8
var L = 2 * SCOOP_RADIUS

func _ready():
	for child in get_children():
		scoops.append(child)

func _process(delta: float) -> void:
	time += delta
	var theta = max_angle * sin(time * tilt_speed)
	
	for i in range(scoops.size()):
		var x: float = 0
		var y: float = 0
		for k in range(i):
			x += L * sin(theta*k/4)
			y += -1 * L * cos(theta*k/4)
		var scoop: Node2D = scoops[i]
		scoop.global_rotation = theta*i/12
		scoop.position = Vector2(x, y)
