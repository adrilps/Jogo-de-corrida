class_name State extends Node

@onready var player: Player = get_parent().get_parent() as Player

func enter():
	pass

func exit():
	pass

func process_state(_delta: float) -> String:
	return ""
