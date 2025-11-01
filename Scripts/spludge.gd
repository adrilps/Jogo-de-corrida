extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_owner().is_in_group("player")):
		area.get_owner().apply_debuff()
