extends Node2D

## Duplicate Builder
##
## A builder to create multiple (identical) instances of a module.
##
## Note 1: This module includes multiple instances of the builder of a module.
##  which might result in performance penalty.


signal hook(exception)

## Path to the target module
var path: String

## Target module
var cls: PackedScene = null

## The singleton to be duplicated
var build_inst: Node2D = null


func get_data() -> Dictionary:
    return {
        "path": path,
        "data": build_inst.get_data(),
        "count": int($Builder/Count.text),
    }


func set_data(new_data: Dictionary):
    $Builder/Count.text = str(new_data["count"])
    _load_path(new_data["path"])
    build_inst.set_data(new_data["data"])
    $Builder/View.button_pressed = true  # will trigger _on_view_toggled()
        

func _ready():
    _view()
        

func _load_path(new_path: String):
    path = new_path
    cls = load(path)
    build_inst = cls.instantiate()
    build_inst.get_node("Builder").visible = true
    

func _view():
    for child in $Node2D.get_children():
        if child == build_inst:
            $Node2D.remove_child(build_inst)
            continue
        child.queue_free()
    for count in range(int($Builder/Count.text)):
        var inst = cls.instantiate()
        inst.set_data(build_inst.get_data())
        $Node2D.add_child(inst)
        

func _handle_child_hook(exception):
    hook.emit(exception)


func _on_builder_toggled(button_pressed):
    if button_pressed:
        $Builder/View.button_pressed = false
        $Node2D.add_child(build_inst)
    else:
        $Node2D.remove_child(build_inst)


func _on_view_toggled(button_pressed):
    if button_pressed:
        _view()
    else:
        for child in $Node2D.get_children():
            if child == build_inst:
                $Node2D.remove_child(build_inst)
                continue
            child.queue_free()


func _on_res_browser_hook(exception):
    _load_path($Builder/ResBrowser.get_data())


func _on_builder_close_requested():
    $Builder.hide()
