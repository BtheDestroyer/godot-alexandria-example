extends Control

@onready var pet_buttons: VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/PetButtons
@onready var pet_info: VBoxContainer = $HBoxContainer/PanelContainer2/MarginContainer/PetInfo
@onready var pet_name: Label = $HBoxContainer/PanelContainer2/MarginContainer/PetInfo/PetName
@onready var pet_image: TextureRect = $HBoxContainer/PanelContainer2/MarginContainer/PetInfo/PetImage
@onready var pet_adoption_date: Label = $HBoxContainer/PanelContainer2/MarginContainer/PetInfo/HBoxContainer/PetAdoptionDate

var selected: Pet

func _ready() -> void:
  await PlayerData.current.update_pet_list()
  if PlayerData.current.pet_list == null or PlayerData.current.pet_list.pets.size() == 0:
    get_tree().change_scene_to_file("res://pet_adoption.tscn")
    return
  for pet: Pet in PlayerData.current.pet_list.pets:
    if not pet:
      continue
    var button := Button.new()
    button.text = pet.name
    button.pressed.connect(select.bind(pet))
    button.add_theme_font_size_override("font_size", 24)
    pet_buttons.add_child(button)
  var pet_list := PlayerData.current.pet_list
  select(PlayerData.current.pet_list.pets.front())

func select(pet: Pet):
  selected = pet
  pet_info.show()
  pet_name.text = pet.name
  pet_image.texture = load("res://pet_images/%d.png" % [pet.type])
  pet_adoption_date.text = Time.get_datetime_string_from_unix_time(pet.adopted).replace("T", " at ")

func _on_adopt_pressed() -> void:
  get_tree().change_scene_to_file("res://pet_adoption.tscn")

func _on_release_pressed() -> void:
  var entry_name := PlayerData.current.username + "." + selected.name
  match await AlexandriaNetClient.delete_remote_entry("pet", entry_name):
    OK:
      pass
    var error:
      OS.alert("Failed to release pet: " + error_string(error))
      return
  var index := PlayerData.current.pet_list.pets.find(entry_name)
  PlayerData.current.pet_list.pets.remove_at(index)
  match await AlexandriaNetClient.update_remote_entry("pet_list", PlayerData.current.username, PlayerData.current.pet_list):
    OK:
      pass
    var error:
      OS.alert("Failed to update pet list: " + error_string(error))
      return
  PlayerData.current.pet_list.pets.remove_at(index)
  pet_buttons.get_child(index).queue_free()
  if PlayerData.current.pet_list.pets.size() == 0:
    get_tree().change_scene_to_file("res://pet_adoption.tscn")
  else:
    select(PlayerData.current.pet_list.pets.front())
