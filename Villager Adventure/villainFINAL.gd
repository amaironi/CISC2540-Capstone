extends Node3D

var frozen = true
var stop_distance = 10
var speed = 3
var just_once = true
var new_pos
var whirled = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hero = $Hero
	var target_position = Vector3(hero.position.x, position.y, hero.position.z)
		
	if frozen == false:
		var to_hero = target_position - position
		var distance = to_hero.length()
		look_at(Vector3($"../Hero".position.x,2.6,$"../Hero".position.z),Vector3.UP,true)

		if distance > stop_distance+7:
			var direction = to_hero.normalized()
			position += direction * speed * delta
			#$"../Hero".hit_back = false
		else:
			if just_once == true:
				$AnimationPlayer.play("Whirl")
				just_once = false
				#$"../Hero".hit_back = true
			elif $AnimationPlayer.current_animation != "Whirl" and whirled == true:
				$AnimationPlayer.play("Strike")
	
			if $AnimationPlayer.current_animation == "Whirl":
				whirled = true
			if $AnimationPlayer.current_animation != "Whirl" and whirled == true:
				position.x = 1.7
				position.z = 5
