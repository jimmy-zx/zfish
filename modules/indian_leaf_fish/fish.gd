extends CharacterBody2D

var scale_inc = 0.1
var scale_max = 2
var speed = 200

func _ready():
    position = Vector2(randi_range(0, get_viewport_rect().size.x), randi_range(0, get_viewport_rect().size.y))
    velocity = Vector2(speed * [1, -1][randi() % 2], 0)
    change_velocity(velocity)

func _physics_process(delta):
    if scale.x < scale_max:
        scale.x += scale_inc * delta
        scale.y += scale_inc * delta
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        velocity = velocity.bounce(collision_info.get_normal())

func _process(delta):
    $FishTexture.flip_h = velocity.x > 0
    $FishTexture.rotation = [-PI / 12, PI / 12][int(velocity.x > 0)]

const max_angle = PI / 4

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
    velocity = Vector2(0, speed).rotated((vangle_restricted + vangle_offset) * -vangle_sign)
