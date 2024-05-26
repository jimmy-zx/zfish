extends Control

## A helper to build a map (key -> object)
##
## Map is NOT a module, but behaves similarly.
## Usually it could be a child of Builder node of a module.

## hook
##
## Possible events:
##  load: when set_data() is called
##  new(id): when the New button is pressed
signal hook(exception)


func set_data(data: Dictionary):
    for id in data:
        $Builder/Items.add_item(id)
        var inst = _add_item(id, data[id]["path"])
        inst.set_data(data[id]["data"])
    hook.emit({"source": "map", "event": "load"})


func get_data() -> Dictionary:
    var data: Dictionary = {}
    for id in insts:
        data[id] = {
            "path": paths[id],
            "data": insts[id].get_data(),
        }
    return data


var insts: Dictionary = {}
var paths: Dictionary = {}


func _add_item(id, path):
    paths[id] = path
    var packed_scene = load(path)
    var inst = packed_scene.instantiate()
    insts[id] = inst
    return inst


func _remove_item(id):
    paths.erase(id)
    insts[id].queue_free()
    insts.erase(id)


func _on_new_pressed():
    var id = $Builder/Name.text
    if id == "" or id in insts:
        return
    $Builder/Items.add_item(id)
    $Builder/Items.select($Builder/Items.item_count - 1)
    _add_item(id, $Builder/Path.text)
    hook.emit({"event": "new", "id": id})


func _on_delete_pressed():
    var items = $Builder/Items.get_selected_items()
    for item in items:  # TODO
        var id = $Builder/Items.get_item_text(item)
        $Builder/Items.remove_item(item)
        _remove_item(id)


func _on_browse_dialog_file_selected(path):
    $Builder/Path.text = path
