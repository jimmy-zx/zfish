extends Node2D

## Custom entity
##
## Hitbox will be automatically detected by the provided image.

var dragging: bool = false

signal hook(exception)

func set_data(data: Dictionary):
    $Builder/Path.text = data["path"]
    _load_path(data["path"])
    $Builder/Scale.value = data["scale"]
    _set_scale(data["scale"])
    $Builder/FlipX.button_pressed = data["flip_x"]
    $Builder/Move.button_pressed = data["move"]
    
func get_data():
    return {
        "path": $Builder/Path.text,
        "scale": $Builder/Scale.value,
        "move": $Builder/Move.button_pressed,
        "flip_x": $Builder/FlipX.button_pressed,
    }
    

func _load_path(path: String):
    var image = Image.new()
    var err = image.load(path)
    if err != OK:
        OS.alert("Failed to load texture")
        return
    var texture = ImageTexture.create_from_image(image)
    $Obj/Sprite2D.texture = texture
    $Obj/CollisionShape2D.shape.size = Vector2(image.get_width(), image.get_height())
    

func _set_scale(new_scale):
    $Obj.scale.x = new_scale
    $Obj.scale.y = new_scale


func _on_browse_pressed():
    $Builder/BrowsePath.visible = true


func _on_browse_path_file_selected(path):
    $Builder/Path.text = path
    _load_path(path)
    

func _process(_delta):
    if dragging:
        _set_scale($Builder/Scale.value)


func _on_scale_drag_started():
    dragging = true


func _on_scale_drag_ended(value_changed):
    dragging = false


func _on_flip_x_toggled(button_pressed):
    $Obj.flip_x = button_pressed


func _on_move_toggled(button_pressed):
    $Obj.move_enable = button_pressed


func _on_builder_close_requested():
    $Builder.hide()
