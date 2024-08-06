class_name PetAdoption extends Control

@onready var selection: Control = $Selection
@onready var personalize: Control = $Personalize
@onready var personalize_texture: TextureRect = $Personalize/MarginContainer/HBoxContainer/TextureRect
@onready var personalize_name: LineEdit = $Personalize/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit
var selected_type: int

func select(type: int) -> void:
  selected_type = type
  selection.hide()
  personalize.show()
  personalize_texture.texture = load("res://pet_images/%d.png" % [selected_type])

func adopt(pet_name: String, type: int) -> void:
  var pet_list: PetList = await AlexandriaNetClient.get_remote_entry("pet_list", PlayerData.current.username)
  if pet_list == null:
    match await AlexandriaNetClient.create_remote_entry("pet_list", PlayerData.current.username):
      OK:
        pass
      var error:
        OS.alert("Failed to create pet list entry: " + error_string(error))
        return
    pet_list = await AlexandriaNetClient.get_remote_entry("pet_list", PlayerData.current.username)
    if pet_list == null:
      OS.alert("Failed to get your pet list!")
      return
  var pet_entry := PlayerData.current.username + "." + pet_name
  match await AlexandriaNetClient.create_remote_entry("pet", pet_entry):
    OK:
      pass
    var error:
      OS.alert("Failed to create pet entry: " + error_string(error))
      return
  match await AlexandriaNetClient.update_remote_entry("pet", pet_entry, Pet.new(pet_name, type)):
    OK:
      pass
    var error:
      OS.alert("Failed to update pet entry: " + error_string(error))
      return
  pet_list.pets.append(pet_entry)
  match await AlexandriaNetClient.update_remote_entry("pet_list", PlayerData.current.username, pet_list):
    OK:
      pass
    var error:
      OS.alert("Failed to update pet list entry: " + error_string(error))
      return
  get_tree().change_scene_to_file("res://pet_list.tscn")

func _on_personalize_adopt_pressed() -> void:
  var pet_name := personalize_name.text.strip_edges()
  if pet_name.length() == 0:
    return;
  adopt(pet_name, selected_type)
