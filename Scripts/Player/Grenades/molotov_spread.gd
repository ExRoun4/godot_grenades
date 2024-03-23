extends Node3D

@onready var fire_sparkle = $fire_sparkle
@onready var check_ray = $CheckRay
@onready var timer = $Timer

func _ready()->void:
	spread()
	timer.timeout.connect(delete)


func spread()->void:
	randomize()
	
	for i in randi_range(16, 20):
		check_ray.global_position = global_position + Vector3(randf_range(-5, 5), 4, (randf_range(-5, 5)))
		await get_tree().create_timer(0.01).timeout
		if check_ray.is_colliding():
			var new_sparkle = fire_sparkle.duplicate()
			add_child(new_sparkle)
			new_sparkle.global_position = check_ray.get_collision_point()
	
	check_ray.queue_free()


func delete(stew: bool = false)->void:
	for sparkle in get_children():
		if sparkle is GPUParticles3D:
			sparkle.emitting = false
			if stew:
				sparkle.get_child(0).queue_free()
	
	if stew:
		#TODO create stew sound
		pass

	await get_tree().create_timer(1).timeout
	queue_free()


func check_smoke_area(_body)->void:
	delete(true)
