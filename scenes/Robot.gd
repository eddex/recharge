extends KinematicBody2D


var player
var speed = 300
var go_to_pickup = false
var target
var boss_mode = false
var boss_dialogue = true
var health = 15

export var bullet_scene: PackedScene

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection

signal enemy_fired_bullet(bullet, pos, direction)
signal boss_mode_activated()
signal dead()


func _ready():
    $AI.connect("energy_pickup_detected", self, "on_energy_pickup_detected")
    $AI.connect("evil_mode_entered", self, "on_evil_mode_entered")
    $AI.actor = self


func _process(delta):	
    if player != null:
        if go_to_pickup:
            look_at(target.global_position)
            if has_reached_target():
                go_to_pickup = false
            else:
                var velocity = global_position.direction_to(target.global_position) * speed
                move_and_slide(velocity)
        else:
            look_at(player.global_position)
            if !has_reached_player() and !boss_mode:
                var velocity = global_position.direction_to(player.global_position) * speed
                move_and_slide(velocity)


func has_reached_player() -> bool:
    var distance = global_position.distance_to(player.global_position)
    return distance < 100
    

func has_reached_target() -> bool:
    var distance = global_position.distance_to(target.global_position)
    return distance < 50


func on_energy_pickup_detected(energy_pickup):
    go_to_pickup = true
    target = energy_pickup


func on_evil_mode_entered():
    $SpriteEvil.visible = true
    boss_mode = true
    emit_signal("boss_mode_activated")


func shoot():
    if boss_dialogue:
        return
    print("enemy shoot()")
    var bullet_instance = bullet_scene.instance()
    var direction = gun_direction.global_position - end_of_gun.global_position
    emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, direction.normalized())
    
func handle_hit():
    if boss_mode:
        health -= 1
    print("enemy hit. health = " + str(health))
    if health <= 0:
        emit_signal("dead")
        queue_free()
