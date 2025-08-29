# res://scripts/enemies/boss.gd
extends CharacterBody2D

@export var max_health: int = 25
signal died

var health: int

func _ready() -> void:
	health = max_health
	velocity = Vector2.ZERO
	z_as_relative = false
	z_index = 150
	# optional: add_to_group("boss")

func _physics_process(_d: float) -> void:
	velocity = Vector2.ZERO

func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0: return
	health = max(0, health - amount)
	# kurzes Trefferfeedback
	modulate = Color(1, 0.7, 0.7)
	await get_tree().create_timer(0.06).timeout
	modulate = Color(1, 1, 1)
	if health == 0:
		emit_signal("died")
		queue_free()
