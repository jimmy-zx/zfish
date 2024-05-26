extends Node2D

signal hook(exception)


var scene = preload("res://modules/zebra_fish/fish.tscn")

func _ready():
    _scene_load_data()
    

func get_data() -> Dictionary:
    return {
        "count": int($Builder/Attrs/Count.text),
        "speed": $Builder/Attrs/Speed.value,
        "scale": $Builder/Attrs/Scale.value,
        "move": $Builder/Attrs/Move.button_pressed
    }
    
func set_data(new_data: Dictionary):
    $Builder/Attrs/Count.text = str(new_data["count"])
    $Builder/Attrs/Speed.value = new_data["speed"]
    $Builder/Attrs/Scale.value = new_data["scale"]
    $Builder/Attrs/Move.button_pressed = new_data["move"]
    _scene_load_data()


func _scene_load_data():
    for child in $Scene.get_children():
        child.queue_free()
    for i in range(int($Builder/Attrs/Count.text)):
        var inst = scene.instantiate()
        inst.velocity = Vector2($Builder/Attrs/Speed.value * [1, -1][randi() % 2], 0)
        inst.scale.x = $Builder/Attrs/Scale.value
        inst.scale.y = $Builder/Attrs/Scale.value
        inst.move_enable = $Builder/Attrs/Move.button_pressed
        $Scene.add_child(inst)


func _on_apply_pressed():
    _scene_load_data()


func _on_builder_close_requested():
    $Builder.hide()
