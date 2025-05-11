extends Node3D

var frozen = true
var stop_distance = 5
var speed = 3
var just_once = true
var new_pos
var whirled = false
var hp = 200
var just_once_2 = true 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hero = $"../Hero"
	var target_position = Vector3(hero.position.x, position.y, hero.position.z)
		
	if frozen == false:
		var to_hero = target_position - position
		var distance = to_hero.length()
		look_at(Vector3($"../Hero".position.x,2.6,$"../Hero".position.z),Vector3.UP,true)

		if distance > stop_distance:
			$AnimationPlayer.play("Running")
			var direction = to_hero.normalized()
			position += direction * speed * delta
			#$"../Hero".hit_back = false
		else:
				#$"../Hero".hit_back = true
				$AnimationPlayer.play("Strike")
	
	if hp <= 0:
		visible = false
		$Bosshp.text = "EVILIUS, THE STEALER OF CHOCOLATE: DEFEATED"
		$"../AudioStreamPlayer".stop()
		$"../Hero".attack = false
		$"../questcomplete".visible = true
		if just_once_2 == true:
			$"../Hero".go_finish = true
			$"../questcomplete/AnimationPlayer".play("fade")
			$"../QUESTS/CheckBox".button_pressed = true
			$"../QUESTS/Node2D/SparklerQuest".play("Sparkle")
			just_once_2 = false
			$"../CSGBox3D/CSGBox3D7/CSGBox3D6/WallUnevenBrickDoorRound/StaticBody3D".queue_free()

	else:
		$Bosshp.text = "EVILIUS, THE STEALER OF CHOCOLATE: " + str(hp)

func _on_losehptimer_timeout() -> void:
	hp -= 15
	$"../Hero".just_once = true
