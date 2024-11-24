extends CharacterBody3D
'''
@onready var HEAD = $Camera3D
@onready var JUMP_BTN = $"../JumpBTN"

const SENSITIVITY = 0.10
const SPEED = 10
const JUMP_VELOCITY = 9

const lerp_time = 10
var direction = Vector3.ZERO

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event is InputEventScreenDrag:
		if event.position.x > 300:
			rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
			HEAD.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
			
			HEAD.rotation.x = clamp(HEAD.rotation.x, deg_to_rad(-45), deg_to_rad(60))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") or JUMP_BTN.is_pressed() and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_time)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
'''
#-----> MOVER PERSONAJE CON TECLADO <-----
@export var h_sensibilidad = 0.0005
@export var v_sensibilidad = 0.001

@export var speed = 14
@export var fall_acceleration = 75

@export var jump_impulse = 22

var target_velocity = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y( - event.relative.x * h_sensibilidad)
		$Camera3D.rotate_x( - event.relative.y * v_sensibilidad)

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	direction = direction.rotated(Vector3(0, 1, 0), rotation.y )
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	
	velocity = target_velocity
	move_and_slide()
