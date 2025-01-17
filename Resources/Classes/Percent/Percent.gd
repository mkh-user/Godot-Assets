class_name percent
extends Resource

## Dedicated class for storing percentage items
##
## This class provides the ability to create, maintain, and work with percentage variables.
## It also has the ability to go above one hundred and below 0, but it is recommended to use values ​
## between 0 and 100. To fix the value in this range, use [method fix_value].
## [br] for create a new percent variable use:
## [codeblock lang=gdscript]
## var new_percent = percent.new(value, allow_less_and_greater)
## [/codeblock]

var _value: float

const _TYPES := [
	"null",
	"bool",
	"int",
	"float",
	"String",
	"Vector2",
	"Vector2i",
	"Rect2",
	"Rect2i",
	"Vector3",
	"Vector3i",
	"Transform2D",
	"Vector4",
	"Vector4i",
	"Plane",
	"Quaternion",
	"AABB",
	"Basis",
	"Transform3D",
	"Projection",
	"Color",
	"StringName",
	"NodePath",
	"RID",
	"Object",
	"Callable",
	"Signal",
	"Dictionary",
	"Array",
	"PackedByteArray",
	"PackedInt32Array",
	"PackedInt64Array",
	"PackedFloat32Array",
	"PackedFloat64Array",
	"PackedStringArray",
	"PackedVector2Array",
	"PackedVector3Array",
	"PackedColorArray",
	"PackedVector4Array",
	"invalid",
]

## This function is the constructor of this class, to call it use [code]percent.new()[/code].
func _init(from: Variant = 0, auto_fix: bool = true):
	match typeof(from):
		TYPE_INT,TYPE_FLOAT:
			_value = from
		TYPE_NIL:
			_value = 0
		TYPE_STRING,TYPE_STRING_NAME:
			_value = float(from)
		_:
			if from is percent:
				_value = from.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("Create new percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, created from {type}. value automaticly seted to 0%.".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(from)]}))
				_value = 0
	if auto_fix:
		fix_value()

## Modifies the value to be between 0 and 100.
func fix_value():
	if _value < 0:
		_value = 0
	elif _value > 100:
		_value = 100

## Returns the percentage with % as a String.
func get_percent() -> String:
	return str(_value) + "%"

## Returns the percentage value as a float.
func get_value() -> float:
	return _value

## Returns a percentage value as a ratio (optimal for calculations).
## For percentages between 0 and 100, the result will be between 0 and 1.
func get_raito() -> float:
	return _value / 100.0

## It assigns a new value to the object, supports int, float, null (0), String and StringName. For other types it does not change the value and prints an error to the console indicating where this function was called and the incorrect type.
func set_value(to: Variant, auto_fix: bool = true) -> void:
	match typeof(to):
		TYPE_INT,TYPE_FLOAT:
			_value = to
		TYPE_NIL:
			_value = 0
		TYPE_STRING,TYPE_STRING_NAME:
			_value = float(to)
		_:
			if to is percent:
				_value = to.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("Set value to percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. changes has no effect!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(to)]}))
	if auto_fix:
		fix_value()

##It is an operator ([code]==[/code]).
## It checks whether the percentage value is equal to the value inside the parentheses, the supported types and error will be the same as [method set_value].
func equal(with: Variant) -> bool:
	var returns = false
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			return _value == with
		TYPE_NIL:
			return _value == 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)
			return _value == with
		_:
			if with is percent:
				return _value == with.get_value()
			else:
				var last_call_stack = get_stack()[1]
				if last_call_stack["function"] in ["not_equal", "less_equal"]:
					last_call_stack = get_stack()[2]
					if last_call_stack["function"] in ["not_equal"]:
						returns = true
				if last_call_stack["function"] in ["greater"]:
					last_call_stack = get_stack()[3]
					if last_call_stack["function"] in ["greater"]:
						returns = true
				printerr("Check \"equal\", \"not_equal\", \"less_equal\" and \"greater\" with percent object sould be with percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, check with {type}. returns {return}.".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(with)], "return": returns}))
	return false

## It is an operator ([code]!=[/code]).
## It checks whether the percentage value is equal to the value inside the parentheses, the supported types and error will be the same as [method set_value].
func not_equal(with: Variant) -> bool:
	return !equal(with)

## It is an operator ([code]<[/code]).
## It checks if the percentage value is less than the value in parentheses, the supported types and error will be the same as [method set_value].
func less(than: Variant) -> bool:
	var returns = false
	match typeof(than):
		TYPE_INT,TYPE_FLOAT:
			return _value < than
		TYPE_NIL:
			return false
		TYPE_STRING,TYPE_STRING_NAME:
			than = float(than)
			return _value < than
		_:
			if than is percent:
				return _value < than.get_value()
			else:
				var last_call_stack = get_stack()[1]
				if last_call_stack["function"] in ["less_equal", "greater_equal"]:
					last_call_stack = get_stack()[2]
					if last_call_stack["function"] in ["greater_equal"]:
						returns = true
				if last_call_stack["function"] in ["greater"]:
					last_call_stack = get_stack()[3]
					if last_call_stack["function"] in ["greater"]:
						returns = true
				printerr("Check \"less\" and \"less_equal\" in percent object sould be than percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, check than {type}. returns {return}.".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(than)], "return": returns}))
	return false

## It is an operator ([code]<=[/code]).
## It checks whether the percentage value is less than or equal to the value in the parentheses. The supported types and error will be the same as [method set_value].
func less_equal(than: Variant) -> bool:
	return self.less(than) or self.equal(than)

## It is an operator ([code]>[/code]).
## It checks whether the percentage value is greater than the value in parentheses, the supported types and error will be the same as [method set_value].
func greater(than: Variant) -> bool:
	return not self.less_equal(than)

## It is an operator ([code]>=[/code]).
## It checks whether the percentage value is greater than or equal to the value in parentheses. The supported types and errors will be the same as [method set_value].
func greater_equal(than: Variant) -> bool:
	return not self.less(than)

## It is an operator ([code]+=[/code]).
## Adds the value in parentheses to the percentage value and places it in percentage, supported types and error will be the same as [method set_value].
func set_add(with: Variant) -> void:
	self.set_value(self.add(with))

## It is an operator ([code]-=[/code]).
## Subtracts the value in parentheses from the percentage value and places it in percentage, supported types and error will be the same as [method set_value].
func set_subtrack(with: Variant) -> void:
	self.set_value(self.subtrack(with))

## It is an operator ([code]*=[/code]).
## Multiplies the value in parentheses by the percentage value and places it in percentage, supported types and error will be the same as [method set_value].
func set_multiply(with: Variant) -> void:
	self.set_value(self.multiply(with))

## It is an operator ([code]/=[/code]).
## Divides the percentage value by the value in parentheses and places it in percentage, supported types and error will be the same as [method set_value].
func set_divide(with: Variant) -> void:
	self.set_value(self.divide(with))

## It is an operator ([code]+[/code]).
## It adds the percentage value to the value in parentheses and returns it (it does not affect the percentage object itself). Supported types and errors will be the same as [method set_value].
func add(with: Variant) -> percent:
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			with = 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)
		_:
			if with is percent:
				with = with.get_value()
			else:
				var last_call_stack = get_stack()[1]
				if last_call_stack["function"] in ["subtrack", "set_add", "set_subtrack"]:
					last_call_stack = get_stack()[2]
				if last_call_stack["function"] in ["set_subtrack"]:
					last_call_stack = get_stack()[3]
				printerr("\"add\", \"subtract\", \"set_add\" and \"set_subtrack\" value with percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. returns self value!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(with)]}))
				with = 0
	var new_value = _value + with
	if new_value < 0:
		new_value == 0
	elif new_value > 100:
		new_value == 100
	return percent.new(new_value)

## It is an operator ([code]-[/code]).
## It subtracts the value in parentheses from the percentage and returns it (it does not affect the percentage object itself), the supported types and error will be the same as [method set_value].
func subtrack(with: Variant) -> percent:
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			with *= -1
		TYPE_NIL:
			with = 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)*-1
		_:
			if with is percent:
				with = with.get_value() * -1
	return self.add(with)

## It is an operator ([code]*[/code]).
## It multiplies the value in the parentheses by a percentage and returns it (it does not affect the percentage object itself), the supported types and error will be the same as [method set_value].
func multiply(with: Variant) -> percent:
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			with = 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)
		_:
			if with is percent:
				with = with.get_value()
			else:
				var last_call_stack = get_stack()[1]
				if last_call_stack["function"] in ["set_multiply"]:
					last_call_stack = get_stack()[2]
				printerr("\"multiply\" and \"set_multiply\" value with percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. returns self value!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(with)]}))
				with = 1
	var new_value = _value * with
	if new_value < 0:
		new_value == 0
	elif new_value > 100:
		new_value == 100
	return percent.new(new_value)

## It is an operator ([code]/[/code]).
## It divides the percentage value by the value inside the parentheses and returns it (it does not affect the percentage object itself). Supported types and errors will be the same as [method set_value].
func divide(with: Variant) -> percent:
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			with = 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)
		_:
			if with is percent:
				with = with.get_value()
			else:
				var last_call_stack = get_stack()[1]
				if last_call_stack["function"] in ["set_divide"]:
					last_call_stack = get_stack()[2]
				printerr("\"divide\" and \"set_divide\" value with percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. returns self value!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(with)]}))
				with = 1
	var new_value = _value / with
	if new_value < 0:
		new_value == 0
	elif new_value > 100:
		new_value == 100
	return percent.new(new_value)

## It is an operator ([code]%[/code]).
## It divides the percentage of the intra -parenthesis and returns the remainder of the division (the object itself has no effect), the supported and erro type will be [method set_value].
func remainder(with: Variant) -> percent:
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			with = 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)
		_:
			if with is percent:
				with = with.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("get \"riminder\" value with percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. returns self value!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(with)]}))
				with = 1
	var new_value = _value % with
	if new_value < 0:
		new_value == 0
	elif new_value > 100:
		new_value == 100
	return percent.new(new_value)

## It is an operator ([code]**[/code]).
## It raises the percentage value to the power of the number in the parentheses and returns it (it does not affect the percentage object itself). Supported types and errors will be the same as [method set_value].
func power(with: Variant) -> percent:
	match typeof(with):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			with = 0
		TYPE_STRING,TYPE_STRING_NAME:
			with = float(with)
		_:
			if with is percent:
				with = with.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"power\" value for percent object sould be from percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. returns self value!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(with)]}))
				with = 1
	var new_value = _value ** with
	if new_value < 0:
		new_value == 0
	elif new_value > 100:
		new_value == 100
	return percent.new(new_value)

## Returns the current percentage remaining out of a hundred (has no effect on the percentage object itself), supported types and errors will be the same as [method set_value].
func get_empty_percent() -> percent:
	return percent.new(100 - _value)

## Converts the percentage to an integer.
func convert_to_int() -> int:
	return int(self.get_value())

## Converts the percentage to a float.
func convert_to_float() -> float:
	return self.get_value()

## Converts the percentage to a string.
func conver_to_string(include_percent_symbol: bool = false):
	if include_percent_symbol:
		return self.get_percent()
	else:
		return str(self.get_value())

## Returns a specified [param percentage] from the [param from].
static func calculate_x_percent_from(percentage: Variant, from: Variant) -> float:
	match typeof(from):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			from = 0
		TYPE_STRING,TYPE_STRING_NAME:
			from = float(from)
		_:
			if from is percent:
				from = from.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"calculate_x_percent_from\" parameter from should be percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. set from to 0!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(from)]}))
				from = 0
	match typeof(percentage):
		TYPE_INT,TYPE_FLOAT:
			percentage = percent.new(percentage, false)
		TYPE_NIL:
			percentage = percent.new(0, false)
		TYPE_STRING,TYPE_STRING_NAME:
			percentage = percent.new(percentage, false)
		_:
			if percentage is percent:
				pass
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"calculate_x_percent_from\" parameter percentage should be percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. set persentage to 0!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(from)]}))
				percentage = percent.new(0, false)
	return from * percentage.get_value() / 100.0

## Converts a fraction to a percentage.
static func calculate_percent(numerator: Variant, denominator: Variant) -> percent: 
	match typeof(numerator):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			numerator = 0
		TYPE_STRING,TYPE_STRING_NAME:
			numerator = float(numerator)
		_:
			if numerator is percent:
				numerator = numerator.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"calculate_percent\" parameter numerator should be percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. set numerator to 0!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(numerator)]}))
				numerator = 0
	match typeof(denominator):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			denominator = 0
		TYPE_STRING,TYPE_STRING_NAME:
			denominator = float(denominator)
		_:
			if denominator is percent:
				denominator = denominator.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"calculate_percent\" parameter denominator should be percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. set denominator to 0!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(denominator)]}))
				denominator = 0
	if denominator == 0:
		var last_call_stack = get_stack()[1]
		printerr("\"calculate_percent\" parameter denominator should be not 0! but in {source} > {function} > line {line}, set from {type}. return 0%!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(denominator)]}))
		return percent.new(0)
	return percent.new(float(numerator)/float(denominator)*100, false)

## Returns the percentage change from the [param from] value to the [param to] value, can be outside the range of 0 to 100 (including negative).
static func calculate_change_percent(from: Variant, to: Variant) -> percent:
	match typeof(from):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			from = 0
		TYPE_STRING,TYPE_STRING_NAME:
			from = float(from)
		_:
			if from is percent:
				from = from.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"calculate_change_percent\" parameter from should be percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. set from to 0!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(from)]}))
				from = 0
	match typeof(to):
		TYPE_INT,TYPE_FLOAT:
			pass
		TYPE_NIL:
			to = 0
		TYPE_STRING,TYPE_STRING_NAME:
			to = float(to)
		_:
			if to is percent:
				to = to.get_value()
			else:
				var last_call_stack = get_stack()[1]
				printerr("\"calculate_change_percent\" parameter to should be percent, int, float, null, String or StringName! but in {source} > {function} > line {line}, set from {type}. set from to 0!".format({"source": last_call_stack["source"], "function": last_call_stack["function"], "line": last_call_stack["line"], "type": _TYPES[typeof(from)]}))
				to = 0
	var changes = from - to
	return calculate_percent(changes, from)

# internal converters
func _to_string() -> String:
	return self.get_value()
