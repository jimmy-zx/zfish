extends Node2D

signal hook(exception)


func set_data(data: Dictionary):
    _load_path(data["path"])
    $Texture.position.x = data["position"]["x"]
    $Texture.position.y = data["position"]["y"]
    $Builder/Scale.value = data["scale"]
    $Texture.scale.x = $Builder/Scale.value
    $Texture.scale.y = $Builder/Scale.value


func get_data():
    return {
        "path": $Builder/Path.text,
        "position": {
            "x": $Texture.position.x,
            "y": $Texture.position.y,
        },
        "scale": $Builder/Scale.value,
    }
    
func _load_path(path: String):
    $Builder/Path.text = path
    var image = Image.new()
    var err = image.load(path)
    if err != OK:
        OS.alert("Failed to load texture: ")
        return
    var texture = ImageTexture.create_from_image(image)
    $Texture.set_texture(texture)

func _on_browse_pressed():
    $Builder/BrowsePath.visible = true


func _on_browse_path_file_selected(path):
    _load_path(path)

var dragging: bool = false

func _process(_delta):
    if dragging:
        $Texture.scale.x = $Builder/Scale.value
        $Texture.scale.y = $Builder/Scale.value
        


func _on_scale_drag_ended(value_changed):
    dragging = false


func _on_scale_drag_started():
    dragging = true


func _on_builder_close_requested():
    $Builder.hide()
