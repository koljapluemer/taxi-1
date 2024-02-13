extends Sprite2D

var lane = 2

const MAX_LANE = 4
const MIN_LANE = 1
const LANE_HEIGHT = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move up and down a lane_height on arrow key press (within limits)
	if Input.is_action_just_pressed("ui_up"):
		lane = max(lane - 1, MIN_LANE)
		position.y = LANE_HEIGHT * (lane - 1)
	elif Input.is_action_just_pressed("ui_down"):
		lane = min(lane + 1, MAX_LANE)
		position.y = LANE_HEIGHT * (lane - 1)
