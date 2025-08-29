extends Control

class_name Stats

@export var player: Player
@export var damage_label: Label
@export var speed_label: Label
@export var attack_speed_label: Label

func _ready() -> void:
	updateStats()

func _process(float) -> void:
	updateStats()

func updateStats() -> void:
	damage_label.text = "Damage: %.1f" % [player.damage]
	speed_label.text = "Speed: %.1f" % [player.moveSpeed]
	attack_speed_label.text = "Attack speed: " + str(player.attackSpeed)
