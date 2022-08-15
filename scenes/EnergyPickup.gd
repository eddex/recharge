extends Node2D

var picked_up = false

func pick_up():
    picked_up = true
    get_parent().get_node("SpriteEmpty").visible = true
