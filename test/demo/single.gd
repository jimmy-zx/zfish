extends Node2D

## Single scene: 20 zebrafish moving with 200 shrimps black background and walls

var root = preload("res://modules/stage/stage_builder.tscn")
var data = [
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {
                    "background": "000000",
                }
            },
            "fish": {
                "path": "res://modules/zebra_fish/zebra_fish.tscn",
                "data": {
                    "group": "g",
                    "count": 20,
                    "speed": 250,
                    "scale": 0.4,
                    "move": true,
                }
            },
            "shrimp": {
                "path": "res://modules/shrimp/shrimp.tscn",
                "data": {
                    "count": 200,
                }
            }
        }
    },
]


func _ready():
    var inst = root.instantiate()
    inst.set_data(data)
    add_child(inst)
    inst.run()
