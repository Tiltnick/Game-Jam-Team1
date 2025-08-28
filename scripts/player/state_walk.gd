class_name State_Walk extends State

@export var moveSpeed:float = 0
@onready var idle:State = $"../Idle"
@onready var dash:State = $"../Dash"
@onready var attack:State = $"../Attack"

func enter() -> void:
	moveSpeed = player.moveSpeed
	player.setMoveAnimation()
	pass

func exit() -> void:
	pass

func process(_delta:float) -> State:
	if(!player.direction):
		return idle
	player.setMoveAnimation()
	player.direction.normalized()
	player.velocity = player.direction * moveSpeed
	return null

func physics(_delta:float) -> State:
	return null

func handleInput(_event:InputEvent) -> State:
	if(_event.is_action_pressed("dash") && player.dashCooldownTimer <= 0.0):
		return dash
	
	if _event.is_action_pressed("interact"):
		return attack
	return null
