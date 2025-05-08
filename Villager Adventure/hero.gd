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
var just_once_4 = true
var to_pos = false
var play_sigh = false
var pickable_sword = false
var in_dialogue = false
var has_sword = false
var at_dialogue_one = true
var at_dialogue_two = false
var look_at_hero_dia2 = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true # Replace with function body.
	rotation.y = 171
	rotation.x = 0
	rotation.z = 0


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
		
	if look_at_player == true and just_once_2 == true:
		var camera = $"../CharacterBody3D/neck/Camera3D"
		var target_pos = position
		target_pos.y += 0.6 
		camera.look_at(target_pos, Vector3(0, 1, 0))
	
	if move_to_player == true:
		#$turn_around.stop()
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
	
	if Input.is_action_just_pressed("AdvanceDialogue") and at_dialogue_one == true:
		if just_once_2 == true:
			$"../Dialogue1/Dia1fade".play("Fadeout")
			just_once_2 = false
			$skip.play()
			$whathappened/lookaround.start()
			move_to_player = false
			at_dialogue_one = false
			
	if just_once_2 == true and in_dialogue == true:
		$"../CharacterBody3D".velocity.x = 0
		$"../CharacterBody3D".velocity.z = 0
		
	if to_pos == true:
		$AnimationPlayer.play("Running")
		var go_to_pos = $AnimationPlayer2/wasdpos.position - position
		go_to_pos.y = 0
		var distance_to_pos = go_to_pos.length()
			
		if distance_to_pos > 0.3:
			var direction = go_to_pos.normalized()
			position += direction * 1.6 * delta
		else:
			to_pos = false
			$AnimationPlayer2.play("wasding")
			$AnimationPlayer2/sigh.play()
			play_sigh = true
			$"../chocolate/AnimationPlayer".play("fade")
			
		
	if play_sigh == true and $AnimationPlayer2/sigh.playing == false:
		$AnimationPlayer2/sigh.play()
		
	
	if pickable_sword == true and Input.is_action_just_pressed("Pickup"):
		$"../FindableSword".visible = false
		$"../FindableSword/Area3D/Label".visible = false
		$"../CharacterBody3D/neck/Camera3D/sword_1handed2".visible = true
		has_sword = true
		pickable_sword = false
	
	
	if has_sword == true:
		if $"../CharacterBody3D".position.z <= -6:
			$AnimationPlayer2.stop()
			has_sword = false
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Idle")
			look_at_player = true
			$"../Dialogue2/Diafade2".play("fadein")
			$"../Dialogue2".visible = true
			look_at_hero_dia2 = true
			play_sigh = false
	
	
	if look_at_player == true and look_at_hero_dia2 == true :
		var camera = $"../CharacterBody3D/neck/Camera3D"
		var target_pos = position
		target_pos.y += 0.6 
		camera.look_at(target_pos, Vector3(0, 1, 0))
	
	if Input.is_action_just_pressed("AdvanceDialogue") and at_dialogue_two == true:
		at_dialogue_two = false
		if just_once_4 == true:
			$"../Dialogue2/Diafade2".play("fadeout")
			just_once_4 = false
			$rewardyou.play()
			$accept.start()
	

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
			move_to_player = true
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Running")
			jumping = false
			keep_jumping = false
			look_at_player = true
			$AnimationPlayer/JumpExpire.stop()
			$AnimationPlayer/JumpAgain.stop()
			$"../Dialogue1/Dia1fade".play("Fadein")
			only_once = false
			$"../CharacterBody3D".can_input = false
			$"../CharacterBody3D".velocity.x = 0
			$"../CharacterBody3D".velocity.z = 0
			$"../Dialogue1/input_timer".start()
			$"../FindableSword/SpotLight3D".visible = true
			$whathappened.play()
			
			

func _on_input_timer_timeout() -> void:
	$"../CharacterBody3D".can_input = true
	in_dialogue = true
	


func _on_lookaround_timeout() -> void:
	$lookaround.play()
	$lookaround/gain_control.start()


func _on_gain_control_timeout() -> void:
	move_to_player = false
	to_pos = true
	$"../FindableSword/Area3D".monitoring = true
	
		

var just_once_3 = true
func _on_area_3d_body_entered(body: Node3D) -> void:
	if just_once_3 == true:
		just_once_3 = false
		$"../FindableSword/Area3D/Label".visible = true
		pickable_sword = true
		at_dialogue_two = true


func _on_accept_timeout() -> void:
	look_at_player = false
	$accept/accept.play()
	$Leave.play("leave")
	$AnimationPlayer.play("Running")
	


func _on_exit_area_shape_body_entered(body: Node3D) -> void:
	$"../fadeout/changescenefade".play("fade")
	$"../fadeout/changescene".start()

func _on_changescene_timeout() -> void:
	get_tree().change_scene_to_file("res://escort_level.tscn")
