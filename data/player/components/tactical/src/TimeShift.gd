extends Component

signal save_shift_pos()
sync var pos_on_time = []

func _ready():
	get_tree().create_timer(0.6).connect("timeout", self, "_on_shift_save")
	
func _on_shift_save():
	var pos = [actor.translation, actor.head.rotation_degrees]
	if pos_on_time.size() < 4:
		pos_on_time.append(pos)
	else:
		if pos[0] != pos_on_time[3][0]:
			pos_on_time[0] = pos_on_time[1]
			pos_on_time[1] = pos_on_time[2]
			pos_on_time[2] = pos_on_time[3]
			pos_on_time[3] = pos
	get_tree().create_timer(0.6).connect("timeout", self, "_on_shift_save")

func _physics_process(delta):
	if actor.input["special"]:
		_move_backwards()

func _move_backwards():
	if pos_on_time.size()>1:
		yield(get_tree().create_timer(0.1), "timeout")
		actor.translation = pos_on_time[0][0]
		actor.head.rotation_degrees = pos_on_time[0][1]
