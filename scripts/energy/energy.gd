extends CanvasLayer

var hearts : Array[ EnergyHeart ] = []


func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is EnergyHeart:
			print("new heart added")
			hearts.append( child )
			child.visible = false
	pass

func update_energy(_hp: int, _max_hp: int) -> void:
	update_max_energy( _max_hp )
	for i in _max_hp:
		update_energyheart( i, _hp)
		pass
	pass
	
func update_energyheart( _index : int, _hp : int) -> void:
	var _value : int = clampi( _hp - _index * 2, 0, 2)
	hearts[ _index ].value = _value
	pass
	
	
	
func update_max_energy( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass
