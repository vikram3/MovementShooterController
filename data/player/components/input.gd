extends Component
export(bool) var run_is_toggle : bool = false
export(bool) var crouch_is_toggle : bool = false

export(bool) var captured : bool = true; # Does not let the mouse leave the screen

var can_jump = true
var jump_timer = null

func _ready():
	actor.input["look_y"] = 0
	actor.input["look_x"] = 0
	actor.input["special"] = int(Input.is_action_pressed("SPECIAL"));
	actor.input["left"]   = int(Input.is_action_pressed("KEY_A"));
	actor.input["right"]  = int(Input.is_action_pressed("KEY_D"));
	actor.input["forward"] = int(Input.is_action_pressed("KEY_W"));
	actor.input["back"]   = int(Input.is_action_pressed("KEY_S"));
	actor.input["jump"] = int(Input.is_action_pressed("KEY_SPACE"));
	actor.input["extra_jump"] =  int(Input.is_action_just_pressed("KEY_SPACE"));
	actor.input["crouch"] = int(Input.is_action_pressed("KEY_CTRL"));
	actor.input["sprint"] = 0
	
	actor.input["shoot"] = int(Input.is_action_pressed("mb_left"));
	actor.input["reload"] = int(Input.is_action_pressed("KEY_R"));
	actor.input["zoom"] = int(Input.is_action_pressed("mb_right"));



func _mouse_toggle() -> void:
	# Function to lock or unlock the mouse in the center of the screen
	if Input.is_action_just_pressed("KEY_ESCAPE"):
		# Captured will receive the opposite of the value itself
		captured = !captured;
	
	if captured:
		# Locks the mouse in the center of the screen
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	else:
		# Unlocks the mouse from the center of the screen
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	

func _physics_process(delta):
	actor.input["left"]   = int(Input.is_action_pressed("KEY_A"));
	actor.input["right"]  = int(Input.is_action_pressed("KEY_D"));
	actor.input["forward"] = int(Input.is_action_pressed("KEY_W"));
	actor.input["back"]   = int(Input.is_action_pressed("KEY_S"));

	if not crouch_is_toggle:
		actor.input["crouch"] = int(Input.is_action_pressed("KEY_CTRL"));
	if not run_is_toggle:
		actor.input["sprint"] = int(Input.is_action_pressed("KEY_SHIFT"));
		
	actor.input["shoot"] = int(Input.is_action_pressed("mb_left"));
	actor.input["reload"] = int(Input.is_action_pressed("KEY_R"));
	actor.input["zoom"] = int(Input.is_action_pressed("mb_right"));
	actor.input["special"] = int(Input.is_action_just_pressed("SPECIAL"));
	actor.input["extra_jump"] = int(Input.is_action_just_pressed("KEY_SPACE"))

func _jump():
	actor.input["jump"] = true
	yield(get_tree().create_timer(0.01), "timeout")
	actor.input["jump"] = false

func _unhandled_input(event):
	# Calls function to switch between locked and unlocked mouse
	_mouse_toggle();
	
	if int(Input.is_action_just_pressed("KEY_SPACE")):
		_jump()
		
	if event is InputEventMouseMotion:
		actor.input["look_y"] = event.relative.y 
		actor.input["look_x"] = event.relative.x 

	if run_is_toggle:
		if Input.is_action_just_pressed("KEY_SHIFT"):
			actor.input["sprint"] = int(not bool(actor.input["sprint"]))
		if Input.is_action_pressed("KEY_CTRL") or actor.run_speed < 0.3 or Input.is_action_just_released("KEY_W"):
			actor.input["sprint"] = 0
	if crouch_is_toggle:
		if Input.is_action_just_released("KEY_CTRL"):
			actor.input["crouch"] = int(not bool(actor.input["crouch"]))
		if Input.is_action_pressed("KEY_SHIFT") or Input.is_action_just_released("KEY_SPACE"):
			actor.input["crouch"] = 0


#	if Input.is_action_just_released(("KEY_SPACE")) and Input.is_action_pressed("KEY_SPACE"):
#		actor.input["jump_extra"] = 1
