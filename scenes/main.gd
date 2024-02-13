extends Node2D


var car_scene = preload("res://scenes/car.tscn")
var cars: Array = []

var speed: float
const SCORE_MODIFIER : float = 0.1
const SPEED_MODIFIER : float = 0.002
const START_SPEED : float = 1000.0
const MAX_SPEED : float = 25.0
var screen_size: Vector2 

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	# reset Taxi, Camera, Ground and speed
	$Camera.position.x = 0
	$Ground.position.x = 0
	$Taxi.reset_position()
	speed = START_SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("speed: ", speed)
	$Taxi.position.x += speed * delta
	$Camera.position.x += speed * delta

	# update ground pos (check if we moved the camera more than 1.5x the screen width)
	if $Camera.position.x - $Ground.position.x > screen_size.x * 1.2:
		$Ground.position.x += screen_size.x


func _on_button_button_up():
	pass
