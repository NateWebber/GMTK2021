extends KinematicBody2D

var rng = RandomNumberGenerator.new()

var gender_id
var hair_id
var skin_id
var flower_id

var partner_traits

var speed = 150
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	

func start():
	rng.randomize()
	velocity = Vector2(speed * rng.randf_range(-1, 1), speed * rng.randf_range(-1, 1))

func _physics_process(delta):
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
