extends Node3D

var frozen = true
var advance_first = true
var first_enemy = true
var hit_back = false
var wait_to_hit = false
var second_enemy = false
var just_once = true
var just_once_2 = true
var attack_enemy_2 = false
var stop_distance = 0.8
var speed = 1
var just_once_3 = true
var go_finish = false
var just_once_4 = true
var just_once_5 = true

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

		
	if hit_back == true and wait_to_hit == false:
		$AnimationPlayer.play("Striking")
		wait_to_hit = true
		$hero_waithit.start()
		$"../enemy".hp = $"../enemy".hp - 15
	
	if second_enemy == true:
		$AnimationPlayer.play("Running")
		position.z -= 0.3*delta
		position.x += 1*delta
		look_at(Vector3($"../Petal_3".position.x,0.7,$"../Petal_3".position.z),Vector3.UP, true)
		if just_once_2 == true:
			$"../enemy2".activate = true
			just_once_2 = false
	
	if position.z <= 3.8 and second_enemy == true:
		second_enemy = false
		$AnimationPlayer.play("PickingUp")
		$"../QUESTS/Node2D/SparklerQuest".play("Sparkle")
		$"../QUESTS/CheckBox4".text =  "COLLECT POPPIES 10/10"
		$"../QUESTS/CheckBox4".button_pressed = true
		$poppies.play()
		$attackenemy2.start()
	
	if attack_enemy_2 == true:
		var enemy = $"../enemy2"
		var target_position = Vector3(enemy.position.x, position.y, enemy.position.z)
		var to_enemy = target_position - position
		var distance = to_enemy.length()

		if distance > stop_distance:
			var direction = to_enemy.normalized()
			position += direction * speed * delta
		elif just_once_3 == true:
			$invincible_hit.start()
			just_once_3 = false

		look_at(Vector3(enemy.position.x,0.6,enemy.position.z),Vector3.UP,true)
	
	if go_finish == true and just_once_4 == true:
		just_once_4 = false
		$evillair.play()
	
	if go_finish == true:
		speed = 1.5
		var finish = $"../Area3D"
		var target_position = Vector3(finish.position.x, position.y, finish.position.z)
		var to_finish = target_position - position
		var distance = to_finish.length()
		look_at(Vector3(finish.position.x,0.6,finish.position.z),Vector3.UP,true)
		if just_once_5 == true:
			just_once_5 = false
			$"../Area3D/StaticBody3D".queue_free()

		if distance > stop_distance:
			$AnimationPlayer.play("Running")
			var direction = to_finish.normalized()
			position += direction * speed * delta
		else:
			visible = false

func _on_hero_waithit_timeout() -> void:
	wait_to_hit = false # Replace with function body.


func _on_attackenemy_2_timeout() -> void:
	attack_enemy_2 = true


func _on_invincible_hit_timeout() -> void:
			$AnimationPlayer.play("Striking")
			$"../enemy2".hp -= 15
			just_once_3 = true
