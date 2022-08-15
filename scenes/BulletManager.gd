extends Node2D


func handle_bullet_fired(bullet, pos, direction):
    print("handle_bullet_fired")
    add_child(bullet)
    bullet.global_position = pos
    bullet.set_direction(direction)
