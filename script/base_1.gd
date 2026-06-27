extends Node
@onready var skip: Button = $Control/skip
@onready var spin: Button = $Control/spin
@onready var end: Button = $Control/end
@onready var enemy: VideoStreamPlayer = $enemy
@onready var chatbox: VBoxContainer = $Control2/VBoxContainer

var skip_used = false
var end_pressed_count = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#DialogueManager.show_example_dialogue_balloon(DialogueResource,dialogue)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
