extends Sprite2D

@export var dino_resource: Dino

func load_dino():
	Globals.curr_egg_hatch_time = Globals.egg_hatch_time
	Globals.curr_dino = dino_resource.dino_type
	texture = load("res://assets/Egg.png")
	Globals.reset_stats()
func hatch():
	$AnimationPlayer.play("egg_hatching")

func grow():
	$AnimationPlayer.play("dino_growing")

func make_hachling():
	texture = load("res://assets/Ball.png")
