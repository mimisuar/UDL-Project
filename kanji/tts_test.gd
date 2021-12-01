extends Node2D

var _tts: TextToSpeech = null

func _ready():
	_tts = TextToSpeech.new()
	add_child(_tts)
	
func _input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		# everything should be ready at this point. 
		if not OS.has_feature("JavaScript"):
			return 
			
		_tts.speak("ちょっとまって", "ja-JP")
		
