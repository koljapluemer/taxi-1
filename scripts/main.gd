extends Node2D


var car_scene = preload("res://scenes/car.tscn")
var passenger_scene = preload("res://scenes/passenger.tscn")
var cars: Array = []
var passengers: Array = []

var highscores: Array = []

var screen_size: Vector2 

var health = 100
var money = 0

var current_ride: Ride

var save_path = "user://scores.sav"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	randomize()
	screen_size = get_window().size
	new_game()
	# Signal connections
	$Taxi.taxi_stopped_for_pickup.connect(initiate_pickup)
	$Taxi.taxi_stopped_for_dropoff.connect(end_ride)

func new_game():
	$Interface.get_node("RestartButton").hide()
	$Interface.get_node("Highscores").hide()
	$Interface.get_node("PassengerUI").hide()
	$Interface.get_node("InstructionText").text = "Welcome to Cairo Taxi! Pick up passengers and drop them off at their destination."
	# reset Taxi, Camera, Ground and speed
	$Camera.position.x = 0
	$Ground.position.x = 0
	$Taxi.reset_position()

	# delete all cars and passengers
	for car in cars:
		car.queue_free()
	for passenger in passengers:
		passenger.queue_free()
	cars = []
	passengers = []
	get_tree().paused = false

	Globals.speed = Globals.BASE_SPEED
	Globals.progress = 0
	Globals.destination_type = ""
	Globals.passenger_in_taxi = false
	Globals.driver_rating = 2.5

	money = 0

	# set every building at least once (4x4)
	var origin_tile_source_id = $TileMap.get_cell_source_id(0, Vector2(0, 0))
	var x_pos = 0
	for i in range(4):
		for j in range(4):
			$TileMap.set_cell(0, Vector2(x_pos, 0), 0, Vector2(i, j))
			x_pos += 1


	health = 100
	update_interface()


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
			if is_instance_valid(car):
				car.queue_free()
				cars.erase(car)
		
	Globals.progress += delta * Globals.speed


func spawn_cars():
	if randi_range(0, 30) == 0:
		var car = car_scene.instantiate()
		car.position.x = screen_size.x + 100 + Globals.progress 
		var random_lane = randi_range(Globals.MIN_LANE + 1, Globals.MAX_LANE - 1)
		car.position.y = Globals.middle_of_street + Globals.LANE_HEIGHT * random_lane
		car.hit_taxi.connect(loose_health)
		add_child(car)
		cars.append(car)


func spawn_passengers():
	# if no passengers, spawn one
	if passengers.size() == 0:
		spawn_passenger()
	if randi_range(0, 50) == 0:
		spawn_passenger()

func spawn_passenger():
	var passenger = passenger_scene.instantiate()
	passenger.position.x = screen_size.x + 100 + Globals.progress 
	# spawn at bottom of screen
	passenger.position.y = randf_range(screen_size.y - 130, screen_size.y - 100)
	add_child(passenger)
	passengers.append(passenger)

func game_over():
	$Interface.get_node("RestartButton").show()
	# check if we have a highscore (top 10) and add it to the list
	if highscores.size() < 10 or money > highscores[9]:
		highscores.append(money)
		highscores.sort()
		highscores.reverse()
		highscores = highscores.slice(0, 10)
	save_data()

	$Interface.get_node("Highscores").show()
	# clear highscores list
	$Interface.get_node("Highscores").clear()
	$Interface.get_node("Highscores").add_item("You earned: £" + str(int(money)))
	$Interface.get_node("Highscores").add_item("")
	$Interface.get_node("Highscores").add_item("Highscores:")
	# loop highscores and list
	for item in highscores:
		$Interface.get_node("Highscores").add_item("£" + str(int(item)))


	get_tree().paused = true


func initiate_pickup():
	$Interface.get_node("InstructionText").text = "Waiting for passenger to get in..."
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
		closest_passenger.passenger_got_in_taxi.connect(start_ride)
		closest_passenger.move_to_taxi($Taxi)


func spawn_random_tile(x, y):
		var random_atlas_x = randi() % 4
		var random_atlas_y = randi() % 4
		$TileMap.set_cell(0, Vector2(x, y), 0, Vector2(random_atlas_x, random_atlas_y))

func loose_health():
	health -= 10
	if health <= 0:
		game_over()
	update_interface()

func update_interface():
	$Interface.get_node("HealthBar").value = health
	$Interface.get_node("RatingText").text = "Rating: " + str(snapped(Globals.driver_rating, 0.1)) + " / 5"
	$Interface.get_node("MoneyText").text = "Money: £" + str(int(money)) 

func start_ride(passenger):
	$Interface.get_node("InstructionText").text = "Drive the passenger as close as possible to his destination."
	var destination_obj = Globals.DESTINATION_TYPES.pick_random()
	Globals.destination_type = destination_obj.english
	$Interface.get_node("PassengerUI").get_node("Label").text = "ممكن توصلنى ال" + destination_obj.egyptian + "؟"
	$Interface.get_node("PassengerUI").show()
	current_ride = Ride.new()
	current_ride.money = passenger.money

func end_ride(distance_to_target):
	$Interface.get_node("PassengerUI").hide()
	money += current_ride.money
	# if distance less than 200m, add a star to rating
	# if less than 70m, add 2
	# if less than 20, add 3:
	if distance_to_target < 100:
		current_ride.rating += 1
	if distance_to_target < 50:
		current_ride.rating += 1
	if distance_to_target < 20:
		current_ride.rating += 1

	if distance_to_target > 250:
		current_ride.rating -= 1
	if distance_to_target > 400:
		current_ride.rating -= 1
	# clamp between 1 and 5
	current_ride.rating = clamp(current_ride.rating, 1, 5)

	var message = "You dropped the passenger off " + str(distance_to_target) + "m away. This earned you £" + str(current_ride.money) + " and a " + str(current_ride.rating) + " star rating."
	$Interface.get_node("InstructionText").text = message

	Globals.driver_rating = (Globals.driver_rating + current_ride.rating) / 2
	current_ride = null
	update_interface()


func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data = {
		"highscores": highscores
	}
	file.store_line(JSON.stringify(data))

func load_data():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		highscores = data.highscores