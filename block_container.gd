extends Node2D
const Block := preload("res://block.tscn")
@onready var play_area : Rect2 = Rect2i(%VisibleStart.global_position, %VisibleEnd.global_position - %VisibleStart.global_position)

func spawn_blocks() -> void:
	var b := Block.instantiate()
	b.set_dimensions(Vector2i(50,50))
	b.global_position.x = 500
	b.global_position.y = %SpawnPoint.global_position.y - global_position.y
	add_child(b)

func in_play_area(pos : Vector2i) -> bool:
	return play_area.has_point(pos)
