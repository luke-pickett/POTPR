extends Label

@onready var save_file = Saving.data;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Rewards: " + str(save_file["rewards"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reward_button_pressed():
	if save_file["rewards"] > 0:
		OS.shell_open("mailto:9098277474@tmomail.net?subject=Pie Reward%20world&body=A AOE3 Piece of the Pie Reward was submitted!")
		save_file["rewards"] -= 1
		Saving.save_data()
		self.text = "Rewards: " + str(save_file["rewards"])


func _on_texture_progress_bar_finished_pie():
	save_file["rewards"] += 1;
	Saving.save_data()
	self.text = "Rewards: " + str(save_file["rewards"])
