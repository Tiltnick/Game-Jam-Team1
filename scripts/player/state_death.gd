class_name State_Death extends State


func enter() -> void:
	player.sprite.play("Hit")
	player.velocity = Vector2.ZERO
	player.die()
	pass

func exit() -> void:
	pass

func process(_delta:float) -> State:
	return null

func physics(_delta:float) -> State:
	return null

func handleInput(_event:InputEvent) -> State:
	return null
