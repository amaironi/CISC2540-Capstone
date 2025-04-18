extends CharacterBody3D

@onready var camera_3d = $neck/Camera3D
@onready var neck = $neck

var SPEED = 1
const JUMP_VELOCITY = 3
var can_input = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	$"../IntroCamera".current = true
	$"../IntroCamera/Intro".play("Intro")
	$"../IntroCamera/Timer".start()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_input == true:
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and can_input == true and can_input == true:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	elif can_input == true:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("test"):
		$neck/Camera3D.current = true
		#$"../IntroCamera/Timer".stop()
		$neck/Camera3D/Blurr_intro.play("unblurr")
		$"../QUESTS/CheckBox3".button_pressed = true
		$"../QUESTS/Node2D/SparklerQuest".play("Sparkle")

func _input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event is InputEventMouseMotion and can_input == true:
		camera_3d.rotate_x(-event.relative.y *0.004)
		neck.rotate_y(-event.relative.x*0.004)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	


func _on_timer_timeout() -> void:
	$neck/Camera3D.current = true
	$neck/Camera3D/Blurr_intro.play("unblurr")
	$"../QUESTS/CheckBox3".button_pressed = true
	$"../QUESTS/Node2D/SparklerQuest".play("Sparkle")


func _on_limp_timeout() -> void:
	if velocity != Vector3(0,0,0):
		$Limp/Limp.play("Limp")
		SPEED = 5
		$Limp/Limp/speed_reset.start()


func _on_speed_reset_timeout() -> void:
	SPEED = 1  # Replace with function body.
