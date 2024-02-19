extends Sprite2D

var is_moving = false
var destination: Vector2

const PASSENGER_SPEED = 300

var money: int
var drive_rating = 4

signal passenger_got_in_taxi

# Called when the node enters the scene tree for the first time.
func _ready():
	# generate how much money the passenger is willing to pay
	# it is influenced by the driver rating of the taxi
	# for the minimum drive rating of 1, the passenger is willing to pay 20-50
	# for the maximum drive rating of 5, the passenger is willing to pay 150-300
	var minimum_money = 20 * Globals.driver_rating
	var maximum_money = 50 * Globals.driver_rating
	money = randf_range(minimum_money, maximum_money)
	# money should be always end with 5 or 0
	money = money - money % 5
	$PassengerText.text = '£' + str(money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		position = position.move_toward(destination, PASSENGER_SPEED * delta)
		if position == destination:
			is_moving = false
			Globals.passenger_in_taxi = true
			passenger_got_in_taxi.emit(self)
			hide()

func move_to_taxi(taxi):
	destination = taxi.position
	is_moving = true