extends Node
enum DataTypeSize { UByte = 1, UShort = 2, UInt = 4, ULong = 8}
var _storage : PackedByteArray
var _alloc_address : int = 0
var pooled_ubytes : Array[Sized]
var pooled_ushorts : Array[Sized]
var pooled_uints : Array[Sized]
var pooled_ulongs : Array[Sized]

func _init() -> void:
	_storage.resize(128)

func get_sized(dt_size : DataTypeSize) -> Sized:
	var s : Sized
	match dt_size:
		DataTypeSize.UByte:
			s = _get_first_available(pooled_ubytes)
		DataTypeSize.UShort:
			s= _get_first_available(pooled_ushorts)
		DataTypeSize.UInt:
			s= _get_first_available(pooled_uints)
		DataTypeSize.ULong:
			s= _get_first_available(pooled_ulongs)
	if s != null:
		return s

	if _alloc_address + dt_size > _storage.size():
		_storage.resize(2*_storage.size())

	s = Sized.new(dt_size,_alloc_address)
	_alloc_address += dt_size
	return s

func _get_first_available(arr : Array) -> Sized:
	if arr.size() > 0:
		var output : Sized = arr[0]
		arr.erase(output)
		return output
	return null

func _set_value(address : int, dt_size : DataTypeSize, value: int) -> void:
	match dt_size:
		DataTypeSize.UByte:
			_storage.encode_u8(address, value)
		DataTypeSize.UShort:
			_storage.encode_u16(address, value)
		DataTypeSize.UInt:
			_storage.encode_u32(address, value)
		DataTypeSize.ULong:
			_storage.encode_u64(address,value)

func _get_value(address : int, dt_size : DataTypeSize) -> int:
	match dt_size:
		DataTypeSize.UByte:
			return _storage.decode_u8(address)
		DataTypeSize.UShort:
			return _storage.decode_u16(address)
		DataTypeSize.UInt:
			return _storage.decode_u32(address)
		DataTypeSize.ULong:
			return _storage.decode_u64(address)
	return 0

func _return_to_pool(sized_var : Sized) -> void:
	sized_var.value = 0
	match sized_var._size:
		DataTypeSize.UByte:
			pooled_ubytes.append(sized_var)
		DataTypeSize.UShort:
			pooled_ushorts.append(sized_var)
		DataTypeSize.UInt:
			pooled_uints.append(sized_var)
		DataTypeSize.ULong:
			pooled_ulongs.append(sized_var)

class Sized:
	func _init(size : DataTypeSize, address : int) -> void:
		_size = size
		_address = address

	func assign(val : int) -> void:
		SizedTypes._set_value(_address, _size, val)

	var value : int:
		get:
			return SizedTypes._get_value(_address, _size)

	func addi(val : int) -> void:
		value = value + val

	func add(sized : Sized) -> void:
		value = value + sized.value

	func subtract(sized : Sized) -> void:
		value = value - sized.value

	func subtracti(val : int) -> void:
		value = value - val

	var _address : int = 0
	var _size : int = 0

	func return_to_pool() -> void:
		SizedTypes._return_to_pool(self)
