extends GutTest

var cls: PackedScene = preload("res://modules/stage/stage_builder.tscn")
var data = [
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "000000ff"}
            },
            "timer": {
                "path": "res://modules/timer/timer.tscn",
                "data": {"time": 0.5, "exception_data": "timer"},
            }
        }
    },
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "222222ff"}
            },
            "timer": {
                "path": "res://modules/timer/timer.tscn",
                "data": {"time": 3.0, "exception_data": "timer"}
            },
            "fish": {
                "path": "res://modules/zebra_fish/zebra_fish.tscn",
                "data": {
                    "count": 20,
                    "speed": 300.0,
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
                "data": {"background": "064273ff"}
            },
            "timer": {
                "path": "res://modules/timer/timer.tscn",
                "data": {"time": 3.0, "exception_data": "timer"}
            },
            "fishs": {
                "path": "res://modules/dup_builder/dup_builder.tscn",
                "data": {
                    "path": "res://modules/indian_leaf_fish/indian_leaf_fish.tscn",
                    "data": {
                        "scale_min": 0.5,
                        "scale_max": 3.0,
                        "scale_step": 0.3,
                        "speed": 200,
                    },
                    "count": 3
                }
            },
        }
    },
    {
        "path": "res://modules/stage/scene_builder.tscn",
        "data": {
            "env": {
                "path": "res://modules/env/env.tscn",
                "data": {"background": "000000ff"}
            },
        }
    }
]


func test_get_data():
    var inst = cls.instantiate()
    inst.set_data(data)
    assert_eq(JSON.stringify(data), JSON.stringify(inst.get_data()))


func test_stringify():
    var inst = cls.instantiate()
    inst.set_data(data)
    var file = FileAccess.open("./data/test_stage.json", FileAccess.WRITE)
    assert_eq(FileAccess.get_open_error(), OK)
    file.store_string(JSON.stringify({
        "zfish": "02",
        "path": "res://modules/stage/stage_builder.tscn",
        "data": inst.get_data(),
    }, "    ", false, false))
    file.close()
