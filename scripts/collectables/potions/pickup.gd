extends Area2D

signal collected(potion: PotionPickup)

@onready var player: Player
@export var potion: PotionPickup

func _ready() -> void:
	$Sprite2D.texture = potion.texture
	
	player = get_tree ().current_scene.get_node("Player")
	body_entered.connect(_on_body_entered)

func _on_body_entered ( body ):
	if body is Player :
		print_debug("Entered body")
		body.apply_potion(potion)
		collected.emit(potion)
		queue_free()
