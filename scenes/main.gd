extends Node2D

var rng = RandomNumberGenerator.new()

var customer = preload("res://scenes/customer.tscn")

const GENDER_VARIANTS = 2
const HAIR_VARIANTS = 5
const SKIN_VARIANTS = 5
const FLOWER_VARIANTS = 5

var current_customers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_new_game()
	start_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			generate_new_customer_pair()

func setup_new_game():
	current_customers = []
	
func start_game():
	while current_customers.size() < 50:
		generate_new_customer_pair()
		yield(get_tree().create_timer(1.5), "timeout")

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
		return null
	else:
		print("Adding a customer with these traits:")
		print(traits)
		var new_customer = customer.instance()
		new_customer.set_trait_ids(traits[0], traits[1], traits[2], traits[3])
		new_customer.set_appearance()
		new_customer.moving = true
		return new_customer
		
func generate_new_customer_pair():
	var customer1 = null
	while customer1 == null:
		customer1 = generate_new_customer()
	add_child(customer1)
	current_customers.append(customer1)
	var door_number = rng.randi_range(1, 4)
	match door_number:
		1:
			customer1.position = $door1.position + Vector2(0, 50)
		2:
			customer1.position = $door2.position + Vector2(-50, 0)
		3:
			customer1.position = $door3.position + Vector2(50, 0)
		4:
			customer1.position = $door4.position + Vector2(0, -50)

	var customer2 = null
	while customer2 == null:
		customer2 = generate_new_customer()
	add_child(customer2)
	current_customers.append(customer2)
	door_number = rng.randi_range(1, 4)
	match door_number:
		1:
			customer2.position = $door1.position + Vector2(0, 50)
		2:
			customer2.position = $door2.position + Vector2(-50, 0)
		3:
			customer2.position = $door3.position + Vector2(50, 0)
		4:
			customer2.position = $door4.position + Vector2(0, -50)
	
	customer1.set_partner_traits(customer2.get_trait_ids())
	customer2.set_partner_traits(customer1.get_trait_ids())
	
	print("Customer 1's Partner is:")
	print(customer1.get_partner_traits())
	
	print("Customer 2's Partner is:")
	print(customer2.get_partner_traits())
	
	
