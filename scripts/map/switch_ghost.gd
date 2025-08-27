extends Node2D

@onready var rock = $Rock
@onready var chest = $Chest
@onready var rock_ghost = $RockGhost
@onready var chest_ghost = $ChestGhost

var is_ghost: bool = false
var q_pressed_last_frame: bool = false

func _process(_delta: float) -> void:
	var q_pressed = Input.is_key_pressed(KEY_Q)

	# nur einmal umschalten, wenn Q gerade gedrückt wurde
	if q_pressed and not q_pressed_last_frame:
		is_ghost = !is_ghost
		print("Switching form! is_ghost =", is_ghost)

		rock.visible = !is_ghost
		chest.visible = !is_ghost
		rock_ghost.visible = is_ghost
		chest_ghost.visible = is_ghost

	q_pressed_last_frame = q_pressed
