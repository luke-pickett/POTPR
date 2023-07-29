extends Node

var save_filename = "user://save_game.save"

var data = {}

func _ready():
	load_data()


func save_data():
	var file = FileAccess.open(save_filename, FileAccess.WRITE)
	file.store_var(data)
	file.close()


func load_data():
	if not FileAccess.file_exists(save_filename):
		data = {
			"pie_value": 0,
			"rewards": 1
		}
		save_data()
		
	var file = FileAccess.open(save_filename, FileAccess.READ)
	data = file.get_var()
	file.close()
