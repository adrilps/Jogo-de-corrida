extends Area2D


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
	
# Função que debilita o jogador caso entre na área desse objeto
func _on_area_entered(area: Area2D)-> void:
	if(area.get_owner().is_in_group("player")):
		area.get_owner().apply_debuff()
