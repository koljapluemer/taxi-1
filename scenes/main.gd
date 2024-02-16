extends Node2D


var car_scene = preload("res://scenes/car.tscn")
var passenger_scene = preload("res://scenes/passenger.tscn")
var cars: Array = []
var passengers: Array = []

var speed: float
const SCORE_MODIFIER : float = 0.1
const SPEED_MODIFIER : float = 0.002
const START_SPEED : float = 1000.0
const MAX_SPEED : float = 25.0
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
	speed = START_SPEED
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
	# chance 1/100 to spawn a car every frame
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(0, 100) == 0:
		var car = car_scene.instantiate()
		car.position.x = screen_size.x + 100 + score 
		car.position.y = randf_range(0, screen_size.y)
		add_child(car)
		cars.append(car)

func spawn_passengers():
	# chance 1/100 to spawn a passenger every frame
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(0, 50) == 0:
		var passenger = passenger_scene.instantiate()
		passenger.position.x = screen_size.x + 100 + score 
		# spawn at bottom of screen
		passenger.position.y = randf_range(screen_size.y - 130, screen_size.y - 100)
		add_child(passenger)
		passengers.append(passenger)