extends Node2D


var car_scene = preload("res://scenes/car.tscn")
var passenger_scene = preload("res://scenes/passenger.tscn")
var cars: Array = []
var passengers: Array = []

var speed: float
var screen_size: Vector2 

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screen_size = get_window().size
	new_game()

func new_game():
	# reset Taxi, Camera, Ground and speed
	$Camera.position.x = 0
	$Ground.position.x = 0
	$Taxi.reset_position()
	speed = Globals.START_SPEED
	score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_cars()
	spawn_passengers()

	$Taxi.position.x += speed * delta
	$Camera.position.x += speed * delta

	# update ground pos (check if we moved the camera more than 1.5x the screen width)
	if $Camera.position.x - $Ground.position.x > screen_size.x * 1.2:
		$Ground.position.x += screen_size.x
	
	score += delta * speed

func _on_button_button_up():
	pass

func spawn_cars():
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(0, 30) == 0:
		var car = car_scene.instantiate()
		car.position.x = screen_size.x + 100 + score 
		var random_lane = rng.randi_range(Globals.MIN_LANE + 1, Globals.MAX_LANE - 1)
		car.position.y = Globals.middle_of_screen + Globals.LANE_HEIGHT * random_lane
		add_child(car)
		cars.append(car)

func spawn_passengers():
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(0, 50) == 0:
		var passenger = passenger_scene.instantiate()
		passenger.position.x = screen_size.x + 100 + score 
		# spawn at bottom of screen
		passenger.position.y = randf_range(screen_size.y - 130, screen_size.y - 100)
		add_child(passenger)
		passengers.append(passenger)
