extends Control

## A helper to build a list (int -> object)
##
## List is NOT a module, but behaves similarly.
## Usually it could be a child of Builder node of a module.

## hook
##
## Possible events:
##  load: when set_data() is called
##  new(id): when the New button is pressed
signal hook(exception)


func set_data(data: Array):
    for inst in insts:
        inst.queue_free()
    insts = []
    paths = []
    $Builder/Items.clear()
    for id in range(data.size()):
        $Builder/Items.add_item(str(id))
        var inst = _add_item(data[id]["path"])
        inst.set_data(data[id]["data"])
    hook.emit({"source": "array", "event": "load"})


func get_data() -> Array:
    var data: Array = []
    for id in range(insts.size()):
        data.append({
            "path": paths[id],
            "data": insts[id].get_data(),
        })
    return data


var insts: Array = []
var paths: Array = []


func _add_item(path):
    paths.append(path)
    var packed_scene = load(path)
    var inst = packed_scene.instantiate()
    insts.append(inst)
    return inst


func _remove_item(id):
    paths.remove_at(id)
    insts[id].queue_free()
    insts.remove_at(id)


func _on_new_pressed():
    var id = insts.size()
    $Builder/Items.add_item(str(id))
    $Builder/Items.select($Builder/Items.item_count - 1)
    _add_item($Builder/Path.text)
    hook.emit({"event": "new", "id": id})


func _on_delete_pressed():
    var items = $Builder/Items.get_selected_items()
    for item in items:  # TODO
        var id = int($Builder/Items.get_item_text(item))
        $Builder/Items.remove_item(item)
        _remove_item(id)
    

func _on_browse_pressed():
    $Builder/BrowseDialog.visible = true


func _on_browse_dialog_file_selected(path):
    $Builder/Path.text = path


func _on_builder_close_requested():
    $Builder.hide()
