extends FogVolume

var tween: Tween


func _ready()->void:
	# create shader material ( individual material )
	var new_shader = ShaderMaterial.new()
	new_shader.shader = load("res://Assets/Shaders/smoke.gdshader")
	new_shader.set_shader_parameter("density", 0)
	
	# create noise
	var new_noise = FastNoiseLite.new()
	new_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	new_noise.frequency = 0.0234
	new_noise.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	new_noise.fractal_octaves = 2
	new_noise.fractal_weighted_strength = 0.08
	new_noise.fractal_ping_pong_strength = 1
	
	new_shader.set_shader_parameter("density_texture", new_noise)
	material = new_shader
	
	# spread smoke
	tween = create_tween()
	tween.tween_property(self, "material:shader_parameter/density", 8, 0.5)


func disperse_smoke()->void:
	# disperce and delete on finish
	tween = create_tween()
	tween.tween_property(self, "material:shader_parameter/density", 0, 2)
	
	await tween.finished
	queue_free()
