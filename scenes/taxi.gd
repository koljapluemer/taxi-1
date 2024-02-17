extends CharacterBody2D

var lane = 0


const START_POS_X = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_position()

func reset_position():
	lane = 0
	position.y = Globals.middle_of_screen + Globals.LANE_HEIGHT * lane
	position.x = START_POS_X

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move up and down a lane_height on arrow key press (within limits)
	if Input.is_action_just_pressed("ui_up"):
		lane = max(lane - 1, Globals.MIN_LANE)
		position.y = Globals.middle_of_screen + Globals.LANE_HEIGHT * lane
	elif Input.is_action_just_pressed("ui_down"):
		lane = min(lane + 1, Globals.MAX_LANE)
		position.y = Globals.middle_of_screen + Globals.LANE_HEIGHT * lane
