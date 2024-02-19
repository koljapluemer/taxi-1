extends Node

const MAX_LANE = 2
const MIN_LANE = -3
const LANE_HEIGHT = 100

const SCORE_MODIFIER : float = 0.1
const SPEED_MODIFIER : float = 0.002
const BASE_SPEED : float = 400.0
const MAX_SPEED : float = 1500.0

const CAR_SPEED : float = 300.0

var passenger_in_taxi : bool = false

const DESTINATION_TYPES: Array = ["Mosque", "School", "University", "Metro", "Library", "Train Station", "Bus Station"]
var destination_type : String

var middle_of_street
var speed: float

var progress
var score
var driver_rating

# Called when the node enters the scene tree for the first time.
func _ready():
	middle_of_street = get_viewport().size.y / 2 + 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
