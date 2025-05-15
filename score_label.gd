extends Label
class_name AnimatedNumber

var points: int = 0: set = _on_points_set
var fake_points: int = 0: set = _on_fake_points_set
var previous_points: int = 0
var tween: Tween
var shader_material: ShaderMaterial
var is_counting: bool = false
var counting_timer: float = 0.0
var hit_effect_active: bool = false
@export var LARGE_CHANGE_THRESHOLD: int = 1000
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var particles: CPUParticles2D = $"../Snowflakes"

func _ready() -> void:
	# Create and assign ShaderMaterial
	var shader = Shader.new()
	shader.code = """
		shader_type canvas_item;

		uniform float hit_effect : hint_range(0,1) = 0.0;
		uniform float shake_intensity = 5.0;
		uniform vec4 flash_color : source_color = vec4(0.0, 0.58, 0.91, 1.0);
		uniform vec4 black_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

		float rand(vec2 co) {
			return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
		}

		void vertex() {
			if (hit_effect > 0.0) {
				float time = TIME * 30.0;
				vec2 random_offset = vec2(
					rand(vec2(time, 0.0)) * 2.0 - 1.0,
					rand(vec2(time, 10.0)) * 2.0 - 1.0
				);
				float shake_factor = hit_effect;
				VERTEX += random_offset * shake_intensity * hit_effect * shake_factor;
			}
		}

		void fragment() {
			vec4 original_color = texture(TEXTURE, UV);
			
			if (hit_effect > 0.0) {
				vec4 final_color = mix(black_color, flash_color, hit_effect);
				final_color.a = original_color.a; 
				
				COLOR = final_color;
			} else {
				COLOR = original_color;
			}
		}
	"""
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	material = shader_material
	
	# Stop animation, SFX, and particles initially
	if animation_player:
		animation_player.stop()
	if sfx_player:
		sfx_player.stop()
	if particles:
		particles.emitting = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		points = randi_range(0, 10_000)

func _process(delta: float) -> void:
	if is_counting:
		counting_timer += delta
		if counting_timer > 0.5 and not hit_effect_active:
			_activate_hit_effect()
		# Start particles at 3 seconds
		if counting_timer >= 2.0 and particles and not particles.emitting:
			particles.emitting = true

func _on_points_set(new_value: int) -> void:
	var score_change = abs(new_value - previous_points)
	points = new_value
	
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	# Set duration based on score change
	var count_duration = 6.0 if score_change >= LARGE_CHANGE_THRESHOLD else 2.0
	tween.tween_property(self, "fake_points", points, count_duration)
	
	if score_change >= LARGE_CHANGE_THRESHOLD:
		# Large changes: black to #0095e9
		is_counting = true
		counting_timer = 0.0
		hit_effect_active = false
		shader_material.set_shader_parameter("hit_effect", 0.0)
		tween.tween_callback(_on_tween_finished)
	else:
		# Small changes: stay black
		is_counting = false
		hit_effect_active = false
		shader_material.set_shader_parameter("hit_effect", 0.01)
		if animation_player:
			animation_player.stop()
		if sfx_player:
			sfx_player.stop()
		if particles:
			particles.emitting = false
	
	previous_points = points

func _on_fake_points_set(new_value: int) -> void:
	fake_points = new_value
	self.text = str(fake_points)

func _activate_hit_effect() -> void:
	if hit_effect_active:
		return
	hit_effect_active = true
	var hit_tween = create_tween()
	hit_tween.tween_method(_set_hit_effect, 0.0, 1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

func _set_hit_effect(value: float) -> void:
	shader_material.set_shader_parameter("hit_effect", value)
	# Play animation and SFX when fully blue
	if value >= 1.0:
		if animation_player and not animation_player.is_playing():
			animation_player.play("ScoreEffect")
		if sfx_player and not sfx_player.playing:
			sfx_player.play()
	elif animation_player and animation_player.is_playing():
		animation_player.stop()
		if sfx_player:
			sfx_player.stop()

func _on_tween_finished() -> void:
	is_counting = false
	counting_timer = 0.0
	hit_effect_active = false
	shader_material.set_shader_parameter("hit_effect", 0.0)
	if animation_player:
		animation_player.stop()
	if sfx_player:
		sfx_player.stop()
	if particles:
		particles.emitting = false
