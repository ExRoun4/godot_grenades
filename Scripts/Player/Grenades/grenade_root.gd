extends RigidBody3D

# grenades parameters
enum EXPLODE_TYPES {
	TIMER = 0,
	RESET_ON_FLOOR,
	INSTANTLY_ON_FLOOR
}

var check_grenade_type_array: Dictionary = {
	"flash": {
		"callable": flash,
		"time": 1.5,
		"explode_type": EXPLODE_TYPES.TIMER,
		"bounce": 0.4,
		"mass": 1,
		"gravity": 1,
		"force": 25
	},
	"HE": {
		"callable": instance_grenade_effect,
		"time": 1.6,
		"explode_type": EXPLODE_TYPES.TIMER,
		"bounce": 0.2,
		"mass": 2,
		"gravity": 1.7,
		"force": 23
	},
	"smoke": {
		"callable": instance_grenade_effect,
		"time": 1,
		"explode_type": EXPLODE_TYPES.RESET_ON_FLOOR,
		"bounce": 0.3,
		"mass": 1.2,
		"gravity": 1.9,
		"force": 21
	},
	"molotov": {
		"callable": instance_grenade_effect,
		"time": 0,
		"explode_type": EXPLODE_TYPES.INSTANTLY_ON_FLOOR,
		"bounce": 0.2,
		"mass": 1.1,
		"gravity": 1.3,
		"force": 22
	}
}


@onready var visibility_check = $visibility_check
@onready var grenade_timer = $timer
@onready var ground_check = $ground_check
var grenade_type: String


func _ready()->void:
	# align timer type by grenade params
	if check_grenade_type_array[grenade_type].explode_type == EXPLODE_TYPES.TIMER:
		grenade_timer.start(check_grenade_type_array[grenade_type].time)
	if check_grenade_type_array[grenade_type].explode_type == EXPLODE_TYPES.RESET_ON_FLOOR:
		grenade_timer.wait_time = check_grenade_type_array[grenade_type].time
	
	grenade_timer.timeout.connect(check_grenade_type_array[grenade_type].callable)

	# align physics properties
	mass = check_grenade_type_array[grenade_type].mass
	gravity_scale = check_grenade_type_array[grenade_type].gravity
	physics_material_override.bounce = check_grenade_type_array[grenade_type].bounce


func _process(_delta):
	# actions for RESET_ON_FLOOR and INSTANTLY_ON_FLOOR flags
	ground_check.global_position = global_position
	if check_grenade_type_array[grenade_type].explode_type == EXPLODE_TYPES.RESET_ON_FLOOR:
		if ground_check.is_colliding() and linear_velocity < Vector3(0.6, 0.1, 0.6) and grenade_timer.is_stopped():
			grenade_timer.start()
			return
	if check_grenade_type_array[grenade_type].explode_type == EXPLODE_TYPES.INSTANTLY_ON_FLOOR:
		if ground_check.is_colliding():
			grenade_timer.timeout.emit()
			return


#region grenades_behavior
func flash()->void:
	#flash player
	if visibility_check.is_on_screen():
		Player.player.event_listener.flash_player()

	queue_free()


func instance_grenade_effect()->void:
	#instance grenade VFX type
	var effect
	if grenade_type == "HE":
		effect = Global.HE_EXPLODE.instantiate()
	elif grenade_type == "smoke":
		effect = Global.SMOKE.instantiate()
	elif grenade_type == "molotov":
		effect = Global.MOLOTOV_FIRE.instantiate()
		
	get_parent().add_child(effect)
	effect.global_position = global_position
	queue_free()
#endregion
