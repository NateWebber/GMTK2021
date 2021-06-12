extends Node2D

var rng = RandomNumberGenerator.new()

export var debug = false

var customer = preload("res://scenes/customer.tscn")

const GENDER_VARIANTS = 2
const HAIR_VARIANTS = 5
const SKIN_VARIANTS = 5
const FLOWER_VARIANTS = 5

var current_customers = []

var selected_customer_1
var selected_customer_2

var goal_customer_1
var goal_customer_2

onready var goal_customer_1_display = $goal_customer_1
onready var goal_customer_2_display = $goal_customer_2

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_new_game()
	start_game()
	set_debug(true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.pressed:
#			generate_new_customer_pair()

func setup_new_game():
	current_customers = []
	selected_customer_1 = null
	selected_customer_2 = null
	goal_customer_1_display.visible = false
	goal_customer_2_display.visible = false
	goal_customer_1_display.scale = Vector2(2, 2)
	goal_customer_2_display.scale = Vector2(2, 2)
	$goal_customer_1/face_sprite.frame = 1 #facing right
	$goal_customer_2/face_sprite.frame = 0 #facing left
	
func start_game():
	for i in 5:
		generate_new_customer_pair()
	get_new_goal_customers()
	while current_customers.size() < 24:
		generate_new_customer_pair()
		yield(get_tree().create_timer(3), "timeout")

func generate_new_customer_traits():
	#print("Generating new customer traits!")
	var new_traits = []
	new_traits.append(rng.randi_range(1, GENDER_VARIANTS))
	new_traits.append(rng.randi_range(1, HAIR_VARIANTS))
	new_traits.append(rng.randi_range(1, SKIN_VARIANTS))
	new_traits.append(rng.randi_range(1, FLOWER_VARIANTS))
	#print("Generated this set of traits:")
	#print(new_traits)
	return new_traits

func check_traits_duplicated(trait_set_1, trait_set_2):
	var gender_matches = trait_set_1[0] == trait_set_2[0]
	var hair_matches = trait_set_1[1] == trait_set_2[1]
	var skin_matches = trait_set_1[2] == trait_set_2[2]
	var flower_matches = trait_set_1[3] == trait_set_2[3]
	return gender_matches and hair_matches and skin_matches and flower_matches

func generate_new_customer():
	#print("Starting to generate a new customer!")
	var traits = generate_new_customer_traits()
	var found_match = false
	for existing_customer in current_customers:
		if check_traits_duplicated(traits, existing_customer.get_trait_ids()):
			found_match = true
			#print("Newly generated customer matches an existing one!")
			break
	if found_match:
		#print("Generation failed because we matched!")
		return null
	else:
		#print("Adding a customer with these traits:")
		#print(traits)
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
	
	#print("Customer 1's Partner is:")
	#print(customer1.get_partner_traits())
	
	#print("Customer 2's Partner is:")
	#print(customer2.get_partner_traits())
	
func select_customer(customer):
	print("selecting customer")
	if selected_customer_1 == null:
		selected_customer_1 = customer
		customer.set_selected(true)
		check_for_match()
	elif selected_customer_2 == null:
		selected_customer_2 = customer
		customer.set_selected(true)
		check_for_match()
	else:
		print("Already have two customers selected!")

func deselect_customer(customer):
	print("deselecting customer")
	if selected_customer_1 == customer:
		selected_customer_1 = null
		customer.set_selected(false)
	elif selected_customer_2 == customer:
		selected_customer_2 = null
		customer.set_selected(false)
	else:
		print("Customer wasn't selected already!")
	
func check_for_match():
	if selected_customer_1 == null or selected_customer_2 == null:
		print("two customers need to be selected!")
		return false
	else:
		#this if statement is gross I know
		if (selected_customer_1 == goal_customer_1 or selected_customer_1 == goal_customer_2) and (selected_customer_2 == goal_customer_1 or selected_customer_2 == goal_customer_2):
			if selected_customer_1.get_partner_traits() == selected_customer_2.get_trait_ids():
				print("found a match!")
				clear_matched_customers()
				get_new_goal_customers()
				return true
		else:
			print("these two aren't a match, or aren't the current goal!")
			return false

func find_customer_with_traits(search_traits):
	for customer in current_customers:
		if check_traits_duplicated(search_traits, customer.get_trait_ids()):
			return customer
	print("no customers matched the search traits and you might be boned")
	return null
	
func clear_matched_customers():
	deselect_customer(goal_customer_1)
	deselect_customer(goal_customer_2)
	current_customers.erase(goal_customer_1)
	current_customers.erase(goal_customer_2)
	goal_customer_1.queue_free()
	goal_customer_2.queue_free()

func get_new_goal_customers():
	goal_customer_1 = current_customers[rng.randi() % current_customers.size()]
	goal_customer_2 = find_customer_with_traits(goal_customer_1.get_partner_traits())
	updateUI()

func updateUI():
	var c_1_traits = goal_customer_1.get_trait_ids()
	print("goal customer 1's traits are %s" % str(c_1_traits))
	var c_2_traits = goal_customer_2.get_trait_ids()
	print("goal customer 2's traits are %s" % str(c_2_traits))
	goal_customer_1_display.set_trait_ids(c_1_traits[0], c_1_traits[1], c_1_traits[2], c_1_traits[3])
	goal_customer_2_display.set_trait_ids(c_2_traits[0], c_2_traits[1], c_2_traits[2], c_2_traits[3])
	goal_customer_1_display.set_appearance()
	goal_customer_2_display.set_appearance()
	goal_customer_1_display.visible = true
	goal_customer_2_display.visible = true
	
func set_debug(value):
	debug = value
	for customer in current_customers:
		customer.set_label_visibilty(value)
	goal_customer_1_display.set_label_visibilty(value)
	goal_customer_2_display.set_label_visibilty(value)
