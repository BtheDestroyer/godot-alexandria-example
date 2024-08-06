extends Control

func _ready() -> void:
  if PlayerData.current.pets == null:
    PlayerData.current.pets = await AlexandriaNetClient.get_remote_entry("pet_list", PlayerData.current.username)
    if PlayerData.current.pets == null or PlayerData.current.pets.pets.size() == 0:
      get_tree().change_scene_to_file("res://pet_adoption.tscn")
