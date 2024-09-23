extends Control

const TEST = "res://test.tscn"

var mpc: MultiPlayCore

@onready var label = $Panel/VBoxContainer/HBoxContainer/Label
@onready var start = $Panel/VBoxContainer/start

func startup():
	mpc = get_parent().mpc
	multiplayer.peer_connected.connect(update_playercount)
	multiplayer.peer_disconnected.connect(update_playercount)
	start.disabled = !mpc.local_player.player_id == 1
	update_playercount(null)

func update_playercount(_peer):
	label.text = "Players: " + str(mpc.player_count) + "/4"

func _on_start_button_down():
	start_game()

func start_game():
	mpc.load_scene(TEST)
	mpc.players.respawn_node_all()
	hide_lobby.rpc()

@rpc("authority", "call_local")
func hide_lobby():
	self.hide()
