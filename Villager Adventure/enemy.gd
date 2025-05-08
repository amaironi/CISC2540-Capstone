extends Node3D

var frozen = true
var hp = 100
var speed = 0.7
var stop_distance = 0.8
var can_hit = false

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
		else:
			$AnimationPlayer.play("Swing")
	
	if hp <= 0:
		queue_free()
	
	if Input.is_action_just_pressed("swing") and can_hit == true:
		hp -= 2
		$"../Label".visible = false
		
	$Label3D.text = "HP: " + str(hp)

func _on_enemyhitbox_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	can_hit = true

func _on_enemyhitbox_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	can_hit = false # Replace with function body.
