extends Node3D

@onready var flash_screen = $"../Canvas/flash_screen"
var flash_tween: Tween


#region player_events_by_grenades
func flash_player()->void:
	flash_screen.modulate.a = 1
	if flash_tween:
		flash_tween.kill()
		
	await get_tree().create_timer(2.5).timeout
	
	flash_tween = create_tween()
	flash_tween.tween_property(flash_screen, "modulate:a", 0, 4)
#endregion
