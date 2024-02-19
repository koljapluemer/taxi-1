extends Area2D

signal hit_taxi

var is_spinning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# drive to the left
	position.x -= Globals.CAR_SPEED * delta
	if is_spinning:
		rotate(.2)


func _on_body_entered(body):
	if body.name == "Taxi":
		hit_taxi.emit()
		is_spinning = true
