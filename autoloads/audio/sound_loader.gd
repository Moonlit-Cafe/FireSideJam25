class_name SoundLoader

# How setup work is within _list you preload the sound so it's an AudioStream

func load_audio() -> void:
	load_ost()
	load_sfx()
	load_ui()
	load_ambient()

func load_ost() -> void:
	# Add OST loads here
	var song_list : Dictionary[int, Array] = {
		0: [preload("res://assets/audio/ost/craft.wav"), 64.8],
		1: [preload("res://assets/audio/ost/dToN.wav"), -1],
		2: [preload("res://assets/audio/ost/menu.wav"), 76.8],
		3: [preload("res://assets/audio/ost/newItem.wav"), -1],
		4: [preload("res://assets/audio/ost/nToD.wav"), -1],
		5: [preload("res://assets/audio/ost/oldRec.wav"), -1],
		6: [preload("res://assets/audio/ost/overworld.wav"), 169.412],
		7: [preload("res://assets/audio/ost/requestDone.wav"), -1],
		8: [preload("res://assets/audio/ost/shop.wav"), 79.059],
		9: [preload("res://assets/audio/ost/town.wav"), 136.0]
	}
	
	for song in song_list.values():
		song.get(0).resource_name = grab_name(song.get(0).resource_path)
		MusicManager.add_ost(song.get(0), song.get(1))

func load_sfx() -> void:
	# Add SFX loads here
	var sfx_list : Array[AudioStream] = [
		preload("res://assets/audio/sfx/stepG/step1.wav"),
		preload("res://assets/audio/sfx/stepG/step2.wav"),
		preload("res://assets/audio/sfx/stepG/step3.wav"),
		preload("res://assets/audio/sfx/stepG/step4.wav"),
		preload("res://assets/audio/sfx/stepG/step5.wav"),
		preload("res://assets/audio/sfx/stepG/step6.wav"),
		preload("res://assets/audio/sfx/stepG/step7.wav"),
		preload("res://assets/audio/sfx/stepG/step8.wav"),
		preload("res://assets/audio/sfx/stepG/step9.wav"),
		preload("res://assets/audio/sfx/stepG/step10.wav"),
		preload("res://assets/audio/sfx/stepG/step11.wav"),
		preload("res://assets/audio/sfx/door.wav"),
		preload("res://assets/audio/sfx/menuBack.wav"),
		preload("res://assets/audio/sfx/menuConfirm.wav"),
		preload("res://assets/audio/sfx/menuCycle.wav"),
		preload("res://assets/audio/sfx/money.wav"),
		preload("res://assets/audio/sfx/requestSelect.wav"),
	]
	
	for sfx in sfx_list:
		sfx.resource_name = grab_name(sfx.resource_path)
		SoundManager.add_sound(sfx)

func load_ui() -> void:
	# Add UI loads here
	var ui_list : Array[AudioStream] = []
	
	for ui in ui_list:
		ui.resource_name = grab_name(ui.resource_path)
		SoundManager.add_sound(ui)

func load_ambient() -> void:
	# Add Ambient loads here
	var ambient_list : Array[AudioStream] = []
	
	for ambient in ambient_list:
		ambient.resource_name = grab_name(ambient.resource_path)
		SoundManager.add_sound(ambient)

func grab_name(path: String) -> String:
	return path.split("/")[path.split("/").size() - 1].split(".")[0]
