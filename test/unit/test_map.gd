extends GutTest

var target: PackedScene = preload("res://lib/map.tscn")

var callback_data = null

const data1 = {
    "tmr1": {
        "path": "res://modules/timer/timer.tscn",
        "data": {
            "time": 0.5,
            "exception_data": "hello",
        },
    },
}


func test_set_data():
    var inst = target.instantiate()
    callback_data = null
    inst.hook.connect(func(data): callback_data = data)
    inst.set_data(data1)
    for item in data1:
        assert_eq(inst.insts[item].get_data(), data1[item]["data"])
        assert_eq(inst.paths[item], data1[item]["path"])
    assert_eq(callback_data["event"], "load")


func test_get_data():
    var inst = target.instantiate()
    inst.set_data(data1)
    assert_eq(inst.get_data(), data1)
    

func test_get_data_mut():
    var inst = target.instantiate()
    inst.set_data(data1)
    inst.insts["tmr1"].set_data({"time": 1.0})
    var data = inst.get_data()
    assert_eq(data["tmr1"]["data"]["time"], 1.0)


func test_add_item():
    var inst = target.instantiate()
    inst.set_data(data1)
    inst._add_item("elem1", "res://modules/timer/timer.tscn")
    assert_true("elem1" in inst.insts)
    assert_eq(inst.paths["elem1"], "res://modules/timer/timer.tscn")
    

func test_remove_item():
    var inst = target.instantiate()
    inst.set_data(data1)
    inst._remove_item("tmr1")
    assert_false("tmr1" in inst.insts)
    assert_false("tmr1" in inst.paths)
