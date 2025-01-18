extends Node

const zoom : int = 8
const gravity : float = 1.8

enum States {
	Demo = 0, 	# 0000
	Init = 1, 	# 0001
	Game = 2, 	# 0010
	Paused = 3,# 0011
	Close }   # 0100

func is_active() -> bool:
	return _active.has(gamePhase)

var _active : Array[States] = [States.Demo, States.Game, States.Paused]

var score : int = 0
var height : int = 0
var dispScore : int = 0
var hiScore := [0, 0]
var score_path : String
var gamePhase : States = States.Demo
var gameover : bool
var upper_line : int = 0
var time_remaining : int = 60

func increase_height() -> bool:
	var bonus : bool = false
	upper_line = (upper_line -1) % 128
	height += 1
	if height > 0:
		score += 1
		if (height % 128) == 0:
			score += time_remaining * 10
			bonus = true
			#timeSpout += 60 * FrameRate
			#if timeSpout > 99 * FrameRate:
			#	timeSpout = 99 * FrameRate
			#Fonts.pceFontSetType(2)
			#Fonts.pceFontSetPos(4 * 5, 82)
			#Fonts.pceFontPrintF("%2d", [ (timeSpout + FrameRate - 1) / FrameRate])
			#Fonts.pceFontSetType(0)
		Fonts.pceFontSetType(2)
		Fonts.pceFontSetPos(4 * 15, 82)
		Fonts.pceFontPrintF("%4d", [ State.height % 10000])
		Fonts.pceFontSetType(0)
	return bonus

func reset() -> void:
	score = 0
	dispScore = 0
	height = -58
