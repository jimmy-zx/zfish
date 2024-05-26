extends Node2D


var root: Node = null
var last_path: String = ""
var _jsutil_input

func _ready():
    if OS.get_name() != "Web":
        get_viewport().set_embedding_subwindows(false)
    $Builder/MenuBar/File.get_popup().id_pressed.connect(_on_file_id_pressed)
    $Builder/MenuBar/Edit.get_popup().id_pressed.connect(_on_edit_id_pressed)


func _input(event: InputEvent):
    if event.is_action_pressed("config_new"):
        _on_file_id_pressed(2)
    elif event.is_action_pressed("config_save"):
        _on_file_id_pressed(1)
    elif event.is_action_pressed("config_open"):
        _on_file_id_pressed(0)
    elif event.is_action_pressed("config_builder"):
        _on_edit_id_pressed(0)
    elif event.is_action_pressed("config_run"):
        _on_edit_id_pressed(1)
        
func _add_root():
    add_child(root)
    move_child(root, 0)
        

func _on_edit_id_pressed(id: int):
    match id:
        0:  # Builder
            $Builder/MenuBar/Edit.get_popup().toggle_item_checked(id)
            if root != null:
                root.get_node("Builder").visible = $Builder/MenuBar/Edit.get_popup().is_item_checked(id)
        1:  # Run
            if root != null:
                root.run()
        
            
func _on_file_id_pressed(id: int):
    match id:
        0:  # Open
            if OS.get_name() == "Web":
                _jsutil_input = JSUtil.load_file(load_string)
            else:
                $Builder/OpenDialog.visible = true
        1:  # Save
            if root == null:
                $Builder/Message.text = "No data to save"
                return
            if OS.get_name() == "Web":
                JSUtil.save_file(get_data().to_utf8_buffer(), "application/json")
            else:
                $Builder/SaveDialog.visible = true
        2:  # New
            if root != null:
                root.queue_free()
            var cls = load("res://modules/stage/stage_builder.tscn")
            root = cls.instantiate()
            root.get_node("Builder").visible = $Builder/MenuBar/Edit.get_popup().is_item_checked(0)
            _add_root()
        3:  # Reload
            if root == null:
                return
            var data = root.get_data()
            root.queue_free()
            var cls = load("res://modules/stage/stage_builder.tscn")
            root = cls.instantiate()
            root.get_node("Builder").visible = $Builder/MenuBar/Edit.get_popup().is_item_checked(0)
            _add_root()
            root.set_data(data)
        5:  # Open user dir
            OS.shell_open(ProjectSettings.globalize_path("user://"))


func _on_open_dialog_file_selected(path: String):
    if root != null:
        root.queue_free()
    load_string(FileAccess.get_file_as_string(path))
    last_path = path


func _on_save_dialog_file_selected(path: String):
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_string(get_data())
    file.close()


func load_string(data):
    load_data(JSON.parse_string(data))
    

func get_data():
    return JSON.stringify({
        "zfish": "02",
        "path": "res://modules/stage/stage_builder.tscn",
        "data": root.get_data(),
    }, "    ", false, false)
    

func load_data(data):
    if data == null:
        $Builder/Message.text = "Invalid JSON file"
        return
    if typeof(data) != TYPE_DICTIONARY:
        $Builder/Message.text = "Invalid data type: should be a dictionary"
        return
    if !data.has("zfish") or data["zfish"] != "02":
        $Builder/Message.text = "Invalid header"
    var packed_scene: PackedScene = load(data["path"])
    root = packed_scene.instantiate()
    root.set_data(data["data"])
    root.get_node("Builder").visible = $Builder/MenuBar/Edit.get_popup().is_item_checked(0)
    _add_root()

