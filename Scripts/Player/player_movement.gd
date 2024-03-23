extends CharacterBody3D
class_name Player

static var player: Player = null
var dir: Vector3

var mouse_sensitivity: Vector2 = Vector2(0.1, 0.1)

var move_speed: float = 6.5
var jump_strength: float = 10
const gravity = -30.0
const accel = 6.0

@onready var camera = $camera
@onready var hud_viewport = $HUD_viewport
@onready var event_listener = $event_listener


func _ready()->void:
	assert(player == null)
	player = self
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hud_viewport.size = get_window().size


func _input(event)->void:
	# camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity.x))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity.y))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)


func _physics_process(delta)->void:
	# get input dir
	var move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	dir = (transform.basis * Vector3(move_dir.x, 0, move_dir.y)).normalized()
	
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strength
	
	# change speed
	var speed = move_speed
	if Input.is_action_pressed("sprint") and is_on_floor():
		speed *= 1.5
	
	# align velocity
	velocity = lerp(velocity, Vector3(dir.x * speed, velocity.y, dir.z * speed), accel * delta)
	velocity.y += gravity * delta
	move_and_slide()
