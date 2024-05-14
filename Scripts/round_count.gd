extends CanvasLayer

# Declare the variables for the countdown timer and the label
var countdown_time = 10
var countdown_label

var timer = Timer.new()

# Called when the node enters the scene tree for the first time
func _ready():
	# Get the label node by its unique name "%count"
	countdown_label = $%count
	# Start the countdown timer
	start_countdown()

# Function to start the countdown
func start_countdown():
	# Update the label with the initial countdown time
	countdown_label.text = str(countdown_time)
	# Set the timer to trigger every second
	timer.wait_time = 1.0
	# Set the timer to repeat
	timer.one_shot = false
	# Connect the timer's timeout signal to a function to update the countdown
	timer.timeout.connect(_on_timer_timeout)
	# Add the timer as a child to the current node
	add_child(timer)
	# Start the timer
	timer.start()

# Function to update the countdown each second
func _on_timer_timeout():
	# Decrease the countdown time
	countdown_time -= 1
	# Update the label with the new countdown time
	countdown_label.text = str(countdown_time)
	# Check if the countdown has reached 0
	if countdown_time <= 0:
		# If it has, stop the timer
		timer.stop()
		queue_free()
