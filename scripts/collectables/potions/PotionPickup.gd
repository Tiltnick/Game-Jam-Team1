extends Area2D

class_name PotionPickup

signal collected(amount: float)

@export var amount: float = 1.0

@export_enum("damage", "speed", "max_health", "health", "max_energy", "energy", "attack_speed")
var stat: String = "damage"

@onready var player: Player

var _consumed := false  # prevents double-triggering

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if player:
		match stat:
			"damage":
				if player.has_method("apply_damage_bonus"):
					collected.connect(Callable(player, "apply_damage_bonus"))
			"speed":
				if player.has_method("apply_speed_bonus"):
					collected.connect(Callable(player, "apply_speed_bonus"))
			"health":
				if player.has_method("heal"):
					collected.connect(Callable(player, "heal"))
			"max_health":
				if player.has_method("increase_max_health"):
					collected.connect(Callable(player, "increase_max_health"))
			"energy":
				if player.has_method("restore_energy"):
					collected.connect(Callable(player, "restore_energy"))
			"max_energy":
				if player.has_method("increase_max_energy"):
					collected.connect(Callable(player, "increase_max_energy"))
			"attack_speed":
				if player.has_method("apply_attack_speed_bonus"):
					collected.connect(Callable(player, "apply_attack_speed_bonus"))

func _on_body_entered(body: Node) -> void:
	if _consumed:
		return
	if body != player and not body.is_in_group("player"):
		return
	
