extends RichTextLabel

var caught_counter
var missed_counter

var caught_count = 0
var missed_count = 0

func _ready():
	caught_counter = $Caught
	missed_counter = $Missed

	caught_counter.text = str(caught_count)
	missed_counter.text = str(missed_count)

func increment_caught():
	caught_count += 1
	caught_counter.text = str(caught_count)

func increment_missed():
	missed_count += 1
	missed_counter.text = str(missed_count)

func reset_caught():
	caught_count = 0
	caught_counter.text = str(caught_count)

func reset_missed():
	missed_count = 0
	missed_counter.text = str(missed_count)
