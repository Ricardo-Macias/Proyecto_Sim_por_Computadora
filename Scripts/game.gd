extends Node

var score = 0

func _ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	score += 1
	$ScoreLabel.text = "Puntaje: %s" % score
	if score >= 50:
		end_game()

func end_game():
	$Timer.stop()
	get_tree().change_scene_to_file("res://Scenes/end_game.tscn")
