extends Node

@onready var time = $TIME
@onready var canvas_modulate = $CanvasModulate
@onready var label = $CanvasLayer/Label

var skygradient = preload("res://resources/skygradient/gradient.tres")

var day_time: int = 12
var hour_time: int = 3

var current_day: int = 0
var current_hour: int = 0
var current_minute: int = 0

var internal_time: int = 0

func _ready():
	#time.wait_time = hour_time
	time.start(1)

func _process(_delta):
	var day_value = float(internal_time)/float(day_time*hour_time)
	canvas_modulate.color = skygradient.sample(day_value)
	label.text = time_convert()

func time_convert() -> String:
	var day
	var hour 
	var minute
	
	day = str(current_day)
	hour = str(current_hour)
	minute = str(current_minute)
	
	return day + " : " + hour + " : " + minute


func _on_time_timeout():
	internal_time += 1
	current_minute += 1
	if current_minute == hour_time:
		current_minute = 0
		current_hour += 1
	if current_hour == day_time:
		current_hour = 0
		internal_time = 0
		day_time += 1
