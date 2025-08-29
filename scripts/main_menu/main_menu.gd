extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story/story.tscn")


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/controls.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
