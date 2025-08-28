class_name State_Idle extends State

@onready var walk:State = $"../Walk"


func enter() -> void:
	player.setIdleAnimation()
	pass

func exit() -> void:
	pass

func process(_delta:float) -> State:
	if player.direction:
		return walk
	player.velocity = Vector2.ZERO
	return null

func physics(_delta:float) -> State:
	return null

func handleInput(_event:InputEvent) -> State:
	return null
