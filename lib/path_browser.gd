extends Node2D

## hook signal
##  path: when a new path is selected
signal hook(exception)

func set_data(data: String):
    $Builder/Path.text = data
    

func get_data():
    return $Builder/Path.text
    

func _on_browse_pressed():
    $Builder/FileDialog.visible = true


func _on_file_dialog_file_selected(path):
    $Builder/Path.text = path
    hook.emit({"event": "path"})
    
    
var paths: Dictionary = {}
    

func _ready():
    var tree = get_node("Builder/Tree")
    var items = tree.create_item()
    tree.hide_root = true
    
    var fishs = tree.create_item(items)
    fishs.set_text(0, "Fish")
    var zebra_fish = tree.create_item(fishs)
    zebra_fish.set_text(0, "Zebra Fish")
    paths[zebra_fish] = "res://modules/zebra_fish/zebra_fish.tscn"
    var indian_leaf_fish = tree.create_item(fishs)
    indian_leaf_fish.set_text(0, "Indian Leaf Fish")
    paths[indian_leaf_fish] = "res://modules/indian_leaf_fish/indian_leaf_fish.tscn"
    var shrimp = tree.create_item(fishs)
    shrimp.set_text(0, "Shrimp")
    paths[shrimp] = "res://modules/shrimp/shrimp.tscn"
    
    var envs = tree.create_item(items)
    envs.set_text(0, "Environments")
    var env = tree.create_item(envs)
    env.set_text(0, "Walls and Background")
    paths[env] = "res://modules/env/env.tscn"
    
    var utils = tree.create_item(items)
    utils.set_text(0, "Utilities")
    var timer = tree.create_item(utils)
    timer.set_text(0, "Timer")
    timer.set_tooltip_text(0, "A trigger that jumps into the next stage after a certain amount of time.")
    paths[timer] = "res://modules/timer/timer.tscn"
    var dup = tree.create_item(utils)
    dup.set_text(0, "Duplicate")
    dup.set_tooltip_text(0, "Created multiple instances of the same object with the same configure.")
    paths[dup] = "res://modules/dup_builder/dup_builder.tscn"
    var pic = tree.create_item(utils)
    pic.set_text(0, "Custom Picture")
    pic.set_tooltip_text(0, "Import a custom stationary picture to the scene.")
    paths[pic] = "res://modules/image/image.tscn"
    var entity = tree.create_item(utils)
    entity.set_text(0, "Custom Entity")
    entity.set_tooltip_text(0, "Create a entity using a custom picture.")
    paths[entity] = "res://modules/entity/entity.tscn"


func _on_tree_item_selected():
    var key = $Builder/Tree.get_selected()
    if paths.has(key):
        $Builder/Path.text = paths.get(key)
        hook.emit({"event": "path"})
    
