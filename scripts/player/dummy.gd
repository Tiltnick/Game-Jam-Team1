extends CharacterBody2D

@export var health = 10.0

func takeDamage(amount:float):
	health -= amount
	if health <= 0.0:
		death()

func death():
	queue_free()
