extends Node3D

var jumping = false
var landing = false
var slide = false
var keep_jumping = true
var jump_count = 0
var can_rotate = true
var look_at_player = false
var move_to_player = false
var only_once = true
var just_once_2 = true
var to_pos = false
var play_sigh = false
var pickable_sword = false

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
		var player_pos = $"../CharacterBody3D".position
		player_pos.y = position.y  #same height
		look_at(player_pos, Vector3(0, 1, 0), true)
		move_to_player = true
		
		var camera = $"../CharacterBody3D/neck/Camera3D"
		var target_pos = position
		target_pos.y += 0.6 
		camera.look_at(target_pos, Vector3(0, 1, 0))
	
	if move_to_player == true:
		var to_player = $"../CharacterBody3D".position - position
		to_player.y = 0
		var distance = to_player.length()

		
		if distance > 1.4:
			var direction = to_player.normalized()
			position += direction * 1.6 * delta
		else:
			move_to_player = false
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Idle")  # Play Idle animation when close enough
		
	if Input.is_action_just_pressed("AdvanceDialogue"):
		if just_once_2 == true:
			$"../Trigger_start/Dialogue1/Fade".play("Fadeout")
			just_once_2 = false
			$skip.play()
			$whathappened/lookaround.start()
			
	if to_pos == true:
		$AnimationPlayer.play("Running")
		var go_to_pos = $AnimationPlayer2/wasdpos.position - position
		go_to_pos.y = 0
		var distance = go_to_pos.length()
			
		if distance > 0.1:
			var direction = go_to_pos.normalized()
			position += direction * 1.6 * delta
		else:
			to_pos = false
			$AnimationPlayer2.play("wasding")
			$AnimationPlayer2/sigh.play()
			play_sigh = true
			
		
		if play_sigh == true and $AnimationPlayer2/sigh.playing == false:
			$AnimationPlayer2/sigh.play()
			$"../chocolate/AnimationPlayer".play("fade")
	
		if pickable_sword == true and Input.is_action_just_pressed("Pickup"):
			$"../FindableSword".queue_free()
			#GIVE SWORD TO PLAYER

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


func _on_trigger_start_body_entered(body: Node3D) -> void:
		if only_once == true:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Running")
			jumping = false
			keep_jumping = false
			look_at_player = true
			$AnimationPlayer/JumpExpire.stop()
			$AnimationPlayer/JumpAgain.stop()
			$"../Trigger_start/Dialogue1/Fade".play("Fadein")
			$"../Trigger_start/Dialogue1".visible = true
			only_once = false
			$"../CharacterBody3D".can_input = false
			$"../CharacterBody3D".velocity.x = 0
			$"../CharacterBody3D".velocity.z = 0
			$"../Trigger_start/Dialogue1/Input_timer".start()
			$"../FindableSword/SpotLight3D".visible = true
			$whathappened.play()
			
			

func _on_input_timer_timeout() -> void:
	$"../CharacterBody3D".can_input = true
	


func _on_lookaround_timeout() -> void:
	$lookaround.play()
	$lookaround/gain_control.start()


func _on_gain_control_timeout() -> void:
	look_at_player = false
	move_to_player = false
	to_pos = true
	
		

var just_once_3 = true
func _on_area_3d_body_entered(body: Node3D) -> void:
	if just_once_3 == true:
		just_once_3 = false
		$"../FindableSword/Area3D/Label".visible = true
		pickable_sword = true
