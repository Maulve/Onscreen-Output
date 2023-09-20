extends Node2D

func _ready() -> void:
	scrnOutput.print("Hello World!")
	
	var timer := Timer.new()
	timer.wait_time = 5
	add_child(timer)
	timer.start()
	timer.timeout.connect(func(): scrnOutput.print("Hello"))

#func _physics_process(_delta: float) -> void:
	#scrnOutput.print("This is a very long debug message, maybe this should be shortened.")
