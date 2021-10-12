extends Node

export (PackedScene) var Img

var ImageList
var images = PoolStringArray()
var images_done = []

var play_tone = false
var order_random = true

var max_reps = 20
var reps = 0

var image_loading_queue = []

func _ready():
	resize()
	get_tree().get_root().connect("size_changed", self, "resize")
	$ImageLoading.visible = false
	$Viewer.visible = false
	$Settings.visible = false

func _process(delta):
	if Input.is_action_just_pressed("back"):
		close_viewer()

func resize():
	if $Viewer.get_node("ImageContainer/Image"):
		$Viewer.get_node("ImageContainer/Image").set_size($MarginContainer.rect_size)

func _on_AddImage_button_up():
	$FileDialog.popup()

func load_image(path):
	var img = Image.new()
	var e = img.load(path)
	if e == 0:
		var tex = ImageTexture.new()
		tex.create_from_image(img)
		var img_node = Img.instance()
		img_node.texture = tex
		ImageList.add_child(img_node)
		
func _on_Load_timeout():
	if image_loading_queue.size() > 0:
		var img_path = image_loading_queue.pop_front()
		$ImageLoading.label.text = "Loading %s" % img_path
		load_image(img_path)
		$ImageLoading.bar.value += 1
		$Load.start()
	else:
		$ImageLoading/Close.start()

func _on_FileDialog_files_selected(paths):
	$ImageLoading.visible = true
	$ImageLoading.bar.max_value = paths.size()
	$ImageLoading.bar.value = 0
	image_loading_queue.append_array(paths)
	$Load.start()

func _on_FileDialog_file_selected(path):
	$ImageLoading.visible = true
	$ImageLoading.bar.max_value = 1
	$ImageLoading.bar.value = 0
	image_loading_queue.append(path)
	$Load.start()

func _on_ImageList_ready():
	ImageList = $MarginContainer/VBoxContainer/ScrollContainer/ImageList

func _on_Settings_button_up():
	$Settings.visible = true

func _on_SettingsBack_button_up():
	$Settings.visible = false

func _on_Clear_button_up():
	images.empty()
	for child in ImageList.get_children():
		child.queue_free()

func _on_Shown_timeout():
	if $Viewer.get_node("ImageContainer/Image"):
		$Viewer.get_node("ImageContainer/Image").queue_free()
	$Viewer/Inbetween.start()

func _on_Inbetween_timeout():
	var i = 0
	if order_random:
		i = randi() % ImageList.get_child_count()
		while images_done.has(i):
			i = randi() % ImageList.get_child_count()
	else:
		i = reps
	images_done.append(i)
	if $Viewer.get_node("ImageContainer/Image"):
		$Viewer.get_node("ImageContainer/Image").queue_free()
	var dupe = ImageList.get_child(i).duplicate()
	dupe.name = "Image"
	dupe.set_position(Vector2(0, 0))
	dupe.set_size($MarginContainer.rect_size)
	if play_tone:
		$ImageTone.play()
	$Viewer/ImageContainer.add_child(dupe)
	if reps != max_reps:
		reps += 1
		$Viewer/Shown.start()
	else:
		$Viewer.visible = false

func _on_Shown_text_changed(new_text):
	$Viewer/Shown.wait_time = int(new_text)

func _on_Inbetween_text_changed(new_text):
	$Viewer/Inbetween.wait_time = int(new_text)

func _on_Reps_text_changed(new_text):
	max_reps = int(new_text)

func _on_StartPractice_button_up():
	if max_reps < 1:
		return
	if ImageList.get_child_count() > 0:
		if $Viewer.get_node("ImageContainer/Image"):
			$Viewer.get_node("ImageContainer/Image").queue_free()
		reps = 0
		images_done = []
		$Viewer.visible = true
		$Viewer/Inbetween.start()

func close_viewer():
	if $Viewer.get_node("ImageContainer/Image"):
		$Viewer.get_node("ImageContainer/Image").queue_free()
	$Viewer/Shown.stop()
	$Viewer/Inbetween.stop()
	$Viewer.visible = false

func _on_Back_button_up():
	close_viewer()

func _on_PlayPause_toggled(pause):
	if pause:
		$Viewer/Shown.paused = true
		$Viewer/Inbetween.paused = true
	else:
		$Viewer/Shown.paused = false
		$Viewer/Inbetween.paused = false

func _on_ToneRep_toggled(play):
	play_tone = play

func _on_RandomOrder_toggled(order):
	order_random = order
