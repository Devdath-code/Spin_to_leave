extends VBoxContainer

@onready var label: Label = $Label
@onready var choice1: Button = $Button
@onready var choice2: Button = $Button2
@onready var base: Node2D = $"../.."

var current := "Rohan_1"
var before_interrupt := ""

var dialogue := {
	"Rohan_1": {
		"text": "Heyy, Can I play you a song?",
		"video": "Rohan_vid1",
		"choice1": "Yea sure ",
		"choice2": "Nah, i dont want my ears bleeding",
		"next1": "Rohan_2a",
		"next2": "Rohan_2b",
	},

	"Rohan_2a": {
		"text": "Here you go",
		"video": "Rohan_vid2",
		"choice1": "",
		"choice2": "",
		"next1": "Rohan_3",
		"next2": "Rohan_3",
	},

	"Rohan_2b": {
		"text": "Why do you have to mean, IM LEAVING",
		"video": "Rohan_vid4",
		"choice1": "",
		"choice2": "",
		"next1": "loading",
		"next2": "",
	},
	
	"Rohan_3": {
		"text": "Ohh Your still here, Nice\n word of advice watch out for the next person",
		"video": "Rohan_vid3",
		"choice1": "",
		"choice2": "",
		"next1": "loading",
		"next2": "",
	},

	"loading": {
		"text": "...",
		"video": "loading_screen",
		"choice1": "",
		"choice2": "",
		"next1": "shreshta_1",
		"next2": "",
	},

	"shreshta_1": {
		"text": "Hello, Im Shreshta, whats your nam-----",
		"video": "shreshta_vid1",
		"choice1": "",
		"choice2": "",
		"next1": "shreshta_2",
		"next2": "",
	},

	"shreshta_2": {
		"text": "Hey, wanna play a game?",
		"video": "shreshta_vid2",
		"choice1": "Yea sure",
		"choice2": "No",
		"next1": "shreshta_yes",
		"next2": "shreshta_no",
	},

	"shreshta_yes": {
		"text": "Alright, lets spin the wheel",
		"video": "spin_wheel_idle",
		"choice1": "",
		"choice2": "",
		"next1": "shreshta_spin_prompt",
		"next2": "",
	},

	"shreshta_no": {
		"text": "YOU REALLY THOUGHT YOU HAD AN OPTION",
		"video": "",
		"choice1": "",
		"choice2": "",
		"next1": "shreshta_no_2",
		"next2": "",
	},

	"shreshta_no_2": {
		"text": "SPIN THE WHEEL",
		"video": "spin_wheel_idle",
		"choice1": "",
		"choice2": "",
		"next1": "shreshta_spin_prompt",
		"next2": "",
	},

	"shreshta_spin_prompt": {
		"text": "Press the spin button",
		"video": "",
		"choice1": "",
		"choice2": "",
		"next1": "",
		"next2": "",
	},

	"shot_hide_seek": {
		"text": "",
		"video": "spin_wheel_1",
		"choice1": "",
		"choice2": "",
		"next1": "hide_seek_1",
		"next2": "",
	},
	
	"hide_seek_1":{
		"text":"Lets play a game",
		"video":"Shreshta_hidenseek_1",
		"choice1": "",
		"choice2": "",
		"next1": "hide_seek_2",
		"next2": "",
	},
	
	"hide_seek_2":{
		"text":"Lets play a game",
		"video":"Shreshta_hidenseek_2",
		"choice1": "",
		"choice2": "",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_smile": {
		"text": "",
		"video": "spin_wheel_2",
		"choice1": "",
		"choice2": "",
		"next1": "smile_1",
		"next2": "",
	},
	
	"smile_1": {
		"text": "smile",
		"video": "Shreshta_smile",
		"choice1": "",
		"choice2": "",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_brick": {
		"text": "why is everthing lagging",
		"video": "spin_wheel_4",
		"choice1": "...",
		"choice2": "",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_truth": {
		"text": "Are you ok %PLAYER% ",
		"video": "spin_wheel_3",
		"choice1": "",
		"choice2": "",
		"next1": "spin_ready",
		"next2": "",
	},

	"shot_leave": {
		"text": "",
		"video": "spin_wheel_5",
		"choice1": "",
		"choice2": "",
		"next1": "leave_1",
		"next2": "",
	},
	
	"leave_1": {
		"text": "NO NO NO NO ok you can leave now",
		"video": "Shreshta_leave",
		"choice1": "",
		"choice2": "",
		"next1": "quit",
		"next2": "",
	},

	"spin_ready": {
		"text": "Spin.",
		"video": "spin_wheel_idle",
		"choice1": "",
		"choice2": "",
		"next1": "",
		"next2": "",
	},

	"shreshta_skip": {
		"text": "Oh you thought you could skip",
		"video": "shreshta_skip_vid",
		"choice1": "",
		"choice2": "",
		"next1": "",
		"next2": "",
	},

	"cant_leave": {
		"text": "YOU CANT LEAVE",
		"video": "",
		"choice1": "",
		"choice2": "",
		"next1": "",
		"next2": "",
	},

	"quit": {
		"text": "...",
		"video": "",
		"choice1": "",
		"choice2": "",
		"next1": "",
		"next2": "",
	},
}

func _ready() -> void:
	choice1.visible = false
	choice2.visible = false
	show_dialogue("Rohan_1")


func show_dialogue(key: String) -> void:
	current = key
	#label.text = dialogue[key]["text"]
	#changes from here
	var display_text : String = dialogue[key]["text"]
	if "%PLAYER%" in display_text:
		display_text = display_text.replace("%PLAYER%", get_system_username())
	label.text = display_text
	#till here
	choice1.visible = false
	choice2.visible = false
	# Tell base to play the corresponding video.
	if dialogue[key]["video"] != "":
		await get_tree().get_root().get_node("base").play_video(dialogue[key]["video"])

	var c1 = dialogue[key]["choice1"]
	var c2 = dialogue[key]["choice2"]

	choice1.visible = c1 != ""
	choice2.visible = c2 != ""

	if c1 != "":
		choice1.text = c1

	if c2 != "":
		choice2.text = c2

	# Automatically continue if there are no choices.
	if c1 == "" and c2 == "" and dialogue[key]["next1"] != "":
		await get_tree().create_timer(1.0).timeout
		show_dialogue(dialogue[key]["next1"])

	# Enable the spin button once the game begins.
	if key == "shreshta_yes" or key == "shreshta_no_2" or key =="spin_ready":
		get_tree().get_root().get_node("base").enable_spin()
		base.enable_spin()
		base.can_spin = true
		base.enable_spin()
	if key == "quit":
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
	if key == "shot_brick":
		# 1. Clear out any visible buttons immediately
		choice1.visible = false
		choice2.visible = false
		label.text = "System Failure..." # Optional: set temporary background text
		
		# 2. Call the full-screen brick player on base.gd and wait for it to finish
		var base_node = get_tree().get_root().get_node("base")
		await base_node.play_fullscreen_brick()
		
		# 3. After the video finishes, redirect smoothly to spin_ready and exit early
		show_dialogue("spin_ready")
		return

func _on_button_pressed() -> void:
	var next = dialogue[current]["next1"]

	if next != "":
		show_dialogue(next)


func _on_button_2_pressed() -> void:
	var next = dialogue[current]["next2"]

	if next != "":
		show_dialogue(next)


func interrupt_skip() -> void:
	choice1.visible = false
	choice2.visible = false
	
	if current.begins_with("Rohan"):
		# Skip Rohan entirely.
		show_dialogue("shreshta_1")
	else:
		before_interrupt = current
		show_dialogue("shreshta_skip")

		await get_tree().create_timer(3.0).timeout

		show_dialogue(before_interrupt)


func interrupt_end() -> void:
	before_interrupt = current

	show_dialogue("cant_leave")

	await get_tree().create_timer(2.0).timeout

	show_dialogue(before_interrupt)

func get_system_username() -> String:
	var system_name := ""
	
	# Windows uses 'USERNAME'
	if OS.has_environment("USERNAME"):
		system_name = OS.get_environment("USERNAME")
	# Mac and Linux use 'USER'
	elif OS.has_environment("USER"):
		system_name = OS.get_environment("USER")
	
	# Fallback if both lookups fail for some reason
	if system_name == "":
		system_name = "Player"
		
	return system_name
