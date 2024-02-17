extends Node

const MAX_LANE = 2
const MIN_LANE = -3
const LANE_HEIGHT = 120

const SCORE_MODIFIER : float = 0.1
const SPEED_MODIFIER : float = 0.002
const START_SPEED : float = 800.0
const MAX_SPEED : float = 1500.0

const CAR_SPEED : float = 200.0

var middle_of_screen


# Called when the node enters the scene tree for the first time.
func _ready():
	middle_of_screen = get_viewport().size.y / 2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
