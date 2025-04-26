class_name WaveMapMaker
extends Node2D

@export var input_tile : TileMapPattern
@export var depth : int
@export var N : int
@export var periodic : bool
@export var symmetry : int = 0 # 1 - 8 add mirror and rotated versions
@export var ground : int = 0 #(this is mainly for vertical worlds, when not set to 0)

var seed : int # seed used to generate our model
var limit : int =  0 # if 0, will run until completion or a contridiction

func make_waves() -> void :
	return
