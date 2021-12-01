extends Node

var _tts: TextToSpeech = null

func _ready():
	_tts = TextToSpeech.new()
	
func _process(dt: float):
	if Input.is_action_just_pressed("p_select"):
		print("OK")
		_tts.speak("こんにちは！", "ja-JP")
