extends Node2D
var width := 70
var height := 10
var y_offset := -230
var _cur := 0
var _max := 1
func set_value(cur: int, maxv: int) -> void:
	_cur = cur; _max = max(1, maxv); queue_redraw()
func _draw() -> void:
	var pct := float(_cur) / float(_max)
	draw_rect(Rect2(Vector2(-width/2, y_offset), Vector2(width, height)), Color(0.6,0,0,0.6))
	draw_rect(Rect2(Vector2(-width/2+1, y_offset+1), Vector2((width-2)*pct, height-2)), Color(1,0,0))
