extends Area2D

var speed:float = 200.0
var direction:Vector2 = Vector2.RIGHT
@onready var ani = $Animation

var aniTimer:float = 0.2

func _ready():
	ani.play("spawn")

func _physics_process(delta):
	if(aniTimer > 0.0):
		aniTimer -= delta
	else:
		position += direction * speed * delta
