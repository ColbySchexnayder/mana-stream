class_name PlacementImage extends Node2D

@export var timeToMove := 3.0
@export var moveSpeed := 3.0
var start: Vector2
var dest: Vector2
var distance: float
var completed := true
signal _Movement_Complete

func card_moves(origin: Vector2, destination: Vector2, time: float = timeToMove):
	start = origin
	dest = destination
	timeToMove = time
	position = start
	distance = start.distance_to(dest)
	completed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !completed:
		visible = true
		
		var current_distance = position.distance_to(dest)
		#position = lerp(start, dest, (current_distance+delta)/distance)
		position = position.move_toward(dest,delta)
		#print(position)
		if current_distance < .01:
			completed = true
			visible = false
			emit_signal("_Movement_Complete")
