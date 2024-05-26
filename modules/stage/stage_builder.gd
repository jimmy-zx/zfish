extends Node2D

## A list of modules, to be displayed at different stages

signal hook(exception)

func set_data(data: Array):
    cur_stage = -1
    $Builder/List.set_data(data)
    

func get_data() -> Array:
    return $Builder/List.get_data()


var cur_stage = -1

func _ready():
    $Builder/List.get_node("Builder/Path").text = "res://modules/stage/scene_builder.tscn"


func _on_list_hook(exception):
    match exception["event"]:
        "new":
            var id = exception["id"]
            var inst = $Builder/List.insts[id]
            inst.hook.connect(func(exception): handle_child_hook(id, exception))
            $Builder/Show.button_pressed = true
            show_current_builder()
        "load":
            for id in range($Builder/List.insts.size()):
                var inst = $Builder/List.insts[id]
                inst.hook.connect(func(exception): handle_child_hook(id, exception))
        "update":
            hook.emit({"event": "update"})
        _:
            printerr("ERROR: unhandled signal from List: " + str(exception))

            
func handle_child_hook(id, exception):
    print("stage::child_hook {} {}".format([id, exception], "{}"))
    match exception["event"]:
        "timer":
            if id != cur_stage or cur_stage + 1 == $Builder/List.insts.size():
                cur_stage = -1
                return
            if id != -1:
                $Stage.remove_child($Builder/List.insts[id])
            $Stage.add_child($Builder/List.insts[id + 1])
            cur_stage += 1
            $Builder/List/Builder/Items.select(cur_stage)


func _on_builder_close_requested():
    $Builder.hide()


func _on_show_toggled(button_pressed):
    for child in $Stage.get_children():
        $Stage.remove_child(child)
    for id in $Builder/List/Builder/Items.get_selected_items():
        if button_pressed:
            $Stage.add_child($Builder/List.insts[id])


func _on_run_pressed():
    run()
    
    
func run():
    for child in $Stage.get_children():
        $Stage.remove_child(child)
    for inst in $Builder/List.insts:
        if inst.has_method("do_request_ready"):
            inst.do_request_ready()
        else:
            inst.request_ready()
    cur_stage = -1
    handle_child_hook(-1, {"event": "timer"})


func _on_builder_enable_pressed():
    show_current_builder()


func show_current_builder():
    for id in $Builder/List/Builder/Items.get_selected_items():
        $Builder/List.insts[id].get_node("Builder").visible = true
        $Stage.add_child($Builder/List.insts[id])
