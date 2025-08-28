# ui_chest_hp.gd  (an CanvasLayer "UI")
extends CanvasLayer
@onready var label: Label = $ChestHPLabel

func _ready() -> void:
	var base = get_tree().get_first_node_in_group("base")
	if base:
		if not base.is_connected("health_changed", Callable(self, "_on_base_health_changed")):
			base.connect("health_changed", Callable(self, "_on_base_health_changed"))
		if not base.is_connected("died", Callable(self, "_on_base_died")):
			base.connect("died", Callable(self, "_on_base_died"))
		_on_base_health_changed(base.health, base.max_health)

func _on_base_health_changed(current: int, maxv: int) -> void:
	label.text = "CHEST HP: %d / %d" % [current, maxv]

func _on_base_died() -> void:
	label.text = "CHEST DESTROYED!"
