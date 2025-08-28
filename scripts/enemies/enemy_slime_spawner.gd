extends Node2D

#@onready var main = get_tree().root.get_node("map")

var slimeScene := preload("res://scenes/enemies/slimePath.tscn")
var spawnPoints := []

func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawnPoints.append(i)


func _on_timer_timeout() -> void:
	var spawn = spawnPoints[randi() % spawnPoints.size()]
	var slime = slimeScene.instantiate()
	slime.position = spawn.position
	get_parent().add_child(slime)
