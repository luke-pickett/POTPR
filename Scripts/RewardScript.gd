extends Label

@onready var save_file = Saving.data;
@onready var rewardButton = $"../RewardButton"
@onready var timer = $"../RewardButton/Timer"

var WEBHOOK_ENDPOINT = "https://discord.com"
var WEBHOOK_URL = "/api/webhooks/1134945188226285719/o2Fpm9Af8YQHiQowiQjFJaSyuBQgHYveWWo22pB10cCLU3_2n564uRfxqRQ2A2MrqFzJ"
var SPAM_TIMER = 60 # in seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Rewards: " + str(save_file["rewards"])
	rewardButton.disabled = save_file["rewards"] <= 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reward_button_pressed():
	if save_file["rewards"] > 0:
		rewardButton.disabled = true
		rewardButton.text = "Submitting..."
		print("A")
		var success = await send_to_webhook("An AOE3 Piece of the Pie Reward was submitted!")
		print(success)
		print("B")
		if success:
			save_file["rewards"] -= 1
			Saving.save_data()
			self.text = "Rewards: " + str(save_file["rewards"])
			rewardButton.text = "Sent! Enjoy your free rewards!"
		else:
			rewardButton.text = "Failed to send. Try again later."
		timer.start()


func _on_texture_progress_bar_finished_pie():
	save_file["rewards"] += 1;
	Saving.save_data()
	self.text = "Rewards: " + str(save_file["rewards"])
	rewardButton.disabled = false

func send_to_webhook(message):
	var success = true
	var httpClient = HTTPClient.new()
	var err = httpClient.connect_to_host(WEBHOOK_ENDPOINT, 443)
	if err == OK:
		while (httpClient.get_status() == HTTPClient.STATUS_CONNECTING or httpClient.get_status() == HTTPClient.STATUS_RESOLVING):
			httpClient.poll()
			if not OS.has_feature("web"):
				OS.delay_msec(100)
			else:
				await Engine.get_main_loop().idle_frame
		var bodyDict = {"content": message}
		var body = JSON.stringify(bodyDict, "\t")
		var headers = [
			"content-length: " + str(body.length()),
			"content-type: application/json"
		]
		err = httpClient.request(HTTPClient.METHOD_POST, WEBHOOK_URL, headers, body)
		if err == OK:
			while httpClient.get_status() == HTTPClient.STATUS_REQUESTING:
				httpClient.poll()
				if not OS.has_feature("web"):
					OS.delay_msec(500)
				else:
					await Engine.get_main_loop().idle_frame
			if httpClient.get_status() == HTTPClient.STATUS_BODY or httpClient.get_status() == HTTPClient.STATUS_CONNECTED:
				if httpClient.has_response():
					if httpClient.get_response_code() < 400:
						var rb = PackedByteArray()
						while httpClient.get_status() == HTTPClient.STATUS_BODY:
							httpClient.poll()
							var chunk = httpClient.read_response_body_chunk();
							if chunk.size() == 0:
								OS.delay_msec(100)
							else:
								rb += chunk
					else:
						print("http error. Code: ", httpClient.get_response_code())
						success = false
			else:
				success = false
		else:
			success = false
	else:
		success = false
	return success


func _on_timer_timeout():
	if save_file["rewards"] > 0:
		rewardButton.disabled = false
	rewardButton.text = "Submit Reward"
