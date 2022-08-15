extends Control


export var game_scene: PackedScene
var game: Node

func _on_StartButton_pressed():
    $StartButton.disabled = true
    var game_instance = game_scene.instance()
    add_child(game_instance)
    game = game_instance
    game.connect("won", self, "on_won")
    game_instance.player.connect("game_over", self, "on_game_over")
    
func on_game_over():
    print("game over")
    remove_child(game)
    var new_dialog = Dialogic.start("lose")
    add_child(new_dialog)
    $StartButton.disabled = false

func on_won():
    var new_dialog = Dialogic.start("win")
    add_child(new_dialog)
    $StartButton.disabled = false
