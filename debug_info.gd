class_name DebugInfo extends Control

@onready var show_hide_button: Button = $"../Show_Hide"
@onready var output: RichTextLabel = $VBoxContainer/ScrollContainer/RichTextLabel
@onready var input: LineEdit = $VBoxContainer/Command
var shown := false
static var current: DebugInfo:
  get:
    if not current:
      return null
    return current

func _ready() -> void:
  if not current:
    current = self

func print_va(things: Array) -> void:
  self.print("".join(things.map(to_string)))

func print(message: String) -> void:
  output.append_text(message + "\n")
  print("[Debug]: ", message)

func _on_show_hide_pressed() -> void:
  shown = !shown
  show_hide_button.text = "v" if shown else "^"
  var tween := create_tween()
  tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
  tween.tween_property(self, "custom_minimum_size:y", 400 if shown else 0, 0.5)
  if shown:
    input.grab_focus()
  else:
    input.release_focus()

func _unhandled_key_input(event: InputEvent) -> void:
  if shown and(event as InputEventKey).get_keycode_with_modifiers() == KEY_ESCAPE:
    _on_show_hide_pressed()
    accept_event()

func _on_command_text_submitted(new_text: String) -> void:
  var command_with_args := new_text.strip_edges().split(" ")
  if command_with_args.size() == 0:
    return
  var command := command_with_args[0].to_lower()
  command_with_args.remove_at(0)
  handle_command(command, command_with_args)
  input.text = ""

var command_handlers := {
  "list_commands": (func(_arguments: PackedStringArray) -> void:
    self.print("Available commands:\n\t" + "\n\t".join(command_handlers.keys()))
    ),
  "current_user": (func(arguments: PackedStringArray) -> void:
    self.print("Username: \"" + PlayerData.current.username + "\"")
    ),
}
func handle_command(command: String, arguments: PackedStringArray):
  if command_handlers.has(command):
    command_handlers[command].call(arguments)
  else:
    self.print("Error: No such command \"" + command + "\"")
