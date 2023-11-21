extends Node2D

var velocity: Vector2 = Vector2.ZERO
var speed := 0.1;

var pos  := Vector2.ZERO
var zoom := 12.0

var fake_zoom = 100

var zoom_dest := 12.0
var pos_dest  := Vector2.ZERO

var picture_ratio = 5.0


@export var color_anim_speed := .05
var color_anim := .0

var color = null
var next_color = null

var taking_photo = false

var timer := .0

var photos := 0

var colors = [
	Color("#f77622"),
	Color("#63c74d"),
	Color("#b55088"),
	Color("#e43b44"),
	Color("#fee761"),
	Color("#2ce8f5"),
	Color("#124e89")
]

@onready var mandelbrot := $Mandelbrot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	randomize()
	
	color = colors.pick_random()
	next_color = colors.pick_random()
	
	while color == next_color:
		colors.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = Time.get_date_dict_from_system()
	$DateLabel.text = str(time["day"]) +"."+ str(time["month"]) +"."+ str(time["year"])
	
	if Input.is_action_just_pressed("photo") and !taking_photo:
		taking_photo = true
		photos += 1
		
		$SnapPhotoSound.play()
		
		$PostProcessing.hide()
		$RecLabel.hide()
		$ZoomLabel.hide()
		$BackBufferCopy/CameraEffect.hide()
		$DateLabel.hide()
		
		$Mandelbrot.material.set_shader_parameter("exponent", .5)
		$Mandelbrot.material.set_shader_parameter("samples", $Mandelbrot.material.get_shader_parameter("samples") * picture_ratio)
		$Mandelbrot.material.set_shader_parameter("max_iterations", $Mandelbrot.material.get_shader_parameter("max_iterations") * picture_ratio)
		
		await(get_tree().create_timer(.1).timeout)
		
		var texture = get_viewport().get_texture()
		var image = texture.get_image()
		image.save_png("user://Mandelbrotov Skup Slike/Slika_" + str(photos) + ".png")
		
		$Picture/Sprite.texture = ImageTexture.create_from_image(image)
		$Picture.show()
		$PictureAnimation.play("picture")
		
		$Mandelbrot.material.set_shader_parameter("exponent", .75)
		$Mandelbrot.material.set_shader_parameter("samples", $Mandelbrot.material.get_shader_parameter("samples") / picture_ratio)
		$Mandelbrot.material.set_shader_parameter("max_iterations", $Mandelbrot.material.get_shader_parameter("max_iterations") / picture_ratio)
		
		$PostProcessing.show()
		$RecLabel.show()
		$ZoomLabel.show()
		$BackBufferCopy/CameraEffect.show()
		$DateLabel.show()
	
	var movement = Input.get_vector("left", "right", "up", "down").normalized()
	
	timer += delta
	$RecLabel/RecCircle.visible = sin(timer * 8.0) > .0
	$ZoomLabel.text = str(fake_zoom) + "%"
	
	pos_dest += movement * delta * zoom
	
	if Input.is_action_just_pressed("scroll_up"):
		zooming(1)
	
	if Input.is_action_just_pressed("scroll_down"):
		zooming(-1)
	
	pos = lerp(pos, pos_dest, 0.2)
	zoom = lerp(zoom, zoom_dest, 0.2)
	
	mandelbrot.material.set_shader_parameter("offset", pos)
	mandelbrot.material.set_shader_parameter("zoom", zoom)
	
	var definite_color = color + (next_color - color) * color_anim
	mandelbrot.material.set_shader_parameter("color2", definite_color)
	mandelbrot.material.set_shader_parameter("color1", Color(definite_color * .05, 1.0))
	
	animate_color(delta)
	

func animate_color(delta: float) -> void:
	color_anim += color_anim_speed * delta
	if color_anim >= 1.0:
		color_anim = .0
		
		color = next_color
		while color == next_color:
			next_color = colors.pick_random()

func zooming(direction: int) -> void:
	if !$CameraZoomSound.playing:
		$CameraZoomSound.pitch_scale = 1.0 + randf_range(-.1, .1) + direction * .2
		$CameraZoomSound.play()
	
	fake_zoom += 25 * direction
	
	direction = -direction
	zoom_dest += 0.2 * zoom_dest * direction


func _on_picture_animation_animation_finished(anim_name: StringName) -> void:
	$Picture.hide()
	taking_photo = false
