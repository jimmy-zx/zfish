extends Node2D

## Shrimp
##
## Note: might have a lot, thus performance intensive.

var cls = preload("res://modules/shrimp/body.tscn")

signal hook(exception)

func set_data(data: Dictionary):
    $Builder/Count.text = str(data["count"])
    _on_apply_pressed()


func get_data() -> Dictionary:
    return {
        "count": int($Builder/Count.text)
    }


func _on_apply_pressed():
    for child in $Node2D.get_children():
        child.queue_free()
    for i in range(int($Builder/Count.text)):
        var inst = cls.instantiate()
        $Node2D.add_child(inst)


func _on_builder_close_requested():
    $Builder.hide()
