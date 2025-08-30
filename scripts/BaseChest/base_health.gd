extends Area2D

@export var max_health: int = 40
@export var damage_per_hit: int = 1
var health: int

signal health_changed(current: int, max: int)
signal died

@onready var hp_bar: Node = get_node_or_null("ChestHPBar")

func _ready() -> void:
	# Kontakt-Event
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	health = max_health
	emit_signal("health_changed", health, max_health)
	_update_bar()
	print("[BASE] ready ->", health, "/", max_health)

func take_damage(amount: int) -> void:
	if health <= 0: return
	health = max(health - amount, 0)
	print("[BASE] -", amount, " => ", health, "/", max_health)
	emit_signal("health_changed", health, max_health)
	_update_bar()
	if health == 0:
		emit_signal("died")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		take_damage(damage_per_hit)
		# Slime wird destroyed bei hit
		if body.has_method("queue_free"):
			body.queue_free()

func _update_bar() -> void:
	if hp_bar and hp_bar.has_method("set_value"):
		hp_bar.set_value(health, max_health)
