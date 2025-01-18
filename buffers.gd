extends Node

const LcdWidth : int = 128
const LcdHeight : int = 88

#func pceLcdSetBuffer(buff : PackedByteArray, offset: int = 0) -> PackedByteArray:
#	if buff != null and offset == 0:
#		vBuffer = buff
#	else:
#		vBuffer = buff.slice(offset, offset + 128*88)
#	Fonts.set_buffer(vBuffer)
#	return vBuffer

#func reset_buffers(gamePhase : State.States) -> void:
#	if State.is_active():
#		memset(display_buff, 0xd2, display_buff.size())
#		memsetOffset(display_buff, 0, 0, LcdWidth * 78)
#		memsetOffset(display_buff, LcdWidth * (LcdWidth - 32),0, LcdWidth * 32)
#	else:
#		memset(display_buff, 0, display_buff.size())
#
#	#memset(vBuff, 0, vBuff.size())

func memset(buff : PackedByteArray, val : int, size : int = -1) -> void:
	if size == -1:
		size = buff.size()
	memsetOffset(buff, 0, val, size)

func memsetOffset(buff : PackedByteArray, offset: int, val : int, size : int) -> void:
	if offset == 0 and buff.size() == size:
		buff.fill(val)
	else:
		for i in range(offset, min(size, buff.size())):
			buff[i] = val

func get_particle_key(p : Particle) -> Vector2i:
	return Vector2i(p.position/State.zoom + Vector2(0.5,0.5))

func set_particle(p : Particle) -> void:
	var key : Vector2i
	if p.last_float_pos != Vector2.INF:
		key = p.last_float_pos
		var new_key := get_particle_key(p)
		if new_key != key:
			particle_lookup.erase(key)
			p.last_buff_pos = new_key
			particle_lookup[new_key] = p
	else:
		key = get_particle_key(p)
	if particle_lookup.has(key):
		var existing : Particle = particle_lookup[key]
		if p != existing:
			if existing.colour_byte > 5:
				existing.hit()

func kill_particle(p : Particle) -> void:
	var key : Vector2i
	if p.last_float_pos != Vector2.INF:
		key = p.last_float_pos
	else:
		key = get_particle_key(p)
	if particle_lookup.has(key):
		particle_lookup.erase(key)

func set_pixel(pos: Vector2i, palletteVal : int) -> void:
	var index : int = (pos.y * LcdWidth) + pos.x
	if display_buff.size() > index and index >= 0 and display_buff[index] != palletteVal:
		display_buff[index] = palletteVal

func _init() -> void:
	display_buff.resize(LcdWidth * LcdHeight)
	memset(display_buff, 0)

#var vBuff : PackedByteArray
var display_buff : PackedByteArray
var particle_lookup = {}
