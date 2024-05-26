extends Node2D


signal hook(exception)

func set_data(data: Dictionary):
    var color = Color.from_string(data["background"], Color.BLACK)
    $Background.color = color
    $Builder/Background.color = color
    
func get_data() -> Dictionary:
    return {
        "background": $Background.color.to_html()
    }


const width = 8


# Called when the node enters the scene tree for the first time.
func _ready():
    get_viewport().size_changed.connect(draw_walls)
    draw_walls()
    
func draw_walls():
    for wall in $Walls.get_children():
        wall.queue_free()
    var size = get_viewport_rect().size
    var left_wall = CollisionShape2D.new()
    left_wall.position = Vector2(width / 2, size.y / 2)
    left_wall.shape = RectangleShape2D.new()
    left_wall.shape.set_size(Vector2(width, size.y))
    $Walls.add_child(left_wall)
    var right_wall = CollisionShape2D.new()
    right_wall.position = Vector2(size.x - width / 2, size.y / 2)
    right_wall.shape = RectangleShape2D.new()
    right_wall.shape.set_size(Vector2(width, size.y))
    $Walls.add_child(right_wall)
    var top_wall = CollisionShape2D.new()
    top_wall.position = Vector2(size.x / 2, width / 2)
    top_wall.shape = RectangleShape2D.new()
    top_wall.shape.set_size(Vector2(size.x, width))
    $Walls.add_child(top_wall)
    var bot_wall = CollisionShape2D.new()
    bot_wall.position = Vector2(size.x / 2, size.y - width / 2)
    bot_wall.shape = RectangleShape2D.new()
    bot_wall.shape.set_size(Vector2(size.x, width))
    $Walls.add_child(bot_wall)
    $Background.size = size


func _on_background_color_changed(color):
    $Background.color = color


func _on_builder_close_requested():
    $Builder.hide()
