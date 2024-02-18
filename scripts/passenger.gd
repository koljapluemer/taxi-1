extends Sprite2D

var is_moving = false
var destination: Vector2

const PASSENGER_SPEED = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		position = position.move_toward(destination, PASSENGER_SPEED * delta)
		if position == destination:
			is_moving = false
			Globals.passenger_in_taxi = true
			hide()

func move_to_taxi(taxi):
	destination = taxi.position
	is_moving = true