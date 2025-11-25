class_name ButtonInstruction extends Node2D

enum Type
{
	LOGIN,
	LOGOUT
}

@onready var button_visualizer : ButtonVisualizer = $ButtonVisualizer
@onready var label_login : Label = $LabelLogin
@onready var label_logout : Label = $LabelLogout

func activate(btn: InputButton, tp:Type) -> void:
	set_type(tp)
	set_button(btn)

func set_type(tp:Type) -> void:
	label_login.set_visible(false)
	label_logout.set_visible(false)
	
	if tp == Type.LOGIN:
		label_login.show()
		label_login.set_text("BUTTON_NEW_PLAYER")
	
	if tp == Type.LOGOUT:
		label_logout.show()
		label_logout.set_text(get_logout_text())

func get_logout_text() -> String:
	if Global.input.removal_type == Global.input.ButtonRemovalType.NONE:
		return "BUTTON_LOGOUT_RELOAD"
	if Global.input.removal_type == Global.input.ButtonRemovalType.HOLD_COND:
		return "BUTTON_LOGOUT_MODE"
	
	var time : int = ceil(Global.input.get_removal_time() / 1000.0)
	return "{tr_1} ({time}s)".format({ tr_1 = tr("BUTTON_LOGOUT"), time = time })

func set_button(btn:InputButton) -> void:
	button_visualizer.set_visible(btn != null)
	if not btn: return
	button_visualizer.set_button(btn)
