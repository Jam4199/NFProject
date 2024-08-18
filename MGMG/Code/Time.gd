extends Node
class_name TimeProgress

var grid_data : Array[BlockData]

var time_speed : TIMESPEED = TIMESPEED.PAUSE
enum TIMESPEED {PAUSE, SLOW, NORM, FAST}

var tic_counter : int = 0
var hour_counter : int = 0
var day_counter : int = 0
var minute : int = 0
var hour : int = 0
var day : int = 0

var current_week : int = 0

signal time_tic

func _process(delta: float) -> void:
	
	match time_speed:
		TIMESPEED.SLOW:
			tic_counter += 1
		TIMESPEED.NORM:
			tic_counter += 2
		TIMESPEED.FAST:
			tic_counter += 4
	
	if tic_counter >= 8:
		tic_counter -= 8
		minute += 1
		emit_signal("time_tic")
		hour_counter += 1
	
	if hour_counter >= 60:
		hour += 1
		hour_counter -= 60
		day_counter += 1
	
	if day_counter >= 24:
		day_counter -= 24 
		day += 1
	

func reset_week():
	time_speed = TIMESPEED.PAUSE
	minute = 0
	tic_counter = 0
	minute = 0
	hour_counter = 0
	hour = 0
	day_counter = 0
	day = 0
	
	

