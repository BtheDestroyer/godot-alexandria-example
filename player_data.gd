class_name PlayerData extends Resource

static var current := PlayerData.new()
var username: String
var pet_list: PetList

func update_pet_list() -> bool:
  pet_list = await AlexandriaNetClient.get_remote_entry("pet_list", username)
  if pet_list == null:
    match await AlexandriaNetClient.create_remote_entry("pet_list", username):
      OK:
        pass
      var error:
        OS.alert("Failed to create pet list entry: " + error_string(error))
        return false
    pet_list = await AlexandriaNetClient.get_remote_entry("pet_list", username)
    if pet_list == null:
      OS.alert("Failed to get your pet list!")
      return false
  print(pet_list.pets.map(func(pet: Pet) -> String: return pet.resource_path if pet else "{null}"))
  return true
