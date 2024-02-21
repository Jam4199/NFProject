extends Node2D
class_name EnemyState

signal state_change(next_state : EnemyState)

var unit : Area2D

func state_allow()->bool:
	return true

func state_enter():
	return

func state_exit():
	return

func state_input(state_input : String):
	return

func state_process(delta : float):
	return

