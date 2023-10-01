extends Node2D


func _ready():
	get_random_egg()

func get_random_egg():
	var random_float = randf()
	if random_float < 0.5:
		$Sprite2D.dino_resource = load("res://resources/dino1.tres")
	else:
		$Sprite2D.dino_resource = load("res://resources/dino2.tres")
	Globals.curr_dino_state = Globals.dino_states.EGG
	$Sprite2D.load_dino()
	$CanvasLayer/UI.change_dino_state()

func _on_ui_new_egg_needed():
	get_random_egg()
