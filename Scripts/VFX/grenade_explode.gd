extends Node3D

var tween: Tween
@onready var anti_fog_explode = $AntiFogExplode
@onready var VFX = $VFX


func _ready()->void:
	#emit VFX
	for effect in VFX.get_children():
		effect.emitting = true

	#antifog
	anti_fog_explode.material = FogMaterial.new()
	anti_fog_explode.material.density = -8

	await get_tree().create_timer(2).timeout

	tween = create_tween()
	tween.tween_property(anti_fog_explode, "material:density", 0, 2)

	await tween.finished
	queue_free()
