extends Control

var classes = ["BR","CH","MT","SC","SW","TI"]
var classPos = -1

var classConv = {
	"BR":"Brute",
	"CH":"Cragheart",
	"MT":"Mindthief",
	"SC":"Scoundrel",
	"SW":"Spellweaver",
	"TI":"Tinkerer"
	}

var classesData = {
	"Brute":
		{"dir":"BR","cards":[]},
	"Cragheart":
		{"dir":"CH","cards":[]},
	"Mindthief":
		{"dir":"MT","cards":[]},
	"Scoundrel":
		{"dir":"SC","cards":[]},
	"Spellweaver":
		{"dir":"SW","cards":[]},
	"Tinkerer":
		{"dir":"TI","cards":[]}
	}

var dir = Directory.new()

func _ready():
	setupNextClass()

func setupNextClass():
	classPos += 1
	if classPos == classes.size():
		saveMetaData()
		var _ERROR_CODE = get_tree().change_scene("res://Main.tscn")
		return
	var classCode:String = classes[classPos]
	dir.open("res://attack-modifiers/"+classCode+"/")
	dir.list_dir_begin(true)
	setupNextCard()

func setupNextCard():
	
	var imageName = dir.get_next()
	if imageName == "":
		setupNextClass()
		imageName = dir.get_next()
	$contTexture/texCard.texture = load(dir.get_current_dir()+"/"+imageName)
	dir.get_next()
	resetButtons()

func resetButtons():
	
	$hboxOptions/contValue/SpinBox.value = 0
	$hboxOptions/contCritOrMiss/vbox/btnCrit.pressed = false
	$hboxOptions/contCritOrMiss/vbox/btnMiss.pressed = false
	$hboxOptions/contRolling/checkCrit.pressed = false
	for btnType in $hboxOptions/contTypes/gridTypes.get_children():
		btnType.pressed = false
	for btnType in $hboxOptions/contElements/gridElements.get_children():
		btnType.pressed = false

func _on_btnFormat_pressed():
	addDataToDictionary()
	setupNextCard()

func addDataToDictionary():
	
	var data:Dictionary = {}
	# Image path
	data["imagePath"] = $contTexture/texCard.texture.resource_path
	# Value
	if $hboxOptions/contCritOrMiss/vbox/btnCrit.pressed:
		data["value"] = true
	elif $hboxOptions/contCritOrMiss/vbox/btnMiss.pressed:
		data["value"] = false
	else:
		data["value"] = $hboxOptions/contValue/SpinBox.value
	# Rolling
	data["rolling"] = $hboxOptions/contRolling/checkCrit.pressed
	# Types
	data["types"] = []
	for btnType in $hboxOptions/contTypes/gridTypes.get_children():
		if btnType.pressed:
			data["types"].append(btnType.name.right(3))
	# Elements
	data["elements"] = []
	for btnElement in $hboxOptions/contElements/gridElements.get_children():
		if btnElement.pressed:
			data["types"].append(btnElement.name.right(3))
	
	print(classConv[classes[classPos]]," ",data)
	
	classesData[classConv[classes[classPos]]].cards.append(data)

func saveMetaData():
	var saveData = classesData
	var saveFile = File.new()
	saveFile.open("user://card_data.save", File.WRITE)
	saveFile.store_line(to_json(saveData))
	saveFile.close() 



