extends Node2D

## Multiple stages:
##  1. Blank screen with black background
##  2. 20 zebrafish moving with grey background and walls
##  3. 3 indian leaf fish with dark-blue background and walls
##  4. Blank screen with black background

var root = preload("res://modules/stage/stage_builder.tscn")
var data = [
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "000000"}
            },
            "timer": {
                "path": "res://modules/timer/timer.tscn",
                "data": {"time": 0.5}
            }
        }
    },
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "222222"}
            },
            "timer": {
                "path": "res://modules/timer/timer.tscn",
                "data": {"time": 3.0}
            },
            "fish": {
                "path": "res://modules/zebra_fish/zebra_fish.tscn",
                "data": {
                    "group": "g",
                    "count": 20,
                    "speed": 300,
                    "scale": 0.4,
                    "move": true,
                }
            },
        }
    },
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "064273"}
            },
            "timer": {
                "path": "res://modules/timer/timer.tscn",
                "data": {"time": 3.0}
            },
            "fishs": {
                "path": "res://modules/dup_builder/dup_builder.tscn",
                "data": {
                    "path": "res://modules/indian_leaf_fish/indian_leaf_fish.tscn",
                    "count": 3,
                    "data": {
                        "scale_min": 0.5,
                        "scale_max": 3,
                        "scale_step": 0.3,
                        "speed": 200,
                    }
                }
            },
        }
    },
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "000000"}
            },
        }
    }
]


func _ready():
    var inst = root.instantiate()
    inst.set_data(data)
    add_child(inst)
    inst.run()
