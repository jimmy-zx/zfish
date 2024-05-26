extends TextureRect

var mouse_on: bool = false
var selected: bool = false
var mouse_pos_offset: Vector2 = Vector2(0, 0)

func _process(_delta):
    if selected:
        position = get_viewport().get_mouse_position() - mouse_pos_offset
    

func _input(event):
    if event is InputEventMouseButton:
        if event.get_button_index() == MOUSE_BUTTON_LEFT:
            selected = event.pressed and mouse_on
            mouse_pos_offset = event.position - position


func _on_mouse_entered():
    mouse_on = true


func _on_mouse_exited():
    mouse_on = false
