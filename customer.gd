extends KinematicBody2D

var rng = RandomNumberGenerator.new()

var gender_id
var hair_id
var skin_id
var flower_id

var partner_traits

var speed = 100
var velocity = Vector2()

var moving = false

export var selected = false setget set_selected

onready var selection_sprite = $selection_sprite

signal was_selected
signal was_deselected

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("was_selected", get_parent(), "select_customer")
	connect("was_deselected", get_parent(), "deselect_customer")
	start()
	

func start():
	selection_sprite.visible = false
	rng.randomize()
	velocity = Vector2(speed * rng.randf_range(-1, 1), speed * rng.randf_range(-1, 1))

func _physics_process(delta):
	if moving:
		if velocity.x > 0:
			$face_sprite.frame = 1
		else:
			$face_sprite.frame = 0
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)

func set_trait_ids(new_gender, new_hair, new_skin, new_flower):
	gender_id = new_gender
	hair_id = new_hair
	skin_id = new_skin
	flower_id = new_flower

func get_trait_ids():
	var trait_ids = []
	trait_ids.append(gender_id)
	trait_ids.append(hair_id)
	trait_ids.append(skin_id)
	trait_ids.append(flower_id)
	return trait_ids
	
func get_partner_traits():
	return partner_traits
	
func set_partner_traits(new_partner_traits):
	partner_traits = new_partner_traits
	
func set_appearance():
	$gender_id_label.text = str(gender_id)
	$hair_id_label.text = str(hair_id)
	$skin_id_label.text = str(skin_id)
	$flower_id_label.text = str(flower_id)
	$gender_sprite.frame = gender_id - 1
	$hair_sprite.frame = hair_id - 1
	$skin_sprite.frame = skin_id - 1
	$flower_sprite.frame = flower_id - 1

func set_selected(value):
	if selected != value:
		selected = value
		selection_sprite.visible = value



func _on_customer_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if !selected:
					emit_signal("was_selected", self)
				else:
					emit_signal("was_deselected", self)
