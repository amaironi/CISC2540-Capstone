extends CharacterBody3D

@onready var camera_3d = $neck/Camera3D
@onready var neck = $neck

var SPEED = 1.3
const JUMP_VELOCITY = 3
var can_input = true
var hero_run = false
var hit = true
var just_once = true
var can_hit = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	$"../fadein/AnimationPlayer2".play("fadein")
	$"../Dialogue1/Dia1fade".play("Fadein")
	SPEED = 0
	
	if $"../Background_ambiance".playing == false:
		$"../Background_ambiance".play()
	
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
	
	if can_hit == true:
		if Input.is_action_just_pressed("swing"):
			can_hit = false
			$"../Hero/wait_to_hit".start()
			$neck/Camera3D/Node3D/AnimationPlayer.play("Swing")


	
	if just_once == true and Input.is_action_just_pressed("AdvanceDialogue"):
		just_once = false
		$"../Dialogue1/Dia1fade".play("Fadeout")
		SPEED = 1.2
		$"../Dialogue1/hostiles".play()
		$"../Dialogue1/herofreeze".start()
	#$Hit.play("Hit")

func _input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event is InputEventMouseMotion and can_input == true:
		camera_3d.rotate_x(-event.relative.y *0.004)
		neck.rotate_y(-event.relative.x*0.004)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	


func _on_herofreeze_timeout() -> void:
	$"../Hero/AudioStreamPlayer3D".play()
	$"../Hero/AnimationPlayer".play("Running")
	$"../Hero".frozen = false
	


func _on_wait_to_hit_timeout() -> void:
	can_hit = true # Replace with function body.
