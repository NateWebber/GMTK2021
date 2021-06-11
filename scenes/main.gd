extends Node2D

var rng = RandomNumberGenerator.new()

var customer = preload("res://scenes/customer.tscn")

const GENDER_VARIANTS = 2
const HAIR_VARIANTS = 2
const SKIN_VARIANTS = 2
const FLOWER_VARIANTS = 2

var current_customers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_new_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			generate_new_customer()

func setup_new_game():
	current_customers = []

func generate_new_customer_traits():
	print("Generating new customer traits!")
	var new_traits = []
	new_traits.append(rng.randi_range(1, GENDER_VARIANTS))
	new_traits.append(rng.randi_range(1, HAIR_VARIANTS))
	new_traits.append(rng.randi_range(1, SKIN_VARIANTS))
	new_traits.append(rng.randi_range(1, FLOWER_VARIANTS))
	print("Generated this set of traits:")
	print(new_traits)
	return new_traits

func check_traits_duplicated(trait_set_1, trait_set_2):
	var gender_matches = trait_set_1[0] == trait_set_2[0]
	var hair_matches = trait_set_1[1] == trait_set_2[1]
	var skin_matches = trait_set_1[2] == trait_set_2[2]
	var flower_matches = trait_set_1[3] == trait_set_2[3]
	return gender_matches and hair_matches and skin_matches and flower_matches

func generate_new_customer():
	print("Starting to generate a new customer!")
	var traits = generate_new_customer_traits()
	var found_match = false
	for existing_customer in current_customers:
		if check_traits_duplicated(traits, existing_customer.get_trait_ids()):
			found_match = true
			print("Newly generated customer matches an existing one!")
			break
	if found_match:
		print("Generation failed because we matched!")
	else:
		print("Adding a customer with these traits:")
		print(traits)
		var new_customer = customer.instance()
		new_customer.set_trait_ids(traits[0], traits[1], traits[2], traits[3])
		new_customer.set_appearance()
		new_customer.position = get_global_mouse_position()
		add_child(new_customer)
		current_customers.append(new_customer)
