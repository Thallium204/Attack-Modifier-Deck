extends Control

var texCard_tscn = preload("res://texCard.tscn")

export var activeColor: Color

var baseCards = [
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-01.png","rolling":false,"types":[],"value":+0},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-02.png","rolling":false,"types":[],"value":+0},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-03.png","rolling":false,"types":[],"value":+0},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-04.png","rolling":false,"types":[],"value":+0},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-05.png","rolling":false,"types":[],"value":+0},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-06.png","rolling":false,"types":[],"value":+0},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-07.png","rolling":false,"types":[],"value":+1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-08.png","rolling":false,"types":[],"value":+1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-09.png","rolling":false,"types":[],"value":+1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-10.png","rolling":false,"types":[],"value":+1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-11.png","rolling":false,"types":[],"value":+1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-12.png","rolling":false,"types":[],"value":-1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-13.png","rolling":false,"types":[],"value":-1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-14.png","rolling":false,"types":[],"value":-1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-15.png","rolling":false,"types":[],"value":-1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-16.png","rolling":false,"types":[],"value":-1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-17.png","rolling":false,"types":[],"value":-2},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-18.png","rolling":false,"types":[],"value":+2},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-19.png","rolling":false,"types":[],"value":false},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player/am-p-20.png","rolling":false,"types":[],"value":true},
]

var addCards = [
	{"elements":[],"imagePath":"res://attack-modifiers/base/player-mod/am-pm-01.png","rolling":false,"types":[],"value":true},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player-mod/am-pm-02.png","rolling":false,"types":[],"value":true},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player-mod/am-pm-11.png","rolling":false,"types":[],"value":-1},
	{"elements":[],"imagePath":"res://attack-modifiers/base/player-mod/am-pm-12.png","rolling":false,"types":[],"value":-1},
]

var classCards = {}

var activeClass = ""

func _ready():
	
	loadMetaData()
	
	for className in classCards:
		
		var btnClass = Button.new()
		btnClass.name = className
		btnClass.text = className
		btnClass.size_flags_horizontal = SIZE_EXPAND_FILL
		btnClass.connect("button_down",self,"makeClassActive",[className])
		$hboxClasses.add_child(btnClass)


func makeClassActive(className):
	
	activeClass = className
	
	updateButtonUI()
	_on_btnReset_pressed()

func updateButtonUI():
	
	for btnClass in $hboxClasses.get_children():
		
		if btnClass.name == activeClass:
			btnClass.modulate = activeColor
		else:
			btnClass.modulate = Color.white

func generateBaseDeck():
	
	# Delete all base cards
	get_tree().call_group("deckCard","queue_free")
	
	for cardData in baseCards:
		
		var texCard = texCard_tscn.instance()
		texCard.configure("base",cardData)
		texCard.get_node("btnCard").connect("pressed",self,"cardPressed",[texCard,cardData,"base"])
		$contDeck/gridDeck.add_child(texCard)

func generateClassDeck():
	
	# Delete all base cards
	get_tree().call_group("classCard","queue_free")
	
	# Check we have a class selected
	if activeClass == "" or activeClass == "base":
		return
	
	for cardData in classCards[activeClass].cards + addCards:
		
		var texCard = texCard_tscn.instance()
		texCard.configure("class",cardData)
		texCard.get_node("btnCard").connect("pressed",self,"cardPressed",[texCard,cardData,"class"])
		$contClass/gridClass.add_child(texCard)
	
	

func cardPressed(btnCard,cardData,type):
	
	if type == "base":
		
		btnCard.queue_free()
		
	elif type == "class":
		
		var new_btnCard = texCard_tscn.instance()
		new_btnCard.configure("class",cardData)
		new_btnCard.get_node("btnCard").connect("pressed",self,"cardPressed",[new_btnCard,cardData,"class"])
		if btnCard in get_tree().get_nodes_in_group("deckCard"):
			new_btnCard.add_to_group("classCard")
			$contClass/gridClass.add_child(new_btnCard)
		elif btnCard in get_tree().get_nodes_in_group("classCard"):
			new_btnCard.add_to_group("deckCard")
			$contDeck/gridDeck.add_child(new_btnCard)
		btnCard.queue_free()

func calculateAverage():
	
	var cards = get_tree().get_nodes_in_group("deckCard")
	var average = {"D":0.0,"V":0.0}
	for texCard in cards:
		if texCard.value is bool:
			if texCard.value == true:
				average.D += 2
		else:
			average.D += 1
			average.V += texCard.value
	
	var damageMult = stepify(average.D/cards.size(),0.01)
	var damageMod = stepify(average.V/cards.size(),0.01)
	$hboxControl/contAverage/labelAverage.text = "Av: " + str(damageMult) + "D + " + str(damageMod)

func _on_btnReset_pressed():
	generateBaseDeck()
	generateClassDeck()

func _on_btnFormat_pressed():
	var _ERROR_CODE = get_tree().change_scene("res://Format.tscn")

func _on_btnCalculate_pressed():
	calculateAverage()

func loadMetaData():
	var saveFile = File.new()
	if not saveFile.file_exists("user://card_data.save"):
		return
	saveFile.open("user://card_data.save", File.READ)
	classCards = parse_json(saveFile.get_line())
	saveFile.close()

