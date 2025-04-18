extends CharacterBody3D

@onready var camera_3d = $neck/Camera3D
@onready var neck = $neck

var SPEED = 1
const JUMP_VELOCITY = 3
var can_input = true
var hero_run = false
var hit = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	pass
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and can_input == true:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	elif can_input == true:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("test"):
		$"../AnimationLibrary_Godot_Standard/AnimationPlayer".play("Jog_Fwd")
		hero_run = true
		$"../AnimationLibrary_Godot_Standard/AudioStreamPlayer3D".play()
	
	if hero_run == true:
		$"../AnimationLibrary_Godot_Standard".position.x -= 2*delta
		$"../AnimationLibrary_Godot_Standard".position.z += 1.5*delta
	
	if $"../AnimationLibrary_Godot_Standard".position.x <= 0.5 and hit == true:
		$"../AnimationLibrary_Godot_Standard/AnimationPlayer".play("Sword_Attack")
		hit = false
		hero_run = false
		$Hit.play("Hit")

func _input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event is InputEventMouseMotion and can_input == true:
		camera_3d.rotate_x(-event.relative.y *0.004)
		neck.rotate_y(-event.relative.x*0.004)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	
