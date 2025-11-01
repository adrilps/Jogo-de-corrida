extends Node2D

func _on_grass_area_entered(area: Area2D) -> void:
	if(area.get_owner().is_in_group("player")):
		area.get_owner().set_friction(3)
		area.get_owner().set_traction(2)
		print("grass!")
