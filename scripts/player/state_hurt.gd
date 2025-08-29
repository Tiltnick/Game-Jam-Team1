class_name State_Hurt extends State

@onready var idle:State = $"../Idle"
var hurtCooldown:float = 0.2
var hurtTimer:float = 0.0

func enter() -> void:
	player.sprite.play("Hit")
	player.velocity = Vector2.ZERO
	hurtTimer=hurtCooldown
	pass

func exit() -> void:
	pass

func process(_delta:float) -> State:
	if hurtTimer >= 0.0:
		hurtTimer-= _delta
	else:
		return idle
	return null

func physics(_delta:float) -> State:
	return null

func handleInput(_event:InputEvent) -> State:
	return null
