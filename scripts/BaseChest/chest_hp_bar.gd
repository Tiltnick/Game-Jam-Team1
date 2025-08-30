extends Node2D
@export var width := 28
@export var height := 4
@export var y_offset := -30
var _cur := 0
var _max := 1
func set_value(cur: int, maxv: int) -> void:
	_cur = cur; _max = max(1, maxv); queue_redraw()
func _draw() -> void:
	var pct := float(_cur) / float(_max)
	draw_rect(Rect2(Vector2(-width/2, y_offset), Vector2(width, height)), Color(0,0,0,0.6))
	draw_rect(Rect2(Vector2(-width/2+1, y_offset+1), Vector2((width-2)*pct, height-2)), Color(0,1,0))
