extends Area2D

signal collected

@onready var player: Player
@export var ally: AllyPickup

func _ready ():
	print_debug("ally is null? ", ally == null)
	$Sprite2D.texture = ally.texture
	
	player = get_tree ().current_scene.get_node("Player")
	body_entered.connect(_on_body_entered)

func _on_body_entered ( body ):
	if body is Player :
		body.increment_ally()
		emit_signal ("collected")
		queue_free () 
