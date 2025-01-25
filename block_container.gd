extends Node2D
const blocks_group : String = "Blocks"
const Block := preload("res://block.tscn")
@onready var play_area : Rect2 = Rect2i(%VisibleStart.global_position, %VisibleEnd.global_position - %VisibleStart.global_position)

func spawn_blocks() -> void:
	## Tag all obstacle blocks to easier recall
	var b := Block.instantiate()
	b.set_dimensions(Vector2i(50,50))
	b.global_position.x = 500
	b.global_position.y = %SpawnPoint.global_position.y - global_position.y
	b.add_to_group(blocks_group)
	add_child(b)

func in_play_area(pos : Vector2i) -> bool:
	return play_area.has_point(pos)

func _process(delta: float) -> void:
	var blocks = get_tree().get_nodes_in_group(blocks_group)
	for b in blocks:
		for p in get_tree().get_nodes_in_group("Particles"):
			var p_pos : Vector2 = p.global_position
			#if b.rectangle.has_point(p_pos) and is_instance_valid(p):
			var part : Particle = p
			part.rectangle.position = part.global_position
			if b.hit_pixel(part.rectangle):
				part.hit()
