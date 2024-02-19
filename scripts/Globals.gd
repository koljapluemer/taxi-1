extends Node

const MAX_LANE = 2
const MIN_LANE = -3
const LANE_HEIGHT = 100

const SPEED_MODIFIER : float = 0.002
const BASE_SPEED : float = 400.0
const MAX_SPEED : float = 1500.0

const CAR_SPEED : float = 300.0

var passenger_in_taxi : bool = false

const DESTINATION_TYPES = [
	{
		"english": "Mosque",
		"egyptian": "مسجد",
		"transliteration": "masgid"
	},
	{
		"english": "School",
		"egyptian": "مدرسة",
		"transliteration": "madrasa"
	},
	{
		"english": "University",
		"egyptian": "جامعة",
		"transliteration": "gam3a"
	},
	{
		"english": "Metro",
		"egyptian": "مترو",
		"transliteration": "metro"
	},
	{
		"english": "Library",
		"egyptian": "مكتبة",
		"transliteration": "maktaba"
	},
	{
		"english": "Train Station",
		"egyptian": "محطة القطر",
		"transliteration": "màHàTtet el àTr"
	},
	{
		"english": "Bus Station",
		"egyptian": "محطة الاوتوبيس",
		"transliteration": "màHàTtet el otobees"
	}
]
var destination_type : String

var middle_of_street
var speed: float

var progress
var driver_rating

# Called when the node enters the scene tree for the first time.
func _ready():
	middle_of_street = get_viewport().size.y / 2 + 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
