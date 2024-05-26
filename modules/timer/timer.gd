extends Node2D

## A timer module
##
## This module sends a specific signal when an amount of time is reached.

signal hook(exception: Dictionary)


func set_data(data: Dictionary):
    $Builder/Time.text = str(data["time"])
    exception_data = data.get("exception_data", exception_data)
    $Timer.wait_time = data["time"]
    

func get_data() -> Dictionary:
    return {
        "time": $Timer.wait_time,
        "exception_data": exception_data,
    }


var exception_data = "timer"


func _ready():
    print("Starting timer")
    $Timer.start()


func _on_apply_pressed():
    $Timer.wait_time = float($Builder/Time.text)


func _on_timer_timeout():
    hook.emit({
        "event": "timer",
        "message": exception_data,
    })


func _on_builder_close_requested():
    $Builder.hide()
