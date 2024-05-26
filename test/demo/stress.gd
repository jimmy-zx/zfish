extends Node2D

## Stress: As mush shrimps as possible
##
## Preset: 1920x1080 @60fps

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
            "shrimp": {
                "path": "res://modules/shrimp/shrimp.tscn",
                "data": {
                    "count": 4000,
                }
            }
        }
    },
]


func _ready():
    var inst = root.instantiate()
    inst.set_data(data)
    $Node2D.add_child(inst)
    inst.run()
