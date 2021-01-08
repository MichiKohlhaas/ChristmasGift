extends Node

var _context = null

func change_scene(target_scene: String, context = null):
	set_context(context)
# warning-ignore:return_value_discarded
	get_tree().change_scene(target_scene)
	
func set_context(context):
	if _context != null and _context.has(context):
		_context.erase(context)
	else:
		_context = context

func get_context(context_name: String):
	if _context != null and _context.has(context_name):
		return _context[context_name]
	return null
