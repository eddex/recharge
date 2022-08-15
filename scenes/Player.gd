extends KinematicBody2D

export var speed: int = 20000
export var bullet_scene: PackedScene

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var camera_transform = $CameraTransform

var health = 3

signal player_fired_bullet(bullet, pos, direction)
signal game_over()
signal health_changed(health)


func _process(delta):
    var direction: Vector2 = Vector2.ZERO
    if Input.is_action_pressed("move_up"):
        direction.y = -1
    if Input.is_action_pressed("move_down"):
        direction.y = 1
    if Input.is_action_pressed("move_left"):
        direction.x = -1
    if Input.is_action_pressed("move_right"):
        direction.x = 1
    direction = direction.normalized()
    move_and_slide(direction * speed * delta)
    look_at(get_global_mouse_position())
        

func _unhandled_input(event):
    if event.is_action_released("shoot"):
        print("shoot")
        shoot()


func shoot():
    var bullet_instance = bullet_scene.instance()
    var direction = gun_direction.global_position - end_of_gun.global_position
    emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction.normalized())
    

func handle_hit():
    health -= 1
    print("player hit. health = " + str(health))
    if health <= 0:
        print("rip")
        emit_signal("game_over")
    emit_signal("health_changed", health)
    

func set_camera_transform(camera_path: NodePath):
    camera_transform.remote_path = camera_path
