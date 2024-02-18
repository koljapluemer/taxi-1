extends Node2D


var car_scene = preload("res://scenes/car.tscn")
var passenger_scene = preload("res://scenes/passenger.tscn")
var cars: Array = []
var passengers: Array = []

var screen_size: Vector2 

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screen_size = get_window().size
	new_game()
	# Signal connections
	$Taxi.taxi_stopped_for_pickup.connect(initiate_pickup)

func new_game():
	$Interface.get_node("RestartButton").hide()
	# reset Taxi, Camera, Ground and speed
	$Camera.position.x = 0
	$Ground.position.x = 0
	$Taxi.reset_position()
	score = 0
	# delete all cars and passengers
	for car in cars:
		car.queue_free()
	for passenger in passengers:
		passenger.queue_free()
	cars = []
	passengers = []
	get_tree().paused = false

	Globals.speed = Globals.BASE_SPEED

	# set random buildings for the first tiles in the 0th row
	var origin_tile_source_id = $TileMap.get_cell_source_id(0, Vector2(0, 0))
	print(origin_tile_source_id)
	for i in range(10):
		spawn_random_tile(i, 0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_cars()
	spawn_passengers()

	$Camera.position.x += Globals.speed * delta
	# spawn tiles when we're about to see empty tiles right of our screen
	var index_of_tile_just_right_of_screen = $TileMap.local_to_map($Camera.position + Vector2(screen_size.x, 0)).x
	# if tile empty, spawn a random tile
	if $TileMap.get_cell_source_id(0, Vector2(index_of_tile_just_right_of_screen, 0)) == -1:
		spawn_random_tile(index_of_tile_just_right_of_screen, 0)

	# update ground pos (check if we moved the camera more than 1.5x the screen width)
	if $Camera.position.x - $Ground.position.x > screen_size.x * 1.2:
		$Ground.position.x += screen_size.x

	# delete passengers and cars out of screen
	for passenger in passengers:
		if passenger.position.x < $Camera.position.x - screen_size.x:
			passenger.queue_free()
			passengers.erase(passenger)
	for car in cars:
		if car.position.x < $Camera.position.x - screen_size.x:
			car.queue_free()
			cars.erase(car)
	
	score += delta * Globals.speed

func _on_button_button_up():
	pass

func spawn_cars():
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(0, 30) == 0:
		var car = car_scene.instantiate()
		car.position.x = screen_size.x + 100 + score 
		var random_lane = rng.randi_range(Globals.MIN_LANE + 1, Globals.MAX_LANE - 1)
		car.position.y = Globals.middle_of_street + Globals.LANE_HEIGHT * random_lane
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

func game_over():
	$Interface.get_node("RestartButton").show()
	get_tree().paused = true


func initiate_pickup():
	# find passenger closest to taxi
	var closest_passenger = null
	var closest_distance = 100000
	for passenger in passengers:
		var distance = passenger.position.x - $Taxi.position.x
		distance = abs(distance)
		if distance < closest_distance:
			closest_distance = distance
			closest_passenger = passenger
	if closest_passenger:
		closest_passenger.move_to_taxi($Taxi)
		passengers.erase(closest_passenger)


func spawn_random_tile(x, y):
		var random_atlas_x = randi() % 4
		var random_atlas_y = randi() % 4
		$TileMap.set_cell(0, Vector2(x, y), 0, Vector2(random_atlas_x, random_atlas_y))