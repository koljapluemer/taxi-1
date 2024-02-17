extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# drive to the left
	position.x -= Globals.CAR_SPEED * delta

func _on_body_entered(body):
	print("body entered")
	if body.name == "Taxi":
		# trigger game_over in main scene
		get_tree().get_root().get_node("Main").game_over()

