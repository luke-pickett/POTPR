extends TextureProgressBar

@onready var save_file = Saving.data;

@onready var confetti = $ConfettiParticles
@onready var cheering = $ChildCheering

signal finished_pie

var NUM_PIECES_TO_REWARD = 6
var VALUE_STEP = 360/NUM_PIECES_TO_REWARD

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = save_file["pie_value"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.value >= 360:
		self.value = 0
		save_file["pie_value"] = 0
		emit_signal("finished_pie")
		Saving.save_data()
		confetti.emitting = true
		cheering.play()


func _on_piece_button_pressed():
	self.value += VALUE_STEP
	save_file["pie_value"] += VALUE_STEP
	Saving.save_data()
