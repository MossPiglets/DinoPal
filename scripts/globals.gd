extends Node

@export var dino_limit: int = 3
@export var egg_hatch_time: int = 30

enum dinos {DINO, DINO2, DINO3}
enum dino_states {EGG, HATCHLING, ADULT}
var loved_items: Dictionary = {dinos.DINO: ["meat", "towel", "ball"], dinos.DINO2: ["plant", "brush", "stick"]}
var hated_items: Dictionary = {dinos.DINO: ["plant", "sponge", "stick"], dinos.DINO2: ["meat", "towel", "ball"]}

var hunger: int = 0: 
	set(value):
		hunger = clamp(value, 0, 100)
var clean_egg: int = 0:
	set(value):
		clean_egg = clamp(value, 0, 100)
var clean_adult: int = 0:
	set(value):
		clean_adult = clamp(value, 0, 100)
var thrist: int = 0:
	set(value):
		thrist = clamp(value, 0, 100)
var fun: int = 0:
	set(value):
		fun = clamp(value, 0, 100)
var energy: int = 100:
	set(value):
		energy = clamp(value, 0, 100)
var health: int = 100:
	set(value):
		health = clamp(value, 0, 100)
var warmth: int = 0:
	set(value):
		warmth = clamp(value, 0, 100)
var affection: int = 0:
	set(value):
		affection = clamp(value, 0, 100)
var hatch_percentage = 0
var curr_egg_hatch_time = egg_hatch_time:
	set(value):
		curr_egg_hatch_time = value
		if value <= 0 and curr_dino_state == dino_states.EGG:
			value = 0
			hatch_egg()
var curr_dino: dinos
var curr_dino_state: dino_states
var owned_dinos: Array[dinos]
var has_grown = false

signal stats_changed
signal state_changed

func _process(_delta):
	if get_stat_sum() == 400 and not has_grown:
		grow_hachling()
		has_grown = true

func hatch_egg():
	curr_dino_state = dino_states.HATCHLING
	state_changed.emit()

func grow_hachling():
	curr_dino_state = dino_states.ADULT
	state_changed.emit()

func get_hatch_time_update():
	var value: int =  round((5 * (get_stat_sum()))/300)
	if value == 0:
		value = 1
	return value

func get_stat_sum():
	if curr_dino_state == dino_states.EGG:
		return warmth + affection + clean_egg
	else:
		return hunger + thrist + clean_adult + fun

func use_item(item, type):
	var value
	if loved_items[curr_dino].has(item):
		value = 50
	elif hated_items[curr_dino].has(item):
		value = 0
	else:
		value = 25
	match type:
		"hunger":
			hunger += value
		"clean_egg":
			clean_egg += value
		"clean_adult":
			clean_adult += value
		"thrist":
			thrist += value
		"fun":
			fun += value
		"energy":
			energy += value
		"health":
			health += value
	stats_changed.emit()	
	if value == 0:
		return true
	return false

func egg_take_care(type):
	match type:
		"warm":
			warmth += 25
		"clean":
			clean_egg += 25
		"talk":
			affection += 25
	stats_changed.emit()
