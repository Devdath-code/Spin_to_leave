extends Node

@onready var skip: Button = $Control/skip
@onready var spin: Button = $Control/spin
@onready var end: Button = $Control/end
@onready var enemy: VideoStreamPlayer = $Control/enemy
@onready var chatbox = $Control2/VBoxContainer
@onready var bricklayer: CanvasLayer = $bricklayer
@onready var full_screen_video: VideoStreamPlayer = $bricklayer/FullScreenVideo

var end_press_count := 0
var game_started := false

var shots_seen := {
	"hide_seek": false,
	"smile": false,
	"truth": false,
	"brick": false,
}

var leave_weight := 1
var shot_weight := 20
var can_spin := false
# Map video names to actual file paths.
var videos := {
	"Rohan_vid1": "res://video/Rohan/Rohan_intro.ogv",
	"Rohan_vid2": "res://video/Rohan/Rohan_talent.ogv",
	"Rohan_vid3": "res://video/Rohan/Rohan_happy.ogv",
	"Rohan_vid4": "res://video/Rohan/Rohan_sad.ogv",
	#"loading_screen": "res://video/loading_screen.ogv",
	"shreshta_vid1": "res://video/Shreshta/Shreshta_my_name_is_Shreshta.ogv",
	"shreshta_vid2": "res://video/Shreshta/Hey_wanna_play_a_game_edited.ogv",
	"Shreshta_hidenseek_1":"res://video/Shreshta/Hidenseek_edited_reverse_walk.ogv",
	"Shreshta_hidenseek_2":"res://video/Shreshta/HidenSeek_jumpscare_edited.ogv",
	"Shreshta_smile":"res://video/Shreshta/smile_edited.ogv",
	"Shreshta_leave":"res://video/Shreshta/leave_edited.ogv",
	#"shreshta_skip_vid": "res://video/shreshta_skip_vid.ogv",
	"spin_wheel_idle": "res://video/spin/spin_idle.ogv",
	"spin_wheel_1": "res://video/spin/spin_hidenseek.ogv",
	"spin_wheel_2": "res://video/spin/spin_smile.ogv",
	"spin_wheel_3": "res://video/spin/spin_truth.ogv",
	"spin_wheel_4": "res://video/spin/spin_brick.ogv",
	"spin_wheel_5": "res://video/spin/spin_leave.ogv",
	"bluescreen": "res://video/bluescreen.ogv",
}

func _ready() -> void:
	spin.visible = false
	print("spin not visible")

func play_video(video_name: String) -> void:
	# If enemy hasn't been initialized by @onready yet, grab it now
	if enemy == null:
		enemy = $Control/enemy
		
	if videos.has(video_name):
		enemy.stream = load(videos[video_name])
		enemy.play()
		await enemy.finished

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
	if not game_started or not can_spin:
		return

	var result = weighted_random_shot()
	# spin.visible = false
	play_shot(result)
	can_spin = false
	spin.visible = false

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

		"truth":
			shots_seen["truth"] = true
			leave_weight += 2
			chatbox.show_dialogue("shot_truth")

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
func play_fullscreen_brick() -> void:
	
	if videos.has("bluescreen"):
		# 1. Hide the main game layout elements or just let the layer cover them
		full_screen_video.stream = load(videos["bluescreen"])
		bricklayer.visible = true
		# 2. Prevent keyboard/shortcut inputs by pausing the rest of the scene tree
		# (The fullscreen video can keep processing if its process mode is set to Always)
		get_tree().paused = true
		full_screen_video.process_mode = Node.PROCESS_MODE_ALWAYS 
		
		# 3. Play the video
		full_screen_video.show()
		full_screen_video.play()
		
		# 4. Wait for it to finish crashing
		await full_screen_video.finished
		
		# 5. Unpause the game and hide the layer when done
		get_tree().paused = false
		full_screen_video.hide()
