extends Node2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_start_pressed() -> void:
	audio.play()
	await audio.finished
	get_tree().change_scene_to_file("res://scenes/base.tscn")
func _on_quit_pressed() -> void:
	get_tree().quit()
