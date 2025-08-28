extends Area2D

var speed:float = 200.0
var direction:Vector2 = Vector2.RIGHT
@onready var ani = $Animation
@export var damage:float = 1.0

var aniTimer:float = 0.2

func _ready():
	ani.play("spawn")

func _physics_process(delta):
	if(aniTimer > 0.0):
		aniTimer -= delta
	else:
		position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.takeDamage(damage)
		queue_free()
