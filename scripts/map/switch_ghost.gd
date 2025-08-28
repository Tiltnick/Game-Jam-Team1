extends Node2D

@onready var rock = $Rock
@onready var chest = $Chest
@onready var rock_ghost = $RockGhost
@onready var chest_ghost = $ChestGhost

var is_ghost: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_form"):
		is_ghost = !is_ghost

		# normale Welt 
		rock.visible = !is_ghost
		chest.visible = !is_ghost

		# geisterwelt 
		rock_ghost.visible = is_ghost
		chest_ghost.visible = is_ghost
