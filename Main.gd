extends Node

export (PackedScene) var Img

var ImageList
var images = PoolStringArray()
var images_done = []

var options = Options.new()

var reps = 0

var image_loading_queue = []

func _ready():
	resize()
	get_tree().connect("files_dropped", self, "_on_files_dropped")
	get_tree().get_root().connect("size_changed", self, "resize")
	$ImageLoading.visible = false
	$Viewer.visible = false
	$Settings.visible = false
	$Preview.visible = false
	if ResourceLoader.exists('user://last_options.res'):
		options = ResourceLoader.load('user://last_options.res')
		if options is Options:
			load_options()

func _process(delta):
	if Input.is_action_just_pressed("back"):
		close_viewer()

func load_options():
	$FileDialog.current_dir = options.current_dir
	print(options.current_dir)
	$Viewer/Shown.wait_time = options.shown
	$Viewer/Inbetween.wait_time = options.in_between
	$Settings/MarginContainer/VBoxContainer/RandomOrder.pressed = options.order_random
	$Settings/MarginContainer/VBoxContainer/ToneRep.pressed = options.play_tone
	$Settings/MarginContainer/VBoxContainer/HBoxContainer/Shown.text = str(options.shown)
	$Settings/MarginContainer/VBoxContainer/HBoxContainer2/Inbetween.text = str(options.in_between)
	$Settings/MarginContainer/VBoxContainer/HBoxContainer3/Reps.text = str(options.max_reps)

func save_options():
	ResourceSaver.save('user://last_options.res', options)

func resize():
	if $Viewer.get_node("ImageContainer/Image"):
		$Viewer.get_node("ImageContainer/Image").set_size($MarginContainer.rect_size)
	if $Preview/ColorRect.get_node("ImageContainer/Image"):
		$Preview/ColorRect.get_node("ImageContainer/Image").set_size($MarginContainer.rect_size)

func _on_files_dropped(paths, screen):
	$ImageLoading.visible = true
	$ImageLoading.bar.max_value = paths.size()
	$ImageLoading.bar.value = 0
	$MarginContainer/VBoxContainer/ScrollContainer/DragDrop.visible = false
	image_loading_queue.append_array(paths)
	$Load.start()

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
	options.current_dir = $FileDialog.current_dir
	save_options()
	$ImageLoading.visible = true
	$ImageLoading.bar.max_value = paths.size()
	$ImageLoading.bar.value = 0
	image_loading_queue.append_array(paths)
	$MarginContainer/VBoxContainer/ScrollContainer/DragDrop.visible = false
	$Load.start()

func _on_FileDialog_file_selected(path):
	options.current_dir = $FileDialog.current_dir
	save_options()
	$ImageLoading.visible = true
	$ImageLoading.bar.max_value = 1
	$ImageLoading.bar.value = 0
	image_loading_queue.append(path)
	$MarginContainer/VBoxContainer/ScrollContainer/DragDrop.visible = false
	$Load.start()

func _on_ImageList_ready():
	ImageList = $MarginContainer/VBoxContainer/ScrollContainer/ImageList

func _on_Settings_button_up():
	$Settings.visible = true

func _on_SettingsBack_button_up():
	save_options()
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
	if options.order_random:
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
	dupe.is_dupe = true
	dupe.set_position(Vector2(0, 0))
	dupe.set_size($MarginContainer.rect_size)
	if options.play_tone:
		$ImageTone.play()
	$Viewer/ImageContainer.add_child(dupe)
	if reps != options.max_reps:
		reps += 1
		$Viewer/Shown.start()
	else:
		$Viewer.visible = false

func _on_Shown_text_changed(new_text):
	options.shown = int(new_text)
	$Viewer/Shown.wait_time = int(new_text)

func _on_Inbetween_text_changed(new_text):
	options.in_between = int(new_text)
	$Viewer/Inbetween.wait_time = int(new_text)

func _on_Reps_text_changed(new_text):
	options.max_reps = int(new_text)

func _on_StartPractice_button_up():
	if options.max_reps < 1:
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

func _on_Stop_button_up():
	close_viewer()

func _on_PlayPause_toggled(pause):
	if pause:
		$Viewer/Shown.paused = true
		$Viewer/Inbetween.paused = true
	else:
		$Viewer/Shown.paused = false
		$Viewer/Inbetween.paused = false

func _on_ToneRep_toggled(play):
	options.play_tone = play

func _on_RandomOrder_toggled(order):
	options.order_random = order

func _on_StopPreview_button_up():
	if $Preview.get_node("ColorRect/ImageContainer/Image"):
		$Preview.get_node("ColorRect/ImageContainer/Image").queue_free()
	$Preview.visible = false

func _on_ImageList_preview_image(image):
	if $Preview.get_node("ColorRect/ImageContainer/Image"):
		$Preview.get_node("ColorRect/ImageContainer/Image").queue_free()
	var dupe = image.duplicate()
	dupe.name = "Image"
	dupe.is_dupe = true
	dupe.set_position(Vector2(0, 0))
	dupe.set_size($MarginContainer.rect_size)
	$Preview/ColorRect/ImageContainer.add_child(dupe)
	$Preview.visible = true
