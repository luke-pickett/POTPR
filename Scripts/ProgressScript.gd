extends TextureProgressBar

@onready var save_file = Saving.data;

@onready var confetti = $ConfettiParticles
@onready var cheering = $ChildCheering

signal finished_pie

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = save_file["pie_value"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.value == 360:
		self.value = 0
		save_file["pie_value"] = 0
		emit_signal("finished_pie")
		Saving.save_data()
		confetti.emitting = true
		cheering.play()


func _on_piece_button_pressed():
	self.value += 60
	save_file["pie_value"] += 60
	Saving.save_data()
