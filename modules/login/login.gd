extends Control

@onready var email: LineEdit = $Email
@onready var password: LineEdit = $Password
@onready var login_button: Button = $LoginButton
@onready var http: HTTPRequest = $Http

var isPasswordSetted
var isEmailSetted	

const REGISTER_SCENE = "res://modules/register/register.tscn"
const START_SCREEN = "res://modules/start_menu/start_menu.tscn"

func _ready() -> void:
	login_button.pressed.connect(_on_login_button_pressed)
	http.request_completed.connect(_on_request_completed)
	
func _process(delta: float) -> void:
	isPasswordSetted =  len(password.text) > 0
	isEmailSetted =  len(email.text) > 0
	
	login_button.disabled = not(isEmailSetted and isPasswordSetted)


func _on_login_button_pressed() -> void:
	var data = {
		"email": email.text,
		"password": password.text
	}
	http.make_request(data)


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_string = body.get_string_from_utf8()
	var response_json = JSON.parse_string(response_string)
	var dialog_text: String
	
	if response_json.has("message"):
		dialog_text = response_json.message
	elif response_json.has("detail") and response_json.detail.size() > 0:
		dialog_text = response_json.detail[0].ctx.reason
	else:
		dialog_text = 'Ha ocurrido un error, vuelve a intentarlo'
	
	Utils.show_dialog(dialog_text)
	
	if response_code == HTTPClient.RESPONSE_OK:
		success_login(response_json)
	

func success_login(response_json) -> void:
	var auth_token = response_json.data.auth_token
	var user = response_json.data.user
	
	StateManager.update_auth_token(auth_token)
	StateManager.update_user(user)
	StateManager.save_game()
	
	get_tree().change_scene_to_file(START_SCREEN)
	
func _on_register_pressed() -> void:
	await Utils.transition()
	get_tree().change_scene_to_file(REGISTER_SCENE)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(START_SCREEN)
