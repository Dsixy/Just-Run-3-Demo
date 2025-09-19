class_name Spell extends Node2D

var spellName: String
var iconIdx: int
var description: String

var castTime: float
var manaCost: int

var inputParams: Array
var filters: Array

class ParamFilter:
	var description: String
	var as_input: Callable
