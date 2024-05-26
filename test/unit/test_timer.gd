extends GutTest


var target = preload('res://modules/timer/timer.tscn')

func test_timer_load():
    var inst = target.instantiate()
    var data = {"time": 2.1, "exception_data": "hello"}
    inst.set_data(data)
    assert_eq(inst.get_node("Timer").wait_time, 2.1)
    assert_eq(inst.exception_data, "hello")
    assert_eq(inst.get_data(), data)



var test_timer_tick_callback_data = null

func test_timer_tick():
    var inst = target.instantiate()
    var data = {"time": 2.1, "exception_data": "hello"}
    inst.set_data(data)
    inst.hook.connect(func(data):
        print("signal received: ", data)
        test_timer_tick_callback_data = data)
    add_child(inst)
    assert_eq(test_timer_tick_callback_data, null)
    await wait_seconds(1)
    assert_eq(test_timer_tick_callback_data, null)
    await wait_seconds(2)
    assert_eq(test_timer_tick_callback_data, {
        "event": "timer",
        "message": "hello",
    })
    remove_child(inst)

