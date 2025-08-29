extends Node2D

@onready var rock = $Rock
@onready var chest = $Chest
@onready var rock_ghost = $RockGhost
@onready var chest_ghost = $ChestGhost

var is_ghost: bool = false

func set_ghost_mode(active: bool) -> void:
	is_ghost = active

	# normale Welt 
	rock.visible = !is_ghost
	chest.visible = !is_ghost

	# geisterwelt 
	rock_ghost.visible = is_ghost
	chest_ghost.visible = is_ghost
