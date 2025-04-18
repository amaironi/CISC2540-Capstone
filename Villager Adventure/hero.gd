extends Node3D

var jumping = false
var landing = false
var slide = false
var keep_jumping = true
var jump_count = 0
var can_rotate = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if jump_count <= 3:
		if jumping == true and keep_jumping == true:
			position.y += 0.24*delta
			position.x += 1.9*delta
		elif jumping == false and landing == true and keep_jumping == true:
			position.x += 1.5*delta
			position.y -= 0.7*delta
		if slide == true and keep_jumping == true:
			position.x += 1.2*delta
	
	if jump_count >= 4:
		if jumping == true and keep_jumping == true:
			position.y += 0.24*delta
			position.x -= 1.9*delta
		elif jumping == false and landing == true and keep_jumping == true:
			position.x -= 1.5*delta
			position.y -= 0.7*delta
		if slide == true and keep_jumping == true:
			position.x -= 1.2*delta
		
		if jump_count == 4 and can_rotate == true:
			$turn_around.play("rotate_first")
			can_rotate = false
		


func _on_timer_timeout() -> void:
	$ANIMATIONS.play("Jump_Start")
	$ANIMATIONS/jump_timer.start()
	jumping = true

func _on_jump_timer_timeout() -> void:
	if keep_jumping == true:
		$ANIMATIONS.play("Jump") 
		$ANIMATIONS/no_jump_timer.start()
		jumping = false
		landing = true
		$ANIMATIONS/restart_jump.start()

func _on_no_jump_timer_timeout() -> void:
	if keep_jumping == true:
		$ANIMATIONS.play("Jump_Land")
		landing = false
		slide = true
		$ANIMATIONS/slide.start()
		jump_count += 1
		if jump_count == 8:
			jump_count = 0
			can_rotate = true
			$turn_around.play("rotate_back")

func _on_slide_timeout() -> void:
	if keep_jumping == true:
		slide = false


func _on_restart_jump_timeout() -> void:
	if keep_jumping == true:
		$ANIMATIONS.play("Jump_Start")
		$ANIMATIONS/jump_timer.start()
		jumping = true

func _on_trigger_start_body_entered(body: Node3D) -> void:
	$ANIMATIONS.play("Idle_Talking")
	keep_jumping = false
