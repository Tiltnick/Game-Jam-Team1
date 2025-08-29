extends Node2D

var skip_requested = false

func _ready():
	$AnimationPlayer.play("Fade in")
	
	
	var timer = get_tree().create_timer(25)
	await _wait_or_skip(timer)
	
	
	$AnimationPlayer.play("Fade out")
	await $AnimationPlayer.animation_finished
	
	
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		skip_requested = true


func _wait_or_skip(timer):
	while not skip_requested:
		if timer.time_left <= 0:
			break
		await get_tree().process_frame
