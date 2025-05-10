extends Node3D

var frozen = true
var stop_distance = 6
var speed = 2
var just_once = true
var attack = true
var go_finish = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var villain = $"../Villain"
	var target_position = Vector3(villain.position.x, position.y, villain.position.z)
		#
	if frozen == false and attack == true:
		var to_villain = target_position - position
		var distance = to_villain.length()
		look_at(Vector3(villain.position.x,2.6,villain.position.z),Vector3.UP,true)
#
		if distance > stop_distance:
			var direction = to_villain.normalized()
			position += direction * speed * delta
			$AnimationPlayer.play("Running")

			#$"../Hero".hit_back = false
		else:
			if just_once == true:
				$AnimationPlayer.play("Striking")
				$"../losehptimer".start()
				just_once = false
			#$"../Hero".hit_back = true
	go_finish = true
	if go_finish == true:
		if position.z >= -26:
			$AnimationPlayer.play("Running")
			position.z -= 4*delta
			position.x -= 0.2*delta
		else:
			$AnimationPlayer.play("Idle")
