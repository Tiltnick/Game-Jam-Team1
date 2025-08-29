extends Area2D

var speed:float = 200.0
var direction:Vector2 = Vector2.RIGHT
@onready var ani = $Animation
@onready var sprite = $Sprite
@export var damage:float = 1.0

var aniTimer:float = 0.22

func _ready():
	sprite.play("hidden")
	ani.play("spawn")

func _physics_process(delta):
	if(aniTimer > 0.0):
		aniTimer -= delta
	else:
		position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.takeDamage(damage)
		$CollisionShape2D.set_deferred("disabled", true)
		speed = 0.0
		sprite.play("hidden")
		ani.play("hit")

func _on_animation_animation_finished():
	if ani.animation == "spawn":
		sprite.play("static")
	if ani.animation == "hit":
		queue_free()
