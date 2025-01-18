class_name Ubyte
extends Node

var _storage : PackedByteArray
const OFFSET : int = 0

func _init() -> void:
	_storage.resize(1)
	assign(0)

func assign(val : int) -> void:
	_storage.encode_u8(OFFSET, val)

func value() -> int:
	return _storage.decode_u8(OFFSET)

func add(other_val : int) -> void:
	assign(value() + other_val)

func subtract(other_val : int) -> void:
	assign(value() - other_val)
