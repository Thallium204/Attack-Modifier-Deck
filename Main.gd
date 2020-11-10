extends Control

var texCard_tscn = preload("res://texCard.tscn")

export var activeColor: Color

var classes = {
	"base":
		{"dir":"P","cards":[
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-2,"types":[],"rolling":false},
			{"value":+2,"types":[],"rolling":false},
			{"value":false,"types":[],"rolling":false},
			{"value":true,"types":[],"rolling":false}
		]},
	"Brute":
		{"dir":"P","cards":[
			{"value":+0,"types":["pierce_3"],"rolling":true},
			{"value":+0,"types":["stun"],"rolling":true},
			{"value":+0,"types":[],"rolling":true},
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+0,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":+1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-1,"types":[],"rolling":false},
			{"value":-2,"types":[],"rolling":false},
			{"value":+2,"types":[],"rolling":false},
			{"value":false,"types":[],"rolling":false},
			{"value":true,"types":[],"rolling":false}
		]},
	"Cragheart":
		{"dir":"CH","cards":18},
	"Mindthief":
		{"dir":"MT","cards":20},
	"Scoundrel":
		{"dir":"SC","cards":17},
	"Spellweaver":
		{"dir":"SW","cards":18},
	"Tinkerer":
		{"dir":"TI","cards":16}
	}

var activeClass = ""

func _ready():
	
	for className in classes:
		
		var btnClass = Button.new()
		btnClass.name = className
		btnClass.text = className
		btnClass.size_flags_horizontal = SIZE_EXPAND_FILL
		btnClass.connect("button_down",self,"makeClassActive",[className])
		$hboxClasses.add_child(btnClass)


func makeClassActive(className):
	
	activeClass = className
	
	updateButtonUI()

func updateButtonUI():
	
	for btnClass in $hboxClasses.get_children():
		
		if btnClass.name == activeClass:
			btnClass.modulate = activeColor
		else:
			btnClass.modulate = Color.white

func generateBaseDeck():
	
	# Delete all base cards
	get_tree().call_group("deckCard","queue_free")
	
	for ID in range(1,20+1):
		
		var strID = "0"+str(ID) if str(ID).length() == 1 else str(ID)
		
		var texCard = texCard_tscn.instance()
		texCard.name = "base"+strID
		texCard.texture = load("res://attack-modifiers/base/player/am-p-"+strID+".png")
		texCard.get_node("btnCard").connect("pressed",self,"cardPressed",[texCard,"base"])
		texCard.add_to_group("baseCard")
		texCard.add_to_group("deckCard")
		$contDeck/gridDeck.add_child(texCard)

func generateClassDeck():
	
	# Delete all base cards
	get_tree().call_group("classCard","queue_free")
	
	# Check we have a class selected
	if activeClass == "":
		return
	
	for ID in range(1,classes[activeClass].cards+1):
		
		var strID = "0"+str(ID) if str(ID).length() == 1 else str(ID)
		
		var texCard = texCard_tscn.instance()
		var classCode: String = classes[activeClass].dir
		texCard.name = classCode+strID
		texCard.texture = load("res://attack-modifiers/"+classCode+"/am-"+classCode.to_lower()+"-"+strID+".png")
		texCard.get_node("btnCard").connect("pressed",self,"cardPressed",[texCard,"class"])
		texCard.add_to_group("baseCard")
		texCard.add_to_group("deckCard")
		$contClass/gridClass.add_child(texCard)

func cardPressed(btnCard,type):
	
	if type == "base":
		
		btnCard.queue_free()
		
	elif type == "class":
		
		var new_btnCard = btnCard.duplicate(true)
		btnCard.queue_free()
		$contDeck/gridDeck.add_child(new_btnCard)

func _on_btnReset_pressed():
	generateBaseDeck()
	generateClassDeck()

func _on_btnFormat_pressed():
	get_tree().change_scene("res://Format.tscn")
