# A simple wrapper for some functions not available in webgl

class_name JSUtil

static func save_file(data: PackedByteArray, mime: String = "application/octet-stream"):
    JavaScriptBridge.download_buffer(data, "data", mime)
    

static func load_file(callback: Callable):
    var on_filereader = JavaScriptBridge.create_callback(func(args):
        callback.call(args[0].target.result))
        
    var on_input = JavaScriptBridge.create_callback(func(args):
        var reader = JavaScriptBridge.create_object("FileReader")
        reader.onload = on_filereader
        reader.readAsBinaryString(args[0].target.files[0], "UTF-8"))
        
    var document = JavaScriptBridge.get_interface("document")
    var input = document.createElement("input")
    input.type = "file"
    input.onchange = on_input
    input.click()
    
    return [input, on_filereader, on_input]
    

var load_file_callback: Callable

var _on_load_file_input = JavaScriptBridge.create_callback(_on_load_file_input_callback)
    
func _on_load_file_input_callback(args):
    var reader = JavaScriptBridge.create_object("FileReader")
    reader.onload = _on_load_file_filereader
    reader.readAsBinaryString(args[0].target.files[0], "UTF-8")
    
var _on_load_file_filereader = JavaScriptBridge.create_callback(_on_load_file_filereader_callback)
    
func _on_load_file_filereader_callback(args):
    load_file_callback.call(args[0].target.result)
