# res://scripts/enemies/boss.gd
extends CharacterBody2D

@export var max_health: int = 25
signal died

var health: int

func _ready() -> void:
	health = max_health
	velocity = Vector2.ZERO

func _physics_process(_d: float) -> void:
	# Boss bleibt exakt, kein Move
	velocity = Vector2.ZERO

func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0: return
	health = max(0, health - amount)
	# optional: blink/FX hier
	if health == 0:
		emit_signal("died")
		queue_free()
