extends Node3D

var flip = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$introcam.current = true
	$introcamanimations.play("intro")
	$introcam/intro1.start()
	$"../AnimationPlayer".play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flip == true and $"../AnimationPlayer".current_animation == "flip":
		$"..".position.z += 12*delta


		
	if $"../AnimationPlayer".current_animation == "Running":
		$"..".position.z += 3*delta


func _on_intro_1_timeout() -> void:
	$introcam2.current = true
	$introcamanimations.play("intro2")
	$introcam2/intro2.start()
	

func _on_intro_2_timeout() -> void:
	$introcam3.current = true
	$introcamanimations.play("introcam3")
	$introcam3/intro3.start()
	flip = true
	$"../AnimationPlayer".play("Flip")
	$flip.start()

func _on_intro_3_timeout() -> void:
	$"../../CharacterBody3D2/neck/Camera3D".current = true
	$introcam/finishintro.start()


func _on_finishintro_timeout() -> void:
	$"../AnimationPlayer".play("Idle")
	$"../../CharacterBody3D2".can_input = true
	$"../Bosshp".visible = true
	$"..".frozen = false
	$"../../Hero".frozen = false

func _on_flip_timeout() -> void:
	$"../AnimationPlayer".play("Running")
	$"../../DefeatEvilius".visible = true
	$"../../DefeatEvilius/fadedefeat".play("fadetext")
