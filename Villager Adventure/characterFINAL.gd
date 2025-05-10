extends CharacterBody3D

@onready var camera_3d = $neck/Camera3D
@onready var neck = $neck

const SPEED = 5
const JUMP_VELOCITY = 3
var can_input = true
var can_hit = true
var damageable = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if can_hit == true:
		if Input.is_action_just_pressed("swing"):
			can_hit = false
			$waithit.start()
			$neck/Camera3D/Node3D/AnimationPlayer.play("Swing")
			if damageable == true:
				$"../Villain".hp -= 2

func _input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event is InputEventMouseMotion and can_input == true:
		camera_3d.rotate_x(-event.relative.y *0.004)
		neck.rotate_y(-event.relative.x*0.004)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	


func _on_waithit_timeout() -> void:
	can_hit = true # Replace with function body.


func _on_area_3d_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	damageable = true # Replace with function body.


func _on_area_3d_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	damageable = false # Replace with function body.
