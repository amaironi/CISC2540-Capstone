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
	if jump_count <= 3:
		if jumping == true and keep_jumping == true:
			position.x += 1.4*delta
		elif jumping == false and landing == true:
			position.x += 0.2*delta

	if look_at_player == true:
		look_at(Vector3($"../CharacterBody3D".position.x,$"../CharacterBody3D".position.y,$"../CharacterBody3D".position.z), Vector3(0,1,0), true)



func _on_timer_timeout() -> void:
	$AnimationPlayer.play("Jumping")
	jumping = true
	$AnimationPlayer/JumpExpire.start()


func _on_jump_expire_timeout() -> void:
	$AnimationPlayer.stop()
	jumping = false
	landing = true
	$AnimationPlayer/JumpAgain.start()
	
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
		#
		#if jump_count == 4 and can_rotate == true:
			##$turn_around.play("rotate_first")
			#can_rotate = false
