extends Sprite2D

var lane = 0

const MAX_LANE = 2
const MIN_LANE = -3
const LANE_HEIGHT = 100

var middle_of_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	middle_of_screen = get_viewport().size.y / 2
	position.y = middle_of_screen + LANE_HEIGHT * lane


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move up and down a lane_height on arrow key press (within limits)
	if Input.is_action_just_pressed("ui_up"):
		lane = max(lane - 1, MIN_LANE)
		position.y = middle_of_screen + LANE_HEIGHT * lane
	elif Input.is_action_just_pressed("ui_down"):
		lane = min(lane + 1, MAX_LANE)
		position.y = middle_of_screen + LANE_HEIGHT * lane
