extends Node

# Lookup table for sin/cos and for their direction vectors using Brads
# We only have to store a subset of values due to mirroring and the reduction from 360 degres to 256 Brads.
# Ported from original C++ in Penjin by PokeParadox

var sin_cos_lookup = {}
var Brad = load("res://addons/binaryradian/Brad.gd")
var Ubyte = load("res://addons/binaryradian/ubyte.gd")

var my_brad : Brad
var my_ubyte : Ubyte

func _init():
	my_brad = Brad.new()
	for i in range(0, 128):
		var brad = Brad.new()
		brad.brad(i)
		sin_cos_lookup[i] = sin(deg_to_rad(brad.get_angle_deg()))
	my_ubyte = Ubyte.new()

func deg_to_brad(a : float) -> int:
	my_brad.set_angle_deg(a)
	return my_brad.get_angle()


func sin_ub(a : Ubyte) -> float:
	var ang : int = a.value()
	if ang > 127:
		ang -= 128
		return -sin_cos_lookup[ang]
	return sin_cos_lookup[ang]

func sin_i(a : int) -> float:
	my_ubyte.assign(a)
	return sin_ub(my_ubyte)


func cos_i(a : int) -> float:
	return sin_i(a + 64)

func sin_b(brad : Brad) -> float:
	return sin_i(brad.get_angle())

func cos_b(brad : Brad) -> float:
	return cos_i(brad.get_angle())

var brad_to_vector_lookup = {}

func brad_to_vector_2d(brad_angle: Brad) -> Vector2:
	var a : int = brad_angle.get_angle()
	if not brad_to_vector_lookup.has(a):
		brad_to_vector_lookup[a] = Vector2(sin_i(a), cos_i(a))
	return brad_to_vector_lookup[a]

func brad_val_to_vector_2d(brad_val : int) -> Vector2:
	my_brad.set_angle(brad_val)
	return brad_to_vector_2d(my_brad)
