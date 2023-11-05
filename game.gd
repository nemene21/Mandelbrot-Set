extends Node2D

var velocity: Vector2 = Vector2.ZERO
var speed := 0.1;

var pos  := Vector2.ZERO
var zoom := 1.0

var zoom_dest := 1.0
var pos_dest  := Vector2.ZERO

@onready var mandelbrot := $Mandelbrot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement = Input.get_vector("left", "right", "up", "down").normalized()
	
	pos_dest += movement * delta * zoom
	
	if Input.is_action_just_pressed("scroll_up"):
		zooming(1)
	
	if Input.is_action_just_pressed("scroll_down"):
		zooming(-1)
	
	pos = lerp(pos, pos_dest, 0.1)
	zoom = lerp(zoom, zoom_dest, 0.1)
	
	mandelbrot.material.set_shader_parameter("offset", pos)
	mandelbrot.material.set_shader_parameter("zoom", zoom)


func zooming(direction: int):
	direction = -direction
	
	zoom_dest += 0.1 * zoom_dest * direction
	var mouse_pos_normalized = get_global_mouse_position() / Vector2(1240, 720)
	mouse_pos_normalized -= Vector2(.5, .5)
	mouse_pos_normalized *= 2.0
