extends Node3D

const grenade_prefab = preload("res://Prefabs/Player/grenade_root.tscn")
var choosed_hud: String = "flash"

@onready var huds: Dictionary = {
	"flash": $flash_grenade,
	"HE": $HE_grenade,
	"smoke": $smoke_grenade,
	"molotov": $molotov_grenade
}

@onready var player = $".."
@onready var main_camera = $"../camera"
@onready var hud_camera = $"../HUD_viewport/HUD_camera"
@onready var choosed_hud_text = $"../Canvas/HUD/choosed_hud"


func _process(_delta)->void:
	sync_hud()
	choosed_hud_text.text = choosed_hud
	
	if Input.is_action_just_pressed("left_mouse"):
		launch_grenade()


func _input(event)->void:
	# detect Keybord Unicode actions for grenades change hud
	var grenades_unicode: Dictionary = {1: "flash", 2: "HE", 3: "smoke", 4: "molotov"}
	if event is InputEventKey:
		if grenades_unicode.has(int(char(event.unicode))):
			var choosed_grenade = grenades_unicode[int(char(event.unicode))]
			change_hud(choosed_grenade)

#region hud_actions
func sync_hud()->void:
	# sync hud tranform for LERP effect
	if hud_camera != null:
		global_position = lerp(global_position, main_camera.global_position, 0.7)
		global_rotation.y = lerp_angle(global_rotation.y, main_camera.global_rotation.y, 0.8)
		global_rotation.x = lerp_angle(global_rotation.x, main_camera.global_rotation.x, 0.8)
		
		hud_camera.global_transform = main_camera.global_transform


func change_hud(nextHud)->void:
	#change hud
	if choosed_hud != nextHud:
		for hud in huds:
			huds[hud].hide()
		huds[nextHud].show()
		choosed_hud = nextHud

#endregion
func launch_grenade()->void:
	# throw grenade
	var grenade = grenade_prefab.instantiate()
	grenade.grenade_type = choosed_hud
	
	player.get_parent().add_child(grenade)
	grenade.global_transform = global_transform
	grenade.apply_central_impulse(-global_transform.basis.z * grenade.check_grenade_type_array[choosed_hud].force)
