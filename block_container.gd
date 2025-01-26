extends Node2D
const blocks_group : String = "Blocks"
const Block := preload("res://block.tscn")
@onready var play_area : Rect2 = Rect2i(%VisibleStart.global_position, %VisibleEnd.global_position - %VisibleStart.global_position)

#	if State.upper_line == 111 and State.height > 0:
#		pL.data = Buffers.vBuff2
#		pL.address =  128 * 108 + 4
#		while pL.address < ((128 * 109 -4) * 4):
#			pL.set_inc(0)
#		pL.inc(2)
#		while pL.address < (128 * 110 - 4):
#			pL.set_inc(0xd3d3d3d3)
#		pL.inc(2)
#		while pL.address < ((128 * 111 -4) * 4):
#			pL.set_inc(0)
#	box.x = (20 - (State.height + 40) / 64)
#	if box.x < 4:
#		box.x = 4
#	box.y = (20 - (State.height + 40) / 64)
#	if box.y < 4:
#		box.y = 4
#	pC.data = Buffers.vBuffer
#	pC.address = ((upperLine - 20 - (randi() & 7)) & 127) * 128
#	for j1 in range(1):
#		var x : int = 4 + (randi() % box.x)
#		var y : int = 4 + (randi() % box.y)
#		pC.address = (((upperLine - 20 - (randi() & 7)) & 127) * 128)
#		var x1 = 4 + (randi() % (120 -x))
#		var x2 = x
#		var i = y
#		while i > 0:
#			if pC.address < 0:
#				pC.inc(128 * 128)
#			pC.inc(x1)
#			var w = x2
#			while w > 0:
#				pC.set_inc(0)
#				w -= 1
#			pC.dec(x1 + x2 + 128)
#			i -= 1
#	sweep(0x13,0xd2)

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
			var part : Particle = p
			part.rectangle.position = part.global_position
			if b.hit_pixel(part.rectangle):
				part.hit()
