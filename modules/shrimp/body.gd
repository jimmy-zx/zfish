extends RigidBody2D

func _ready():
    position = Vector2(randi_range(0, get_viewport_rect().size.x), randi_range(0, get_viewport_rect().size.y))
    linear_velocity = Vector2(randi_range(100, 150), 0).rotated(randf_range(0, 2 * PI))
