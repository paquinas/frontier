extends CharacterBody3D

@export var speed := 6.0
@export var jump_velocity := 4.0
@export var mouse_sensitivity := 0.02

@onready var camera_joint := $CameraJoint

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_joint.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_joint.rotation.x = clamp(
			camera_joint.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		position.y -= gravity * delta
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_foreward", "move_backward")
	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if dir:
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	move_and_slide()
