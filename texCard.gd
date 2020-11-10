extends TextureRect

var value
var types = []
var rolling = false

func configure(cardType,cardData):
	
	name = cardType
	texture = load(cardData.imagePath)
	if cardType == "base":
		add_to_group("baseCard")
		add_to_group("deckCard")
	else:
		add_to_group("classCard")
	
	value = cardData.value
	types = cardData.types
	rolling = cardData.rolling
