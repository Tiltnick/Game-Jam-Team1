extends CharacterBody2D
@onready var player:Player = $"../Player"
@onready var area:Area2D = $Area2D
@export var health = 3.0

var attackCooldown:float = 1.0

var attackTimer:float = 0.0

func takeDamage(amount:float):
	health -= amount
	if health <= 0.0:
		death()

func death():
	queue_free()


func _process(delta):
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			attack()
	if attackTimer > 0.0:
		attackTimer -= delta

func attack():
	if attackTimer <= 0.0:
		player.take_damage(1)
		attackTimer = attackCooldown
