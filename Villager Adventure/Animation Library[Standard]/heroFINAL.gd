extends Node3D

var frozen = true
var stop_distance = 5
var speed = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var villain = $"../Villain/Node"
	var target_position = Vector3(villain.position.x, position.y, villain.position.z)
		
	if frozen == false:
		var to_villain = target_position - position
		var distance = to_villain.length()
		look_at(Vector3(villain.position.x,2.6,villain.position.z),Vector3.UP,true)

		if distance > stop_distance:
			var direction = to_villain.normalized()
			position -= direction * speed * delta
			#$"../Hero".hit_back = false
		else:
			$AnimationPlayer.play("Striking")
			#$"../Hero".hit_back = true
