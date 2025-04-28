extends Node3D

var jumping = false
var landing = false
var slide = false
var keep_jumping = true
var jump_count = 0
var can_rotate = true
var look_at_player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if jump_count <= 2:
		if jumping == true and keep_jumping == true:
			position.x += 1.2*delta
		elif jumping == false and landing == true:
			position.x += 1.2*delta
			
	if jump_count >= 3:
		if jumping == true and keep_jumping == true:
			position.x -= 1.2*delta
		elif jumping == false and landing == true:
			position.x -= 1.2*delta

	if jump_count == 3 and can_rotate == true:
			$turn_around.play("rotate_first")
			can_rotate = false
	elif jump_count == 6 and can_rotate == false:
			$turn_around.play("rotate_back")
			jump_count = 0

			
	if look_at_player == true:
		look_at(Vector3($"../CharacterBody3D".position.x,$"../CharacterBody3D".position.y+1,$"../CharacterBody3D".position.z), Vector3(0,1,0), true)



func _on_timer_timeout() -> void:
	$AnimationPlayer.play("Jumping")
	jumping = true
	$AnimationPlayer/JumpExpire.start()


func _on_jump_expire_timeout() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Running")
	jumping = false
	landing = true
	$AnimationPlayer/JumpAgain.start()
	jump_count += 1
	
func _on_jump_again_timeout() -> void:
	$AnimationPlayer.play("Jumping")
	jumping = true
	landing = false
	$AnimationPlayer/JumpExpire.start()

#elif jumping == false and landing == true and keep_jumping == true:
			#position.x += 0.7*delta
		#if slide == true and keep_jumping == true:
			#position.x += 0.8*delta
	#
	#if jump_count >= 4:
		#if jumping == true and keep_jumping == true:
			#position.x -= 1.4*delta
		#elif jumping == false and landing == true and keep_jumping == true:
			#position.x -= 1*delta
		#if slide == true and keep_jumping == true:
			#position.x -= 0.8*delta
		


func _on_trigger_start_body_entered(body: Node3D) -> void:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Idle")
		jumping = false
		keep_jumping = false
		look_at_player = true
		$AnimationPlayer/JumpExpire.stop()
		$AnimationPlayer/JumpAgain.stop()
		var only_once = true
		if only_once == true:
			$"../Trigger_start/IntroDia/Fade".play("Fadein")
			$"../Trigger_start/IntroDia".visible = true
			only_once = false
		$"../CharacterBody3D".can_input = false
		$"../Trigger_start/Input_timer".start()

func _on_input_timer_timeout() -> void:
	$"../CharacterBody3D".can_input = false
