extends Node3D

var activate = false
var just_once = true
var frozen = true
var hp = 100
var stop_distance = 1
var speed = 1.1
var hits = 0
var just_once_2 = true
var just_once_3 = true
var can_be_hit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = $"../CharacterBody3D"
	var target_position = Vector3(player.position.x, position.y, player.position.z)
	

	if activate == true and just_once == true:
		visible = true
		$AnimationPlayer.play("Drop")
		frozen = false
		just_once = false
	
	$Label3D2.text = "HP: " + str(hp)
	
	if frozen == false:
		var to_player = target_position - position
		var distance = to_player.length()
		look_at(Vector3(player.position.x,0.6,player.position.z),Vector3.UP,true)

		if distance > stop_distance:
			var direction = to_player.normalized()
			position += direction * speed * delta
		elif just_once_2 == true:
			$AnimationPlayer.play("Swing")
			hits += 1 
			$"../hit/AnimationPlayer".play("fadein")
			$hit_reset.start()
			just_once_2 = false

	
	if Input.is_action_just_pressed("swing") and can_be_hit == true:
		hp -= 2
		
	if hp <= 0:
		frozen = true
		$"../Hero".attack_enemy_2 = false
		visible = false
		position.y -= 100
		$"../Hero".go_finish = true

		


func _on_hit_reset_timeout() -> void:
	just_once_2 = true



func _on_area_3d_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	can_be_hit = true # Replace with function body.


func _on_area_3d_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	can_be_hit = false # Replace with function body.


func _on_restart_timeout() -> void:
	get_tree().change_scene_to_file("res://escort_level_invincible.tscn")
