# res://scripts/enemies/boss.gd
extends CharacterBody2D

@export var max_health: int = 250
signal died
@onready var hp_bar: Node = get_node_or_null("BossHPBar")
var health: int

func _ready() -> void:
	health = max_health
	velocity = Vector2.ZERO
	z_as_relative = false
	z_index = 150
	_update_bar()
	# optional: add_to_group("boss")

func _physics_process(_d: float) -> void:
	velocity = Vector2.ZERO

func takeDamage(amount: int) -> void:
	if amount <= 0 or health <= 0: return
	health = max(0, health - amount)
	# kurzes Trefferfeedback
	modulate = Color(1, 0.7, 0.7)
	await get_tree().create_timer(0.06).timeout
	modulate = Color(1, 1, 1)
	_update_bar()
	if health == 0:
		emit_signal("died")
		var game_over_ui = get_tree().current_scene.get_node("Win")
		print(game_over_ui)
		game_over_ui.game_over()
		queue_free()

func _update_bar() -> void:
	if hp_bar and hp_bar.has_method("set_value"):
		hp_bar.set_value(health, max_health)
