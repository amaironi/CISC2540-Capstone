extends Node3D

var frozen = true
var advance_first = true
var first_ennemy = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frozen == false and advance_first == true:
		position.z -= 1.6*delta
		
	
	if position.z <= 6.8 and first_ennemy == true:
		advance_first = false
		first_ennemy = false
		$AnimationPlayer.play("Jumping")
		$"../enemy/AudioStreamPlayer3D".play()
		$"../enemy".visible = true
		$"../enemy/AnimationPlayer".play("Drop")
		$"../enemy".frozen = false
		$"../Label".visible = true
		
