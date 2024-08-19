extends PanelContainer

@onready var username: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/Username
@onready var password: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer2/Password

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventKey and event.get_keycode_with_modifiers() == KEY_ENTER:
    attempt_log_in()
    accept_event()

func _on_log_in_pressed() -> void:
  attempt_log_in()

func _on_create_account_pressed() -> void:
  attempt_create_account()

func attempt_log_in() -> void:
  if username.text.strip_edges().length() == 0:
    return
  if password.text.length() == 0:
    return
  match await AlexandriaNetClient.login_remote_user(username.text.strip_edges(), password.text):
    OK:
      PlayerData.current.username = username.text.strip_edges()
      get_tree().change_scene_to_file("res://pet_list.tscn")
    var error:
      OS.alert("Failed to log in! Error: " + error_string(error), "Log In Error")

func attempt_create_account() -> void:
  match await AlexandriaNetClient.create_remote_user(username.text.strip_edges(), password.text):
    OK:
      OS.alert("Created account successfully! Log in to continue.", "Created Account")
    var error:
      OS.alert("Failed to create account! Error: " + error_string(error), "Account Create Error")
