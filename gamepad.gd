extends Node

var pad : int = 0
enum Pad
{
	Ri = 0x01,
	Lf = 0x02,
	Dn = 0x04,
	Up = 0x08,
	B = 0x10,
	A = 0x20,
	D = 0x40,
	C = 0x80
}
enum Trg
{
	Ri = 0x0100,
	Lf = 0x0200,
	Dn = 0x0400,
	Up = 0x0800,
	B = 0x1000,
	A = 0x2000,
	D = 0x4000,
	C = 0x8000,
	Start = 0x10000
}

func get_pad() -> int:
	var e := Input
	pad = 0
	var op : int = pad & 0x00ff
	if e.is_action_pressed("ui_left"):
		pad |= Pad.Lf
	if e.is_action_pressed("ui_right"):
		pad |= Pad.Ri
	if e.is_action_pressed("ui_up"):
		pad |= Pad.Up
	if e.is_action_pressed("ui_down"):
		pad |= Pad.Dn
	if e.is_action_pressed("ui_accept"):
		pad |= Pad.A
	if e.is_action_pressed("ui_cancel"):
		pad |= Pad.B
	pad |= (pad & (~op)) << 8
	return pad
