extends Node2D

## A map of modules, to be displayed at the same time

signal hook(exception)

func set_data(data: Dictionary):
    $Builder/Map.set_data(data)
    

func get_data() -> Dictionary:
    return $Builder/Map.get_data()


func handle_child_hook(_id, exception):
    hook.emit(exception)


func _on_map_hook(exception):
    match exception["event"]:
        "new":   
            var id = exception["id"]
            var inst = $Builder/Map.insts[id]
            inst.hook.connect(func(exception): handle_child_hook(id, exception))
            inst.get_node("Builder").visible = $Builder/BuilderEnable.button_pressed
            $Scenes.add_child(inst)
        "load":
            for id in $Builder/Map.insts:
                var inst = $Builder/Map.insts[id]
                inst.hook.connect(func(exception): handle_child_hook(id, exception))
                $Scenes.add_child(inst)
        "update":
            hook.emit({"event": "update"})
        _:
            printerr("ERROR: unhandled signal from map: " + str(exception))
        

func _on_builder_close_requested():
    $Builder.hide()


func _on_builder_enable_toggled(button_pressed):
    for item in $Builder/Map/Builder/Items.get_selected_items():
        var id = $Builder/Map/Builder/Items.get_item_text(item)
        $Builder/Map.insts[id].get_node("Builder").visible = button_pressed


func _ready():
    $Builder/Map/Builder/Path.visible = false


func _on_res_browser_hook(_exception):
    $Builder/Map/Builder/Path.text = $Builder/ResBrowser/Builder/Path.text
    $Builder/Map/Builder/Name.text = $Builder/ResBrowser/Builder/Tree.get_selected().get_text(0)
    
func do_request_ready():
    request_ready()
    for id in $Builder/Map.insts:
        $Builder/Map.insts[id].request_ready()


func _on_builder_visibility_changed():
    for id in $Builder/Map.insts:
        $Builder/Map.insts[id].get_node("Builder").visible = $Builder.visible
