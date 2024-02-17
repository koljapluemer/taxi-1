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
	if body.name == "Player":
		print("Player hit by car!")
		body.die()
		queue_free()
