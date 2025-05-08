extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$Timer.start()
	$"../ColorRect".visible = true
	$"../ColorRect/AnimationPlayer".play("fade")
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
