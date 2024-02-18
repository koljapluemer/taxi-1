extends CharacterBody2D

var lane = 0

const START_POS_X = 100

signal taxi_stopped_for_pickup
signal taxi_stopped_for_dropoff

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_position()

func reset_position():
	lane = 0
	position.y = Globals.middle_of_street + Globals.LANE_HEIGHT * lane
	position.x = START_POS_X

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move up and down a lane_height on arrow key press (within limits)
	if Input.is_action_just_pressed("ui_up"):
		lane = max(lane - 1, Globals.MIN_LANE)
		position.y = Globals.middle_of_street + Globals.LANE_HEIGHT * lane
		Globals.speed = Globals.BASE_SPEED
		if Globals.passenger_in_taxi && lane == Globals.MIN_LANE:
			Globals.speed = 0
			# find out how far the nearest tyle of type destination_type is from the taxi:
			var nearest_relevant_tile: Vector2
			var tile_map = get_parent().get_node("TileMap")
			var tile_that_taxi_is_on = tile_map.local_to_map(position)
			var nearest_correct_tile_found = false
			var looking_for_destination_type_string = Globals.destination_type.replace(" ", "_").to_lower()
			var i = 0;
			while !nearest_correct_tile_found:
				# we're iteratively checking tiles on both sides of the taxi, fanning out
				# TODO: could abstract this, it's almost exactly the same twice (also incredibly complex for the simple question I have)
				# check behind
				var tile_to_check_behind = Vector2(tile_that_taxi_is_on.x - i, 0)
				var tile_behind_data = tile_map.get_cell_tile_data(0, tile_to_check_behind)
				if tile_behind_data:
					var tile_type_behind = tile_behind_data.get_custom_data("building_type")
					if tile_type_behind == looking_for_destination_type_string:
						nearest_correct_tile_found = true
						nearest_relevant_tile = tile_to_check_behind
						tile_that_taxi_is_on = tile_to_check_behind
				# check ahead
				var tile_to_check_ahead = Vector2(tile_that_taxi_is_on.x + i, 0)
				var tile_ahead_data = tile_map.get_cell_tile_data(0, tile_to_check_ahead)
				if tile_ahead_data:
					var tile_type_ahead = tile_ahead_data.get_custom_data("building_type")
					if tile_type_ahead == looking_for_destination_type_string:
						nearest_relevant_tile = tile_to_check_ahead
						nearest_correct_tile_found = true
						tile_that_taxi_is_on = tile_to_check_ahead
				
				i += 1
			var tile_x = tile_map.map_to_local(nearest_relevant_tile).x
			var distance_to_nearest_relevant_tile = abs(tile_x - position.x)
			# distance in m: divide by 10 and round
			distance_to_nearest_relevant_tile = round(distance_to_nearest_relevant_tile / 10)
			# put in main's DialogueText
			# TODO: this is terrible. use a signal or something.
			get_tree().get_root().get_node("Main").get_node("Interface").get_node("DialogueText").text = "You dropped off your passenger " + str(distance_to_nearest_relevant_tile) + " m away."
			# add score based on distance
			# +1000 for perfect dropoff, minimum 5 at 500m distance
			var dropoff_score = max(5, 1000 - distance_to_nearest_relevant_tile * 2)
			Globals.score += dropoff_score
			# reset
			Globals.passenger_in_taxi = false

	elif Input.is_action_just_pressed("ui_down"):
		lane = min(lane + 1, Globals.MAX_LANE)
		position.y = Globals.middle_of_street + Globals.LANE_HEIGHT * lane
		Globals.speed = Globals.BASE_SPEED
		if lane == Globals.MAX_LANE && !Globals.passenger_in_taxi:
			Globals.speed = 0
			taxi_stopped_for_pickup.emit()
			


	move_and_collide(Vector2(Globals.speed * delta, 0))

