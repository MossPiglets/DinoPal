extends Control

@onready var pop_up_container

enum menu_states {FEED, CLEAN, FUN}
var curr_menu_state: menu_states = menu_states.FEED
var food_items: Array = ["meat", "plant", "water"]
var clean_items: Array = ["sponge", "towel", "brush"]
var fun_items: Array = ["ball", "stick", "feather_boa"]
@onready var hunger_label = $StatsAdult/VBoxContainer/Stats/Hunger/HungerLabel
@onready var clean_label_adult = $StatsAdult/VBoxContainer/Stats/Clean/CleanLabel
@onready var energy_label = $StatsAdult/VBoxContainer/Stats/Energy/EnergyLabel
@onready var thrist_label = $StatsAdult/VBoxContainer/Stats/Thirst/ThristLabel
@onready var fun_label = $StatsAdult/VBoxContainer/Stats/Fun/FunLabel
@onready var health_label = $StatsAdult/VBoxContainer/Stats/Health/HealthLabel
@onready var warmth_label = $StatsEgg/VBoxContainer/Stats/Warmth/WarmthLabel
@onready var affection_label = $StatsEgg/VBoxContainer/Stats/Affection/AffectionLabel
@onready var clean_label_egg = $StatsEgg/VBoxContainer/Stats/Clean/CleanLabel
@onready var pop_up_button_1 = $DownButtonsAdult/VBoxContainer/PopUpContainer/PopUpContainer/PopUpButton1
@onready var pop_up_button_2 = $DownButtonsAdult/VBoxContainer/PopUpContainer/PopUpContainer/PopUpButton2
@onready var pop_up_button_3 = $DownButtonsAdult/VBoxContainer/PopUpContainer/PopUpContainer/PopUpButton3

signal new_egg_needed

func _ready():
	Globals.curr_dino_state = Globals.dino_states.EGG
	if Globals.curr_dino_state == Globals.dino_states.EGG:
		pop_up_container = null
	else:
		pop_up_container = $DownButtonsAdult/VBoxContainer/PopUpContainer
	Globals.stats_changed.connect(update_stats_progress_bars)
	Globals.state_changed.connect(change_dino_state)
	update_stats_progress_bars()

func _process(_delta):
	if Input.is_action_just_pressed("bath"):
		if Globals.curr_dino_state == Globals.dino_states.EGG:
			Globals.curr_dino_state = Globals.dino_states.ADULT
		else:
			Globals.curr_dino_state = Globals.dino_states.EGG
		change_dino_state()

func update_stats_progress_bars():
	if Globals.curr_dino_state == Globals.dino_states.EGG:
		$StatsEgg/VBoxContainer/Stats/Warmth.value = Globals.warmth
		warmth_label.text = str(Globals.warmth)
		$StatsEgg/VBoxContainer/Stats/Clean.value = Globals.clean_egg
		clean_label_egg.text = str(Globals.clean_egg)
		$StatsEgg/VBoxContainer/Stats/Affection.value = Globals.affection
		affection_label.text = str(Globals.affection)
	else:
		$StatsAdult/VBoxContainer/Stats/Hunger.value = Globals.hunger
		hunger_label.text = str(Globals.hunger)
		$StatsAdult/VBoxContainer/Stats/Clean.value = Globals.clean_adult
		clean_label_adult.text = str(Globals.clean_adult)
		$StatsAdult/VBoxContainer/Stats/Energy.value = Globals.energy
		energy_label.text = str(Globals.energy)
		$StatsAdult/VBoxContainer/Stats/Thirst.value = Globals.thrist
		thrist_label.text = str(Globals.thrist)
		$StatsAdult/VBoxContainer/Stats/Fun.value = Globals.fun
		fun_label.text = str(Globals.fun)
		$StatsAdult/VBoxContainer/Stats/Health.value = Globals.health
		health_label.text = str(Globals.health)

func _on_feed_pressed():
	if not pop_up_container == null:
		change_visibility(menu_states.FEED)
		pop_up_container.size_flags_horizontal = SIZE_SHRINK_BEGIN
	change_pop_up_buttons()

func _on_clean_pressed():
	if Globals.curr_dino_state == Globals.dino_states.EGG:
		Globals.egg_take_care("clean")
	else:
		if not pop_up_container == null:
			change_visibility(menu_states.CLEAN)
			pop_up_container.size_flags_horizontal = SIZE_SHRINK_CENTER
		change_pop_up_buttons()

func _on_play_pressed():
	if not pop_up_container == null:
		change_visibility(menu_states.FUN)
		pop_up_container.size_flags_horizontal = SIZE_SHRINK_END
	change_pop_up_buttons()

func _on_warm_pressed():
	Globals.egg_take_care("warm")

func _on_talk_pressed():
	Globals.egg_take_care("talk")

func change_pop_up_buttons():
	match curr_menu_state:
		menu_states.FEED:
			pop_up_button_1.texture_normal = load_textur("res://assets/meat.png")
			pop_up_button_2.texture_normal = load_textur("res://assets/plant.png")
			pop_up_button_3.texture_normal = load_textur("res://assets/water.png")
		menu_states.CLEAN:
			pop_up_button_1.texture_normal = load_textur("res://assets/brush.png")
			pop_up_button_2.texture_normal = load_textur("res://assets/towel.png")
			pop_up_button_3.texture_normal = load_textur("res://assets/Sponge.png")
		menu_states.FUN:
			pop_up_button_1.texture_normal = load_textur("res://assets/Ball.png")
			pop_up_button_2.texture_normal = load_textur("res://assets/stick.png")
			pop_up_button_3.texture_normal = load_textur("res://assets/quill.png")

func load_textur(path: String):
	var image = Image.new()
	image.load(path)
	return ImageTexture.create_from_image(image)

func change_dino_state():
	if pop_up_container:
		pop_up_container.hide()
	match Globals.curr_dino_state:
		Globals.dino_states.EGG:
			show_egg_ui()
		Globals.dino_states.HATCHLING:
			$"../../Sprite2D".hatch()
			show_adult_ui()
		Globals.dino_states.ADULT:
			$"../../Sprite2D".grow()
			show_adult_ui()
	update_stats_progress_bars()

func show_egg_ui():
	$StatsEgg.show()
	$StatsAdult.hide()
	$DownButtonsAdult.hide()
	$DownButtonsEgg.show()
	pop_up_container = null

func show_adult_ui():
	$StatsEgg.hide()
	$StatsAdult.show()
	if Globals.curr_dino_state == Globals.dino_states.ADULT:
		$StatsAdult/VBoxContainer/NewEggButton.show()
	else:
		$StatsAdult/VBoxContainer/NewEggButton.hide()
	$DownButtonsAdult.show()
	$DownButtonsEgg.hide()
	pop_up_container = $DownButtonsAdult/VBoxContainer/PopUpContainer

func change_visibility(state: menu_states):
	if pop_up_container == null:
		return
	if curr_menu_state == state:
		pop_up_container.visible = not pop_up_container.visible
	else:
		pop_up_container.show()
	curr_menu_state = state

func _on_stats_falling_timer_timeout():
	if Globals.curr_dino_state == Globals.dino_states.EGG:
		Globals.warmth -= 1
		Globals.clean_egg -= 1
		Globals.affection -= 1
	else:
		Globals.hunger -= 1
		Globals.clean_adult -= 1
		Globals.thrist -= 1
		Globals.fun -= 1
	update_stats_progress_bars()

func _on_hatch_timer_timeout():
	var hatch_time_update = Globals.get_hatch_time_update()
	Globals.curr_egg_hatch_time -= hatch_time_update
	var hatch_time = round(Globals.curr_egg_hatch_time / hatch_time_update)
	var percentage = round((float(Globals.egg_hatch_time - hatch_time) / float(Globals.egg_hatch_time)) * 100)
	$StatsEgg/VBoxContainer/HatchProgressBar/ProgressBar.value = percentage
	var minutes = str(hatch_time / 60)
	var seconds = hatch_time%60
	if seconds < 10:
		seconds = "0%s" % seconds
	$StatsEgg/VBoxContainer/HatchProgressBar/HatchProgresBarLable.text = "%s hatch in %s:%s" % [str(percentage) + "%", minutes, seconds]

func _on_pop_up_button_1_pressed():
	var hated
	match curr_menu_state:
		menu_states.FEED:
			hated = Globals.use_item("meat", "hunger")
		menu_states.CLEAN:
			hated = Globals.use_item("brush", "clean_adult")
		menu_states.FUN:
			hated = Globals.use_item("ball", "fun")
	if hated:
		Globals.health -= 10

func _on_pop_up_button_2_pressed():
	var hated
	match curr_menu_state:
		menu_states.FEED:
			hated = Globals.use_item("plant", "hunger")
		menu_states.CLEAN:
			hated = Globals.use_item("towel", "clean_adult")
		menu_states.FUN:
			hated = Globals.use_item("stick", "fun")
	if hated:
		Globals.health -= 10

func _on_pop_up_button_3_pressed():
	var hated
	match curr_menu_state:
		menu_states.FEED:
			hated = Globals.use_item("water", "thrist")
		menu_states.CLEAN:
			hated = Globals.use_item("sponge", "clean_adult")
		menu_states.FUN:
			hated = Globals.use_item("feather_boa", "fun")
	if hated:
		Globals.health -= 10

func _on_new_egg_button_pressed():
	new_egg_needed.emit()
