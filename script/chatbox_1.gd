extends VBoxContainer

signal dialogue_finished

@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var button_2: Button = $Button2



const Dialogue_data = {
	"start":{
		"text":"Hey whats up  wanna listen to me play some ukelele",
		"choices":[
			{"text:"Yea I would love to", "next_id":"Rohan_happy"},
			{"text":"Hell no you probably suck", "next_id":"Rohan_sad"}
		]
	},
	"Rohan_happy":{
		"text":"Ahh Thank you for staying and listening and some advise there\n beware of the next person",
		"next_id":"Shreshta_1",
	},
	"Rohan_sad":{
		
	}
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
