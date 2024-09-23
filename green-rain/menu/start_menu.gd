extends Node

@export var mpc: MultiPlayCore
@onready var adress = $StartMenu/Panel/VBoxContainer/HBoxContainer/ADRESS
@onready var start_menu = $StartMenu
@onready var lobby = $lobby

func _on_host_button_down():
	mpc.start_online_host(true)
	start_menu.hide()
	lobby.show()
	lobby.startup()

func _on_join_button_down():
	var url = adress.text
	if url == "":
		url = adress.placeholder_text
	mpc.start_online_join(url)
	start_menu.hide()
	lobby.show()
