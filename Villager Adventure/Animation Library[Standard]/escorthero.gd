extends Node3D

var frozen = true
var advance_first = true
var first_enemy = true
var hit_back = false
var wait_to_hit = false
var second_enemy = false
var just_once = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frozen == false and advance_first == true:
		position.z -= 1.6*delta
		
	
	if position.z <= 6.8 and first_enemy == true:
		advance_first = false
		first_enemy = false
		$AnimationPlayer.play("Jumping")
		$"../enemy/AudioStreamPlayer3D".play()
		$"../enemy".visible = true
		$"../enemy/AnimationPlayer".play("Drop")
		$"../enemy".frozen = false
		$"../Label".visible = true
		
	if hit_back == true and wait_to_hit == false:
		$AnimationPlayer.play("Striking")
		wait_to_hit = true
		$hero_waithit.start()
		$"../enemy".hp = $"../enemy".hp - 15
	
	if first_enemy == false and just_once == true:
		second_enemy = true
		just_once = false
		$AnimationPlayer.play("Running")
		
	if second_enemy == true:
		position.z -= 0.3*delta
		position.x += 0.8*delta
	
	if position.z <= 5 and second_enemy == true:
		second_enemy = false


func _on_hero_waithit_timeout() -> void:
	wait_to_hit = false # Replace with function body.
