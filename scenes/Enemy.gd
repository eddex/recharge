extends KinematicBody2D


var health = 1

export var bullet_scene: PackedScene

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection

var spin = true

signal enemy_fired_bullet(bullet, pos, direction)

func _ready():
    $AI.connect("state_changed", self, "on_state_changed")
    $AI.initialize(self)


func _process(delta):
    if spin:
        rotation += 0.01


func on_state_changed(state):
    spin = false

func handle_hit():
    health -= 1
    print("enemy hit. health = " + str(health))
    if health <= 0:
        queue_free()


func shoot():
    print("enemy shoot()")
    var bullet_instance = bullet_scene.instance()
    var direction = gun_direction.global_position - end_of_gun.global_position
    emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, direction.normalized())
