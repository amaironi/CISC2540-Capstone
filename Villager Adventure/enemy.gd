extends Node3D

var frozen = true
var hp = 100
var speed = 0.7
var stop_distance = 0.8
var can_hit = false
var win = false
var just_once = true
var damageable = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hero = $"../Hero"
	var target_position = Vector3(hero.position.x, position.y, hero.position.z)

	look_at(Vector3($"../Hero".position.x,0.6,$"../Hero".position.z),Vector3.UP,true)


	if frozen == false:
		var to_hero = target_position - position
		var distance = to_hero.length()

		if distance > stop_distance:
			var direction = to_hero.normalized()
			position += direction * speed * delta
			$"../Hero".hit_back = false
		else:
			$AnimationPlayer.play("Swing")
			$"../Hero".hit_back = true
			

	if hp <= 0 and win == false:
		frozen = true
		$"../Hero".hit_back = false
		$"../Hero/AnimationPlayer".play("Idle")
		visible = false
		position.y = -100
		position.x = 200
		position.z = 200
		$"../Label".visible = false
		win = true
		$"../Hero".first_enemy = false

	if win == true and just_once == true:
		$"../Hero/alwaystriumphant".play()
		just_once = false
		$"../Hero".second_enemy = true
	
	
	if Input.is_action_just_pressed("swing") and can_hit == true and damageable == true:
		hp -= 2
		damageable = false
		$"../Label".visible = false
		$"../Hero/AnimationPlayer".play("Idle")
		
	$Label3D.text = "HP: " + str(hp)

func _on_enemyhitbox_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	can_hit = true

func _on_enemyhitbox_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	can_hit = false # Replace with function body.


func _on_wait_to_hit_timeout() -> void:
	damageable = true # Replace with function body.
