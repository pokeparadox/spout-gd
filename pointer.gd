extends Node2D

class_name Pointer

enum DataTypeSize { UByte = 1, UShort = 2, UInt = 4, ULong = 8}

var data : PackedByteArray
var data_type_size : DataTypeSize = DataTypeSize.UByte
var address : int = 0

func _init(byte_array : PackedByteArray, start_address : int = 0, size : DataTypeSize = DataTypeSize.UByte) -> void:
	self.data = byte_array
	self.address = start_address
	self.data_type_size = size

func set_value(val : int) -> void:
	match data_type_size:
		DataTypeSize.UByte:
			return set_ubyte(val)
		DataTypeSize.UShort:
			return set_ushort(val)
		DataTypeSize.UInt:
			return set_uint(val)
		DataTypeSize.ULong:
			return set_ulong(val)

func value() -> int:
	match data_type_size:
		DataTypeSize.UByte:
			return value_ubyte()
		DataTypeSize.UShort:
			return value_ushort()
		DataTypeSize.UInt:
			return value_uint()
		DataTypeSize.ULong:
			return value_ulong()
	return 0

func set_ubyte(val : int) -> void:
	return data.encode_u8(address, val)

func set_ushort(val : int) -> void:
	return data.encode_u16(address, val)

func set_uint(val : int) -> void:
	return data.encode_u32(address, val)

func set_ulong(val : int) -> void:
	return data.encode_u64(address, val)

func value_ubyte() -> int:
	return data.decode_u8(address)

func value_ushort() -> int:
	return data.decode_u16(address)

func value_uint() -> int:
	return data.decode_u32(address)

func value_ulong() -> int:
	return data.decode_u64(address)

func get_inc() -> int:
	var out: int = value()
	inc()
	return out

func get_dec() -> int:
	var out: int = value()
	dec()
	return out

func set_inc(value :int) -> void:
	set_value(value)
	inc()

func set_dec(value : int) -> void:
	set_value(value)
	dec()

func inc(increment : int = 1) -> void:
	address += (increment * data_type_size)

func dec(decrement : int = 1) -> void:
	inc(-decrement)
