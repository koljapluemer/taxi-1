extends Area2D

signal hit_taxi

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# drive to the left
	position.x -= Globals.CAR_SPEED * delta

func _on_body_entered(body):
	if body.name == "Taxi":
		# subtract 1000 points from the score, but cap it at 0
		Globals.score = max(0, Globals.score - 1000)
		hit_taxi.emit()
		# call game_over in main scene to end the game 
		# get_tree().get_root().get_node("Main").game_over()
