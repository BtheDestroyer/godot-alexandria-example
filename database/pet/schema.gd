class_name Pet extends Alexandria_Entry

@export var name: String
@export var type: int
@export var adopted: int = Time.get_unix_time_from_system()
@export var last_fed: int = Time.get_unix_time_from_system()

func _init(name: String = "", type: int = 0):
  self.name = name
  self.type = type
