extends CharacterBody2D

var mouseOn = false
var selected = false
var mouse_pos_offset = Vector2(0, 0)

var direction = 0

var move_enable = true

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
    velocity = Vector2(0, target.length()).rotated((vangle_restricted + vangle_offset) * -vangle_sign)

# Called when the node enters the scene tree for the first time.
func _ready():
    position = Vector2(randi_range(0, get_viewport_rect().size.x), randi_range(0, get_viewport_rect().size.y))
    change_velocity(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if selected:
        position = get_viewport().get_mouse_position() - mouse_pos_offset
    # $FishTexture.flip_h = velocity.x < 0
    $RealisticFishTexture.flip_h = velocity.x > 0
    
func _physics_process(delta):
    if !move_enable:
        return
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        change_velocity(velocity.bounce(collision_info.get_normal()))

func _input(event):
    if event is InputEventMouseButton:
        if event.get_button_index() == MOUSE_BUTTON_LEFT:
            selected = event.pressed and mouseOn
            mouse_pos_offset = event.position - position

func _on_mouse_entered():
    mouseOn = true
    $SelectionBox.visible = true


func _on_mouse_exited():
    mouseOn = false
    $SelectionBox.visible = false
