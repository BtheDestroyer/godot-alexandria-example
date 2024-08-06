extends VBoxContainer

@export var pet_adoption: PetAdoption
@onready var texture_rect: TextureRect = $TextureRect
@onready var adopt_button: Button = $Adopt
@onready var type := randi_range(0, 4)

func _ready() -> void:
  texture_rect.texture = load("res://pet_images/%d.png" % [type])
  adopt_button.pressed.connect(pet_adoption.select.bind(type))
