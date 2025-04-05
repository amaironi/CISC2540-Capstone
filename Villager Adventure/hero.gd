extends Node3D

var jumping = false
var landing = false
var slide = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if jumping == true:
		position.y += 0.2*delta
		position.x += 1.9*delta
	elif jumping == false and landing == true:
		position.x += 1.5*delta
		position.y -= 0.8*delta
	if slide == true:
		position.x+= 1.2*delta


func _on_timer_timeout() -> void:
	$ANIMATIONS.play("Jump_Start")
	$ANIMATIONS/jump_timer.start()
	jumping = true

func _on_jump_timer_timeout() -> void:
	$ANIMATIONS.play("Jump") 
	$ANIMATIONS/no_jump_timer.start()
	jumping = false
	landing = true

func _on_no_jump_timer_timeout() -> void:
	$ANIMATIONS.play("Jump_Land")
	landing = false
	slide = true
	$ANIMATIONS/slide.start()

func _on_slide_timeout() -> void:
	slide = false
