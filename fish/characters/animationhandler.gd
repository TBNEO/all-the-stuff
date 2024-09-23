extends Node2D

@onready var animtree = $AnimationTree
var statemach

@export var walking: bool = false
@export var grabbing: bool = false
@export var direction: Vector2

func _ready():
	statemach = animtree.get("parameters/playback")

func _process(delta):
	anim_update()

func anim_update():
	var state: String
	if grabbing and walking:
		state = "walkgrab"
	elif walking: state = "walk"
	elif grabbing: state = "grab"
	else: state = "idle"
	animtree.set("parameters/grab/blend_position", direction)
	animtree.set("parameters/walk/blend_position", direction)
	animtree.set("parameters/walkgrab/blend_position", direction)
	animtree.set("parameters/idle/blend_position", direction)
	
	if statemach.get_current_node() == state:
		return
	
	statemach.travel(state)
	
