extends Area2D

@export var potion: PotionPickup

func _ready() -> void:
	$Sprite2D.texture = potion.texture
