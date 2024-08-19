class_name Pet extends Alexandria_Entry

@export var name: String
@export var type: int
@export var adopted: float = Time.get_unix_time_from_system()
@export var last_fed: float = Time.get_unix_time_from_system()

func _init(name_: String = "", type_: int = 0):
  name = name_
  type = type_
