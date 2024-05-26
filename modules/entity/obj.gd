extends CharacterBody2D

var flip_x: bool = false
var move_enable: bool = false
const max_angle: float = PI / 4

func _ready():
    position = Vector2(randi_range(0, get_viewport_rect().size.x), randi_range(0, get_viewport_rect().size.y))
    velocity = Vector2(randi_range(100, 150) * [1, -1][randi() % 2], 0)
    change_velocity(velocity)

func _physics_process(delta):
    if !move_enable:
        return
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        velocity = velocity.bounce(collision_info.get_normal())

func _process(delta):
    $Sprite2D.flip_h = flip_x if velocity.x > 0 else !flip_x



func change_velocity(target: Vector2):
    # Current policy:
    #  given `target`: the target velocity the fish ought to be
    #  normalize its horizontal angle to be within +/- max_angle / 2
    #   and add a random offset +/- max_angle / 2
    var vangle = target.angle_to(Vector2(0, 1))
    var vangle_restricted = clamp(abs(vangle), PI / 2 - max_angle / 2, PI / 2 + max_angle / 2)
    var vangle_offset = randf_range(-max_angle / 2, max_angle / 2)
    var vangle_sign = sign(vangle)
    if vangle_sign == 0:
        vangle_sign = 1
    velocity = Vector2(0, target.length()).rotated((vangle_restricted + vangle_offset) * -vangle_sign)
