extends Node2D

## Indian Leaf Fish (Predator)

var cls: PackedScene = preload("res://modules/indian_leaf_fish/fish.tscn")
var inst

signal hook(exception)

func set_data(data):
    $Builder/ScaleMin.value = data["scale_min"]
    $Builder/ScaleMax.value = data["scale_max"]
    $Builder/ScaleStep.value = data["scale_step"]
    $Builder/Speed.value = data["speed"]
    run()
    
    
func get_data():
    return {
        "scale_min": $Builder/ScaleMin.value,
        "scale_max": $Builder/ScaleMax.value,
        "scale_step": $Builder/ScaleStep.value,
        "speed": $Builder/Speed.value,
    }
    

func run():
    for child in $Scene.get_children():
        child.queue_free()
    inst = cls.instantiate()
    inst.scale.x = $Builder/ScaleMin.value
    inst.scale.y = $Builder/ScaleMin.value
    inst.scale_inc = $Builder/ScaleStep.value
    inst.scale_max = $Builder/ScaleMax.value
    inst.speed = $Builder/Speed.value
    $Scene.add_child(inst)


func _ready():
    run()
    

func _on_apply_pressed():
    run()


func _on_builder_close_requested():
    $Builder.hide()
