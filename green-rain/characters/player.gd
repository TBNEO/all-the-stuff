extends CharacterBody3D

@onready var pivot = $pivot
@onready var spring_arm_3d = $pivot/SpringArm3D
@onready var camera_3d = $pivot/SpringArm3D/Camera3D
@onready var dashtime = $Node/Dashtime
@onready var dash_cd = $Node/DashCD
@onready var weapon_node = $pivot/WeaponNode
@onready var playermesh = $playermesh

var mpp: MPPlayer

const SPEED = 30.0
const DASHSPEED = 150.0
const JUMP_VELOCITY = 20.0

var dash_lock = false

func _ready():
	mpp = get_parent()
	camera_3d.current = mpp.is_local
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if not mpp.is_local:
		return
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * 0.01)
		spring_arm_3d.rotate_x(-event.relative.y * 0.01)
		spring_arm_3d.rotation.x = clampf(spring_arm_3d.rotation.x, deg_to_rad(-65), deg_to_rad(65))
		
		weapon_node.rotation.x = lerp_angle(weapon_node.rotation.x, spring_arm_3d.rotation.x, 0.75)
		playermesh.rotation.y = lerp_angle(playermesh.rotation.y, pivot.rotation.y, 0.75)
		

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed(mpp.ma("jump")) and is_on_floor():
		velocity.y += JUMP_VELOCITY
	elif Input.is_action_just_released(mpp.ma("jump")) and velocity.y > 0:
		velocity.y /= 2

	var input_dir = Input.get_vector(mpp.ma("left"), mpp.ma("right"), mpp.ma("up"), mpp.ma("down"))
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor() and not dash_lock:
		if direction:
			velocity.x = lerpf(velocity.x, direction.x*SPEED, 0.75)
			velocity.z = lerpf(velocity.z, direction.z*SPEED, 0.75)
		else:
			velocity.x = lerpf(velocity.x, 0, 0.5)
			velocity.z = lerpf(velocity.z, 0, 0.5)
	else:
		if direction:
			velocity.x = lerpf(velocity.x, direction.x*SPEED, 0.05)
			velocity.z = lerpf(velocity.z, direction.z*SPEED, 0.05)
		else:
			velocity.x = lerpf(velocity.x, 0, 0.05)
			velocity.z = lerpf(velocity.z, 0, 0.05)

	var side_input = Input.get_axis(mpp.ma("left"), mpp.ma("right"))
	var side_dir = (pivot.transform.basis * Vector3(side_input, 0, 0)).normalized()
	
	if Input.is_action_just_pressed(mpp.ma("dash")) and side_dir and !dash_lock:
		velocity.x = DASHSPEED * side_dir.x
		velocity.z = DASHSPEED * side_dir.z
		dashtime.start()
		dash_lock = true

	move_and_slide()


func _on_dashtime_timeout():
	velocity.x = lerpf(velocity.x, 0.0, 0.75)
	velocity.z = lerpf(velocity.z, 0.0, 0.75)
	dash_cd.start()


func _on_dash_cd_timeout():
	dash_lock = false
