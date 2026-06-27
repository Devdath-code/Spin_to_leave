extends Node

@onready var skip: Button = $Control/skip
@onready var spin: Button = $Control/spin
@onready var end: Button = $Control/end
@onready var enemy: VideoStreamPlayer = $enemy
@onready var chatbox = $Control2/VBoxContainer

var end_press_count := 0
var game_started := false

var shots_seen := {
	"hide_seek": false,
	"smile": false,
	"mirror": false,
	"brick": false,
}

var leave_weight := 1
var shot_weight := 20

# Map video names to actual file paths.
var videos := {
	"Rohan_vid1": "res://video/Rohan/Rohan_intro.ogv",
	#"Rohan_vid2": "res://video/Rohan_vid2.ogv",
	#"Rohan_vid3": "res://video/Rohan_vid3.ogv",
	#"loading_screen": "res://video/loading_screen.ogv",
	##"shreshta_vid1": "res://video/shreshta_vid1.ogv",
	#"shreshta_vid2": "res://video/shreshta_vid2.ogv",
	#"shreshta_skip_vid": "res://video/shreshta_skip_vid.ogv",
	#"spin_wheel_idle": "res://video/spin_wheel_idle.ogv",
	#"spin_wheel_1": "res://video/spin_wheel_1.ogv",
	#"spin_wheel_2": "res://video/spin_wheel_2.ogv",
	#"spin_wheel_3": "res://video/spin_wheel_3.ogv",
	#"spin_wheel_4": "res://video/spin_wheel_4.ogv",
	#"spin_wheel_5": "res://video/spin_wheel_5.ogv",
	#"spin_wheel_6": "res://video/spin_wheel_6.ogv",
}

func _ready() -> void:
	spin.visible = false
	print("spin not visible")

func play_video(video_name: String) -> void:
	if videos.has(video_name):
		enemy.stream = load(videos[video_name])
		enemy.play()

func enable_spin() -> void:
	game_started = true
	spin.visible = true
	print("spin visible")

func _on_skip_pressed() -> void:
	chatbox.interrupt_skip()

func _on_end_pressed() -> void:
	end_press_count += 1

	if end_press_count == 1 or end_press_count > 10:
		if end_press_count > 10:
			shake_screen()

		chatbox.interrupt_end()

func _on_spin_pressed() -> void:
	if not game_started:
		return

	var result = weighted_random_shot()
	# spin.visible = false
	play_shot(result)

func weighted_random_shot() -> String:
	var pool := []

	for shot in shots_seen:
		if not shots_seen[shot]:
			for i in shot_weight:
				pool.append(shot)

	for i in leave_weight:
		pool.append("leave")

	pool.shuffle()
	return pool[0]

func play_shot(shot: String) -> void:
	match shot:
		"hide_seek":
			shots_seen["hide_seek"] = true
			leave_weight += 2
			chatbox.show_dialogue("shot_hide_seek")

		"smile":
			shots_seen["smile"] = true
			leave_weight += 2
			chatbox.show_dialogue("shot_smile")

		"mirror":
			shots_seen["mirror"] = true
			leave_weight += 2
			chatbox.show_dialogue("shot_mirror")

		"brick":
			shots_seen["brick"] = true
			leave_weight += 2
			chatbox.show_dialogue("shot_brick")

		"leave":
			chatbox.show_dialogue("shot_leave")

func shake_screen() -> void:
	var original: Vector2 = chatbox.position

	for i in 20:
		chatbox.position = original + Vector2(
			randf_range(-10, 10),
			randf_range(-10, 10)
		)

		await get_tree().create_timer(0.05).timeout

	chatbox.position = original
