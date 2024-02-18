extends Node

const MAX_LANE = 2
const MIN_LANE = -3
const LANE_HEIGHT = 100

const SCORE_MODIFIER : float = 0.1
const SPEED_MODIFIER : float = 0.002
const BASE_SPEED : float = 800.0
const MAX_SPEED : float = 1500.0

const CAR_SPEED : float = 200.0

var middle_of_street
var speed: float


# Called when the node enters the scene tree for the first time.
func _ready():
	middle_of_street = get_viewport().size.y / 2 + 50
	speed = BASE_SPEED



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass