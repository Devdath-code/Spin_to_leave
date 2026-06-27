extends VBoxContainer

@onready var label: Label = $Label
@onready var choice1: Button = $Button
@onready var choice2: Button = $Button2

var current := "Rohan_1"
var before_interrupt := ""

var dialogue := {
	"Rohan_1": {
		"text": "Yooo, camera off huh?",
		"video": "Rohan_vid1",
		"choice1": "Yea, don't wanna show my face",
		"choice2": "Yea, what about it",
		"next1": "Rohan_2a",
		"next2": "Rohan_2b",
	},

	"Rohan_2b": {
		"text": "Turn it on, I have mine on don't I",
		"video": "Rohan_vid2",
		"choice1": "Nahh not doing that",
		"choice2": "Get lost creep",
		"next1": "Rohan_3b_1",
		"next2": "Rohan_bye",
	},

	"Rohan_bye": {
		"text": "ok I don't need this hostility BYE",
		"video": "",
		"choice1": "",
		"choice2": "",
		"next1": "loading",
		"next2": "",
	},

	"Rohan_3b_1": {
		"text": "...",
		"video": "Rohan_vid3",
		"choice1": "",
		"choice2": "",
		"next1": "loading",
		"next2": "",
	},

	"Rohan_2a": {
		"text": "Fair enough. Please don't steal my data",
		"video": "Rohan_vid2",
		"choice1": "I know where you live,\nsend me 50 grand or\nI will send 47 cruise missiles where you live",
		"choice2": "Don't worry, I won't",
		"next1": "Rohan_3a",
		"next2": "Rohan_3a",
	},

	"Rohan_3a": {
		"text": "Alr nice speaking with u, gotta go",
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
		"next1": "shreshta_2",
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
		"text": "Why dont u wanna play with me",
		"video": "spin_wheel_2",
		"choice1": "Im here",
		"choice2": "Stop",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_smile": {
		"text": "Smile for me",
		"video": "spin_wheel_3",
		"choice1": ":)",
		"choice2": "No",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_mirror": {
		"text": "I know who you are",
		"video": "spin_wheel_4",
		"choice1": "How",
		"choice2": "Stop",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_brick": {
		"text": "Its not over",
		"video": "spin_wheel_5",
		"choice1": "...",
		"choice2": "",
		"next1": "spin_ready",
		"next2": "spin_ready",
	},

	"shot_leave": {
		"text": "NO NO NO NO ok you can leave now",
		"video": "spin_wheel_6",
		"choice1": "Leave",
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
	label.text = dialogue[key]["text"]

	# Tell base to play the corresponding video.
	if dialogue[key]["video"] != "":
		get_tree().get_root().get_node("base").play_video(dialogue[key]["video"])

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
		await get_tree().create_timer(3.0).timeout
		show_dialogue(dialogue[key]["next1"])

	# Enable the spin button once the game begins.
	if key == "shreshta_yes" or key == "shreshta_no_2":
		get_tree().get_root().get_node("base").enable_spin()

	if key == "quit":
		await get_tree().create_timer(3.0).timeout
		get_tree().quit()


func _on_button_pressed() -> void:
	var next = dialogue[current]["next1"]

	if next != "":
		show_dialogue(next)


func _on_button_2_pressed() -> void:
	var next = dialogue[current]["next2"]

	if next != "":
		show_dialogue(next)


func interrupt_skip() -> void:
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
