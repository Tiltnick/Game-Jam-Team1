class_name State_Walk extends State

@export var moveSpeed:float = 150.0
@onready var idle:State = $"../Idle"



func enter() -> void:
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
	
	return null
